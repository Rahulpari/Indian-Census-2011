-- Understanding each dataset --
SELECT * FROM census.d1;
SELECT * FROM census.d2;
DESCRIBE census.d1;
DESCRIBE census.d2;

SELECT COUNT(*) FROM census.d1;
SELECT COUNT(district) FROM census.d1;
SELECT COUNT(DISTINCT district) FROM census.d1;
SELECT COUNT(*) FROM census.d2;
SELECT COUNT(district) FROM census.d2;
SELECT COUNT(DISTINCT district) FROM census.d2;

-- INVESTIGATING DUPLICATES IN census.d1 --
DROP TABLE IF EXISTS census.d1_new;
CREATE TABLE census.d1_new
	(SELECT *, 
			ROW_NUMBER() 
            OVER(PARTITION BY district
            ORDER BY district) AS dupp
FROM census.d1);

SELECT * FROM census.d1
WHERE district IN (SELECT district FROM census.d1_new
					WHERE dupp>1)
ORDER BY district;

DROP TABLE census.d1_new;

-- INVESTIGATING DUPLICATES IN census.d2 --
DROP TABLE IF EXISTS census.d2_new;
CREATE TABLE census.d2_new
	(SELECT *, 
			ROW_NUMBER() 
            OVER(PARTITION BY district
            ORDER BY district) AS dupp
FROM census.d2);

SELECT * FROM census.d2
WHERE district IN (SELECT district FROM census.d2_new
					WHERE dupp>1)
ORDER BY district;

DROP TABLE census.d2_new;

-- d1 + d2 = data WITH TYPE CASTING --
DROP TABLE IF EXISTS census.data;
CREATE TABLE census.data
(
SELECT 
	d2.district, 
	d2.state, 
    CAST(REPLACE(d1.Population,',','') AS UNSIGNED) AS Population, 
    CAST(REPLACE(d1.Area_km2,',','') AS UNSIGNED) AS Area, 
    CAST(REPLACE(d2.Growth,',','') AS DECIMAL(9,2)) AS  Growth, 
    d2.Literacy, 
    d2.Sex_Ratio
FROM census.d1 RIGHT JOIN census.d2
ON d1.district = d2.district AND d1.state = d2.state
ORDER BY state
);

SELECT * FROM census.data;
DESCRIBE census.data;

DELETE FROM census.data WHERE population IS NULL;

-- Update table with literacy_sex_growth data --
DROP PROCEDURE IF EXISTS drop_literacy_sex_growth_data;
DELIMITER //

CREATE PROCEDURE drop_literacy_sex_growth_data() BEGIN
IF EXISTS (SELECT * FROM information_schema.COLUMNS WHERE table_schema = 'census' AND COLUMN_NAME = 'Literate') 
THEN ALTER TABLE census.data DROP COLUMN Literate;
END IF;
 
IF EXISTS (SELECT * FROM information_schema.COLUMNS WHERE table_schema = 'census' AND COLUMN_NAME = 'Illiterate') 
THEN ALTER TABLE census.data DROP COLUMN Illiterate;
END IF;
 
IF EXISTS (SELECT * FROM information_schema.COLUMNS WHERE table_schema = 'census' AND COLUMN_NAME = 'Male') 
THEN ALTER TABLE census.data DROP COLUMN Male;
END IF;
 
IF EXISTS (SELECT * FROM information_schema.COLUMNS WHERE table_schema = 'census' AND COLUMN_NAME = 'Female') 
THEN ALTER TABLE census.data DROP COLUMN Female;
END IF;

IF EXISTS (SELECT * FROM information_schema.COLUMNS WHERE table_schema = 'census' AND COLUMN_NAME = 'Prev_Population') 
THEN ALTER TABLE census.data DROP COLUMN Prev_Population;
END IF;

ALTER TABLE census.data ADD COLUMN Literate INTEGER;
ALTER TABLE census.data ADD COLUMN Illiterate INTEGER;
ALTER TABLE census.data ADD COLUMN Male INTEGER;
ALTER TABLE census.data ADD COLUMN Female INTEGER;
ALTER TABLE census.data ADD COLUMN Prev_Population INTEGER;

END//
DELIMITER ;

CALL drop_literacy_sex_growth_data;

UPDATE census.data SET literate = literacy/100 * population;
UPDATE census.data SET illiterate = population - literate;
UPDATE census.data SET male = population/(1+sex_ratio/1000);
UPDATE census.data SET female = population - male;
UPDATE census.data SET Prev_Population = population/(1+growth/100);

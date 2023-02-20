-- Data Summary --
SELECT ROUND(MIN(Literacy),2), ROUND(MAX(Literacy),2), ROUND(AVG(Literacy),2) FROM census.data;
SELECT ROUND(MIN(Literate)), ROUND(MAX(Literate)), ROUND(AVG(Literate)) FROM census.data;
SELECT ROUND(MIN(Illiterate)), ROUND(MAX(Illiterate)), ROUND(AVG(Illiterate)) FROM census.data;

SELECT ROUND(MIN(Sex_Ratio)), ROUND(MAX(Sex_Ratio)), ROUND(AVG(Sex_Ratio)) FROM census.data;
SELECT ROUND(MIN(Male)), ROUND(MAX(Male)), ROUND(AVG(Male)) FROM census.data;
SELECT ROUND(MIN(Female)), ROUND(MAX(Female)), ROUND(AVG(Female)) FROM census.data;

SELECT ROUND(MIN(Growth),2), ROUND(MAX(Growth),2), ROUND(AVG(Growth),2) FROM census.data;
SELECT ROUND(MIN(Prev_Population)), ROUND(MAX(Prev_Population)), ROUND(AVG(Prev_Population)) FROM census.data;
SELECT ROUND(MIN(Population),2), ROUND(MAX(Population),2), ROUND(AVG(Population),2) FROM census.data;
SELECT ROUND(MIN(Area),2), ROUND(MAX(Area),2), ROUND(AVG(Area),2) FROM census.data;


-- INDIA's DEMOGRAPHICS --
SELECT
       ROUND(AVG(Literacy),2) AS Avg_Literacy_rate_India, 
       ROUND(SUM(Literate)/SUM(population)*100,2) AS Act_literacy_rate_India,
       ROUND(SUM(population),2) AS Tot_Pop_India,
       ROUND(AVG(literate)) AS Avg_Literate_India, 
       ROUND(AVG(illiterate)) AS Avg_Illiterate_India,
       
       ROUND(AVG(Sex_Ratio)) AS Avg_Sex_Ratio_India,
       ROUND(SUM(Female)/SUM(Male)*1000,2) AS Act_Sex_Ratio_India,
       ROUND(AVG(male)) AS Avg_Male_India,
	   ROUND(AVG(female)) AS Avg_Female_India, 
       
       ROUND(SUM(prev_population)) AS Tot_Prev_Pop_India,
       ROUND(SUM(Area),2) AS Tot_Area_India, 
       ROUND(SUM(population)/SUM(area),2) AS density_India,
       ROUND(SUM(prev_population)/SUM(area),2) AS Prev_density_India,
       ROUND(AVG(growth),2) AS Avg_growth_rate_India,
	   ROUND(((SUM(population)-SUM(prev_population))/SUM(prev_population))*100,2) AS Act_growth_rate_India
FROM census.data;

-- DEMOGRAPHICS BY STATE --
SELECT state, 
	   ROUND(AVG(Literacy),2) AS Avg_Literacy_rate, 
       ROUND(SUM(Literate)/SUM(population)*100,2) AS Act_literacy_rate,
       ROUND(SUM(population),2) AS Tot_Pop,
       ROUND(AVG(literate)) AS Avg_Literate, 
       ROUND(AVG(illiterate)) AS Avg_Illiterate,
       
       ROUND(AVG(Sex_Ratio)) AS Avg_Sex_Ratio,
       ROUND(SUM(Female)/SUM(Male)*1000,2) AS Act_Sex_Ratio,
       ROUND(AVG(male)) AS Avg_Male,
	   ROUND(AVG(female)) AS Avg_Female, 
       
       ROUND(SUM(prev_population)) AS Tot_Prev_Pop,
       ROUND(SUM(Area),2) AS Tot_Area, 
       ROUND(SUM(population)/SUM(area),2) AS density,
       ROUND(SUM(prev_population)/SUM(area),2) AS Prev_density,
       ROUND(AVG(growth),2) AS Avg_growth_rate,
	   ROUND(((SUM(population)-SUM(prev_population))/SUM(prev_population))*100,2) AS Act_growth_rate
FROM census.data
GROUP BY state
ORDER BY state;

-- TOP 3 state with highest & lowest Literate population --
(SELECT * FROM census.data
ORDER BY Literacy DESC
LIMIT 3)
UNION
(SELECT * FROM census.data
ORDER BY Literacy
LIMIT 3);

-- ============================================================
-- SQL PROJECT + SQLZOO-STYLE ANSWERS
-- ============================================================


-- ============================================================
-- Q1: Show the name and population of all countries.
-- (Basic SELECT, all rows)
-- ============================================================

SELECT
    name,
    population
FROM world;


-- ============================================================
-- Q2: Show the population of Germany.
-- (Filter by exact country name)
-- ============================================================

SELECT
    population
FROM world
WHERE name = 'Germany';


-- ============================================================
-- Q3: Show the name and population of countries in Europe.
-- (Filter by continent)
-- ============================================================

SELECT
    name,
    population
FROM world
WHERE continent = 'Europe';


-- ============================================================
-- Q4: Show the name and area of countries with area
--     between 200,000 and 250,000 km^2.
-- (BETWEEN on numeric range)
-- ============================================================

SELECT
    name,
    area
FROM world
WHERE area BETWEEN 200000 AND 250000;


-- ============================================================
-- Q5: Show the name and GDP per capita of countries with
--     population over 200 million.
-- (Computed column + WHERE filter)
-- ============================================================

SELECT
    name,
    (gdp / population::NUMERIC) AS gdp_per_capita
FROM world
WHERE population > 200000000;


-- ============================================================
-- Q6: Show the name and population (in millions, rounded to 1 dp)
--     of countries in South America.
-- (Rounding + aliasing)
-- ============================================================

SELECT
    name,
    ROUND(population / 1000000.0, 1) AS population_millions
FROM world
WHERE continent = 'South America';


-- ============================================================
-- Q7: Show the name and population density of all countries,
--     ordered from highest to lowest density.
-- Density = population / area
-- ============================================================

SELECT
    name,
    population,
    area,
    (population::NUMERIC / area) AS population_density
FROM world
WHERE area > 0
ORDER BY population_density DESC;


-- ============================================================
-- Q8: Show the name of countries whose name starts with 'A'
--     and ends with 'a'.
-- (Pattern matching with LIKE)
-- ============================================================

SELECT
    name
FROM world
WHERE name LIKE 'A%a';


-- ============================================================
-- Q9: Show the name of countries whose name contains 'land'.
-- (Substring search)
-- ============================================================

SELECT
    name
FROM world
WHERE name LIKE '%land%';


-- ============================================================
-- Q10: Show the name and population of the 5 most populous
--      countries in the world.
-- (ORDER BY + LIMIT)
-- ============================================================

SELECT
    name,
    population
FROM world
ORDER BY population DESC
LIMIT 5;


-- ============================================================
-- Q11: Show the total population of the world.
-- (Aggregate SUM)
-- ============================================================

SELECT
    SUM(population) AS world_population
FROM world;


-- ============================================================
-- Q12: Show, for each continent, the total population.
-- (GROUP BY)
-- ============================================================

SELECT
    continent,
    SUM(population) AS continent_population
FROM world
GROUP BY continent
ORDER BY continent;


-- ============================================================
-- Q13: Show, for each continent, the number of countries.
-- (COUNT + GROUP BY)
-- ============================================================

SELECT
    continent,
    COUNT(*) AS country_count
FROM world
GROUP BY continent
ORDER BY country_count DESC;


-- ============================================================
-- Q14: Show, for each continent, the country with the highest
--      population.
-- (Correlated subquery - classic SQLZoo-style pattern)
-- ============================================================

SELECT
    w1.continent,
    w1.name,
    w1.population
FROM world AS w1
WHERE w1.population = (
    SELECT MAX(w2.population)
    FROM world AS w2
    WHERE w2.continent = w1.continent
)
ORDER BY w1.continent;


-- ============================================================
-- Q15: Show the name and GDP of countries whose GDP is greater
--      than the average GDP of all countries.
-- (Subquery with AVG)
-- ============================================================

SELECT
    name,
    gdp
FROM world
WHERE gdp > (
    SELECT AVG(gdp)
    FROM world
)
ORDER BY gdp DESC;


-- ============================================================
-- Q16: Show the name and population of countries whose
--      population is more than three times that of any
--      neighbouring country on the same continent.
-- (Self-join style logic using NOT EXISTS)
-- ============================================================

SELECT
    w1.name,
    w1.population,
    w1.continent
FROM world AS w1
WHERE NOT EXISTS (
    SELECT 1
    FROM world AS w2
    WHERE w2.continent = w1.continent
      AND w2.name <> w1.name
      AND w2.population * 3 > w1.population
);


-- ============================================================
-- Q17: Show the name of all countries where the length of the
--      country name is exactly 4 characters.
-- (String length function)
-- ============================================================

SELECT
    name
FROM world
WHERE LENGTH(name) = 4;


-- ============================================================
-- Q18: Show the name and population of countries where the
--      population is between 1 million and 10 million, ordered
--      by population descending.
-- ============================================================

SELECT
    name,
    population
FROM world
WHERE population BETWEEN 1000000 AND 10000000
ORDER BY population DESC;


-- ============================================================
-- Q19: Show, for each continent, the average GDP per capita.
-- (Aggregate on computed expression)
-- ============================================================

SELECT
    continent,
    AVG(gdp::NUMERIC / population) AS avg_gdp_per_capita
FROM world
WHERE gdp IS NOT NULL
  AND population > 0
GROUP BY continent
ORDER BY avg_gdp_per_capita DESC;


-- ============================================================
-- Q20: Show the top 3 countries with the largest area in each
--      continent.
-- (Window function: ROW_NUMBER)
-- ============================================================

SELECT
    name,
    continent,
    area
FROM (
    SELECT
        name,
        continent,
        area,
        ROW_NUMBER() OVER (
            PARTITION BY continent
            ORDER BY area DESC
        ) AS rn
    FROM world
) AS ranked
WHERE rn <= 3
ORDER BY continent, area DESC;





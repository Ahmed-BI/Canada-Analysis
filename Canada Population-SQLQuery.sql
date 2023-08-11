--Original Population data set
Select * from [dbo].[CanadaPopulation]

-- Calculate average growth rate for each province from Q1 2018 to Q2 2023 (Rounded to the nearest whole number)
-- And rank the provinces according to the highest rate
SELECT
    Geography AS province,
    ROUND(("Q2 2023" - "Q1 2018") / 22, 0) AS avg_growth_rate_#Persons
FROM [dbo].[CanadaPopulation];

SELECT
    Geography AS province,
    ROUND(("Q2 2023" - "Q1 2018") / 22, 0) AS avg_growth_rate,
    RANK() OVER (ORDER BY ROUND(("Q2 2023" - "Q1 2018") / 22, 0) DESC) AS growth_rate_rank
FROM [dbo].[CanadaPopulation]
ORDER BY growth_rate_rank;


-- Visualize the population trend of Ontario over quarters
SELECT
    Geography,
    "Q1 2018" AS q1_2018, "Q2 2018" AS q2_2018 -- Repeat for other quarters
FROM [dbo].[CanadaPopulation]


-- Poulation counter and rank as of Q2 2023
SELECT
    Geography AS province,
    CAST("Q2 2023" / 1000 AS INT) AS population_in_thousands,
    RANK() OVER (ORDER BY "Q2 2023" DESC) AS population_rank
FROM [dbo].[CanadaPopulation]
ORDER BY population_rank;


-- Top 5 Provinces
SELECT TOP 5
    Geography AS province,
    CAST("Q2 2023" / 1000000.0 AS DECIMAL(18, 2)) AS population_in_millions,
    RANK() OVER (ORDER BY "Q2 2023" DESC) AS population_rank
FROM [dbo].[CanadaPopulation]
ORDER BY population_rank;

-- Overall growth rate from 2018 to 2023 combined
SELECT
    Geography AS province,
    ROUND((("Q2 2023" - "Q1 2018") / "Q1 2018") * 100, 2) AS overall_growth_percent
FROM [dbo].[CanadaPopulation]
ORDER BY overall_growth_percent DESC;
-- Overall growth rate from 2018 to 2023 years by year
--Yearly growth per province
SELECT
    Geography AS province,
    ROUND((("Q4 2018" - "Q1 2018") / "Q1 2018") * 100, 2) AS growth_2018,
    ROUND((("Q4 2019" - "Q1 2019") / "Q1 2019") * 100, 2) AS growth_2019,
    ROUND((("Q4 2020" - "Q1 2020") / "Q1 2020") * 100, 2) AS growth_2020,
    ROUND((("Q4 2021" - "Q1 2021") / "Q1 2021") * 100, 2) AS growth_2021,
    ROUND((("Q4 2022" - "Q1 2022") / "Q1 2022") * 100, 2) AS growth_2022
FROM [dbo].[CanadaPopulation]
ORDER BY  growth_2022 DESC, growth_2021 DESC, growth_2020 DESC, growth_2019 DESC, growth_2018 DESC;
-----------------

--Which year each province scored the highest growth
WITH GrowthData AS (
    SELECT
        Geography AS province,
        ROUND((("Q4 2018" - "Q1 2018") / "Q1 2018") * 100, 2) AS growth_2018,
        ROUND((("Q4 2019" - "Q1 2019") / "Q1 2019") * 100, 2) AS growth_2019,
        ROUND((("Q4 2020" - "Q1 2020") / "Q1 2020") * 100, 2) AS growth_2020,
        ROUND((("Q4 2021" - "Q1 2021") / "Q1 2021") * 100, 2) AS growth_2021,
        ROUND((("Q4 2022" - "Q1 2022") / "Q1 2022") * 100, 2) AS growth_2022
    FROM [dbo].[CanadaPopulation]
)
SELECT
    province,
    CASE
        WHEN growth_2018 >= growth_2019 AND growth_2018 >= growth_2020 AND growth_2018 >= growth_2021 AND growth_2018 >= growth_2022 THEN '2018'
        WHEN growth_2019 >= growth_2020 AND growth_2019 >= growth_2021 AND growth_2019 >= growth_2022 THEN '2019'
        WHEN growth_2020 >= growth_2021 AND growth_2020 >= growth_2022 THEN '2020'
        WHEN growth_2021 >= growth_2022 THEN '2021'
        ELSE '2022'
    END AS highest_growth_year
FROM GrowthData;


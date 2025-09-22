-- Connect to database (MySQL only)
USE hospital_db;

-- OBJECTIVE 1: ENCOUNTERS OVERVIEW
-- a. How many total encounters occurred each year?

SELECT * FROM encounters;

SELECT 	YEAR(start) AS yr,
		COUNT(id) AS encounters_num
			FROM encounters
		GROUP BY YEAR(start)
		ORDER BY yr;

-- b. For each year, what percentage of all encounters belonged to each encounter class
-- (ambulatory, outpatient, wellness, urgent care, emergency, and inpatient)?

WITH eclass AS (SELECT YEAR(start) AS yr, encounterclass,
					COUNT(id) AS class_encounters_num
						FROM encounters
					GROUP BY YEAR(start), encounterclass
					ORDER BY yr),
		yre AS ( SELECT YEAR(START) e2_yr, COUNT(id) as yr_encounters_num 
					FROM encounters
                    GROUP BY YEAR(START))
    SELECT eclass.yr, eclass.encounterclass, class_encounters_num,
		ROUND((class_encounters_num / yr_encounters_num) * 100,2) AS percentage
			FROM eclass 
				LEFT JOIN yre
                ON eclass.yr = yre.e2_yr;
					
                    
-- c. What percentage of encounters were over 24 hours versus under 24 hours?

SELECT  
		SUM(
			CASE WHEN TIMESTAMPDIFF(HOUR,START, STOP) < 24 THEN 1 ELSE 0
				END) as under_24h,
        SUM(
			CASE WHEN TIMESTAMPDIFF(HOUR,START, STOP) >= 24 THEN 1 ELSE 0
				END) as over_24h
					FROM encounters;

-- OBJECTIVE 2: COST & COVERAGE INSIGHTS
-- a. How many encounters had zero payer coverage, and what percentage of total encounters does this represent?

WITH total AS (SELECT COUNT(*) as total_num, 
				SUM(CASE WHEN PAYER_COVERAGE = 0 THEN 1 ELSE 0 END) AS 0_cover_num
						FROM encounters)
						
			SELECT total_num, 0_cover_num, ROUND(0_cover_num/total_num * 100, 2) as percentage  FROM total;

-- b. What are the top 10 most frequent procedures performed and the average base cost for each?

	SELECT code, description,COUNT(description) AS procedures_num, AVG(base_cost) AS avg_cost
		FROM procedures
        GROUP BY code, description
        ORDER BY procedures_num DESC
        LIMIT 10;

-- c. What are the top 10 procedures with the highest average base cost and the number of times they were performed?

SELECT code, description, AVG(base_cost) AS avg_cost, COUNT(description) as performed_num
	FROM procedures
    GROUP BY code, description
    ORDER BY avg_cost desc
    LIMIT 10;
    
-- d. What is the average total claim cost for encounters, broken down by payer?

SELECT p.name, AVG(e.total_claim_cost) as avg_cost
	FROM payers p LEFT JOIN encounters e
		ON p.id = e.payer
    GROUP BY e.payer, p.name
    ORDER BY avg_cost DESC;

-- OBJECTIVE 3: PATIENT BEHAVIOR ANALYSIS
-- a. How many unique patients were admitted each quarter over time?

SELECT 	YEAR(start) as yr, QUARTER(start) as qrt,
		COUNT(DISTINCT patient) as unique_patients
				FROM encounters
				GROUP BY YEAR(start), QUARTER(start);

-- b. How many patients were readmitted within 30 days of a previous encounter?

WITH ready_dates AS (SELECT patient, start, stop,
						LEAD(start) OVER(PARTITION BY patient ORDER BY start) as next_start_date
							FROM encounters
							ORDER BY patient, start),
			rd2 AS 	(SELECT patient, start, stop, next_start_date,
						DATEDIFF(next_start_date, stop) as days_diff
							FROM ready_dates
							HAVING days_diff < 30)
		SELECT COUNT(DISTINCT patient) FROM rd2;
	
-- c. Which patients had the most readmissions?

SELECT DISTINCT patient, COUNT(*) - 1 as num_readmision FROM encounters
GROUP BY patient
ORDER BY num_readmision DESC;
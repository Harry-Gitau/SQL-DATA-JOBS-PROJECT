SELECT * FROM job_postings_fact
limit 100;
SELECT 
		job_title_short as title,
		job_location as location,
		job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'ACST' as date,
		EXTRACT( 'month' from job_posted_date) as month
		
FROM job_postings_fact;

SELECT count(job_id) AS monthly_jobs,
		EXTRACT('month' from job_posted_date) as month
FROM job_postings_fact
     GROUP BY month
	 ORDER BY monthly_jobs DESC;
	 
CREATE TABLE january_postings AS
		SELECT *
		FROM job_postings_fact 
		WHERE
		EXTRACT('MONTH' FROM job_posted_date) = 1;
		
		-- For February
CREATE TABLE february_postings AS
    SELECT *
    FROM job_postings_fact 
    WHERE EXTRACT(MONTH FROM job_posted_date) = 2;

-- For March
CREATE TABLE march_postings AS
    SELECT *
    FROM job_postings_fact 
    WHERE EXTRACT(MONTH FROM job_posted_date) = 3;
		
-- For April
CREATE TABLE april_postings AS
    SELECT *
    FROM job_postings_fact 
    WHERE EXTRACT(MONTH FROM job_posted_date) = 4;

-- For May
CREATE TABLE may_postings AS
    SELECT *
    FROM job_postings_fact 
    WHERE EXTRACT(MONTH FROM job_posted_date) = 5;

-- For June
CREATE TABLE june_postings AS
    SELECT *
    FROM job_postings_fact 
    WHERE EXTRACT(MONTH FROM job_posted_date) = 6;

-- For July
CREATE TABLE july_postings AS
    SELECT *
    FROM job_postings_fact 
    WHERE EXTRACT(MONTH FROM job_posted_date) = 7;

-- For August
CREATE TABLE august_postings AS
    SELECT *
    FROM job_postings_fact 
    WHERE EXTRACT(MONTH FROM job_posted_date) = 8;

-- For September
CREATE TABLE september_postings AS
    SELECT *
    FROM job_postings_fact 
    WHERE EXTRACT(MONTH FROM job_posted_date) = 9;

-- For October
CREATE TABLE october_postings AS
    SELECT *
    FROM job_postings_fact 
    WHERE EXTRACT(MONTH FROM job_posted_date) = 10;

-- For November
CREATE TABLE november_postings AS
    SELECT *
    FROM job_postings_fact 
    WHERE EXTRACT(MONTH FROM job_posted_date) = 11;

-- For December
CREATE TABLE december_postings AS
    SELECT *
    FROM job_postings_fact 
    WHERE EXTRACT(MONTH FROM job_posted_date) = 12; 
	
	
	-- number of jobs in three categories
SELECT COUNT(job_id) AS number_per_location, 
		
		CASE
			WHEN job_location = 'Anywhere'THEN 'Remote'
			WHEN job_location = 'New York, NY' THEN 'Local'
			ELSE 'Global'
		END AS location
FROM job_postings_fact 
GROUP BY location
ORDER BY number_per_location;

-- table to reference
SELECT * FROM job_postings_fact limit 100;

-- sub-querry.
SELECT company_id,
		name, 
		link_google as link
FROM company_dim
WHERE company_id IN 
	( SELECT company_id 
	 FROM job_postings_fact
	 WHERE job_no_degree_mention = 'true'
	 AND job_title_short = 'Data Analyst'
	 ORDER BY company_id
);

--second sub-querry

WITH count_of_jobs AS
(
	SELECT company_id,
		count(*) as count_of_company
	FROM job_postings_fact
	GROUP BY 
	company_id
)
SELECT 
	company_dim.name,
	count_of_jobs.count_of_company
FROM company_dim 
LEFT JOIN 
count_of_jobs
ON count_of_jobs.company_id = company_dim.company_id

ORDER BY count_of_company DESC;

SELECT * FROM count_of_jobs;

SELECT * FROM company_dim;

SELECT * FROM skills_dim;

SELECT * FROM skills_job_dim;

SELECT 
	
	skills_dim.skill_id,
	skills_dim.skills,
	skills_job_dim.job_id
FROM skills_dim 
LEFT JOIN skills_job_dim
ON skills_dim.skill_id = skills_job_dim.skill_id;

WITH remote_jobs_skills as 
(
SELECT 
	
	skills_job_dim.skill_id as id,
	count(*) as skills
FROM skills_job_dim
LEFT JOIN job_postings_fact
ON job_postings_fact.job_id = skills_job_dim.job_id
WHERE job_postings_fact.job_work_from_home = true
GROUP BY id;
)
SELECT 
	skill_name.skill_id,
	
	remote.skills
	
FROM skills_dim as skill_names

RIGHT JOIN remote_job_skills as remote
ON remote.skill_id = skill_name.skill_id;

	

/*
Question: What are the 10 top paying data analyst jobs available remotely and also the company names of those job roles?
-Identify the top 10 highest paying data analyst roles that are available remotely.
-focuses on job psotings with specified salries (removing nulls)
-Why? Highlight the top paying opportunities for data analysts, offering insights to company names for top opportunities for data analysts*/

SELECT  job_id,
        job_title,
        job_location,
        job_schedule_type,
        salary_year_avg,
        job_posted_date,
        name AS company_name
FROM job_postings_fact
LEFT JOIN company_dim ON
job_postings_fact.company_id=company_dim.company_id
WHERE job_title_short= 'Data Analyst' 
        AND
      job_location = 'Anywhere'
      AND
      salary_year_avg IS NOT NULL 
ORDER BY salary_year_avg DESC
LIMIT 10

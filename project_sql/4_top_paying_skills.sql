-- Question : What are top skills based on salary/ top paying skills for data analysts?
SELECT skills,
        ROUND(AVG(salary_year_avg),0) as associated_avgsalary
FROM job_postings_fact
INNER JOIN skills_job_dim
ON skills_job_dim.job_id= job_postings_fact.job_id
INNER JOIN skills_dim
ON skills_job_dim.skill_id= skills_dim.skill_id
WHERE job_postings_fact.job_title_short ='Data Analyst' AND
salary_year_avg IS NOT NULL
GROUP BY skills
ORDER BY associated_avgsalary DESC
LIMIT 10


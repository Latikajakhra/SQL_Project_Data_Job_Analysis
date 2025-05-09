--Question: What are the most optimal skills to learn (high deamnd and high paying)

WITH skills_demand AS (
SELECT skills_dim.skill_id,
        skills_dim.skills,
        count(skills_job_dim.job_id) as total_associated_jobs
FROM job_postings_fact
INNER JOIN skills_job_dim
ON skills_job_dim.job_id= job_postings_fact.job_id
INNER JOIN skills_dim
ON skills_job_dim.skill_id= skills_dim.skill_id
WHERE job_postings_fact.job_title_short ='Data Analyst' AND
salary_year_avg IS NOT NULL
GROUP BY skills_dim.skill_id

),

average_salary AS(
    SELECT skills_job_dim.skill_id,
     ROUND(AVG(salary_year_avg),0) as associated_avgsalary
FROM job_postings_fact
INNER JOIN skills_job_dim
ON skills_job_dim.job_id= job_postings_fact.job_id
INNER JOIN skills_dim
ON skills_job_dim.skill_id= skills_dim.skill_id
WHERE job_postings_fact.job_title_short ='Data Analyst' AND
salary_year_avg IS NOT NULL
GROUP BY skills_job_dim.skill_id
)

SELECT skills_demand.skill_id,
        skills_demand.skills,
        total_associated_jobs,
        associated_avgsalary
FROM skills_demand
INNER JOIN average_salary ON
skills_demand.skill_id= average_salary.skill_id
ORDER BY total_associated_jobs DESC,
        associated_avgsalary DESC
LIMIT 25
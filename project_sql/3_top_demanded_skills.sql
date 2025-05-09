--Question: What are the most in demand skills for data analysts?

SELECT skills,
        count(skills_job_dim.job_id) as total_associated_jobs
FROM job_postings_fact
INNER JOIN skills_job_dim
ON skills_job_dim.job_id= job_postings_fact.job_id
INNER JOIN skills_dim
ON skills_job_dim.skill_id= skills_dim.skill_id
WHERE job_postings_fact.job_title_short ='Data Analyst'
GROUP BY skills
ORDER BY total_associated_jobs DESC
limit 5
# Introduction
 📊 Dive into the data job market! Focusing on Data Analyst roles, this project explores 💼 top-paying jobs, 🚀 in-demand skills, and where high demand meets high salary in the world of Data Analytics.
🔍 SQL queries? Check them out here:[project_sql folder](/project_sql/)

# Background
Driven by a quest to navigate the data analyst job market moore effectively , this project was born from a desire to pinpoint top-paid and in-demand skills , streamlining others work to find optimal jobs .
Data hails from [SQL Course](https://lukebarousse.com/sql). It's packed with insights on job-titles , salaries , locations, essential skills.

### The Questions I wanted to answer through my SQL queries were:
1. What are the 10 top paying data analyst jobs available remotely and also the company names of those job roles?
2. What skills are required for the top-paying data analyst jobs?
3.  What are the most in demand skills for data analysts?
4.  What are top skills based on salary/ top paying skills for data analysts?
5.  What are the most optimal skills to learn (high deamnd and high paying)

# Tools I used
For my deep dive into the data analyst job market, I harnessed the power of several key tools:
- **SQL:** The backbone of my analysis , allowing me to query the database and unearth critical insights .
- **PostgresSQL:** The chosen database management system , ideal for handling the job posting data.
- **Visual Studio Code:** My go-to for database management and executing SQL queries.
- **Git & Github :** Essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking.

# The Analysis
Each query for this project aimed at investigating specific aspects of the data analyst job market. Here's how I approached each question:
### 1. Top paying Data Analyst Jobs
To identify the highest-paying roles , I filtered data analyst positions by average yearly salary and location , focusing on remote jobs.This query highlights the high-paying opportunities in the field.
```sql
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
```
Here's the breakdown of the top data analyst jobs in 2023:
- **Wide Salary Range:** Top 10 paying data analyst roles span from $184,000 to $650,000, indicating significant salary potential in the field.
- **Diverse Employers:** Companies like SmartAsset, Meta, and AT&T are among those offering high salaries, showing a broad interest across different industries.
- **Job Title Variety:** There's a high diversity in job titles, from Data Analyst to Director of Analytics, reflecting varied roles and specializations within data analytics.
 ![Top paying roles](project_sql\assets\1_top_paying_roles.png)
### 2.Skills for top paying jobs
To undertand what skills are required for the top-paying jobs. I joined the job postings with the skills data , providing insights into what employers value for high compensation roles.
```sql
WITH top_paying_jobs AS (
SELECT  job_id,
        job_title,
        salary_year_avg,
      
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
)

SELECT top_paying_jobs.*,
        skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON
top_paying_jobs.job_id= skills_job_dim.job_id
INNER JOIN skills_dim ON 
skills_job_dim.skill_id= skills_dim.skill_id
ORDER BY salary_year_avg DESC
```
Here’s a breakdown of the top-paying skills for data analyst roles:

-**High-paying technical tools:** Skills like Jupyter ($154,238), PySpark ($143,616), and Databricks ($142,768) lead the list, highlighting strong demand for data engineering and big data tools.

-**Visualization and reporting matter:** Even tools like PowerPoint ($142,404) show up high, indicating the value of communication and presentation in data analytics roles.

-**Versatility is rewarded:** A mix of open-source platforms, cloud tools, and scripting environments makes up the top 10, suggesting employers value analysts who can operate across diverse ecosystems.

![skills for top paying jobs](project_sql\assets\image.png)

### 3. In-Demand Skills for Data Analysts

This query helped identify the skills mst frequently requested in job postings, directing focus to areas with high demand .
```sql
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
```
Here’s a breakdown of the most in-demand data analyst skills based on job listings:

-**SQL** is essential: With over 92,000 job listings, SQL is by far the most requested skill for data analysts, making it foundational for data querying and analysis.

-**Excel** remains relevant: Despite the rise of advanced tools, Excel is listed in over 67,000 jobs, showing it's still a critical skill, especially for business-focused roles.

-**Visualization tools are key:** Tools like Tableau (46,554) and Power BI (39,468) show strong demand, emphasizing the importance of data storytelling and dashboard creation.
| Skill    | Total Associated Jobs |
| -------- | --------------------- |
| SQL      | 92,628                |
| Excel    | 67,031                |
| Python   | 57,326                |
| Tableau  | 46,554                |
| Power BI | 39,468                |
### 4. Top Paying Skills:
Exploring the average salaries associated with different skills revealed which skills are the highest paying.
 ```sql
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
```
Here's a breakdown of the results for top paying skills for data analysts:
- **svn**
- **solidity**
- **couchbase**
- **datarobot**
- **golang**

### 5. Most optimal skills to learn
Combining insights from demand and salary data, this query aimed to pinpoint skills that are both in high demand and high paying offering a strategic focus for skills development.

```sql

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
```
Here's a breakdown of the most optimal skills for data analysts in 2023:
- **Programing languages :** sql, pyhton , r
- **Cloud Tools and technologies :** Snoflake , azure , AWS , etc.
- **Business Intelligence and visualization tools:** Tableau, power bi
- **Database technologies:** server , sql server, oracle,etc.

# What I learned

Throughout this adventure, I've turbocharged my SQL toolkit with some serious firepower:

- **🧩 Complex Query Crafting:** Mastered the art of advanced SQL, merging tables like a pro and wielding WITH clauses for ninja-level temp table maneuvers.
- **📊 Data Aggregation:** Got cozy with GROUP BY and turned aggregate functions like COUNT() and AVG() into my data-summarizing sidekicks. ⏳
- **💡 Analytical Wizardry:** Leveled up my real-world puzzle-solving skills, turning questions into actionable, insightful SQL queries.


# Conclusion

### Insights

From the analysis, several general insights emerged:

1. **Top-Paying Data Analyst Jobs**: The highest-paying jobs for data analysts that allow remote work offer a wide range of salaries, the highest at \$650,000!
2. **Skills for Top-Paying Jobs**: High-paying data analyst jobs require advanced proficiency in SQL, suggesting it’s a critical skill for earning a top salary.
3. **Most In-Demand Skills**: SQL is also the most demanded skill in the data analyst job market, thus making it essential for job seekers.
4. **Skills with Higher Salaries**: Specialized skills, such as SVN and Solidity, are associated with the highest average salaries, indicating a premium on niche expertise.
5. **Optimal Skills for Job Market Value**: SQL leads in demand and offers for a high average salary, positioning it as one of the most optimal skills for data analysts to learn to maximize their market value.

### Closing Thoughts
 
This project enhanced my SQL skills and provided valuable insights into the data analyst job market. The findings from the analysis serve as a guide to prioritizing skill development and job search efforts. Aspiring data analysts can better position themselves in a competitive job market by focusing on high-demand, high-salary skills. This exploration highlights the importance of continuous learning and adaptation to emerging trends in the field of data analytics.



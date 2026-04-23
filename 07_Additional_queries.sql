USE job_salary_db;
-- ============================================
-- Additional Query 1: Salary by job title
-- Business question: Which job titles offer the highest average salaries?
-- ============================================

SELECT
    jp.job_title,
    ROUND(AVG(sr.salary), 2) AS average_salary,
    COUNT(*) AS record_count
FROM salary_records sr
JOIN job_profiles jp
    ON sr.job_profile_id = jp.job_profile_id
GROUP BY jp.job_title
ORDER BY average_salary DESC;

-- Conclusion:
-- Job title appears to be one of the strongest salary differentiators in the dataset, with substantial variation across roles.
-- AI Engineer and Machine Learning Engineer show the highest average salaries, while Business Analyst and Data Analyst appear at the lower end of the ranking.
-- Compared with the minimal variation observed across industries, job title provides a much more meaningful explanation of salary differences.

-- ============================================
-- Additional Query 2: Remote work and salary by job title
-- Business question: Does remote work affect salary equally across different job titles?
-- ============================================

SELECT
    jp.job_title,
    wc.remote_work,
    ROUND(AVG(sr.salary), 2) AS average_salary,
    COUNT(*) AS record_count
FROM salary_records sr
JOIN job_profiles jp
    ON sr.job_profile_id = jp.job_profile_id
JOIN work_contexts wc
    ON sr.work_context_id = wc.work_context_id
GROUP BY jp.job_title, wc.remote_work
ORDER BY jp.job_title,
    CASE
        WHEN wc.remote_work = 'No' THEN 1
        WHEN wc.remote_work = 'Hybrid' THEN 2
        WHEN wc.remote_work = 'Yes' THEN 3
    END;
    
-- Conclusion:
-- Across most job titles, fully remote roles show the highest average salary, while hybrid and non-remote roles remain relatively close to each other.
-- This suggests that the salary premium associated with remote work is not limited to the overall dataset, but is also visible within individual roles.
-- However, the magnitude of the difference remains moderate, indicating that remote work is a contributing factor rather than a primary salary driver. 
 
-- ============================================
-- Additional Query 3: Education and salary by job title
-- Business question: Does education level influence salary consistently across job titles?
-- ============================================

SELECT
    jp.job_title,
    jp.education_level,
    ROUND(AVG(sr.salary), 2) AS average_salary,
    COUNT(*) AS record_count
FROM salary_records sr
JOIN job_profiles jp
    ON sr.job_profile_id = jp.job_profile_id
GROUP BY jp.job_title, jp.education_level
ORDER BY jp.job_title,
    CASE
        WHEN jp.education_level = 'High School' THEN 1
        WHEN jp.education_level = 'Diploma' THEN 2
        WHEN jp.education_level = 'Bachelor' THEN 3
        WHEN jp.education_level = 'Master' THEN 4
        WHEN jp.education_level = 'PhD' THEN 5
    END;
    
-- Conclusion:
-- Education level shows a consistent positive relationship with salary across all job titles, with higher academic attainment linked to higher average compensation within each role.
-- This confirms that the education effect observed in the overall analysis is not simply driven by job title composition, but also holds within individual professions.
-- The pattern suggests that advanced education provides an additional salary premium even when comparing professionals in the same role.

-- ============================================
-- Additional Query 4: Top 10% salaries by industry
-- Business question: Do industries differ more clearly when focusing on their highest-paid salary segment?
-- ============================================

WITH industry_salary_percentile AS (
    SELECT
        wc.industry,
        sr.salary,
        CUME_DIST() OVER (
            PARTITION BY wc.industry
            ORDER BY sr.salary DESC
        ) AS salary_percentile
    FROM salary_records sr
    JOIN work_contexts wc
        ON sr.work_context_id = wc.work_context_id
)
SELECT
    industry,
    ROUND(AVG(salary), 2) AS average_top_10pct_salary,
    COUNT(*) AS record_count
FROM industry_salary_percentile
WHERE salary_percentile <= 0.10
GROUP BY industry
ORDER BY average_top_10pct_salary DESC;

USE job_salary_db;

-- Conclusion:
-- Even when focusing on the top 10% highest-paid records within each industry, salary differences remain very small across sectors.
-- This suggests that industry does not strongly differentiate salary levels, even at the upper end of the distribution.
-- The result reinforces the idea that other variables, such as job title, experience, or education, are likely to be more relevant salary drivers in this dataset.

-- ============================================
-- Additional Query 5: Top job titles within the top 10% salaries of each industry
-- Business question: Which job titles are most represented among the highest-paid records in each industry?
-- ============================================

WITH industry_salary_percentile AS (
    SELECT
        wc.industry,
        jp.job_title,
        sr.salary,
        CUME_DIST() OVER (PARTITION BY wc.industry
            ORDER BY sr.salary DESC) AS salary_percentile
    FROM salary_records sr
    JOIN work_contexts wc
        ON sr.work_context_id = wc.work_context_id
    JOIN job_profiles jp
        ON sr.job_profile_id = jp.job_profile_id),
elite_jobs AS (
    SELECT
        industry,
        job_title,
        COUNT(*) AS elite_record_count,
        ROUND(AVG(salary), 2) AS average_salary
    FROM industry_salary_percentile
    WHERE salary_percentile <= 0.10
    GROUP BY industry, job_title
),
ranked_elite_jobs AS (
    SELECT
        industry,
        job_title,
        elite_record_count,
        average_salary,
        ROW_NUMBER() OVER (PARTITION BY industry 
			ORDER BY elite_record_count DESC, average_salary DESC) AS job_rank
    FROM elite_jobs)
SELECT
    industry,
    job_title,
    elite_record_count,
    average_salary,
    job_rank
FROM ranked_elite_jobs
WHERE job_rank <= 3
ORDER BY industry, job_rank;

-- Conclusion:
-- The top 10% highest-paid records in every industry are consistently dominated by the same three roles: AI Engineer, Machine Learning Engineer, and Product Manager.
-- This suggests that top-end salary differences are driven more by job title composition than by industry itself.
-- Even within the highest-paying segment of each industry, job title remains a much stronger differentiator than sector membership.
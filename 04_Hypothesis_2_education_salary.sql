USE job_salary_db;

-- ============================================
-- Hypothesis 2: Education and salary
-- Business question: Does education level significantly affect salary?
-- ============================================

-- Query 2.1: Average salary and record count by education level
SELECT
    jp.education_level,
    ROUND(AVG(sr.salary), 2) AS average_salary,
    COUNT(*) AS record_count
FROM salary_records sr
JOIN job_profiles jp
    ON sr.job_profile_id = jp.job_profile_id
GROUP BY jp.education_level
ORDER BY
    CASE
        WHEN jp.education_level = 'High School' THEN 1
        WHEN jp.education_level = 'Diploma' THEN 2
        WHEN jp.education_level = 'Bachelor' THEN 3
        WHEN jp.education_level = 'Master' THEN 4
        WHEN jp.education_level = 'PhD' THEN 5
    END;
    
-- Query 2.2: Salary growth across education levels
WITH education_salary AS (
    SELECT
        jp.education_level,
        CASE
            WHEN jp.education_level = 'High School' THEN 1
            WHEN jp.education_level = 'Diploma' THEN 2
            WHEN jp.education_level = 'Bachelor' THEN 3
            WHEN jp.education_level = 'Master' THEN 4
            WHEN jp.education_level = 'PhD' THEN 5
        END AS education_order,
        AVG(sr.salary) AS average_salary,
        COUNT(*) AS record_count
    FROM salary_records sr
    JOIN job_profiles jp
        ON sr.job_profile_id = jp.job_profile_id
    GROUP BY jp.education_level
)
SELECT
    education_level,
    ROUND(average_salary, 2) AS average_salary,
    record_count,
    ROUND(LAG(average_salary) OVER (ORDER BY education_order), 2) AS previous_average_salary,
    ROUND(average_salary - LAG(average_salary) OVER (ORDER BY education_order), 2) AS salary_increase,
    ROUND(((average_salary - LAG(average_salary) OVER (ORDER BY education_order))/ LAG(average_salary) OVER (ORDER BY education_order)) * 100, 2) AS salary_increase_pct
FROM education_salary
ORDER BY education_order;

-- Conclusion:
-- Average salary rises steadily across all education levels, from High School to PhD, indicating a clear positive relationship between education and compensation.
-- The largest salary increases occur at postgraduate levels, particularly from Bachelor to Master and from Master to PhD, suggesting a stronger premium for advanced education.
-- This supports the hypothesis that higher education levels are associated with higher salaries.
-- Further analysis may examine how education interacts with experience or industry to better understand its impact on salary.
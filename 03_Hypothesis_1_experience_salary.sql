#How strongly does experience level influence salary? // Higher experience leads to higher salaries.
#Does education level significantly affect salary? // Higher education levels are associated with better pay.
#Do remote jobs pay more or less than non-remote jobs? // Remote work affects salary levels.
#Which industries offer the highest average salaries? // Industry is a major driver of salary differences.

USE job_salary_db;

######How strongly does experience level influence salary? // Higher experience leads to higher salaries.
USE job_salary_db;

USE job_salary_db;

-- ============================================
-- Hypothesis 1: Experience and salary
-- Business question: How strongly does experience level influence salary?
-- ============================================

-- 1.1 Average salary and record count by exact years of experience
SELECT
    jp.experience_years,
    ROUND(AVG(sr.salary), 2) AS average_salary,
    COUNT(*) AS record_count
FROM salary_records sr
JOIN job_profiles jp
    ON sr.job_profile_id = jp.job_profile_id
GROUP BY jp.experience_years
ORDER BY jp.experience_years ASC;

-- 1.2 Year-over-year salary growth by exact years of experience
WITH yearly_salary AS (
    SELECT
        jp.experience_years,
        AVG(sr.salary) AS average_salary,
        COUNT(*) AS record_count
    FROM salary_records sr
    JOIN job_profiles jp
        ON sr.job_profile_id = jp.job_profile_id
    GROUP BY jp.experience_years
)
SELECT
    experience_years,
    ROUND(average_salary, 2) AS average_salary,
    record_count,
    ROUND(LAG(average_salary) OVER (ORDER BY experience_years), 2) AS previous_average_salary,
    ROUND(average_salary - LAG(average_salary) OVER (ORDER BY experience_years), 2) AS salary_increase,
    ROUND(((average_salary - LAG(average_salary) OVER (ORDER BY experience_years))/ LAG(average_salary) OVER (ORDER BY experience_years)) * 100,2) AS salary_increase_pct
FROM yearly_salary
ORDER BY experience_years ASC;

-- Conclusion:
-- Average salary increases consistently with years of experience, showing a clear upward trend across the career path.
-- The year-over-year analysis confirms that salary growth is generally positive, with incremental gains as experience accumulates.
-- This strongly supports the hypothesis that experience is one of the primary drivers of salary differences in the dataset.
-- Further analysis could explore how this effect interacts with other factors such as education level or industry.

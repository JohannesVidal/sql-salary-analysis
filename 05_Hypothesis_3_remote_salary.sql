USE job_salary_db;

-- ============================================
-- Hypothesis 3: Remote work and salary
-- Business question: Do remote jobs pay more or less than non-remote jobs?
-- ============================================

-- Query 3.1: Average salary and record count by work arrangement
SELECT
    wc.remote_work,
    ROUND(AVG(sr.salary), 2) AS average_salary,
    COUNT(*) AS record_count
FROM salary_records sr
JOIN work_contexts wc
    ON sr.work_context_id = wc.work_context_id
GROUP BY wc.remote_work
ORDER BY
    CASE
        WHEN wc.remote_work = 'No' THEN 1
        WHEN wc.remote_work = 'Hybrid' THEN 2
        WHEN wc.remote_work = 'Yes' THEN 3
    END;
    
-- Conclusion:
-- Fully remote roles show the highest average salary in the dataset, while hybrid and non-remote roles display nearly identical pay levels.
-- This suggests that remote work is associated with higher salaries, although the effect is not linear across all work arrangements.
-- Further analysis will explore whether this difference is driven by other factors, such as industry or job profile, in the additional queries section.
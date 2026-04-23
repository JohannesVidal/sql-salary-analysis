USE job_salary_db;

-- ============================================
-- Hypothesis 4: Industry and salary
-- Business question: Which industries offer the highest average salaries?
-- ============================================

-- Query 4.1: Average salary and record count by industry
SELECT
    wc.industry,
    ROUND(AVG(sr.salary), 2) AS average_salary,
    COUNT(*) AS record_count
FROM salary_records sr
JOIN work_contexts wc
    ON sr.work_context_id = wc.work_context_id
GROUP BY wc.industry
ORDER BY average_salary DESC;

-- Conclusion:
-- Average salaries are remarkably similar across industries, with only minor differences between the highest- and lowest-paying sectors.
-- Although a ranking can be established, the variation is too small to conclude that industry is a major driver of salary differences in this dataset.
-- This suggests that other factors, such as experience or education level, may play a more important role in explaining salary variation.
-- Further analysis in the additional queries section may explore whether industry has a stronger effect when combined with variables such as remote work or education.
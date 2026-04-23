CREATE DATABASE job_salary_db;
USE job_salary_db;

CREATE TABLE job_profiles (
    job_profile_id INT AUTO_INCREMENT PRIMARY KEY,
    job_title VARCHAR(255),
    experience_years INT,
    education_level VARCHAR(100),
    skills_count INT,
    certifications INT
);

CREATE TABLE work_contexts (
    work_context_id INT AUTO_INCREMENT PRIMARY KEY,
    industry VARCHAR(255),
    company_size VARCHAR(100),
    location VARCHAR(255),
    remote_work VARCHAR(50)
);

CREATE TABLE salary_records (
    salary_record_id INT AUTO_INCREMENT PRIMARY KEY,
    job_profile_id INT,
    work_context_id INT,
    salary INT,
    FOREIGN KEY (job_profile_id) REFERENCES job_profiles(job_profile_id),
    FOREIGN KEY (work_context_id) REFERENCES work_contexts(work_context_id)
);

INSERT INTO job_profiles (job_title, experience_years, education_level, skills_count, certifications)
SELECT DISTINCT
    job_title,
    experience_years,
    education_level,
    skills_count,
    certifications
FROM raw_salary_db;

INSERT INTO work_contexts (industry, company_size, location, remote_work)
SELECT DISTINCT
    industry,
    company_size,
    location,
    remote_work
FROM raw_salary_db;

INSERT INTO salary_records (job_profile_id, work_context_id, salary)
SELECT
    jp.job_profile_id,
    wc.work_context_id,
    r.salary
FROM raw_salary_db r
JOIN job_profiles jp
    ON r.job_title = jp.job_title
    AND r.experience_years = jp.experience_years
    AND r.education_level = jp.education_level
    AND r.skills_count = jp.skills_count
    AND r.certifications = jp.certifications
JOIN work_contexts wc
    ON r.industry = wc.industry
    AND r.company_size = wc.company_size
    AND r.location = wc.location
    AND r.remote_work = wc.remote_work;   



DROP INDEX IF EXISTS idx_ci_year_version;

CREATE INDEX idx_ci_year_version
ON course_instance (year, period)

SELECT 
    wa.emp_id, 
	CONCAT(e.first_name, ' ', e.last_name) AS teachers_name,
    ci.period, 
    COUNT(DISTINCT wa.instance_id) as no_of_courses
FROM work_allocation wa
JOIN course_instance ci ON wa.instance_id = ci.instance_id
JOIN employee AS e ON e.emp_id = wa.emp_id
WHERE ci.year = EXTRACT(YEAR FROM CURRENT_DATE) AND ci.period = 'P1'
GROUP BY wa.emp_id, e.emp_id, ci.period
HAVING COUNT(DISTINCT wa.instance_id) >= 2
ORDER BY ci.period;
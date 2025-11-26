DROP VIEW IF EXISTS employees_course_per_period_calculation;

CREATE VIEW employees_course_per_period_calculation AS
SELECT 
    wa.emp_id, 
	CONCAT(e.first_name, ' ', e.last_name) AS teachers_name,
    ci.period, 
    COUNT(DISTINCT wa.instance_id) as no_of_courses
FROM work_allocation wa
JOIN course_instance ci ON wa.instance_id = ci.instance_id
JOIN employee AS e ON e.emp_id = wa.emp_id
WHERE ci.year = EXTRACT(YEAR FROM CURRENT_DATE) AND ci.period = 'P2'
GROUP BY wa.emp_id, e.emp_id, ci.period
ORDER BY ci.period;

SELECT * FROM employees_course_per_period_calculation;
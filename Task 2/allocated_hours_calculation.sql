DROP VIEW IF EXISTS allocated_hours_calculation;

CREATE VIEW allocated_hours_calculation AS 
SELECT 
cv.course_code, 
ci.instance_id, 
cv.hp,   
CONCAT(e.first_name, ' ', e.last_name) AS teachers_name,
j.job_title AS designation,

CASE WHEN act.name = 'Lecture' 	THEN ROUND(w.hours_allocated * act.preparation_factor) ELSE 0 END AS lecture_hours,
CASE WHEN act.name = 'Tutorial' THEN ROUND(w.hours_allocated * act.preparation_factor) ELSE 0 END AS tutorial_hours,
CASE WHEN act.name = 'Lab' 		THEN ROUND(w.hours_allocated * act.preparation_factor) ELSE 0 END AS lab_hours,
CASE WHEN act.name = 'Seminar' 	THEN ROUND(w.hours_allocated * act.preparation_factor) ELSE 0 END AS seminar_hours,
CASE WHEN act.name = 'Other' 	THEN ROUND(w.hours_allocated * act.preparation_factor) ELSE 0 END AS other_overhead_hours,
ROUND((2*cv.hp+28+0.2*ci.registered_students) / (SELECT COUNT(*) FROM work_allocation WHERE ci.instance_id = instance_id GROUP BY instance_id)) AS admin,
ROUND((32+0.725*ci.registered_students) / (SELECT COUNT(*) FROM work_allocation WHERE ci.instance_id = instance_id GROUP BY instance_id)) AS exam,


CASE WHEN act.name = 'Lecture' 	THEN ROUND(w.hours_allocated * act.preparation_factor) ELSE 0 END +
CASE WHEN act.name = 'Tutorial' THEN ROUND(w.hours_allocated * act.preparation_factor) ELSE 0 END +
CASE WHEN act.name = 'Lab' 		THEN ROUND(w.hours_allocated * act.preparation_factor) ELSE 0 END +
CASE WHEN act.name = 'Seminar' 	THEN ROUND(w.hours_allocated * act.preparation_factor) ELSE 0 END +
CASE WHEN act.name = 'Other' 	THEN ROUND(w.hours_allocated * act.preparation_factor) ELSE 0 END +
ROUND((2*cv.hp+28+0.2*ci.registered_students) / (SELECT COUNT(*) FROM work_allocation WHERE ci.instance_id = instance_id GROUP BY instance_id)) +
ROUND((32+0.725*ci.registered_students) / (SELECT COUNT(*) FROM work_allocation WHERE ci.instance_id = instance_id GROUP BY instance_id)) AS total


FROM course_version AS cv
INNER JOIN course_instance AS ci ON ci.version_id = cv.version_id
INNER JOIN planned_activity AS pa ON pa.instance_id = ci.instance_id
INNER JOIN activity_type AS act ON pa.activity_id = act.activity_id
INNER JOIN work_allocation AS w ON w.activity_id = act.activity_id AND w.instance_id = ci.instance_id
INNER JOIN employee AS e ON e.emp_id = w.emp_id
INNER JOIN job_title AS j ON j.job_id = e.job_title_id

WHERE ci.year = EXTRACT(YEAR FROM CURRENT_DATE)

ORDER BY cv.course_code, ci.instance_id;

SELECT * FROM allocated_hours_calculation;
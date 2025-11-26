DROP VIEW IF EXISTS planned_hours_calculation;

CREATE VIEW planned_hours_calculation AS 
SELECT 
cv.course_code, 
ci.instance_id, 
cv.hp, 
ci.period, 
ci.registered_students, 
SUM(CASE WHEN act.name = 'Lecture' 	THEN ROUND(pa.planned_hours * act.preparation_factor) ELSE 0 END) AS lecture_hours, 
SUM(CASE WHEN act.name = 'Tutorial' THEN ROUND(pa.planned_hours * act.preparation_factor) ELSE 0 END) AS tutorial_hours, 
SUM(CASE WHEN act.name = 'Lab' 		THEN ROUND(pa.planned_hours * act.preparation_factor) ELSE 0 END) AS lab_hours, 
SUM(CASE WHEN act.name = 'Seminar' 	THEN ROUND(pa.planned_hours * act.preparation_factor) ELSE 0 END) AS seminar_hours, 
SUM(CASE WHEN act.name = 'Other' 	THEN ROUND(pa.planned_hours * act.preparation_factor) ELSE 0 END) AS other_overhead_hours,
ROUND(2*cv.hp+28+0.2*ci.registered_students) AS admin,
ROUND(32+0.725*ci.registered_students) AS exam,
ROUND(SUM(pa.planned_hours * act.preparation_factor) + 2*cv.hp+28+0.2*ci.registered_students + 32+0.725*ci.registered_students) AS total_hours

FROM course_version AS cv
INNER JOIN course_instance AS ci ON ci.version_id = cv.version_id
INNER JOIN planned_activity AS pa ON pa.instance_id = ci.instance_id
INNER JOIN activity_type AS act ON pa.activity_id = act.activity_id
WHERE ci.year = EXTRACT(YEAR FROM CURRENT_DATE)
GROUP BY cv.course_code, ci.instance_id, cv.hp, ci.period, ci.registered_students
ORDER BY cv.course_code, ci.period;

SELECT * FROM planned_hours_calculation;
-- This trigger code was AI generated. --

CREATE OR REPLACE FUNCTION check_max_course_allocation()
RETURNS TRIGGER AS $$
DECLARE
    max_limit INT;
    current_count INT;
    target_period CHAR(2);
BEGIN
    SELECT CAST(rule_value AS INT) INTO max_limit 
    FROM system_config 
    WHERE rule_name = 'MaxCoursesPerPeriod';

    IF max_limit IS NULL THEN
        max_limit := 4;
    END IF;

    SELECT period INTO target_period 
    FROM course_instance 
    WHERE instance_id = NEW.instance_id;

    SELECT COUNT(DISTINCT wa.instance_id) INTO current_count
    FROM work_allocation wa
    JOIN course_instance ci ON wa.instance_id = ci.instance_id
    WHERE wa.emp_id = NEW.emp_id
      AND ci.period = target_period
      AND wa.instance_id != NEW.instance_id; 

    IF current_count >= max_limit THEN
        RAISE EXCEPTION 'Allocation violation: Teacher % is already assigned to % courses in period % (Max allowed: %).', 
            NEW.emp_id, current_count, target_period, max_limit;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER enforce_max_courses
BEFORE INSERT OR UPDATE ON work_allocation
FOR EACH ROW EXECUTE FUNCTION check_max_course_allocation();
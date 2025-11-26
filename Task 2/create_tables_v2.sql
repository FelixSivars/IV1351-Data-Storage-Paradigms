DROP TABLE IF EXISTS "employee_email" CASCADE;
DROP TABLE IF EXISTS "employee_phone" CASCADE;
DROP TABLE IF EXISTS "employee_skill" CASCADE;
DROP TABLE IF EXISTS "work_allocation" CASCADE;
DROP TABLE IF EXISTS "planned_activity" CASCADE;
DROP TABLE IF EXISTS "salary_history" CASCADE;
DROP TABLE IF EXISTS "employee" CASCADE;
DROP TABLE IF EXISTS "activity_type" CASCADE;
DROP TABLE IF EXISTS "course_instance" CASCADE;
DROP TABLE IF EXISTS "course_version" CASCADE;
DROP TABLE IF EXISTS "skill_type" CASCADE;
DROP TABLE IF EXISTS "job_title" CASCADE;
DROP TABLE IF EXISTS "department" CASCADE;
DROP TABLE IF EXISTS "system_config" CASCADE;

CREATE TABLE "department" (
  "dept_id" SERIAL,
  "manager_id" INT UNIQUE,
  "name" VARCHAR(100) NOT NULL UNIQUE,
  PRIMARY KEY ("dept_id")
);

CREATE TABLE "job_title" (
  "job_id" SERIAL,
  "job_title" VARCHAR(100) NOT NULL UNIQUE,
  PRIMARY KEY ("job_id")
);

CREATE TABLE "employee" (
  "emp_id" SERIAL,
  "first_name" VARCHAR(100) NOT NULL,
  "last_name" VARCHAR(100) NOT NULL,
  "dept_id" INT NOT NULL,
  "job_title_id" INT NOT NULL,
  PRIMARY KEY ("emp_id"),
  CONSTRAINT "FK_employee_dept_id"
    FOREIGN KEY ("dept_id")
      REFERENCES "department"("dept_id")
	  	ON DELETE RESTRICT,
  CONSTRAINT "FK_employee_job_title_id"
    FOREIGN KEY ("job_title_id")
      REFERENCES "job_title"("job_id")
	  	ON DELETE RESTRICT
);

CREATE TABLE "salary_history" (
  "emp_id" INT NOT NULL,
  "valid_from" DATE NOT NULL,
  "valid_to" DATE,
  "amount" DECIMAL(10, 2) NOT NULL,
  PRIMARY KEY ("emp_id", "valid_from"),
  CONSTRAINT "FK_salary_history_emp_id"
    FOREIGN KEY ("emp_id")
      REFERENCES "employee"("emp_id")
	  	ON DELETE CASCADE
);

CREATE TABLE "course_version" (
  "course_code" CHAR(6) NOT NULL,
  "version_id" SERIAL UNIQUE,
  "course_name" VARCHAR(50) NOT NULL,
  "valid_from" DATE NOT NULL,
  "valid_to" DATE,
  "hp" DECIMAL(4, 1),
  "min_students" INT NOT NULL DEFAULT 0,
  "max_students" INT NOT NULL,
  PRIMARY KEY ("course_code", "version_id")
);

CREATE TABLE "course_instance" (
  "instance_id" SERIAL,
  "version_id" INT NOT NULL,
  "period" CHAR(2) NOT NULL CHECK (Period IN ('P1', 'P2', 'P3', 'P4')),
  "year" INT NOT NULL CHECK (Year > 1900),
  "registered_students" INT NOT NULL DEFAULT 0,
  PRIMARY KEY ("instance_id"),
  CONSTRAINT "FK_course_instance_version_id"
    FOREIGN KEY ("version_id")
      REFERENCES "course_version"("version_id")
	  	ON DELETE CASCADE
);

CREATE TABLE "activity_type" (
  "activity_id" SERIAL,
  "name" VARCHAR(50) NOT NULL UNIQUE,
  "preparation_factor" DECIMAL(4, 2) NOT NULL DEFAULT 1.00,
  PRIMARY KEY ("activity_id")
);

CREATE TABLE "work_allocation" (
  "emp_id" INT NOT NULL,
  "instance_id" INT NOT NULL,
  "activity_id" INT NOT NULL,
  "hours_allocated" DECIMAL(6, 2) NOT NULL DEFAULT 0,
  PRIMARY KEY ("emp_id", "instance_id", "activity_id"),
  CONSTRAINT "FK_work_allocation_emp_id"
    FOREIGN KEY ("emp_id")
      REFERENCES "employee"("emp_id")
	  	ON DELETE CASCADE,
  CONSTRAINT "FK_work_allocation_instance_id"
    FOREIGN KEY ("instance_id")
      REFERENCES "course_instance"("instance_id")
	  	ON DELETE CASCADE,
  CONSTRAINT "FK_work_allocation_activity_id"
    FOREIGN KEY ("activity_id")
      REFERENCES "activity_type"("activity_id")
	  	ON DELETE RESTRICT
);

CREATE TABLE "planned_activity" (
  "instance_id" INT NOT NULL,
  "activity_id" INT NOT NULL,
  "planned_hours" DECIMAL(6, 2) NOT NULL DEFAULT 0,
  PRIMARY KEY ("instance_id", "activity_id"),
  CONSTRAINT "FK_planned_activity_activity_id"
    FOREIGN KEY ("activity_id")
      REFERENCES "activity_type"("activity_id")
	  	ON DELETE RESTRICT,
  CONSTRAINT "FK_planned_activity_instance_id"
    FOREIGN KEY ("instance_id")
      REFERENCES "course_instance"("instance_id")
	  	ON DELETE CASCADE
);

CREATE TABLE "skill_type" (
  "skill_id" SERIAL,
  "skill_name" VARCHAR(100) NOT NULL UNIQUE,
  PRIMARY KEY ("skill_id")
);

CREATE TABLE "employee_skill" (
  "skill_id" INT NOT NULL,
  "emp_id" INT NOT NULL,
  PRIMARY KEY ("skill_id", "emp_id"),
  CONSTRAINT "FK_employee_skill_skill_id"
    FOREIGN KEY ("skill_id")
      REFERENCES "skill_type"("skill_id")
	  	ON DELETE CASCADE,
  CONSTRAINT "FK_employee_skill_emp_id"
    FOREIGN KEY ("emp_id")
      REFERENCES "employee"("emp_id")
	  	ON DELETE CASCADE
);

CREATE TABLE "system_config" (
  "rule_name" VARCHAR(50),
  "rule_value" VARCHAR(255) NOT NULL,
  "description" TEXT,
  PRIMARY KEY ("rule_name")
);

CREATE TABLE "employee_email" (
  "emp_id" INT NOT NULL,
  "email_address" VARCHAR(100) NOT NULL,
  PRIMARY KEY ("emp_id", "email_address"),
  CONSTRAINT "FK_employee_email_emp_id"
    FOREIGN KEY ("emp_id")
      REFERENCES "employee"("emp_id")
	  	ON DELETE CASCADE
);

CREATE TABLE "employee_phone" (
  "emp_id" INT NOT NULL,
  "phone_number" VARCHAR(20) NOT NULL,
  PRIMARY KEY ("emp_id", "phone_number"),
  CONSTRAINT "FK_employee_phone_emp_id"
    FOREIGN KEY ("emp_id")
      REFERENCES "employee"("emp_id")
	  	ON DELETE CASCADE
);

ALTER TABLE "department"
  ADD CONSTRAINT "FK_dept_manager" 
  	FOREIGN KEY ("manager_id") 
	  REFERENCES "employee"("emp_id") 
	  	ON DELETE RESTRICT




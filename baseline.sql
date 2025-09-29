-- V001__baseline.sql
-- Baseline schema for exam seating
-- Uses MySQL8+ collation utf8mb4_0900_ai_ci. If you have MySQL 5.7, change collation to utf8mb4_general_ci

-- enforce strict mode for session
SET SESSION sql_mode = 'STRICT_ALL_TABLES';

SET SESSION foreign_key_checks = 1;

CREATE DATABASE IF NOT EXISTS exam_seating
  CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;

USE exam_seating;

-- MASTER / LOOKUP TABLES
CREATE TABLE departments (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE semesters (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    department_id BIGINT UNSIGNED NOT NULL,
    title VARCHAR(100) NOT NULL,
    code VARCHAR(50) NOT NULL UNIQUE,
    exam_date DATE NOT NULL,
    CONSTRAINT fk_semesters_department FOREIGN KEY (department_id)
       REFERENCES departments(id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- STUDENTS
CREATE TABLE students (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    semester_id BIGINT UNSIGNED NOT NULL,
    roll_no VARCHAR(50) NOT NULL UNIQUE,
    full_name VARCHAR(150) NOT NULL,
    seat_pref VARCHAR(20) NULL,
    CONSTRAINT fk_students_semester FOREIGN KEY (semester_id)
       REFERENCES semesters(id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE INDEX idx_students_semester_id ON students(semester_id);

-- ROOMS
CREATE TABLE rooms (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(50) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    capacity INT NOT NULL,
    rows INT NOT NULL,
    cols INT NOT NULL
) ENGINE=InnoDB;

-- SEATING PLANS
CREATE TABLE seating_plans (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    plan_date DATE NOT NULL,
    created_by VARCHAR(100) NOT NULL,
    status ENUM('draft','active','archived') NOT NULL DEFAULT 'draft'
) ENGINE=InnoDB;

-- ALLOCATED SEATS (one row/col per seat assignment)
CREATE TABLE allocated_seats (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    plan_id BIGINT UNSIGNED NOT NULL,
    room_id BIGINT UNSIGNED NOT NULL,
    seat_row INT NOT NULL,
    seat_col INT NOT NULL,
    student_id BIGINT UNSIGNED NOT NULL,
    CONSTRAINT fk_allocated_plan FOREIGN KEY (plan_id)
       REFERENCES seating_plans(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_allocated_room FOREIGN KEY (room_id)
       REFERENCES rooms(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_allocated_student FOREIGN KEY (student_id)
       REFERENCES students(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    UNIQUE KEY uq_plan_room_seat (plan_id, room_id, seat_row, seat_col)
) ENGINE=InnoDB;

CREATE INDEX idx_allocated_plan_id ON allocated_seats(plan_id);
CREATE INDEX idx_allocated_room_id ON allocated_seats(room_id);

CREATE INDEX idx_semesters_exam_date ON semesters(exam_date);

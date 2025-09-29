-- V002__seed_data.sql
USE exam_seating;

-- Departments
INSERT INTO departments (name) VALUES
('Computer Science'),
('Electrical Engineering'),
('Business Administration'),
('Software Engineering');

-- Semesters
INSERT INTO semesters (department_id, title, code, exam_date) VALUES
(1, 'BSCS - Semester 1', 'CS-1', '2025-10-15'),
(1, 'BSCS - Semester 3', 'CS-3', '2025-10-15'),
(2, 'EE - Semester 1', 'EE-1', '2025-10-15'),
(3, 'BBA - Semester 5', 'BBA-5', '2025-10-15'),
(4, 'SE - Semester 2', 'SE-2', '2025-10-16');

-- Students
INSERT INTO students (semester_id, roll_no, full_name, seat_pref) VALUES
(1, 'CS-001', 'Ali Khan', NULL),
(1, 'CS-002', 'Ayesha Ahmed', 'Front'),
(1, 'CS-003', 'Zain Raza', NULL),
(1, 'CS-004', 'Mariam Noor', 'Aisle'),
(2, 'CS-101', 'Bilal Hussain', NULL),
(2, 'CS-102', 'Fatima Zahra', 'Back'),
(2, 'CS-103', 'Sadia Iqbal', NULL),
(3, 'EE-001', 'Usman Khalid', NULL),
(3, 'EE-002', 'Hira Baloch', 'Middle'),
(3, 'EE-003', 'Tariq Mehmood', NULL),
(4, 'BBA-501', 'Sara Malik', NULL),
(4, 'BBA-502', 'Hamza Tariq', 'Front'),
(5, 'SE-201', 'Noor Jahan', NULL),
(5, 'SE-202', 'Omar Farooq', NULL);

-- Rooms
INSERT INTO rooms (code, name, capacity, rows, cols) VALUES
('R-101', 'Main Hall', 100, 10, 10),
('R-102', 'Seminar Room', 40, 5, 8),
('R-201', 'Computer Lab A', 30, 5, 6);

-- Seating Plan
INSERT INTO seating_plans (title, plan_date, created_by, status) VALUES
('Midterm Exam (Oct 2025)', '2025-10-10', 'admin', 'draft');

-- Allocated seats (example assignments)
-- NOTE: These assume the student ids are the ones auto-assigned (starting at 1).
INSERT INTO allocated_seats (plan_id, room_id, seat_row, seat_col, student_id) VALUES
(1, 1, 1, 1, 1),
(1, 1, 1, 2, 2),
(1, 1, 1, 3, 3),
(1, 1, 2, 1, 5),
(1, 1, 2, 2, 6),
(1, 2, 1, 1, 8),
(1, 2, 1, 2, 9),
(1, 3, 1, 1, 13);


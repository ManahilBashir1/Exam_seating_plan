-- V003__views_and_validation.sql
USE exam_seating;

-- View: room usage (allocated seats per room per plan)
CREATE OR REPLACE VIEW v_room_usage AS
SELECT
  sp.id AS plan_id,
  r.id AS room_id,
  r.code AS room_code,
  r.name AS room_name,
  r.capacity,
  COUNT(a.id) AS allocated_seats,
  (r.capacity - COUNT(a.id)) AS remaining_capacity
FROM rooms r
LEFT JOIN allocated_seats a ON r.id = a.room_id
LEFT JOIN seating_plans sp ON a.plan_id = sp.id
GROUP BY sp.id, r.id;

-- Procedure: validate_plan(p_plan_id)
-- Checks (a) any room over capacity, (b) any adjacent seat pairs assigned to students from same semester.
DELIMITER //
CREATE PROCEDURE validate_plan(IN p_plan_id BIGINT)
BEGIN
  -- 1) Rooms exceeding capacity
  SELECT
    r.id AS room_id, r.code AS room_code, r.capacity,
    COUNT(a.id) AS used
  FROM rooms r
  JOIN allocated_seats a ON r.id = a.room_id
  WHERE a.plan_id = p_plan_id
  GROUP BY r.id
  HAVING used > r.capacity;

  -- 2) Adjacency violations (orthogonal neighbours only)
  -- We define adjacency as seats that share a side: (row +/-1, same col) OR (same row, col +/-1)
  SELECT
    a.id AS seat_a_id, a.room_id, a.seat_row AS row_a, a.seat_col AS col_a,
    sa.full_name AS student_a, sA.semester_id AS semA,
    b.id AS seat_b_id, b.seat_row AS row_b, b.seat_col AS col_b,
    sb.full_name AS student_b, sB.semester_id AS semB
  FROM allocated_seats a
  JOIN allocated_seats b
    ON a.plan_id = b.plan_id
   AND a.room_id = b.room_id
   AND ((a.seat_row = b.seat_row AND ABS(a.seat_col - b.seat_col) = 1)
     OR (a.seat_col = b.seat_col AND ABS(a.seat_row - b.seat_row) = 1))
  JOIN students sa ON a.student_id = sa.id
  JOIN students sb ON b.student_id = sb.id
  JOIN semesters sA ON sa.semester_id = sA.id
  JOIN semesters sB ON sb.semester_id = sB.id
  WHERE a.plan_id = p_plan_id
    AND a.id < b.id               -- avoid duplicate pair rows (A-B and B-A)
    AND sA.id = sB.id;            -- same semester -> violation
END //
DELIMITER ;

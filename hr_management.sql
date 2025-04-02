-- Create Database
CREATE DATABASE hr_management_db;
USE hr_management_db;

-- Create Employees table
CREATE TABLE employees (
    emp_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    hire_date DATE NOT NULL
);

-- Create Attendance table
CREATE TABLE attendance (
    attendance_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_id INT,
    date DATE,
    status ENUM('Present', 'Absent', 'Late') DEFAULT 'Present',
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id) ON DELETE CASCADE
);

-- Create Salary_History table
CREATE TABLE salary_history (
    salary_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_id INT,
    salary_amount DECIMAL(10,2),
    effective_date DATE,
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id) ON DELETE CASCADE
);

-- Create Leave_Records table
CREATE TABLE leave_records (
    leave_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_id INT,
    leave_type ENUM('Sick', 'Vacation', 'Personal') NOT NULL,
    start_date DATE,
    end_date DATE,
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id) ON DELETE CASCADE
);

-- Insert Sample Data into Employees
INSERT INTO employees (first_name, last_name, email, hire_date) VALUES
('John', 'Smith', 'john.smith@company.com', '2023-01-15'),
('Mary', 'Johnson', 'mary.j@company.com', '2022-06-01'),
('Peter', 'Brown', 'peter.b@company.com', '2023-03-10');

-- Insert Sample Data into Attendance
INSERT INTO attendance (emp_id, date, status) VALUES
(1, '2025-04-01', 'Present'),
(2, '2025-04-01', 'Late'),
(3, '2025-04-01', 'Absent');

-- Insert Sample Data into Salary_History
INSERT INTO salary_history (emp_id, salary_amount, effective_date) VALUES
(1, 60000.00, '2023-01-15'),
(2, 65000.00, '2022-06-01'),
(3, 55000.00, '2023-03-10');

-- Insert Sample Data into Leave_Records
INSERT INTO leave_records (emp_id, leave_type, start_date, end_date) VALUES
(1, 'Vacation', '2025-04-10', '2025-04-15'),
(2, 'Sick', '2025-03-20', '2025-03-22'),
(3, 'Personal', '2025-04-05', '2025-04-06');

-- Create Procedure to Delete Employee and Associated Data
DELIMITER //
CREATE PROCEDURE delete_employee(IN p_emp_id INT)
BEGIN
    -- CASCADE will handle deletion of related records
    DELETE FROM employees WHERE emp_id = p_emp_id;
    
    IF ROW_COUNT() > 0 THEN
        SELECT CONCAT('Employee ', p_emp_id, ' and all associated data deleted successfully') AS message;
    ELSE
        SELECT CONCAT('Employee ', p_emp_id, ' not found') AS message;
    END IF;
END //
DELIMITER ;

-- Example Usage
-- View data before deletion
SELECT * FROM employees;
SELECT * FROM attendance;
SELECT * FROM salary_history;
SELECT * FROM leave_records;

-- Delete employee with ID 1
CALL delete_employee(1);

-- View data after deletion
SELECT * FROM employees;
SELECT * FROM attendance;
SELECT * FROM salary_history;
SELECT * FROM leave_records;

-- Optional: Clean up (uncomment to drop tables)
-- DROP TABLE leave_records;
-- DROP TABLE salary_history;
-- DROP TABLE attendance;
-- DROP TABLE employees;
-- DROP DATABASE hr_management_db;

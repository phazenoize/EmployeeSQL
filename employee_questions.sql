--Before creating the tables, if there are those that have the same name, they will be dropped.
--Primary and foreign keys set based on relations to other databases

DROP TABLE IF EXISTS departments;
CREATE TABLE departments (
    dept_no VARCHAR(10) primary key not null,
    dept_name VARCHAR(50)
);

DROP TABLE IF EXISTS dept_emp;
CREATE TABLE dept_emp (
	emp_no int not null,
	dept_no VARCHAR(10) not null,
    foreign key (emp_no) references employees (emp_no),
    foreign key (dept_no) references departments (dept_no)
);

DROP TABLE IF EXISTS dept_manager;
CREATE TABLE dept_manager (
	emp_no int not null,
	dept_no VARCHAR(10) not null,
    foreign key (dept_no) references departments (dept_no),
    foreign key (emp_no) references employees (emp_no)
);

DROP TABLE IF EXISTS employees;
CREATE TABLE employees (
    emp_no int primary key not null,
    emp_title VARCHAR(10) not null,
	birth_date DATE not null,
	first_name VARCHAR(20) not null,
	last_name VARCHAR(20)not null,
	sex VARCHAR(1) not null,
	hire_date DATE not null
);

DROP TABLE IF EXISTS salaries;
CREATE TABLE salaries (
	emp_no int not null,
    foreign key (emp_no) references employees (emp_no),
    salary int
);

DROP TABLE IF EXISTS titles;
CREATE TABLE titles (
    title_id VARCHAR(10),
    title VARCHAR(30)
);

--List the employee number, last name, first name, sex, and salary of each employee.
SELECT e.emp_no, e.last_name, e.first_name, e.sex, s.salary
FROM employees AS e
JOIN salaries AS s ON e.emp_no = s.emp_no;

--List the first name, last name, and hire date for the employees who were hired in 1986.
SELECT first_name, last_name, hire_date
FROM employees
WHERE EXTRACT(YEAR FROM hire_date) = 1986;

--List the manager of each department along with their department number, department name, employee number, last name, and first name.
SELECT
    d.dept_no AS department_number,
    d.dept_name AS department_name,
    dm.emp_no AS manager_employee_number,
    e.last_name AS manager_last_name,
    e.first_name AS manager_first_name
FROM departments AS d
JOIN dept_manager AS dm ON d.dept_no = dm.dept_no
JOIN employees AS e ON dm.emp_no = e.emp_no;

--List the department number for each employee along with that employee’s employee number, last name, first name, and department name.
SELECT e.emp_no, e.last_name, e.first_name, de.dept_no, d.dept_name
FROM employees AS e
JOIN dept_emp AS de ON e.emp_no = de.emp_no
JOIN departments AS d ON de.dept_no = d.dept_no;

--List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B.
SELECT first_name, last_name, sex
FROM employees
WHERE first_name = 'Hercules' AND last_name LIKE 'B%';

--List each employee in the Sales department, including their employee number, last name, and first name.
SELECT e.emp_no, e.last_name, e.first_name
FROM employees AS e
JOIN dept_emp AS de ON e.emp_no = de.emp_no
JOIN departments AS d ON de.dept_no = d.dept_no
WHERE d.dept_name = 'Sales';

--List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name.
SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
FROM employees AS e
JOIN dept_emp AS de ON e.emp_no = de.emp_no
JOIN departments AS d ON de.dept_no = d.dept_no
WHERE d.dept_name IN ('Sales', 'Development');

--List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name).
SELECT last_name, COUNT(*) AS frequency
FROM employees
GROUP BY last_name
ORDER BY frequency DESC, last_name;
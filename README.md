# 🎓 Academic Record Management System

📌 **Project Overview**

The Academic Record Management System is a **SQL-based database project** that manages students, instructors, departments, courses, and tuition. It also includes a **Book Download Subsystem** to demonstrate many-to-many relationships in a simplified use case.

This project showcases:

* **Database design (ERD)** with academic and library subsystems
* **Essential SQL queries** for analytics and reporting
* **Advanced SQL features**: views, functions, procedures, triggers, cursors, transactions
* **Real-world use cases** such as tuition calculation, workload analysis, and department management

---

## 📂 Repository Contents

* **Academic_Record_Management_System_ERD.sql** → Schema definitions for all entities
* **Academic_Record_Management_System.sql** → SQL scripts including queries, business logic, and advanced features

---

## 🔄 Database Workflow

### **1. Academic Record Schema**

* **Departments** → Department info and chairman
* **Instructors** → Personal info, hire date, salary, department assignment
* **Courses** → Course details, units, linked to department and instructor
* **Students** → Student details with enrollment and graduation dates
* **Tuition** → Stores cost rules (part-time, full-time, per-unit)
* **StudentCourses** → Associative entity to link students ↔ courses

### **2. Book Download Subsystem**

* **Users** → User details
* **Books** → Book catalog
* **Downloads** → Tracks many-to-many relationships (users ↔ books)

---

## 🛠 Features

### **Essential Queries**

* Students with last names A–K
* Instructors hired in 2022
* Students’ months attended
* Top 20% instructors by salary
* Tuition calculations (per unit vs full-time)
* Graduated vs undergrad students
* Department statistics (instructors, max salary)
* Workload analysis (course units per instructor/student)

### **Advanced SQL Features**

* **Views**

  * `DepartmentInstructors` → instructors grouped by department
  * `StudentCoursesMin` / `StudentCoursesSummary` → student enrollments and summaries
* **Stored Procedures**

  * `spInsertDepartment` → safely insert new departments
  * `spInsertInstructor` → validates salary before inserting
* **Functions**

  * `fnStudentUnits` → returns total course units per student
  * `fnTuition` → calculates tuition dynamically
* **Triggers**

  * `Instructors_UPDATE` → enforces salary rules on update
* **Other**

  * CTEs for tuition status
  * Cursors for enrollment monitoring
  * Transactions for safe multi-step operations

---

## 📊 Reports & Analytics

The system supports:

* Tuition by student status (part-time vs full-time)
* Instructor salary and workload analysis
* Course enrollments by student
* Departmental salary distributions
* Recruitment-style checks (graduation vs enrollment status)
* Book downloads by user

---

## 📈 Applications

* 🎓 **Universities & Colleges** → Academic record and tuition management
* 📚 **Libraries** → Book borrowing and download tracking
* 🏫 **Education Institutes** → Instructor workload and course assignments
* 📊 **Analytics Teams** → Insights into enrollments, teaching loads, and costs

---

## 🛠️ Tools & Technologies

* **SQL Server / Azure SQL Database**
* **T-SQL** (DDL, DML, Views, Procedures, Triggers, Functions, Cursors, Transactions)
* **ERD Modeling** for relational design

---



# 🎓 Academic Record Management System

📌 **Project Overview**

This project demonstrates how academic data can be efficiently managed using **SQL database design and advanced querying techniques**. The system models entities like students, instructors, departments, and academic activity, while also implementing **views, stored procedures, and triggers** for realistic database functionality.

Instead of focusing only on schema creation, this project highlights the **practical SQL skills** required to manage and analyze academic records.

---

## 📂 Repository Contents

* **Academic_Record_Management_System_ERD.sql** → Schema definition for the database (Users, Books, Downloads as practice schema)
* **Academic_Record_Management_System.sql** → Collection of SQL queries, advanced operations, and constraints (students, instructors, departments)

---

## 🔄 Database Workflow

### **Database Setup**

* Creation of relational schema (`Users`, `Books`, `Downloads`)
* Primary keys, foreign keys, and indexing for performance

### **Essential Queries**

* Retrieve student full names (A–K last names)
* List instructors hired in a given year
* Calculate months attended by each student
* Identify top 20% highest-paid instructors
* Find active (non-graduated) students

### **Advanced SQL Features**

* **View**: `DepartmentInstructors` → maps instructors to their departments
* **Stored Procedure**: `spInsertDepartment` → safely inserts new departments
* **Trigger**: Enforces salary rules (valid range & adjustments)

---

## 📊 Key Learning Outcomes

### **Database KPIs**

* Well-structured ERD with normalized relations
* Indexed queries for faster lookups
* Use of DDL (schema) + DML (queries) in tandem

### **Advanced SQL KPIs**

* Data integrity maintained via triggers
* Scalability through stored procedures
* Query optimization using indexes

---

## 📈 Applications

* 🎓 **Universities** → Manage students, instructors, and courses
* 🏫 **Colleges** → Track enrollments and faculty details
* 📚 **Libraries** → Adapt schema for book-user interactions
* 🏢 **Corporate Training** → Record training sessions, instructors, and learners

---

## 🛠️ Tools & Technologies

* **SQL Server / Azure SQL Database** → Execution environment
* **T-SQL** → Querying, procedures, and triggers
* **ERD Design** → Database normalization and schema modeling

---

# 🎓 Academic Record Management System

An end-to-end SQL project demonstrating **academic data management**, including database schema design, student/instructor queries, and advanced SQL features like **views, stored procedures, and triggers**.

---

## 📂 Project Structure

* **`Project 1 _ ERD.sql`** → Database schema for **MyBookDB** (Users, Books, Downloads).
* **`Project 1.sql`** → SQL queries & advanced functionality for managing **students, instructors, and departments**.

---

## 🛠 Features

### **Database Schema (ERD)**

✅ Clean relational design with:

* 👤 **Users** – stores user information
* 📖 **Books** – catalog of available books
* ⬇️ **Downloads** – tracks who downloads what

*(Acts as a practice schema to simulate academic datasets)*

---

### **Core SQL Functionality**

* 🔎 **Data Queries**

  * Students with last names A–K
  * Instructors hired in 2022
  * Months attended by each student
  * Top 20% highest-paid instructors
  * Active students (not yet graduated)

* 📊 **Advanced Features**

  * **Views**: `DepartmentInstructors` – instructors grouped by department
  * **Stored Procedure**: `spInsertDepartment` – safe department creation
  * **Trigger**: Salary validation & enforcement

---

## ▶️ Getting Started

1. Clone the repository:

   ```bash
   git clone https://github.com/your-username/academic-record-management-system.git
   ```

2. Run the schema setup:

   ```sql
   -- Execute Project 1 _ ERD.sql
   ```

3. Execute the SQL exercises:

   ```sql
   -- Run Project 1.sql
   ```

---

## 📋 Requirements

* Microsoft SQL Server / Azure SQL Database
* Familiarity with SQL concepts (DDL, DML, Views, Procedures, Triggers)

---


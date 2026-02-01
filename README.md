# 🚆 Online Railway Booking System

A role-based railway reservation web application built using **JSP**, **JDBC**, and **MySQL**.  
The system supports **Customers**, **Customer Representatives**, and **Administrators**, each with dedicated dashboards and workflows.

This project demonstrates relational database design, SQL joins and aggregations, session-based authentication, and multi-role system functionality.

---

## 👑 Admin Functionalities

Administrators have full control over system configuration, users, and analytics.

- Admin dashboard for centralized access
- Manage customer representatives
  - Add representatives
  - Edit representative details
  - Delete representatives
- Manage train schedules
  - Create new schedules
  - Update existing schedules
  - Delete schedules
- View all reservations in the system
- Generate analytical and revenue reports:
  - Best customer by total revenue
  - Revenue by customer
  - Revenue by transit line
  - Reservations grouped by transit line
  - Top transit lines
  - Train schedules by station

---

## 🧑‍💼 Customer Representative Functionalities

Customer representatives act as the support interface for users.

- Dedicated customer representative dashboard
- View customer-submitted questions
- Reply to customer inquiries via the message center

---

## 👤 Customer Functionalities

Customers can search for trains, manage bookings, and communicate with support.

- User registration and login
- Search trains using:
  - Transit line
  - Station
  - Keywords
- View train schedules and stops
- Make reservations
- Confirm reservations
- Cancel reservations
- View reservation history
- Browse FAQs
- Submit questions to customer representatives

---

## 🧠 Project Tech Stack

- **Frontend**: JSP, HTML, CSS  
- **Backend**: Java, JDBC  
- **Database**: MySQL  
- **Server**: Apache Tomcat  
- **Architecture**: Role-based JSP web application with session management

---

## ⚙️ Project Setup & Run Instructions

### Prerequisites

Ensure the following are installed on your system:

- Java JDK 8 or higher (recommended: Java 11)
- MySQL 8+
- Apache Tomcat 9+
- Git
- IDE (optional but recommended): Eclipse

---

### Step 1: Clone the Repository
```bash
git clone https://github.com/<your-username>/online-railway-booking-system.git
cd online-railway-booking-system
```

---

### Step 2: Create and Configure the Database
Create the database:
```bash
CREATE DATABASE railway_booking_system;
```

Import the schema:

```bash
mysql -u root -p railway_booking_system < database_schema.sql
```

This step creates all required tables, relationships, and constraints.

---

### Step 3: Configure Database Connection
In the file DatabaseConnection.java, update the MySQL connection details:

```bash
String url = "jdbc:mysql://localhost:3306/railway_booking_system";
String username = "root";
String password = "your_password";
```

---

### Step 4: Deploy the Application on Apache Tomcat

**Using an IDE (Eclipse)**

Import the project as a Dynamic Web Project
1. Configure Apache Tomcat as the server
2. Add the project to the server
3. Start the server

---

### Step 5: Access the Application

Open a web browser and navigate to:
```bash
http://localhost:8080/<project-name>/login.html
```

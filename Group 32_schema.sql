-- Create the database
CREATE DATABASE railway_booking_system;
USE railway_booking_system;

-- Trains Table
CREATE TABLE trains (
    train_id INT PRIMARY KEY AUTO_INCREMENT,
    train_name VARCHAR(255) NOT NULL UNIQUE,
    transit_line_name VARCHAR(255) NOT NULL -- Name of the transit line (e.g., "Northeast Corridor")
);

-- Stations Table
CREATE TABLE stations (
    station_id INT PRIMARY KEY AUTO_INCREMENT,
    station_name VARCHAR(255) NOT NULL UNIQUE,
    city VARCHAR(255) NOT NULL,
    state VARCHAR(255) NOT NULL
);

-- Train Schedules Table
CREATE TABLE train_schedules (
    schedule_id INT PRIMARY KEY AUTO_INCREMENT,
    transit_line_name VARCHAR(100) NOT NULL,
    train_id INT NOT NULL,
    origin_station_id INT NOT NULL,
    destination_station_id INT NOT NULL,
    departure_datetime DATETIME NOT NULL,
    arrival_datetime DATETIME NOT NULL,
    fare DOUBLE NOT NULL, -- Fare for the entire route
    num_stops INT NOT NULL,
    FOREIGN KEY (train_id) REFERENCES trains(train_id),
    FOREIGN KEY (origin_station_id) REFERENCES stations(station_id),
    FOREIGN KEY (destination_station_id) REFERENCES stations(station_id)
);


-- Stops Table
CREATE TABLE stops (
    stop_id INT PRIMARY KEY AUTO_INCREMENT,
    schedule_id INT NOT NULL,
    station_id INT NOT NULL,
    arrival_time DATETIME NOT NULL,
    departure_time DATETIME NOT NULL,
    stop_order INT NOT NULL, -- The order of the stop in the route
    FOREIGN KEY (schedule_id) REFERENCES train_schedules(schedule_id),
    FOREIGN KEY (station_id) REFERENCES stations(station_id)
);

CREATE TABLE roles (
    role_id INT PRIMARY KEY AUTO_INCREMENT,
    role_name ENUM('Customer', 'Admin', 'CustomerRep') NOT NULL
);

-- Users Tableusers
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role_id INT NOT NULL, -- Link to the roles table
    FOREIGN KEY (role_id) REFERENCES roles(role_id)
);

-- Customers Table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Employees Table
CREATE TABLE employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    role_id INT NOT NULL, -- Role ID added as a foreign key
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    ssn VARCHAR(15) NOT NULL UNIQUE, -- Social Security Number, unique constraint
    email VARCHAR(100) NOT NULL UNIQUE, -- Email, unique constraint
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (role_id) REFERENCES roles(role_id) -- Reference to roles table
);

-- Reservations Table
CREATE TABLE reservations (
    reservation_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    schedule_id INT NOT NULL,
    origin_station_id INT NOT NULL,
    destination_station_id INT NOT NULL,
    trip_type ENUM('One-Way', 'Round-Trip') NOT NULL,
    num_adults INT NOT NULL,
    num_children INT NOT NULL,
    total_fare DOUBLE NOT NULL,
    num_seniors INT NOT NULL,
    num_disabled INT NOT NULL,
    reservation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_cancelled BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (schedule_id) REFERENCES train_schedules(schedule_id),
    FOREIGN KEY (origin_station_id) REFERENCES stations(station_id),
    FOREIGN KEY (destination_station_id) REFERENCES stations(station_id)
);

CREATE TABLE discounts (
    discount_id INT PRIMARY KEY AUTO_INCREMENT,
    discount_type ENUM('None', 'Child', 'Senior', 'Disabled') NOT NULL,
    discount_rate DOUBLE NOT NULL -- E.g., 0.25 for 25%
);

CREATE TABLE railwayFAQs (
    faq_id INT AUTO_INCREMENT PRIMARY KEY,
    question TEXT NOT NULL,
    answer TEXT NOT NULL
);

CREATE TABLE customer_questions (
    question_id INT AUTO_INCREMENT PRIMARY KEY,
    question TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    customer_id INT NOT NULL,
    reply TEXT
);

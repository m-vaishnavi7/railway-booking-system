package com.railway.db;

import java.sql.Connection;
import java.sql.DriverManager;

public class DatabaseConnection {
    public static Connection initializeDatabase() throws Exception {
        String url = "jdbc:mysql://localhost:3306/railway_booking_system"; // Database name
        String username = "root"; // Your DB username
        String password = "sql@1234"; // Your DB password

        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(url, username, password);
    }
}

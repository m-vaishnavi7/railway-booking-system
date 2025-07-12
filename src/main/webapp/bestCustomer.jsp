<%@ page import="java.sql.*, com.railway.db.DatabaseConnection" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Best Customer</title>
    <link href="https://fonts.googleapis.com/css?family=Cormorant+Garamond|Cormorant+SC:300,500" rel="stylesheet">
    <link rel="stylesheet" href="assets/style.css">
</head>
<body>
	<header class="header">
        <div class="container">
            <h1 class="site-title">Online Railway Booking System</h1>
            <nav class="navbar">
            	<a href="javascript:history.back()">Back</a>
                <a href="adminDashboard.jsp">Home</a>
                <a href="logout.jsp">Logout</a>
            </nav>
        </div>
    </header>
    <section class="hero">
        <div class="container">
            <p class="hero-title">Best Customer</p>
        </div>
    </section>

    <section class="dashboard-section">
    	<div class="dashboard-card">
            <p class="hero-title">Top Revenue-Generating Customer</p>
        <%
            Connection conn = null;
            PreparedStatement ps = null;
            ResultSet rs = null;

            try {
                conn = DatabaseConnection.initializeDatabase();
                String query = "SELECT CONCAT(C.first_name, ' ', C.last_name) AS CustomerName, SUM(R.total_fare) AS TotalRevenue " +
                               "FROM reservations R " +
                               "JOIN customers C ON R.customer_id = C.customer_id " +
                               "WHERE R.is_cancelled = FALSE " +
                               "GROUP BY C.customer_id " +
                               "ORDER BY TotalRevenue DESC " +
                               "LIMIT 1";
                ps = conn.prepareStatement(query);
                rs = ps.executeQuery();

                if (rs.next()) {
        %>
        <p class="hero-subtitle"><strong>Customer Name:</strong> <%= rs.getString("CustomerName") %></p>
        <p class="hero-subtitle"><strong>Total Revenue:</strong> $<%= rs.getDouble("TotalRevenue") %></p>
        <%
                } else {
        %>
        <p class="error">No data available.</p>
        <%
                }
            } catch (Exception e) {
                e.printStackTrace();
        %>
        <p class="error">An error occurred while retrieving data. Please try again later.</p>
        <%
            } finally {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            }
        %>
    </div>
    </section>
</body>
</html>

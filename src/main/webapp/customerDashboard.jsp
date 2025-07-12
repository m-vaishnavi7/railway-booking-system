<%@ page import="java.sql.*, java.util.*, com.railway.db.DatabaseConnection" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Dashboard</title>
    <link href="https://fonts.googleapis.com/css?family=Cormorant+Garamond|Cormorant+SC:300,500" rel="stylesheet">
    <link rel="stylesheet" href="assets/style.css">
</head>
<body>
	<%
        // Retrieve session attributes
        String username = (String) session.getAttribute("username");
        Integer customerId = (Integer) session.getAttribute("customerId");
        String role = (String) session.getAttribute("role");

        if (username == null || customerId == null || role == null) {
            response.sendRedirect("login.html");
            return;
        }

        // Fetch additional customer details
        String firstName = "";
        String lastName = "";
        String email = "";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DatabaseConnection.initializeDatabase();

            ps = conn.prepareStatement("SELECT first_name, last_name, email FROM customers WHERE customer_id = ?");
            ps.setInt(1, customerId);
            rs = ps.executeQuery();

            if (rs.next()) {
                firstName = rs.getString("first_name");
                lastName = rs.getString("last_name");
                email = rs.getString("email");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        }
    %>
    <header class="header">
        <div class="container">
            <h1 class="site-title">Online Railway Booking System</h1>
            <nav class="navbar">
                <a href="customerDashboard.jsp">Home</a>
                <a href="logout.jsp">Logout</a>
            </nav>
        </div>
    </header>
    

    <section class="hero">
        <div class="container">
            <p class="hero-title">Customer Dashboard</p>
            <p class="hero-subtitle">Welcome, <%= firstName %>! Explore your bookings, manage your account, and more.</p>
        </div>
    </section>

    <section class="dashboard-section">
        <div class="container">
            <div class="dashboard-card">
                <div class="actions">
                    <a href="searchTrains.jsp" class="button">Search Trains</a>
                    <a href="viewReservations.jsp" class="button">View Bookings</a>
                    <a href="searchbykeywords.jsp" class="button">FAQs</a>
                    <a href="messageCenter.jsp" class="button">Contact Support </a>
                </div>
            </div>
        </div>
    </section>

    <footer class="footer">
        <div class="container">
            <p>&copy; 2024 Online Railway Booking System. All rights reserved.</p>
        </div>
    </footer>
</body>
</html>

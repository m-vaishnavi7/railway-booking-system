<%@ page import="java.sql.*, java.util.*, com.railway.db.DatabaseConnection" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard</title>
    <link href="https://fonts.googleapis.com/css?family=Cormorant+Garamond|Cormorant+SC:300,500" rel="stylesheet">
    <link rel="stylesheet" href="assets/style.css">
</head>
<body>
    <%
        // Retrieve session attributes
        String username = (String) session.getAttribute("username");
        String role = (String) session.getAttribute("role");
        Integer employeeId = (Integer) session.getAttribute("employeeId");

        if (username == null || !"Admin".equals(role)) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        // Fetch additional admin details
        String firstName = "";
        String lastName = "";
        String email = "";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DatabaseConnection.initializeDatabase();

            ps = conn.prepareStatement("SELECT first_name, last_name, email FROM employees WHERE employee_id = ?");
            ps.setInt(1, employeeId);
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
                <a href="adminDashboard.jsp">Home</a>
                <a href="logout.jsp">Logout</a>
            </nav>
        </div>
    </header>
    <section class="hero">
        <div class="container">
            <p class="hero-title">Admin Dashboard</p>
        </div>
    </section>
    
    <section class="dashboard-section">
        <div class="container">
            <div class="dashboard-card">
                <div class="actions">
                    <a href="manageCustomerReps.jsp" class="button">Manage Customer Representatives</a>
		            <a href="generateSalesReport.jsp" class="button">Sales Reports</a>
		            <a href="adminViewReservations.jsp" class="button">View Reservations</a>
		            <a href="revenueReportsByTransitLine.jsp" class="button">Revenue Reports by Transit Line</a>
		            
                </div>
                <br/>
                <br/>
                <div class="actions">
		            <a href="revenueReportsByCustomer.jsp" class="button">Revenue Reports by Customer</a>
		            <a href="bestCustomer.jsp" class="button">Best Customers</a>
		            <a href="topTransitLines.jsp" class="button">Top Transit Lines</a>
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

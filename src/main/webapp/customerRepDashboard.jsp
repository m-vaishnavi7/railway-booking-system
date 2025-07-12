<%@ page import="java.sql.*, com.railway.db.DatabaseConnection" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Representative Dashboard</title>
    <link href="https://fonts.googleapis.com/css?family=Cormorant+Garamond|Cormorant+SC:300,500" rel="stylesheet">
    <link rel="stylesheet" href="assets/style.css">
</head>
<body>
    <%
        // Retrieve session attributes
        String username = (String) session.getAttribute("username");
        String role = (String) session.getAttribute("role");
        Integer employeeId = (Integer) session.getAttribute("employeeId");

        if (username == null || !"CustomerRep".equals(role)) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Fetch additional representative details
        String firstName = "";
        String lastName = "";
        String email = "";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DatabaseConnection.initializeDatabase();
            String query = "SELECT first_name, last_name, email FROM employees WHERE employee_id = ?";
            ps = conn.prepareStatement(query);
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
            <p class="hero-title">Customer Representative Dashboard</p>
        </div>
    </section>

    <!-- Dashboard Container -->
    <section class="dashboard-section">
        <div class="container">
        <div class="dashboard-card">
		        <!-- Dashboard Buttons -->
		        <div class="actions">
		            <a href="manageTrainSchedules.jsp" class="button">Manage Train Schedules</a>
		            <a href="trainSchedulesByStation.jsp" class="button">Schedules by Station</a>
		            <a href="reservationsByTransitLine.jsp" class="button">Reservations by Transit Line</a>
		        </div>
		        <br/>
		        <br/>
		        <div class="actions">
		            <a href="searchbykeywords.jsp" class="button">Browse Questions and Answers</a>
		            <a href="viewCustomerQuestions.jsp" class="button">Reply to Questions</a>
		        </div>
		    </div>
		</div>
	</section>
</body>
</html>

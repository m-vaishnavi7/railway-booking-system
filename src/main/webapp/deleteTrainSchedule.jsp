<%@ page import="java.sql.*, com.railway.db.DatabaseConnection" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Delete Train Schedule</title>
    <link rel="stylesheet" href="assets/style.css">
</head>
<body>
    <header class="header">
        <div class="container">
            <h1 class="site-title">Online Railway Booking System</h1>
            <nav class="navbar">
                <a href="javascript:history.back()">Back</a>
                <a href="customerRepDashboard.jsp">Home</a>
                <a href="logout.jsp">Logout</a>
            </nav>
        </div>
    </header>
    <section class="hero">
        <div class="container">
            <p class="hero-title">Delete Train Schedule</p>
        </div>
    </section>

    <div class="dashboard-section">
        <div class="dashboard-card">
<%
    int scheduleID = Integer.parseInt(request.getParameter("scheduleID"));

    Connection conn = null;
    PreparedStatement ps = null;
    String errorMessage = null;
    String successMessage = null;

    try {
        conn = DatabaseConnection.initializeDatabase();
        String deleteQuery = "DELETE FROM train_schedules WHERE schedule_id = ?";
        ps = conn.prepareStatement(deleteQuery);
        ps.setInt(1, scheduleID);
        int rowsAffected = ps.executeUpdate();

        if (rowsAffected > 0) {
            successMessage = "Train schedule deleted successfully.";
        } else {
            errorMessage = "Failed to delete the train schedule. Please try again.";
        }
    } catch (Exception e) {
        e.printStackTrace();
        errorMessage = "An error occurred. Please try again.";
    } finally {
        if (ps != null) try { ps.close(); } catch (Exception ignored) {}
        if (conn != null) try { conn.close(); } catch (Exception ignored) {}
    }
    %>
    <% if (successMessage != null) { %>
    <p style="color: green; font-weight: bold;"><%= successMessage %></p>
    <script>
        setTimeout(() => {
            window.location.href = 'manageTrainSchedules.jsp';
        }, 2000);
    </script>
<% } else if (errorMessage != null) { %>
    <p style="color: red; font-weight: bold;"><%= errorMessage %></p>
    <a href="javascript:history.back()" class="btn">Back</a>
<% } %>
        </div>
    </div>
</body>
</html>

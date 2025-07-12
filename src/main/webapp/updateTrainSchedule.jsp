<%@ page import="java.sql.*, com.railway.db.DatabaseConnection" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Train Schedule</title>
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
            <p class="hero-title">Update Train Schedule</p>
        </div>
    </section>

    <div class="dashboard-section">
        <div class="dashboard-card">
            <% 
                String errorMessage = null;
                String successMessage = null;

                if ("POST".equalsIgnoreCase(request.getMethod())) {
                    int scheduleID = Integer.parseInt(request.getParameter("scheduleID"));
                    String departure = request.getParameter("departure");
                    String arrival = request.getParameter("arrival");

                    Connection conn = null;
                    PreparedStatement ps = null;

                    try {
                        conn = DatabaseConnection.initializeDatabase();
                        String updateQuery = "UPDATE train_schedules SET departure_datetime = ?, arrival_datetime = ? WHERE schedule_id = ?";
                        ps = conn.prepareStatement(updateQuery);
                        ps.setString(1, departure.replace("T", " "));
                        ps.setString(2, arrival.replace("T", " "));
                        ps.setInt(3, scheduleID);

                        int rowsAffected = ps.executeUpdate();

                        if (rowsAffected > 0) {
                            successMessage = "Train schedule updated successfully.";
                        } else {
                            errorMessage = "Failed to update the train schedule. Please try again.";
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                        errorMessage = "An error occurred. Please try again.";
                    } finally {
                        if (ps != null) try { ps.close(); } catch (Exception ignored) {}
                        if (conn != null) try { conn.close(); } catch (Exception ignored) {}
                    }
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

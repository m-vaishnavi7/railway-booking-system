<%@ page import="java.sql.*, com.railway.db.DatabaseConnection" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Train Schedules</title>
    <link href="https://fonts.googleapis.com/css?family=Cormorant+Garamond|Cormorant+SC:300,500" rel="stylesheet">
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
            <p class="hero-title">Manage Train Schedules</p>
        </div>
    </section>
    <section class="dashboard-section">
        <div class="dashboard-card">
        <table class="results-table">
            <thead>
                <tr>
                    <th>Schedule ID</th>
                    <th>Train Name</th>
                    <th>Transit Line</th>
                    <th>Origin</th>
                    <th>Destination</th>
                    <th>Departure</th>
                    <th>Arrival</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    Connection conn = null;
                    PreparedStatement ps = null;
                    ResultSet rs = null;

                    try {
                        conn = DatabaseConnection.initializeDatabase();
                        
                        String query = "SELECT TS.schedule_id, T.train_name, T.transit_line_name, S1.station_name AS Origin, S2.station_name AS Destination, " +
                                "TS.departure_datetime, TS.arrival_datetime " +
                                "FROM train_schedules TS " +
                                "JOIN trains T ON TS.train_id = T.train_id " +
                                "JOIN stations S1 ON TS.origin_station_id = S1.station_id " +
                                "JOIN stations S2 ON TS.destination_station_id = S2.station_id " ;
                        ps = conn.prepareStatement(query);
                        rs = ps.executeQuery();

                        while (rs.next()) {
                %>
                <tr>
                
                    <td><%= rs.getInt("schedule_id") %></td>
                    <td><%= rs.getString("train_name") %></td>
                    <td><%= rs.getString("transit_line_name") %></td>
                    <td><%= rs.getString("Origin") %></td>
                    <td><%= rs.getString("Destination") %></td>
                    <td><%= rs.getString("departure_datetime") %></td>
                    <td><%= rs.getString("arrival_datetime") %></td>
                    <td>
                        <a href="editTrainSchedule.jsp?scheduleID=<%= rs.getInt("schedule_id") %>" class="edit">Edit</a><br/>
                        <a href="deleteTrainSchedule.jsp?scheduleID=<%= rs.getInt("schedule_id") %>" class="delete">Delete</a>
                    </td>
                </tr>
                <%
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                %>
                <tr>
                    <td colspan="5" class="error">An error occurred while fetching train schedules.</td>
                </tr>
                <%
                    } finally {
                        if (rs != null) rs.close();
                        if (ps != null) ps.close();
                        if (conn != null) conn.close();
                    }
                %>
            </tbody>
        </table>
    </div>
</body>
</html>

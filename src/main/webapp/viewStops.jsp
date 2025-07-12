<%@ page import="java.sql.*, com.railway.db.DatabaseConnection" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Train Stops - Online Railway Booking</title>
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@400&family=Cormorant+SC:wght@300;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="assets/style.css">
</head>
<body>
    <!-- Header Section -->
    <header class="header">
        <div class="container">
            <h1 class="site-title">Online Railway Booking System</h1>
            <nav class="navbar">
                <a href="javascript:history.back()">Back</a>
                <a href="customerDashboard.jsp">Home</a>
                <a href="logout.jsp">Logout</a>
            </nav>
        </div>
    </header>

    <!-- Train Details Section -->
    <!--  <div class="dashboard-section">
        <div class="dashboard-card">
            <p class="hero-title">Train Details<p>
            <table class="results-table">
                <thead>
                    <tr>
                        <th>Train Name</th>
                        <th>Origin</th>
                        <th>Destination</th>
                        <th>Departure</th>
                        <th>Arrival</th>
                        <th>Fare</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        String scheduleID = request.getParameter("scheduleID");

                        if (scheduleID == null || scheduleID.trim().isEmpty()) {
                    %>
                    <tr>
                        <td colspan="6">Invalid Schedule ID. Please go back and try again.</td>
                    </tr>
                    <%
                        } else {
                            Connection conn = null;
                            PreparedStatement ps = null;
                            ResultSet rs = null;

                            try {
                                conn = DatabaseConnection.initializeDatabase();

                                String query = "SELECT T.train_name, S1.station_name AS origin, S2.station_name AS destination, " +
                                               "TS.departure_datetime, TS.arrival_datetime, TS.fare " +
                                               "FROM train_schedules TS " +
                                               "JOIN trains T ON TS.train_id = T.train_id " +
                                               "JOIN stations S1 ON TS.origin_station_id = S1.station_id " +
                                               "JOIN stations S2 ON TS.destination_station_id = S2.station_id " +
                                               "WHERE TS.schedule_id = ?";

                                ps = conn.prepareStatement(query);
                                ps.setString(1, scheduleID);
                                rs = ps.executeQuery();

                                if (rs.next()) {
                    %>
                    <tr>
                        <td><%= rs.getString("train_name") %></td>
                        <td><%= rs.getString("origin") %></td>
                        <td><%= rs.getString("destination") %></td>
                        <td><%= rs.getString("departure_datetime") %></td>
                        <td><%= rs.getString("arrival_datetime") %></td>
                        <td>$<%= rs.getDouble("fare") %></td>
                    </tr>
                    <%
                                } else {
                    %>
                    <tr>
                        <td colspan="6">Train details not found for the selected schedule.</td>
                    </tr>
                    <%
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                    %>
                    <tr>
                        <td colspan="6">Error fetching train details. Please try again later.</td>
                    </tr>
                    <%
                            } finally {
                                if (rs != null) rs.close();
                                if (ps != null) ps.close();
                                if (conn != null) conn.close();
                            }
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div> ==>

    <!-- Train Stops Section -->
    <div class="dashboard-section">
        <div class="dashboard-card">
            <p class="hero-title">Train Stops</p>
            <table class="results-table">
                <thead>
                    <tr>
                        <th>Stop Number</th>
                        <th>Station Name</th>
                        <th>Arrival Time</th>
                        <th>Departure Time</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        if (scheduleID != null && !scheduleID.trim().isEmpty()) {
                            Connection connStops = null;
                            PreparedStatement psStops = null;
                            ResultSet rsStops = null;

                            try {
                                connStops = DatabaseConnection.initializeDatabase();

                                String stopsQuery = "SELECT SP.stop_order, ST.station_name, SP.arrival_time, SP.departure_time " +
                                                    "FROM stops SP " +
                                                    "JOIN stations ST ON SP.station_id = ST.station_id " +
                                                    "WHERE SP.schedule_id = ? " +
                                                    "ORDER BY SP.stop_id";

                                psStops = connStops.prepareStatement(stopsQuery);
                                psStops.setString(1, scheduleID);
                                rsStops = psStops.executeQuery();

                                if (!rsStops.isBeforeFirst()) {
                    %>
                    <tr>
                        <td colspan="4">No stops found for the selected schedule.</td>
                    </tr>
                    <%
                                } else {
                                    while (rsStops.next()) {
                    %>
                    <tr>
                        <td><%= rsStops.getInt("stop_order") %></td>
                        <td><%= rsStops.getString("station_name") %></td>
                        <td><%= rsStops.getString("arrival_time") != null ? rsStops.getString("arrival_time") : "N/A" %></td>
                        <td><%= rsStops.getString("departure_time") != null ? rsStops.getString("departure_time") : "N/A" %></td>
                    </tr>
                    <%
                                    }
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                    %>
                    <tr>
                        <td colspan="4">Error fetching stops. Please try again later.</td>
                    </tr>
                    <%
                            } finally {
                                if (rsStops != null) rsStops.close();
                                if (psStops != null) psStops.close();
                                if (connStops != null) connStops.close();
                            }
                        }
                    %>
                </tbody>
            </table>
            <br/><br/>
            <div class="back-button-container">
                <a href="searchTrains.jsp" class="button">Back to Search</a>
            </div>
        </div>
    </div>
</body>
</html>

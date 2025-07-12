<%@ page import="java.sql.*, java.util.*, com.railway.db.DatabaseConnection" %>
<%
    Integer customerId = (Integer) session.getAttribute("customerId");

    if (customerId == null) {
        response.sendRedirect("login.jsp"); // Redirect to login if not authenticated
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Reservations</title>
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@400&family=Cormorant+SC:wght@300;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="assets/style.css">
</head>
<body>
    <!-- Header Section -->
    <header class="header">
        <div class="container">
            <h1 class="site-title">Online Railway Booking System</h1>
            <nav class="navbar">
                <a href="customerDashboard.jsp">Home</a>
                <a href="logout.jsp">Logout</a>
            </nav>
        </div>
    </header>
    
    <div class="tabs-container">
        <div class="button active" onclick="showTab('current')" style="background-color: #33333">Current Reservations</div>
        <div class="button" onclick="showTab('past')">Past Reservations</div>
    </div>

    <!-- Tabs for Current and Past Reservations -->
    <div class="dashboard-section">

        <!-- Current Reservations Tab -->
        <div id="current" class="tab-content active dashboard-card">
            <p class="hero-title">Current Reservations</p>
            <table class="results-table">
                <thead>
                    <tr>
                        <th>Reservation ID</th>
                        <th>Train Name</th>
                        <th>Origin</th>
                        <th>Destination</th>
                        <th>Departure</th>
                        <th>Arrival</th>
                        <th>Total Fare</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        Connection conn = null;
                        PreparedStatement ps = null;
                        ResultSet rs = null;
                        try {
                            conn = DatabaseConnection.initializeDatabase();
                            String currentQuery = "SELECT R.reservation_id, T.train_name, S1.station_name AS Origin, S2.station_name AS Destination, " +
                                    "ST1.departure_time AS OriginDeparture, ST2.arrival_time AS DestinationArrival, R.total_fare " +
                                    "FROM reservations R " +
                                    "JOIN train_schedules TS ON R.schedule_id = TS.schedule_id " +
                                    "JOIN trains T ON TS.train_id = T.train_id " +
                                    "JOIN stops ST1 ON TS.schedule_id = ST1.schedule_id AND ST1.station_id = R.origin_station_id " +
                                    "JOIN stops ST2 ON TS.schedule_id = ST2.schedule_id AND ST2.station_id = R.destination_station_id " +
                                    "JOIN stations S1 ON ST1.station_id = S1.station_id " +
                                    "JOIN stations S2 ON ST2.station_id = S2.station_id " +
                                    "WHERE R.customer_id = ? "+
                                    "AND R.is_cancelled = FALSE " +
                                    "AND ST1.departure_time > NOW() " +
                                    "AND ST1.stop_order < ST2.stop_order";

                            ps = conn.prepareStatement(currentQuery);
                            ps.setInt(1, customerId);
                            rs = ps.executeQuery();

                            while (rs.next()) {
                    %>
                    <tr>
                        <td><%= rs.getInt("reservation_id") %></td>
                        <td><%= rs.getString("train_name") %></td>
                        <td><%= rs.getString("Origin") %></td>
                        <td><%= rs.getString("Destination") %></td>
                        <td><%= rs.getString("OriginDeparture") %></td>
                        <td><%= rs.getString("DestinationArrival") %></td>
                        <td>$<%= rs.getDouble("total_fare") %></td>
                        <td><a href="cancelReservation.jsp?reservationId=<%= rs.getInt("reservation_id") %>">Cancel</a></td>
                    </tr>
                    <%
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        } finally {
                            if (rs != null) rs.close();
                            if (ps != null) ps.close();
                            if (conn != null) conn.close();
                        }
                    %>
                </tbody>
            </table>
        </div>

        <!-- Past Reservations Tab -->
        <div id="past" class="tab-content dashboard-card">
            <p class="hero-title">Past Reservations</p>
            <table class="results-table">
                <thead>
                    <tr>
                        <th>Reservation ID</th>
                        <th>Train Name</th>
                        <th>Origin</th>
                        <th>Destination</th>
                        <th>Departure</th>
                        <th>Arrival</th>
                        <th>Total Fare</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    conn = null;
                    ps = null;
                    rs = null;
                        try {
                            conn = DatabaseConnection.initializeDatabase();
                            String pastQuery = "SELECT R.reservation_id, T.train_name, S1.station_name AS Origin, S2.station_name AS Destination, " +
                                    "ST1.departure_time AS OriginDeparture, ST2.arrival_time AS DestinationArrival, R.total_fare " +
                                    "FROM reservations R " +
                                    "JOIN train_schedules TS ON R.schedule_id = TS.schedule_id " +
                                    "JOIN trains T ON TS.train_id = T.train_id " +
                                    "JOIN stops ST1 ON TS.schedule_id = ST1.schedule_id AND ST1.station_id = R.origin_station_id " +
                                    "JOIN stops ST2 ON TS.schedule_id = ST2.schedule_id AND ST2.station_id = R.destination_station_id " +
                                    "JOIN stations S1 ON ST1.station_id = S1.station_id " +
                                    "JOIN stations S2 ON ST2.station_id = S2.station_id " +
                                    "WHERE R.customer_id = ? "+
                                    "AND R.is_cancelled = FALSE " +
                                    "AND ST1.departure_time <= NOW() " +
                                    "AND ST1.stop_order < ST2.stop_order";

                            ps = conn.prepareStatement(pastQuery);
                            ps.setInt(1, customerId);
                            rs = ps.executeQuery();

                            while (rs.next()) {
                    %>
                    <tr>
                        <td><%= rs.getInt("reservation_id") %></td>
                        <td><%= rs.getString("train_name") %></td>
                        <td><%= rs.getString("Origin") %></td>
                        <td><%= rs.getString("Destination") %></td>
                        <td><%= rs.getString("OriginDeparture") %></td>
                        <td><%= rs.getString("DestinationArrival") %></td>
                        <td>$<%= rs.getDouble("total_fare") %></td>
                    </tr>
                    <%
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        } finally {
                            if (rs != null) rs.close();
                            if (ps != null) ps.close();
                            if (conn != null) conn.close();
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>

    <script>
        function showTab(tabId) {
            document.querySelectorAll('.tab-content').forEach(tab => tab.classList.remove('active'));
            document.querySelectorAll('.tab').forEach(tab => tab.classList.remove('active'));
            document.getElementById(tabId).classList.add('active');
            document.querySelector(`[onclick="showTab('${tabId}')"]`).classList.add('active');
        }
    </script>
</body>
</html>
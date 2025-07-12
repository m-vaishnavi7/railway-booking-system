<%@ page import="java.sql.*, com.railway.db.DatabaseConnection" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Train Schedule by Station</title>
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
            <p class="hero-title">Train Schedule by Station</p>
        </div>
    </section>

	<div class="dashboard-section">
        <div class="dashboard-card">
        <form method="GET" action="trainSchedulesByStation.jsp" class="search-form-vertical">
            <div class="form-group-inline" style="width: 500px; margin: 0 auto;">
                <label for="station">Select Station</label>
                <select id="station" name="stationID" required>
                    <option value="">-- Select Station --</option>
                    <%
                        Connection conn = null;
                        PreparedStatement ps = null;
                        ResultSet rs = null;

                        try {
                            conn = DatabaseConnection.initializeDatabase();
                            String stationQuery = "SELECT station_id, station_name FROM stations";
                            ps = conn.prepareStatement(stationQuery);
                            rs = ps.executeQuery();

                            while (rs.next()) {
                    %>
                    <option value="<%= rs.getInt("station_id") %>"><%= rs.getString("station_name") %></option>
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
                </select>
            </div>
			<br/>
            <div class="actions">
                <button type="submit" class="button">Search</button>
            </div>
        </form>

        <%
            if (request.getParameter("stationID") != null) {
                int stationID = Integer.parseInt(request.getParameter("stationID"));

                conn = null;
                ps = null;
                rs = null;

                try {
                    conn = DatabaseConnection.initializeDatabase();
                    String query = "SELECT DISTINCT " +
                            "TS.schedule_id, " +
             			   "TS.transit_line_name, " +
                            "TS.train_id, " +
                            "TS.fare AS total_fare, " +
                            "TS.departure_datetime, " +
                            "St1.station_name AS origin, " +
                            "S1.departure_time, " +
                            "St2.station_name AS destination, " +
                            "S2.arrival_time, " +
                            "T.train_name, " +
                            "ABS(S1.stop_order - S2.stop_order) AS stop_order_difference, " +
                            "(TS.fare / (SELECT COUNT(*) FROM stops S WHERE S.schedule_id = TS.schedule_id)) * ABS(S1.stop_order - S2.stop_order) AS calculated_fare " +
                            "FROM train_schedules TS " +
                            "JOIN stops S1 ON TS.schedule_id = S1.schedule_id " +
                            "JOIN stops S2 ON TS.schedule_id = S2.schedule_id " +
                            "JOIN stations St1 ON S1.station_id = St1.station_id " +
                            "JOIN stations St2 ON S2.station_id = St2.station_id " +
                            "JOIN trains T ON TS.train_id = T.train_id " +
                            "WHERE (St1.station_id = ? OR St2.station_id = ?) " +
                            "AND S1.stop_order < S2.stop_order ";

             ps = conn.prepareStatement(query);
             ps.setInt(1, stationID);
             ps.setInt(2, stationID);

             rs = ps.executeQuery();

                    if (!rs.isBeforeFirst()) {
                        out.println("<p>No train schedules found for the selected station.</p>");
                    } else {
        %>
        <table class="results-table">
            <thead>
                <tr>
                	<th>Transit Line Name</th>
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
                        while (rs.next()) {
                %>
                <tr>
                	<td><%= rs.getString("transit_line_name") %></td>
                    <td><%= rs.getString("train_name") %></td>
                    <td><%= rs.getString("origin") %></td>
                    <td><%= rs.getString("destination") %></td>
                    <td><%= rs.getString("departure_time") %></td>
                    <td><%= rs.getString("arrival_time") %></td>
                    <td><%= rs.getString("calculated_fare") %></td>
                </tr>
                <%
                        }
                %>
            </tbody>
        </table>
        <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    if (rs != null) rs.close();
                    if (ps != null) ps.close();
                    if (conn != null) conn.close();
                }
            }
        %>
    </div>
</body>
</html>

<%@ page import="java.sql.*, com.railway.db.DatabaseConnection" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Train Schedules</title>
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
            <p class="hero-title">Edit Train Schedules</p>
        </div>
    </section>
    <section class="dashboard-section">
        <div class="dashboard-card">
        <%
            int scheduleID = Integer.parseInt(request.getParameter("scheduleID"));
            String trainName = "";
            String transitLine = "";
            String origin = "";
            String destination = "";
            String departure = "";
            String arrival = "";

            Connection conn = null;
            PreparedStatement ps = null;
            ResultSet rs = null;

            try {
                conn = DatabaseConnection.initializeDatabase();
                String query = "SELECT T.train_name, T.transit_line_name, S1.station_name AS Origin, S2.station_name AS Destination, " +
                               "TS.departure_datetime, TS.arrival_datetime " +
                               "FROM train_schedules TS " +
                               "JOIN trains T ON TS.train_id = T.train_id " +
                               "JOIN stations S1 ON TS.origin_station_id = S1.station_id " +
                               "JOIN stations S2 ON TS.destination_station_id = S2.station_id " +
                               "WHERE TS.schedule_id = ?";
                ps = conn.prepareStatement(query);
                ps.setInt(1, scheduleID);
                rs = ps.executeQuery();

                if (rs.next()) {
                	transitLine = rs.getString("transit_line_name");
                    trainName = rs.getString("train_name");
                    origin = rs.getString("Origin");
                    destination = rs.getString("Destination");
                    departure = rs.getString("departure_datetime");
                    arrival = rs.getString("arrival_datetime");
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            }
        %>

        <form method="POST" action="updateTrainSchedule.jsp" class="search-form-vertical">
            <input type="hidden" name="scheduleID" value="<%= scheduleID %>">
            <div class="form-group-inline" style="width: 500px; margin: 0 auto;">
                <label for="transitLine">Transit Line</label>
                <input type="text" id="transitLine" name="transitLine" value="<%= transitLine %>" readonly>
            </div>
            <div class="form-group-inline" style="width: 500px; margin: 0 auto;">
                <label for="trainName">Train Name</label>
                <input type="text" id="trainName" name="trainName" value="<%= trainName %>" readonly>
            </div>
            <div class="form-group-inline" style="width: 500px; margin: 0 auto;">
                <label for="origin">Origin</label>
                <input type="text" id="origin" name="origin" value="<%= origin %>" readonly>
            </div>
            <div class="form-group-inline" style="width: 500px; margin: 0 auto;">
                <label for="destination">Destination</label>
                <input type="text" id="destination" name="destination" value="<%= destination %>" readonly>
            </div>
            <div class="form-group-inline" style="width: 500px; margin: 0 auto;">
                <label for="departure">Departure Time</label>
                <input type="datetime-local" id="departure" name="departure" value="<%= departure.replace(" ", "T") %>">
            </div>
            <div class="form-group-inline" style="width: 500px; margin: 0 auto;">
                <label for="arrival">Arrival Time</label>
                <input type="datetime-local" id="arrival" name="arrival" value="<%= arrival.replace(" ", "T") %>">
            </div>
            <br/>
            <div class="actions" style="width: 500px; margin: 0 auto;">
                <button type="submit" class="button">Update</button>
                <a href="manageTrainSchedules.jsp" class="button">Cancel</a>
            </div>
        </form>
    </div>
    </section>
</body>
</html>

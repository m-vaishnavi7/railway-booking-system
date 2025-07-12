<%@ page import="java.sql.*, java.util.*, com.railway.db.DatabaseConnection" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Train Search - Online Railway Booking</title>
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

    <!-- Train Search Form -->
    <div class="dashboard-section">
        <div class="dashboard-card">
            <p class="hero-title">Search for Train Schedules</p>
            <form method="POST" action="fetchSchedules.jsp" class="search-form-horizontal">
                <!-- Origin Dropdown -->
                <div class="form-group-inline">
                    <label for="origin">Origin:</label>
                    <select id="origin" name="origin" required>
                        <option value="">-- Select Origin --</option>
                        <%
                            Connection conn = null;
                            PreparedStatement ps = null;
                            ResultSet rs = null;
                            try {
                                conn = DatabaseConnection.initializeDatabase();
                                String query = "SELECT station_name FROM stations ORDER BY station_name";
                                ps = conn.prepareStatement(query);
                                rs = ps.executeQuery();

                                while (rs.next()) {
                                    String stationName = rs.getString("station_name");
                        %>
                        <option value="<%= stationName %>"><%= stationName %></option>
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

                <!-- Destination Dropdown -->
                <div class="form-group-inline">
                    <label for="destination">Destination:</label>
                    <select id="destination" name="destination" required>
                        <option value="">-- Select Destination --</option>
                        <%
                            try {
                                conn = DatabaseConnection.initializeDatabase();
                                String query = "SELECT station_name FROM stations ORDER BY station_name";
                                ps = conn.prepareStatement(query);
                                rs = ps.executeQuery();

                                while (rs.next()) {
                                    String stationName = rs.getString("station_name");
                        %>
                        <option value="<%= stationName %>"><%= stationName %></option>
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

                <!-- Date of Travel -->
                <div class="form-group-inline">
                    <label for="date">Date of Travel:</label>
                    <input type="date" id="date" name="date" required>
                </div>
				
				<div class="form-group-inline">
				    <label for="sort" class="form-label">Sort by:</label>
				    <select id="sort" name="sort" class="form-input">
				        <option value="" <%= "none".equals(session.getAttribute("sortBy")) ? "selected" : "" %>>None</option>
				        <option value="arrivalTime" <%= "arrivalTime".equals(session.getAttribute("sortBy")) ? "selected" : "" %>>Arrival Time</option>
				        <option value="departureTime" <%= "departureTime".equals(session.getAttribute("sortBy")) ? "selected" : "" %>>Departure Time</option>
				        <option value="fare" <%= "fare".equals(session.getAttribute("sortBy")) ? "selected" : "" %>>Fare</option>
				    </select>
				</div>
				
                <!-- Search Button -->
                <button type="submit" class="search-btn-inline">Search</button>
            </form>
            <table class="results-table">
                <thead>
                    <tr>
                    	<th>Transit Line</th>
                        <th>Train Name</th>
                        <th>Origin</th>
                        <th>Destination</th>
                        <th>Departure</th>
                        <th>Arrival</th>
                        <th>Fare</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        List<Map<String, String>> searchResults = (List<Map<String, String>>) session.getAttribute("searchResults");
                        if (searchResults != null && !searchResults.isEmpty()) {
                            for (Map<String, String> result : searchResults) {
                    %>
                    <tr>
                    	<td><%= result.get("TransitLineName") %></td>
                        <td><%= result.get("TrainName") %></td>
                        <td><%= result.get("Origin") %></td>
                        <td><%= result.get("Destination") %></td>
                        <td><%= result.get("Departure") %></td>
                        <td><%= result.get("Arrival") %></td>
                        <td>$<%= result.get("Fare") %></td>
                        <td>
                        	<div><a href="viewStops.jsp?scheduleID=<%= result.get("ScheduleID") %>">View Stops</a></div>
                        	<div><a href="makeReservation.jsp?scheduleID=<%= result.get("ScheduleID") %>&traveldate=<%= result.get("Departure") %>&origin=<%= result.get("Origin") %>&destination=<%= result.get("Destination") %>&calculatedFare=<%= result.get("Fare") %>">Make Reservation</a></div>
                        </td>
                    </tr>
                    <%
                            }
                            session.removeAttribute("searchResults");
                        } else {
                    %>
                    <tr>
                        <td colspan="8">No results found. Please search for trains.</td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>

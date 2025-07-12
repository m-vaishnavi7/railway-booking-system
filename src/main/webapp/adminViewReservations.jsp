<%@ page import="java.sql.*, com.railway.db.DatabaseConnection" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin View Reservations</title>
    <link href="https://fonts.googleapis.com/css?family=Cormorant+Garamond|Cormorant+SC:300,500" rel="stylesheet">
    <link rel="stylesheet" href="assets/style.css">
</head>
<body>
    <header class="header">
        <div class="container">
            <h1 class="site-title">Online Railway Booking System</h1>
            <nav class="navbar">
            	<a href="javascript:history.back()">Back</a>
                <a href="adminDashboard.jsp">Home</a>
                <a href="logout.jsp">Logout</a>
            </nav>
        </div>
    </header>
    <section class="hero">
        <div class="container">
            <p class="hero-title">View Reservations</p>
        </div>
    </section>

	<div class="dashboard-section">
        <div class="dashboard-card">
            <form method="GET" class="search-form-horizontal">
                <!-- Origin Dropdown -->
                <div class="form-group-inline">
                    <label for="transitLine">TransitLine:</label>
                    <select id="transitLine" name="transitLine">
                        <option value="">-- Select Transit Line --</option>
		                <%
		                    Connection conn = null;
		                    PreparedStatement ps = null;
		                    ResultSet rs = null;
		
		                    try {
		                        conn = DatabaseConnection.initializeDatabase();
		                        String query = "SELECT distinct transit_line_name FROM trains";
		                        ps = conn.prepareStatement(query);
		                        rs = ps.executeQuery();
		
		                        while (rs.next()) {
		                            String transitLine = rs.getString("transit_line_name");
		                %>
		                <option value="<%= transitLine %>"><%= transitLine %></option>
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
		         <div class="form-group-inline">
                    <label for="customerName">Customer Name:</label>
                    <input type="text" name="customerName" placeholder="Enter Customer Name">
                </div>
            <button type="submit" class="search-btn-inline">Filter</button>
        </form>
        <table class="results-table">
            <thead>
                <tr>
                    <th>Reservation ID</th>
                    <th>Customer Name</th>
                    <th>Transit Line</th>
                    <th>Origin</th>
                    <th>Destination</th>
                    <th>Departure</th>
                    <th>Arrival</th>
                    <th>Total Fare</th>
                </tr>
            </thead>
            <tbody>
                <%
                    String transitLine = request.getParameter("transitLine");
                    String customerName = request.getParameter("customerName");
                    conn = null;
                    ps = null;
                    rs = null;

                    try {
                        conn = DatabaseConnection.initializeDatabase();
                        if (transitLine != null && !transitLine.isEmpty()) {
                            // Filter by transit line
                            String query = "SELECT R.reservation_id, CONCAT(C.first_name, ' ', C.last_name) AS customer_name, S1.station_name AS Origin, S2.station_name AS Destination," +
                                    "T.train_name, TS.transit_line_name, ST1.departure_time AS OriginDeparture, " +
                                    "ST2.arrival_time AS DestinationArrival, R.total_fare " +
                                    "FROM reservations R " +
                                    "JOIN customers C ON R.customer_id = C.customer_id " +
                                    "JOIN train_schedules TS ON R.schedule_id = TS.schedule_id " +
                                    "JOIN trains T ON TS.train_id = T.train_id " +
                                    "JOIN stops ST1 ON TS.schedule_id = ST1.schedule_id AND ST1.station_id = R.origin_station_id " +
                                    "JOIN stops ST2 ON TS.schedule_id = ST2.schedule_id AND ST2.station_id = R.destination_station_id " +
                            		"JOIN stations S1 ON ST1.station_id = S1.station_id " +
                                    "JOIN stations S2 ON ST2.station_id = S2.station_id " +
                                    "WHERE TS.transit_line_name = ? " +
                                    "AND R.is_cancelled = FALSE " +
                                    "AND ST1.stop_order < ST2.stop_order";
                            ps = conn.prepareStatement(query);
                            ps.setString(1, transitLine);
                        } else if (customerName != null && !customerName.isEmpty()) {
                            // Filter by customer name
                            String query = "SELECT R.reservation_id, CONCAT(C.first_name, ' ', C.last_name) AS customer_name, S1.station_name AS Origin, S2.station_name AS Destination," +
                                    "T.train_name, TS.transit_line_name, ST1.departure_time AS OriginDeparture, " +
                                    "ST2.arrival_time AS DestinationArrival, R.total_fare " +
                                    "FROM reservations R " +
                                    "JOIN customers C ON R.customer_id = C.customer_id " +
                                    "JOIN train_schedules TS ON R.schedule_id = TS.schedule_id " +
                                    "JOIN trains T ON TS.train_id = T.train_id " +
                                    "JOIN stops ST1 ON TS.schedule_id = ST1.schedule_id AND ST1.station_id = R.origin_station_id " +
                                    "JOIN stops ST2 ON TS.schedule_id = ST2.schedule_id AND ST2.station_id = R.destination_station_id " +
                            		"JOIN stations S1 ON ST1.station_id = S1.station_id " +
                                    "JOIN stations S2 ON ST2.station_id = S2.station_id " +
                                    "WHERE C.first_name LIKE ? OR C.last_name LIKE ? " +
                                    "AND R.is_cancelled = FALSE " +
                                    "AND ST1.stop_order < ST2.stop_order";
                            ps = conn.prepareStatement(query);
                            ps.setString(1, "%" + customerName + "%");
                            ps.setString(2, "%" + customerName + "%");
                        }

                        if (ps != null) {
                            rs = ps.executeQuery();
                            while (rs.next()) {
                %>
                <tr>
                    <td><%= rs.getInt("reservation_id") %></td>
                    <td><%= rs.getString("customer_name") %></td>
                    <td><%= rs.getString("transit_line_name") %></td>
                    <td><%= rs.getString("Origin") %></td>
                    <td><%= rs.getString("Destination") %></td>
                    <td><%= rs.getString("OriginDeparture") %></td>
                    <td><%= rs.getString("DestinationArrival") %></td>
                    <td>$<%= rs.getDouble("total_fare") %></td>
                </tr>
                <%
                            }
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                %>
                <tr>
                    <td colspan="6">Error retrieving data. Please try again.</td>
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

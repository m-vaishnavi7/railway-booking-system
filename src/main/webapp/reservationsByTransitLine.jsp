<%@ page import="java.sql.*, com.railway.db.DatabaseConnection" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reservations by Transit line</title>
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
            <p class="hero-title">Reservations by Transit line</p>
        </div>
    </section>

	<div class="dashboard-section">
        <div class="dashboard-card">
        <form method="GET" action="reservationsByTransitLine.jsp" class="search-form-vertical">
            <div class="form-group-inline" style="width: 400px; margin: 0 auto;">
                <label for="transitLine">Select Transit Line</label>
                <select id="transitLine" name="transitLine" required>
                    <option value="">-- Select Transit Line --</option>
                    <%
                        Connection conn = null;
                        PreparedStatement ps = null;
                        ResultSet rs = null;

                        try {
                            conn = DatabaseConnection.initializeDatabase();
                            String trainQuery = "SELECT distinct transit_line_name FROM trains";
                            ps = conn.prepareStatement(trainQuery);
                            rs = ps.executeQuery();

                            while (rs.next()) {
                    %>
                    <option value="<%= rs.getString("transit_line_name") %>"><%= rs.getString("transit_line_name") %></option>
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

            <div class="form-group-inline" style="width: 400px; margin: 0 auto;">
                <label for="date">Select Date</label>
                <input type="date" id="date" name="reservationDate" required>
            </div>
			<br/>
            <div class="actions">
                <button type="submit" class="button">Search</button>
            </div>
        </form>

        <%
            if (request.getParameter("transitLine") != null && request.getParameter("reservationDate") != null) {
                String transitLine = request.getParameter("transitLine");
                String reservationDate = request.getParameter("reservationDate");

                conn = null;
                ps = null;
                rs = null;

                try {
                    conn = DatabaseConnection.initializeDatabase();
                    String query = "SELECT C.first_name, C.last_name, C.email, R.reservation_id, R.total_fare, TS.schedule_id " +
                                   "FROM reservations R " +
                                   "JOIN customers C ON R.customer_id = C.customer_id " +
                                   "JOIN train_schedules TS ON R.schedule_id = TS.schedule_id " +
                                   "WHERE TS.transit_line_name = ? AND DATE(TS.departure_datetime) = ? AND R.is_cancelled = FALSE";
                    ps = conn.prepareStatement(query);
                    ps.setString(1, transitLine);
                    ps.setString(2, reservationDate);
                    rs = ps.executeQuery();

                    if (!rs.isBeforeFirst()) {
        %>
        <p class="no-data">No reservations found for the selected transit line and date.</p>
        <%
                    } else {
        %>
        <table class="results-table">
            <thead>
                <tr>
                    <th>Reservation ID</th>
                    <th>Customer Name</th>
                    <th>Email</th>
                    <th>Total Fare</th>
                </tr>
            </thead>
            <tbody>
                <%
                        while (rs.next()) {
                %>
                <tr>
                    <td><%= rs.getInt("reservation_id") %></td>
                    <td><%= rs.getString("first_name") + " " + rs.getString("last_name") %></td>
                    <td><%= rs.getString("email") %></td>
                    <td>$<%= rs.getDouble("total_fare") %></td>
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

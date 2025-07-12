<%@ page import="java.sql.*, com.railway.db.DatabaseConnection" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Revenue Reports</title>
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

    <!-- Revenue by Transit Line -->
    <section class="dashboard-section">
    <div class="dashboard-card">
        <p class="hero-title">Revenue by Transit Line</p>
        
        <!-- Dropdown for Transit Line Search -->
        <form method="GET" action="" class="search-form-horizontal">
        <div class="form-group-inline">
            <label for="transitDropdown">Select Transit Line:</label>
            <select id="transitDropdown" name="transitLineName">
                <option value="">--Select a Transit Line--</option>
                <%
                Connection conn = null;
                PreparedStatement ps = null;
                ResultSet rs = null;

                try {
                    conn = DatabaseConnection.initializeDatabase();
                    String transitQuery = "SELECT DISTINCT transit_line_name FROM trains";
                    ps = conn.prepareStatement(transitQuery);
                    rs = ps.executeQuery();

                    while (rs.next()) {
                %>
                <option value="<%= rs.getString("transit_line_name") %>"
                    <%= request.getParameter("transitLineName") != null && request.getParameter("transitLineName").equals(rs.getString("transit_line_name")) ? "selected" : "" %>>
                    <%= rs.getString("transit_line_name") %>
                </option>
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
            <div class="actions">
            	<button type="submit" class="button">Search</button>
            </div>
        </form>

        <!-- Display Revenue by Selected Transit Line -->
        <table class="results-table" style="width: 700px; margin: 0 auto;">
            <thead>
                <tr>
                    <th>Transit Line</th>
                    <th>Total Revenue</th>
                </tr>
            </thead>
            <tbody>
                <%
                    String selectedTransitLine = request.getParameter("transitLineName");

                    if (selectedTransitLine != null && !selectedTransitLine.isEmpty()) {
                        conn = null;
                        ps = null;
                        rs = null;

                        try {
                            conn = DatabaseConnection.initializeDatabase();
                            String revenueQuery = "SELECT T.transit_line_name, SUM(R.total_fare) AS TotalRevenue " +
                                                  "FROM reservations R " +
                                                  "JOIN train_schedules TS ON R.schedule_id = TS.schedule_id " +
                                                  "JOIN trains T ON TS.train_id = T.train_id " +
                                                  "WHERE R.is_cancelled = FALSE AND T.transit_line_name = ? " +
                                                  "GROUP BY T.transit_line_name";
                            ps = conn.prepareStatement(revenueQuery);
                            ps.setString(1, selectedTransitLine);
                            rs = ps.executeQuery();

                            if (rs.next()) {
                %>
                <tr>
                    <td><%= rs.getString("transit_line_name") %></td>
                    <td>$<%= rs.getDouble("TotalRevenue") %></td>
                </tr>
                <%
                            } else {
                %>
                <tr>
                    <td colspan="2">No revenue data available for the selected transit line.</td>
                </tr>
                <%
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                %>
                <tr>
                    <td colspan="2">Error retrieving data. Please try again.</td>
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
</section>
    
</body>
</html>

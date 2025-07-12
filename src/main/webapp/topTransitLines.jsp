<%@ page import="java.sql.*, com.railway.db.DatabaseConnection" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Top Transit Lines</title>
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
            <p class="hero-title">Top 5 Most Active Transit Lines</p>
        </div>
    </section>
    <section class="dashboard-section">
    	<div class="dashboard-card">
        <table class="results-table" style="width: 800px; margin: 0 auto;">
            <thead>
                <tr>
                    <th>Transit Line Name</th>
                    <th>Reservation Count</th>
                    <th>Month</th>
                </tr>
            </thead>
            <tbody>
                <%
                    Connection conn = null;
                    PreparedStatement ps = null;
                    ResultSet rs = null;

                    try {
                        conn = DatabaseConnection.initializeDatabase();
                        String query = "SELECT T.train_name, COUNT(R.reservation_id) AS ReservationCount, " +
                                       "DATE_FORMAT(R.reservation_date, '%Y-%m') AS Month " +
                                       "FROM reservations R " +
                                       "JOIN train_schedules TS ON R.schedule_id = TS.schedule_id " +
                                       "JOIN trains T ON TS.train_id = T.train_id " +
                                       "WHERE R.is_cancelled = FALSE " +
                                       "GROUP BY T.train_name, DATE_FORMAT(R.reservation_date, '%Y-%m') " +
                                       "ORDER BY ReservationCount DESC " +
                                       "LIMIT 5";
                        ps = conn.prepareStatement(query);
                        rs = ps.executeQuery();

                        while (rs.next()) {
                %>
                <tr>
                    <td><%= rs.getString("train_name") %></td>
                    <td><%= rs.getInt("ReservationCount") %></td>
                    <td><%= rs.getString("Month") %></td>
                </tr>
                <%
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                %>
                <tr>
                    <td colspan="3" class="error">An error occurred while fetching data.</td>
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
    </section>
</body>
</html>

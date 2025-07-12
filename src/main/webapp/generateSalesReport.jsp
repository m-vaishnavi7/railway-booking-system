<%@ page import="java.sql.*, com.railway.db.DatabaseConnection" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sales Report</title>
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
            <p class="hero-title">Monthly Sales Report</p>
        </div>
    </section>
    <div class="dashboard-section">
        <div class="dashboard-card">
            <h2>Select Month for Report</h2>
            <form method="GET" action="" class="search-form-horizontal">
            <div class="form-group-inline">
                <label for="month">Select Month:</label>
                <select name="month" id="month">
                    <option value="">--Select Month--</option>
                    <% 
                        try {
                            Connection conn = DatabaseConnection.initializeDatabase();
                            String monthQuery = "SELECT DISTINCT DATE_FORMAT(reservation_date, '%Y-%m') AS MonthYear FROM reservations ORDER BY MonthYear DESC";
                            PreparedStatement ps = conn.prepareStatement(monthQuery);
                            ResultSet rs = ps.executeQuery();
                            while (rs.next()) {
                                String monthYear = rs.getString("MonthYear");
                    %>
                    <option value="<%= monthYear %>"><%= monthYear %></option>
                    <%
                            }
                            rs.close();
                            ps.close();
                            conn.close();
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    %>
                </select>
                </div>
                <div class="actions">
                <button type="submit" class="button">Generate Report</button>
                </div>
            </form>

            <% 
                String selectedMonth = request.getParameter("month");
                if (selectedMonth != null && !selectedMonth.isEmpty()) {
            %>
            <h2>Report for <%= selectedMonth %></h2>
            <table class="results-table" style="width: 600px; margin: 0 auto;">
                <thead>
                    <tr>
                        <th>Month</th>
                        <th>Total Revenue</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                        Connection conn = null;
                        PreparedStatement ps = null;
                        ResultSet rs = null;

                        try {
                            conn = DatabaseConnection.initializeDatabase();

                            String query = "SELECT DATE_FORMAT(reservation_date, '%Y-%m') AS MonthYear, SUM(total_fare) AS TotalRevenue " +
                                           "FROM reservations " +
                                           "WHERE is_cancelled = FALSE AND DATE_FORMAT(reservation_date, '%Y-%m') = ? " +
                                           "GROUP BY DATE_FORMAT(reservation_date, '%Y-%m') " +
                                           "ORDER BY DATE_FORMAT(reservation_date, '%Y-%m')";

                            ps = conn.prepareStatement(query);
                            ps.setString(1, selectedMonth);
                            rs = ps.executeQuery();

                            if (rs.next()) {
                    %>
                    <tr>
                        <td><%= rs.getString("MonthYear") %></td>
                        <td>$<%= String.format("%.2f", rs.getDouble("TotalRevenue")) %></td>
                    </tr>
                    <%
                            } else {
                    %>
                    <tr>
                        <td colspan="2">No data available for the selected month.</td>
                    </tr>
                    <%
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                    %>
                    <tr>
                        <td colspan="2">Error retrieving data. Please try again later.</td>
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
            <% } %>
        </div>
    </div>
</body>
</html>

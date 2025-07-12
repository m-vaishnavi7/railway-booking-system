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
    
    <!-- Revenue by Customer Name -->
    <section class="dashboard-section">
    <div class="dashboard-card">
        <p class="hero-title">Revenue Reports by Customer Name</p>
        
        <!-- Search Box for Customer Name -->
        <form method="GET" action="" class="search-form-horizontal">
            <div class="form-group-inline">
                <label for="customerName">Enter Customer Name:</label>
                <input type="text" id="customerName" name="customerName" value="<%= request.getParameter("customerName") != null ? request.getParameter("customerName") : "" %>" placeholder="Enter name here" required>
            </div>
            <div class="actions">
                <button type="submit" class="button">Search</button>
            </div>
        </form>

        <!-- Display Revenue by Customer Name -->
        <table class="results-table" style="width: 700px; margin: 0 auto;">
            <thead>
                <tr>
                    <th>Customer Name</th>
                    <th>Total Revenue</th>
                </tr>
            </thead>
            <tbody>
                <%
                    String customerName = request.getParameter("customerName");

                    if (customerName != null && !customerName.trim().isEmpty()) {
                        Connection conn = null;
                        PreparedStatement ps = null;
                        ResultSet rs = null;

                        try {
                            conn = DatabaseConnection.initializeDatabase();
                            String revenueQuery = "SELECT CONCAT(C.first_name, ' ', C.last_name) AS customer_name, SUM(R.total_fare) AS TotalRevenue " +
                                                  "FROM reservations R " +
                                                  "JOIN customers C ON R.customer_id = C.customer_id " +
                                                  "WHERE R.is_cancelled = FALSE AND CONCAT(C.first_name, ' ', C.last_name) LIKE ? " +
                                                  "GROUP BY C.customer_id";
                            ps = conn.prepareStatement(revenueQuery);
                            ps.setString(1, "%" + customerName + "%");
                            rs = ps.executeQuery();

                            if (rs.next()) {
                %>
                <tr>
                    <td><%= rs.getString("customer_name") %></td>
                    <td>$<%= rs.getDouble("TotalRevenue") %></td>
                </tr>
                <%
                            } else {
                %>
                <tr>
                    <td colspan="2">No revenue data available for the entered customer name.</td>
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

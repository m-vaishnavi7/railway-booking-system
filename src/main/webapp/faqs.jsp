<%@ page import="java.sql.*, com.railway.db.DatabaseConnection" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FAQs</title>
    <link href="https://fonts.googleapis.com/css?family=Cormorant+Garamond|Cormorant+SC:300,500" rel="stylesheet">
    <link rel="stylesheet" href="assets/style.css">
</head>
<body>
	<header class="header">
        <div class="container">
            <h1 class="site-title">Online Railway Booking System</h1>
            <nav class="navbar">
            	<a href="javascript:history.back()">Back</a>
                <a href="javascript:history.back()">Home</a>
                <a href="logout.jsp">Logout</a>
            </nav>
        </div>
    </header>
    <section class="hero">
        <div class="container">
            <p class="hero-title">Frequently Asked Questions</p>
        </div>
    </section>
    <section class="dashboard-section">
        <div class="dashboard-card">
        <table class="results-table">
            <thead>
                <tr>
                    <th>#</th>
                    <th>Question</th>
                    <th>Answer</th>
                </tr>
            </thead>
            <tbody>
                <%
                    Connection conn = null;
                    PreparedStatement ps = null;
                    ResultSet rs = null;

                    try {
                        // Initialize database connection using your utility class
                        conn = DatabaseConnection.initializeDatabase();

                        // Query to retrieve FAQs
                        String query = "SELECT * FROM railwayFAQs";
                        ps = conn.prepareStatement(query);
                        rs = ps.executeQuery();

                        // Display FAQs in the table
                        int index = 1;
                        while (rs.next()) {
                %>
                <tr>
                    <td><%= index++ %></td>
                    <td><%= rs.getString("question") %></td>
                    <td><%= rs.getString("answer") %></td>
                </tr>
                <%
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                %>
                <tr>
                    <td colspan="3">Error loading FAQs. Please try again later.</td>
                </tr>
                <%
                    } finally {
                        // Close resources
                        if (rs != null) try { rs.close(); } catch (Exception e) {}
                        if (ps != null) try { ps.close(); } catch (Exception e) {}
                        if (conn != null) try { conn.close(); } catch (Exception e) {}
                    }
                %>
            </tbody>
        </table>
    </div>
    </section>
</body>
</html>



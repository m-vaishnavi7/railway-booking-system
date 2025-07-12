<%@ page import="java.sql.*, com.railway.db.DatabaseConnection" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Message Center</title>
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
	<section class="hero">
        <div class="container">
            <p class="hero-title">Customer Support</p>
        </div>
    </section>
    <!-- Train Search Form -->
    <div class="dashboard-section">
        <div class="dashboard-card">
        <form method="POST" action="submitquestion.jsp" class="search-form-horizontal">
	        	<div class="form-group-inline" style="width: 800px; margin: 0 auto;">
	        		<input type="text" id="customerQuestion" name="customerQuestion" class="form-input" placeholder="Type your question" required>
            	</div>
	            <div class="actions">
	                <button type="submit" class="button">Submit</button>
	            </div>
        <table class="results-table">
            <thead>
                <tr>
                    <th>#</th>
                    <th>Question</th>
                    <th>Reply</th>
                </tr>
            </thead>
            <tbody>
                <%
                    Connection conn = null;
                    PreparedStatement ps = null;
                    ResultSet rs = null;

                    try {
                        // Get customer ID from session
                        int customerID = (Integer) session.getAttribute("customerId");

                        // Initialize database connection
                        conn = DatabaseConnection.initializeDatabase();

                        // Query to fetch questions and replies for the logged-in customer
                        String query = "SELECT question, reply FROM customer_questions WHERE customer_id = ? ORDER BY created_at DESC";
                        ps = conn.prepareStatement(query);
                        ps.setInt(1, customerID);
                        rs = ps.executeQuery();

                        int index = 1;
                        boolean hasResults = false;

                        while (rs.next()) {
                            hasResults = true;
                %>
                <tr>
                    <td><%= index++ %></td>
                    <td><%= rs.getString("question") %></td>
                    <td><%= (rs.getString("reply") != null ? rs.getString("reply") : "No reply yet") %></td>
                </tr>
                <%
                        }

                        if (!hasResults) {
                %>
                <tr>
                    <td colspan="3">You have not submitted any questions yet.</td>
                </tr>
                <%
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                %>
                <tr>
                    <td colspan="3">Error loading your questions. Please try again later.</td>
                </tr>
                <%
                    } finally {
                        if (rs != null) try { rs.close(); } catch (Exception e) {}
                        if (ps != null) try { ps.close(); } catch (Exception e) {}
                        if (conn != null) try { conn.close(); } catch (Exception e) {}
                    }
                %>
            </tbody>
        </table>
        </form>
    </div>
    </div>
</body>
</html>

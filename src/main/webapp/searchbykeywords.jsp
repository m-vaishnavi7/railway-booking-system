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
                <a href="customerRepDashboard.jsp">Home</a>
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
	        <form method="GET" action="searchbykeywords.jsp" class="search-form-vertical">
	        	<div class="form-group-inline" style="width: 400px; margin: 0 auto;">
	            	<input type="text" name="keyword" placeholder="Search for questions..." value="<%= request.getParameter("keyword") != null ? request.getParameter("keyword") : "" %>">
	            </div>
	            <br/>
	            <div class="actions">
	                <button type="submit" class="button">Search</button>
	            </div>
	        </form>
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

                        // Get the search keyword from the request
                        String keyword = request.getParameter("keyword");

                        // Debug: Print the keyword
                        System.out.println("Search keyword: " + keyword);

                        if (keyword != null && !keyword.trim().isEmpty()) {
                            keyword = "%" + keyword.trim() + "%"; // For partial matching in SQL
                        } else {
                            keyword = "%"; // Return all results if no keyword is provided
                        }

                        // Query to retrieve FAQs with keyword filtering
                        String query = "SELECT * FROM railwayFAQs WHERE question LIKE ?";
                        ps = conn.prepareStatement(query);
                        ps.setString(1, keyword); // Set the keyword in the query
                        rs = ps.executeQuery();

                        int index = 1;
                        boolean hasResults = false;

                        while (rs.next()) {
                            hasResults = true;
                %>
                <tr>
                    <td><%= index++ %></td>
                    <td><%= rs.getString("question") %></td>
                    <td><%= rs.getString("answer") %></td>
                </tr>
                <%
                        }

                        if (!hasResults) {
                %>
                <tr>
                    <td colspan="3">No FAQs found for the given keyword.</td>
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

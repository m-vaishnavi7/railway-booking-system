<%@ page import="java.sql.*, com.railway.db.DatabaseConnection" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Questions</title>
    <link href="https://fonts.googleapis.com/css?family=Cormorant+Garamond|Cormorant+SC:300,500" rel="stylesheet">
    <link rel="stylesheet" href="assets/style.css">
</head>
<style>
.button {
    font-family: 'Cormorant SC', serif;
    font-weight: 500;
    font-size: 10px;
    text-transform: uppercase;
    letter-spacing: 1px;
    background-color: #333333; /* Dark Button */
    color: white;
    padding: 0.5rem 0.5rem;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    transition: background-color 0.3s ease;
    flex: 1; /* Make all buttons the same size */
    text-align: center;
    margin: 0 0.5rem; /* Adjust space between buttons */
    min-width: 100px; /* Minimum width to prevent wrapping */
    max-width: 100px; /* Prevent buttons from stretching too much */
    /* white-space: nowrap;  Prevent text from breaking into multiple lines */
    overflow-wrap: break-word;
}

</style>
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
            <p class="hero-title">Customer Inquiries</p>
        </div>
    </section>
    <section class="dashboard-section">
        <div class="dashboard-card">
        <table class="results-table">
            <thead>
                <tr>
                    <th>#</th>
                    <th>Customer ID</th>
                    <th>Question</th>
                    <th>Reply</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                    Connection conn = null;
                    PreparedStatement ps = null;
                    ResultSet rs = null;

                    try {
                        // Initialize database connection
                        conn = DatabaseConnection.initializeDatabase();

                        // Query to fetch questions and corresponding customer IDs
                        String query = "SELECT customer_id, question, reply, question_id FROM customer_questions ORDER BY created_at DESC";
                        ps = conn.prepareStatement(query);
                        rs = ps.executeQuery();

                        int index = 1;

                        while (rs.next()) {
                            int questionID = rs.getInt("question_id");
                            String question = rs.getString("question");
                            String reply = rs.getString("reply");
                            int customerID = rs.getInt("customer_id");
                %>
                <form method="POST" action="replyToQuestion.jsp" class="search-form-horizontal">
                    <tr>
                        <td><%= index++ %></td>
                        <td><%= customerID %></td>
                        <td><%= question %></td>
                        <td><%= (reply != null ? reply : "No reply yet") %></td>
                        <td>
                            <!-- Hidden input to send QuestionID -->
                            <input type="hidden" name="questionID" value="<%= questionID %>">
                            <!-- Reply text area -->
                            <input type="text" id="customerQuestion" name="reply" class="form-input" placeholder="Type your reply here..." required>
                            <button type="submit" class="button" style="">Submit Reply</button>
                        </td>
                    </tr>
                </form>
                <%
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                %>
                <tr>
                    <td colspan="5">Error loading customer questions. Please try again later.</td>
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
</body>
</html>

<%@ page import="java.sql.*, com.railway.db.DatabaseConnection" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Submit Question</title>
</head>
<body>
    <%
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            // Retrieve the customer question from the form
            String customerQuestion = request.getParameter("customerQuestion");

            // Retrieve CustomerID from session
            Integer customerID = (Integer) session.getAttribute("customerId");

            // Check if CustomerID is available in the session
            if (customerID == null) {
                out.println("<script>alert('Customer not logged in. Please log in again.'); window.location.href='login.jsp';</script>");
                return;
            }

            // Initialize database connection
            conn = DatabaseConnection.initializeDatabase();

            // Check if the customerQuestion is valid
            if (customerQuestion != null && !customerQuestion.trim().isEmpty()) {
                // Insert the question into the CustomerQuestions table with CustomerID
                String query = "INSERT INTO customer_questions (customer_id, question) VALUES (?, ?)";
                ps = conn.prepareStatement(query);
                ps.setInt(1, customerID); // Set the CustomerID
                ps.setString(2, customerQuestion); // Set the customer question

                // Execute the query to insert the question into the table
                int result = ps.executeUpdate();

                // Check if the insertion was successful
                if (result > 0) {
                    out.println("<script>alert('Your question has been submitted successfully!'); window.location.href='messageCenter.jsp';</script>");
                } else {
                    out.println("<script>alert('Failed to submit your question. Please try again.'); window.location.href='messageCenter.jsp';</script>");
                }
            } else {
                out.println("<script>alert('Question cannot be empty.'); window.location.href='messageCenter.jsp';</script>");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<script>alert('An error occurred. Please try again later.'); window.location.href='messageCenter.jsp';</script>");
        } finally {
            // Clean up resources
            if (ps != null) try { ps.close(); } catch (Exception e) {}
            if (conn != null) try { conn.close(); } catch (Exception e) {}
        }
    %>
</body>
</html>

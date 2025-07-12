<%@ page import="java.sql.*, com.railway.db.DatabaseConnection" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reply to Question</title>
</head>
<body>
    <%
        // Retrieve the questionID and reply from the form submission
        String reply = request.getParameter("reply");
        String questionIDParam = request.getParameter("questionID");
        System.out.println("Reply: " + reply);
        System.out.println("questionID: " + questionIDParam);

        // Validate that both the reply and questionID are provided
        if (questionIDParam != null && !questionIDParam.trim().isEmpty() && reply != null && !reply.trim().isEmpty()) {
            int questionID = Integer.parseInt(questionIDParam);  // Convert questionID to integer

            Connection conn = null;
            PreparedStatement ps = null;

            try {
                // Initialize database connection
                conn = DatabaseConnection.initializeDatabase();

                // SQL query to update the reply in the CustomerQuestions table
                String query = "UPDATE customer_questions SET reply = ? WHERE question_id = ?";
                ps = conn.prepareStatement(query);
                ps.setString(1, reply); // Set the reply
                ps.setInt(2, questionID); // Set the QuestionID

                // Execute the update
                int result = ps.executeUpdate();

                if (result > 0) {
                    out.println("<script>");
                    out.println("alert('Reply submitted successfully.');");
                    out.println("window.location.href = 'viewCustomerQuestions.jsp';");
                    out.println("</script>");
                } else {
                    out.println("<script>");
                    out.println("alert('Failed to submit the reply.');");
                    out.println("window.location.href = 'viewCustomerQuestions.jsp';");
                    out.println("</script>");
                }
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<script>");
                out.println("alert('An error occurred. Please try again later.');");
                out.println("window.location.href = 'viewCustomerQuestions.jsp';");
                out.println("</script>");
            } finally {
                if (ps != null) try { ps.close(); } catch (Exception e) {}
                if (conn != null) try { conn.close(); } catch (Exception e) {}
            }
        } else {
            out.println("<script>");
            out.println("alert('Please enter a reply before submitting.');");
            out.println("window.location.href = 'viewCustomerQuestions.jsp';");
            out.println("</script>");
        }
    %>
</body>
</html>

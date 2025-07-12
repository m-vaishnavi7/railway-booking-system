<%@ page import="java.sql.*, com.railway.db.DatabaseConnection" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Delete Customer Representatives</title>
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
            <p class="hero-title">Delete Customer Representative</p>
        </div>
    </section>

	<div class="dashboard-section">
        <div class="dashboard-card">
        <%
    String errorMessage = null;
    String successMessage = null;
    int employeeID = request.getParameter("employeeID") == null || request.getParameter("employeeID").isEmpty()
            ? 0
            : Integer.parseInt(request.getParameter("employeeID"));

    if (employeeID == 0) {
        errorMessage = "Invalid Employee ID.";
    }

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DatabaseConnection.initializeDatabase();

            // Step 1: Retrieve user_id associated with the employee
            String findUserQuery = "SELECT user_id FROM employees WHERE employee_id = ?";
            ps = conn.prepareStatement(findUserQuery);
            ps.setInt(1, employeeID);
            rs = ps.executeQuery();

            int userID = 0;
            if (rs.next()) {
                userID = rs.getInt("user_id");
            }
            rs.close();
            ps.close();

            if (userID == 0) {
                errorMessage = "Employee not found. Cannot delete.";
            } else {
                // Step 2: Delete the employee record
                String deleteEmployeeQuery = "DELETE FROM employees WHERE employee_id = ?";
                ps = conn.prepareStatement(deleteEmployeeQuery);
                ps.setInt(1, employeeID);
                int employeeRows = ps.executeUpdate();
                ps.close();

                // Step 3: Delete the user record
                String deleteUserQuery = "DELETE FROM users WHERE user_id = ?";
                ps = conn.prepareStatement(deleteUserQuery);
                ps.setInt(1, userID);
                int userRows = ps.executeUpdate();
                ps.close();

                // Success Message
                if (employeeRows > 0 && userRows > 0) {
                    successMessage = "Customer Representative deleted successfully.";
                } else {
                    errorMessage = "Failed to delete the Customer Representative. Please try again.";
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            errorMessage = "An error occurred. Please try again.";
        } finally {
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        }
    }
%>

<!-- Display success or error message -->
<% if (successMessage != null) { %>
    <p style="color: green; font-weight: bold;"><%= successMessage %></p>
    <script>
        setTimeout(() => {
            window.location.href = 'manageCustomerReps.jsp';
        }, 2000);
    </script>
<% } else if (errorMessage != null) { %>
    <p style="color: red; font-weight: bold;"><%= errorMessage %></p>
    <a href="manageCustomerReps.jsp" class="btn">Back</a>
<% } else { %>
    <h2>Are you sure you want to delete this Customer Representative?</h2>
    <form method="POST" action="deleteCustomerRep.jsp">
        <input type="hidden" name="employeeID" value="<%= employeeID %>">
        <button type="submit" class="button">Yes, Delete</button>
        <a href="manageCustomerReps.jsp" class="button">Cancel</a>
    </form>
<% } %>

    </div>
    </div>
</body>
</html>

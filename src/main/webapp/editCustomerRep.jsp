<%@ page import="java.sql.*, java.util.*, com.railway.db.DatabaseConnection" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Customer Representatives</title>
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
            <p class="hero-title">Edit Customer Representativ</p>
        </div>
    </section>

	<div class="dashboard-section">
        <div class="dashboard-card">
        <%
            String errorMessage = null;
            int employeeID = request.getParameter("employeeID") == null || request.getParameter("employeeID").isEmpty()
                    ? 0
                    : Integer.parseInt(request.getParameter("employeeID"));

            String firstName = "";
            String lastName = "";
            String ssn = "";
            String email = "";

            if (employeeID != 0) {
                // Retrieve employee details
                Connection conn = null;
                PreparedStatement ps = null;
                ResultSet rs = null;

                try {
                    conn = DatabaseConnection.initializeDatabase();
                    String selectQuery = "SELECT first_name, last_name, ssn, email FROM employees WHERE employee_id = ?";
                    ps = conn.prepareStatement(selectQuery);
                    ps.setInt(1, employeeID);
                    rs = ps.executeQuery();

                    if (rs.next()) {
                        firstName = rs.getString("first_name");
                        lastName = rs.getString("last_name");
                        ssn = rs.getString("ssn");
                        email = rs.getString("email");
                    } else {
                        errorMessage = "No employee found with the provided ID.";
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    errorMessage = "An error occurred while retrieving employee details.";
                } finally {
                    if (rs != null) rs.close();
                    if (ps != null) ps.close();
                    if (conn != null) conn.close();
                }
            }

            if ("POST".equalsIgnoreCase(request.getMethod())) {
                // Process update
                firstName = request.getParameter("firstName");
                lastName = request.getParameter("lastName");
                ssn = request.getParameter("ssn");
                email = request.getParameter("email");

                Connection conn = null;
                PreparedStatement ps = null;

                try {
                    conn = DatabaseConnection.initializeDatabase();
                    String updateQuery = "UPDATE employees SET first_name = ?, last_name = ?, ssn = ?, email = ? WHERE employee_id = ?";
                    ps = conn.prepareStatement(updateQuery);
                    ps.setString(1, firstName);
                    ps.setString(2, lastName);
                    ps.setString(3, ssn);
                    ps.setString(4, email);
                    ps.setInt(5, employeeID);
                    ps.executeUpdate();

                    response.sendRedirect("manageCustomerReps.jsp");
                    return;
                } catch (Exception e) {
                    e.printStackTrace();
                    errorMessage = "An error occurred while updating employee details.";
                } finally {
                    if (ps != null) ps.close();
                    if (conn != null) conn.close();
                }
            }
        %>

        <% if (errorMessage != null) { %>
            <p style="color: red;"><%= errorMessage %></p>
        <% } %>

        <form method="POST" action="editCustomerRep.jsp?employeeID=<%= employeeID %>" class="search-form-vertical">
            <div class="form-group-inline" style="width: 500px; margin: 0 auto;">
                <label for="firstName">First Name</label>
                <input type="text" id="firstName" name="firstName" value="<%= firstName %>" required>
            </div>
            <div class="form-group-inline" style="width: 500px; margin: 0 auto;">
                <label for="lastName">Last Name</label>
                <input type="text" id="lastName" name="lastName" value="<%= lastName %>" required>
            </div>
            <div class="form-group-inline" style="width: 500px; margin: 0 auto;">
                <label for="ssn">SSN</label>
                <input type="text" id="ssn" name="ssn" value="<%= ssn %>" required>
            </div>
            <div class="form-group-inline" style="width: 500px; margin: 0 auto;">
                <label for="email">Email</label>
                <input type="email" id="email" name="email" value="<%= email %>" required>
            </div>
			<br/>
            <div class="actions">
                <button type="submit" class="button">Update</button>
            </div>
        </form>
    </div>
</body>
</html>

<%@ page import="java.sql.*, java.util.*, com.railway.db.DatabaseConnection" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Customer Representatives</title>
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
            <p class="hero-title">Add Customer Representative</p>
        </div>
    </section>

	<div class="dashboard-section">
        <div class="dashboard-card">
        <%
            String errorMessage = null;

            if ("POST".equalsIgnoreCase(request.getMethod())) {
                // Process form submission
                String firstName = request.getParameter("firstName");
                String lastName = request.getParameter("lastName");
                String ssn = request.getParameter("ssn");
                String email = request.getParameter("email");
                String username = request.getParameter("username");
                String password = request.getParameter("password");

                if (firstName == null || lastName == null || ssn == null || email == null || username == null || password == null ||
                    firstName.trim().isEmpty() || lastName.trim().isEmpty() || ssn.trim().isEmpty() || email.trim().isEmpty() || username.trim().isEmpty() || password.trim().isEmpty()) {
                    errorMessage = "All fields are required.";
                } else {
                    Connection conn = null;
                    PreparedStatement psUser = null;
                    PreparedStatement psEmployee = null;
                    ResultSet rs = null;

                    try {
                        conn = DatabaseConnection.initializeDatabase();
                        conn.setAutoCommit(false); // Begin transaction

                        // Step 1: Insert into `users` table
                        String insertUserQuery = "INSERT INTO users (username, password, role_id) VALUES (?, ?, ?)";
                        psUser = conn.prepareStatement(insertUserQuery, Statement.RETURN_GENERATED_KEYS);
                        psUser.setString(1, username);
                        psUser.setString(2, password);
                        psUser.setInt(3, 3); // RoleID for Customer Representative
                        psUser.executeUpdate();

                        // Get the generated userID
                        rs = psUser.getGeneratedKeys();
                        int userID = 0;
                        if (rs.next()) {
                            userID = rs.getInt(1);
                        }

                        if (userID == 0) {
                            throw new SQLException("Failed to insert into users table and retrieve userID.");
                        }

                        // Step 2: Insert into `employees` table
                        String insertEmployeeQuery = "INSERT INTO employees (user_id, first_name, last_name, ssn, email,role_id) VALUES (?, ?, ?, ?, ?,3)";
                        psEmployee = conn.prepareStatement(insertEmployeeQuery);
                        psEmployee.setInt(1, userID);
                        psEmployee.setString(2, firstName);
                        psEmployee.setString(3, lastName);
                        psEmployee.setString(4, ssn);
                        psEmployee.setString(5, email);
                        psEmployee.executeUpdate();

                        conn.commit(); // Commit transaction
                        response.sendRedirect("manageCustomerReps.jsp");
                        return;
                    } catch (Exception e) {
                        if (conn != null) conn.rollback(); // Rollback on failure
                        errorMessage = "An error occurred while adding the representative. Please try again.";
                        e.printStackTrace();
                    } finally {
                        if (rs != null) rs.close();
                        if (psUser != null) psUser.close();
                        if (psEmployee != null) psEmployee.close();
                        if (conn != null) conn.close();
                    }
                }
            }
        %>

        <% if (errorMessage != null) { %>
            <p class="error"><%= errorMessage %></p>
        <% } %>

        <form method="POST" action="saveCustomerReps.jsp" class="search-form-vertical">
            <div class="form-group-inline" style="width: 500px; margin: 0 auto;">
                <label for="firstName">First Name</label>
                <input type="text" id="firstName" name="firstName" required>
            </div>
            <div class="form-group-inline" style="width: 500px; margin: 0 auto;">
                <label for="lastName">Last Name</label>
                <input type="text" id="lastName" name="lastName" required>
            </div>
            <div class="form-group-inline" style="width: 500px; margin: 0 auto;">
                <label for="ssn">SSN</label>
                <input type="text" id="ssn" name="ssn" required>
            </div>
            <div class="form-group-inline" style="width: 500px; margin: 0 auto;">
                <label for="email">Email</label>
                <input type="email" id="email" name="email" required>
            </div>
            <div class="form-group-inline" style="width: 500px; margin: 0 auto;">
                <label for="username">Username</label>
                <input type="text" id="username" name="username" required>
            </div>
            <div class="form-group-inline" style="width: 500px; margin: 0 auto;">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" required>
            </div>
            <br/>
            <div class="actions" style="width: 500px; margin: 0 auto;">
                <button type="submit" class="button ">Add Representative</button>
            </div>
        </form>
    </div>
</body>
</html>

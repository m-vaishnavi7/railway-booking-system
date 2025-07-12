<%@ page import="java.sql.*, com.railway.db.DatabaseConnection" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Customer Representatives</title>
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
            <p class="hero-title">Manage Customer Representatives</p>
        </div>
    </section>

	<div class="dashboard-section">
        <div class="dashboard-card">
            <!-- Search Section -->
            <form method="GET" action="manageCustomerReps.jsp" class="search-form-vertical">
            	<div class="form-group-inline" style="width: 400px; margin: 0 auto;">
                <input type="text" name="search" placeholder="Search by Name or ID" value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
                </div>
                <br/>
                <button type="submit" class="button">Search</button>
            </form>
			<br/>
            <!-- Add Representative Button -->
            <a href="saveCustomerReps.jsp" class="button">Add Representative</a>

        <!-- Representatives Table -->
        <table class="results-table">
            <thead>
                <tr>
                    <th>Employee ID</th>
                    <th>Full Name</th>
                    <th>Email</th>
                    <th>SSN</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    Connection conn = null;
                    PreparedStatement ps = null;
                    ResultSet rs = null;

                    try {
                        conn = DatabaseConnection.initializeDatabase();
                        String query = "SELECT * FROM employees WHERE role_id = 3";
                        String search = request.getParameter("search");
                        if (search != null && !search.trim().isEmpty()) {
                            query += " AND (first_name LIKE ? OR last_name LIKE ? OR employee_id LIKE ?)";
                        }
                        ps = conn.prepareStatement(query);
                        if (search != null && !search.trim().isEmpty()) {
                            ps.setString(1, "%" + search + "%");
                            ps.setString(2, "%" + search + "%");
                            ps.setString(3, "%" + search + "%");
                        }
                        rs = ps.executeQuery();
                        while (rs.next()) {
                %>
                <tr>
                    <td><%= rs.getInt("employee_id") %></td>
                    <td><%= rs.getString("first_name") %> <%= rs.getString("last_name") %></td>
                    <td><%= rs.getString("email") %></td>
                    <td><%= rs.getString("ssn") %></td>
                    <td class="actions">
                        <a href="editCustomerRep.jsp?employeeID=<%= rs.getInt("employee_id") %>" class="edit">Edit</a>
                        <a href="deleteCustomerRep.jsp?employeeID=<%= rs.getInt("employee_id") %>" class="delete">Delete</a>
                   	
                    </td>
                </tr>
                <%
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    } finally {
                        if (rs != null) rs.close();
                        if (ps != null) ps.close();
                        if (conn != null) conn.close();
                    }
                %>
            </tbody>
        </table>
    </div>
    </div>
</body>
</html>

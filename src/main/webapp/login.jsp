<%@ page import="java.sql.*, com.railway.db.DatabaseConnection" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login Processing</title>
    <link rel="stylesheet" href="assets/style.css">
</head>
<body>
    <%
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username == null || password == null || username.trim().isEmpty() || password.trim().isEmpty()) {
            out.println("<script>");
            out.println("alert('Please enter both username and password.');");
            out.println("window.location.href = 'login.html';");
            out.println("</script>");
        } else {
            Connection conn = null;
            PreparedStatement ps = null;
            ResultSet rs = null;

            try {
                // Initialize database connection
                conn = DatabaseConnection.initializeDatabase();

                // Query to fetch user and role information
                String userQuery = "SELECT U.user_id, U.username, R.role_name " +
                                   "FROM users U " +
                                   "JOIN roles R ON U.role_id = R.role_id " +
                                   "WHERE U.username = ? AND U.password = ?";
                ps = conn.prepareStatement(userQuery);
                ps.setString(1, username);
                ps.setString(2, password);

                rs = ps.executeQuery();

                if (rs.next()) {
                    String role = rs.getString("role_name");

                    // Store user details in session
                    session.setAttribute("userID", rs.getString("user_id"));
                    session.setAttribute("username", rs.getString("username"));
                    session.setAttribute("role", role);

                    int customerOrEmployeeId = 0;

                    // Determine the ID based on the role
                    if ("Customer".equalsIgnoreCase(role)) {
                        String customerQuery = "SELECT customer_id FROM customers WHERE user_id = ?";
                        PreparedStatement psCustomer = conn.prepareStatement(customerQuery);
                        psCustomer.setInt(1, rs.getInt("user_id"));
                        ResultSet rsCustomer = psCustomer.executeQuery();

                        if (rsCustomer.next()) {
                            customerOrEmployeeId = rsCustomer.getInt("customer_id");
                            session.setAttribute("customerId", customerOrEmployeeId);
                        }
                        rsCustomer.close();
                        psCustomer.close();
                    } else if ("Admin".equalsIgnoreCase(role) || "CustomerRep".equalsIgnoreCase(role)) {
                        String employeeQuery = "SELECT employee_id FROM employees WHERE user_id = ?";
                        PreparedStatement psEmployee = conn.prepareStatement(employeeQuery);
                        psEmployee.setInt(1, rs.getInt("user_id"));
                        ResultSet rsEmployee = psEmployee.executeQuery();

                        if (rsEmployee.next()) {
                            customerOrEmployeeId = rsEmployee.getInt("employee_id");
                            session.setAttribute("employeeId", customerOrEmployeeId);
                        }
                        rsEmployee.close();
                        psEmployee.close();
                    } 

                    // Redirect based on role
                    if ("Admin".equalsIgnoreCase(role)) {
                        out.println("<script>");
                        out.println("alert('Login successful! Redirecting to Admin Dashboard.');");
                        out.println("window.location.href = 'adminDashboard.jsp';");
                        out.println("</script>");
                    } else if ("CustomerRep".equalsIgnoreCase(role)) {
                        out.println("<script>");
                        out.println("alert('Login successful! Redirecting to Customer Representative Dashboard.');");
                        out.println("window.location.href = 'customerRepDashboard.jsp';");
                        out.println("</script>");
                    } else if ("Customer".equalsIgnoreCase(role)) {
                        out.println("<script>");
                        out.println("alert('Login successful! Redirecting to Customer Dashboard.');");
                        out.println("window.location.href = 'customerDashboard.jsp';");
                        out.println("</script>");
                    } else {
                        out.println("<script>");
                        out.println("alert('Invalid role assigned. Contact admin.');");
                        out.println("window.location.href = 'login.html';");
                        out.println("</script>");
                    }
                } else {
                    // Display error popup for invalid credentials
                    out.println("<script>");
                    out.println("alert('Invalid username or password. Please try again.');");
                    out.println("window.location.href = 'login.html';");
                    out.println("</script>");
                }
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<script>");
                out.println("alert('An error occurred. Please try again later.');");
                out.println("window.location.href = 'login.html';");
                out.println("</script>");
            } finally {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            }
        }
    %>
</body>
</html>

<%@ page import="java.sql.*, com.railway.db.DatabaseConnection" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Register Processing</title>
    <link rel="stylesheet" href="assets/style.css">
</head>
<body>
    <%
        String firstName = request.getParameter("firstname");
        String lastName = request.getParameter("lastname");
        String email = request.getParameter("email");
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (firstName == null || lastName == null || email == null || username == null || password == null ||
            firstName.trim().isEmpty() || lastName.trim().isEmpty() || email.trim().isEmpty() ||
            username.trim().isEmpty() || password.trim().isEmpty()) {
            out.println("<script>");
            out.println("alert('Please fill in all the required fields.');");
            out.println("window.location.href = 'register.html';");
            out.println("</script>");
        } else {
            Connection conn = null;
            PreparedStatement psUser = null;
            PreparedStatement psCustomer = null;

            try {
                conn = DatabaseConnection.initializeDatabase();

                // Check if username or email already exists
                String checkQuery = "SELECT * FROM users WHERE username = ? OR user_id IN (SELECT user_id FROM customers WHERE email = ?)";
                psUser = conn.prepareStatement(checkQuery);
                psUser.setString(1, username);
                psUser.setString(2, email);
                ResultSet rs = psUser.executeQuery();

                if (rs.next()) {
                    out.println("<script>");
                    out.println("alert('Username or Email already exists. Please choose another.');");
                    out.println("window.location.href = 'register.html';");
                    out.println("</script>");
                } else {
                    // Insert into Users table
                    String userQuery = "INSERT INTO users (username, password, role_id) VALUES (?, ?, ?)";
                    psUser = conn.prepareStatement(userQuery, Statement.RETURN_GENERATED_KEYS);
                    psUser.setString(1, username);
                    psUser.setString(2, password);
                    psUser.setInt(3, 1); // RoleID 1 = Customer

                    int userResult = psUser.executeUpdate();

                    if (userResult > 0) {
                        ResultSet generatedKeys = psUser.getGeneratedKeys();
                        if (generatedKeys.next()) {
                            int userID = generatedKeys.getInt(1);

                            // Insert into Customers table
                            String customerQuery = "INSERT INTO customers (user_id, first_name, last_name, email) VALUES (?, ?, ?, ?)";
                            psCustomer = conn.prepareStatement(customerQuery);
                            psCustomer.setInt(1, userID);
                            psCustomer.setString(2, firstName);
                            psCustomer.setString(3, lastName);
                            psCustomer.setString(4, email);

                            int customerResult = psCustomer.executeUpdate();

                            if (customerResult > 0) {
                                out.println("<script>");
                                out.println("alert('Account successfully created! Redirecting to login page.');");
                                out.println("window.location.href = 'login.html';");
                                out.println("</script>");
                            } else {
                                out.println("<p style='color:red;'>Failed to create customer record. Please try again.</p>");
                            }
                        }
                    } else {
                        out.println("<p style='color:red;'>Registration failed. Please try again.</p>");
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<p style='color:red;'>An error occurred. Please try again later.</p>");
            } finally {
                if (psCustomer != null) psCustomer.close();
                if (psUser != null) psUser.close();
                if (conn != null) conn.close();
            }
        }
    %>
</body>
</html>

<%@ page session="true" %>
<%@ page import="java.io.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Logout</title>
</head>
<body>
    <%
        // Invalidate the current session
        if (session != null) {
            session.invalidate();
        }

        // Redirect to the login page
        response.sendRedirect("login.html");
    %>
</body>
</html>

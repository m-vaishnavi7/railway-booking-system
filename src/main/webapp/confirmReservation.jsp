<%@ page import="java.sql.*, com.railway.db.DatabaseConnection" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reservation Confirmation</title>
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@400&family=Cormorant+SC:wght@300;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="assets/style.css">
</head>
<body>
    <!-- Header Section -->
    <header class="header">
        <div class="container">
            <h1 class="site-title">Online Railway Booking System</h1>
            <nav class="navbar">
                <a href="javascript:history.back()">Back</a>
                <a href="customerDashboard.jsp">Home</a>
                <a href="logout.jsp">Logout</a>
            </nav>
        </div>
    </header>

    <%
        // Fetch reservation details from the form
        String scheduleID = request.getParameter("scheduleID");
    	String trainId = request.getParameter("trainID");
    	String originID = request.getParameter("originID");
    	String destinationID = request.getParameter("destinationID");
        String tripType = request.getParameter("tripType");
        String numAdults = request.getParameter("numAdults");
        String numChild = request.getParameter("numChildren");
        String numSeniors = request.getParameter("numSeniors");
        String numDisabled = request.getParameter("numDisabled");
        double totalFare = Double.parseDouble(request.getParameter("totalFare"));

        // Simulating customer and train IDs (replace with actual session management logic)
        Integer customerId = (Integer) session.getAttribute("customerId");

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DatabaseConnection.initializeDatabase();

            // Insert reservation into the database
            String insertQuery = "INSERT INTO reservations (customer_id, schedule_id, origin_station_id, destination_station_id, trip_type, num_adults, num_children, num_seniors, num_disabled, total_fare) " +
                                 "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            ps = conn.prepareStatement(insertQuery);
            ps.setInt(1, customerId);
            ps.setString(2, scheduleID);
            ps.setString(3, originID);
            ps.setString(4, destinationID);
            ps.setString(5, tripType);
            ps.setString(6, numAdults);
            ps.setString(7, numChild);
            ps.setString(8, numSeniors);
            ps.setString(9, numDisabled);
            ps.setDouble(10, totalFare);

            int rowsInserted = ps.executeUpdate();

            if (rowsInserted > 0) {
    %>
 <div class="dashboard-section">
    <div class="dashboard-card">
        <h2 class="hero-title">Reservation Confirmed!</h2>
        <p class="confirmation-message">Your reservation has been successfully booked. Below are the details:</p>
        <table class="results-table" style="width: 500px; margin: 0 auto;">
            <thead>
                <tr>
                    <th>Detail</th>
                    <th>Value</th>
                </tr>
            </thead>
            <tbody>
                <tr><th>Trip Type:</th><td><%= tripType %></td></tr>
                <tr><th>Number of Adults:</th><td><%= numAdults %></td></tr>
                <tr><th>Number of Children:</th><td><%= numChild %></td></tr>
                <tr><th>Number of Seniors:</th><td><%= numSeniors %></td></tr>
                <tr><th>Number of Disabled:</th><td><%= numDisabled %></td></tr>
                <tr><th>Total Fare:</th><td>$<%= totalFare %></td></tr>
            </tbody>
        </table>
        <div class="form-group-inline">
            <a href="viewReservations.jsp" class="button">View All Reservations</a>
        </div>
    </div>
</div>
<%
        } else {
%>
<div class="dashboard-section">
    <div class="dashboard-card" >
        <div class="error-message">Failed to process your reservation. Please try again later.</div>
        <div class="form-group-inline">
            <a href="makeReservation.jsp?scheduleID=<%= scheduleID %>" class="button">Back to Reservation</a>
        </div>
    </div>
</div>
<%
        }
    } catch (Exception e) {
        e.printStackTrace();
%>
<div class="dashboard-section">
    <div class="dashboard-card">
        <div class="error-message">An error occurred while processing your reservation. Please try again later.</div>
        <div class="form-group-inline">
            <a href="makeReservation.jsp?scheduleID=<%= scheduleID %>" class="button">Back to Reservation</a>
        </div>
    </div>
</div>
<%
    } finally {
        if (ps != null) ps.close();
        if (conn != null) conn.close();
    }
%>
</body>
</html>

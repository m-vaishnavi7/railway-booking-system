<%@ page import="java.sql.*, com.railway.db.DatabaseConnection" %>
<%
    String reservationId = request.getParameter("reservationId");
    if (reservationId != null && !reservationId.trim().isEmpty()) {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DatabaseConnection.initializeDatabase();
            String cancelQuery = "UPDATE reservations SET is_cancelled = TRUE WHERE reservation_id = ?";
            ps = conn.prepareStatement(cancelQuery);
            ps.setInt(1, Integer.parseInt(reservationId));
            ps.executeUpdate();
            session.setAttribute("message", "Reservation canceled successfully.");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Error canceling the reservation.");
        } finally {
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        }
    } else {
        session.setAttribute("error", "Invalid reservation ID.");
    }
    response.sendRedirect("viewReservations.jsp");
%>

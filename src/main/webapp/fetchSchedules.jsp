<%@ page import="java.sql.*, java.util.*, com.railway.db.DatabaseConnection" %>
<%
    String origin = request.getParameter("origin");
    String destination = request.getParameter("destination");
    String travelDate = request.getParameter("date");
    String sortBy = request.getParameter("sort"); // Get sort criteria from the dropdown

    if (origin != null && destination != null && travelDate != null &&
        !origin.trim().isEmpty() && !destination.trim().isEmpty() && !travelDate.trim().isEmpty()) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DatabaseConnection.initializeDatabase();

            // Determine sort field for the query
            String sortField = "TS.departure_datetime"; // Default sort by departure time
            if ("arrivalTime".equals(sortBy)) {
                sortField = "TS.arrival_datetime";
            } else if ("fare".equals(sortBy)) {
                sortField = "calculated_fare"; // Dynamic fare calculation column
            }

            String query = "SELECT DISTINCT " +
                           "TS.schedule_id, " +
            			   "TS.transit_line_name, " +
                           "TS.train_id, " +
                           "TS.fare AS total_fare, " +
                           "TS.departure_datetime, " +
                           "S1.station_id AS origin, " +
                           "S1.departure_time, " +
                           "S2.station_id AS destination, " +
                           "S2.arrival_time, " +
                           "T.train_name, " +
                           "ABS(S1.stop_order - S2.stop_order) AS stop_order_difference, " +
                           "(TS.fare / (SELECT COUNT(*) FROM stops S WHERE S.schedule_id = TS.schedule_id)) * ABS(S1.stop_order - S2.stop_order) AS calculated_fare " +
                           "FROM train_schedules TS " +
                           "JOIN stops S1 ON TS.schedule_id = S1.schedule_id " +
                           "JOIN stops S2 ON TS.schedule_id = S2.schedule_id " +
                           "JOIN stations St1 ON S1.station_id = St1.station_id " +
                           "JOIN stations St2 ON S2.station_id = St2.station_id " +
                           "JOIN trains T ON TS.train_id = T.train_id " +
                           "WHERE St1.station_name = ? " +
                           "AND St2.station_name = ? " +
                           "AND DATE(TS.departure_datetime) = ? " +
                           "AND S1.stop_order < S2.stop_order " +
                           "ORDER BY " + sortField;

            ps = conn.prepareStatement(query);
            ps.setString(1, origin);
            ps.setString(2, destination);
            ps.setString(3, travelDate);

            rs = ps.executeQuery();

            List<Map<String, String>> results = new ArrayList<>();
            while (rs.next()) {
                Map<String, String> result = new HashMap<>();
                result.put("ScheduleID", rs.getString("schedule_id"));
                result.put("TrainID", rs.getString("train_id"));
                result.put("TrainName", rs.getString("train_name"));
                result.put("TransitLineName", rs.getString("transit_line_name"));
                result.put("Origin", rs.getString("origin"));
                result.put("Departure", rs.getString("departure_time"));
                result.put("Destination", rs.getString("destination"));
                result.put("Arrival", rs.getString("arrival_time"));
                result.put("StopsBetween", rs.getString("stop_order_difference"));
                result.put("Fare", String.format("%.2f", rs.getDouble("calculated_fare")));
                result.put("Origin",origin);
                result.put("Destination",destination);
                results.add(result);
            }

            if (!results.isEmpty()) {
                session.setAttribute("searchResults", results);
                session.setAttribute("sortBy", sortBy); // Pass the selected sort field back to the results page
                response.sendRedirect("searchTrains.jsp");
            } else {
                session.setAttribute("error", "No results found for the given criteria.");
                response.sendRedirect("searchTrains.jsp");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "An error occurred while processing your request. Please try again.");
            response.sendRedirect("searchTrains.jsp");
        } finally {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        }
    } else {
        session.setAttribute("error", "Please provide all required inputs.");
        response.sendRedirect("searchTrains.jsp");
    }
%>

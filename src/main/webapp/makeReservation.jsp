<%@ page import="java.sql.*, java.util.*, com.railway.db.DatabaseConnection" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Make a Reservation</title>
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
    Connection conn = DatabaseConnection.initializeDatabase();
    PreparedStatement psDiscount = null;
    ResultSet rsDiscount = null;
    try {
        String discountQuery = "SELECT discount_type, discount_rate FROM discounts";
        psDiscount = conn.prepareStatement(discountQuery);
        rsDiscount = psDiscount.executeQuery();
        while (rsDiscount.next()) {
            String discountType = rsDiscount.getString("discount_type").toLowerCase();
            double discountRate = rsDiscount.getDouble("discount_rate");
%>
    <input type="hidden" id="<%= discountType %>Discount" value="<%= discountRate %>">
<% 
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rsDiscount != null) rsDiscount.close();
        if (psDiscount != null) psDiscount.close();
        if (conn != null) conn.close();
    }
%>
    <%
        String scheduleID = request.getParameter("scheduleID");
        String trainID = request.getParameter("trainID");
        String origin = request.getParameter("origin");
        String destination = request.getParameter("destination");
        String departure = request.getParameter("traveldate");
        if (scheduleID == null || scheduleID.trim().isEmpty()) {
    %>
    <div class="error-message">Invalid schedule. Please try again.</div>
    <div class="back-link">
        <a href="searchTrains.jsp">Back to Search</a>
    </div>
    <%
        } else {
            conn = null;
            PreparedStatement ps = null;
            ResultSet rs = null;

            try {
                conn = DatabaseConnection.initializeDatabase();
                
                
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
                        "AND DATE(TS.departure_datetime) = DATE(?) " +
                        "AND S1.stop_order < S2.stop_order " +
                        "AND TS.schedule_id = ?";

				         ps = conn.prepareStatement(query);
				         ps.setString(1, origin);
				         ps.setString(2, destination);
				         ps.setString(3, departure);
				         ps.setString(4, scheduleID);
				
				         rs = ps.executeQuery();
				
				         List<Map<String, String>> results = new ArrayList<>();

                if (rs.next()) {
                    double baseFare = Double.parseDouble(request.getParameter("calculatedFare"));
    %>
    
    <!-- Reservation Form Section -->
    <div class="dashboard-section">
        <div class="dashboard-card">
            <h2 class="hero-title">Make a Reservation</h2>

            <!-- Reservation Form -->
            <form id="reservationForm" method="POST" action="confirmReservation.jsp" class="search-form-vertical">
                <input type="hidden" name="scheduleID" value="<%= scheduleID %>">
        		<input type="hidden" name="trainID" value="<%= trainID %>">
        		<input type="hidden" name="originID" value="<%= rs.getString("origin") %>">
        		<input type="hidden" name="destinationID" value="<%= rs.getString("destination") %>">
                <!-- Train Details as Non-Editable Input Boxes -->
                <div class="form-group-inline" style="width: 500px; margin: 0 auto;">
                    <label for="trainName">Train Name:</label>
                    <input type="text" id="trainName" class="form-input" value="<%= rs.getString("train_name") %>" readonly />
                </div>
                <div class="form-group-inline" style="width: 500px; margin: 0 auto;">
                    <label for="baseFare">Base Fare:</label>
                    <input type="text" id="baseFare" class="form-input" value="$<%= rs.getDouble("calculated_fare") %>" readonly />
                </div>
                <div class="form-group-inline" style="width: 500px; margin: 0 auto;">
                    <label for="origin">Origin:</label>
                    <input type="text" id="origin" class="form-input" value="<%= origin %>" readonly />
                </div>
                <div class="form-group-inline" style="width: 500px; margin: 0 auto;">
                    <label for="departure">Departure:</label>
                    <input type="text" id="departure" class="form-input" value="<%= rs.getString("departure_time") %>" readonly />
                </div>
                <div class="form-group-inline" style="width: 500px; margin: 0 auto;">
                    <label for="destination">Destination:</label>
                    <input type="text" id="destination" class="form-input" value="<%= destination %>" readonly />
                </div>
                <div class="form-group-inline" style="width: 500px; margin: 0 auto;">
                    <label for="arrival">Arrival:</label>
                    <input type="text" id="arrival" class="form-input" value="<%= rs.getString("arrival_time") %>" readonly />
                </div>
                <div class="form-group-inline" style="width: 500px; margin: 0 auto;">
                	<label for="tripType">Trip Type:</label>
                <select id="tripType" name="tripType" required onchange="calculateFare()">
	                <option value="One-Way">One-Way</option>
	                <option value="Round-Trip">Round-Trip</option>
	            </select>
                </div>
                <!-- Passenger Categories -->
                <div class="form-group-inline" style="width: 500px; margin: 0 auto;">
                    <label for="numAdults">Number of Adults:</label>
                    <input type="number" id="numAdults" name="numAdults" class="form-input" value="1" min="0" onchange="calculateFare()" required />
                </div>
                <div class="form-group-inline" style="width: 500px; margin: 0 auto;">
                    <label for="numChildren">Number of Children:</label>
                    <input type="number" id="numChildren" name="numChildren" class="form-input" value="0" min="0" onchange="calculateFare()" required />
                </div>
                <div class="form-group-inline" style="width: 500px; margin: 0 auto;">
                    <label for="numSeniors">Number of Seniors:</label>
                    <input type="number" id="numSeniors" name="numSeniors" class="form-input" value="0" min="0" onchange="calculateFare()" required />
                </div>
                <div class="form-group-inline" style="width: 500px; margin: 0 auto;">
                    <label for="numDisabled">Number of Disabled Passengers:</label>
                    <input type="number" id="numDisabled" name="numDisabled" class="form-input" value="0" min="0" onchange="calculateFare()" required />
                </div>

                <!-- Total Fare -->
                <div class="form-group-inline" style="width: 500px; margin: 0 auto;">
                    <label for="totalFare">Total Fare:</label>
                    <input type="text" id="totalFare" class="form-input" value="$<%= rs.getDouble("calculated_fare") %>" readonly />
                    <input type="hidden" id="totalFareInput" name="totalFare" value="<%= rs.getDouble("calculated_fare") %>" />
                </div>
				<br/>
                <button type="submit" class="button">Confirm Reservation</button>
            </form>
        </div>
    </div>
    <div class="back-link">
        <a href="searchTrains.jsp">Back to Search</a>
    </div>
    <%
                } else {
    %>
    <div class="error-message">No train details found for the selected schedule.</div>
    <div class="back-link">
        <a href="searchTrains.jsp">Back to Search</a>
    </div>
    <%
                }
            } catch (Exception e) {
                e.printStackTrace();
    %>
    <div class="error-message">An error occurred while processing your request. Please try again later.</div>
    <div class="back-link">
        <a href="searchTrains.jsp">Back to Search</a>
    </div>
    <%
            } finally {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            }
        }
    %>
    

    <script>
    
    // JavaScript for Fare Calculation
    function calculateFare() {
    const baseFare = parseFloat(document.getElementById('baseFare').value.replace('$', ''));
    const numAdults = parseInt(document.getElementById('numAdults').value);
    const numChildren = parseInt(document.getElementById('numChildren').value);
    const numSeniors = parseInt(document.getElementById('numSeniors').value);
    const numDisabled = parseInt(document.getElementById('numDisabled').value);

    // Fetch discount values from hidden inputs
    const childDiscount = parseFloat(document.getElementById('childDiscount').value) || 0;
    const seniorDiscount = parseFloat(document.getElementById('seniorDiscount').value) || 0;
    const disabledDiscount = parseFloat(document.getElementById('disabledDiscount').value) || 0;

    // Calculate individual fares
    const adultFare = baseFare * numAdults;
    const childFare = baseFare * (1 - childDiscount) * numChildren;
    const seniorFare = baseFare * (1 - seniorDiscount) * numSeniors;
    const disabledFare = baseFare * (1 - disabledDiscount) * numDisabled;

    // Determine trip type (One-Way or Round-Trip)
    const tripType = document.getElementById('tripType').value;
    let totalFare = adultFare + childFare + seniorFare + disabledFare;

    // Apply round-trip multiplier if applicable
    if (tripType === "Round-Trip") {
        totalFare *= 2;
    }

    // Update the total fare display and form input
    document.getElementById('totalFare').value = '$' + totalFare.toFixed(2);
    document.getElementById('totalFareInput').value = totalFare.toFixed(2);
}

    </script>
</body>
</html>

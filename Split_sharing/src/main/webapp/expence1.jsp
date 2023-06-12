<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Expense Submission</title>
</head>
<body>
<%
    // Retrieve the username, roomname, and spent value from the request parameters
    String username = request.getParameter("username");
    String roomname = request.getParameter("roomname");
    double additionalSpent = Double.parseDouble(request.getParameter("spent"));

    // Database connection details
    String jdbcUrl = "jdbc:mysql://localhost:3306/moneydata";
    String username_1 = "root";
    String password_1 = "root";

    try {
        // Load the MySQL JDBC driver (Assuming the driver JAR is present in your classpath)
        Class.forName("com.mysql.jdbc.Driver");

        // Establish the database connection
        Connection connection = DriverManager.getConnection(jdbcUrl, username_1, password_1);

        // Update the "spent" value for the specific user in the temporary table
        String updateTempQuery = "UPDATE " + roomname + " SET spent = spent + ? WHERE username = ?";
        PreparedStatement updateTempStatement = connection.prepareStatement(updateTempQuery);
        updateTempStatement.setDouble(1, additionalSpent);
        updateTempStatement.setString(2, username);
        updateTempStatement.executeUpdate();

        // Calculate the total spent and participant count
        String selectTempQuery = "SELECT * FROM " + roomname;
        PreparedStatement selectTempStatement = connection.prepareStatement(selectTempQuery);
        ResultSet tempResultSet = selectTempStatement.executeQuery();

        double totalSpent = 0;
        int participantCount = 0;

        while (tempResultSet.next()) {
            double userSpent = tempResultSet.getDouble("spent");
            totalSpent += userSpent;
            participantCount++;
        }

        // Calculate the debt per participant
        double debtPerParticipant = totalSpent / participantCount;

        // Create a temporary table to store the updated values
        String tempTable = roomname + "_temp";
        String createTempTableQuery = "CREATE TEMPORARY TABLE " + tempTable + " SELECT * FROM " + roomname;
        Statement createTempTableStatement = connection.createStatement();
        createTempTableStatement.execute(createTempTableQuery);

        // Update the "debt" value for all users in the temporary table
        String updateTempDebtQuery = "UPDATE " + tempTable + " SET givetake = spent - ?";
        PreparedStatement updateTempDebtStatement = connection.prepareStatement(updateTempDebtQuery);
        updateTempDebtStatement.setDouble(1, debtPerParticipant);
        updateTempDebtStatement.executeUpdate();

        // Copy the updated values from the temporary table to the original table
        String copyDataQuery = "UPDATE " + roomname + " SET spent = ?, givetake = ? WHERE username = ?";
        PreparedStatement copyDataStatement = connection.prepareStatement(copyDataQuery);

        String selectTempDataQuery = "SELECT * FROM " + tempTable;
        PreparedStatement selectTempDataStatement = connection.prepareStatement(selectTempDataQuery);
        ResultSet tempDataResultSet = selectTempDataStatement.executeQuery();

        while (tempDataResultSet.next()) {
            double spentValue = tempDataResultSet.getDouble("spent");
            double debtValue = tempDataResultSet.getDouble("givetake");
            String usernameDB = tempDataResultSet.getString("username");
            copyDataStatement.setDouble(1, spentValue);
            copyDataStatement.setDouble(2, debtValue);
            copyDataStatement.setString(3, usernameDB);
            copyDataStatement.executeUpdate();
        }

        // Close the database resources
        tempDataResultSet.close();
        selectTempDataStatement.close();
        copyDataStatement.close();
        createTempTableStatement.close();
        updateTempDebtStatement.close();
        updateTempStatement.close();
        tempResultSet.close();
        selectTempStatement.close();
        connection.close();

        // Redirect to calculate.jsp
        response.sendRedirect("expence.jsp");
    } catch (ClassNotFoundException e) {
        e.printStackTrace();
    } catch (SQLException e) {
        e.printStackTrace();
    }
%>
</body>
</html>

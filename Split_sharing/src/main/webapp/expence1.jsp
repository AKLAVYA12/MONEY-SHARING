<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Expense Submission</title>
</head>
<body>
<%

    String username = request.getParameter("username");
    String roomname = request.getParameter("roomname");
    double additionalSpent = Double.parseDouble(request.getParameter("spent"));

    String jdbcUrl = "jdbc:mysql://localhost:3306/moneydata";
    String username_1 = "root";
    String password_1 = "root";

    try {
        Class.forName("com.mysql.jdbc.Driver");

        Connection connection = DriverManager.getConnection(jdbcUrl, username_1, password_1);

        String updateTempQuery = "UPDATE " + roomname + " SET spent = spent + ? WHERE username = ?";
        PreparedStatement updateTempStatement = connection.prepareStatement(updateTempQuery);
        updateTempStatement.setDouble(1, additionalSpent);
        updateTempStatement.setString(2, username);
        updateTempStatement.executeUpdate();

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

        double debtPerParticipant = totalSpent / participantCount;

        String tempTable = roomname + "_temp";
        String createTempTableQuery = "CREATE TEMPORARY TABLE " + tempTable + " SELECT * FROM " + roomname;
        Statement createTempTableStatement = connection.createStatement();
        createTempTableStatement.execute(createTempTableQuery);

        String updateTempDebtQuery = "UPDATE " + tempTable + " SET givetake = spent - ?";
        PreparedStatement updateTempDebtStatement = connection.prepareStatement(updateTempDebtQuery);
        updateTempDebtStatement.setDouble(1, debtPerParticipant);
        updateTempDebtStatement.executeUpdate();

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

        tempDataResultSet.close();
        selectTempDataStatement.close();
        copyDataStatement.close();
        createTempTableStatement.close();
        updateTempDebtStatement.close();
        updateTempStatement.close();
        tempResultSet.close();
        selectTempStatement.close();
        connection.close();

        response.sendRedirect("expence.jsp");
    } catch (ClassNotFoundException e) {
        e.printStackTrace();
    } catch (SQLException e) {
        e.printStackTrace();
    }
%>
</body>
</html>

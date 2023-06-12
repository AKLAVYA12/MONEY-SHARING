<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Money Sharing Room</title>
    <link rel="stylesheet" type="text/css" href="styles.css">
</head>
<body>
<%
// Database connection details
String jdbcUrl = "jdbc:mysql://localhost:3306/moneydata";
String username_1 = "root";
String password_1 = "root";

// Retrieve the roomname and username from the session
HttpSession session_1 = request.getSession();
String roomname = (String) session_1.getAttribute("roomname");
String username = (String) session_1.getAttribute("username");

try {
    // Establish the database connection
    Connection connection = DriverManager.getConnection(jdbcUrl, username_1, password_1);

    // Check if the table already exists
    DatabaseMetaData metaData = connection.getMetaData();
    ResultSet tables = metaData.getTables(null, null, roomname, null);

    // If the table exists
    if (tables.next()) {
        // Check if the username already exists in the table
        String selectQuery = "SELECT * FROM " + roomname + " WHERE username = ?";
        PreparedStatement selectStatement = connection.prepareStatement(selectQuery);
        selectStatement.setString(1, username);
        ResultSet resultSet = selectStatement.executeQuery();

        // If the username is already registered, redirect to index.html with a message
        if (resultSet.next()) {
            response.sendRedirect("index.html?message=already_registered");
        } else {
            // Insert the username into the existing table
            String insertQuery = "INSERT INTO " + roomname + " (username) VALUES (?)";
            PreparedStatement insertStatement = connection.prepareStatement(insertQuery);
            insertStatement.setString(1, username);
            insertStatement.executeUpdate();

            // Close the database resources
            insertStatement.close();
        }

        // Close the database resources
        resultSet.close();
        selectStatement.close();
    } else {
    	// Create the new table with the roomname as the table name
    	String createTableQuery = "CREATE TABLE " + roomname + "  (id INT AUTO_INCREMENT PRIMARY KEY, username VARCHAR(255), spent INT, givetake INT)";
    	Statement createTableStatement = connection.createStatement();
    	createTableStatement.executeUpdate(createTableQuery);

        // Insert the username into the newly created table
        String insertQuery = "INSERT INTO " + roomname + " (username) VALUES (?)";
        PreparedStatement insertStatement = connection.prepareStatement(insertQuery);
        insertStatement.setString(1, username);
        insertStatement.executeUpdate();
       
        // Set the roomname attribute in the session
        session_1.setAttribute("roomname", roomname);
        session_1.setAttribute("username", username);
        // Redirect the user to room.jsp with roomname as a query parameter
        response.sendRedirect("room.html?roomname=" + roomname + "&username" + username);

        // Close the database resources
        insertStatement.close();
        createTableStatement.close();
    }

    // Close the database resources
    tables.close();
    connection.close();
} catch (SQLException e) {
    e.printStackTrace();
}

%>
</body>
</html>


<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
 <link rel="stylesheet" type="text/css" href="jsp.css">
    <meta charset="UTF-8">
    <title>Login</title>
</head>
<body>
<%
// Database connection details
String jdbcUrl = "jdbc:mysql://localhost:3306/moneydata";
String username_1 = "root";
String password_1 = "root";

// Retrieve the roomname, username, and password from the request parameters
String roomname = request.getParameter("roomname");
String username = request.getParameter("username");
String password = request.getParameter("password");

try {
    // Load the MySQL JDBC driver (Assuming the driver JAR is present in your classpath)
    Class.forName("com.mysql.jdbc.Driver");

    // Establish the database connection
    Connection connection = DriverManager.getConnection(jdbcUrl, username_1, password_1);

    // Check if the table exists for the provided roomname
    DatabaseMetaData metaData = connection.getMetaData();
    ResultSet tables = metaData.getTables(null, null, roomname, null);

    if (tables.next()) {
        // Check if the password matches the room's password
        String selectQuery = "SELECT * FROM rooms WHERE roomname = ? AND password = ?";
        PreparedStatement selectStatement = connection.prepareStatement(selectQuery);
        selectStatement.setString(1, roomname);
        selectStatement.setString(2, password);
        ResultSet resultSet = selectStatement.executeQuery();

        if (resultSet.next()) {
            // Roomname and password match, check if the username exists in the table
            String selectUserQuery = "SELECT * FROM " + roomname + " WHERE username = ?";
            PreparedStatement selectUserStatement = connection.prepareStatement(selectUserQuery);
            selectUserStatement.setString(1, username);
            ResultSet userResultSet = selectUserStatement.executeQuery();

            if (userResultSet.next()) {
                // Username exists, set session attributes and redirect to expence.jsp
                session.setAttribute("roomname", roomname);
                session.setAttribute("username", username);
                response.sendRedirect("expence.jsp?roomname=" + roomname + "&username=" + username);
            } else {
                // Username not registered in the room
                out.println("<p class=\"error-message\">Name not registered in room.</p>");
                out.println("<p class=\"error-message\"><a href=\"registername.jsp\">Click here to register.</a></p>");
            }
            

            // Close the database resources
            userResultSet.close();
            selectUserStatement.close();
        } else {
            // Invalid password for the room
            out.println("<p class=\"error-message1\">Invalid password.</p>");
            out.println("<p class=\"error-message\"><a href=\"roomlogin.html\">Click here to go back.</a></p>");		
        }

        // Close the database resources
        resultSet.close();
        selectStatement.close();
    } else {
        // Table doesn't exist for the provided roomname
        out.println("<p class=\"error-message2\">Invalid RoomName</p>");
        out.println("<p class=\"error-message\"><a href=\"roomlogin.html\">Click here to go back.</a></p>");		
    }

    // Close the database resources
    tables.close();
    connection.close();
} catch (ClassNotFoundException e) {
    e.printStackTrace();
} catch (SQLException e) {
    e.printStackTrace();
}
%>
</body>
</html>

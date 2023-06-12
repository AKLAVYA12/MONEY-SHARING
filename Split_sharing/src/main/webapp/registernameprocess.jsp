<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<%
    // Retrieve form data
    String username = request.getParameter("username");
    String roomname = request.getParameter("roomname");
    
    // Perform database connection
    Connection connection = null;
    PreparedStatement statement = null;
    try {
        // Configure database connection
        String jdbcUrl = "jdbc:mysql://localhost:3306/moneydata";
        String dbUser = "root";
        String dbPassword = "root";

        // Create database connection
        Class.forName("com.mysql.jdbc.Driver");
        connection = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword);

        // Check if username already exists in the table
        String checkSql = "SELECT * FROM " + roomname + " WHERE username = ?";
        statement = connection.prepareStatement(checkSql);
        statement.setString(1, username);
        ResultSet resultSet = statement.executeQuery();

        if (resultSet.next()) {
            // Redirect to an error page indicating that the username already exists
            response.sendRedirect("index.html?errorMessage=Username already exists");
        } else {
            // Prepare SQL statement to insert user data into the table
            String insertSql = "INSERT INTO " + roomname + "(username) VALUES (?)";
            statement = connection.prepareStatement(insertSql);
            statement.setString(1, username);

            // Execute the SQL statement
            statement.executeUpdate();

            // Redirect to a success page or login page
            System.out.println("sucessfully register");
            response.sendRedirect("roomlogin.html");
        }
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("register.jsp?errorMessage=An error occurred");
    } finally {
        // Close the database resources
        if (statement != null) {
            statement.close();
        }
        if (connection != null) {
            connection.close();
        }
    }
%>        
</body>
</html>

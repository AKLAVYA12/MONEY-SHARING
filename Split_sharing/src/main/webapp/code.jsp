<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>

<%
    // Database connection details
    String jdbcUrl = "jdbc:mysql://localhost:3306/moneydata";
    String username_1 = "root";
    String password_1 = "root";

    // Retrieve the values of "roomname" and "password" submitted from the form
    String roomname = request.getParameter("roomname");
    String password = request.getParameter("password");

    try {
        // Establish the database connection
        Connection connection = DriverManager.getConnection(jdbcUrl, username_1, password_1);

        // Prepare the SQL query to check the roomname and password
        String sql = "SELECT * FROM rooms WHERE roomname = ? AND password = ?";
        PreparedStatement statement = connection.prepareStatement(sql);
        statement.setString(1, roomname);
        statement.setString(2, password);

        // Execute the query
        ResultSet resultSet = statement.executeQuery();

        // Check if a matching room is found
        if (resultSet.next()) {
            // Roomname and password are valid

            // Retrieve the value of "Username" from the form
            String username = request.getParameter("username");

            // Prepare the SQL query to check if the provided username exists in the register table
            String userQuery = "SELECT * FROM register WHERE username = ?";
            PreparedStatement userStatement = connection.prepareStatement(userQuery);
            userStatement.setString(1, username);

            // Execute the user query
            ResultSet userResultSet = userStatement.executeQuery();

            // Check if a matching username is found
            if (userResultSet.next()) {
            	HttpSession session_1 = request.getSession();
            	session_1.setAttribute("roomname", roomname);
            	session_1.setAttribute("username", username);

            	// Redirect the user to room.jsp with roomname and username as query parameters
            	response.sendRedirect("room.jsp?roomname=" + roomname + "&username=" + username);

            } else {
                // Handle invalid username
                out.println("Invalid username!");
            }

            // Close the user query resources
            userResultSet.close();
            userStatement.close();
        } else {
            // Handle invalid roomname or password
            out.println("Invalid roomname or password!");
        }

        // Close the database resources
        resultSet.close();
        statement.close();
        connection.close();
    } catch (SQLException e) {
        e.printStackTrace();
    }
%>

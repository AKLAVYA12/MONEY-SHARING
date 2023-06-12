<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Createroom</title>
</head>
<body>
<%
    String roomname = request.getParameter("roomname");
    String password = request.getParameter("password");
    String username = request.getParameter("username");
    String confirmPassword = request.getParameter("confirmpassword");

    if (!password.equals(confirmPassword)) {
        response.sendRedirect("createroom.jsp?errorMessage=Passwords do not match");
        return;
    }

    Connection connection = null;
    PreparedStatement statement = null;
    try {
        String jdbcUrl = "jdbc:mysql://localhost:3306/moneydata";
        String dbUser = "root";
        String dbPassword = "root";

        Class.forName("com.mysql.jdbc.Driver");
        connection = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword);

        String sql = "INSERT INTO rooms (roomname, password) VALUES (?, ?)";
        statement = connection.prepareStatement(sql);
        statement.setString(1, roomname);
        statement.setString(2, password);

        statement.executeUpdate();

        session.setAttribute("roomname", roomname);
        session.setAttribute("username", username);

        response.sendRedirect("room.jsp?Message=Room created successfully");
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("login.html?errorMessage=An error occurred");
    } finally {
        try {
            if (statement != null) {
                statement.close();
            }
            if (connection != null) {
                connection.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
</head>
<body>
<%
    Boolean isValidUser = false;
    String username = request.getParameter("username");
    String password = request.getParameter("password");

    try {

        Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/moneydata", "root", "root");

        String sql = "SELECT * FROM register WHERE username=? AND password=?";
        PreparedStatement statement = conn.prepareStatement(sql);
        statement.setString(1, username);
        statement.setString(2, password);
        ResultSet resultSet = statement.executeQuery();

        if (resultSet.next()) {

            isValidUser = true;
            String loggedInUsername = resultSet.getString("username");
            session.setAttribute("username", loggedInUsername);
        }

        resultSet.close();
        statement.close();
        conn.close();

    } catch (Exception e) {
        e.printStackTrace();
    }

    if (isValidUser) {
        response.sendRedirect("room.html");
    } else {
        response.sendRedirect("index.html"); 
    }
%>

</body>
</html>

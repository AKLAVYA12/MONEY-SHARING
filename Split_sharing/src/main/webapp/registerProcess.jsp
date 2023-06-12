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
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    String confirmPassword = request.getParameter("confirm-password");

    if (!password.equals(confirmPassword)) {
        response.sendRedirect("register.jsp?errorMessage=Passwords do not match");
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

        String sql = "INSERT INTO register (username, password) VALUES (?, ?)";
        statement = connection.prepareStatement(sql);
        statement.setString(1, username);
        statement.setString(2, password);

        statement.executeUpdate();

        response.sendRedirect("index.html");
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("register.jsp?errorMessage=An error occurred");
    } finally {

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
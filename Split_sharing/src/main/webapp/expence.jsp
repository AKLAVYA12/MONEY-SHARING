<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Money Sharing Room</title>
    <link rel="stylesheet" type="text/css" href="expence.css">
</head>
<body>
<%
    // Retrieve the username and roomname from session attributes
    String username = (String) session.getAttribute("username");
    String roomname = (String) session.getAttribute("roomname");
    
    out.println("<div class=\"headline\">Money Sharing Room</div>");
    out.println("<div class=\"welcome\">Welcome: " + username + "</div>");
    out.println("<div class=\"room-name\">Room Name: " + roomname + "</div>");

    // Database connection details
    String jdbcUrl = "jdbc:mysql://localhost:3306/moneydata";
    String username_1 = "root";
    String password_1 = "root";

    try {
        Class.forName("com.mysql.jdbc.Driver");

        Connection connection = DriverManager.getConnection(jdbcUrl, username_1, password_1);

        String selectQuery = "SELECT * FROM " + roomname;
        PreparedStatement selectStatement = connection.prepareStatement(selectQuery);
        ResultSet resultSet = selectStatement.executeQuery();

        out.println("<table class=\"data-table\">");
        out.println("<tr><th>Username</th><th>Spent</th><th>Debt</th></tr>");

        int usernameCount = 0; 

        while (resultSet.next()) {
            String usernameDB = resultSet.getString("username");
            double spent = resultSet.getDouble("spent");
            double debt = resultSet.getDouble("givetake");

            out.println("<tr>");
            out.println("<td>" + usernameDB + "</td>");
            out.println("<td>" + spent + "</td>");
            
            if (debt >= 0) {
                out.println("<td class=\"positive\">" + debt + "</td>");
              } else {
                out.println("<td class=\"negative\">" + debt + "</td>");
              }
            
            out.println("</tr>");

            usernameCount++;
        }

        out.println("</table>");

        out.println("<div class=\"total-usernames\">Total usernames: " + usernameCount + "</div>");

        out.println("<form class=\"expense-form\" method='post' action='expence1.jsp'>");
        out.println("<input type='hidden' name='roomname' value='" + roomname + "'>");
        out.println("<input type='hidden' name='username' value='" + username + "'>");
        out.println("<input type='hidden' name='usernameCount' value='"+ usernameCount +"'>");
        out.println("<label>Enter spent value:</label> <input type='number' name='spent'>");
        out.println("<input type='submit' value='Submit'>");
        out.println("</form>");
        
        out.println("<form class=\"expense-form32\" method='post' action='index.html'>");
        out.println("<input type='submit' value=Logout>");
        out.println("</form>");

        resultSet.close();
        selectStatement.close();
        connection.close();
    } catch (ClassNotFoundException e) {
        e.printStackTrace();
    } catch (SQLException e) {
        e.printStackTrace();
    }
%>
 <h3>Pay Through PAYTM</h3>
 <button class="paytm-button" onclick="window.location.href='https://paytm.com/login'">Paytm Login</button>
</body>
</html>

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Insert title here</title>
    <link rel="stylesheet" type="text/css" href="get6.css">
</head>
<body>
    <div class="container">
        <div class="box">
            <h1>Register Name</h1>
            <form action="registernameprocess.jsp" method="post">
                <label for="username">Username:</label>
                <input type="text" id="username" name="username" required><br><br>
                <label for="roomname">Room Name:</label>
                <input type="text" id="roomname" name="roomname" required><br><br>
                <label for="password">Password:</label>
                <input type="password" id="password" name="password" required><br><br>
                <input type="submit" value="Submit">
            </form>
        </div>
    </div>
</body>
</html>
    
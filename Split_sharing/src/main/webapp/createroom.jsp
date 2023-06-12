<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Form Data Retrieval</title>
    <link rel="stylesheet" type="text/css" href="get4.css">
</head>
<body>
    <h1>CREATE ROOM</h1>
    
    <form class="form" action="create.jsp" method="post">
         <label for="username" style="color: black;">UserName</label>
        <input type="text" id="username" name="username" required><br><br>   
    
        <label for="roomname" style="color: black;">Room Name:</label>
        <input type="text" id="roomname" name="roomname" required><br><br>
        
        <label for="password" style="color: black;">Password:</label>
        <input type="password" id="password" name="password" required><br><br>
        
        <label for="confirmpassword" style="color: black;">Confirm Password:</label>
        <input type="password" id="confirmpassword" name="confirmpassword" required><br><br>
        
        <input type="submit" value="Submit" class="submit-btn">
    </form>
</body>
</html>

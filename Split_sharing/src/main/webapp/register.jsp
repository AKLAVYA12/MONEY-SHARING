<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
  <title>Registration</title>
  <link rel="stylesheet" type="text/css" href="get2.css">
</head>
<body>
  <div class="container">
    <div class="card">
      <h1>Registration</h1>
        <p class="error-message">${errorMessage}</p>
      <form action="registerProcess.jsp" method="POST">
        <div class="form-group">
          <label for="username">username</label>
          <input type="text" id="username" name="username" placeholder="Enter your desired username">
        </div>
        <div class="form-group">
          <label for="password">password</label>
          <input type="password" id="password" name="password" placeholder="Enter your desired password">
        </div>
        <div class="form-group">
          <label for="confirm-password">confirm-password</label>
          <input type="password" id="confirm-password" name="confirm-password" placeholder="Confirm your password">
        </div>
        <button type="submit">Register</button>
      </form>
      <div class="links">
        <a href="index.html">Back to Login</a>
      </div>
    </div>
  </div>
</body>
</html>

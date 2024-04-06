<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login to TakeTest</title>
    <link rel="stylesheet" href="AdminResources/fonts/icomoon/style.css">
    <link rel="stylesheet" href="AdminResources/css/owl.carousel.min.css">
    <link rel="stylesheet" href="AdminResources/css/bootstrap.min.css">
    <link rel="stylesheet" href="AdminResources/css/newStyle.css">
</head>
<body>

<div class="d-lg-flex half">
    <div class="bg order-1 order-md-2" style="background-image: url('../logo-white.png');"></div>
    <div class="contents order-2 order-md-1">
        <div class="container">
            <div class="row align-items-center justify-content-center">
                <div class="col-md-7">
                    <h1>Login as <br><strong><span style="color: #F5B700; font-size: 4rem;">Admin</span></strong></h1>
                    <form action="/TakeTest/AdminLogin" method="post">
                        <div class="form-group first" style="border: 2px solid #ccc; border-radius: 10px; padding: 10px; margin-bottom: 20px;">
                            <label for="username"><b>Enter your username</b></label>
                            <input type="text" class="form-control" placeholder="Username" id="username" name="username" required style="border-radius: 5px;">
                        </div>
                        <div class="form-group last mb-3" style="border: 2px solid #ccc; border-radius: 10px; padding: 10px; margin-bottom: 20px;">
                            <label for="password"><b>Enter your password</b></label>
                            <input type="password" class="form-control" placeholder="Password" id="password" name="password" required style="border-radius: 5px;">
                        </div>
                        
                        <input type="submit" value="Log In" class="btn btn-block btn-warning">
                    </form>
                    <% 
                        String error = request.getParameter("error");
                        if(error != null && error.equals("1")){
                    %>
                    <p>Invalid username or password. Try again</p>
                    <%
                        }
                    %>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="AdminResources/js/jquery-3.3.1.min.js"></script>
<script src="AdminResources/js/popper.min.js"></script>
<script src="AdminResources/js/bootstrap.min.js"></script>
<script src="AdminResources/js/main.js"></script>
</body>
</html>

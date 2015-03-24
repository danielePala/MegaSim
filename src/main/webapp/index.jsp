<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>MegaSim</title>

    <!-- Bootstrap core CSS -->
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/css/bootstrap.min.css" rel="stylesheet">
    <!-- Custom styles for this site -->
    <link href="style/cover.css" rel="stylesheet">
  </head>

  <body>

    <div class="site-wrapper">
      <div class="masthead">
        <div class="inner">
          <h3 class="masthead-brand">MegaSim</h3>
        </div>
        <nav class="inner">
          <ul class="nav masthead-nav">
	    <%
             String s = null;
             if (request.getSession().getAttribute("Username") != null) {
                 s = request.getSession().getAttribute("Username").toString();
             }

             UserService userService = UserServiceFactory.getUserService();
             User user = userService.getCurrentUser();
             if (user != null) {
	         request.getSession().removeAttribute("WrongLogin");
                 pageContext.setAttribute("user", user);
          %>

          <li>
	    <p>${fn:escapeXml(user.nickname)}</p>
	  </li> 
          <li>
	    <a href="<%= userService.createLogoutURL(request.getRequestURI()) %>"> logout </a>
	  </li>

          <%
             } else if (s != null) {
          %>

          <li>
	    <p><%= s %></p>
	  </li> 
          <li>
	    <a href="logout"> logout </a>
	  </li>

	  <%
             } 
          %>

          </ul>
        </nav>
      </div>

      <div class="cover-container">
        <div class="cover">
          <h1 class="cover-heading">Simula numeri a caso.</h1>
          <p class="lead">MegaSim ti permette di lanciare simulazioni a caso.</p>
	  <%
	     if (user != null || s != null) {
	  %>

	  <form action="simulate" method="POST">
	    <button type="submit" class="btn btn-default">Lancia una simulazione!</button>
	  </form>

	  <%
	     } else {
	  %>

	  <p>
	    <a href="<%= userService.createLoginURL(request.getRequestURI()) %>">login con Google+</a>
	  </p>

	  <%
             if (request.getSession().getAttribute("WrongLogin") != null) {
          %>

	   <p>Username o password errati.</p>
	   
	  <%
             } 
          %>


	  <form action="login" method="POST">
	    <div class="form-group">
	      <label for="inputUsername1">Username</label>
	      <input type="text" class="form-control" name="inputUsername1" id="inputUsername1" placeholder="Inserisci username">
	    </div>
	    <div class="form-group">
	      <label for="inputPassword1">Password</label>
	      <input type="password" class="form-control" name="inputPassword1" id="inputPassword1" placeholder="Password">
	    </div>
	    <button type="submit" class="btn btn-default">Login</button>
	  </form>

	  <%
	     }
	  %>

        </div>
      </div>
      
      <div class="mastfoot">
        <div class="inner">
          <p>Sito realizzato da Daniele Pala.</p>
        </div>
      </div>
      
    </div>

    <script src="https://code.jquery.com/jquery-1.11.2.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/js/bootstrap.min.js"></script>
  </body>
</html>

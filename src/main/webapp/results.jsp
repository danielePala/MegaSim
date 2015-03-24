<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="com.google.appengine.api.taskqueue.QueueFactory" %>
<%@ page import="com.google.appengine.api.taskqueue.Queue" %>
<%@ page import="com.google.appengine.api.datastore.Query" %>
<%@ page import="com.google.appengine.api.datastore.Entity" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreService" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
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
              String username = null;
              if (request.getSession().getAttribute("Username") != null) {
                username = request.getSession().getAttribute("Username").toString();
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
              } else if (username != null) {
            %>

                <li>
		  <p><%= username %></p>
		</li> 
                <li>
	          <a href="logout"> logout </a>
	        </li>

	    <%
              } else {
	        response.sendRedirect("index.jsp");
              }
            %>

          </ul>
        </nav>
      </div>

      <div class="cover-container">
        <div class="cover" id="cover">
         
	  <%  
	    if (user != null || username != null) {
	  %>

	      <div id="show-progress">
		<p class="lead">Simulazione in corso...</p>
		<div class="progress" id="progress">
                  <div class="progress-bar progress-bar-success progress-bar-striped active" role="progressbar" aria-valuenow="100" aria-valuemin="0" aria-valuemax="100" style="width: 100%">
                    <span class="sr-only">Simulazione in corso...</span>
                  </div>
		</div>
	      </div>
	      

	  <%
            }
          %>

        </div>
	<div class="statistics-container" id="statistics-container">
	  <div class="statistics-summary" id="statistics-summary" >
	  </div>
	  <div id="statistics" class="statistics">
          </div>
	  <div class="statistics-btn">
            <a class="btn btn-default" href="/index.jsp" role="button">Fai una nuova simulazione</a>
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
<script type="text/javascript" src="https://www.google.com/jsapi?autoload={'modules':[{'name':'visualization','version':'1','packages':['corechart']}]}"></script>
    <script>
      $(document).ready(function() {
          function googleLoaded() {
              $.get('statistics', function(responseText) {
                  obj = JSON.parse(responseText);
                  obj.perc.splice(0, 0, ["numero", "percentuale"]); 
  
                  var data = google.visualization.arrayToDataTable(obj.perc);

                  var options = {
                      title: '% di apparizione dei numeri da 0 a 50',
                      hAxis: {
                          title: '% di apparizione',
                          minValue: 0,
                          titleTextStyle: {color: '#FFFFFF'},
                          textStyle: {color: '#FFFFFF'}
                      },
                      vAxis: {
                          title: 'Numero',
                          titleTextStyle: {color: '#FFFFFF'},
                          textStyle: {color: '#FFFFFF'}
                      },
                      legend: {
                          textStyle: {color: '#FFFFFF'}
                      },
                      titleTextStyle: {color: '#FFFFFF'},
                      backgroundColor: {
                          stroke: '#666',
                          strokeWidth: 10,
                          fill: '#4B8F30'
                      },
                      colors:['orange'],
                      titlePosition: 'in',
                      chartArea: {left:20,top:100,width:'50%',height:'75%'},
                      bars: 'horizontal' 
                  }
                  var chart = new google.charts.Bar(document.getElementById('statistics'));
                  var summary = '<p class="lead">Simulazione completata (' + obj.simTime + ' secondi - ' + obj.totalNumbers + ' numeri differenti)</p>';
                  var maxKey = '<p>Numero maggiormente estratto: ' + obj.maxKey + '</p>';
                  $('#cover').hide();
                  $('#statistics-container').show();
                  $('#statistics-summary').append(summary).append(maxKey);
                  chart.draw(data, google.charts.Bar.convertOptions(options));
              }); 
          }
          $('#statistics-container').hide();
          $('#show-progress').show();
          google.load("visualization", "1.1", {packages:["bar"], callback: googleLoaded});
      });

    </script>
  </body>
</html>

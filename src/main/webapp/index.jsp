<%@ page import="ecs189.querying.github.GithubQuerier" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <title>Github Stalker 2.0</title>

    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.2/css/bootstrap.min.css" integrity="sha384-PsH8R72JQ3SOdhVi3uxftmaW6Vc51MKb0q5P2rRUpPvrszuE4W1povHYgTpBfshb" crossorigin="anonymous">
    <link href="https://fonts.googleapis.com/css?family=Quicksand" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/octicons/4.4.0/font/octicons.min.css" rel="stylesheet">
    <link href="style.css" rel="stylesheet">

    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
</head>
<body>
<div class="main">
    <h1>Github Stalker 2.0</h1>
    <h4>What have I been up to?</h4>
    <p>Tell me who you are, and I will tell you your latest 10 push requests!</p>
    <form action="index.jsp" method="GET">
        <div class="form-group">
            <input type="text" class="form-control" id="username" placeholder="Github Username" name="user_name" value="<%= request.getParameter("user_name") == null ? "" : request.getParameter("user_name")%>">
        </div>
        <div class="form-group">
            <%String user=request.getParameter("user_name"); %>
            <button type="submit" class="btn btn-default">
                <c:choose>
                    <c:when test="${empty user}">
                        Submit
                    </c:when>
                    <c:otherwise>
                        Refresh
                    </c:otherwise>
                </c:choose>
            </button>
        </div>
    </form>
    <%if (user != null && !user.isEmpty()){%>
        <hr>
        <div class="results">
            <%=GithubQuerier.eventsAsHTML(user)%>
        </div>
    <% }%>
</div>
<script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.3/umd/popper.min.js" integrity="sha384-vFJXuSJphROIrBnz7yo7oB41mKfc8JzQZiCq4NCceLEaO4IHwicKwpJf9c9IpFgh" crossorigin="anonymous"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.2/js/bootstrap.min.js" integrity="sha384-alpBpkh1PFOepccYVYDB4do5UnbKysX5WZXm3XxPqe5iKTfUKjNkCk9SaVuEZflJ" crossorigin="anonymous"></script>
</body>
</html>
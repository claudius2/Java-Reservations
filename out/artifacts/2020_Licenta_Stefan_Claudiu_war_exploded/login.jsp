<%--
  Created by IntelliJ IDEA.
  User: DeLL
  Date: 4/2/2020
  Time: 1:01 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Login</title>
    <style>
        <%@include file="/css/style.css" %>
    </style>
</head>
<body>

<div class="container">
    <div class="header">
        <div class="logo">

        </div>
        <div class="menu">
            <ul class="menu">
                <%
                    boolean logat = false;
                    if (session.getAttribute("logat") != null && session.getAttribute("logat") == "true")
                        logat = true;

                    if (logat) {
                %>
                <li><a href="CheckLogin">Log Out </a></li>
                <%

                } else {%>
                <li><a href="login.jsp">Contul meu </a></li>
                <% }%>
                <li><a href="GetPitches">Terenuri</a></li>
                <li><a href="index.jsp">Acasa</a></li>
                <%
                    String userType = "v";
                    if (session.getAttribute("typeUser") != null)
                        userType = (String) session.getAttribute("typeUser");
                    if (userType.equals("g")) {
                %>
                <li><a href="EditPitches">Editeaza terenurile </a></li>
                <%
                } else if (userType.equals("a")) {%>
                <li><a href="AdminPitches">Administeaza terenurile </a></li>
                <% }%>
            </ul>
        </div>

    </div>
    <div class="content">

        <%
            if (request.getAttribute("test") == "wrong") {
        %>
        <div class="showmessage">
            Ai introdus email sau parola gresita!
        </div>
        <%
            }
        %>
        <div class="loginform">
            <form action="CheckLogin" method="post">
                <input type="text" placeholder="Email" name="email" required>
                <input type="password" placeholder="Parola" name="password" required>
                <button type="submit">Log In</button>
                <div>
                    Nu ai un cont? <a href="register.jsp">Inregistreaza-te aici</a>
                </div>
            </form>

        </div>

    </div>
    <div class="footer">
        @Licenta Rezervari Terenuri @Claudiu Stefan

    </div>

</div>
</body>
</html>

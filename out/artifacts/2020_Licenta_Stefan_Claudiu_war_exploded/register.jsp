<%--
  Created by IntelliJ IDEA.
  User: DeLL
  Date: 4/2/2020
  Time: 3:31 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Inregistrare</title>
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
                <li><a href="index.jsp">Terenuri</a></li>
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
            if (request.getAttribute("test") == "already exist") {
        %>
        <div class="showmessage">
            Acest email este asociat unui alt cont!
        </div>
        <%
            }
        %>
        <%
            if (request.getAttribute("test") == "invalid email") {
        %>
        <div class="showmessage">
            Acest email este incorect!
        </div>
        <%
            }
        %>
        <div class="registerform">
            <form action="Register" method="post">
                <input type="text" placeholder="Nume" name="fname" required>
                <input type="text" placeholder="Prenume" name="lname" required>
                <input type="email" placeholder="Email" name="email" required>
                <input type="password" placeholder="Parola" name="psw" required>
                <input type="tel" id="phone" placeholder="Numarul de telefon" name="phone" pattern="[0-9]{10}" required>
                <button type="submit">Inregistrare</button>
            </form>
        </div>

    </div>
    <div class="footer">
        @Licenta Rezervari Terenuri @Claudiu Stefan

    </div>

</div>
</body>
</html>

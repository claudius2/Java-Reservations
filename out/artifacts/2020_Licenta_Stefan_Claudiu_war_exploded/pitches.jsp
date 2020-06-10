<%@ page import="Entities.PitchesEntity" %>
<%@ page import="javax.xml.crypto.Data" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="java.util.*" %><%--
  Created by IntelliJ IDEA.
  User: DeLL
  Date: 5/19/2020
  Time: 11:28 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Terenuri</title>
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
        <div class="searchPitch">
            Cauta dupa data si ora dorita:
            <form action="GetPitches" method="post">
                <%String data = "azi";%>
                Data:
                <select id="data" name="data">

                    <%


                        Calendar calendar = Calendar.getInstance();
                        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
                        if (calendar.get(Calendar.HOUR_OF_DAY) == 23)
                            calendar.add(Calendar.HOUR_OF_DAY, 1);

                        for (int i = 0; i < 7; i++) {
                            String valnow = dateFormat.format(calendar.getTime());
                    %>

                    <option value="<%=valnow%>">
                        <%=valnow%>
                    </option>
                    <%
                            calendar.add(Calendar.DAY_OF_YEAR, 1);
                        }
                    %>

                </select>
                Ora:

                <select id="ora" name="ora">
                    <%

                        if (Calendar.getInstance().get(Calendar.HOUR_OF_DAY) + 1 >= 10 && Calendar.getInstance().get(Calendar.HOUR_OF_DAY) + 1 < 23) {
                            for (int i = Calendar.getInstance().get(Calendar.HOUR_OF_DAY) + 1; i < 24; i++) {

                    %>
                    <option value="<%=i%>">
                        <%=i%>
                    </option>
                    <% }
                    } else {
                        for (int i = 10; i < 24; i++) {

                    %>
                    <option value="<%=i%>">
                        <%=i%>
                    </option>
                    <%

                            }
                        }
                    %>

                    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
                    <script>$(document).ready(function () {
                        $("#data").change(function () {
                            var val = $(this).val();
                            var oraCurenta =<%=Calendar.getInstance().get(Calendar.HOUR_OF_DAY)+1%>;
                            <%Calendar calendar1=Calendar.getInstance();%>
                            if (val == "<%=(new SimpleDateFormat("yyyy-MM-dd")).format(calendar1.getTime())%>" && oraCurenta + 1 > 10) {
                                var i = 10;
                                let opt = new String();
                                for (i = oraCurenta; i < 24; i++) {
                                    opt += "<option value='" + i + "'>" + i + "</option>";
                                }
                                $("#ora").html(opt);
                            } else {

                                let opt = new String();
                                for (i = 10; i < 24; i++) {
                                    opt += "<option value='" + i + "'>" + i + "</option>";
                                }
                                $("#ora").html(opt);
                            }

                        });

                    })
                    </script>

                </select>
                Sportul:
                <select name="sport">
                    <option value="f">Footbal</option>
                    <option value="t">Tenis</option>
                </select>
                <br><br>
                <input type="hidden" name="action" value="dupaData">
                <button type="submit">Afiseaza</button>
            </form>

        </div>

        <div class="searchPitch">
            Vezi orele disponibile terenului dorit:
            <form action="GetPitches" method="post">

                Terenul:
                <select name="idPitch">

                    <%
                        // PitchesEntity myList=(PitchesEntity)request.getAttribute("pitchList");
                        ArrayList<PitchesEntity> myList = (ArrayList<PitchesEntity>) request.getAttribute("pitchList");

                        for (PitchesEntity p : myList) {
                    %>

                    <option value="<%=p.getId()%>"><%=p.getName()%>
                    </option>
                    <%
                        }
                    %>
                </select>
                Data:
                <select id="dataT" name="data">

                    <%
                        calendar = Calendar.getInstance();
                        for (int i = 0; i < 7; i++) {
                            String valnow = dateFormat.format(calendar.getTime());
                    %>

                    <option>
                        <%=valnow%>
                    </option>
                    <%
                            calendar.add(Calendar.DAY_OF_YEAR, 1);
                        }
                    %>

                </select>
                <br><br>

                <input type="hidden" name="action" value="dupaTeren">
                <button type="submit">Afiseaza</button>
            </form>

        </div>

        <div class="searchPitch">
            Vezi toate terenurile:
            <form action="GetPitches" method="post">

                <br><br>
                <input type="hidden" name="action" value="toateTerenurile">
                <button type="submit">Afiseaza</button>
            </form>

        </div>


    </div>
    <div class="footer">
        @Licenta Rezervari Terenuri @Claudiu Stefan

    </div>

</div>
</body>
</html>

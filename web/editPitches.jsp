<%@ page import="java.util.ArrayList" %>
<%@ page import="Entities.PitchesEntity" %>
<%@ page import="Entities.UserEntity" %><%--
  Created by IntelliJ IDEA.
  User: DeLL
  Date: 6/2/2020
  Time: 11:09 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Editare</title>
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
            ArrayList<PitchesEntity> arrayList=(ArrayList<PitchesEntity>) request.getAttribute("pitchList");
            ArrayList<UserEntity> usersList=(ArrayList<UserEntity>) request.getAttribute("usersList");
            ArrayList<String> adminsList=(ArrayList<String>) request.getAttribute("adminsList");

        %>
        <div class="infoMessage">
            Sterge unul din terenurile inregistrate:<br>
            <div>
                <table class="showTable">
                    <tr class="mainTable">
                        <td>Denumire</td>
                        <td>Descriere</td>
                        <td>Adresa</td>
                        <td>Pret pe ora</td>
                        <td>Administrator</td>
                        <td></td>
                    </tr>
                    <%
                        for (PitchesEntity p : arrayList) {
                            StringBuffer description = new StringBuffer(p.getDescription());
                            int count = description.length() / 70;
                            for (int i = 0; i < count; i++) {
                                description.insert(70 * (i + 1), "<br>");
                            }


                    %>
                    <tr>
                        <td><%=p.getName()%>
                        </td>
                        <td><%=description.toString()%>
                        </td>
                        <td><%=p.getAdress()%>
                        </td>
                        <td><%=p.getPrice()%>
                        </td>
                        <td><%=adminsList.get(arrayList.indexOf(p))%>
                        </td>
                        <td>
                            <form action="EditPitches" method="post">
                                <input type="hidden" name="idPitch" value="<%=p.getId()%>"/>
                                <input type="hidden" name="action" value="delete"/>
                                <button type="submit">Sterge terenul</button>
                            </form>
                        </td>
                    </tr>

                    <%
                        }
                    %>
                </table>
                <div class="infoMessage">
                    Adauga un nou teren:<br>
                </div>
                <div class="registerform">
                    <form action="EditPitches" method="post">
                        <input type="text" placeholder="Denumire" name="name" required>
                        <input type="text" placeholder="Descriere" name="description" required>
                        <input type="text" placeholder="Adresa" name="adress" required>
                        <input type="number" placeholder="Pret pe ora" name="price" min="0" max="10000000" required>
                        Sportul:
                        <select id="type" name="type">
                            <option value="f">Fotbal</option>
                            <option value="t">Tenis</option>
                        </select><br>
                        Administrator:
                        <select id="idAdmin" name="idAdmin">
                            <%
                                for (UserEntity u : usersList) {
                                    int id = u.getId();
                                    if (id != 1) {
                            %>
                            <option value="<%=u.getId()%>"><%=u.getFirstName() + " " + u.getLastName()%>
                            </option>
                            <%
                                    }
                                }
                            %>
                        </select>
                        <input type="hidden" name="action" value="add">
                        <button type="submit">Adauga</button>
                    </form>
                </div>


            </div>
            <div class="footer">
                @Licenta Rezervari Terenuri @Claudiu Stefan

            </div>

        </div>
</body>
</html>

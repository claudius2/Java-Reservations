<%@ page import="java.util.ArrayList" %>
<%@ page import="Entities.PitchesEntity" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.text.DateFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="Model.PitchDB" %>
<%@ page import="Entities.ReservationEntity" %><%--
  Created by IntelliJ IDEA.
  User: DeLL
  Date: 6/2/2020
  Time: 11:09 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Administrare </title>
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
            String action = (String) request.getAttribute("action");
            switch (action) {
                case "showPitches":
                    ArrayList<PitchesEntity> pitchList = (ArrayList<PitchesEntity>) request.getAttribute("pitchList");
        %>
        <table class="showTable">
            <tr class="mainTable">
                <td>Denumire</td>
                <td>Descriere</td>
                <td>Adresa</td>
                <td>Pret pe ora</td>
                <td>Editeaza</td>
                <td>Data</td>
                <td>Vezi Rezervarile</td>
            </tr>
            <%
                for (PitchesEntity p : pitchList) {
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
                <td>
                    <form action="AdminPitches" method="post">
                        <input type="hidden" name="idPitch" value="<%=p.getId()%>"/>
                        <input type="hidden" name="action" value="edit"/>
                        <button type="submit">Editeaza datele</button>
                    </form>

                </td>

                <form action="AdminPitches" method="post">
                    <td>
                        <select name="data">

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
                    </td>
                    <td>
                        <input type="hidden" name="idPitch" value="<%=p.getId()%>"/>
                        <input type="hidden" name="action" value="showReservations"/>
                        <button type="submit">Vezi rezervarile</button>
                    </td>
                </form>
            </tr>

            <%
                }
            %>
        </table>
        <%
                break;
            case "edit": {
                PitchesEntity pitchesEntity = (PitchesEntity) request.getAttribute("pitch");
        %>
        <div class="registerform">
            <form action="AdminPitches" method="post">
                <input type="text" placeholder="Denumire" value="<%=pitchesEntity.getName()%>" name="name" required>
                <input type="text" placeholder="Descriere" value="<%=pitchesEntity.getDescription()%>"
                       name="description" required>
                <input type="text" placeholder="Adresa" value="<%=pitchesEntity.getAdress()%>" name="adress" required>
                <input type="number" value="<%=pitchesEntity.getPrice()%>" name="price" required>
                <input type="hidden" name="idPitch" value="<%=pitchesEntity.getId()%>"/>
                <input type="hidden" name="action" value="update"/>
                <button type="submit">Update</button>
            </form>
        </div>
        <%
            }

            break;
            case "showReservations":
                String empty = (String) request.getAttribute("empty");
                String data = (String) request.getAttribute("data");
                String pitchName = (String) request.getAttribute("pitchName");
                String idPitch = (String) request.getAttribute("idPitch");
                if (empty.equals("yes")) {
        %>
        <div class="showmessage">
            Nu exista nici o rezervare in data <%=data%> pe terenul <%=pitchName%>!
        </div>


        <%
        } else {
            ArrayList<ReservationEntity> listOfReservations = (ArrayList<ReservationEntity>) request.getAttribute("reservationsList");
            ArrayList<String> listOfUsers = (ArrayList<String>) request.getAttribute("usersList");
        %>
        <div class="showmessage">
            Rezervarile din data <%=data%> pe terenul <%=pitchName%>!
            <table class="showTable">
                <tr class="mainTable">
                    <td>Userul care a rezervat</td>
                    <td>Ora rezervarii</td>
                    <td>Sterge rezervarea</td>
                </tr>
                <%
                    for (ReservationEntity r : listOfReservations) {

                %>
                <tr>
                    <td><%=listOfUsers.get(listOfReservations.indexOf(r))%>
                    </td>
                    <td><%=r.getHour()%>
                    </td>
                    <td>
                        <form action="AdminPitches" method="post">
                            <input type="hidden" name="data" value="<%=data%>">
                            <input type="hidden" name="idPitch" value="<%=idPitch%>">
                            <input type="hidden" name="idreservation" value="<%=r.getId()%>">
                            <input type="hidden" name="action" value="delete">
                            <button type="submit">Sterge rezervarea</button>
                        </form>
                    </td>
                </tr>
                <%
                    }
                %>
            </table>

        </div>


        <%
                    }

                    break;
            }
        %>


    </div>
    <div class="footer">
        @Licenta Rezervari Terenuri @Claudiu Stefan

    </div>

</div>
</body>
</html>

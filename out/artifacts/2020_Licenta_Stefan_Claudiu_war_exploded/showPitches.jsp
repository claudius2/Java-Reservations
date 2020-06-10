<%@ page import="Entities.PitchesEntity" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="Entities.UserEntity" %>
<%--
  Created by IntelliJ IDEA.
  User: DeLL
  Date: 5/21/2020
  Time: 12:33 PM
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
            <%
           String action=(String) request.getAttribute("action");
           String data=(String) request.getAttribute("data");
           String ora=(String) request.getAttribute("ora");


        switch (action)
        {
            case "dupaData":
                %>
        <div class="infoMessage"> <% if(logat==false){%>
            Pentru a face o rezervare trebuie sa fii logat!!<br><%}%>
            Terenurile disponibile in data <%=data %> la ora <%=ora%>:
            <div>

                    <%
                ArrayList<PitchesEntity> myList = (ArrayList<PitchesEntity>) request.getAttribute("pitchList");
                ArrayList<String> adminsList=(ArrayList<String>) request.getAttribute("adminsList");

                %>

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
                        for (PitchesEntity p : myList) {
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
                        <td><%=adminsList.get(myList.indexOf(p))%>
                        </td>
                        <td>
                            <form action="<%if(logat){%>AddReservation<%}else{%>login.jsp<%}%>" method="post">
                                <input type="hidden" name="idPitch" value="<%=p.getId()%>"/>
                                <input type="hidden" name="idUser" value="<%=session.getAttribute("idUser")%>"/>
                                <input type="hidden" name="data" value="<%=data%>"/>
                                <input type="hidden" name="ora" value="<%=ora%>"/>
                                <button type="submit">Rezerva</button>
                            </form>
                        </td>
                    </tr>

                    <%
                        }
                    %>
                </table>

                <div class="searchPitch">
                    <br><br>Cauta dupa alta data:
                    <form action="GetPitches" method="post">
                        <%String data1 = "azi";%>
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
                                    <%Calendar calendar1=Calendar.getInstance();%>
                                    if (val == "<%=(new SimpleDateFormat("yyyy-MM-dd")).format(calendar1.getTime())%>") {
                                        var i = 10;
                                        let opt = new String();
                                        for (i =<%=Calendar.getInstance().get(Calendar.HOUR_OF_DAY)+1%>; i < 24; i++) {
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
                        <input type="hidden" name="action" value="dupaData">
                        <button type="submit">Afiseaza</button>
                    </form>

                </div>
                    <%


                    break;
//----------------------------------------------------------------------------------------------------------------------------------
                case "dupaTeren":
                    String nameOfPitch=(String)request.getAttribute("pitchName");
                    String idPitch=(String)request.getAttribute("idPitch");
                                 ArrayList<String> freeHours = (ArrayList<String>) request.getAttribute("freeHours");
                                 String dataT=(String)request.getAttribute("data");
 %>
                <div class="infoMessage"><% if (logat == false) {
                %>Pentru a face o rezervare trebuie sa fii logat!!<br><%}%>
                    Orele disponibile in data <%=dataT %> pentru terenul <%=nameOfPitch%>:
                    <div>

                        <%


                        %>
                        <table class="showTable">
                            <tr class="mainTable">
                                <td>Nume Teren</td>
                                <td>Ora libera</td>
                                <td></td>
                            </tr>
                            <tr>
                                <td rowspan="<%=freeHours.size()%>"><%=nameOfPitch%>
                                </td>
                                <% for (String s : freeHours) {
                                %>
                                <td>
                                    <%=s%>
                                </td>
                                <td>
                                    <form action="<%if(logat){%>AddReservation<%}else{%>login.jsp<%}%>" method="post">
                                        <input type="hidden" name="idPitch" value="<%=idPitch%>"/>
                                        <input type="hidden" name="idUser" value="<%=session.getAttribute("idUser")%>"/>
                                        <input type="hidden" name="data" value="<%=dataT%>"/>
                                        <input type="hidden" name="ora" value="<%=s%>"/>
                                        <button type="submit">Rezerva</button>
                                    </form>
                                </td>
                            </tr>
                            <%
                                }%>
                        </table>
                        <%

                                break;

                            //==============================================================================================================================
                            case "toateTerenurile":
                                ArrayList<PitchesEntity> footballPitchList = (ArrayList<PitchesEntity>) request.getAttribute("footballPitchList");
                                ArrayList<PitchesEntity> tennisPitchList = (ArrayList<PitchesEntity>) request.getAttribute("tennisPitchList");
                                ArrayList<UserEntity> footballAdmins = (ArrayList<UserEntity>) request.getAttribute("footballPitchAdmins");
                                ArrayList<UserEntity> tennisAdmins = (ArrayList<UserEntity>) request.getAttribute("tennisPitchAdmins");
                        %>
                        <table class="showTable">
                            <tr class="mainTable">
                                <td>Denumire</td>
                                <td>Descriere</td>
                                <td>Adresa</td>
                                <td>Pret pe ora</td>
                                <td>Administrator</td>
                                <td>Data</td>
                                <td></td>
                            </tr>
                            <tr class="mainTable">
                                <td colspan="7">Fotbal</td>
                            </tr>
                            <%
                                for (PitchesEntity p : footballPitchList) {
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
                                <td><%=footballAdmins.get(footballPitchList.indexOf(p))%>
                                </td>
                                <form action="GetPitches" method="post">
                                    <td>
                                        <select name="data">

                                            <%


                                                calendar = Calendar.getInstance();
                                                dateFormat = new SimpleDateFormat("yyyy-MM-dd");
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
                                        <input type="hidden" name="action" value="dupaTeren"/>
                                        <button type="submit">Vezi detalii</button>
                                    </td>
                                </form>
                            </tr>

                            <%
                                }
                            %>

                            <tr class="mainTable">
                                <td colspan="7">Tenis</td>
                            </tr>
                            <%
                                for (PitchesEntity p : tennisPitchList) {
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
                                <td><%=tennisAdmins.get(tennisPitchList.indexOf(p))%>
                                </td>
                                <form action="GetPitches" method="post">
                                    <td>
                                        <select name="data">

                                            <%


                                                calendar = Calendar.getInstance();
                                                dateFormat = new SimpleDateFormat("yyyy-MM-dd");
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
                                        <input type="hidden" name="action" value="dupaTeren"/>
                                        <button type="submit">Vezi detalii</button>
                                    </td>
                                </form>
                            </tr>

                            <%
                                }
                            %>

                        </table>
                        <%

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

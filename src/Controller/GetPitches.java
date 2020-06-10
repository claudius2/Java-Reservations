package Controller;

import Entities.PitchesEntity;
import Model.PitchDB;
import Model.ReservationDB;
import Model.UserDB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

import java.text.ParseException;
import java.util.ArrayList;

@WebServlet(name = "GetPitches")
public class GetPitches extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String action = request.getParameter("action");
        request.setAttribute("action", action);

        switch (action) {
            case "dupaData" -> {

                String data = request.getParameter("data");
                String ora = request.getParameter("ora");
                String sport = request.getParameter("sport");
                //   int ora=Integer.parseInt(oraString);
                request.setAttribute("ora", ora);
                request.setAttribute("data", data);

                PitchDB pitchDB = new PitchDB();
                ArrayList<PitchesEntity> emptyPitches = pitchDB.getEmptyPitches(data, ora, sport);


                request.setAttribute("pitchList", emptyPitches);
                request.setAttribute("adminsList", pitchDB.getListOfAdmins(emptyPitches));
                request.getRequestDispatcher("showPitches.jsp").forward(request, response);

            }
            case "dupaTeren" -> {
                int idPitch = Integer.parseInt(request.getParameter("idPitch"));
                String data = request.getParameter("data");
                request.setAttribute("data", data);
                PitchDB pitchDB = new PitchDB();
                PitchesEntity pitchesEntity = pitchDB.getPitchById(idPitch);
                ReservationDB reservationDB = new ReservationDB();
                try {
                    ArrayList<String> freeHours = reservationDB.getFreeHours(idPitch, data);
                    request.setAttribute("freeHours", freeHours);
                } catch (ParseException e) {
                    e.printStackTrace();
                    request.getRequestDispatcher("index").forward(request, response);
                }


                request.setAttribute("pitchName", pitchesEntity.getName());
                request.setAttribute("idPitch", String.valueOf(pitchesEntity.getId()));
                request.getRequestDispatcher("showPitches.jsp").forward(request, response);

            }
            case "toateTerenurile" -> {
                PitchDB pitchDB = new PitchDB();
                request.setAttribute("footballPitchList", pitchDB.getListOfPitchesBySport("f"));
                request.setAttribute("footballPitchAdmins", pitchDB.getListOfAdmins(pitchDB.getListOfPitchesBySport("f")));
                request.setAttribute("tennisPitchList", pitchDB.getListOfPitchesBySport("t"));
                request.setAttribute("tennisPitchAdmins", pitchDB.getListOfAdmins(pitchDB.getListOfPitchesBySport("t")));
                request.getRequestDispatcher("showPitches.jsp").forward(request, response);
            }
        }
        //  response.sendRedirect("index.jsp");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == "showOptions") {
            response.sendRedirect("index.jsp");
        } else {
            PitchDB pitchDB = new PitchDB();
            request.setAttribute("pitchList", pitchDB.getListOfPitches());
            request.getRequestDispatcher("pitches.jsp").forward(request, response);
        }

    }
}

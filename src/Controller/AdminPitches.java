package Controller;

import Entities.ReservationEntity;
import Model.PitchDB;
import Model.ReservationDB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import javax.persistence.criteria.CriteriaBuilder;
import java.io.IOException;
import java.text.ParseException;
import java.util.ArrayList;

@WebServlet(name = "AdminPitches")
public class AdminPitches extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String action = request.getParameter("action");
        request.setAttribute("action", action);
        PitchDB pitchDB;
        HttpSession httpSession;
        ReservationDB reservationDB;
        String data;
        ArrayList<ReservationEntity> list;

        int idPitch;
        switch (action) {
            case "edit":
                idPitch = Integer.parseInt(request.getParameter("idPitch"));
                pitchDB = new PitchDB();
                request.setAttribute("pitch", pitchDB.getPitchById(idPitch));
                request.getRequestDispatcher("adminPitches.jsp").forward(request, response);

                break;
            case "showReservations":

                idPitch = Integer.parseInt(request.getParameter("idPitch"));
                request.setAttribute("idPitch", request.getParameter("idPitch"));
                pitchDB = new PitchDB();
                data = request.getParameter("data");
                request.setAttribute("data", data);
                request.setAttribute("pitchName", pitchDB.getPitchById(idPitch).getName());
                reservationDB = new ReservationDB();
                try {
                    list = reservationDB.getListOfReservationsByPitch(idPitch, data);
                    request.setAttribute("reservationsList", list);
                    request.setAttribute("usersList", reservationDB.getListOfUsersByReservations(list));
                    if (list.size() > 0)
                        request.setAttribute("empty", "no");
                    else
                        request.setAttribute("empty", "yes");
                } catch (ParseException e) {
                    request.setAttribute("empty", "yes");
                    request.getRequestDispatcher("adminPitches.jsp").forward(request, response);
                }

                request.getRequestDispatcher("adminPitches.jsp").forward(request, response);

                break;
            case "update":
                httpSession = request.getSession();
                int idAdmin = (int) httpSession.getAttribute("idUser");
                String name = request.getParameter("name");
                String description = request.getParameter("description");
                String adress = request.getParameter("adress");
                int price = Integer.parseInt(request.getParameter("price"));
                idPitch = Integer.parseInt(request.getParameter("idPitch"));
                pitchDB = new PitchDB();
                pitchDB.updatePitch(idPitch, name, description, adress, price);

                request.setAttribute("action", "showPitches");
                request.setAttribute("pitchList", pitchDB.getListOfAnAdmin(idAdmin));
                request.getRequestDispatcher("adminPitches.jsp").forward(request, response);
                break;
            case "delete":
                int idRes = Integer.parseInt(request.getParameter("idreservation"));
                reservationDB = new ReservationDB();
                reservationDB.deleteById(idRes);

                data = request.getParameter("data");
                idPitch = Integer.parseInt(request.getParameter("idPitch"));
                request.setAttribute("idPitch", request.getParameter("idPitch"));
                pitchDB = new PitchDB();
                request.setAttribute("data", data);
                request.setAttribute("pitchName", pitchDB.getPitchById(idPitch).getName());
                request.setAttribute("action", "showReservations");
                reservationDB = new ReservationDB();
                try {
                    list = reservationDB.getListOfReservationsByPitch(idPitch, data);
                    request.setAttribute("reservationsList", list);
                    request.setAttribute("usersList", reservationDB.getListOfUsersByReservations(list));
                    if (list.size() > 0)
                        request.setAttribute("empty", "no");
                    else
                        request.setAttribute("empty", "yes");
                } catch (ParseException e) {
                    request.setAttribute("empty", "yes");
                    request.getRequestDispatcher("adminPitches.jsp").forward(request, response);
                }

                request.getRequestDispatcher("adminPitches.jsp").forward(request, response);

                break;
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession httpSession = request.getSession();
        int idAdmin = (int) httpSession.getAttribute("idUser");
        PitchDB pitchDB = new PitchDB();
        request.setAttribute("action", "showPitches");
        request.setAttribute("pitchList", pitchDB.getListOfAnAdmin(idAdmin));
        request.getRequestDispatcher("adminPitches.jsp").forward(request, response);
    }
}

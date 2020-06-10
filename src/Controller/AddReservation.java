package Controller;

import Model.ReservationDB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.text.ParseException;

@WebServlet(name = "AddReservation")
public class AddReservation extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession httpSession = request.getSession();
        httpSession.getAttribute("idUser");
        String data = request.getParameter("data");
        String ora = request.getParameter("ora");
        int idPitch = Integer.parseInt(request.getParameter("idPitch"));
        int idUser = Integer.parseInt(request.getParameter("idUser"));
        ReservationDB reservationDB = new ReservationDB();
        try {
            boolean statusReserv = reservationDB.addReservation(idUser, idPitch, data, ora);
            request.setAttribute("reservation", "succes");
        } catch (ParseException e) {
            request.setAttribute("reservation", e.getMessage());
        }
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}

package Controller;

import Entities.PitchesEntity;
import Entities.UserEntity;
import Model.PitchDB;
import Model.UserDB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.hibernate.Session;

import javax.persistence.criteria.CriteriaBuilder;
import java.io.IOException;
import java.util.ArrayList;

@WebServlet(name = "EditPitches")
public class EditPitches extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action.equals("delete")) {
            int idPitch = Integer.parseInt(request.getParameter("idPitch"));
            PitchDB pitchDB = new PitchDB();
            int idAdmin = pitchDB.getIdAdminFromIdPitch(idPitch);
            pitchDB.deletePitchById(idPitch);
            UserDB userDB = new UserDB();
            ArrayList<PitchesEntity> arrayList = pitchDB.getListOfPitches();
            boolean administrator = false;
            for (PitchesEntity o : arrayList) {
                if (o.getIdAdmin() == idAdmin) {
                    administrator = true;
                }
            }
            if (administrator == false) {
                userDB.updateType(idAdmin, "u");
            }
            request.setAttribute("pitchList", pitchDB.getListOfPitches());
            request.setAttribute("adminsList", pitchDB.getListOfAdmins(pitchDB.getListOfPitches()));
            request.setAttribute("usersList", userDB.getListOfUsers());
            request.getRequestDispatcher("editPitches.jsp").forward(request, response);
        } else if (action.equals("add")) {
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String adress = request.getParameter("adress");
            String type = request.getParameter("type");
            int price = Integer.parseInt(request.getParameter("price"));
            int idAdmin = Integer.parseInt(request.getParameter("idAdmin"));
            PitchDB pitchDB = new PitchDB();
            pitchDB.addPitch(name, description, adress, type, price, idAdmin);

            UserDB userDB = new UserDB();
            userDB.updateType(idAdmin, "a");
            request.setAttribute("pitchList", pitchDB.getListOfPitches());
            request.setAttribute("adminsList", pitchDB.getListOfAdmins(pitchDB.getListOfPitches()));
            request.setAttribute("usersList", userDB.getListOfUsers());
            request.getRequestDispatcher("editPitches.jsp").forward(request, response);
        }

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        PitchDB pitchDB = new PitchDB();
        UserDB userDB = new UserDB();
        request.setAttribute("pitchList", pitchDB.getListOfPitches());
        request.setAttribute("adminsList", pitchDB.getListOfAdmins(pitchDB.getListOfPitches()));
        request.setAttribute("usersList", userDB.getListOfUsers());
        request.getRequestDispatcher("editPitches.jsp").forward(request, response);
    }
}

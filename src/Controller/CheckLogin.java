package Controller;

import Entities.UserEntity;
import Model.UserDB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.hibernate.SessionFactory;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;
import org.hibernate.query.Query;
import org.hibernate.HibernateException;

@WebServlet(name = "CheckLogin")
public class CheckLogin extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession httpSession = request.getSession();

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        UserDB userDB = new UserDB();
        int logged = userDB.checkLogin(email, password);

        if (logged != 0) {
            response.sendRedirect("index.jsp");
            httpSession.setAttribute("logat", "true");
            httpSession.setAttribute("idUser", logged);
            httpSession.setAttribute("typeUser", userDB.getTypeById(logged));
        } else {
            request.setAttribute("test", "wrong");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession httpSession = request.getSession();
        response.sendRedirect("login.jsp");
        httpSession.setAttribute("logat", "false");
        httpSession.setAttribute("typeUser", "v");
    }
}

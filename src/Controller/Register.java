package Controller;

import Entities.UserEntity;
import Model.UserDB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

import org.hibernate.SessionFactory;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;
import org.hibernate.query.Query;
import org.hibernate.HibernateException;

@WebServlet(name = "Register")
public class Register extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String fname = request.getParameter("fname");
        String lname = request.getParameter("lname");
        String email = request.getParameter("email");
        String password = request.getParameter("psw");
        String phone = request.getParameter("phone");
        UserDB userDB = new UserDB();

        String status = userDB.registerUser(fname, lname, email, password, phone, "u");

        if (status.equals("succes")) {
            response.sendRedirect("login.jsp");
        } else if (status.equals("emailExist")) {
            request.setAttribute("test", "already exist");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        } else if (status.equals("invalidEmail")) {
            request.setAttribute("test", "invalid email");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }


    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}

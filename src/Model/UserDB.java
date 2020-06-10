package Model;

import Entities.UserEntity;
import jakarta.servlet.http.HttpSession;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;
import org.hibernate.query.Query;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.validator.routines.EmailValidator;

public class UserDB {
    private static final SessionFactory ourSessionFactory;

    static {
        try {
            Configuration configuration = new Configuration();
            configuration.configure();

            ourSessionFactory = configuration.buildSessionFactory();
        } catch (Throwable ex) {
            throw new ExceptionInInitializerError(ex);
        }
    }

    public static Session getSession() throws HibernateException {
        return ourSessionFactory.openSession();
    }

    public int checkLogin(String email, String password) {

        final Session session = getSession();
        try {
            final Query query = session.createQuery("from UserEntity");

            List<UserEntity> list = query.list();
            for (UserEntity o : list) {
                if (o.getEmail().equals(email) && o.getPassword().equals(password)) {
                    return o.getId();
                }
            }

        } finally {
            session.close();
        }
        return 0;
    }

    public String getTypeById(int id) {
        final Session session = getSession();
        try {
            final Query query = session.createQuery("from UserEntity where id=" + id);

            List<UserEntity> list = query.list();
            for (UserEntity o : list) {
                return o.getType();
            }

        } finally {
            session.close();
        }
        return "v";
    }

    public ArrayList<UserEntity> getListOfUsers() {
        ArrayList<UserEntity> userEntityArrayList;

        final Session session = getSession();
        try {
            final Query query = session.createQuery("from UserEntity");

            List<UserEntity> list = query.list();
            userEntityArrayList = new ArrayList<>(list.size());
            for (UserEntity o : list) {
                userEntityArrayList.add(o);
            }

        } finally {
            session.close();
        }
        return userEntityArrayList;
    }

    public String registerUser(String firstName, String lastName, String email, String password, String phoneNumber, String type) {

        ArrayList<UserEntity> userEntityArrayList = getListOfUsers();
        for (UserEntity o : userEntityArrayList) {
            if (o.getEmail().equals(email)) {
                return "emailExist";
            }

        }
        if (EmailValidator.getInstance().isValid(email)) {

            Session session = getSession();

            session.beginTransaction();

            UserEntity userEntity = new UserEntity();
            userEntity.setFirstName(firstName);
            userEntity.setLastName(lastName);
            userEntity.setEmail(email);
            userEntity.setPassword(password);
            userEntity.setPhoneNumber(phoneNumber);
            userEntity.setType(type);
            //Save the employee in database
            session.save(userEntity);

            //Commit the transaction
            session.getTransaction().commit();
            return "succes";
        } else {
            return "invalidEmail";
        }


    }

    public void updateType(int idUser, String type) {
        final Session session = getSession();
        try {
            final Query query = session.createQuery("from UserEntity where id=" + idUser);

            List<UserEntity> list = query.list();
            for (UserEntity o : list) {
                session.beginTransaction();
                o.setType(type);
                session.update(o);
                session.getTransaction().commit();
            }

        } finally {
            session.close();
        }
    }

    public String getNameById(int idUser) {
        String fullName = "";
        final Session session = getSession();
        try {
            final Query query = session.createQuery("from UserEntity where id=" + idUser);

            List<UserEntity> list = query.list();
            for (UserEntity o : list) {
                fullName = o.getFirstName() + " " + o.getLastName()+"<br>"+o.getPhoneNumber();
            }

        } finally {
            session.close();
        }
        return fullName;
    }
}

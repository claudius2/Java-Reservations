package Model;

import Entities.ReservationEntity;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;
import org.hibernate.query.Query;

import javax.persistence.TemporalType;
import java.sql.Date;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

public class ReservationDB {
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

    public void deteleOldReservations() {
        final Session session = getSession();
        try {
            session.beginTransaction();
            Calendar calendar = Calendar.getInstance();
            calendar.add(Calendar.DAY_OF_YEAR, -7);
            Date date = new Date(calendar.getTimeInMillis());
            session.createQuery("delete from ReservationEntity where data< :data").setParameter("data", date).executeUpdate();

            session.getTransaction().commit();


        } finally {
            session.close();
        }
    }

    public ArrayList<ReservationEntity> getListOfReservations() {
        deteleOldReservations();

        ArrayList<ReservationEntity> reservationEntityArrayList;
        final Session session = getSession();
        try {
            final Query query = session.createQuery("from ReservationEntity ");

            List<ReservationEntity> list = query.list();
            reservationEntityArrayList = new ArrayList<>(list.size());
            for (ReservationEntity p : list) {
                reservationEntityArrayList.add(p);
            }
        } finally {
            session.close();
        }


        return reservationEntityArrayList;
    }

    public boolean addReservation(int idUser, int idPitch, String data, String ora) throws ParseException {
        Session session = getSession();

        session.beginTransaction();

        ReservationEntity reservationEntity = new ReservationEntity();
        //reservationsEntity.setPitchesByIdPitch();
        DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        java.util.Date date = df.parse(data);
        Date goodDate = new Date(date.getTime());
        reservationEntity.setData(goodDate);
        reservationEntity.setHour(Integer.parseInt(ora));
        reservationEntity.setIdPitch(idPitch);
        reservationEntity.setIdUser(idUser);
        reservationEntity.setTime(1);

        session.save(reservationEntity);

        //Commit the transaction
        session.getTransaction().commit();
        return true;
    }

    public ArrayList<String> getFreeHours(int idPitch, String data) throws ParseException {
        ArrayList<String> freeHours = new ArrayList<>(14);
        DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        java.util.Date date = df.parse(data);
        Date goodDate = new Date(date.getTime());

        for (int i = 10; i < 24; i++) {
            freeHours.add(String.valueOf(i));
        }
        final Session session = getSession();
        try {
            final Query query = session.createQuery("from ReservationEntity ");

            List<ReservationEntity> list = query.list();
            for (ReservationEntity p : list) {
                if (p.getIdPitch() == idPitch && data.equals(df.format(p.getData()))) {
                    freeHours.remove(String.valueOf(p.getHour()));
                }
            }
        } finally {
            session.close();
        }

        return freeHours;

    }

    public ArrayList<ReservationEntity> getListOfReservationsByPitch(int idPitch, String data) throws ParseException {
        ArrayList<ReservationEntity> reservationEntityArrayList;
        DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        java.util.Date date = df.parse(data);
        Date goodDate = new Date(date.getTime());
        final Session session = getSession();
        try {
            final Query query = session.createQuery("from ReservationEntity where idPitch=:idPitch and data=:data");
            query.setParameter("idPitch", idPitch);
            query.setParameter("data", goodDate);

            List<ReservationEntity> list = query.list();
            reservationEntityArrayList = new ArrayList<>(list.size());
            for (ReservationEntity p : list) {
                reservationEntityArrayList.add(p);
            }
        } finally {
            session.close();
        }
        return reservationEntityArrayList;
    }

    public ArrayList<String> getListOfUsersByReservations(ArrayList<ReservationEntity> list) {
        ArrayList<String> finalList = new ArrayList<>(list.size());
        UserDB userDB = new UserDB();
        for (ReservationEntity r : list) {
            finalList.add(userDB.getNameById(r.getIdUser()));
        }
        return finalList;
    }

    public void deleteById(int id) {
        final Session session = getSession();
        try {
            session.beginTransaction();
            session.createQuery("delete from ReservationEntity where id= :id").setParameter("id", id).executeUpdate();

            session.getTransaction().commit();


        } finally {
            session.close();
        }
    }

}

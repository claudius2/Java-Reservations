package Model;

import Entities.PitchesEntity;
import Entities.ReservationEntity;
import Entities.UserEntity;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;
import org.hibernate.query.Query;

import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

public class PitchDB {
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

    public PitchesEntity getPitchById(int id) {
        final Session session = getSession();
        try {
            final Query query = session.createQuery("from PitchesEntity where id=" + id);

            List<PitchesEntity> list = query.list();
            for (PitchesEntity p : list) {
                return p;
            }
        } finally {
            session.close();
        }
        return new PitchesEntity();
    }

    public ArrayList<PitchesEntity> getListOfPitches() {
        ArrayList<PitchesEntity> pitchesEntityArrayList;

        final Session session = getSession();
        try {
            final Query query = session.createQuery("from PitchesEntity ");

            List<PitchesEntity> list = query.list();
            pitchesEntityArrayList = new ArrayList<>(list.size());
            for (PitchesEntity p : list) {
                pitchesEntityArrayList.add(p);
            }
        } finally {
            session.close();
        }

        return pitchesEntityArrayList;
    }

    public ArrayList<PitchesEntity> getListOfPitchesBySport(String sport) {
        ArrayList<PitchesEntity> pitchesEntityArrayList;

        final Session session = getSession();
        try {
            final Query query = session.createQuery("from PitchesEntity ");

            List<PitchesEntity> list = query.list();
            pitchesEntityArrayList = new ArrayList<>(list.size());
            for (PitchesEntity p : list) {
                if (p.getType().equals(sport))
                    pitchesEntityArrayList.add(p);
            }
        } finally {
            session.close();
        }

        return pitchesEntityArrayList;
    }

    public ArrayList<PitchesEntity> getEmptyPitches(String data, String oraD, String sport) {
        int ora = Integer.parseInt(oraD);
        String initialaSport = String.valueOf(sport.charAt(0));

        ArrayList<PitchesEntity> emptyPitchesList = getListOfPitchesBySport(initialaSport);
        ReservationDB reservationDB = new ReservationDB();
        ArrayList<ReservationEntity> listOfAllReservations = reservationDB.getListOfReservations();

        for (int i = 0; i < emptyPitchesList.size(); i++) {
            PitchesEntity p = emptyPitchesList.get(i);

            for (ReservationEntity r : listOfAllReservations) {
                if (r.getData().toString().equals(data) && p.getId() == r.getIdPitch() && r.getHour() <= ora && (r.getHour() + r.getTime() - 1) >= ora) {
                    emptyPitchesList.remove(p);
                    i--;
                }
            }
        }

        return emptyPitchesList;
    }

    public boolean deletePitchById(int id) {
        final Session session = getSession();
        try {
            session.beginTransaction();
            session.createQuery("delete from PitchesEntity where id= :id").setParameter("id", id).executeUpdate();

            session.getTransaction().commit();


        } finally {
            session.close();
        }

        return true;
    }

    public void addPitch(String name, String description, String adress, String type, int price, int idAdmin) {
        Session session = getSession();

        session.beginTransaction();
        PitchesEntity pitchesEntity = new PitchesEntity();
        pitchesEntity.setName(name);
        pitchesEntity.setDescription(description);
        pitchesEntity.setAdress(adress);
        pitchesEntity.setType(type);
        pitchesEntity.setPrice(price);
        pitchesEntity.setIdAdmin(idAdmin);

        //Save the employee in database
        session.save(pitchesEntity);

        //Commit the transaction
        session.getTransaction().commit();
    }

    public int getIdAdminFromIdPitch(int idPitch) {

        final Session session = getSession();
        try {
            final Query query = session.createQuery("from PitchesEntity where id=" + idPitch);

            List<PitchesEntity> list = query.list();
            for (PitchesEntity p : list) {
                return p.getIdAdmin();
            }
        } finally {
            session.close();
        }
        return -1;
    }

    public ArrayList<String> getListOfAdmins(ArrayList<PitchesEntity> listOfPitches) {
        UserDB userDB = new UserDB();
        ArrayList<String> listOfAdmins = new ArrayList<>(listOfPitches.size());
        for (PitchesEntity p : listOfPitches) {
            listOfAdmins.add(userDB.getNameById(p.getIdAdmin()));
        }
        return listOfAdmins;
    }

    public ArrayList<PitchesEntity> getListOfAnAdmin(int idAdmin) {
        ArrayList<PitchesEntity> arrayList;
        final Session session = getSession();
        try {
            final Query query = session.createQuery("from PitchesEntity where idAdmin=" + idAdmin);

            List<PitchesEntity> list = query.list();
            arrayList = new ArrayList<>(list.size());
            for (PitchesEntity p : list) {
                arrayList.add(p);
            }
        } finally {
            session.close();
        }
        return arrayList;
    }

    public void updatePitch(int id, String name, String description, String adress, int price) {
        final Session session = getSession();
        try {
            session.beginTransaction();
            Query query = session.createQuery("update PitchesEntity set name=:name, description=:description, adress=:adress, price=:price where id= :id");
            query.setParameter("name", name);
            query.setParameter("description", description);
            query.setParameter("adress", adress);
            query.setParameter("price", price);
            query.setParameter("id", id);
            query.executeUpdate();

            session.getTransaction().commit();

        } finally {
            session.close();
        }
    }
}

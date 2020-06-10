import Entities.PitchesEntity;
import Entities.ReservationEntity;
import Model.PitchDB;
import Model.ReservationDB;
import Model.UserDB;
import org.hibernate.HibernateException;
import org.hibernate.Metamodel;
import org.hibernate.query.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;

import javax.persistence.metamodel.EntityType;

import java.util.ArrayList;
import java.util.Map;
import java.util.*;
import javax.mail.*;
import javax.mail.internet.*;
import javax.activation.*;

public class Main {
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

    public static void main(final String[] args) throws Exception {
        // Recipient's email ID needs to be mentioned.
        String to = "claudiu.stefan@ulbsibiu.ro";

        // Sender's email ID needs to be mentioned
        String from = "claudiustefan254@gmail.com";

        // Assuming you are sending email from localhost
        String host = "localhost";

        // Get system properties
        Properties properties = System.getProperties();

        // Setup mail server
        properties.setProperty("mail.smtp.host", host);

        // Get the default Session object.
        javax.mail.Session session = javax.mail.Session.getDefaultInstance(properties);

        try {
            // Create a default MimeMessage object.
            MimeMessage message = new MimeMessage(session);

            // Set From: header field of the header.
            message.setFrom(new InternetAddress(from));

            // Set To: header field of the header.
            message.addRecipient(Message.RecipientType.TO, new InternetAddress(to));

            // Set Subject: header field
            message.setSubject("This is the Subject Line!");

            // Now set the actual message
            message.setText("This is actual message");

            // Send message
            Transport.send(message);
            System.out.println("Sent message successfully....");
        } catch (MessagingException mex) {
            mex.printStackTrace();
        }


        /*
        UserDB userDB=new UserDB();
        userDB.updateType(10,"a");
        PitchDB pitchDB=new PitchDB();
        pitchDB.addPitch("Teren Fotbal","Descrierea terenului","Spring","f",90,7);
        UserDB userDB=new UserDB();
        System.out.print(userDB.getTypeById(3));
        PitchDB pitchDB=new PitchDB();
        ReservationDB reservationDB=new ReservationDB();
        ArrayList<ReservationEntity> arrayList=  reservationDB.getListOfReservations();
        for(ReservationEntity r: arrayList   ) {
            System.out.println(r.getData().toString());
        }
         PitchesEntity pitchesEntity=pitchDB.getPitchById(4);
        System.out.println(pitchesEntity.getName());
       ArrayList<PitchesEntity> list=pitchDB.getEmptyPitches("2020-05-21","18","fotbal");
        for (PitchesEntity o: list   ) {
            System.out.println(o.getName());

        }*/
        /*  final Session session = getSession();
        try {
            System.out.println("querying all the managed entities...");
            final Metamodel metamodel = session.getSessionFactory().getMetamodel();
            for (EntityType<?> entityType : metamodel.getEntities()) {
                final String entityName = entityType.getName();
                final Query query = session.createQuery("from " + entityName);
                System.out.println("executing: " + query.getQueryString());
                for (Object o : query.list()) {
                    System.out.println("  " + o);
                }
            }
        } finally {
            session.close();
        }*/
    }
}
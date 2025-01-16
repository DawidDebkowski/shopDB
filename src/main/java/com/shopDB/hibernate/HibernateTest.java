package com.shopDB.hibernate;

import com.shopDB.entities.Client;
import com.shopDB.entities.User;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.mapping.UnionSubclass;

public class HibernateTest {
    public static void main(String[] args) {
        Session session = HibernateUtil.getSessionFactory().openSession();

        Transaction transaction = null;
        try (session) {
            transaction = session.beginTransaction();
            // Tworzenie nowego użytkownika
            User user = new User();
            user.setLogin("testUser");
            user.setPassword("testPassword");

            session.save(user);
            transaction.commit();

            System.out.println("Użytkownik zapisany!");
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        } finally {
            HibernateUtil.shutdown();
        }
    }
}

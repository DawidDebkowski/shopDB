package com.shopDB.hibernate;

import com.shopDB.entities.User;
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 * Ta klasa pokazuje jak połączyć się z bazą danych.
 */
public class HibernateTest {
    public static void main(String[] args) {
        Session session = null;
        Transaction transaction = null;

        try {
            session = HibernateUtil.getSessionFactory().openSession();
            transaction = session.beginTransaction();

            // Tworzenie nowego użytkownika
            User user = new User();
            user.setLogin("testUser");
            user.setPassword("testPassword");
            user.setAccType("admin");

            session.save(user);
            transaction.commit();

            System.out.println("Użytkownik zapisany!");
        } catch (Exception e) {
            if (transaction != null && transaction.isActive()) {
                transaction.rollback(); // Rollback tylko gdy transakcja jest aktywna
            }
            e.printStackTrace();
        } finally {
            if (session != null && session.isOpen()) {
                session.close(); // Zamknięcie sesji ręcznie
            }
            HibernateUtil.shutdown(); // Zamknięcie SessionFactory na końcu
        }
    }
}

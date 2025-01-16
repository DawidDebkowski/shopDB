package com.shopDB;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * O strukturze:
 *
 * Modularność kodu:
 *     Spring zachęca do organizowania kodu w warstwach:
 *         Controller (logika widoku, np. w JavaFX),
 *         Service (logika biznesowa),
 *         Repository (dostęp do danych, np. Hibernate).
 *     To sprawia, że aplikacja staje się bardziej czytelna i łatwiejsza do rozwijania.
 */
@SpringBootApplication
public class ShopApp {

    public static void main(String[] args) {
        SpringApplication.run(ShopApp.class, args);
    }
}

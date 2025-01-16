package com.shopDB.controller;

import com.shopDB.ShopApp;
import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Scene;
import javafx.scene.control.Label;
import javafx.stage.Stage;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.context.ApplicationContext;

/**
 * Hello world!
 *
 */
public class App extends Application
{
    public static void main( String[] args )
    {
        launch(args);
    }

    private ApplicationContext springContext;

    @Override
    public void init() {
        springContext = new SpringApplicationBuilder(ShopApp.class).run();
    }

    @Override
    public void start(Stage primaryStage) throws Exception {
        FXMLLoader loader = new FXMLLoader(getClass().getResource("/controller/main.fxml"));
        loader.setControllerFactory(springContext::getBean);

        primaryStage.setScene(new Scene(loader.load()));
        primaryStage.setTitle("Shop Application");
        primaryStage.show();
    }

    @Override
    public void stop() throws Exception {
        super.stop();
        SpringApplication.exit(springContext);
    }

}

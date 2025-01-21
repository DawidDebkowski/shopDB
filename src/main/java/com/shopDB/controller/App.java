package com.shopDB.controller;

import com.shopDB.SceneType;
import com.shopDB.ShopApp;
import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Scene;
import javafx.stage.Stage;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.context.ApplicationContext;

/**
 * Main GUI class
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
        SceneManager sceneManager = springContext.getBean(SceneManager.class);
        sceneManager.initialize(primaryStage);

        SceneManager.getInstance().setScene(SceneType.LOGIN);
        primaryStage.setTitle("Shop Application");
        primaryStage.show();
    }

    @Override
    public void stop() throws Exception {
        super.stop();
        SpringApplication.exit(springContext);
    }

}

package com.gui;

import javafx.application.Application;
import javafx.scene.Scene;
import javafx.scene.control.Label;
import javafx.stage.Stage;

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

    @Override
    public void start(Stage stage) throws Exception {
        Label label = new Label("Hello World!");
        Scene scene = new Scene(label, 300, 300);
        stage.setScene(scene);
        stage.setTitle("Hello World!");
        stage.show();
    }
}

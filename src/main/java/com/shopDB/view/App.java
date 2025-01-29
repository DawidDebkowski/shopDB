package com.shopDB.view;

import com.shopDB.SceneType;
import com.shopDB.ShopApp;
import com.shopDB.dto.ProductDTO;
import io.github.palexdev.materialfx.theming.JavaFXThemes;
import io.github.palexdev.materialfx.theming.MaterialFXStylesheets;
import io.github.palexdev.materialfx.theming.UserAgentBuilder;
import javafx.application.Application;
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
    public static int userId=1;
    public static String userType="client";
    public static ProductDTO lastChosenProduct;

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
        UserAgentBuilder.builder()
                .themes(JavaFXThemes.MODENA)
                .themes(MaterialFXStylesheets.forAssemble(true))
                .setDeploy(true)
                .setResolveAssets(true)
                .build()
                .setGlobal();


        SceneManager sceneManager = springContext.getBean(SceneManager.class);
        sceneManager.initialize(primaryStage);

        SceneManager.getInstance().setScene(SceneType.SINGLE_PRODUCT);
        primaryStage.setTitle("Shop Application");
        primaryStage.show();
    }

    @Override
    public void stop() throws Exception {
        super.stop();
        SpringApplication.exit(springContext);
    }

}

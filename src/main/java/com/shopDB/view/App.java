package com.shopDB.view;

import com.shopDB.SceneType;
import com.shopDB.ShopApp;
import com.shopDB.dto.ProductDTO;
import io.github.palexdev.materialfx.theming.JavaFXThemes;
import io.github.palexdev.materialfx.theming.MaterialFXStylesheets;
import io.github.palexdev.materialfx.theming.UserAgentBuilder;
import javafx.application.Application;
import javafx.scene.image.Image;
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
    public static int userId;
    public static String userType;
    public static ProductDTO lastChosenProduct = null;
    public static Integer lastSelectedOrderId = null;

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

        SceneManager.getInstance().setScene(SceneType.LOGIN);
        primaryStage.setTitle("Szop DB");

        Image icon = new Image(App.class.getResourceAsStream("/racoon-transparent.png"));
        primaryStage.getIcons().add(icon);

        primaryStage.show();
    }

    @Override
    public void stop() throws Exception {
        super.stop();
        SpringApplication.exit(springContext);
    }

}

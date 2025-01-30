package com.shopDB.view;

import com.shopDB.SceneType;
import com.shopDB.view.controllers.SceneController;
import javafx.fxml.FXMLLoader;
import javafx.scene.Scene;
import javafx.stage.Stage;
import org.springframework.context.ApplicationContext;
import org.springframework.stereotype.Controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

/**
 * Singleton class to change scenes.
 */
@Controller
public class SceneManager {
    private static Stage stage;
    private static SceneManager Instance;
    private final Map<SceneType, String> scenes = new HashMap<>();
    private final ApplicationContext springContext;

    public SceneManager(ApplicationContext applicationContext) {
        this.springContext = applicationContext;
    }

    public static SceneManager getInstance() {
        return Instance;
    }

    public void initialize(Stage primaryStage) {
        Instance = this;
        stage = primaryStage;

        scenes.put(SceneType.LOGIN, "/fxml/login.fxml");
        scenes.put(SceneType.CLIENT_DATA, "/fxml/clientData.fxml");
        scenes.put(SceneType.MAIN_SHOP, "/fxml/mainShop.fxml");
        scenes.put(SceneType.SINGLE_PRODUCT, "/fxml/singleProduct.fxml");
        scenes.put(SceneType.CART, "/fxml/cart.fxml");
        scenes.put(SceneType.ORDER_HISTORY, "/fxml/orderHistory.fxml");
        scenes.put(SceneType.ADD_PRODUCT, "/fxml/addProduct.fxml");

        stage.setTitle("Trylma Chinesisches Dame von Ćmolud (TM)");
        stage.show();
    }

    /**
     * Changes the scene based on the enum.
     * @param sceneType new scene
     */
    public void setScene(SceneType sceneType) {
        try {
            FXMLLoader loader = new FXMLLoader(SceneManager.class.getResource(scenes.get(sceneType)));
            loader.setControllerFactory(springContext::getBean);

            Scene scene = new Scene(loader.load());
            SceneController controller = loader.getController();
            stage.setScene(scene);
            controller.refresh();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
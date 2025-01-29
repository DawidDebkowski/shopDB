package com.shopDB.view.controllers;

import com.shopDB.SceneType;
import com.shopDB.view.SceneManager;
import javafx.fxml.FXML;
import javafx.event.ActionEvent;
import org.springframework.stereotype.Controller;

@Controller
public class HeaderController {

    public HeaderController() {
        System.out.println("HeaderController()");
    }

    @FXML
    void goToCart(ActionEvent event) {
        SceneManager.getInstance().setScene(SceneType.CART);
    }

    @FXML
    void goToClientData(ActionEvent event) {
        SceneManager.getInstance().setScene(SceneType.CLIENT_DATA);
    }

    @FXML
    void goToMainShop(ActionEvent event) {
        SceneManager.getInstance().setScene(SceneType.MAIN_SHOP);
    }

    @FXML
    void goToOrderHistory(ActionEvent event) {
        SceneManager.getInstance().setScene(SceneType.ORDER_HISTORY);
    }

    @FXML
    void goToTitle(ActionEvent event) {
        SceneManager.getInstance().setScene(SceneType.MAIN_SHOP);
    }

    @FXML
    void onLogoutButtonClicked(ActionEvent event) {
        SceneManager.getInstance().setScene(SceneType.LOGIN);
        // TODO: logika wylogowania
    }

}

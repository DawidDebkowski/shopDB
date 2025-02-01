package com.shopDB.view.controllers;

import com.shopDB.SceneType;
import com.shopDB.view.App;
import com.shopDB.view.SceneManager;
import io.github.palexdev.materialfx.controls.MFXButton;
import javafx.fxml.FXML;
import javafx.event.ActionEvent;
import org.springframework.stereotype.Controller;

@Controller
public class HeaderController {

    @FXML
    private MFXButton addProductButton;

    @FXML
    private MFXButton cartButton;

    @FXML
    private MFXButton dataButton;

    @FXML
    private MFXButton ordersButton;

    public HeaderController() {
        System.out.println("HeaderController()");
    }

    public void initialize() {
        if("warehouse".equals(App.userType)) {
            disableButton(addProductButton);
            disableButton(cartButton);
            disableButton(dataButton);
        } else if("salesman".equals(App.userType)) {
            disableButton(ordersButton);
            disableButton(cartButton);
            disableButton(dataButton);
        } else {
            disableButton(addProductButton);
        }
    }

    private void disableButton(MFXButton button) {
        button.setDisable(true);
        button.setVisible(false);
        button.setMinWidth(0);
        button.setPrefWidth(0);
    }

    @FXML
    void goToAddProduct(ActionEvent event) {
        App.lastChosenProduct = null;
        SceneManager.getInstance().setScene(SceneType.ADD_PRODUCT);
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

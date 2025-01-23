package com.shopDB.controller;

import com.shopDB.SceneType;
import io.github.palexdev.materialfx.controls.*;
import io.github.palexdev.mfxcore.controls.Label;
import io.github.palexdev.mfxcore.controls.Text;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.Scene;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.Region;
import javafx.scene.layout.VBox;
import org.springframework.stereotype.Controller;

@Controller
public class LoginController implements SceneController {
    private boolean loginState = true;

    @FXML
    private MFXToggleButton companyToggle;

    @FXML
    private MFXCheckbox cookiesCheckbox;

    @FXML
    private MFXTextField emailField;

    @FXML
    private VBox fieldsBox1;

    @FXML
    private MFXButton forgotButton;

    @FXML
    private MFXButton loginButton;

    @FXML
    private MFXButton loginButton1;

    @FXML
    private MFXPasswordField loginPasswordField;

    @FXML
    private VBox loginStateBox;

    @FXML
    private MFXTextField loginUsernameField;

    @FXML
    private VBox loginWrapper;

    @FXML
    private BorderPane mainPane;

    @FXML
    private Label messageLabel;

    @FXML
    private Label messageLabel1;

    @FXML
    private MFXTextField nipField;

    @FXML
    private MFXTextField phoneField;

    @FXML
    private MFXButton registerButton;

    @FXML
    private MFXButton registerButton1;

    @FXML
    private MFXPasswordField registerPasswordField;

    @FXML
    private VBox registerStateBox;

    @FXML
    private MFXTextField registerUsernameField;

    @FXML
    private VBox registerWrapper;

    @FXML
    private MFXCheckbox rodoCheckbox;

    @FXML
    private MFXPasswordField secondPasswordField;

    @FXML
    private MFXCheckbox termsCheckbox;

    @FXML
    void onForgotButtonClicked(ActionEvent event) {
        System.out.println("to be added maybe");
    }

    @FXML
    void onLoginButtonClick(ActionEvent event) {
        if(loginState){
            setMessage("can't login");
            SceneManager.getInstance().setScene(SceneType.LOGIN);
        } else {
            changeState(true );
        }
    }

    @FXML
    void onRegisterButtonClick(ActionEvent event) {
        if(!loginState){
            setMessage("can't register");
            SceneManager.getInstance().setScene(SceneType.MAIN_SHOP);

        } else {
            changeState(false);
        }
    }

    private void changeState(boolean newState) {
        loginState = newState;
        loginWrapper.setVisible(loginState);
        registerWrapper.setVisible(!loginState);
        if(loginState){
            loginWrapper.setMinHeight(Region.USE_COMPUTED_SIZE);
            registerWrapper.setMinHeight(0);
        } else {
            loginWrapper.setMinHeight(0);
            registerWrapper.setMinHeight(Region.USE_COMPUTED_SIZE);
        }
    }

    private void setMessage(String message) {
        messageLabel.setVisible(true);
        messageLabel.setText(message);
    }

    @FXML
    void onCookiesCheckboxClicked(ActionEvent event) {

    }

    @FXML
    void onRodoCheckboxClicked(ActionEvent event) {

    }

    @FXML
    void onTermsCheckboxClicked(ActionEvent event) {

    }
}

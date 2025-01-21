package com.shopDB.controller;

import com.shopDB.SceneType;
import io.github.palexdev.materialfx.controls.MFXButton;
import io.github.palexdev.materialfx.controls.MFXPasswordField;
import io.github.palexdev.materialfx.controls.MFXTextField;
import io.github.palexdev.mfxcore.controls.Label;
import io.github.palexdev.mfxcore.controls.Text;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.Region;
import javafx.scene.layout.VBox;
import org.springframework.stereotype.Controller;

@Controller
public class LoginController implements SceneController {
    private boolean loginState = true;

    @FXML
    private Label messageLabel;

    @FXML
    private MFXTextField emailText;

    @FXML
    private VBox fieldsBox;

    @FXML
    private MFXButton forgotButton;

    @FXML
    private MFXButton loginButton;

    @FXML
    private MFXButton loginButton1;

    @FXML
    private VBox loginStateBox;

    @FXML
    private BorderPane mainPane;

    @FXML
    private MFXPasswordField passwordText;

    @FXML
    private MFXButton registerButton;

    @FXML
    private MFXButton registerButton1;

    @FXML
    private VBox registerStateBox;

    @FXML
    private MFXPasswordField secondPasswordText;

    @FXML
    private Text titleText;

    @FXML
    private MFXTextField usernameText;

    @FXML
    void onForgotButtonClicked(ActionEvent event) {
        System.out.println("to be added maybe");
    }

    @FXML
    void onLoginButtonClick(ActionEvent event) {
        if(loginState){
            setMessage("can't login");
            SceneManager.getInstance().setScene(SceneType.CLIENT_DATA);
        } else {
            changeState(true );
        }
    }

    @FXML
    void onRegisterButtonClick(ActionEvent event) {
        if(!loginState){
            setMessage("can't register");
        } else {
            changeState(false);
        }
    }

    private void changeState(boolean newState) {
        loginState = newState;
        loginStateBox.setVisible(loginState);
        registerStateBox.setVisible(!loginState);
        emailText.setVisible(!loginState);
        if(loginState){
            loginStateBox.setMinHeight(Region.USE_COMPUTED_SIZE);
            registerStateBox.setMinHeight(0);
            emailText.setMinHeight(0);
        } else {
            loginStateBox.setMinHeight(0);
            registerStateBox.setMinHeight(Region.USE_COMPUTED_SIZE);
            emailText.setMinHeight(Region.USE_COMPUTED_SIZE);
        }
    }

    private void setMessage(String message) {
        messageLabel.setVisible(true);
        messageLabel.setText(message);
    }
}

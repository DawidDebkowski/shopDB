package com.shopDB.controller;

import io.github.palexdev.materialfx.controls.MFXButton;
import io.github.palexdev.materialfx.controls.MFXPasswordField;
import io.github.palexdev.materialfx.controls.MFXTextField;
import io.github.palexdev.mfxcore.controls.Text;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.VBox;
import org.springframework.stereotype.Controller;

@Controller
public class LoginController {

    @FXML
    private VBox fieldsBox;

    @FXML
    private MFXButton loginButton;

    @FXML
    private BorderPane mainPane;

    @FXML
    private MFXPasswordField passwordText;

    @FXML
    private MFXButton registerButton;

    @FXML
    private Text titleText;

    @FXML
    private MFXTextField usernameText;

    @FXML
    void onLoginButtonClick(ActionEvent event) {

    }

    @FXML
    void onRegisterButtonClick(ActionEvent event) {

    }

}

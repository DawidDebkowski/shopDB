package com.shopDB.controller;

import com.shopDB.service.UserService;
import javafx.fxml.FXML;
import javafx.scene.control.Button;
import javafx.scene.control.TextField;
import org.springframework.stereotype.Component;

@Component
public class MainController {

    private final UserService userService;

    @FXML
    private TextField nameField;

    @FXML
    private TextField emailField;

    @FXML
    private TextField accField;


    @FXML
    private Button saveButton;

    public MainController(UserService userService) {
        this.userService = userService;
    }

    @FXML
    public void initialize() {
        saveButton.setOnAction(event -> {
            String login = nameField.getText();
            String password = emailField.getText();
            String accountType = accField.getText();
            userService.saveUser(login, password, accountType);
            System.out.println("User saved!");
        });
    }
}
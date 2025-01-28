package com.shopDB.view.controllers;

import java.sql.CallableStatement;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import com.shopDB.dto.ClientInfoDTO;
import com.shopDB.service.ClientService;
import com.shopDB.service.GeneralService;
import com.shopDB.service.UserService;
import com.shopDB.view.App;

import io.github.palexdev.materialfx.controls.MFXTextField;
import javafx.fxml.FXML;
import javafx.scene.layout.BorderPane;
import javafx.event.ActionEvent;

@Controller
public class ClientDataSceneController implements SceneController {

    @FXML
    private MFXTextField apartmentNumberField;

    @FXML
    private MFXTextField cityField;

    @FXML
    private MFXTextField companyNameField;

    @FXML
    private MFXTextField emailField;

    @FXML
    private MFXTextField houseNumberField;

    @FXML
    private MFXTextField lastNameField;

    @FXML
    private BorderPane mainPane;

    @FXML
    private MFXTextField nameField;

    @FXML
    private MFXTextField nipField;

    @FXML
    private MFXTextField phoneField;

    @FXML
    private MFXTextField postalCodeField;

    @FXML
    private MFXTextField streetField;

    @Autowired
    GeneralService generalService;

    @Autowired
    ClientService clientService;

    @Autowired
    UserService userService;
    
    public void initialize() {
        ClientInfoDTO clientInfo = generalService.showClientInfo(clientService.getIdbyUser(userService.getbyId(App.userId)));
        emailField.setText(clientInfo.getEmail());
        phoneField.setText(clientInfo.getPhone());

        if (clientService.getTypebyUser(userService.getbyId(App.userId)).equals("individual")) {
            nameField.setVisible(true);
            nameField.setDisable(false);
            
            lastNameField.setVisible(true);
            lastNameField.setDisable(false);

            companyNameField.setVisible(false);
            companyNameField.setDisable(true);
            
            nipField.setVisible(false);
            nipField.setDisable(true);

            try {nameField.setText(clientInfo.getName());} catch(Exception e) {}
            try {lastNameField.setText(clientInfo.getSurname());} catch(Exception e) {}
        } else {
            nameField.setVisible(false);
            nameField.setDisable(true);
            
            lastNameField.setVisible(false);
            lastNameField.setDisable(true);

            companyNameField.setVisible(true);
            companyNameField.setDisable(false);
            
            nipField.setVisible(true);
            nipField.setDisable(false);

            try {companyNameField.setText(clientInfo.getCompanyName());} catch(Exception e) {}
            try {nipField.setText(clientInfo.getNIP());} catch(Exception e) {}
        }
    }

    @FXML
    void onSaveAddressClicked(ActionEvent event) {
        // zapisanie adresu do bazy
        // na przykład String street = streetField.getText();
    }

    @FXML
    void onSaveClientDataClicked(ActionEvent event) {
        // zapisanie danych klienta do bazy
    }
}

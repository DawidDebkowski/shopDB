package com.shopDB.view.controllers;

import org.springframework.stereotype.Controller;
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

    public void initialize() {
        // schować / pokazać nip i nazwę firmy w zależności od typu klienta
        nipField.setVisible(false);
        nipField.setDisable(true);
        // oraz wpisać już dane w pole
        emailField.setText("b.pawluk@gmail.com");
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

    @Override
    public void refresh() {

    }
}

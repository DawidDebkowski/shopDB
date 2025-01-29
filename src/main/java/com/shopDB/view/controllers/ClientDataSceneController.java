package com.shopDB.view.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import com.shopDB.dto.ClientInfoDTO;
import com.shopDB.service.ClientService;
import com.shopDB.service.GeneralService;
import com.shopDB.service.UserService;
import com.shopDB.view.App;
import com.shopDB.view.components.PopUp;

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

        try {streetField.setText(clientInfo.getStreet());} catch(Exception e) {}
        try {houseNumberField.setText(clientInfo.getHouseNumber().toString());} catch(Exception e) {}
        try {apartmentNumberField.setText(clientInfo.getApartmentNumber().toString());} catch(Exception e) {}
        try {cityField.setText(clientInfo.getCity());} catch(Exception e) {}
        try {postalCodeField.setText(clientInfo.getPostalCode());} catch(Exception e) {}

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
        try {
            String street = streetField.getText().trim();
            if (street.equals("")) throw new IllegalArgumentException("Podaj ulice.");

            String city = cityField.getText().trim();
            if (city.equals("")) throw new IllegalArgumentException("Podaj miasto.");

            String postalCode = postalCodeField.getText().trim();
            if (postalCode.equals("")) throw new IllegalArgumentException("Podaj kod pocztowy.");

            String houseNumberString = houseNumberField.getText().trim();
            Integer houseNumber;
            if (houseNumberString.equals("")) throw new IllegalArgumentException("Podaj numer domu");
            try {houseNumber = Integer.parseInt(houseNumberString);} 
            catch(NumberFormatException e) {throw new IllegalArgumentException("Niepoprawny numer domu.");}

            String apartmentNumberString = apartmentNumberField.getText().trim();
            Integer apartmentNumber;
            if (apartmentNumberString.equals("")) apartmentNumber = null;
            else try {apartmentNumber = Integer.parseInt(apartmentNumberString);}
            catch (NumberFormatException e) {throw new IllegalArgumentException("Niepoprawny numer mieszkania.");}

            String response = clientService.changeAddress(
                clientService.getIdbyUser(userService.getbyId(App.userId)), 
                street,
                houseNumber,
                apartmentNumber,
                city,
                postalCode
            );

            if (response.startsWith("Zmieniono adres.")) {
                new PopUp("Sukces", "Zmieniono adres", null);
            } else {
                throw new IllegalArgumentException(response);
            }
        } catch (IllegalArgumentException e) {
            new PopUp("Błąd", "Niepoprawny adres", e.getMessage());
        }
    }

    @FXML
    void onSaveClientDataClicked(ActionEvent event) {
        try {
            String email = emailField.getText().trim();
            if (email.equals("")) throw new IllegalArgumentException("Podaj email.");

            String phone = phoneField.getText().trim();
            if (phone.equals("")) throw new IllegalArgumentException("Podaj numer telefonu.");

            String response;
            if (clientService.getTypebyUser(userService.getbyId(App.userId)).equals("individual")) {
                String name = nameField.getText().trim();
                if (name.equals("")) name = null;

                String surname = lastNameField.getText().trim();
                if (surname.equals("")) surname = null;

                response = clientService.changeAccInfoIndividual(
                    clientService.getIdbyUser(userService.getbyId(App.userId)),
                    name,
                    surname,
                    email,
                    phone
                );
            } else {
                String companyName = companyNameField.getText().trim();
                if (companyName.equals("")) companyName = null;

                String NIP = nipField.getText().trim();
                if (NIP.equals("")) throw new IllegalArgumentException("Podaj NIP.");

                response = clientService.changeAccInfoCompany(
                    clientService.getIdbyUser(userService.getbyId(App.userId)),
                    companyName,
                    NIP,
                    email,
                    phone
                );

            }
            
            if (response.startsWith("Zmieniono dane.")) {
                new PopUp("Sukces", response, null);
            } else {
                throw new IllegalArgumentException(response);
            }
        } catch (IllegalArgumentException e) {
            new PopUp("Błąd", "Niepoprawny adres", e.getMessage());
        }
    }

    @Override
    public void refresh() {

    }
}

package com.shopDB.view.controllers;

import com.shopDB.service.GeneralService;
import com.shopDB.service.SalesmanService;
import com.shopDB.view.components.PopUp;

import javafx.collections.FXCollections;
import javafx.collections.ObservableList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import io.github.palexdev.materialfx.controls.MFXComboBox;
import io.github.palexdev.materialfx.controls.MFXTextField;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.layout.BorderPane;

import java.util.Arrays;

@Controller
public class AddProductController implements SceneController {
    private final GeneralService generalService;
    @FXML
    private MFXComboBox<String> categoryComboBox;

    @FXML
    private MFXComboBox<String> colorComboBox;

    @FXML
    private MFXTextField colorNameField;

    @FXML
    private MFXTextField emailField;

    @FXML
    private MFXTextField hexColorField;

    @FXML
    private BorderPane mainPane;

    @FXML
    private MFXTextField nameField;

    @FXML
    private MFXTextField phoneField;

    @FXML
    private MFXComboBox<String> typeComboBox;

    @FXML
    private MFXTextField typeField;

    @Autowired
    private SalesmanService salesmanService;

    public AddProductController(GeneralService generalService) {
        this.generalService = generalService;
    }

    @FXML
    void displayCategory(ActionEvent event) {

    }

    @FXML
    void onColorConfirm(ActionEvent event) {

    }

    @FXML
    void onSaveColorClicked(ActionEvent event) {

    }

    @FXML
    void onSaveProductClicked(ActionEvent event) {

    }

    @FXML
    void onSaveTypeClicked(ActionEvent event) {
        String newType = typeField.getText();
        if (newType.equals("")) {
            new PopUp(
                "Błąd", 
                "Niepoprawny typ", 
                "Podaj nazwę nowego typu");
        } else {
            String response = salesmanService.addType(newType);
            if (response.startsWith("Dodano")) {
                new PopUp(
                    "Sukces", 
                    "Dodano nowy typ: " + newType + " do bazy", 
                    null);
            } else {
                new PopUp(
                    "Błąd", 
                    "Taki typ jest już w bazie", 
                    null);
            }
        }

    }

    @FXML
    void onTypeConfirm(ActionEvent event) {

    }

    public void initialize() {
        ObservableList<String> categories = FXCollections.observableArrayList();
        categories.addAll(Arrays.asList(
                "mężczyzna", "kobieta", "chłopiec", "dziewczynka"
        ));
        categoryComboBox.setItems(categories);

        ObservableList<String> colors = generalService.getAllColors();
        colorComboBox.setItems(colors);

        ObservableList<String> types = FXCollections.observableArrayList(generalService.getAllTypes());
        typeComboBox.setItems(types);
    }

    @Override
    public void refresh() {

    }
}

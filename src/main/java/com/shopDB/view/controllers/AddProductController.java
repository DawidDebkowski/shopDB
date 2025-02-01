package com.shopDB.view.controllers;

import com.shopDB.Categories;
import com.shopDB.dto.ProductDTO;
import com.shopDB.repository.ProductColorRepository;
import com.shopDB.repository.ProductTypeRepository;
import com.shopDB.service.GeneralService;
import com.shopDB.service.SalesmanService;
import com.shopDB.view.App;
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

    @Autowired
    private ProductTypeRepository productTypeRepository;

    @Autowired
    private ProductColorRepository productColorRepository;

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
        String name = colorNameField.getText();
        String code = hexColorField.getText();

        if (name.equals("") || code.equals("")) {
            new PopUp("Błąd", "Niepoprawne dane koloru.", "Pola nazwa i kod nie mogą być puste.");
        } else {
            String response = salesmanService.addColor(name, code);
            if (response.equals("Dodano nowy kolor.")) {
                new PopUp("Sukces", "Dodano nowy kolor.", "Kolor " + name + " o kodzie " + code + " został dodany do bazy.");
            } else {
                new PopUp("Błąd", "Problem przy dodawaniu koloru do bazy", response);
            }
        }
    }

    @FXML
    void onSaveProductClicked(ActionEvent event) {
        Double price = null;
        try {
            price = Double.parseDouble(emailField.getText());
        } catch(NumberFormatException e) {
            new PopUp(
                "Błąd", 
                "Niepoprawna cena.", 
                "Cena musi być liczbą.");
        }

        Integer discount = null;
        try {
            discount = phoneField.getText().equals("") ? 0 : Integer.parseInt(phoneField.getText());
        } catch (NumberFormatException e) {
            new PopUp(
                "Błąd", 
                "Niepoprawna cena.", 
                "Cena musi być liczbą całkowitą.");
        }

        ProductDTO product = App.lastChosenProduct;
        String productResponse;
        String priceResponse;
        String discountResponse;

        if (product == null) {
            productResponse = salesmanService.addProduct(
                nameField.getText(),
                Categories.translate(categoryComboBox.getValue()), 
                productTypeRepository.getIdFromName(typeComboBox.getValue()), 
                productColorRepository.getIdFromName(colorComboBox.getValue()), 
                price);
            priceResponse = "";
            if (productResponse.equals("Dodano nowy produkt.")) {
                discountResponse = salesmanService.changeDiscount(
                    generalService.getProductId(
                        nameField.getText(), 
                        categoryComboBox.getValue(), 
                        typeComboBox.getValue(), 
                        colorComboBox.getValue()), 
                    discount);
            } else {
                discountResponse = "";
            }
        } else {
            productResponse = salesmanService.editProduct(
                product.getProductId(),
                nameField.getText(),
                Categories.translate(categoryComboBox.getValue()), 
                productTypeRepository.getIdFromName(typeComboBox.getValue()), 
                productColorRepository.getIdFromName(colorComboBox.getValue()));
            priceResponse = salesmanService.changePrice(
                product.getProductId(), 
                price);
            discountResponse = salesmanService.changeDiscount(
                product.getProductId(), 
                discount);
        }

        if ((productResponse.equals("Dodano nowy produkt.") || productResponse.equals("Edytowano produkt.")) &&
            (priceResponse.equals("Zmieniono cene.") || priceResponse.equals("")) &&
            discountResponse.equals("Zmieniono znizke.")) {
                new PopUp(
                    "Sukces", 
                    "Produkt jest w bazie", 
                    null);
        } else {
            new PopUp(
                "Błąd", 
                "Wystąpił problem przy wykonywaniu tej operacji.", 
                productResponse + " + " + priceResponse + " + " + discountResponse);
        }
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

    @FXML
    void onPhotoAdd(ActionEvent event) {
        // dodawanie fotosa
    }

    @Override
    public void refresh() {
        categoryComboBox.selectFirst();
        typeComboBox.selectFirst();
        colorComboBox.selectFirst();

        ProductDTO product = App.lastChosenProduct;
        if (product != null) {
            nameField.setText(product.getName());
            emailField.setText(product.getPrice().toString());
            phoneField.setText(product.getDiscount().toString());

            while (!categoryComboBox.getValue().equals(Categories.translateToPolish(product.getCategory()))) {
                categoryComboBox.selectNext();
            }

            while (!typeComboBox.getValue().equals(product.getType())) {
                typeComboBox.selectNext();
            }

            while (!colorComboBox.getValue().equals(product.getColor())) {
                colorComboBox.selectNext();
            }
        }
    }
}

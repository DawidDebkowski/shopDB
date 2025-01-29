package com.shopDB.view.controllers;

import com.shopDB.SceneType;
import com.shopDB.dto.ProductDTO;
import com.shopDB.view.App;
import com.shopDB.view.SceneManager;
import com.shopDB.view.components.ProductCell;
import com.shopDB.view.components.SizeComboBox;
import io.github.palexdev.materialfx.controls.MFXButton;
import io.github.palexdev.mfxcore.controls.Label;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.geometry.Pos;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;
import javafx.scene.text.Font;
import org.springframework.stereotype.Controller;

@Controller
public class SingleProductSceneController implements SceneController{
    @FXML
    private MFXButton addButton;

    @FXML
    private BorderPane mainPane;

    @FXML
    private VBox productWrapper;

    private ImageView imageBox;
    private Label priceText;
    private Label titleText;
    private String chosenSize;
    private String amountLeft;

    private Label categoryField;
    private Label colorField;
    private Label discountField;

    private ProductDTO product;
    private Label amountLeftLabel;

    public void initialize() {

    }

    public void initProduct(ProductDTO product) {
        System.out.println("initProduct");
        // główny box
        this.product = product;
        HBox productBox = new HBox();
        productBox.setPrefWidth(600);
        productBox.setSpacing(25);
        productBox.setPrefWidth(600);

        // zdjęcie
        imageBox = new ImageView();
        imageBox.setFitHeight(450);
        imageBox.setFitWidth(400);
        imageBox.setImage(new Image(String.valueOf(ProductCell.class.getResource("/kurtkasuper1.png"))));

        VBox textBox = new VBox();
        textBox.setSpacing(20);

        // teksty
        titleText = new Label();
        priceText = new Label();
        titleText.setFont(new Font("Arial", 30));
        priceText.setFont(new Font("Arial", 24));

        MFXButton cartButton = new MFXButton("Dodaj do koszyka");
        cartButton.getStyleClass().add("main-button");
        cartButton.setFont(new Font("Arial", 25));
        cartButton.setAlignment(Pos.BOTTOM_CENTER);
        cartButton.setOnAction(this::onAddToCartClicked);

        HBox sizeBox = new HBox();
        sizeBox.setSpacing(20);

        SizeComboBox sizeComboBox = new SizeComboBox();
        sizeComboBox.setText("Rozmiar");
        sizeComboBox.setOnAction(event -> {
            chosenSize = sizeComboBox.getSelectionModel().getSelectedItem();

            //TODO wziac amountLeft z bazy danych
            amountLeft = "2";

            amountLeftLabel.setText("Pozostałe sztuki " + chosenSize + ": " + amountLeft);
        });

        amountLeftLabel = new Label();
        amountLeftLabel.setFont(new Font("Arial", 24));

        sizeBox.getChildren().addAll(sizeComboBox, amountLeftLabel);

        if("salesman".equals(App.userType)) {
            Label categoryField = new Label("Kategoria " + product.getCategory());
            Label colorField = new Label("Kolor " + product.getColor());
            Label discountField = new Label("Zniżka " + product.getDiscount().toString());
            textBox.getChildren().addAll(categoryField, colorField, discountField);
        }


        productBox.getChildren().addAll(imageBox, textBox);
        textBox.getChildren().addAll(titleText, priceText, sizeBox, cartButton);
        productWrapper.getChildren().add(productBox);
        updateTexts();
    }

    public void updateTexts() {
        priceText.setText(Double.toString(product.getPrice()));
        titleText.setText(product.getName());
    }

    @FXML
    void onAddToCartClicked(ActionEvent event) {
        SceneManager.getInstance().setScene(SceneType.MAIN_SHOP);
        // sprawdz czy ma rozmiar
        // i dodaj do koszyka jakos
        // moze zmien guzik na cos innego nwm
    }

    @Override
    public void refresh() {
//        App.lastChosenProduct = ProductDTO.getMockWithName("super mega kurtka", 199.99);
        initProduct(App.lastChosenProduct);
    }
}

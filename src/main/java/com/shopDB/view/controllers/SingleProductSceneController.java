package com.shopDB.view.controllers;

import com.shopDB.SceneType;
import com.shopDB.dto.ProductDTO;
import com.shopDB.view.App;
import com.shopDB.view.SceneManager;
import com.shopDB.view.components.ProductCell;
import io.github.palexdev.materialfx.controls.MFXButton;
import io.github.palexdev.mfxcore.controls.Label;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;
import javafx.scene.text.Font;
import org.springframework.stereotype.Controller;

import java.io.IOException;

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

    private ProductDTO product;

    public void initialize() {

    }

    public void initProduct(ProductDTO product) {
        VBox productBox = new VBox();
//        productBox.setPrefWidth(370);
//        productBox.setMaxWidth(370);
//        productBox.setSpacing(5);
//        productBox.setPrefWidth(370);
//        productBox.setMaxHeight(475);

        imageBox = new ImageView();
        priceText = new Label();
//        imageBox.setFitHeight(400);
//        imageBox.setFitWidth(370);

        titleText = new Label();
        imageBox.setImage(new Image(String.valueOf(ProductCell.class.getResource("/kurtkasuper1.png"))));
        HBox hbox = new HBox();
        productBox.getChildren().addAll(imageBox, hbox);
        hbox.getChildren().addAll(titleText, priceText);
        priceText.setFont(new Font("Arial", 18));
        titleText.setFont(new Font("Arial", 18));
        productWrapper.getChildren().add(productBox);
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
        App.lastChosenProduct = ProductDTO.getMockWithName("super mega kurtka", 199.99);
        initProduct(App.lastChosenProduct);
        updateTexts();
    }
}

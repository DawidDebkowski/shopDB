package com.shopDB.view.components;

import com.shopDB.dto.OrderDetailDTO;
import io.github.palexdev.mfxcore.controls.Label;
import javafx.geometry.Insets;
import javafx.geometry.Pos;
import javafx.scene.image.ImageView;
import javafx.scene.layout.*;
import javafx.scene.text.Font;

public class SingleOrder extends VBox {
    private String chosenSize;
    private ImageView imageBox;
    private final Label priceText;
    private final Label titleText;
    private final Label sizeText;
    private final Label amountText;
    private final Label priceForAllText;

    private OrderDetailDTO product;

    public SingleOrder(OrderDetailDTO product) {
        System.out.println("init SingleOrder");

        // główny box
        this.product = product;
        VBox productBox = new VBox();
        productBox.setSpacing(15);
        this.setAlignment(Pos.TOP_CENTER);

        HBox textBox = new HBox();
        textBox.setSpacing(40);
        this.setStyle("-fx-border-color: #0995A1; -fx-border-width: 2");
        this.setPadding(new Insets(8));

        // teksty
        titleText = new Label();
        priceText = new Label();
        sizeText = new Label();
        amountText = new Label();
        priceForAllText = new Label();

        titleText.setFont(new Font("Arial", 18));
        priceText.setFont(new Font("Arial", 18));
        sizeText.setFont(new Font("Arial", 18));
        amountText.setFont(new Font("Arial", 18));
        priceForAllText.setFont(new Font("Arial", 18));

        productBox.getChildren().addAll(textBox);
        textBox.getChildren().addAll(titleText, priceText, sizeText,amountText,priceForAllText);
        this.getChildren().addAll(productBox);
        updateTexts();
    }

    public void updateTexts() {
        titleText.setText("Nazwa: " + product.getName());
        priceText.setText("Cena: "+Double.toString(product.getPriceForOne()));
        sizeText.setText("Rozmiar: " + product.getSize());
        amountText.setText("Sztuki: " + Integer.toString(product.getAmount()));
        priceForAllText.setText("Za wszystkie: " + Double.toString(product.getPriceForOne()));
    }
}
package com.shopDB.view.components;
import com.shopDB.SceneType;
import com.shopDB.dto.OrderDetailDTO;
import com.shopDB.entities.Product;
import com.shopDB.view.App;
import com.shopDB.view.SceneManager;
import io.github.palexdev.materialfx.controls.MFXButton;
import io.github.palexdev.mfxcore.controls.Label;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.geometry.Pos;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.input.MouseEvent;
import javafx.scene.layout.*;
import javafx.scene.paint.Color;
import javafx.scene.text.Font;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Controller;

/**
 * To nie do końca jest komponent.
 * Aby go dodać jako dziecko trzeba posłużyć się productCellWrapper.
 */
public class SmallProduct extends VBox {
    private String chosenSize;
    private ImageView imageBox;
    private Label priceText;
    private Label titleText;
    private Label sizeText;
    private Label amountText;
    private Label priceForOneText;
    private Label priceForAllText;

    private OrderDetailDTO product;

    public SmallProduct(OrderDetailDTO product) {
        System.out.println("initProduct");
        // główny box
        this.product = product;
        VBox productBox = new VBox();
        productBox.setPrefWidth(3000);
        productBox.setSpacing(15);
        this.setPrefWidth(3000);

        this.getStyleClass().add("cart-item");
        productBox.getStyleClass().add("cart-item");

//        // zdjęcie
//        // zdjęcie
//        imageBox = new ImageView();
//        imageBox.setFitHeight(200);
//        imageBox.setFitWidth(180);
//        imageBox.setImage(new Image(String.valueOf(ProductCell.class.getResource("/kurtkasuper1.png"))));

        HBox textBox = new HBox();
        textBox.setSpacing(40);
        textBox.getStyleClass().add("cart-item");
        textBox.setPrefWidth(1000);

        // teksty
        titleText = new Label();
        priceText = new Label();
        sizeText = new Label();
        amountText = new Label();
        priceForOneText = new Label();
        priceForAllText = new Label();
        titleText.setFont(new Font("Arial", 21));
        priceText.setFont(new Font("Arial", 21));

        HBox buttonBox = new HBox();
        MFXButton removeButton = new MFXButton("Usuń z koszyka");
        removeButton.getStyleClass().add("white-button");
        removeButton.setFont(new Font("Arial", 18));
//        removeButton.setAlignment(Pos.CENTER_LEFT);
        removeButton.setOnAction(this::removeMeFromCart);
        buttonBox.getChildren().add(removeButton);
        buttonBox.setAlignment(Pos.CENTER_LEFT);
        buttonBox.setPrefWidth(1000);

        productBox.getChildren().addAll(textBox);
        textBox.getChildren().addAll(titleText, priceText, buttonBox);
        this.getChildren().addAll(productBox);
        updateTexts();
    }

    private void removeMeFromCart(ActionEvent actionEvent) {
        // usuwanie z koszyka
    }

    public void updateTexts() {
        titleText.setText(product.getName());
        priceText.setText(Double.toString(product.getPriceForOne()));
        sizeText.setText("Rozmiar: " + product.getSize());
        amountText.setText("Sztuki: " + Integer.toString(product.getAmount()));
        priceForAllText.setText("Za wszystkie: " + Double.toString(product.getPriceForOne()));
    }
}
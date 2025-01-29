package com.shopDB.view.components;
import com.shopDB.dto.ProductDTO;
import com.shopDB.entities.Product;
import io.github.palexdev.mfxcore.controls.Label;
import javafx.fxml.FXML;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.input.MouseEvent;
import javafx.scene.layout.VBox;
import javafx.scene.text.Font;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Controller;

/**
 * To nie do końca jest komponent.
 * Aby go dodać jako dziecko trzeba posłużyć się productCellWrapper.
 */
public class ProductCell extends VBox {
    private ImageView imageBox;
    private Label priceText;
    private Label titleText;

    private ProductDTO product;

    public ProductCell(ProductDTO product) {
        this.product = product;
        this.setPrefWidth(370);
        this.setMaxWidth(370);
        this.setSpacing(5);
        this.setPrefWidth(370);
        this.setHeight(475);
        this.setMaxHeight(475);
        imageBox = new ImageView();
        priceText = new Label();
        imageBox.setFitHeight(400);
        imageBox.setFitWidth(370);
        titleText = new Label();
        imageBox.setImage(new Image(String.valueOf(ProductCell.class.getResource("/kurtkasuper1.png"))));
        this.getChildren().addAll(imageBox, titleText, priceText);
        priceText.setFont(new Font("Arial", 18));
        titleText.setFont(new Font("Arial", 18));
    }

    public void updateTexts() {
        priceText.setText(Double.toString(product.getPrice()));
        titleText.setText(product.getName());
    }

    @FXML
    void onMouseClicked(MouseEvent event) {

    }

    @FXML
    void onMouseEnter(MouseEvent event) {
        this.setOpacity(0.5);
    }

    @FXML
    void onMouseExit(MouseEvent event) {
        this.setOpacity(1);
    }

}

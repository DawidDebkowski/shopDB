package com.shopDB.view.components;
import com.shopDB.dto.ProductDTO;
import com.shopDB.entities.Product;
import io.github.palexdev.mfxcore.controls.Label;
import javafx.fxml.FXML;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.input.MouseEvent;
import javafx.scene.layout.VBox;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Controller;

/**
 * To nie do końca jest komponent.
 * Aby go dodać jako dziecko trzeba posłużyć się productCellWrapper.
 */
public class ProductCell {
    @FXML
    private VBox productCellWrapper;

    public VBox getProductCellWrapper() {return productCellWrapper;}

    @FXML
    private ImageView imageBox;

    @FXML
    private Label priceText;

    @FXML
    private Label titleText;

    private ProductDTO product;

    public ProductCell(ProductDTO product) {
        this.product = product;
//        imageBox.setImage(new Image(ProductCell.class.getResource("kurtkasuper1.png").toString()));
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
        productCellWrapper.setOpacity(0.5);
    }

    @FXML
    void onMouseExit(MouseEvent event) {
        productCellWrapper.setOpacity(1);
    }

}

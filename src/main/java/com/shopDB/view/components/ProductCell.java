package com.shopDB.view.components;
import com.shopDB.SceneType;
import com.shopDB.dto.ProductDTO;
import com.shopDB.service.GeneralService;
import com.shopDB.view.App;
import com.shopDB.view.SceneManager;
import io.github.palexdev.mfxcore.controls.Label;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.input.MouseEvent;
import javafx.scene.layout.VBox;
import javafx.scene.text.Font;

import java.io.InputStream;

/**
 * To nie do końca jest komponent.
 * Aby go dodać jako dziecko trzeba posłużyć się productCellWrapper.
 */
public class ProductCell extends VBox {
    private ImageView imageBox;
    private Label priceText;
    private Label titleText;

    private ProductDTO product;

    public ProductCell(ProductDTO product, GeneralService generalService) {
        this.product = product;

        this.setPrefWidth(370);
        this.setMaxWidth(370);
        this.setSpacing(5);
        this.setPrefWidth(370);
        this.setHeight(475);
        this.setMaxHeight(475);

        imageBox = new ImageView();
        imageBox.setFitHeight(400);
        imageBox.setFitWidth(370);

        InputStream in = null;
        try {in = generalService.getPhotoFromProductId(product.getProductId()).getBinaryStream();} catch (Exception e) {System.out.println(e);}
        Image image = (in != null) ? new Image(in) : new Image(String.valueOf(ProductCell.class.getResource("/no-image.png")));
        imageBox.setImage(image);
        
        priceText = new Label();
        priceText.setFont(new Font("Arial", 18));
        
        titleText = new Label();
        titleText.setFont(new Font("Arial", 18));
        
        this.getChildren().addAll(imageBox, titleText, priceText);

        this.setOnMouseClicked(this::onMouseClicked);
        this.setOnMouseEntered(this::onMouseEnter);
        this.setOnMouseExited(this::onMouseExit);
    }

    public void updateTexts() {
        priceText.setText(Double.toString(product.getPrice()));
        titleText.setText(product.getName());
    }

    void onMouseClicked(MouseEvent event) {
        App.lastChosenProduct = product;
        SceneManager.getInstance().setScene(SceneType.SINGLE_PRODUCT);
    }

    void onMouseEnter(MouseEvent event) {
        imageBox.setScaleX(1.2);
        imageBox.setScaleY(1.2);
    }

    void onMouseExit(MouseEvent event) {
        imageBox.setScaleX(1.0);
        imageBox.setScaleY(1.0);
    }

}

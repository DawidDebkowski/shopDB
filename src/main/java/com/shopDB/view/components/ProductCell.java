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

import java.io.ByteArrayInputStream;
import java.text.DecimalFormat;

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

        Image in = new Image(new ByteArrayInputStream(generalService.getPhotoFromProductId(product.getProductId())));
        Image image = (in != null) ? in : new Image(String.valueOf(ProductCell.class.getResource("/no-image.png")));
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
        DecimalFormat decimalFormat = new DecimalFormat("####.##");
        String discount = (product.getDiscount() > 0) ? (" → " + decimalFormat.format(product.getPrice() * (100 - product.getDiscount()) / 100)) : ("");
        priceText.setText(Double.toString(product.getPrice()) + discount);
        titleText.setText(product.getName());
    }

    void onMouseClicked(MouseEvent event) {
        App.lastChosenProduct = product;

        switch (App.userType) {
            case "client":
                SceneManager.getInstance().setScene(SceneType.SINGLE_PRODUCT);
                break;
            case "salesman":
                SceneManager.getInstance().setScene(SceneType.ADD_PRODUCT);
                break;
            case "warehouse":
                SceneManager.getInstance().setScene(SceneType.ADD_WAREHOUSE);
                break;
        }
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

package com.shopDB.view.components;

import com.shopDB.dto.OrderDetailDTO;
import com.shopDB.repository.ProductRepository;
import com.shopDB.repository.WarehouseRepository;
import com.shopDB.service.ClientService;
import com.shopDB.service.UserService;
import com.shopDB.view.App;
import com.shopDB.view.controllers.*;

import io.github.palexdev.materialfx.controls.MFXButton;
import io.github.palexdev.mfxcore.controls.Label;
import javafx.event.ActionEvent;
import javafx.geometry.Insets;
import javafx.geometry.Pos;
import javafx.scene.image.ImageView;
import javafx.scene.layout.*;
import javafx.scene.text.Font;

/**
 * To nie do końca jest komponent.
 * Aby go dodać jako dziecko trzeba posłużyć się productCellWrapper.
 */
public class SmallProduct extends VBox {
    private final UserService userService;
    private final ClientService clientService;
    private final WarehouseRepository warehouseRepository;
    private final ProductRepository productRepository;

    private String chosenSize;
    private ImageView imageBox;
    private Label priceText;
    private Label titleText;
    private Label sizeText;
    private Label amountText;
    private Label priceForOneText;
    private Label priceForAllText;

    private OrderDetailDTO product;
    
    private CartSceneController cartSceneController;

    public SmallProduct(OrderDetailDTO product, UserService userService, ClientService clientService, WarehouseRepository warehouseRepository, ProductRepository productRepository, CartSceneController cartSceneController) {
        this.cartSceneController = cartSceneController;

        // główny box
        this.product = product;
        VBox productBox = new VBox();
//        productBox.setPrefWidth(3000);
        productBox.setSpacing(15);
//        this.setPrefWidth(3000);
        this.setAlignment(Pos.CENTER);

//        this.getStyleClass().add("cart-item");
//        productBox.getStyleClass().add("cart-item");

//        // zdjęcie
//        // zdjęcie
//        imageBox = new ImageView();
//        imageBox.setFitHeight(200);
//        imageBox.setFitWidth(180);
//        imageBox.setImage(new Image(String.valueOf(ProductCell.class.getResource("/kurtkasuper1.png"))));

        HBox textBox = new HBox();
        textBox.setSpacing(40);
//        textBox.getStyleClass().add("cart-item");
        System.out.println(textBox.getStyleClass());
        this.setStyle("-fx-border-color: #0995A1; -fx-border-width: 2");
        this.setPadding(new Insets(8));
//        textBox.setPrefWidth(1000);
        textBox.setAlignment(Pos.CENTER);

        // teksty
        titleText = new Label();
        priceText = new Label();
        sizeText = new Label();
        amountText = new Label();
        priceForOneText = new Label();
        priceForAllText = new Label();
        titleText.setFont(new Font("Arial", 18));
        priceText.setFont(new Font("Arial", 18));
        sizeText.setFont(new Font("Arial", 18));
        amountText.setFont(new Font("Arial", 18));
        priceForAllText.setFont(new Font("Arial", 18));

        MFXButton removeButton = new MFXButton("Usuń z koszyka");
        removeButton.getStyleClass().add("secondary-button");
        removeButton.setFont(new Font("Arial", 18));
        removeButton.setAlignment(Pos.CENTER_LEFT);
        removeButton.setOnAction(this::removeMeFromCart);

        productBox.getChildren().addAll(textBox);
        textBox.getChildren().addAll(titleText, priceText, sizeText,amountText,priceForAllText, removeButton);
        this.getChildren().addAll(productBox);
        updateTexts();
        this.userService = userService;
        this.clientService = clientService;
        this.warehouseRepository = warehouseRepository;
        this.productRepository = productRepository;
    }

    private void removeMeFromCart(ActionEvent actionEvent) {
        Integer clientId = clientService.getIdbyUser(userService.getbyId(App.userId));
        Integer warehouseId = warehouseRepository.getIdByData(productRepository.findById(product.getProductId()), product.getSize());
        Integer posId = clientService.getOrderPos(clientId, warehouseId);
        String response = clientService.removeOrderPos(clientId, posId);
        if (response.equals("Usunieto pozycje z koszyka.")) {
                cartSceneController.refresh();
        }
}

    public void updateTexts() {
        titleText.setText("Nazwa: "+product.getName());
        priceText.setText("Cena: "+Double.toString(product.getPriceForOne()));
        sizeText.setText("Rozmiar: " + product.getSize());
        amountText.setText("Sztuki: " + Integer.toString(product.getAmount()));
        priceForAllText.setText("Za wszystkie: " + Double.toString(product.getPriceForOne()));
    }
}
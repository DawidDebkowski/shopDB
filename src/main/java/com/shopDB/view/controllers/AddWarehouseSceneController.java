package com.shopDB.view.controllers;

import com.shopDB.dto.ProductDTO;
import com.shopDB.dto.ProductDetailDTO;
import com.shopDB.repository.ProductRepository;
import com.shopDB.repository.WarehouseRepository;
import com.shopDB.service.ClientService;
import com.shopDB.service.GeneralService;
import com.shopDB.service.UserService;
import com.shopDB.service.WarehouseService;
import com.shopDB.view.App;
import com.shopDB.view.components.PopUp;
import com.shopDB.view.components.ProductCell;
import io.github.palexdev.materialfx.controls.MFXButton;
import io.github.palexdev.materialfx.controls.MFXComboBox;
import io.github.palexdev.materialfx.controls.MFXTextField;
import io.github.palexdev.mfxcore.controls.Label;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.geometry.Pos;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;
import javafx.scene.text.Font;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.io.InputStream;
import java.text.DecimalFormat;

@Controller
public class AddWarehouseSceneController implements SceneController {
    @FXML
    private MFXButton addButton;

    @FXML
    private BorderPane mainPane;

    @FXML
    private VBox productWrapper;

    @Autowired
    private GeneralService generalService;

    @Autowired
    private ClientService clientService;

    @Autowired
    private UserService userService;

    @Autowired
    private WarehouseService warehouseService;

    @Autowired
    private WarehouseRepository warehouseRepository;

    @Autowired
    private ProductRepository productRepository;

    private ImageView imageBox;
    private Label priceText;
    private Label titleText;
    private String chosenSize;
    private String amountLeft;

    private ProductDTO product;
    private Integer productId;
    private Label amountLeftLabel;
    private MFXComboBox<String> sizeComboBox;

    private ObservableList<ProductDetailDTO> available;
    private ObservableList<String> sizes;
    private MFXTextField addField;

    public void initialize() {

    }

    public void initProduct(ProductDTO product) {
        productId = generalService.getProductId(product.getName(), product.getCategory(), product.getType(), product.getColor());
        chosenSize = null;

        System.out.println("initProductWarehouse, productId: " + productId);
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

        InputStream in = null;
        try {in = generalService.getPhotoFromProductId(productId).getBinaryStream();} catch (Exception e) {}
        Image image = (in != null) ? new Image(in) : new Image(String.valueOf(ProductCell.class.getResource("/no-image.png")));
        imageBox.setImage(image);

        VBox textBox = new VBox();
        textBox.setSpacing(20);

        // teksty
        titleText = new Label();
        priceText = new Label();
        titleText.setFont(new Font("Arial", 30));
        priceText.setFont(new Font("Arial", 24));

        MFXButton addButton = new MFXButton("Dodaj rozmiar");
        addButton.getStyleClass().add("main-button");
        addButton.setFont(new Font("Arial", 25));
        addButton.setAlignment(Pos.BOTTOM_CENTER);
        addButton.setOnAction(this::onAddButtonClicked);

        addField = new MFXTextField();
        addField.setFloatingText("Ilość");
        addField.setFont(new Font("Arial", 21));

        HBox sizeBox = new HBox();
        sizeBox.setSpacing(20);

        sizeComboBox = new MFXComboBox<String>();
        ObservableList<String> sizes = FXCollections.observableArrayList();
        sizes.add("XS");
        sizes.add("S");
        sizes.add("M");
        sizes.add("L");
        sizes.add("XL");
        sizeComboBox.setItems(sizes);

        available = FXCollections.observableArrayList(generalService.showProductDetails(productId));
        sizeComboBox.setOnAction(event -> {
            chosenSize = sizeComboBox.getSelectionModel().getSelectedItem();

            boolean ok = false;
            for (ProductDetailDTO warehouse : available) {
                if (warehouse.getSize().equals(chosenSize)) {
                    amountLeft = ((Integer) warehouse.getAvailable()).toString();
                    amountLeftLabel.setText("Pozostałe sztuki " + chosenSize + ": " + amountLeft);
                    ok = true;
                }
            }
            if(!ok) {
                amountLeft = "0";
                amountLeftLabel.setText("Pozostałe sztuki " + chosenSize + ": 0");
            }
        });

        amountLeftLabel = new Label();
        amountLeftLabel.setFont(new Font("Arial", 24));

        sizeBox.getChildren().addAll(sizeComboBox, amountLeftLabel);

        productBox.getChildren().addAll(imageBox, textBox);
        textBox.getChildren().addAll(titleText, priceText, sizeBox, addField, addButton);
        productWrapper.getChildren().add(productBox);
        updateTexts();
    }

    public void updateTexts() {
        DecimalFormat decimalFormat = new DecimalFormat("####.##");
        String discount = (product.getDiscount() > 0) ? (" → " + decimalFormat.format(product.getPrice() * (100 - product.getDiscount()) / 100)) : ("");
        priceText.setText(Double.toString(product.getPrice()) + discount);
        titleText.setText(product.getName());
    }

    @FXML
    void onAddButtonClicked(ActionEvent event) {
        int delta = 0;
        try {
            delta = Integer.parseInt(addField.getText());
            if (chosenSize == null || chosenSize.equals("")) {
                new PopUp("Błąd", "rozmiar", "musi być wybrany");
            } else if (delta < 0) {
                Integer warehouseId = generalService.getWarehouseId(productId, chosenSize);
                if (warehouseId == null) {
                    System.out.println("Nie da się dodać ujemnej ilości dla produktu, którego nie było nigdy w bazie.");
                } else {
                    String response = warehouseService.editWarehouse(warehouseId, delta);
                    System.out.println(response);
                }
            } else {
                String response = warehouseService.addWarehouse(productId, chosenSize, delta);
                System.out.println(response);
            }
        } catch (NumberFormatException e) {
            new PopUp("Błąd", "wartość", "musi być liczba");
        }
    }

    @Override
    public void refresh() {
        initProduct(App.lastChosenProduct);
    }
}

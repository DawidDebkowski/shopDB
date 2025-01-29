package com.shopDB.view.controllers;

import com.shopDB.dto.ProductDTO;
import com.shopDB.view.components.ProductCell;
import io.github.palexdev.materialfx.controls.MFXScrollPane;
import javafx.fxml.FXML;
import javafx.geometry.Insets;
import javafx.scene.layout.GridPane;
import org.springframework.stereotype.Controller;

import java.util.Collection;

@Controller
public class ProductGridController {
    @FXML
    private MFXScrollPane mainScrollPane;

    @FXML
    private GridPane productGridPane;

    public static ProductGridController instance;

    public ProductGridController() {
        instance = this;
        System.out.println("ProductGridController created");
    }

    public void initialize() {
        System.out.println("ProductGridController initialized");
        instance = this;
    }

    public void showProducts(Collection<ProductDTO> products) {
        System.out.println("ProductGridController showProducts");
        productGridPane.getChildren().clear();
        int productsCount = products.size();

        productGridPane.setPadding(new Insets(5, 0, 0, 0));
        productGridPane.setMinHeight(productsCount/3 * 775);
        productGridPane.setVgap(200);

        while (productGridPane.getRowCount() < productsCount/3+1) {
            productGridPane.addRow(productGridPane.getRowCount()-1);
        }
        int i=0;
        for (ProductDTO product : products) {
            System.out.println("ProductGridController showProducts " + i + " i%3 " + i%3 + " " + i/3);
            ProductCell productCell = new ProductCell(product);
            productGridPane.add(productCell, i%3, i/3);
            productCell.updateTexts();
            i++;
        }
        System.out.println("ProductGridController showProducts ends");
    }
}
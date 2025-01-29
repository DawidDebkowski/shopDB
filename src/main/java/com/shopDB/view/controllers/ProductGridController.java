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
    }

    public void initialize() {
        instance = this;
    }

    public void showProducts(Collection<ProductDTO> products) {
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
            ProductCell productCell = new ProductCell(product);
            productGridPane.add(productCell, i%3, i/3);
            productCell.updateTexts();
            i++;
        }
    }
}
package com.shopDB.view.controllers;

import com.shopDB.dto.ProductDTO;
import com.shopDB.service.GeneralService;
import com.shopDB.view.components.ProductCell;
import io.github.palexdev.materialfx.controls.MFXScrollPane;
import javafx.fxml.FXML;
import javafx.geometry.Insets;
import javafx.geometry.VPos;
import javafx.scene.layout.GridPane;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.Collection;

@Controller
public class ProductGridController {
    @FXML
    private MFXScrollPane mainScrollPane;

    @FXML
    private GridPane productGridPane;

    @Autowired
    private GeneralService generalService;

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
        System.out.println(productsCount);
        
        productGridPane.setPadding(new Insets(5, 0, 0, 0));
        // productGridPane.setMinHeight((productsCount/3 + ((productsCount%3==0) ? 0 : 1)) * 550);
        // productGridPane.setMaxHeight((productsCount/3 + ((productsCount%3==0) ? 0 : 1)) * 550);
        productGridPane.setVgap(25);

        for (int i = 0; i < productsCount; i += 3) {
            productGridPane.addRow(i/3);
            try {
                productGridPane.getRowConstraints().get(i/3).setMinHeight(500);
                productGridPane.getRowConstraints().get(i/3).setMaxHeight(500);
                productGridPane.getRowConstraints().get(i/3).setValignment(VPos.TOP);
            } catch (Exception e) {}
        }

        int i=0;
        for (ProductDTO product : products) {
            ProductCell productCell = new ProductCell(product, generalService);
            productGridPane.add(productCell, i%3, i/3);
            productCell.updateTexts();
            i++;
        }
    }
}
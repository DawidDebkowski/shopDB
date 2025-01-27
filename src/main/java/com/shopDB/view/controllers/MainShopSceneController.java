package com.shopDB.view.controllers;

import org.springframework.stereotype.Controller;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.VBox;

@Controller

public class MainShopSceneController implements SceneController {

    @FXML
    private BorderPane mainPane;

    @FXML
    private VBox typesWrapper;

    private String selectedType;
    private String selectedCategory;
    private String selectedColor;
    private int sortingMethod;
    private int minPrice;
    private int maxPrice;

    void initialize() {

    }

    @FXML
    void displaySortMethods(ActionEvent event) {
        // sortuj combo box
    }
}
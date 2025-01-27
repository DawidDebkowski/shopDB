package com.shopDB.view.controllers;

import com.shopDB.view.components.SelectTypeLabel;
import org.springframework.stereotype.Controller;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.VBox;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.List;

@Controller
public class MainShopSceneController implements SceneController {
    @FXML
    private VBox typesWrapper;

    private Collection<SelectTypeLabel> selectTypeLabels;
    private String selectedType;
    private String selectedCategory;
    private String selectedColor;
    private int sortingMethod;
    private int minPrice;
    private int maxPrice;

    public void initialize() {


        // przykładowa lista z bazy
        List<String> types = Arrays.asList("spodnie", "koszulka", "bluza", "sukienka");
        setupTypeLabels(types);
    }

    /**
     * Wyświetlenie i
     * Logika wybierania, tylko 1 możliwe na raz
     * Utworzenie wszystkich wymaganych label
     */
    private void setupTypeLabels(List<String> types) {
        selectTypeLabels = new ArrayList<>();
        for (String type : types) {
            SelectTypeLabel label = new SelectTypeLabel(type);
            selectTypeLabels.add(label);
            typesWrapper.getChildren().add(label);
        }

        for (SelectTypeLabel selectTypeLabel : selectTypeLabels) {
            selectTypeLabel.setOnMouseClicked(event -> {
                System.out.println("Clicked on type: " + selectTypeLabel.getText());
                selectedType = selectTypeLabel.getType();
                for (SelectTypeLabel otherSelectTypeLabel : selectTypeLabels) {
                    otherSelectTypeLabel.select(false);
                }
                selectTypeLabel.select(true);
            });
        }
    }

    @FXML
    void displaySortMethods(ActionEvent event) {
        // sortuj combo box
    }
}
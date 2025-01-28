package com.shopDB.view.controllers;

import com.shopDB.dto.ProductDTO;
import com.shopDB.entities.Product;
import com.shopDB.view.components.SelectLabel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.layout.VBox;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.List;
import java.util.function.Function;

@Controller
public class MainShopSceneController implements SceneController {
    @FXML
    private VBox typesWrapper;

    @FXML
    private VBox categoriesWrapper;

    private Collection<SelectLabel> selectTypeLabels;
    private Collection<SelectLabel> selectCategoryLabels;
    private String selectedType;
    private String selectedCategory;
    private String selectedColor;
    private int sortingMethod;
    private int minPrice;
    private int maxPrice;

    private ProductGridController productGridController;

    @Autowired
    public MainShopSceneController(ProductGridController productGridController) {
        this.productGridController = productGridController;
    }

    public void initialize() {


        // przykładowa lista z bazy
        List<String> types = Arrays.asList("spodnie", "koszulka", "bluza", "sukienka");
        selectTypeLabels = setupSelectLabels(types, this::setSelectedType);
        selectCategoryLabels = setupSelectLabels(Arrays.asList("mężczyzna", "kobieta", "dziecko"), this::setSelectedCategory);
        displayLabels(selectTypeLabels, typesWrapper);
        displayLabels(selectCategoryLabels, categoriesWrapper);
    }

    /**
     * Wyświetlenie i
     * Logika wybierania, tylko 1 możliwe na raz
     * Utworzenie wszystkich wymaganych label
     */
    private List<SelectLabel> setupSelectLabels(List<String> values, Function<String, Void> valueSetter) {
        List<SelectLabel> selectLabels = new ArrayList<>();
        for (String value : values) {
            SelectLabel label = new SelectLabel(value);
            selectLabels.add(label);
        }

        for (SelectLabel selectLabel : selectLabels) {
            selectLabel.setOnMouseClicked(event -> {
                System.out.println("Clicked on value: " + selectLabel.getText());
                valueSetter.apply(selectLabel.getText());
                for (SelectLabel other : selectLabels) {
                    other.select(false);
                }
                selectLabel.select(true);
            });
        }
        return selectLabels;
    }

    private void displayLabels(Collection<SelectLabel> labels, VBox root) {
        for (SelectLabel label : labels) {
            root.getChildren().add(label);
        }
    }

    public Void setSelectedType(String selectedType) {
        this.selectedType = selectedType;
        return null;
    }
    public Void setSelectedCategory(String selectedCategory) {
        this.selectedCategory = selectedCategory;
        return null;
    }

    @FXML
    void displaySortMethods(ActionEvent event) {
        // sortuj combo box
    }
}
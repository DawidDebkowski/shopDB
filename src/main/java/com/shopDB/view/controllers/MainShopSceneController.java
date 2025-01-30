package com.shopDB.view.controllers;

import com.shopDB.dto.ProductDTO;
import com.shopDB.service.GeneralService;
import com.shopDB.view.components.SelectLabel;
import io.github.palexdev.materialfx.controls.MFXComboBox;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.scene.layout.BorderPane;
import javafx.util.Pair;

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
    private BorderPane mainPane;

    @FXML
    private VBox typesWrapper;

    @FXML
    private VBox categoriesWrapper;

    @FXML
    private MFXComboBox<String> colorComboBox;

    @FXML
    private MFXComboBox<MyPair<Double, Double>> priceComboBox;

    @FXML
    private MFXComboBox<String> sizeComboBox;

    @FXML
    private MFXComboBox<Pair<String, Integer>> sortComboBox;

    @Autowired
    private GeneralService generalService;

    private Collection<SelectLabel> selectTypeLabels;
    private Collection<SelectLabel> selectCategoryLabels;
    private String selectedType = null;
    private String selectedCategory = null;
    private String selectedSize = null;
    private String selectedColor = null;
    private int sortingMethod = 0;
    private Double minPrice = null;
    private Double maxPrice = null;

    private ProductGridController productGridController;

    /**
     * Klasa do ładnego wyświetlania tych (głupich) combo boxów
     * @param <T>
     * @param <R>
     */
    class MyPair<T, R> extends Pair<T, R> {
        String display;

        public MyPair(T key, R value, String display) {
            super(key, value);
            this.display = display;
        }

        @Override
        public String toString() {
            if(display == null) display = getKey().toString();
            return display;
        }
    }

    public void initialize() {
        //filtr kategorii
        selectCategoryLabels = setupSelectLabels(Arrays.asList("mężczyzna", "kobieta", "chłopiec", "dziewczynka"), this::setSelectedCategory);
        displayLabels(selectCategoryLabels, categoriesWrapper);

        // filtr typow
        List<String> types = generalService.getAllTypes();
        selectTypeLabels = setupSelectLabels(types, this::setSelectedType);
        displayLabels(selectTypeLabels, typesWrapper);

        // sortowanie
        ObservableList<Pair<String, Integer>> sortMethods = FXCollections.observableArrayList();
        sortMethods.add(new MyPair<String,Integer>("Od najstarszego", 0,null));
        sortMethods.add(new MyPair<String,Integer>("Od najnowszego", 1,null));
        sortMethods.add(new MyPair<String,Integer>("Cena malejąco", 2, null));
        sortMethods.add(new MyPair<String,Integer>("Cena rosnąco", 3, null));
        sortMethods.add(new MyPair<String,Integer>("Nazwa alfabetycznie", 4, null));
        sortComboBox.setItems(sortMethods);

        // filtr rozmiarow
        ObservableList<String> sizes = FXCollections.observableArrayList();
        sizes.add("XS");
        sizes.add("S");
        sizes.add("M");
        sizes.add("L");
        sizes.add("XL");
        sizeComboBox.setItems(sizes);

        // filtr kolorow
        ObservableList<String> colors = generalService.getAllColors();
        colorComboBox.setItems(colors);

        // filtr cenowy
        ObservableList<MyPair<Double, Double>> prices = FXCollections.observableArrayList();
        prices.add(new MyPair<Double, Double>(null, 25., "< 25 PLN"));
        prices.add(new MyPair<Double, Double>(null, 50., "< 50 PLN"));
        prices.add(new MyPair<Double, Double>(null, 75., "< 75 PLN"));
        prices.add(new MyPair<Double, Double>(null, 100., "< 100 PLN"));
        priceComboBox.setItems(prices);
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
        this.selectedType = selectedType.equals("") ? null : selectedType;
        return null;
    }
    public Void setSelectedCategory(String selectedCategory) {
        this.selectedCategory = selectedCategory.equals("") ? null : selectedCategory;
        return null;
    }

    @FXML
    void displaySortMethods(ActionEvent event) {
        sortingMethod = sortComboBox.getSelectionModel().getSelectedItem().getValue();
        showProducts();
    }

    @FXML
    void onColorConfirm(ActionEvent event) {
        selectedColor = colorComboBox.getSelectionModel().getSelectedItem();
        showProducts();
    }

    @FXML
    void onPriceConfirm(ActionEvent event) {
        MyPair<Double, Double> p = priceComboBox.getSelectionModel().getSelectedItem();
        minPrice = p.getKey();
        maxPrice = p.getValue();
        System.out.println("Min price: " + minPrice + " Max price: " + maxPrice);
        showProducts();
    }

    @FXML
    void onSizeConfirm(ActionEvent event) {
        selectedSize = sizeComboBox.getSelectionModel().getSelectedItem();
        showProducts();
    }

    @Override
    public void refresh() {
        // List<ProductDTO> list = generalService.showProducts(null, null, null, null, null, 0);

        productGridController = ProductGridController.instance;
        // productGridController.showProducts(list);
        showProducts();
    }

    public void showProducts() {
        List<ProductDTO> list = generalService.showProducts(selectedCategory, selectedType, selectedColor, minPrice, maxPrice, sortingMethod);
        productGridController.showProducts(list);
    }
}
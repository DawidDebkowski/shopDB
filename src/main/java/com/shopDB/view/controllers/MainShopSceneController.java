package com.shopDB.view.controllers;

import com.shopDB.dto.ProductDTO;
import com.shopDB.view.components.SelectLabel;
import io.github.palexdev.materialfx.controls.MFXComboBox;
import jakarta.persistence.criteria.CriteriaBuilder;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.fxml.FXMLLoader;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.HBox;
import javafx.util.Pair;
import org.springframework.stereotype.Controller;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.layout.VBox;

import java.io.IOException;
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
    private MFXComboBox<MyPair<Integer, Integer>> priceComboBox;

    @FXML
    private MFXComboBox<String> sizeComboBox;

    @FXML
    private MFXComboBox<Pair<String, Integer>> sortComboBox;

    private Collection<SelectLabel> selectTypeLabels;
    private Collection<SelectLabel> selectCategoryLabels;
    private String selectedType;
    private String selectedCategory;
    private String selectedSize;
    private String selectedColor;
    private int sortingMethod;
    private int minPrice;
    private int maxPrice;

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
        // pobrac produkty z bazy i wrzucic w refresh
        // potem uzywac refresh i wartosci na gorze do wziecia produktów

        // przykładowa lista z bazy
        List<String> types = Arrays.asList("spodnie", "koszulka", "bluza", "sukienka");
        selectTypeLabels = setupSelectLabels(types, this::setSelectedType);
        selectCategoryLabels = setupSelectLabels(Arrays.asList("mężczyzna", "kobieta", "chłopiec", "dziewczynka"), this::setSelectedCategory);
        displayLabels(selectTypeLabels, typesWrapper);
        displayLabels(selectCategoryLabels, categoriesWrapper);

        ObservableList<Pair<String, Integer>> sortMethods = FXCollections.observableArrayList();
        sortMethods.add(new MyPair<String,Integer>("Brak", 1,null));
        sortMethods.add(new MyPair<String,Integer>("Cena malejąco", 2, null));
        sortMethods.add(new MyPair<String,Integer>("Cena rosnąco", 3, null));
        sortMethods.add(new MyPair<String,Integer>("Nazwa", 4, null));
        sortComboBox.setItems(sortMethods);

        ObservableList<String> sizes = FXCollections.observableArrayList();
        sizes.add("XS");
        sizes.add("S");
        sizes.add("M");
        sizes.add("L");
        sizes.add("XL");
        sizeComboBox.setItems(sizes);

        // TODO: wziąć z bazy danych
        ObservableList<String> colors = FXCollections.observableArrayList();
        colors.add("Czerwony");
        colors.add("Niebieski");
        colorComboBox.setItems(colors);

        ObservableList<MyPair<Integer, Integer>> prices = FXCollections.observableArrayList();
        prices.add(new MyPair<Integer, Integer>(0, 25, "0 - 25"));
        prices.add(new MyPair<Integer, Integer>(0, 50, "0 - 50"));
        prices.add(new MyPair<Integer, Integer>(25, 75, "25 - 75"));
        prices.add(new MyPair<Integer, Integer>(100, 1000, "<100"));
        prices.add(new MyPair<Integer, Integer>(50, 1000, ">50"));
        prices.add(new MyPair<Integer, Integer>(75, 1000, ">75"));
        prices.add(new MyPair<Integer, Integer>(100, 1000, ">100"));

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
        this.selectedType = selectedType;
        return null;
    }
    public Void setSelectedCategory(String selectedCategory) {
        this.selectedCategory = selectedCategory;
        return null;
    }

    @FXML
    void displaySortMethods(ActionEvent event) {
        sortingMethod = sortComboBox.getSelectionModel().getSelectedItem().getValue();
    }

    @FXML
    void onColorConfirm(ActionEvent event) {
        selectedColor = colorComboBox.getSelectionModel().getSelectedItem();
    }

    @FXML
    void onPriceConfirm(ActionEvent event) {
        Pair<Integer, Integer> p = priceComboBox.getSelectionModel().getSelectedItem();
        minPrice = p.getKey();
        maxPrice = p.getValue();
        System.out.println("Min price: " + minPrice + " Max price: " + maxPrice);
    }

    @FXML
    void onSizeConfirm(ActionEvent event) {
        selectedSize = sizeComboBox.getSelectionModel().getSelectedItem();
    }

    @Override
    public void refresh() {
        Collection<ProductDTO> products = Arrays.asList(
                ProductDTO.getMockWithName("kurtka super", 9.99),
                ProductDTO.getMockWithName("mniej super kurtka", 19.99),
                ProductDTO.getMockWithName("kurtka super", 9.99),
                ProductDTO.getMockWithName("mniej super kurtka", 19.99),
                ProductDTO.getMockWithName("kurtka super", 9.99),
                ProductDTO.getMockWithName("mniej super kurtka", 19.99),
                ProductDTO.getMockWithName("kurtka super", 9.99),
                ProductDTO.getMockWithName("mniej super kurtka", 19.99));

        System.out.println("refresh");

        productGridController = ProductGridController.instance;
        productGridController.showProducts(products);
    }
}
package com.shopDB.view.components;

import io.github.palexdev.materialfx.controls.MFXComboBox;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;

public class SizeComboBox extends MFXComboBox<String> {

    public SizeComboBox() {
        super();
        ObservableList<String> sizes = FXCollections.observableArrayList();
        sizes.add("XS");
        sizes.add("S");
        sizes.add("M");
        sizes.add("L");
        sizes.add("XL");
        this.setItems(sizes);
    }
}

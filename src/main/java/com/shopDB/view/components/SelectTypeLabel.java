package com.shopDB.view.components;

import io.github.palexdev.mfxcore.controls.Label;
import javafx.geometry.Insets;

public class SelectTypeLabel extends Label {
    private final String type;
    private boolean selected;

    public SelectTypeLabel(String type) {
        this.type = type;
        this.setText(type);
        selected = false;

        setOnMouseEntered(event -> {
            clickStyle(true);
//            System.out.println("Hover over " + getText());
        });
        setOnMouseExited(event -> {
            clickStyle(selected);
//            System.out.println("Hover over " + getText());
        });
    }

    public void select(boolean selected) {
        clickStyle(selected);
        this.selected = selected;
//        System.out.println(type + " selected: " + selected);
    }

    private void clickStyle(boolean selected) {
        this.setUnderline(selected);
    }

    public String getType() {
        return type;
    }
}

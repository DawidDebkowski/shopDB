package com.shopDB.view.components;

import com.shopDB.SceneType;
import com.shopDB.dto.ClientOrderDTO;
import com.shopDB.view.App;
import com.shopDB.view.SceneManager;
import io.github.palexdev.mfxcore.controls.Label;
import javafx.scene.input.MouseEvent;
import javafx.scene.layout.HBox;
import javafx.scene.text.Font;

public class SingleClientOrder extends HBox {
    ClientOrderDTO clientOrder;

    private final Label statusLabel;
    private final Label orderIdLabel;
    private final Label valueLabel;

    private final boolean warehouse;

    public SingleClientOrder(ClientOrderDTO clientOrder) {
        this.clientOrder = clientOrder;

        warehouse = "warehouse".equals(App.userType);

        statusLabel = new Label();
        orderIdLabel = new Label();
        valueLabel = new Label();

        statusLabel.setFont(new Font("Arial", 21));
        orderIdLabel.setFont(new Font("Arial", 21));
        valueLabel.setFont(new Font("Arial", 21));

        this.setOnMouseClicked(this::onMouseClicked);
        this.setOnMouseEntered(this::onMouseEnter);
        this.setOnMouseExited(this::onMouseExit);

        this.getChildren().addAll(orderIdLabel, statusLabel, valueLabel);
        this.setSpacing(20);
        updateTexts();
    }

    private void updateTexts() {
        if(warehouse) {
            orderIdLabel.setText("ID: " + clientOrder.getOrderId());
        }
        statusLabel.setText("Status: " + clientOrder.getStatus());
        valueLabel.setText("Wartość: " + clientOrder.getValue());
    }

    void onMouseClicked(MouseEvent event) {
        App.lastSelectedOrderId = clientOrder.getOrderId();
        SceneManager.getInstance().setScene(SceneType.SINGLE_ORDER);
    }

    void onMouseEnter(MouseEvent event) {
        this.setStyle("-fx-border-color: #0995A1; -fx-border-width: 2");
    }

    void onMouseExit(MouseEvent event) {
        this.setStyle("-fx-border-color: #0995A1; -fx-border-width: 0");
    }
}

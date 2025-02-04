package com.shopDB.view.components;

import com.shopDB.OrderStatus;
import com.shopDB.SceneType;
import com.shopDB.dto.ClientOrderDTO;
import com.shopDB.service.ClientService;
import com.shopDB.service.WarehouseService;
import com.shopDB.view.App;
import com.shopDB.view.SceneManager;
import io.github.palexdev.materialfx.controls.MFXButton;
import io.github.palexdev.mfxcore.controls.Label;
import javafx.event.ActionEvent;
import javafx.event.EventHandler;
import javafx.geometry.Pos;
import javafx.scene.input.MouseEvent;
import javafx.scene.layout.HBox;
import javafx.scene.text.Font;

public class SingleClientOrder extends HBox {
    private final HBox clickableTextBox;
    private final MFXButton mainButton;
    private final MFXButton secondaryButton;
    ClientOrderDTO clientOrder;

    private final Label statusLabel;
    private final Label orderIdLabel;
    private final Label valueLabel;

    private final boolean warehouse;
    private final OrderStatus orderStatus;

    private final WarehouseService warehouseService;
    private final ClientService clientService;

    public SingleClientOrder(ClientOrderDTO clientOrder, ClientService clientService, WarehouseService warehouseService) {
        this.clientOrder = clientOrder;
        this.warehouseService = warehouseService;
        this.clientService = clientService;
        orderStatus = OrderStatus.getOrderStatus(clientOrder.getStatus());

        warehouse = "warehouse".equals(App.userType);

        clickableTextBox = new HBox();

        statusLabel = new Label();
        orderIdLabel = new Label();
        valueLabel = new Label();

        statusLabel.setFont(new Font("Arial", 21));
        orderIdLabel.setFont(new Font("Arial", 21));
        valueLabel.setFont(new Font("Arial", 21));

        clickableTextBox.setSpacing(20);
        clickableTextBox.getChildren().addAll(statusLabel, orderIdLabel, valueLabel);
        clickableTextBox.setAlignment(Pos.CENTER_LEFT);

        mainButton = new MFXButton();
        secondaryButton = new MFXButton();
        mainButton.setFont(new Font("Arial", 18));
        secondaryButton.setFont(new Font("Arial", 18));
        mainButton.getStyleClass().add("main-button");
        secondaryButton.getStyleClass().add("cancel-button");
        setupCaseButtons();

        clickableTextBox.setOnMouseClicked(this::onMouseClicked);
        clickableTextBox.setOnMouseEntered(this::onMouseEnter);
        clickableTextBox.setOnMouseExited(this::onMouseExit);

        this.getChildren().addAll(clickableTextBox, mainButton, secondaryButton);
        this.setSpacing(20);
        updateTexts();
    }

    private void setupCaseButtons(){
        boolean showMainButton = true;
        boolean showSecButton = true;
        String mainText="";
        String secondaryText="";
        EventHandler<ActionEvent> handler = null;
        EventHandler<ActionEvent> secHandler = null;

        if(warehouse){
            if(orderStatus==OrderStatus.paid){
                mainText = "Oznacz jako kompletne";
                handler = this::completeButton;
                secondaryText = "Anuluj";
                secHandler = this::cancelButton;
            } else if(orderStatus==OrderStatus.return_reported){
                mainText = "Akceptuj";
                handler = this::acceptReturnButton;
                secondaryText = "Odrzuć";
                secHandler = this::denyReturnButton;
            } else {
                showMainButton = false;
                showSecButton = false;
            }
        }else{
            if(orderStatus==OrderStatus.placed){
                mainText = "Opłać";
                handler = this::payButton;
                secondaryText = "Anuluj";
                secHandler = this::cancelButton;
            } else if(orderStatus==OrderStatus.completed){
                mainText = "Zwróć";
                handler = this::askReturnButton;
                showSecButton = false;
            } else {
                showMainButton = false;
                showSecButton = false;
            }
        }
        mainButton.setText(mainText);
        mainButton.setOnAction(handler);
        secondaryButton.setText(secondaryText);
        secondaryButton.setOnAction(secHandler);

        mainButton.setDisable(!showMainButton);
        secondaryButton.setDisable(!showSecButton);
        mainButton.setVisible(showMainButton);
        secondaryButton.setVisible(showSecButton);
    }

    private void updateTexts() {
        if(warehouse) {
            orderIdLabel.setText("ID: " + clientOrder.getOrderId());
        } else {
            valueLabel.setText("Wartość: " + clientOrder.getValue());
        }
        statusLabel.setText("Status: " + orderStatus.polish);
    }

    void payButton(ActionEvent event) {
        String respone = clientService.payOrder(clientOrder.getOrderId());
        new PopUp("Udało się", "Status:", respone);
        SceneManager.getInstance().setScene(SceneType.ORDER_HISTORY);
    }

    void completeButton(ActionEvent event) {
        String respone = warehouseService.completeOrder(clientOrder.getOrderId());
        if(!"Zamowienie wykonane.".equals(respone)){
            new PopUp("Błąd", "Źle", respone);
        }
        new PopUp("Udało się", "Status:", respone);
        SceneManager.getInstance().setScene(SceneType.ORDER_HISTORY);
    }

    void cancelButton(ActionEvent event) {
        String respone = clientService.cancelOrder(clientOrder.getOrderId());
        new PopUp("Udało się", "Status:", respone);
        SceneManager.getInstance().setScene(SceneType.ORDER_HISTORY);
    }

    void askReturnButton(ActionEvent event) {
        String respone = clientService.reportReturn(clientOrder.getOrderId());
        if(!"Zgloszono zwrot.".equals(respone)){
            new PopUp("Błąd", "Źle", respone);
        }
        SceneManager.getInstance().setScene(SceneType.ORDER_HISTORY);
    }

    void acceptReturnButton(ActionEvent event) {
        String respone = warehouseService.considerReturn(clientOrder.getOrderId(), true);
        new PopUp("Udało się", "Status:", respone);
        SceneManager.getInstance().setScene(SceneType.ORDER_HISTORY);
    }

    void denyReturnButton(ActionEvent event) {
        String respone = warehouseService.considerReturn(clientOrder.getOrderId(), false);
        new PopUp("Udało się", "Status:", respone);
        SceneManager.getInstance().setScene(SceneType.ORDER_HISTORY);
    }

    void onMouseClicked(MouseEvent event) {
        App.lastSelectedOrderId = clientOrder.getOrderId();
        SceneManager.getInstance().setScene(SceneType.SINGLE_ORDER);
    }

    void onMouseEnter(MouseEvent event) {
        clickableTextBox.setStyle("-fx-border-color: #0995A1; -fx-border-width: 2");
    }

    void onMouseExit(MouseEvent event) {
        clickableTextBox.setStyle("-fx-border-color: #0995A1; -fx-border-width: 0");
    }
}

package com.shopDB.view.controllers;

import com.shopDB.dto.ClientOrderDTO;
import com.shopDB.service.ClientService;
import com.shopDB.service.GeneralService;
import com.shopDB.service.UserService;
import com.shopDB.view.App;
import com.shopDB.view.components.SingleClientOrder;
import io.github.palexdev.materialfx.controls.MFXComboBox;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.VBox;
import org.springframework.stereotype.Controller;

import java.util.List;

@Controller
public class OrderHistorySceneController implements SceneController {
    private final GeneralService generalService;
    private final ClientService clientService;
    private final UserService userService;
    private final boolean warehouse;

    private boolean paidFilter = true;
    @FXML
    private MFXComboBox<String> warehouseFilterCombo;

    @FXML
    private BorderPane mainPane;

    @FXML
    private VBox orderWrapper;

    public OrderHistorySceneController(GeneralService generalService, ClientService clientService, UserService userService) {
        this.generalService = generalService;
        this.clientService = clientService;
        this.userService = userService;
        warehouse = "warehouse".equals(App.userType);
    }


    public void initialize() {
        if(!warehouse) {
            warehouseFilterCombo.setMinHeight(0);
            warehouseFilterCombo.setPrefHeight(0);
            warehouseFilterCombo.setVisible(false);
        } else {
            ObservableList<String> filters = FXCollections.observableArrayList("Opłacone", "Prośba o zwrot");
            warehouseFilterCombo.setItems(filters);
            warehouseFilterCombo.getSelectionModel().selectFirst();
        }
    }

    @Override
    public void refresh() {
        List<ClientOrderDTO> clientOrderDTOs = null;
        if(warehouse) {
            if(paidFilter) {
                clientOrderDTOs = generalService.showPaidOrders();
            } else {
                clientOrderDTOs = generalService.showReportedReturns();
            }
        } else {
            clientOrderDTOs = generalService.showClientOrders(clientService.getIdbyUser(userService.getbyId(App.userId)));
        }

        displayOrders(clientOrderDTOs);
    }

    @FXML
    void onFilterChange(ActionEvent event) {
        paidFilter = warehouseFilterCombo.getSelectionModel().getSelectedItem().equals("Opłacone");
        refresh();
    }

    private void displayOrders(List<ClientOrderDTO> clientOrderDTOs) {
        System.out.println("clientOrderDTOs: " + clientOrderDTOs);
        for (ClientOrderDTO orderDetailDTO : clientOrderDTOs) {
            SingleClientOrder smallProduct = new SingleClientOrder(orderDetailDTO);
            orderWrapper.getChildren().add(smallProduct);
        }
    }

}

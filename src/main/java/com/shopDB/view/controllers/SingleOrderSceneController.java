package com.shopDB.view.controllers;

import com.shopDB.dto.OrderDetailDTO;
import com.shopDB.repository.ProductRepository;
import com.shopDB.repository.WarehouseRepository;
import com.shopDB.service.ClientService;
import com.shopDB.service.GeneralService;
import com.shopDB.service.UserService;
import com.shopDB.view.App;
import com.shopDB.view.components.PopUp;
import com.shopDB.view.components.SingleOrder;
import javafx.fxml.FXML;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.VBox;
import org.springframework.stereotype.Controller;

import java.util.List;

// możliwość zapłaty

@Controller
public class SingleOrderSceneController implements SceneController {
    @FXML
    private BorderPane mainPane;

    @FXML
    private VBox orderWrapper;

    private final GeneralService generalService;
    private final ClientService clientService;
    private final UserService userService;
    private final WarehouseRepository warehouseRepository;
    private final ProductRepository productRepository;

    public SingleOrderSceneController(GeneralService generalService, ClientService clientService, UserService userService, WarehouseRepository warehouseRepository, ProductRepository productRepository) {
        this.generalService = generalService;
        this.clientService = clientService;
        this.userService = userService;
        this.warehouseRepository = warehouseRepository;
        this.productRepository = productRepository;
    }

    public void initialize() {

    }

    @Override
    public void refresh() {
        if(App.lastSelectedOrderId == null) {
            new PopUp("Błąd", "Niepoprawny order", "Nigdy się nie powinno zdarzyć ale się zdarzyło. Proszę wyjść i wejść.");
            return;
        }
        List<OrderDetailDTO> orderDetailDTOS =
                generalService.showOrderDetails(App.lastSelectedOrderId);

        for (OrderDetailDTO orderDetailDTO : orderDetailDTOS) {
            SingleOrder singleOrder = new SingleOrder(orderDetailDTO);
            orderWrapper.getChildren().add(singleOrder);
        }
    }
}

package com.shopDB.view.controllers;

import com.shopDB.dto.ClientOrderDTO;
import com.shopDB.service.ClientService;
import com.shopDB.service.GeneralService;
import com.shopDB.service.UserService;
import com.shopDB.view.App;
import com.shopDB.view.components.SingleClientOrder;
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
    @FXML
    private BorderPane mainPane;

    @FXML
    private VBox orderWrapper;

    public OrderHistorySceneController(GeneralService generalService, ClientService clientService, UserService userService) {
        this.generalService = generalService;
        this.clientService = clientService;
        this.userService = userService;
    }


    public void initialize() {

    }

    @Override
    public void refresh() {
        List<ClientOrderDTO> clientOrderDTOs = generalService.showClientOrders(clientService.getIdbyUser(userService.getbyId(App.userId)));

        System.out.println("clientOrderDTOs: " + clientOrderDTOs);
        for (ClientOrderDTO orderDetailDTO : clientOrderDTOs) {
            SingleClientOrder smallProduct = new SingleClientOrder(orderDetailDTO);
            orderWrapper.getChildren().add(smallProduct);
        }
    }

}

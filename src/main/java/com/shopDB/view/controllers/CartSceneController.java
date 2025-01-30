package com.shopDB.view.controllers;

import com.shopDB.dto.OrderDetailDTO;
import com.shopDB.service.ClientService;
import com.shopDB.service.GeneralService;
import com.shopDB.service.UserService;
import com.shopDB.view.App;
import com.shopDB.view.components.SmallProduct;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.layout.VBox;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import java.util.List;

// lista produktów + usuwanie
// złóż zamówienie

@Controller
public class CartSceneController implements SceneController {
    @FXML
    private VBox cartWrapper;

    @Autowired
    private GeneralService generalService;

    @Autowired
    private ClientService clientService;

    @Autowired
    private UserService userService;

    public void initialize() {

    }

    @Override
    public void refresh() {
        List<OrderDetailDTO> orderDetailDTOS = 
            generalService.showOrderDetails(
                clientService.getCartId(
                    clientService.getIdbyUser(
                        userService.getbyId(
                            App.userId))));

        for (OrderDetailDTO orderDetailDTO : orderDetailDTOS) {
            SmallProduct smallProduct = new SmallProduct(orderDetailDTO);
            cartWrapper.getChildren().add(smallProduct);
        }
    }

    @FXML
    private void placeOrder(ActionEvent actionEvent) {
        // zplejsuj order

        //usuwanie  z   koszyka jest    w   Small   Product
    }
}

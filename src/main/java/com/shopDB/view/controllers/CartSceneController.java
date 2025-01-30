package com.shopDB.view.controllers;

import com.shopDB.dto.OrderDetailDTO;
import com.shopDB.view.components.SmallProduct;
import io.github.palexdev.materialfx.controls.MFXButton;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.geometry.Pos;
import javafx.scene.layout.VBox;
import javafx.scene.text.Font;
import org.springframework.stereotype.Controller;

import java.lang.reflect.Array;
import java.util.Arrays;
import java.util.List;

// lista produktów + usuwanie
// złóż zamówienie

@Controller
public class CartSceneController implements SceneController {
    @FXML
    private VBox cartWrapper;

    public void initialize() {

    }

    @Override
    public void refresh() {

        List<OrderDetailDTO> orderDetailDTOS = Arrays.asList(
                OrderDetailDTO.getMockWithName("mega kutka", 9.99),
                OrderDetailDTO.getMockWithName("taka se kutka", 18.00)
        );

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

package com.shopDB.view.controllers;

import com.shopDB.SceneType;
import com.shopDB.dto.OrderDetailDTO;
import com.shopDB.repository.ProductRepository;
import com.shopDB.repository.WarehouseRepository;
import com.shopDB.service.ClientService;
import com.shopDB.service.GeneralService;
import com.shopDB.service.UserService;
import com.shopDB.view.App;
import com.shopDB.view.SceneManager;
import com.shopDB.view.components.PopUp;
import com.shopDB.view.components.SmallProduct;

import javafx.collections.ObservableList;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.Node;
import javafx.scene.layout.VBox;

import org.springframework.stereotype.Controller;
import java.util.List;

// lista produktów + usuwanie
// złóż zamówienie

@Controller
public class CartSceneController implements SceneController {
    @FXML
    private VBox cartWrapper;

    private final GeneralService generalService;
    private final ClientService clientService;
    private final UserService userService;
    private final WarehouseRepository warehouseRepository;
    private final ProductRepository productRepository;

    public CartSceneController(GeneralService generalService, ClientService clientService, UserService userService, WarehouseRepository warehouseRepository, ProductRepository productRepository) {
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
        List<OrderDetailDTO> orderDetailDTOS = 
            generalService.showOrderDetails(
                clientService.getCartId(
                    clientService.getIdbyUser(
                        userService.getbyId(
                            App.userId))));

        ObservableList<Node> list = cartWrapper.getChildren();
        cartWrapper.getChildren().removeAll(list);

        for (OrderDetailDTO orderDetailDTO : orderDetailDTOS) {
            SmallProduct smallProduct = new SmallProduct(orderDetailDTO, userService, clientService, warehouseRepository, productRepository, this);
            cartWrapper.getChildren().add(smallProduct);
        }
    }

    @FXML
    private void placeOrder(ActionEvent actionEvent) {
        Integer clientId = clientService.getIdbyUser(userService.getbyId(App.userId));
        Boolean invoice = clientService.getTypeFromId(clientId).equals("company");
        String response = clientService.placeOrder(clientId, invoice);
        
        if (response.equals("Nie mozna zlozyc pustego zamowienia.")) {
            new PopUp(
                "Błąd", 
                "Nie można złożyć pustego zamówienia.", 
                null);
        }

        if (response.equals("Nie znamy wszystkich danych niezbednych do zlozenia zamowienia")) {
            new PopUp(
                "Błąd", 
                "Nie znamy wszystkich danych niezbędnych do złożenia zamówienia.", 
                "Uzupełnij dane i spróbuj ponownie.");
            SceneManager.getInstance().setScene(SceneType.CLIENT_DATA);
        }

        if (response.equals("Niektore pozycje z koszyka nie sa juz dostepne")) {
            new PopUp(
                "Błąd", 
                "Niektóre pozycje są niedostępne.",
                "Sprawdź dostępność produktów z koszyka i usuń niedostępne.");
        }

        if (response.equals("Zlozono zamowienie")) {
            new PopUp(
                "Sukces", 
                "Złożono zamówienie", 
                "Przejdź do zamówień i opłać swoje nowe zamówienie");
                SceneManager.getInstance().setScene(SceneType.MAIN_SHOP);
        }

        refresh();
    }
}

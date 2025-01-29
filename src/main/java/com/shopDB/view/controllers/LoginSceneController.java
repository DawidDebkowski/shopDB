package com.shopDB.view.controllers;

import com.shopDB.SceneType;
import com.shopDB.entities.Client;
import com.shopDB.service.ClientService;
import com.shopDB.service.UserService;
import com.shopDB.view.App;
import com.shopDB.view.SceneManager;
import io.github.palexdev.materialfx.controls.*;
import io.github.palexdev.mfxcore.controls.Label;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.Region;
import javafx.scene.layout.VBox;

import org.springframework.stereotype.Controller;

//@NamedStoredProcedureQuery(name = "Client.addClient", procedureName = "add_client", parameters = {
//        @StoredProcedureParameter(mode = ParameterMode.IN, name = "login", type = String.class),
//        @StoredProcedureParameter(mode = ParameterMode.IN, name = "password", type = String.class),
//        @StoredProcedureParameter(mode = ParameterMode.IN, name = "type", type = String.class),
//        @StoredProcedureParameter(mode = ParameterMode.IN, name = "email", type = String.class),
//        @StoredProcedureParameter(mode = ParameterMode.IN, name = "phone", type = String.class),
//        @StoredProcedureParameter(mode = ParameterMode.IN, name = "cookies", type = boolean.class),
//})
//public class Client {
//    public static final String INDIVIDUAL_TYPE = "individual";
//    public static final String COMPANY_TYPE = "company";

@Controller
public class LoginSceneController implements SceneController {
    private final ClientService clientService;
    private final UserService userService;
    private boolean loginState = true;

    private boolean cookies = false;
    private boolean rodo = false;
    private boolean terms = false;

    @FXML
    private MFXToggleButton companyToggle;

    @FXML
    private MFXCheckbox cookiesCheckbox;

    @FXML
    private MFXTextField emailField;

    @FXML
    private VBox fieldsBox1;

    @FXML
    private MFXButton forgotButton;

    @FXML
    private MFXButton loginButton;

    @FXML
    private MFXButton loginButton1;

    @FXML
    private MFXPasswordField loginPasswordField;

    @FXML
    private VBox loginStateBox;

    @FXML
    private MFXTextField loginUsernameField;

    @FXML
    private VBox loginWrapper;

    @FXML
    private BorderPane mainPane;

    @FXML
    private Label messageLabel;

    @FXML
    private Label messageLabel1;

    @FXML
    private MFXTextField nipField;

    @FXML
    private MFXTextField phoneField;

    @FXML
    private MFXButton registerButton;

    @FXML
    private MFXButton registerButton1;

    @FXML
    private MFXPasswordField registerPasswordField;

    @FXML
    private VBox registerStateBox;

    @FXML
    private MFXTextField registerUsernameField;

    @FXML
    private VBox registerWrapper;

    @FXML
    private MFXCheckbox rodoCheckbox;

    @FXML
    private MFXPasswordField secondPasswordField;

    @FXML
    private MFXCheckbox termsCheckbox;

    public LoginSceneController(ClientService clientService, UserService userService) {
        this.clientService = clientService;
        this.userService = userService;
    }

    public void initialize() {
        companyToggle.setOnAction(event -> {
            nipField.disableProperty().set(!companyToggle.isSelected());
        });
    }

    @FXML
    void onForgotButtonClicked(ActionEvent event) {
        System.out.println("to be added maybe");
    }

    @FXML
    void onLoginButtonClick(ActionEvent event) {
        if(loginState){
            String login, password;
            login = loginUsernameField.getText();
            password = loginPasswordField.getText();
            String accType = userService.authenticateUser(login, password);
            if(accType == null) {
                setMessage("Login failed");
            } else {
                setMessage("Login successful");
                SceneManager.getInstance().setScene(SceneType.MAIN_SHOP);
                App.userId = userService.getUserIdByLogin(login);
                App.userType = userService.getTypeIdByLogin(login);
            }
        } else {
            changeState(true );
        }
    }

    @FXML
    void onRegisterButtonClick(ActionEvent event) {
        if(!loginState){
            if(!rodo || !terms) {
                setMessage("Zaakceptuj regulamin i rodo.");
            } else {
                if(!registerPasswordField.getText().equals(secondPasswordField.getText())) {
                    setMessage("Hasła się nie zgadzają.");
                    return;
                }
                String response = addClientFromFields();
                if(response.startsWith("Dodano")) {
                    String login = registerUsernameField.getText();
                    App.userId = userService.getUserIdByLogin(login);
                    App.userType = userService.getTypeIdByLogin(login);

                    SceneManager.getInstance().setScene(SceneType.MAIN_SHOP);
                }
            }
        } else {
            changeState(false);
        }
    }

    /**
     * Próbuje dodać klienta na bazie pól z tekstem.
     */
    private String addClientFromFields() {
        String password = registerPasswordField.getText();
        String type = null;
        if(companyToggle.isSelected()) {
            type = Client.COMPANY_TYPE;
        } else {
            type = Client.INDIVIDUAL_TYPE;
        }
        System.out.println("PAS: " + password);
        String response = clientService.addClient(
                registerUsernameField.getText(),
                password,
                type,
                emailField.getText(),
                phoneField.getText(),
                nipField.getText(),
                cookies
        );
        setMessage(response);
        return response;
    }

    private void changeState(boolean newState) {
        loginState = newState;
        loginWrapper.setVisible(loginState);
        registerWrapper.setVisible(!loginState);
        if(loginState){
            loginWrapper.setMinWidth(Region.USE_COMPUTED_SIZE);
            loginWrapper.setPrefWidth(Region.USE_COMPUTED_SIZE);
            registerWrapper.setMinWidth(0);
            registerWrapper.setPrefWidth(0);
        } else {
            loginWrapper.setMinWidth(0);
            loginWrapper.setPrefWidth(0);
            registerWrapper.setMinWidth(Region.USE_COMPUTED_SIZE);
            registerWrapper.setPrefWidth(Region.USE_COMPUTED_SIZE);
        }
    }

    private void setMessage(String message) {
        messageLabel.setVisible(true);
        messageLabel.setText(message);
    }

    @FXML
    void onCookiesCheckboxClicked(ActionEvent event) {
        cookies = !cookies;
    }

    @FXML
    void onRodoCheckboxClicked(ActionEvent event) {
        rodo = !rodo;
    }

    @FXML
    void onTermsCheckboxClicked(ActionEvent event) {
        terms = !terms;
    }

    @Override
    public void refresh() {

    }
}

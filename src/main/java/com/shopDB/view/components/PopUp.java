package com.shopDB.view.components;

import javafx.scene.control.Alert;
import javafx.scene.control.ButtonType;

public class PopUp extends Alert {
	public PopUp(String title, String header, String message) {
		super(AlertType.INFORMATION);

		setTitle(title);
		setHeaderText(header);
		setContentText(message);

		getButtonTypes().setAll(ButtonType.OK);

		showAndWait();
	}
}

package com.shopDB;

public enum Categories {
	boys("chłopiec", "boys"), 
	girls("dziewczynka", "girls"), 
	men("mężczyzna", "men"), 
	women("kobieta", "women"), 
	all("wszystko", null);

	public String polish;
	public String databaseValue;

	Categories(String polish, String databaseValue) {
		this.polish = polish;
		this.databaseValue = databaseValue;
	}

	public static String translate(String polish) {
		for (Categories c : Categories.values()) {
			if (c.polish.equals(polish)) {
				return c.databaseValue;
			}
		}
		return null;
	}
}
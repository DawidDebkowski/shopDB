package com.shopDB;

public enum OrderStatus {
    cart("koszyk", "cart"),
    placed("złożone", "placed"),
    paid("opłacone", "paid"),
    cancelled("anulowane", "cancelled"),
    completed("kompletne", "completed"),
    return_reported("zgłoszony zwrot", "return reported"),
    returned("zwrócone", "returned");

    public final String polish;
    public final String databaseValue;

    OrderStatus(String polish, String databaseValue) {
        this.polish = polish;
        this.databaseValue = databaseValue;
    }

    public static OrderStatus getOrderStatus(String any) {
        for (OrderStatus c : OrderStatus.values()) {
            if (c.polish.equals(any)|| c.databaseValue.equals(any)) {
                return c;
            }
        }
        return null;
    }

    public static String translate(String polish) {
        for (OrderStatus c : OrderStatus.values()) {
            if (c.polish.equals(polish)) {
                return c.databaseValue;
            }
        }
        return null;
    }

    public static String translateToPolish(String databaseValue) {
        for (OrderStatus c : OrderStatus.values()) {
            if (c.databaseValue.equals(databaseValue)) {
                return c.polish;
            }
        }
        return null;
    }
}

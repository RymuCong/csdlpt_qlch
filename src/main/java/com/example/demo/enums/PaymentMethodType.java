package com.example.demo.enums;

public enum PaymentMethodType {
    CASH("Tiền mặt"),
    TRANSFER("Chuyển khoản"),
    CARD("Thẻ"),
    MOMO("MoMo"),
    VNPAY("VNPay");

    private final String displayName;

    PaymentMethodType(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }
}

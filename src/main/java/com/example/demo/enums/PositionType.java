package com.example.demo.enums;

public enum PositionType {
    ADMIN("Quản trị viên"),
    QUAN_LY("Quản lý"),
    BAN_HANG("Bán hàng"),
    KE_TOAN("Kế toán"),
    KHO("Nhân viên kho"),
    BAO_VE("Bảo vệ"),
    VE_SINH("Vệ sinh");

    private final String displayName;

    PositionType(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }
}

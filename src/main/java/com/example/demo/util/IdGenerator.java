package com.example.demo.util;

import org.springframework.stereotype.Component;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Utility class để generate ID cho các entity theo format chuẩn
 */
@Component
public class IdGenerator {
    
    /**
     * Generate Category ID: CAT001, CAT002, ...
     * Format: CAT + 3 số tự động tăng
     */
    public String generateCategoryId(long currentCount) {
        return String.format("CAT%03d", currentCount + 1);
    }
    
    /**
     * Generate Customer ID: CUS0001, CUS0002, ... (deprecated - dùng cho backward compatibility)
     * Format: CUS + 4 số tự động tăng
     */
    @Deprecated
    public String generateCustomerId(long currentCount) {
        return String.format("CUS%04d", currentCount + 1);
    }
    
    /**
     * Generate Customer ID theo chi nhánh: {storeId}_CUS0001, {storeId}_CUS0002, ...
     * Format: {storeId}_CUS + 4 số tự động tăng
     * Ví dụ: CN02_CUS0021
     */
    public String generateCustomerId(String storeId, long currentCount) {
        return String.format("%s_CUS%04d", storeId, currentCount + 1);
    }
    
    /**
     * Generate Employee ID: {storeId}_EMP001, {storeId}_EMP002, ...
     * Format: {storeId}_EMP + 3 số tự động tăng
     * Ví dụ: CN01_EMP009
     */
    public String generateEmployeeId(String storeId, long currentCount) {
        return String.format("%s_EMP%03d", storeId, currentCount + 1);
    }
    
    /**
     * Generate Product ID: {storeId}_P0001, {storeId}_P0002, ...
     * Format: {storeId}_P + 4 số tự động tăng
     * Ví dụ: CN02_P0013
     */
    public String generateProductId(String storeId, long currentCount) {
        return String.format("%s_P%04d", storeId, currentCount + 1);
    }
    
    /**
     * Generate Bill ID: {storeId}_B00001, {storeId}_B00002, ...
     * Format: {storeId}_B + 5 số tự động tăng
     * Ví dụ: CN01_B00423
     */
    public String generateBillId(String storeId, long currentCount) {
        return String.format("%s_B%05d", storeId, currentCount + 1);
    }
    
    /**
     * Generate BillDetail ID: {storeId}_B{5 số}_BD0001, ...
     * Format: {storeId}_B{5 số}_BD + 4 số tự động tăng
     * Ví dụ: CN07_B00034_BD0003
     * Note: billId đã có format {storeId}_B{5 số}, nên chỉ cần extract phần B{5 số}
     */
    public String generateBillDetailId(String storeId, String billId, long currentCount) {
        // Extract phần B{5 số} từ billId (ví dụ: CN01_B00001 -> B00001)
        String billNumber = billId.substring(billId.indexOf('_') + 1); // Lấy phần sau dấu _
        return String.format("%s_%s_BD%04d", storeId, billNumber, currentCount + 1);
    }
    
    /**
     * Generate PayRoll ID: {storeId}_{MMyyyy}_001, {storeId}_{MMyyyy}_002, ...
     * Format: {storeId}_{MMyyyy}_ + 3 số tự động tăng
     * Ví dụ: CN01_102025_009
     */
    public String generatePayRollId(String storeId, LocalDate payMonth, long currentCount) {
        String monthYear = payMonth.format(DateTimeFormatter.ofPattern("MMyyyy"));
        return String.format("%s_%s_%03d", storeId, monthYear, currentCount + 1);
    }
    
    /**
     * Extract store ID from entity ID (for Employee, Product, Bill, etc.)
     * Ví dụ: CN01_EMP009 -> CN01
     */
    public String extractStoreId(String entityId) {
        if (entityId == null || entityId.isEmpty()) {
            return null;
        }
        
        // Pattern: {storeId}_...
        int underscoreIndex = entityId.indexOf('_');
        if (underscoreIndex > 0) {
            return entityId.substring(0, underscoreIndex);
        }
        
        return null;
    }
    
    /**
     * Extract number from ID (for counting purposes)
     * Ví dụ: CN01_EMP009 -> 9, CAT001 -> 1
     */
    public long extractNumberFromId(String id) {
        if (id == null || id.isEmpty()) {
            return 0;
        }
        
        // Tìm số cuối cùng trong ID
        Pattern pattern = Pattern.compile("(\\d+)(?!.*\\d)");
        Matcher matcher = pattern.matcher(id);
        if (matcher.find()) {
            return Long.parseLong(matcher.group(1));
        }
        
        return 0;
    }
}


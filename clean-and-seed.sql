-- ============================================
-- CLEAN AND SEED DATA CHO HỆ THỐNG
-- Database: store_management
-- ============================================

USE store_management;
GO

PRINT '================================================';
PRINT 'BẮT ĐẦU XÓA DỮ LIỆU CŨ...';
PRINT '================================================';

-- Xóa constraint cũ nếu có (để tránh lỗi FOREIGN KEY)
-- Lưu ý: Nếu gặp lỗi FOREIGN KEY, có thể do constraint cũ trong database
BEGIN TRY
    -- Xóa FOREIGN KEY constraint cũ trên bill_details nếu có
    IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK7coossdaxtwjpy23knsjtua2i')
    BEGIN
        ALTER TABLE bill_details DROP CONSTRAINT FK7coossdaxtwjpy23knsjtua2i;
        PRINT 'Đã xóa FOREIGN KEY constraint cũ: FK7coossdaxtwjpy23knsjtua2i';
    END
END TRY
BEGIN CATCH
    -- Bỏ qua lỗi nếu constraint không tồn tại
    PRINT 'Không tìm thấy constraint cũ hoặc đã được xóa';
END CATCH
GO

-- Xóa theo thứ tự để tránh lỗi foreign key
DELETE FROM bill_details;
DELETE FROM pay_roll;
DELETE FROM bill;
DELETE FROM product;
DELETE FROM customer;
DELETE FROM employee;
DELETE FROM category;
DELETE FROM store;

PRINT 'ĐÃ XÓA TẤT CẢ DỮ LIỆU CŨ!';
PRINT '================================================';
PRINT 'BẮT ĐẦU SEED DỮ LIỆU MỚI...';
PRINT '================================================';
GO

-- ============================================
-- 1. STORE - Cửa hàng (1 trụ sở + 7 chi nhánh)
-- ============================================
INSERT INTO store (id, address, phone, area, created_date, updated_date) VALUES
('TS01', N'Tầng 10, Tòa nhà Hồ Gươm Plaza, 110 Trần Phú, P. Mộ Lao, Q. Hà Đông, Hà Nội', '02411112222', 1000.00, GETDATE(), GETDATE()),
('CN01', N'25 Hàng Bài, P. Hàng Bài, Q. Hoàn Kiếm, Hà Nội', '02433334444', 150.00, GETDATE(), GETDATE()),
('CN02', N'112 Xuân Thủy, P. Dịch Vọng Hậu, Q. Cầu Giấy, Hà Nội', '02455556666', 130.00, GETDATE(), GETDATE()),
('CN03', N'315 Nguyễn Trãi, P. Thanh Xuân Trung, Q. Thanh Xuân, Hà Nội', '02477778888', 140.00, GETDATE(), GETDATE()),
('CN04', N'50 Phố Huế, P. Phạm Đình Hổ, Q. Hai Bà Trưng, Hà Nội', '02499990000', 120.00, GETDATE(), GETDATE()),
('CN05', N'168 Nguyễn Văn Cừ, P. Bồ Đề, Q. Long Biên, Hà Nội', '02422223333', 160.00, GETDATE(), GETDATE()),
('CN06', N'Khu CNC Hòa Lạc, H. Thạch Thất, Hà Nội', '02444445555', 200.00, GETDATE(), GETDATE()),
('CN07', N'Kim Mã, Hà Nội', '0244444777', 199.00, GETDATE(), GETDATE());

PRINT 'Store: 1 trụ sở + 7 chi nhánh ✓';

-- ============================================
-- 2. CATEGORY - Danh mục sản phẩm (8 danh mục)
-- Format: CAT001, CAT002, ...
-- ============================================
INSERT INTO category (id, name, created_date, updated_date) VALUES
('CAT001', N'Đồ uống', GETDATE(), GETDATE()),
('CAT002', N'Snack & Bánh kẹo', GETDATE(), GETDATE()),
('CAT003', N'Mì ăn liền', GETDATE(), GETDATE()),
('CAT004', N'Sữa & Sản phẩm từ sữa', GETDATE(), GETDATE()),
('CAT005', N'Đồ dùng cá nhân', GETDATE(), GETDATE()),
('CAT006', N'Đồ gia dụng', GETDATE(), GETDATE()),
('CAT007', N'Thực phẩm tươi sống', GETDATE(), GETDATE()),
('CAT008', N'Văn phòng phẩm', GETDATE(), GETDATE());

PRINT 'Category: 8 danh mục ✓';

-- ============================================
-- 3. EMPLOYEE - Nhân viên CN01 (11 người: 1 ADMIN, 1 QUAN_LY, 1 KE_TOAN, 4 BAN_HANG, 2 KHO, 1 BAO_VE, 1 VE_SINH)
-- Format: {storeId}_EMP001, {storeId}_EMP002, ...
-- Password: "123456" 
-- BCrypt Hash: $2a$12$DNidaiqmRJDsT7BeHI/lL.mI7NguOVwZiMgtavH475YYhInt9tpBS
-- ============================================
INSERT INTO employee (id, name, phone, address, position, base_salary, password, store_id, created_date, updated_date) VALUES
('TS01_EMP001', N'Admin System', '0900000000', N'Server Trung Tâm', 'ADMIN', 100000, '$2a$12$DNidaiqmRJDsT7BeHI/lL.mI7NguOVwZiMgtavH475YYhInt9tpBS', 'TS01', GETDATE(), GETDATE()),
('CN01_EMP001', N'Nguyễn Văn A', '0901234567', N'Hà Nội', 'QUAN_LY', 50000, '$2a$12$DNidaiqmRJDsT7BeHI/lL.mI7NguOVwZiMgtavH475YYhInt9tpBS', 'CN01', GETDATE(), GETDATE()),
('CN01_EMP002', N'Trần Thị B', '0901234568', N'Hà Nội', 'KE_TOAN', 45000, '$2a$12$DNidaiqmRJDsT7BeHI/lL.mI7NguOVwZiMgtavH475YYhInt9tpBS', 'CN01', GETDATE(), GETDATE()),
('CN01_EMP003', N'Lê Văn C', '0901234569', N'Hà Nội', 'BAN_HANG', 30000, '$2a$12$DNidaiqmRJDsT7BeHI/lL.mI7NguOVwZiMgtavH475YYhInt9tpBS', 'CN01', GETDATE(), GETDATE()),
('CN01_EMP004', N'Phạm Thị D', '0901234570', N'Hà Nội', 'BAN_HANG', 30000, '$2a$12$DNidaiqmRJDsT7BeHI/lL.mI7NguOVwZiMgtavH475YYhInt9tpBS', 'CN01', GETDATE(), GETDATE()),
('CN01_EMP005', N'Hoàng Văn E', '0901234571', N'Hà Nội', 'BAN_HANG', 28000, '$2a$12$DNidaiqmRJDsT7BeHI/lL.mI7NguOVwZiMgtavH475YYhInt9tpBS', 'CN01', GETDATE(), GETDATE()),
('CN01_EMP006', N'Vũ Thị F', '0901234572', N'Hà Nội', 'BAN_HANG', 28000, '$2a$12$DNidaiqmRJDsT7BeHI/lL.mI7NguOVwZiMgtavH475YYhInt9tpBS', 'CN01', GETDATE(), GETDATE()),
('CN01_EMP007', N'Đặng Văn G', '0901234573', N'Hà Nội', 'KHO', 32000, '$2a$12$DNidaiqmRJDsT7BeHI/lL.mI7NguOVwZiMgtavH475YYhInt9tpBS', 'CN01', GETDATE(), GETDATE()),
('CN01_EMP008', N'Bùi Thị H', '0901234574', N'Hà Nội', 'KHO', 32000, '$2a$12$DNidaiqmRJDsT7BeHI/lL.mI7NguOVwZiMgtavH475YYhInt9tpBS', 'CN01', GETDATE(), GETDATE()),
('CN01_EMP009', N'Đỗ Văn I', '0901234575', N'Hà Nội', 'BAO_VE', 25000, '$2a$12$DNidaiqmRJDsT7BeHI/lL.mI7NguOVwZiMgtavH475YYhInt9tpBS', 'CN01', GETDATE(), GETDATE()),
('CN01_EMP010', N'Mai Thị K', '0901234576', N'Hà Nội', 'VE_SINH', 22000, '$2a$12$DNidaiqmRJDsT7BeHI/lL.mI7NguOVwZiMgtavH475YYhInt9tpBS', 'CN01', GETDATE(), GETDATE());

-- ============================================
-- EMPLOYEE - Nhân viên CN02 (11 người)
-- ============================================
INSERT INTO employee (id, name, phone, address, position, base_salary, password, store_id, created_date, updated_date) VALUES
('CN02_EMP001', N'Lý Văn An', '0911234567', N'Hà Nội', 'QUAN_LY', 50000, '$2a$12$DNidaiqmRJDsT7BeHI/lL.mI7NguOVwZiMgtavH475YYhInt9tpBS', 'CN02', GETDATE(), GETDATE()),
('CN02_EMP002', N'Võ Thị Bình', '0911234568', N'Hà Nội', 'KE_TOAN', 45000, '$2a$12$DNidaiqmRJDsT7BeHI/lL.mI7NguOVwZiMgtavH475YYhInt9tpBS', 'CN02', GETDATE(), GETDATE()),
('CN02_EMP003', N'Đinh Văn Cường', '0911234569', N'Hà Nội', 'BAN_HANG', 30000, '$2a$12$DNidaiqmRJDsT7BeHI/lL.mI7NguOVwZiMgtavH475YYhInt9tpBS', 'CN02', GETDATE(), GETDATE()),
('CN02_EMP004', N'Bùi Thị Dung', '0911234570', N'Hà Nội', 'BAN_HANG', 30000, '$2a$12$DNidaiqmRJDsT7BeHI/lL.mI7NguOVwZiMgtavH475YYhInt9tpBS', 'CN02', GETDATE(), GETDATE()),
('CN02_EMP005', N'Phan Văn Em', '0911234571', N'Hà Nội', 'BAN_HANG', 28000, '$2a$12$DNidaiqmRJDsT7BeHI/lL.mI7NguOVwZiMgtavH475YYhInt9tpBS', 'CN02', GETDATE(), GETDATE()),
('CN02_EMP006', N'Trương Thị Phương', '0911234572', N'Hà Nội', 'BAN_HANG', 28000, '$2a$12$DNidaiqmRJDsT7BeHI/lL.mI7NguOVwZiMgtavH475YYhInt9tpBS', 'CN02', GETDATE(), GETDATE()),
('CN02_EMP007', N'Lưu Văn Giang', '0911234573', N'Hà Nội', 'KHO', 32000, '$2a$12$DNidaiqmRJDsT7BeHI/lL.mI7NguOVwZiMgtavH475YYhInt9tpBS', 'CN02', GETDATE(), GETDATE()),
('CN02_EMP008', N'Ngô Thị Hoa', '0911234574', N'Hà Nội', 'KHO', 32000, '$2a$12$DNidaiqmRJDsT7BeHI/lL.mI7NguOVwZiMgtavH475YYhInt9tpBS', 'CN02', GETDATE(), GETDATE()),
('CN02_EMP009', N'Đào Văn Hùng', '0911234575', N'Hà Nội', 'BAO_VE', 25000, '$2a$12$DNidaiqmRJDsT7BeHI/lL.mI7NguOVwZiMgtavH475YYhInt9tpBS', 'CN02', GETDATE(), GETDATE()),
('CN02_EMP010', N'Lương Thị Lan', '0911234576', N'Hà Nội', 'VE_SINH', 22000, '$2a$12$DNidaiqmRJDsT7BeHI/lL.mI7NguOVwZiMgtavH475YYhInt9tpBS', 'CN02', GETDATE(), GETDATE());

-- ============================================
-- EMPLOYEE - Nhân viên CN03 (11 người)
-- ============================================
INSERT INTO employee (id, name, phone, address, position, base_salary, password, store_id, created_date, updated_date) VALUES
('CN03_EMP001', N'Vương Văn Minh', '0921234567', N'Hà Nội', 'QUAN_LY', 50000, '$2a$12$DNidaiqmRJDsT7BeHI/lL.mI7NguOVwZiMgtavH475YYhInt9tpBS', 'CN03', GETDATE(), GETDATE()),
('CN03_EMP002', N'Đỗ Thị Nga', '0921234568', N'Hà Nội', 'KE_TOAN', 45000, '$2a$12$DNidaiqmRJDsT7BeHI/lL.mI7NguOVwZiMgtavH475YYhInt9tpBS', 'CN03', GETDATE(), GETDATE()),
('CN03_EMP003', N'Hoàng Văn Oanh', '0921234569', N'Hà Nội', 'BAN_HANG', 30000, '$2a$12$DNidaiqmRJDsT7BeHI/lL.mI7NguOVwZiMgtavH475YYhInt9tpBS', 'CN03', GETDATE(), GETDATE()),
('CN03_EMP004', N'Phạm Thị Phượng', '0921234570', N'Hà Nội', 'BAN_HANG', 30000, '$2a$12$DNidaiqmRJDsT7BeHI/lL.mI7NguOVwZiMgtavH475YYhInt9tpBS', 'CN03', GETDATE(), GETDATE()),
('CN03_EMP005', N'Trần Văn Quang', '0921234571', N'Hà Nội', 'BAN_HANG', 28000, '$2a$12$DNidaiqmRJDsT7BeHI/lL.mI7NguOVwZiMgtavH475YYhInt9tpBS', 'CN03', GETDATE(), GETDATE()),
('CN03_EMP006', N'Nguyễn Thị Quyên', '0921234572', N'Hà Nội', 'BAN_HANG', 28000, '$2a$12$DNidaiqmRJDsT7BeHI/lL.mI7NguOVwZiMgtavH475YYhInt9tpBS', 'CN03', GETDATE(), GETDATE()),
('CN03_EMP007', N'Lê Văn Sơn', '0921234573', N'Hà Nội', 'KHO', 32000, '$2a$12$DNidaiqmRJDsT7BeHI/lL.mI7NguOVwZiMgtavH475YYhInt9tpBS', 'CN03', GETDATE(), GETDATE()),
('CN03_EMP008', N'Vũ Thị Tâm', '0921234574', N'Hà Nội', 'KHO', 32000, '$2a$12$DNidaiqmRJDsT7BeHI/lL.mI7NguOVwZiMgtavH475YYhInt9tpBS', 'CN03', GETDATE(), GETDATE()),
('CN03_EMP009', N'Đặng Văn Tuấn', '0921234575', N'Hà Nội', 'BAO_VE', 25000, '$2a$12$DNidaiqmRJDsT7BeHI/lL.mI7NguOVwZiMgtavH475YYhInt9tpBS', 'CN03', GETDATE(), GETDATE()),
('CN03_EMP010', N'Bùi Thị Uyên', '0921234576', N'Hà Nội', 'VE_SINH', 22000, '$2a$12$DNidaiqmRJDsT7BeHI/lL.mI7NguOVwZiMgtavH475YYhInt9tpBS', 'CN03', GETDATE(), GETDATE());

-- ============================================
-- EMPLOYEE - Nhân viên CN04 (11 người)
-- ============================================
INSERT INTO employee (id, name, phone, address, position, base_salary, password, store_id, created_date, updated_date) VALUES
('CN04_EMP001', N'Lý Văn Việt', '0931234567', N'Hà Nội', 'QUAN_LY', 50000, '$2a$12$DNidaiqmRJDsT7BeHI/lL.mI7NguOVwZiMgtavH475YYhInt9tpBS', 'CN04', GETDATE(), GETDATE()),
('CN04_EMP002', N'Võ Thị Xuân', '0931234568', N'Hà Nội', 'KE_TOAN', 45000, '$2a$12$DNidaiqmRJDsT7BeHI/lL.mI7NguOVwZiMgtavH475YYhInt9tpBS', 'CN04', GETDATE(), GETDATE()),
('CN04_EMP003', N'Đinh Văn Yên', '0931234569', N'Hà Nội', 'BAN_HANG', 30000, '$2a$12$DNidaiqmRJDsT7BeHI/lL.mI7NguOVwZiMgtavH475YYhInt9tpBS', 'CN04', GETDATE(), GETDATE()),
('CN04_EMP004', N'Bùi Thị Yến', '0931234570', N'Hà Nội', 'BAN_HANG', 30000, '$2a$12$DNidaiqmRJDsT7BeHI/lL.mI7NguOVwZiMgtavH475YYhInt9tpBS', 'CN04', GETDATE(), GETDATE()),
('CN04_EMP005', N'Phan Văn Anh', '0931234571', N'Hà Nội', 'BAN_HANG', 28000, '$2a$12$DNidaiqmRJDsT7BeHI/lL.mI7NguOVwZiMgtavH475YYhInt9tpBS', 'CN04', GETDATE(), GETDATE()),
('CN04_EMP006', N'Trương Thị Bích', '0931234572', N'Hà Nội', 'BAN_HANG', 28000, '$2a$12$DNidaiqmRJDsT7BeHI/lL.mI7NguOVwZiMgtavH475YYhInt9tpBS', 'CN04', GETDATE(), GETDATE()),
('CN04_EMP007', N'Lưu Văn Cảnh', '0931234573', N'Hà Nội', 'KHO', 32000, '$2a$12$DNidaiqmRJDsT7BeHI/lL.mI7NguOVwZiMgtavH475YYhInt9tpBS', 'CN04', GETDATE(), GETDATE()),
('CN04_EMP008', N'Ngô Thị Duyên', '0931234574', N'Hà Nội', 'KHO', 32000, '$2a$12$DNidaiqmRJDsT7BeHI/lL.mI7NguOVwZiMgtavH475YYhInt9tpBS', 'CN04', GETDATE(), GETDATE()),
('CN04_EMP009', N'Đào Văn Đức', '0931234575', N'Hà Nội', 'BAO_VE', 25000, '$2a$12$DNidaiqmRJDsT7BeHI/lL.mI7NguOVwZiMgtavH475YYhInt9tpBS', 'CN04', GETDATE(), GETDATE()),
('CN04_EMP010', N'Lương Thị Hạnh', '0931234576', N'Hà Nội', 'VE_SINH', 22000, '$2a$12$DNidaiqmRJDsT7BeHI/lL.mI7NguOVwZiMgtavH475YYhInt9tpBS', 'CN04', GETDATE(), GETDATE());

-- ============================================
-- EMPLOYEE - Nhân viên CN05 (11 người)
-- ============================================
INSERT INTO employee (id, name, phone, address, position, base_salary, password, store_id, created_date, updated_date) VALUES
('CN05_EMP001', N'Vương Văn Hải', '0941234567', N'Hà Nội', 'QUAN_LY', 50000, '$2a$12$DNidaiqmRJDsT7BeHI/lL.mI7NguOVwZiMgtavH475YYhInt9tpBS', 'CN05', GETDATE(), GETDATE()),
('CN05_EMP002', N'Đỗ Thị Hương', '0941234568', N'Hà Nội', 'KE_TOAN', 45000, '$2a$12$DNidaiqmRJDsT7BeHI/lL.mI7NguOVwZiMgtavH475YYhInt9tpBS', 'CN05', GETDATE(), GETDATE()),
('CN05_EMP003', N'Hoàng Văn Khoa', '0941234569', N'Hà Nội', 'BAN_HANG', 30000, '$2a$12$DNidaiqmRJDsT7BeHI/lL.mI7NguOVwZiMgtavH475YYhInt9tpBS', 'CN05', GETDATE(), GETDATE()),
('CN05_EMP004', N'Phạm Thị Linh', '0941234570', N'Hà Nội', 'BAN_HANG', 30000, '$2a$12$DNidaiqmRJDsT7BeHI/lL.mI7NguOVwZiMgtavH475YYhInt9tpBS', 'CN05', GETDATE(), GETDATE()),
('CN05_EMP005', N'Trần Văn Long', '0941234571', N'Hà Nội', 'BAN_HANG', 28000, '$2a$12$DNidaiqmRJDsT7BeHI/lL.mI7NguOVwZiMgtavH475YYhInt9tpBS', 'CN05', GETDATE(), GETDATE()),
('CN05_EMP006', N'Nguyễn Thị Mai', '0941234572', N'Hà Nội', 'BAN_HANG', 28000, '$2a$12$DNidaiqmRJDsT7BeHI/lL.mI7NguOVwZiMgtavH475YYhInt9tpBS', 'CN05', GETDATE(), GETDATE()),
('CN05_EMP007', N'Lê Văn Nam', '0941234573', N'Hà Nội', 'KHO', 32000, '$2a$12$DNidaiqmRJDsT7BeHI/lL.mI7NguOVwZiMgtavH475YYhInt9tpBS', 'CN05', GETDATE(), GETDATE()),
('CN05_EMP008', N'Vũ Thị Nhung', '0941234574', N'Hà Nội', 'KHO', 32000, '$2a$12$DNidaiqmRJDsT7BeHI/lL.mI7NguOVwZiMgtavH475YYhInt9tpBS', 'CN05', GETDATE(), GETDATE()),
('CN05_EMP009', N'Đặng Văn Phong', '0941234575', N'Hà Nội', 'BAO_VE', 25000, '$2a$12$DNidaiqmRJDsT7BeHI/lL.mI7NguOVwZiMgtavH475YYhInt9tpBS', 'CN05', GETDATE(), GETDATE()),
('CN05_EMP010', N'Bùi Thị Quỳnh', '0941234576', N'Hà Nội', 'VE_SINH', 22000, '$2a$12$DNidaiqmRJDsT7BeHI/lL.mI7NguOVwZiMgtavH475YYhInt9tpBS', 'CN05', GETDATE(), GETDATE());

-- ============================================
-- EMPLOYEE - Nhân viên CN06 (11 người)
-- ============================================
INSERT INTO employee (id, name, phone, address, position, base_salary, password, store_id, created_date, updated_date) VALUES
('CN06_EMP001', N'Lý Văn Sinh', '0951234567', N'Hà Nội', 'QUAN_LY', 50000, '$2a$12$DNidaiqmRJDsT7BeHI/lL.mI7NguOVwZiMgtavH475YYhInt9tpBS', 'CN06', GETDATE(), GETDATE()),
('CN06_EMP002', N'Võ Thị Thảo', '0951234568', N'Hà Nội', 'KE_TOAN', 45000, '$2a$12$DNidaiqmRJDsT7BeHI/lL.mI7NguOVwZiMgtavH475YYhInt9tpBS', 'CN06', GETDATE(), GETDATE()),
('CN06_EMP003', N'Đinh Văn Thắng', '0951234569', N'Hà Nội', 'BAN_HANG', 30000, '$2a$12$DNidaiqmRJDsT7BeHI/lL.mI7NguOVwZiMgtavH475YYhInt9tpBS', 'CN06', GETDATE(), GETDATE()),
('CN06_EMP004', N'Bùi Thị Thơm', '0951234570', N'Hà Nội', 'BAN_HANG', 30000, '$2a$12$DNidaiqmRJDsT7BeHI/lL.mI7NguOVwZiMgtavH475YYhInt9tpBS', 'CN06', GETDATE(), GETDATE()),
('CN06_EMP005', N'Phan Văn Thông', '0951234571', N'Hà Nội', 'BAN_HANG', 28000, '$2a$12$DNidaiqmRJDsT7BeHI/lL.mI7NguOVwZiMgtavH475YYhInt9tpBS', 'CN06', GETDATE(), GETDATE()),
('CN06_EMP006', N'Trương Thị Trang', '0951234572', N'Hà Nội', 'BAN_HANG', 28000, '$2a$12$DNidaiqmRJDsT7BeHI/lL.mI7NguOVwZiMgtavH475YYhInt9tpBS', 'CN06', GETDATE(), GETDATE()),
('CN06_EMP007', N'Lưu Văn Trung', '0951234573', N'Hà Nội', 'KHO', 32000, '$2a$12$DNidaiqmRJDsT7BeHI/lL.mI7NguOVwZiMgtavH475YYhInt9tpBS', 'CN06', GETDATE(), GETDATE()),
('CN06_EMP008', N'Ngô Thị Trúc', '0951234574', N'Hà Nội', 'KHO', 32000, '$2a$12$DNidaiqmRJDsT7BeHI/lL.mI7NguOVwZiMgtavH475YYhInt9tpBS', 'CN06', GETDATE(), GETDATE()),
('CN06_EMP009', N'Đào Văn Vinh', '0951234575', N'Hà Nội', 'BAO_VE', 25000, '$2a$12$DNidaiqmRJDsT7BeHI/lL.mI7NguOVwZiMgtavH475YYhInt9tpBS', 'CN06', GETDATE(), GETDATE()),
('CN06_EMP010', N'Lương Thị Vân', '0951234576', N'Hà Nội', 'VE_SINH', 22000, '$2a$12$DNidaiqmRJDsT7BeHI/lL.mI7NguOVwZiMgtavH475YYhInt9tpBS', 'CN06', GETDATE(), GETDATE());

-- ============================================
-- EMPLOYEE - Nhân viên CN07 (11 người)
-- ============================================
INSERT INTO employee (id, name, phone, address, position, base_salary, password, store_id, created_date, updated_date) VALUES
('CN07_EMP001', N'Vương Văn Vũ', '0961234567', N'Hà Nội', 'QUAN_LY', 50000, '$2a$12$DNidaiqmRJDsT7BeHI/lL.mI7NguOVwZiMgtavH475YYhInt9tpBS', 'CN07', GETDATE(), GETDATE()),
('CN07_EMP002', N'Đỗ Thị Yến', '0961234568', N'Hà Nội', 'KE_TOAN', 45000, '$2a$12$DNidaiqmRJDsT7BeHI/lL.mI7NguOVwZiMgtavH475YYhInt9tpBS', 'CN07', GETDATE(), GETDATE()),
('CN07_EMP003', N'Hoàng Văn Anh', '0961234569', N'Hà Nội', 'BAN_HANG', 30000, '$2a$12$DNidaiqmRJDsT7BeHI/lL.mI7NguOVwZiMgtavH475YYhInt9tpBS', 'CN07', GETDATE(), GETDATE()),
('CN07_EMP004', N'Phạm Thị Bình', '0961234570', N'Hà Nội', 'BAN_HANG', 30000, '$2a$12$DNidaiqmRJDsT7BeHI/lL.mI7NguOVwZiMgtavH475YYhInt9tpBS', 'CN07', GETDATE(), GETDATE()),
('CN07_EMP005', N'Trần Văn Cường', '0961234571', N'Hà Nội', 'BAN_HANG', 28000, '$2a$12$DNidaiqmRJDsT7BeHI/lL.mI7NguOVwZiMgtavH475YYhInt9tpBS', 'CN07', GETDATE(), GETDATE()),
('CN07_EMP006', N'Nguyễn Thị Dung', '0961234572', N'Hà Nội', 'BAN_HANG', 28000, '$2a$12$DNidaiqmRJDsT7BeHI/lL.mI7NguOVwZiMgtavH475YYhInt9tpBS', 'CN07', GETDATE(), GETDATE()),
('CN07_EMP007', N'Lê Văn Em', '0961234573', N'Hà Nội', 'KHO', 32000, '$2a$12$DNidaiqmRJDsT7BeHI/lL.mI7NguOVwZiMgtavH475YYhInt9tpBS', 'CN07', GETDATE(), GETDATE()),
('CN07_EMP008', N'Vũ Thị Phương', '0961234574', N'Hà Nội', 'KHO', 32000, '$2a$12$DNidaiqmRJDsT7BeHI/lL.mI7NguOVwZiMgtavH475YYhInt9tpBS', 'CN07', GETDATE(), GETDATE()),
('CN07_EMP009', N'Đặng Văn Giang', '0961234575', N'Hà Nội', 'BAO_VE', 25000, '$2a$12$DNidaiqmRJDsT7BeHI/lL.mI7NguOVwZiMgtavH475YYhInt9tpBS', 'CN07', GETDATE(), GETDATE()),
('CN07_EMP010', N'Bùi Thị Hoa', '0961234576', N'Hà Nội', 'VE_SINH', 22000, '$2a$12$DNidaiqmRJDsT7BeHI/lL.mI7NguOVwZiMgtavH475YYhInt9tpBS', 'CN07', GETDATE(), GETDATE());

PRINT 'Employee: 71 nhân viên (1 ADMIN, 7 QUAN_LY, 7 KE_TOAN, 28 BAN_HANG, 14 KHO, 7 BAO_VE, 7 VE_SINH) ✓';
GO

-- ============================================
-- 4. CUSTOMER - Khách hàng (10 người)
-- Format: CUS0001, CUS0002, ...
-- ============================================
INSERT INTO customer (id, name, phone, level, total_payment, created_date, updated_date) VALUES
('CUS0001', N'Nguyễn Minh Anh', '0987654321', 4, 15000000.00, GETDATE(), GETDATE()),
('CUS0002', N'Trần Hoàng Bảo', '0987654322', 3, 8500000.00, GETDATE(), GETDATE()),
('CUS0003', N'Lê Thu Cúc', '0987654323', 3, 7200000.00, GETDATE(), GETDATE()),
('CUS0004', N'Phạm Văn Dũng', '0987654324', 2, 3500000.00, GETDATE(), GETDATE()),
('CUS0005', N'Hoàng Thị Em', '0987654325', 2, 2800000.00, GETDATE(), GETDATE()),
('CUS0006', N'Vũ Minh Phương', '0987654326', 1, 950000.00, GETDATE(), GETDATE()),
('CUS0007', N'Đặng Thu Giang', '0987654327', 1, 650000.00, GETDATE(), GETDATE()),
('CUS0008', N'Bùi Văn Hải', '0987654328', 1, 420000.00, GETDATE(), GETDATE()),
('CUS0009', N'Đỗ Thị Lan', '0987654329', 1, 280000.00, GETDATE(), GETDATE()),
('CUS0010', N'Mai Văn Khôi', '0987654330', 1, 150000.00, GETDATE(), GETDATE());

PRINT 'Customer: 10 khách hàng ✓';

-- ============================================
-- 5. PRODUCT - Sản phẩm CN01 (30 sản phẩm)
-- Format: {storeId}_P0001, {storeId}_P0002, ...
-- ============================================
INSERT INTO product (id, name, price, quantity, exp_date, cate_id, store_id, created_date, updated_date) VALUES
-- Đồ uống (10 sản phẩm)
('CN01_P0001', N'Coca Cola 330ml', 10000, 500, '2025-12-31', 'CAT001', 'CN01', GETDATE(), GETDATE()),
('CN01_P0002', N'Pepsi 330ml', 9500, 450, '2025-12-31', 'CAT001', 'CN01', GETDATE(), GETDATE()),
('CN01_P0003', N'7Up 330ml', 9500, 480, '2025-11-30', 'CAT001', 'CN01', GETDATE(), GETDATE()),
('CN01_P0004', N'Sting dâu 330ml', 12000, 350, '2025-10-31', 'CAT001', 'CN01', GETDATE(), GETDATE()),
('CN01_P0005', N'Revive chanh muối 500ml', 13000, 280, '2025-09-30', 'CAT001', 'CN01', GETDATE(), GETDATE()),
('CN01_P0006', N'Trà xanh 0 độ Không độ 450ml', 11000, 320, '2025-08-31', 'CAT001', 'CN01', GETDATE(), GETDATE()),
('CN01_P0007', N'Number 1 Sôcôla 220ml', 8000, 420, '2025-12-15', 'CAT001', 'CN01', GETDATE(), GETDATE()),
('CN01_P0008', N'Aquafina 500ml', 5000, 800, '2026-12-31', 'CAT001', 'CN01', GETDATE(), GETDATE()),
('CN01_P0009', N'Lavie 500ml', 4500, 750, '2026-12-31', 'CAT001', 'CN01', GETDATE(), GETDATE()),
('CN01_P0010', N'C2 Hương Đào 455ml', 10000, 300, '2025-07-31', 'CAT001', 'CN01', GETDATE(), GETDATE()),

-- Snack & Bánh kẹo (6 sản phẩm)
('CN01_P0011', N'Snack Oishi Tôm Cay 40g', 5000, 600, '2025-06-30', 'CAT002', 'CN01', GETDATE(), GETDATE()),
('CN01_P0012', N'Bánh Oreo Original 133g', 18000, 250, '2025-08-15', 'CAT002', 'CN01', GETDATE(), GETDATE()),
('CN01_P0013', N'Kẹo Alpenliebe nhiều vị 1 túi', 22000, 180, '2025-10-31', 'CAT002', 'CN01', GETDATE(), GETDATE()),
('CN01_P0014', N'Snack Poca khoai tây vị tự nhiên 54g', 10000, 320, '2025-05-31', 'CAT002', 'CN01', GETDATE(), GETDATE()),
('CN01_P0015', N'Bánh Goute vị Sữa 15 cái', 25000, 150, '2025-07-20', 'CAT002', 'CN01', GETDATE(), GETDATE()),
('CN01_P0016', N'Kẹo Mentos Cola 3 cuộn', 15000, 200, '2025-09-30', 'CAT002', 'CN01', GETDATE(), GETDATE()),

-- Mì ăn liền (4 sản phẩm)
('CN01_P0017', N'Mì Hảo Hảo Tôm Chua Cay 75g', 4000, 1000, '2025-12-31', 'CAT003', 'CN01', GETDATE(), GETDATE()),
('CN01_P0018', N'Mì Omachi Xào Bò 80g', 5500, 800, '2025-11-30', 'CAT003', 'CN01', GETDATE(), GETDATE()),
('CN01_P0019', N'Mì Kokomi Tôm 60g', 3500, 950, '2025-10-31', 'CAT003', 'CN01', GETDATE(), GETDATE()),
('CN01_P0020', N'Mì 3 Miền Gold Tôm Thịt 68g', 5000, 700, '2025-09-30', 'CAT003', 'CN01', GETDATE(), GETDATE()),

-- Sữa (5 sản phẩm)
('CN01_P0021', N'Sữa TH True Milk có đường 1L', 29000, 200, '2024-11-25', 'CAT004', 'CN01', GETDATE(), GETDATE()),
('CN01_P0022', N'Sữa Vinamilk 100% có đường 1L', 32000, 180, '2024-11-20', 'CAT004', 'CN01', GETDATE(), GETDATE()),
('CN01_P0023', N'Sữa chua uống Vinamilk dâu 180ml', 7000, 350, '2024-11-18', 'CAT004', 'CN01', GETDATE(), GETDATE()),
('CN01_P0024', N'Sữa Ensure Gold vani 850g', 485000, 50, '2025-06-30', 'CAT004', 'CN01', GETDATE(), GETDATE()),
('CN01_P0025', N'Sữa Dutch Lady Cô Gái Hà Lan 170ml', 8000, 280, '2024-12-15', 'CAT004', 'CN01', GETDATE(), GETDATE()),

-- Đồ dùng cá nhân (5 sản phẩm)
('CN01_P0026', N'Kem đánh răng P/S bạc hà 240g', 38000, 150, '2026-12-31', 'CAT005', 'CN01', GETDATE(), GETDATE()),
('CN01_P0027', N'Dầu gội Clear Men Mát Lạnh 630g', 128000, 80, '2026-06-30', 'CAT005', 'CN01', GETDATE(), GETDATE()),
('CN01_P0028', N'Sữa tắm Lifebouy bảo vệ vượt trội 850g', 115000, 90, '2026-03-31', 'CAT005', 'CN01', GETDATE(), GETDATE()),
('CN01_P0029', N'Khăn giấy Tempo hộp 200 tờ', 22000, 200, '2027-12-31', 'CAT005', 'CN01', GETDATE(), GETDATE()),
('CN01_P0030', N'Bông tẩy trang Silcot túi 82 miếng', 35000, 120, '2027-12-31', 'CAT005', 'CN01', GETDATE(), GETDATE());

-- ============================================
-- PRODUCT - Sản phẩm CN02 (30 sản phẩm)
-- ============================================
INSERT INTO product (id, name, price, quantity, exp_date, cate_id, store_id, created_date, updated_date) VALUES
('CN02_P0001', N'Coca Cola 330ml', 10000, 480, '2025-12-31', 'CAT001', 'CN02', GETDATE(), GETDATE()),
('CN02_P0002', N'Pepsi 330ml', 9500, 420, '2025-12-31', 'CAT001', 'CN02', GETDATE(), GETDATE()),
('CN02_P0003', N'7Up 330ml', 9500, 450, '2025-11-30', 'CAT001', 'CN02', GETDATE(), GETDATE()),
('CN02_P0004', N'Sting dâu 330ml', 12000, 320, '2025-10-31', 'CAT001', 'CN02', GETDATE(), GETDATE()),
('CN02_P0005', N'Revive chanh muối 500ml', 13000, 260, '2025-09-30', 'CAT001', 'CN02', GETDATE(), GETDATE()),
('CN02_P0006', N'Trà xanh 0 độ Không độ 450ml', 11000, 300, '2025-08-31', 'CAT001', 'CN02', GETDATE(), GETDATE()),
('CN02_P0007', N'Number 1 Sôcôla 220ml', 8000, 400, '2025-12-15', 'CAT001', 'CN02', GETDATE(), GETDATE()),
('CN02_P0008', N'Aquafina 500ml', 5000, 750, '2026-12-31', 'CAT001', 'CN02', GETDATE(), GETDATE()),
('CN02_P0009', N'Lavie 500ml', 4500, 700, '2026-12-31', 'CAT001', 'CN02', GETDATE(), GETDATE()),
('CN02_P0010', N'C2 Hương Đào 455ml', 10000, 280, '2025-07-31', 'CAT001', 'CN02', GETDATE(), GETDATE()),
('CN02_P0011', N'Snack Oishi Tôm Cay 40g', 5000, 550, '2025-06-30', 'CAT002', 'CN02', GETDATE(), GETDATE()),
('CN02_P0012', N'Bánh Oreo Original 133g', 18000, 230, '2025-08-15', 'CAT002', 'CN02', GETDATE(), GETDATE()),
('CN02_P0013', N'Kẹo Alpenliebe nhiều vị 1 túi', 22000, 170, '2025-10-31', 'CAT002', 'CN02', GETDATE(), GETDATE()),
('CN02_P0014', N'Snack Poca khoai tây vị tự nhiên 54g', 10000, 300, '2025-05-31', 'CAT002', 'CN02', GETDATE(), GETDATE()),
('CN02_P0015', N'Bánh Goute vị Sữa 15 cái', 25000, 140, '2025-07-20', 'CAT002', 'CN02', GETDATE(), GETDATE()),
('CN02_P0016', N'Kẹo Mentos Cola 3 cuộn', 15000, 190, '2025-09-30', 'CAT002', 'CN02', GETDATE(), GETDATE()),
('CN02_P0017', N'Mì Hảo Hảo Tôm Chua Cay 75g', 4000, 950, '2025-12-31', 'CAT003', 'CN02', GETDATE(), GETDATE()),
('CN02_P0018', N'Mì Omachi Xào Bò 80g', 5500, 750, '2025-11-30', 'CAT003', 'CN02', GETDATE(), GETDATE()),
('CN02_P0019', N'Mì Kokomi Tôm 60g', 3500, 900, '2025-10-31', 'CAT003', 'CN02', GETDATE(), GETDATE()),
('CN02_P0020', N'Mì 3 Miền Gold Tôm Thịt 68g', 5000, 650, '2025-09-30', 'CAT003', 'CN02', GETDATE(), GETDATE()),
('CN02_P0021', N'Sữa TH True Milk có đường 1L', 29000, 190, '2024-11-25', 'CAT004', 'CN02', GETDATE(), GETDATE()),
('CN02_P0022', N'Sữa Vinamilk 100% có đường 1L', 32000, 170, '2024-11-20', 'CAT004', 'CN02', GETDATE(), GETDATE()),
('CN02_P0023', N'Sữa chua uống Vinamilk dâu 180ml', 7000, 330, '2024-11-18', 'CAT004', 'CN02', GETDATE(), GETDATE()),
('CN02_P0024', N'Sữa Ensure Gold vani 850g', 485000, 45, '2025-06-30', 'CAT004', 'CN02', GETDATE(), GETDATE()),
('CN02_P0025', N'Sữa Dutch Lady Cô Gái Hà Lan 170ml', 8000, 270, '2024-12-15', 'CAT004', 'CN02', GETDATE(), GETDATE()),
('CN02_P0026', N'Kem đánh răng P/S bạc hà 240g', 38000, 140, '2026-12-31', 'CAT005', 'CN02', GETDATE(), GETDATE()),
('CN02_P0027', N'Dầu gội Clear Men Mát Lạnh 630g', 128000, 75, '2026-06-30', 'CAT005', 'CN02', GETDATE(), GETDATE()),
('CN02_P0028', N'Sữa tắm Lifebouy bảo vệ vượt trội 850g', 115000, 85, '2026-03-31', 'CAT005', 'CN02', GETDATE(), GETDATE()),
('CN02_P0029', N'Khăn giấy Tempo hộp 200 tờ', 22000, 190, '2027-12-31', 'CAT005', 'CN02', GETDATE(), GETDATE()),
('CN02_P0030', N'Bông tẩy trang Silcot túi 82 miếng', 35000, 110, '2027-12-31', 'CAT005', 'CN02', GETDATE(), GETDATE());

-- ============================================
-- PRODUCT - Sản phẩm CN03 (30 sản phẩm)
-- ============================================
INSERT INTO product (id, name, price, quantity, exp_date, cate_id, store_id, created_date, updated_date) VALUES
('CN03_P0001', N'Coca Cola 330ml', 10000, 460, '2025-12-31', 'CAT001', 'CN03', GETDATE(), GETDATE()),
('CN03_P0002', N'Pepsi 330ml', 9500, 410, '2025-12-31', 'CAT001', 'CN03', GETDATE(), GETDATE()),
('CN03_P0003', N'7Up 330ml', 9500, 440, '2025-11-30', 'CAT001', 'CN03', GETDATE(), GETDATE()),
('CN03_P0004', N'Sting dâu 330ml', 12000, 310, '2025-10-31', 'CAT001', 'CN03', GETDATE(), GETDATE()),
('CN03_P0005', N'Revive chanh muối 500ml', 13000, 250, '2025-09-30', 'CAT001', 'CN03', GETDATE(), GETDATE()),
('CN03_P0006', N'Trà xanh 0 độ Không độ 450ml', 11000, 290, '2025-08-31', 'CAT001', 'CN03', GETDATE(), GETDATE()),
('CN03_P0007', N'Number 1 Sôcôla 220ml', 8000, 390, '2025-12-15', 'CAT001', 'CN03', GETDATE(), GETDATE()),
('CN03_P0008', N'Aquafina 500ml', 5000, 720, '2026-12-31', 'CAT001', 'CN03', GETDATE(), GETDATE()),
('CN03_P0009', N'Lavie 500ml', 4500, 680, '2026-12-31', 'CAT001', 'CN03', GETDATE(), GETDATE()),
('CN03_P0010', N'C2 Hương Đào 455ml', 10000, 270, '2025-07-31', 'CAT001', 'CN03', GETDATE(), GETDATE()),
('CN03_P0011', N'Snack Oishi Tôm Cay 40g', 5000, 540, '2025-06-30', 'CAT002', 'CN03', GETDATE(), GETDATE()),
('CN03_P0012', N'Bánh Oreo Original 133g', 18000, 220, '2025-08-15', 'CAT002', 'CN03', GETDATE(), GETDATE()),
('CN03_P0013', N'Kẹo Alpenliebe nhiều vị 1 túi', 22000, 160, '2025-10-31', 'CAT002', 'CN03', GETDATE(), GETDATE()),
('CN03_P0014', N'Snack Poca khoai tây vị tự nhiên 54g', 10000, 290, '2025-05-31', 'CAT002', 'CN03', GETDATE(), GETDATE()),
('CN03_P0015', N'Bánh Goute vị Sữa 15 cái', 25000, 130, '2025-07-20', 'CAT002', 'CN03', GETDATE(), GETDATE()),
('CN03_P0016', N'Kẹo Mentos Cola 3 cuộn', 15000, 180, '2025-09-30', 'CAT002', 'CN03', GETDATE(), GETDATE()),
('CN03_P0017', N'Mì Hảo Hảo Tôm Chua Cay 75g', 4000, 920, '2025-12-31', 'CAT003', 'CN03', GETDATE(), GETDATE()),
('CN03_P0018', N'Mì Omachi Xào Bò 80g', 5500, 720, '2025-11-30', 'CAT003', 'CN03', GETDATE(), GETDATE()),
('CN03_P0019', N'Mì Kokomi Tôm 60g', 3500, 880, '2025-10-31', 'CAT003', 'CN03', GETDATE(), GETDATE()),
('CN03_P0020', N'Mì 3 Miền Gold Tôm Thịt 68g', 5000, 630, '2025-09-30', 'CAT003', 'CN03', GETDATE(), GETDATE()),
('CN03_P0021', N'Sữa TH True Milk có đường 1L', 29000, 180, '2024-11-25', 'CAT004', 'CN03', GETDATE(), GETDATE()),
('CN03_P0022', N'Sữa Vinamilk 100% có đường 1L', 32000, 160, '2024-11-20', 'CAT004', 'CN03', GETDATE(), GETDATE()),
('CN03_P0023', N'Sữa chua uống Vinamilk dâu 180ml', 7000, 320, '2024-11-18', 'CAT004', 'CN03', GETDATE(), GETDATE()),
('CN03_P0024', N'Sữa Ensure Gold vani 850g', 485000, 40, '2025-06-30', 'CAT004', 'CN03', GETDATE(), GETDATE()),
('CN03_P0025', N'Sữa Dutch Lady Cô Gái Hà Lan 170ml', 8000, 260, '2024-12-15', 'CAT004', 'CN03', GETDATE(), GETDATE()),
('CN03_P0026', N'Kem đánh răng P/S bạc hà 240g', 38000, 130, '2026-12-31', 'CAT005', 'CN03', GETDATE(), GETDATE()),
('CN03_P0027', N'Dầu gội Clear Men Mát Lạnh 630g', 128000, 70, '2026-06-30', 'CAT005', 'CN03', GETDATE(), GETDATE()),
('CN03_P0028', N'Sữa tắm Lifebouy bảo vệ vượt trội 850g', 115000, 80, '2026-03-31', 'CAT005', 'CN03', GETDATE(), GETDATE()),
('CN03_P0029', N'Khăn giấy Tempo hộp 200 tờ', 22000, 180, '2027-12-31', 'CAT005', 'CN03', GETDATE(), GETDATE()),
('CN03_P0030', N'Bông tẩy trang Silcot túi 82 miếng', 35000, 100, '2027-12-31', 'CAT005', 'CN03', GETDATE(), GETDATE());

-- ============================================
-- PRODUCT - Sản phẩm CN04 (30 sản phẩm)
-- ============================================
INSERT INTO product (id, name, price, quantity, exp_date, cate_id, store_id, created_date, updated_date) VALUES
('CN04_P0001', N'Coca Cola 330ml', 10000, 440, '2025-12-31', 'CAT001', 'CN04', GETDATE(), GETDATE()),
('CN04_P0002', N'Pepsi 330ml', 9500, 400, '2025-12-31', 'CAT001', 'CN04', GETDATE(), GETDATE()),
('CN04_P0003', N'7Up 330ml', 9500, 430, '2025-11-30', 'CAT001', 'CN04', GETDATE(), GETDATE()),
('CN04_P0004', N'Sting dâu 330ml', 12000, 300, '2025-10-31', 'CAT001', 'CN04', GETDATE(), GETDATE()),
('CN04_P0005', N'Revive chanh muối 500ml', 13000, 240, '2025-09-30', 'CAT001', 'CN04', GETDATE(), GETDATE()),
('CN04_P0006', N'Trà xanh 0 độ Không độ 450ml', 11000, 280, '2025-08-31', 'CAT001', 'CN04', GETDATE(), GETDATE()),
('CN04_P0007', N'Number 1 Sôcôla 220ml', 8000, 380, '2025-12-15', 'CAT001', 'CN04', GETDATE(), GETDATE()),
('CN04_P0008', N'Aquafina 500ml', 5000, 700, '2026-12-31', 'CAT001', 'CN04', GETDATE(), GETDATE()),
('CN04_P0009', N'Lavie 500ml', 4500, 660, '2026-12-31', 'CAT001', 'CN04', GETDATE(), GETDATE()),
('CN04_P0010', N'C2 Hương Đào 455ml', 10000, 260, '2025-07-31', 'CAT001', 'CN04', GETDATE(), GETDATE()),
('CN04_P0011', N'Snack Oishi Tôm Cay 40g', 5000, 530, '2025-06-30', 'CAT002', 'CN04', GETDATE(), GETDATE()),
('CN04_P0012', N'Bánh Oreo Original 133g', 18000, 210, '2025-08-15', 'CAT002', 'CN04', GETDATE(), GETDATE()),
('CN04_P0013', N'Kẹo Alpenliebe nhiều vị 1 túi', 22000, 150, '2025-10-31', 'CAT002', 'CN04', GETDATE(), GETDATE()),
('CN04_P0014', N'Snack Poca khoai tây vị tự nhiên 54g', 10000, 280, '2025-05-31', 'CAT002', 'CN04', GETDATE(), GETDATE()),
('CN04_P0015', N'Bánh Goute vị Sữa 15 cái', 25000, 120, '2025-07-20', 'CAT002', 'CN04', GETDATE(), GETDATE()),
('CN04_P0016', N'Kẹo Mentos Cola 3 cuộn', 15000, 170, '2025-09-30', 'CAT002', 'CN04', GETDATE(), GETDATE()),
('CN04_P0017', N'Mì Hảo Hảo Tôm Chua Cay 75g', 4000, 890, '2025-12-31', 'CAT003', 'CN04', GETDATE(), GETDATE()),
('CN04_P0018', N'Mì Omachi Xào Bò 80g', 5500, 690, '2025-11-30', 'CAT003', 'CN04', GETDATE(), GETDATE()),
('CN04_P0019', N'Mì Kokomi Tôm 60g', 3500, 850, '2025-10-31', 'CAT003', 'CN04', GETDATE(), GETDATE()),
('CN04_P0020', N'Mì 3 Miền Gold Tôm Thịt 68g', 5000, 610, '2025-09-30', 'CAT003', 'CN04', GETDATE(), GETDATE()),
('CN04_P0021', N'Sữa TH True Milk có đường 1L', 29000, 170, '2024-11-25', 'CAT004', 'CN04', GETDATE(), GETDATE()),
('CN04_P0022', N'Sữa Vinamilk 100% có đường 1L', 32000, 150, '2024-11-20', 'CAT004', 'CN04', GETDATE(), GETDATE()),
('CN04_P0023', N'Sữa chua uống Vinamilk dâu 180ml', 7000, 310, '2024-11-18', 'CAT004', 'CN04', GETDATE(), GETDATE()),
('CN04_P0024', N'Sữa Ensure Gold vani 850g', 485000, 35, '2025-06-30', 'CAT004', 'CN04', GETDATE(), GETDATE()),
('CN04_P0025', N'Sữa Dutch Lady Cô Gái Hà Lan 170ml', 8000, 250, '2024-12-15', 'CAT004', 'CN04', GETDATE(), GETDATE()),
('CN04_P0026', N'Kem đánh răng P/S bạc hà 240g', 38000, 120, '2026-12-31', 'CAT005', 'CN04', GETDATE(), GETDATE()),
('CN04_P0027', N'Dầu gội Clear Men Mát Lạnh 630g', 128000, 65, '2026-06-30', 'CAT005', 'CN04', GETDATE(), GETDATE()),
('CN04_P0028', N'Sữa tắm Lifebouy bảo vệ vượt trội 850g', 115000, 75, '2026-03-31', 'CAT005', 'CN04', GETDATE(), GETDATE()),
('CN04_P0029', N'Khăn giấy Tempo hộp 200 tờ', 22000, 170, '2027-12-31', 'CAT005', 'CN04', GETDATE(), GETDATE()),
('CN04_P0030', N'Bông tẩy trang Silcot túi 82 miếng', 35000, 90, '2027-12-31', 'CAT005', 'CN04', GETDATE(), GETDATE());

-- ============================================
-- PRODUCT - Sản phẩm CN05 (30 sản phẩm)
-- ============================================
INSERT INTO product (id, name, price, quantity, exp_date, cate_id, store_id, created_date, updated_date) VALUES
('CN05_P0001', N'Coca Cola 330ml', 10000, 520, '2025-12-31', 'CAT001', 'CN05', GETDATE(), GETDATE()),
('CN05_P0002', N'Pepsi 330ml', 9500, 470, '2025-12-31', 'CAT001', 'CN05', GETDATE(), GETDATE()),
('CN05_P0003', N'7Up 330ml', 9500, 500, '2025-11-30', 'CAT001', 'CN05', GETDATE(), GETDATE()),
('CN05_P0004', N'Sting dâu 330ml', 12000, 360, '2025-10-31', 'CAT001', 'CN05', GETDATE(), GETDATE()),
('CN05_P0005', N'Revive chanh muối 500ml', 13000, 300, '2025-09-30', 'CAT001', 'CN05', GETDATE(), GETDATE()),
('CN05_P0006', N'Trà xanh 0 độ Không độ 450ml', 11000, 340, '2025-08-31', 'CAT001', 'CN05', GETDATE(), GETDATE()),
('CN05_P0007', N'Number 1 Sôcôla 220ml', 8000, 440, '2025-12-15', 'CAT001', 'CN05', GETDATE(), GETDATE()),
('CN05_P0008', N'Aquafina 500ml', 5000, 850, '2026-12-31', 'CAT001', 'CN05', GETDATE(), GETDATE()),
('CN05_P0009', N'Lavie 500ml', 4500, 800, '2026-12-31', 'CAT001', 'CN05', GETDATE(), GETDATE()),
('CN05_P0010', N'C2 Hương Đào 455ml', 10000, 320, '2025-07-31', 'CAT001', 'CN05', GETDATE(), GETDATE()),
('CN05_P0011', N'Snack Oishi Tôm Cay 40g', 5000, 620, '2025-06-30', 'CAT002', 'CN05', GETDATE(), GETDATE()),
('CN05_P0012', N'Bánh Oreo Original 133g', 18000, 270, '2025-08-15', 'CAT002', 'CN05', GETDATE(), GETDATE()),
('CN05_P0013', N'Kẹo Alpenliebe nhiều vị 1 túi', 22000, 200, '2025-10-31', 'CAT002', 'CN05', GETDATE(), GETDATE()),
('CN05_P0014', N'Snack Poca khoai tây vị tự nhiên 54g', 10000, 360, '2025-05-31', 'CAT002', 'CN05', GETDATE(), GETDATE()),
('CN05_P0015', N'Bánh Goute vị Sữa 15 cái', 25000, 170, '2025-07-20', 'CAT002', 'CN05', GETDATE(), GETDATE()),
('CN05_P0016', N'Kẹo Mentos Cola 3 cuộn', 15000, 220, '2025-09-30', 'CAT002', 'CN05', GETDATE(), GETDATE()),
('CN05_P0017', N'Mì Hảo Hảo Tôm Chua Cay 75g', 4000, 1050, '2025-12-31', 'CAT003', 'CN05', GETDATE(), GETDATE()),
('CN05_P0018', N'Mì Omachi Xào Bò 80g', 5500, 850, '2025-11-30', 'CAT003', 'CN05', GETDATE(), GETDATE()),
('CN05_P0019', N'Mì Kokomi Tôm 60g', 3500, 1000, '2025-10-31', 'CAT003', 'CN05', GETDATE(), GETDATE()),
('CN05_P0020', N'Mì 3 Miền Gold Tôm Thịt 68g', 5000, 750, '2025-09-30', 'CAT003', 'CN05', GETDATE(), GETDATE()),
('CN05_P0021', N'Sữa TH True Milk có đường 1L', 29000, 220, '2024-11-25', 'CAT004', 'CN05', GETDATE(), GETDATE()),
('CN05_P0022', N'Sữa Vinamilk 100% có đường 1L', 32000, 200, '2024-11-20', 'CAT004', 'CN05', GETDATE(), GETDATE()),
('CN05_P0023', N'Sữa chua uống Vinamilk dâu 180ml', 7000, 380, '2024-11-18', 'CAT004', 'CN05', GETDATE(), GETDATE()),
('CN05_P0024', N'Sữa Ensure Gold vani 850g', 485000, 55, '2025-06-30', 'CAT004', 'CN05', GETDATE(), GETDATE()),
('CN05_P0025', N'Sữa Dutch Lady Cô Gái Hà Lan 170ml', 8000, 300, '2024-12-15', 'CAT004', 'CN05', GETDATE(), GETDATE()),
('CN05_P0026', N'Kem đánh răng P/S bạc hà 240g', 38000, 170, '2026-12-31', 'CAT005', 'CN05', GETDATE(), GETDATE()),
('CN05_P0027', N'Dầu gội Clear Men Mát Lạnh 630g', 128000, 90, '2026-06-30', 'CAT005', 'CN05', GETDATE(), GETDATE()),
('CN05_P0028', N'Sữa tắm Lifebouy bảo vệ vượt trội 850g', 115000, 100, '2026-03-31', 'CAT005', 'CN05', GETDATE(), GETDATE()),
('CN05_P0029', N'Khăn giấy Tempo hộp 200 tờ', 22000, 220, '2027-12-31', 'CAT005', 'CN05', GETDATE(), GETDATE()),
('CN05_P0030', N'Bông tẩy trang Silcot túi 82 miếng', 35000, 140, '2027-12-31', 'CAT005', 'CN05', GETDATE(), GETDATE());

-- ============================================
-- PRODUCT - Sản phẩm CN06 (30 sản phẩm)
-- ============================================
INSERT INTO product (id, name, price, quantity, exp_date, cate_id, store_id, created_date, updated_date) VALUES
('CN06_P0001', N'Coca Cola 330ml', 10000, 600, '2025-12-31', 'CAT001', 'CN06', GETDATE(), GETDATE()),
('CN06_P0002', N'Pepsi 330ml', 9500, 550, '2025-12-31', 'CAT001', 'CN06', GETDATE(), GETDATE()),
('CN06_P0003', N'7Up 330ml', 9500, 580, '2025-11-30', 'CAT001', 'CN06', GETDATE(), GETDATE()),
('CN06_P0004', N'Sting dâu 330ml', 12000, 400, '2025-10-31', 'CAT001', 'CN06', GETDATE(), GETDATE()),
('CN06_P0005', N'Revive chanh muối 500ml', 13000, 340, '2025-09-30', 'CAT001', 'CN06', GETDATE(), GETDATE()),
('CN06_P0006', N'Trà xanh 0 độ Không độ 450ml', 11000, 380, '2025-08-31', 'CAT001', 'CN06', GETDATE(), GETDATE()),
('CN06_P0007', N'Number 1 Sôcôla 220ml', 8000, 480, '2025-12-15', 'CAT001', 'CN06', GETDATE(), GETDATE()),
('CN06_P0008', N'Aquafina 500ml', 5000, 950, '2026-12-31', 'CAT001', 'CN06', GETDATE(), GETDATE()),
('CN06_P0009', N'Lavie 500ml', 4500, 900, '2026-12-31', 'CAT001', 'CN06', GETDATE(), GETDATE()),
('CN06_P0010', N'C2 Hương Đào 455ml', 10000, 360, '2025-07-31', 'CAT001', 'CN06', GETDATE(), GETDATE()),
('CN06_P0011', N'Snack Oishi Tôm Cay 40g', 5000, 700, '2025-06-30', 'CAT002', 'CN06', GETDATE(), GETDATE()),
('CN06_P0012', N'Bánh Oreo Original 133g', 18000, 300, '2025-08-15', 'CAT002', 'CN06', GETDATE(), GETDATE()),
('CN06_P0013', N'Kẹo Alpenliebe nhiều vị 1 túi', 22000, 230, '2025-10-31', 'CAT002', 'CN06', GETDATE(), GETDATE()),
('CN06_P0014', N'Snack Poca khoai tây vị tự nhiên 54g', 10000, 400, '2025-05-31', 'CAT002', 'CN06', GETDATE(), GETDATE()),
('CN06_P0015', N'Bánh Goute vị Sữa 15 cái', 25000, 200, '2025-07-20', 'CAT002', 'CN06', GETDATE(), GETDATE()),
('CN06_P0016', N'Kẹo Mentos Cola 3 cuộn', 15000, 250, '2025-09-30', 'CAT002', 'CN06', GETDATE(), GETDATE()),
('CN06_P0017', N'Mì Hảo Hảo Tôm Chua Cay 75g', 4000, 1200, '2025-12-31', 'CAT003', 'CN06', GETDATE(), GETDATE()),
('CN06_P0018', N'Mì Omachi Xào Bò 80g', 5500, 1000, '2025-11-30', 'CAT003', 'CN06', GETDATE(), GETDATE()),
('CN06_P0019', N'Mì Kokomi Tôm 60g', 3500, 1150, '2025-10-31', 'CAT003', 'CN06', GETDATE(), GETDATE()),
('CN06_P0020', N'Mì 3 Miền Gold Tôm Thịt 68g', 5000, 850, '2025-09-30', 'CAT003', 'CN06', GETDATE(), GETDATE()),
('CN06_P0021', N'Sữa TH True Milk có đường 1L', 29000, 250, '2024-11-25', 'CAT004', 'CN06', GETDATE(), GETDATE()),
('CN06_P0022', N'Sữa Vinamilk 100% có đường 1L', 32000, 230, '2024-11-20', 'CAT004', 'CN06', GETDATE(), GETDATE()),
('CN06_P0023', N'Sữa chua uống Vinamilk dâu 180ml', 7000, 420, '2024-11-18', 'CAT004', 'CN06', GETDATE(), GETDATE()),
('CN06_P0024', N'Sữa Ensure Gold vani 850g', 485000, 60, '2025-06-30', 'CAT004', 'CN06', GETDATE(), GETDATE()),
('CN06_P0025', N'Sữa Dutch Lady Cô Gái Hà Lan 170ml', 8000, 350, '2024-12-15', 'CAT004', 'CN06', GETDATE(), GETDATE()),
('CN06_P0026', N'Kem đánh răng P/S bạc hà 240g', 38000, 200, '2026-12-31', 'CAT005', 'CN06', GETDATE(), GETDATE()),
('CN06_P0027', N'Dầu gội Clear Men Mát Lạnh 630g', 128000, 100, '2026-06-30', 'CAT005', 'CN06', GETDATE(), GETDATE()),
('CN06_P0028', N'Sữa tắm Lifebouy bảo vệ vượt trội 850g', 115000, 110, '2026-03-31', 'CAT005', 'CN06', GETDATE(), GETDATE()),
('CN06_P0029', N'Khăn giấy Tempo hộp 200 tờ', 22000, 250, '2027-12-31', 'CAT005', 'CN06', GETDATE(), GETDATE()),
('CN06_P0030', N'Bông tẩy trang Silcot túi 82 miếng', 35000, 160, '2027-12-31', 'CAT005', 'CN06', GETDATE(), GETDATE());

-- ============================================
-- PRODUCT - Sản phẩm CN07 (30 sản phẩm)
-- ============================================
INSERT INTO product (id, name, price, quantity, exp_date, cate_id, store_id, created_date, updated_date) VALUES
('CN07_P0001', N'Coca Cola 330ml', 10000, 590, '2025-12-31', 'CAT001', 'CN07', GETDATE(), GETDATE()),
('CN07_P0002', N'Pepsi 330ml', 9500, 540, '2025-12-31', 'CAT001', 'CN07', GETDATE(), GETDATE()),
('CN07_P0003', N'7Up 330ml', 9500, 570, '2025-11-30', 'CAT001', 'CN07', GETDATE(), GETDATE()),
('CN07_P0004', N'Sting dâu 330ml', 12000, 390, '2025-10-31', 'CAT001', 'CN07', GETDATE(), GETDATE()),
('CN07_P0005', N'Revive chanh muối 500ml', 13000, 330, '2025-09-30', 'CAT001', 'CN07', GETDATE(), GETDATE()),
('CN07_P0006', N'Trà xanh 0 độ Không độ 450ml', 11000, 370, '2025-08-31', 'CAT001', 'CN07', GETDATE(), GETDATE()),
('CN07_P0007', N'Number 1 Sôcôla 220ml', 8000, 470, '2025-12-15', 'CAT001', 'CN07', GETDATE(), GETDATE()),
('CN07_P0008', N'Aquafina 500ml', 5000, 940, '2026-12-31', 'CAT001', 'CN07', GETDATE(), GETDATE()),
('CN07_P0009', N'Lavie 500ml', 4500, 890, '2026-12-31', 'CAT001', 'CN07', GETDATE(), GETDATE()),
('CN07_P0010', N'C2 Hương Đào 455ml', 10000, 350, '2025-07-31', 'CAT001', 'CN07', GETDATE(), GETDATE()),
('CN07_P0011', N'Snack Oishi Tôm Cay 40g', 5000, 690, '2025-06-30', 'CAT002', 'CN07', GETDATE(), GETDATE()),
('CN07_P0012', N'Bánh Oreo Original 133g', 18000, 290, '2025-08-15', 'CAT002', 'CN07', GETDATE(), GETDATE()),
('CN07_P0013', N'Kẹo Alpenliebe nhiều vị 1 túi', 22000, 220, '2025-10-31', 'CAT002', 'CN07', GETDATE(), GETDATE()),
('CN07_P0014', N'Snack Poca khoai tây vị tự nhiên 54g', 10000, 390, '2025-05-31', 'CAT002', 'CN07', GETDATE(), GETDATE()),
('CN07_P0015', N'Bánh Goute vị Sữa 15 cái', 25000, 190, '2025-07-20', 'CAT002', 'CN07', GETDATE(), GETDATE()),
('CN07_P0016', N'Kẹo Mentos Cola 3 cuộn', 15000, 240, '2025-09-30', 'CAT002', 'CN07', GETDATE(), GETDATE()),
('CN07_P0017', N'Mì Hảo Hảo Tôm Chua Cay 75g', 4000, 1180, '2025-12-31', 'CAT003', 'CN07', GETDATE(), GETDATE()),
('CN07_P0018', N'Mì Omachi Xào Bò 80g', 5500, 980, '2025-11-30', 'CAT003', 'CN07', GETDATE(), GETDATE()),
('CN07_P0019', N'Mì Kokomi Tôm 60g', 3500, 1130, '2025-10-31', 'CAT003', 'CN07', GETDATE(), GETDATE()),
('CN07_P0020', N'Mì 3 Miền Gold Tôm Thịt 68g', 5000, 830, '2025-09-30', 'CAT003', 'CN07', GETDATE(), GETDATE()),
('CN07_P0021', N'Sữa TH True Milk có đường 1L', 29000, 240, '2024-11-25', 'CAT004', 'CN07', GETDATE(), GETDATE()),
('CN07_P0022', N'Sữa Vinamilk 100% có đường 1L', 32000, 220, '2024-11-20', 'CAT004', 'CN07', GETDATE(), GETDATE()),
('CN07_P0023', N'Sữa chua uống Vinamilk dâu 180ml', 7000, 410, '2024-11-18', 'CAT004', 'CN07', GETDATE(), GETDATE()),
('CN07_P0024', N'Sữa Ensure Gold vani 850g', 485000, 58, '2025-06-30', 'CAT004', 'CN07', GETDATE(), GETDATE()),
('CN07_P0025', N'Sữa Dutch Lady Cô Gái Hà Lan 170ml', 8000, 340, '2024-12-15', 'CAT004', 'CN07', GETDATE(), GETDATE()),
('CN07_P0026', N'Kem đánh răng P/S bạc hà 240g', 38000, 190, '2026-12-31', 'CAT005', 'CN07', GETDATE(), GETDATE()),
('CN07_P0027', N'Dầu gội Clear Men Mát Lạnh 630g', 128000, 95, '2026-06-30', 'CAT005', 'CN07', GETDATE(), GETDATE()),
('CN07_P0028', N'Sữa tắm Lifebouy bảo vệ vượt trội 850g', 115000, 105, '2026-03-31', 'CAT005', 'CN07', GETDATE(), GETDATE()),
('CN07_P0029', N'Khăn giấy Tempo hộp 200 tờ', 22000, 240, '2027-12-31', 'CAT005', 'CN07', GETDATE(), GETDATE()),
('CN07_P0030', N'Bông tẩy trang Silcot túi 82 miếng', 35000, 150, '2027-12-31', 'CAT005', 'CN07', GETDATE(), GETDATE());

PRINT 'Product: 210 sản phẩm (30 sản phẩm x 7 chi nhánh) ✓';

-- ============================================
-- 6. BILL - Hóa đơn (10 hóa đơn)
-- Format: {storeId}_B00001, {storeId}_B00002, ...
-- Enum values: CASH, TRANSFER, CARD, MOMO, VNPAY
-- ============================================
INSERT INTO bill (id, cus_id, emp_id, discount, total_price, payment_date, payment_method, created_date, updated_date) VALUES
('CN01_B00001', 'CUS0001', 'CN01_EMP004', 15, 425000.00, '2024-11-01 09:15:00', 'CASH', GETDATE(), GETDATE()),
('CN01_B00002', 'CUS0002', 'CN01_EMP004', 10, 234000.00, '2024-11-01 10:30:00', 'TRANSFER', GETDATE(), GETDATE()),
('CN01_B00003', 'CUS0003', 'CN01_EMP005', 10, 156000.00, '2024-11-02 14:20:00', 'CARD', GETDATE(), GETDATE()),
('CN01_B00004', 'CUS0004', 'CN01_EMP005', 5, 95000.00, '2024-11-03 16:45:00', 'CASH', GETDATE(), GETDATE()),
('CN01_B00005', NULL, 'CN01_EMP004', 0, 85000.00, '2024-11-03 18:10:00', 'CASH', GETDATE(), GETDATE()),
('CN01_B00006', 'CUS0005', 'CN01_EMP005', 5, 142500.00, '2024-11-04 11:00:00', 'TRANSFER', GETDATE(), GETDATE()),
('CN01_B00007', NULL, 'CN01_EMP004', 0, 67000.00, '2024-11-04 15:30:00', 'CASH', GETDATE(), GETDATE()),
('CN01_B00008', 'CUS0006', 'CN01_EMP005', 0, 235000.00, '2024-11-05 09:20:00', 'CARD', GETDATE(), GETDATE()),
('CN01_B00009', NULL, 'CN01_EMP004', 0, 128000.00, '2024-11-05 13:45:00', 'MOMO', GETDATE(), GETDATE()),
('CN01_B00010', 'CUS0007', 'CN01_EMP005', 0, 89000.00, '2024-11-06 17:15:00', 'VNPAY', GETDATE(), GETDATE());

-- ============================================
-- BILL - Hóa đơn CN02 (10 hóa đơn)
-- ============================================
INSERT INTO bill (id, cus_id, emp_id, discount, total_price, payment_date, payment_method, created_date, updated_date) VALUES
('CN02_B00001', 'CUS0001', 'CN02_EMP004', 15, 410000.00, '2024-11-01 10:00:00', 'CASH', GETDATE(), GETDATE()),
('CN02_B00002', 'CUS0002', 'CN02_EMP004', 10, 220000.00, '2024-11-01 11:15:00', 'TRANSFER', GETDATE(), GETDATE()),
('CN02_B00003', 'CUS0003', 'CN02_EMP005', 10, 148000.00, '2024-11-02 15:00:00', 'CARD', GETDATE(), GETDATE()),
('CN02_B00004', 'CUS0004', 'CN02_EMP005', 5, 92000.00, '2024-11-03 17:00:00', 'CASH', GETDATE(), GETDATE()),
('CN02_B00005', NULL, 'CN02_EMP004', 0, 82000.00, '2024-11-03 18:30:00', 'CASH', GETDATE(), GETDATE()),
('CN02_B00006', 'CUS0005', 'CN02_EMP005', 5, 135000.00, '2024-11-04 12:00:00', 'TRANSFER', GETDATE(), GETDATE()),
('CN02_B00007', NULL, 'CN02_EMP004', 0, 65000.00, '2024-11-04 16:00:00', 'CASH', GETDATE(), GETDATE()),
('CN02_B00008', 'CUS0006', 'CN02_EMP005', 0, 228000.00, '2024-11-05 10:00:00', 'CARD', GETDATE(), GETDATE()),
('CN02_B00009', NULL, 'CN02_EMP004', 0, 125000.00, '2024-11-05 14:00:00', 'MOMO', GETDATE(), GETDATE()),
('CN02_B00010', 'CUS0007', 'CN02_EMP005', 0, 86000.00, '2024-11-06 18:00:00', 'VNPAY', GETDATE(), GETDATE());

-- ============================================
-- BILL - Hóa đơn CN03 (10 hóa đơn)
-- ============================================
INSERT INTO bill (id, cus_id, emp_id, discount, total_price, payment_date, payment_method, created_date, updated_date) VALUES
('CN03_B00001', 'CUS0001', 'CN03_EMP004', 15, 395000.00, '2024-11-01 10:30:00', 'CASH', GETDATE(), GETDATE()),
('CN03_B00002', 'CUS0002', 'CN03_EMP004', 10, 215000.00, '2024-11-01 11:45:00', 'TRANSFER', GETDATE(), GETDATE()),
('CN03_B00003', 'CUS0003', 'CN03_EMP005', 10, 142000.00, '2024-11-02 15:30:00', 'CARD', GETDATE(), GETDATE()),
('CN03_B00004', 'CUS0004', 'CN03_EMP005', 5, 90000.00, '2024-11-03 17:30:00', 'CASH', GETDATE(), GETDATE()),
('CN03_B00005', NULL, 'CN03_EMP004', 0, 80000.00, '2024-11-03 19:00:00', 'CASH', GETDATE(), GETDATE()),
('CN03_B00006', 'CUS0005', 'CN03_EMP005', 5, 130000.00, '2024-11-04 12:30:00', 'TRANSFER', GETDATE(), GETDATE()),
('CN03_B00007', NULL, 'CN03_EMP004', 0, 63000.00, '2024-11-04 16:30:00', 'CASH', GETDATE(), GETDATE()),
('CN03_B00008', 'CUS0006', 'CN03_EMP005', 0, 220000.00, '2024-11-05 10:30:00', 'CARD', GETDATE(), GETDATE()),
('CN03_B00009', NULL, 'CN03_EMP004', 0, 120000.00, '2024-11-05 14:30:00', 'MOMO', GETDATE(), GETDATE()),
('CN03_B00010', 'CUS0007', 'CN03_EMP005', 0, 84000.00, '2024-11-06 18:30:00', 'VNPAY', GETDATE(), GETDATE());

-- ============================================
-- BILL - Hóa đơn CN04 (10 hóa đơn)
-- ============================================
INSERT INTO bill (id, cus_id, emp_id, discount, total_price, payment_date, payment_method, created_date, updated_date) VALUES
('CN04_B00001', 'CUS0001', 'CN04_EMP004', 15, 380000.00, '2024-11-01 11:00:00', 'CASH', GETDATE(), GETDATE()),
('CN04_B00002', 'CUS0002', 'CN04_EMP004', 10, 210000.00, '2024-11-01 12:00:00', 'TRANSFER', GETDATE(), GETDATE()),
('CN04_B00003', 'CUS0003', 'CN04_EMP005', 10, 138000.00, '2024-11-02 16:00:00', 'CARD', GETDATE(), GETDATE()),
('CN04_B00004', 'CUS0004', 'CN04_EMP005', 5, 88000.00, '2024-11-03 18:00:00', 'CASH', GETDATE(), GETDATE()),
('CN04_B00005', NULL, 'CN04_EMP004', 0, 78000.00, '2024-11-03 19:30:00', 'CASH', GETDATE(), GETDATE()),
('CN04_B00006', 'CUS0005', 'CN04_EMP005', 5, 128000.00, '2024-11-04 13:00:00', 'TRANSFER', GETDATE(), GETDATE()),
('CN04_B00007', NULL, 'CN04_EMP004', 0, 61000.00, '2024-11-04 17:00:00', 'CASH', GETDATE(), GETDATE()),
('CN04_B00008', 'CUS0006', 'CN04_EMP005', 0, 215000.00, '2024-11-05 11:00:00', 'CARD', GETDATE(), GETDATE()),
('CN04_B00009', NULL, 'CN04_EMP004', 0, 118000.00, '2024-11-05 15:00:00', 'MOMO', GETDATE(), GETDATE()),
('CN04_B00010', 'CUS0007', 'CN04_EMP005', 0, 82000.00, '2024-11-06 19:00:00', 'VNPAY', GETDATE(), GETDATE());

-- ============================================
-- BILL - Hóa đơn CN05 (10 hóa đơn)
-- ============================================
INSERT INTO bill (id, cus_id, emp_id, discount, total_price, payment_date, payment_method, created_date, updated_date) VALUES
('CN05_B00001', 'CUS0001', 'CN05_EMP004', 15, 450000.00, '2024-11-01 09:30:00', 'CASH', GETDATE(), GETDATE()),
('CN05_B00002', 'CUS0002', 'CN05_EMP004', 10, 245000.00, '2024-11-01 10:45:00', 'TRANSFER', GETDATE(), GETDATE()),
('CN05_B00003', 'CUS0003', 'CN05_EMP005', 10, 162000.00, '2024-11-02 14:45:00', 'CARD', GETDATE(), GETDATE()),
('CN05_B00004', 'CUS0004', 'CN05_EMP005', 5, 98000.00, '2024-11-03 17:15:00', 'CASH', GETDATE(), GETDATE()),
('CN05_B00005', NULL, 'CN05_EMP004', 0, 88000.00, '2024-11-03 18:45:00', 'CASH', GETDATE(), GETDATE()),
('CN05_B00006', 'CUS0005', 'CN05_EMP005', 5, 148000.00, '2024-11-04 11:30:00', 'TRANSFER', GETDATE(), GETDATE()),
('CN05_B00007', NULL, 'CN05_EMP004', 0, 69000.00, '2024-11-04 15:45:00', 'CASH', GETDATE(), GETDATE()),
('CN05_B00008', 'CUS0006', 'CN05_EMP005', 0, 240000.00, '2024-11-05 09:45:00', 'CARD', GETDATE(), GETDATE()),
('CN05_B00009', NULL, 'CN05_EMP004', 0, 132000.00, '2024-11-05 14:00:00', 'MOMO', GETDATE(), GETDATE()),
('CN05_B00010', 'CUS0007', 'CN05_EMP005', 0, 92000.00, '2024-11-06 17:30:00', 'VNPAY', GETDATE(), GETDATE());

-- ============================================
-- BILL - Hóa đơn CN06 (10 hóa đơn)
-- ============================================
INSERT INTO bill (id, cus_id, emp_id, discount, total_price, payment_date, payment_method, created_date, updated_date) VALUES
('CN06_B00001', 'CUS0001', 'CN06_EMP004', 15, 480000.00, '2024-11-01 08:00:00', 'CASH', GETDATE(), GETDATE()),
('CN06_B00002', 'CUS0002', 'CN06_EMP004', 10, 260000.00, '2024-11-01 09:15:00', 'TRANSFER', GETDATE(), GETDATE()),
('CN06_B00003', 'CUS0003', 'CN06_EMP005', 10, 170000.00, '2024-11-02 13:30:00', 'CARD', GETDATE(), GETDATE()),
('CN06_B00004', 'CUS0004', 'CN06_EMP005', 5, 105000.00, '2024-11-03 16:00:00', 'CASH', GETDATE(), GETDATE()),
('CN06_B00005', NULL, 'CN06_EMP004', 0, 95000.00, '2024-11-03 17:30:00', 'CASH', GETDATE(), GETDATE()),
('CN06_B00006', 'CUS0005', 'CN06_EMP005', 5, 155000.00, '2024-11-04 10:15:00', 'TRANSFER', GETDATE(), GETDATE()),
('CN06_B00007', NULL, 'CN06_EMP004', 0, 72000.00, '2024-11-04 14:30:00', 'CASH', GETDATE(), GETDATE()),
('CN06_B00008', 'CUS0006', 'CN06_EMP005', 0, 250000.00, '2024-11-05 08:30:00', 'CARD', GETDATE(), GETDATE()),
('CN06_B00009', NULL, 'CN06_EMP004', 0, 140000.00, '2024-11-05 13:00:00', 'MOMO', GETDATE(), GETDATE()),
('CN06_B00010', 'CUS0007', 'CN06_EMP005', 0, 98000.00, '2024-11-06 16:45:00', 'VNPAY', GETDATE(), GETDATE());

-- ============================================
-- BILL - Hóa đơn CN07 (10 hóa đơn)
-- ============================================
INSERT INTO bill (id, cus_id, emp_id, discount, total_price, payment_date, payment_method, created_date, updated_date) VALUES
('CN07_B00001', 'CUS0001', 'CN07_EMP004', 15, 470000.00, '2024-11-01 08:30:00', 'CASH', GETDATE(), GETDATE()),
('CN07_B00002', 'CUS0002', 'CN07_EMP004', 10, 255000.00, '2024-11-01 09:45:00', 'TRANSFER', GETDATE(), GETDATE()),
('CN07_B00003', 'CUS0003', 'CN07_EMP005', 10, 168000.00, '2024-11-02 14:00:00', 'CARD', GETDATE(), GETDATE()),
('CN07_B00004', 'CUS0004', 'CN07_EMP005', 5, 102000.00, '2024-11-03 16:30:00', 'CASH', GETDATE(), GETDATE()),
('CN07_B00005', NULL, 'CN07_EMP004', 0, 92000.00, '2024-11-03 18:00:00', 'CASH', GETDATE(), GETDATE()),
('CN07_B00006', 'CUS0005', 'CN07_EMP005', 5, 152000.00, '2024-11-04 10:45:00', 'TRANSFER', GETDATE(), GETDATE()),
('CN07_B00007', NULL, 'CN07_EMP004', 0, 70000.00, '2024-11-04 15:00:00', 'CASH', GETDATE(), GETDATE()),
('CN07_B00008', 'CUS0006', 'CN07_EMP005', 0, 245000.00, '2024-11-05 09:00:00', 'CARD', GETDATE(), GETDATE()),
('CN07_B00009', NULL, 'CN07_EMP004', 0, 138000.00, '2024-11-05 13:15:00', 'MOMO', GETDATE(), GETDATE()),
('CN07_B00010', 'CUS0007', 'CN07_EMP005', 0, 96000.00, '2024-11-06 17:00:00', 'VNPAY', GETDATE(), GETDATE());

PRINT 'Bill: 70 hóa đơn (10 hóa đơn x 7 chi nhánh) ✓';

-- ============================================
-- 7. BILL_DETAILS - Chi tiết hóa đơn
-- Format: {storeId}_{billId}_BD0001, {storeId}_{billId}_BD0002, ...
-- ============================================
INSERT INTO bill_details (id, bill_id, prod_id, quantity, created_date, updated_date) VALUES
-- CN01_B00001: 5 sản phẩm
('CN01_B00001_BD0001', 'CN01_B00001', 'CN01_P0001', 10, GETDATE(), GETDATE()),
('CN01_B00001_BD0002', 'CN01_B00001', 'CN01_P0002', 10, GETDATE(), GETDATE()),
('CN01_B00001_BD0003', 'CN01_B00001', 'CN01_P0011', 20, GETDATE(), GETDATE()),
('CN01_B00001_BD0004', 'CN01_B00001', 'CN01_P0017', 25, GETDATE(), GETDATE()),
('CN01_B00001_BD0005', 'CN01_B00001', 'CN01_P0021', 3, GETDATE(), GETDATE()),
-- CN01_B00002: 4 sản phẩm
('CN01_B00002_BD0001', 'CN01_B00002', 'CN01_P0003', 8, GETDATE(), GETDATE()),
('CN01_B00002_BD0002', 'CN01_B00002', 'CN01_P0012', 5, GETDATE(), GETDATE()),
('CN01_B00002_BD0003', 'CN01_B00002', 'CN01_P0018', 10, GETDATE(), GETDATE()),
('CN01_B00002_BD0004', 'CN01_B00002', 'CN01_P0026', 2, GETDATE(), GETDATE()),
-- CN01_B00003: 3 sản phẩm
('CN01_B00003_BD0001', 'CN01_B00003', 'CN01_P0004', 5, GETDATE(), GETDATE()),
('CN01_B00003_BD0002', 'CN01_B00003', 'CN01_P0013', 3, GETDATE(), GETDATE()),
('CN01_B00003_BD0003', 'CN01_B00003', 'CN01_P0022', 2, GETDATE(), GETDATE()),
-- CN01_B00004: 3 sản phẩm
('CN01_B00004_BD0001', 'CN01_B00004', 'CN01_P0005', 3, GETDATE(), GETDATE()),
('CN01_B00004_BD0002', 'CN01_B00004', 'CN01_P0014', 5, GETDATE(), GETDATE()),
('CN01_B00004_BD0003', 'CN01_B00004', 'CN01_P0019', 8, GETDATE(), GETDATE()),
-- CN01_B00005: 4 sản phẩm
('CN01_B00005_BD0001', 'CN01_B00005', 'CN01_P0006', 3, GETDATE(), GETDATE()),
('CN01_B00005_BD0002', 'CN01_B00005', 'CN01_P0015', 2, GETDATE(), GETDATE()),
('CN01_B00005_BD0003', 'CN01_B00005', 'CN01_P0020', 5, GETDATE(), GETDATE()),
('CN01_B00005_BD0004', 'CN01_B00005', 'CN01_P0008', 4, GETDATE(), GETDATE()),
-- CN01_B00006: 4 sản phẩm
('CN01_B00006_BD0001', 'CN01_B00006', 'CN01_P0007', 8, GETDATE(), GETDATE()),
('CN01_B00006_BD0002', 'CN01_B00006', 'CN01_P0016', 4, GETDATE(), GETDATE()),
('CN01_B00006_BD0003', 'CN01_B00006', 'CN01_P0023', 10, GETDATE(), GETDATE()),
('CN01_B00006_BD0004', 'CN01_B00006', 'CN01_P0027', 1, GETDATE(), GETDATE()),
-- CN01_B00007: 3 sản phẩm
('CN01_B00007_BD0001', 'CN01_B00007', 'CN01_P0009', 6, GETDATE(), GETDATE()),
('CN01_B00007_BD0002', 'CN01_B00007', 'CN01_P0017', 15, GETDATE(), GETDATE()),
('CN01_B00007_BD0003', 'CN01_B00007', 'CN01_P0029', 1, GETDATE(), GETDATE()),
-- CN01_B00008: 5 sản phẩm
('CN01_B00008_BD0001', 'CN01_B00008', 'CN01_P0010', 8, GETDATE(), GETDATE()),
('CN01_B00008_BD0002', 'CN01_B00008', 'CN01_P0018', 10, GETDATE(), GETDATE()),
('CN01_B00008_BD0003', 'CN01_B00008', 'CN01_P0025', 12, GETDATE(), GETDATE()),
('CN01_B00008_BD0004', 'CN01_B00008', 'CN01_P0028', 1, GETDATE(), GETDATE()),
('CN01_B00008_BD0005', 'CN01_B00008', 'CN01_P0030', 1, GETDATE(), GETDATE()),
-- CN01_B00009: 4 sản phẩm
('CN01_B00009_BD0001', 'CN01_B00009', 'CN01_P0001', 6, GETDATE(), GETDATE()),
('CN01_B00009_BD0002', 'CN01_B00009', 'CN01_P0011', 15, GETDATE(), GETDATE()),
('CN01_B00009_BD0003', 'CN01_B00009', 'CN01_P0019', 10, GETDATE(), GETDATE()),
('CN01_B00009_BD0004', 'CN01_B00009', 'CN01_P0023', 5, GETDATE(), GETDATE()),
-- CN01_B00010: 3 sản phẩm
('CN01_B00010_BD0001', 'CN01_B00010', 'CN01_P0002', 5, GETDATE(), GETDATE()),
('CN01_B00010_BD0002', 'CN01_B00010', 'CN01_P0012', 2, GETDATE(), GETDATE()),
('CN01_B00010_BD0003', 'CN01_B00010', 'CN01_P0021', 1, GETDATE(), GETDATE());

-- ============================================
-- BILL_DETAILS - Chi tiết hóa đơn CN02
-- ============================================
INSERT INTO bill_details (id, bill_id, prod_id, quantity, created_date, updated_date) VALUES
('CN02_B00001_BD0001', 'CN02_B00001', 'CN02_P0001', 10, GETDATE(), GETDATE()),
('CN02_B00001_BD0002', 'CN02_B00001', 'CN02_P0002', 10, GETDATE(), GETDATE()),
('CN02_B00001_BD0003', 'CN02_B00001', 'CN02_P0011', 20, GETDATE(), GETDATE()),
('CN02_B00001_BD0004', 'CN02_B00001', 'CN02_P0017', 25, GETDATE(), GETDATE()),
('CN02_B00001_BD0005', 'CN02_B00001', 'CN02_P0021', 3, GETDATE(), GETDATE()),
('CN02_B00002_BD0001', 'CN02_B00002', 'CN02_P0003', 8, GETDATE(), GETDATE()),
('CN02_B00002_BD0002', 'CN02_B00002', 'CN02_P0012', 5, GETDATE(), GETDATE()),
('CN02_B00002_BD0003', 'CN02_B00002', 'CN02_P0018', 10, GETDATE(), GETDATE()),
('CN02_B00002_BD0004', 'CN02_B00002', 'CN02_P0026', 2, GETDATE(), GETDATE()),
('CN02_B00003_BD0001', 'CN02_B00003', 'CN02_P0004', 5, GETDATE(), GETDATE()),
('CN02_B00003_BD0002', 'CN02_B00003', 'CN02_P0013', 3, GETDATE(), GETDATE()),
('CN02_B00003_BD0003', 'CN02_B00003', 'CN02_P0022', 2, GETDATE(), GETDATE()),
('CN02_B00004_BD0001', 'CN02_B00004', 'CN02_P0005', 3, GETDATE(), GETDATE()),
('CN02_B00004_BD0002', 'CN02_B00004', 'CN02_P0014', 5, GETDATE(), GETDATE()),
('CN02_B00004_BD0003', 'CN02_B00004', 'CN02_P0019', 8, GETDATE(), GETDATE()),
('CN02_B00005_BD0001', 'CN02_B00005', 'CN02_P0006', 3, GETDATE(), GETDATE()),
('CN02_B00005_BD0002', 'CN02_B00005', 'CN02_P0015', 2, GETDATE(), GETDATE()),
('CN02_B00005_BD0003', 'CN02_B00005', 'CN02_P0020', 5, GETDATE(), GETDATE()),
('CN02_B00005_BD0004', 'CN02_B00005', 'CN02_P0008', 4, GETDATE(), GETDATE()),
('CN02_B00006_BD0001', 'CN02_B00006', 'CN02_P0007', 8, GETDATE(), GETDATE()),
('CN02_B00006_BD0002', 'CN02_B00006', 'CN02_P0016', 4, GETDATE(), GETDATE()),
('CN02_B00006_BD0003', 'CN02_B00006', 'CN02_P0023', 10, GETDATE(), GETDATE()),
('CN02_B00006_BD0004', 'CN02_B00006', 'CN02_P0027', 1, GETDATE(), GETDATE()),
('CN02_B00007_BD0001', 'CN02_B00007', 'CN02_P0009', 6, GETDATE(), GETDATE()),
('CN02_B00007_BD0002', 'CN02_B00007', 'CN02_P0017', 15, GETDATE(), GETDATE()),
('CN02_B00007_BD0003', 'CN02_B00007', 'CN02_P0029', 1, GETDATE(), GETDATE()),
('CN02_B00008_BD0001', 'CN02_B00008', 'CN02_P0010', 8, GETDATE(), GETDATE()),
('CN02_B00008_BD0002', 'CN02_B00008', 'CN02_P0018', 10, GETDATE(), GETDATE()),
('CN02_B00008_BD0003', 'CN02_B00008', 'CN02_P0025', 12, GETDATE(), GETDATE()),
('CN02_B00008_BD0004', 'CN02_B00008', 'CN02_P0028', 1, GETDATE(), GETDATE()),
('CN02_B00008_BD0005', 'CN02_B00008', 'CN02_P0030', 1, GETDATE(), GETDATE()),
('CN02_B00009_BD0001', 'CN02_B00009', 'CN02_P0001', 6, GETDATE(), GETDATE()),
('CN02_B00009_BD0002', 'CN02_B00009', 'CN02_P0011', 15, GETDATE(), GETDATE()),
('CN02_B00009_BD0003', 'CN02_B00009', 'CN02_P0019', 10, GETDATE(), GETDATE()),
('CN02_B00009_BD0004', 'CN02_B00009', 'CN02_P0023', 5, GETDATE(), GETDATE()),
('CN02_B00010_BD0001', 'CN02_B00010', 'CN02_P0002', 5, GETDATE(), GETDATE()),
('CN02_B00010_BD0002', 'CN02_B00010', 'CN02_P0012', 2, GETDATE(), GETDATE()),
('CN02_B00010_BD0003', 'CN02_B00010', 'CN02_P0021', 1, GETDATE(), GETDATE());

-- Tương tự cho CN03-CN07 (tôi sẽ tạo pattern tương tự)
-- CN03
INSERT INTO bill_details (id, bill_id, prod_id, quantity, created_date, updated_date) VALUES
('CN03_B00001_BD0001', 'CN03_B00001', 'CN03_P0001', 10, GETDATE(), GETDATE()),
('CN03_B00001_BD0002', 'CN03_B00001', 'CN03_P0002', 10, GETDATE(), GETDATE()),
('CN03_B00001_BD0003', 'CN03_B00001', 'CN03_P0011', 20, GETDATE(), GETDATE()),
('CN03_B00001_BD0004', 'CN03_B00001', 'CN03_P0017', 25, GETDATE(), GETDATE()),
('CN03_B00001_BD0005', 'CN03_B00001', 'CN03_P0021', 3, GETDATE(), GETDATE()),
('CN03_B00002_BD0001', 'CN03_B00002', 'CN03_P0003', 8, GETDATE(), GETDATE()),
('CN03_B00002_BD0002', 'CN03_B00002', 'CN03_P0012', 5, GETDATE(), GETDATE()),
('CN03_B00002_BD0003', 'CN03_B00002', 'CN03_P0018', 10, GETDATE(), GETDATE()),
('CN03_B00002_BD0004', 'CN03_B00002', 'CN03_P0026', 2, GETDATE(), GETDATE()),
('CN03_B00003_BD0001', 'CN03_B00003', 'CN03_P0004', 5, GETDATE(), GETDATE()),
('CN03_B00003_BD0002', 'CN03_B00003', 'CN03_P0013', 3, GETDATE(), GETDATE()),
('CN03_B00003_BD0003', 'CN03_B00003', 'CN03_P0022', 2, GETDATE(), GETDATE()),
('CN03_B00004_BD0001', 'CN03_B00004', 'CN03_P0005', 3, GETDATE(), GETDATE()),
('CN03_B00004_BD0002', 'CN03_B00004', 'CN03_P0014', 5, GETDATE(), GETDATE()),
('CN03_B00004_BD0003', 'CN03_B00004', 'CN03_P0019', 8, GETDATE(), GETDATE()),
('CN03_B00005_BD0001', 'CN03_B00005', 'CN03_P0006', 3, GETDATE(), GETDATE()),
('CN03_B00005_BD0002', 'CN03_B00005', 'CN03_P0015', 2, GETDATE(), GETDATE()),
('CN03_B00005_BD0003', 'CN03_B00005', 'CN03_P0020', 5, GETDATE(), GETDATE()),
('CN03_B00005_BD0004', 'CN03_B00005', 'CN03_P0008', 4, GETDATE(), GETDATE()),
('CN03_B00006_BD0001', 'CN03_B00006', 'CN03_P0007', 8, GETDATE(), GETDATE()),
('CN03_B00006_BD0002', 'CN03_B00006', 'CN03_P0016', 4, GETDATE(), GETDATE()),
('CN03_B00006_BD0003', 'CN03_B00006', 'CN03_P0023', 10, GETDATE(), GETDATE()),
('CN03_B00006_BD0004', 'CN03_B00006', 'CN03_P0027', 1, GETDATE(), GETDATE()),
('CN03_B00007_BD0001', 'CN03_B00007', 'CN03_P0009', 6, GETDATE(), GETDATE()),
('CN03_B00007_BD0002', 'CN03_B00007', 'CN03_P0017', 15, GETDATE(), GETDATE()),
('CN03_B00007_BD0003', 'CN03_B00007', 'CN03_P0029', 1, GETDATE(), GETDATE()),
('CN03_B00008_BD0001', 'CN03_B00008', 'CN03_P0010', 8, GETDATE(), GETDATE()),
('CN03_B00008_BD0002', 'CN03_B00008', 'CN03_P0018', 10, GETDATE(), GETDATE()),
('CN03_B00008_BD0003', 'CN03_B00008', 'CN03_P0025', 12, GETDATE(), GETDATE()),
('CN03_B00008_BD0004', 'CN03_B00008', 'CN03_P0028', 1, GETDATE(), GETDATE()),
('CN03_B00008_BD0005', 'CN03_B00008', 'CN03_P0030', 1, GETDATE(), GETDATE()),
('CN03_B00009_BD0001', 'CN03_B00009', 'CN03_P0001', 6, GETDATE(), GETDATE()),
('CN03_B00009_BD0002', 'CN03_B00009', 'CN03_P0011', 15, GETDATE(), GETDATE()),
('CN03_B00009_BD0003', 'CN03_B00009', 'CN03_P0019', 10, GETDATE(), GETDATE()),
('CN03_B00009_BD0004', 'CN03_B00009', 'CN03_P0023', 5, GETDATE(), GETDATE()),
('CN03_B00010_BD0001', 'CN03_B00010', 'CN03_P0002', 5, GETDATE(), GETDATE()),
('CN03_B00010_BD0002', 'CN03_B00010', 'CN03_P0012', 2, GETDATE(), GETDATE()),
('CN03_B00010_BD0003', 'CN03_B00010', 'CN03_P0021', 1, GETDATE(), GETDATE());

-- CN04
INSERT INTO bill_details (id, bill_id, prod_id, quantity, created_date, updated_date) VALUES
('CN04_B00001_BD0001', 'CN04_B00001', 'CN04_P0001', 10, GETDATE(), GETDATE()),
('CN04_B00001_BD0002', 'CN04_B00001', 'CN04_P0002', 10, GETDATE(), GETDATE()),
('CN04_B00001_BD0003', 'CN04_B00001', 'CN04_P0011', 20, GETDATE(), GETDATE()),
('CN04_B00001_BD0004', 'CN04_B00001', 'CN04_P0017', 25, GETDATE(), GETDATE()),
('CN04_B00001_BD0005', 'CN04_B00001', 'CN04_P0021', 3, GETDATE(), GETDATE()),
('CN04_B00002_BD0001', 'CN04_B00002', 'CN04_P0003', 8, GETDATE(), GETDATE()),
('CN04_B00002_BD0002', 'CN04_B00002', 'CN04_P0012', 5, GETDATE(), GETDATE()),
('CN04_B00002_BD0003', 'CN04_B00002', 'CN04_P0018', 10, GETDATE(), GETDATE()),
('CN04_B00002_BD0004', 'CN04_B00002', 'CN04_P0026', 2, GETDATE(), GETDATE()),
('CN04_B00003_BD0001', 'CN04_B00003', 'CN04_P0004', 5, GETDATE(), GETDATE()),
('CN04_B00003_BD0002', 'CN04_B00003', 'CN04_P0013', 3, GETDATE(), GETDATE()),
('CN04_B00003_BD0003', 'CN04_B00003', 'CN04_P0022', 2, GETDATE(), GETDATE()),
('CN04_B00004_BD0001', 'CN04_B00004', 'CN04_P0005', 3, GETDATE(), GETDATE()),
('CN04_B00004_BD0002', 'CN04_B00004', 'CN04_P0014', 5, GETDATE(), GETDATE()),
('CN04_B00004_BD0003', 'CN04_B00004', 'CN04_P0019', 8, GETDATE(), GETDATE()),
('CN04_B00005_BD0001', 'CN04_B00005', 'CN04_P0006', 3, GETDATE(), GETDATE()),
('CN04_B00005_BD0002', 'CN04_B00005', 'CN04_P0015', 2, GETDATE(), GETDATE()),
('CN04_B00005_BD0003', 'CN04_B00005', 'CN04_P0020', 5, GETDATE(), GETDATE()),
('CN04_B00005_BD0004', 'CN04_B00005', 'CN04_P0008', 4, GETDATE(), GETDATE()),
('CN04_B00006_BD0001', 'CN04_B00006', 'CN04_P0007', 8, GETDATE(), GETDATE()),
('CN04_B00006_BD0002', 'CN04_B00006', 'CN04_P0016', 4, GETDATE(), GETDATE()),
('CN04_B00006_BD0003', 'CN04_B00006', 'CN04_P0023', 10, GETDATE(), GETDATE()),
('CN04_B00006_BD0004', 'CN04_B00006', 'CN04_P0027', 1, GETDATE(), GETDATE()),
('CN04_B00007_BD0001', 'CN04_B00007', 'CN04_P0009', 6, GETDATE(), GETDATE()),
('CN04_B00007_BD0002', 'CN04_B00007', 'CN04_P0017', 15, GETDATE(), GETDATE()),
('CN04_B00007_BD0003', 'CN04_B00007', 'CN04_P0029', 1, GETDATE(), GETDATE()),
('CN04_B00008_BD0001', 'CN04_B00008', 'CN04_P0010', 8, GETDATE(), GETDATE()),
('CN04_B00008_BD0002', 'CN04_B00008', 'CN04_P0018', 10, GETDATE(), GETDATE()),
('CN04_B00008_BD0003', 'CN04_B00008', 'CN04_P0025', 12, GETDATE(), GETDATE()),
('CN04_B00008_BD0004', 'CN04_B00008', 'CN04_P0028', 1, GETDATE(), GETDATE()),
('CN04_B00008_BD0005', 'CN04_B00008', 'CN04_P0030', 1, GETDATE(), GETDATE()),
('CN04_B00009_BD0001', 'CN04_B00009', 'CN04_P0001', 6, GETDATE(), GETDATE()),
('CN04_B00009_BD0002', 'CN04_B00009', 'CN04_P0011', 15, GETDATE(), GETDATE()),
('CN04_B00009_BD0003', 'CN04_B00009', 'CN04_P0019', 10, GETDATE(), GETDATE()),
('CN04_B00009_BD0004', 'CN04_B00009', 'CN04_P0023', 5, GETDATE(), GETDATE()),
('CN04_B00010_BD0001', 'CN04_B00010', 'CN04_P0002', 5, GETDATE(), GETDATE()),
('CN04_B00010_BD0002', 'CN04_B00010', 'CN04_P0012', 2, GETDATE(), GETDATE()),
('CN04_B00010_BD0003', 'CN04_B00010', 'CN04_P0021', 1, GETDATE(), GETDATE());

-- CN05-CN07 (pattern tương tự, tôi sẽ tạo đầy đủ)
-- CN05
INSERT INTO bill_details (id, bill_id, prod_id, quantity, created_date, updated_date) VALUES
('CN05_B00001_BD0001', 'CN05_B00001', 'CN05_P0001', 10, GETDATE(), GETDATE()),
('CN05_B00001_BD0002', 'CN05_B00001', 'CN05_P0002', 10, GETDATE(), GETDATE()),
('CN05_B00001_BD0003', 'CN05_B00001', 'CN05_P0011', 20, GETDATE(), GETDATE()),
('CN05_B00001_BD0004', 'CN05_B00001', 'CN05_P0017', 25, GETDATE(), GETDATE()),
('CN05_B00001_BD0005', 'CN05_B00001', 'CN05_P0021', 3, GETDATE(), GETDATE()),
('CN05_B00002_BD0001', 'CN05_B00002', 'CN05_P0003', 8, GETDATE(), GETDATE()),
('CN05_B00002_BD0002', 'CN05_B00002', 'CN05_P0012', 5, GETDATE(), GETDATE()),
('CN05_B00002_BD0003', 'CN05_B00002', 'CN05_P0018', 10, GETDATE(), GETDATE()),
('CN05_B00002_BD0004', 'CN05_B00002', 'CN05_P0026', 2, GETDATE(), GETDATE()),
('CN05_B00003_BD0001', 'CN05_B00003', 'CN05_P0004', 5, GETDATE(), GETDATE()),
('CN05_B00003_BD0002', 'CN05_B00003', 'CN05_P0013', 3, GETDATE(), GETDATE()),
('CN05_B00003_BD0003', 'CN05_B00003', 'CN05_P0022', 2, GETDATE(), GETDATE()),
('CN05_B00004_BD0001', 'CN05_B00004', 'CN05_P0005', 3, GETDATE(), GETDATE()),
('CN05_B00004_BD0002', 'CN05_B00004', 'CN05_P0014', 5, GETDATE(), GETDATE()),
('CN05_B00004_BD0003', 'CN05_B00004', 'CN05_P0019', 8, GETDATE(), GETDATE()),
('CN05_B00005_BD0001', 'CN05_B00005', 'CN05_P0006', 3, GETDATE(), GETDATE()),
('CN05_B00005_BD0002', 'CN05_B00005', 'CN05_P0015', 2, GETDATE(), GETDATE()),
('CN05_B00005_BD0003', 'CN05_B00005', 'CN05_P0020', 5, GETDATE(), GETDATE()),
('CN05_B00005_BD0004', 'CN05_B00005', 'CN05_P0008', 4, GETDATE(), GETDATE()),
('CN05_B00006_BD0001', 'CN05_B00006', 'CN05_P0007', 8, GETDATE(), GETDATE()),
('CN05_B00006_BD0002', 'CN05_B00006', 'CN05_P0016', 4, GETDATE(), GETDATE()),
('CN05_B00006_BD0003', 'CN05_B00006', 'CN05_P0023', 10, GETDATE(), GETDATE()),
('CN05_B00006_BD0004', 'CN05_B00006', 'CN05_P0027', 1, GETDATE(), GETDATE()),
('CN05_B00007_BD0001', 'CN05_B00007', 'CN05_P0009', 6, GETDATE(), GETDATE()),
('CN05_B00007_BD0002', 'CN05_B00007', 'CN05_P0017', 15, GETDATE(), GETDATE()),
('CN05_B00007_BD0003', 'CN05_B00007', 'CN05_P0029', 1, GETDATE(), GETDATE()),
('CN05_B00008_BD0001', 'CN05_B00008', 'CN05_P0010', 8, GETDATE(), GETDATE()),
('CN05_B00008_BD0002', 'CN05_B00008', 'CN05_P0018', 10, GETDATE(), GETDATE()),
('CN05_B00008_BD0003', 'CN05_B00008', 'CN05_P0025', 12, GETDATE(), GETDATE()),
('CN05_B00008_BD0004', 'CN05_B00008', 'CN05_P0028', 1, GETDATE(), GETDATE()),
('CN05_B00008_BD0005', 'CN05_B00008', 'CN05_P0030', 1, GETDATE(), GETDATE()),
('CN05_B00009_BD0001', 'CN05_B00009', 'CN05_P0001', 6, GETDATE(), GETDATE()),
('CN05_B00009_BD0002', 'CN05_B00009', 'CN05_P0011', 15, GETDATE(), GETDATE()),
('CN05_B00009_BD0003', 'CN05_B00009', 'CN05_P0019', 10, GETDATE(), GETDATE()),
('CN05_B00009_BD0004', 'CN05_B00009', 'CN05_P0023', 5, GETDATE(), GETDATE()),
('CN05_B00010_BD0001', 'CN05_B00010', 'CN05_P0002', 5, GETDATE(), GETDATE()),
('CN05_B00010_BD0002', 'CN05_B00010', 'CN05_P0012', 2, GETDATE(), GETDATE()),
('CN05_B00010_BD0003', 'CN05_B00010', 'CN05_P0021', 1, GETDATE(), GETDATE());

-- CN06
INSERT INTO bill_details (id, bill_id, prod_id, quantity, created_date, updated_date) VALUES
('CN06_B00001_BD0001', 'CN06_B00001', 'CN06_P0001', 10, GETDATE(), GETDATE()),
('CN06_B00001_BD0002', 'CN06_B00001', 'CN06_P0002', 10, GETDATE(), GETDATE()),
('CN06_B00001_BD0003', 'CN06_B00001', 'CN06_P0011', 20, GETDATE(), GETDATE()),
('CN06_B00001_BD0004', 'CN06_B00001', 'CN06_P0017', 25, GETDATE(), GETDATE()),
('CN06_B00001_BD0005', 'CN06_B00001', 'CN06_P0021', 3, GETDATE(), GETDATE()),
('CN06_B00002_BD0001', 'CN06_B00002', 'CN06_P0003', 8, GETDATE(), GETDATE()),
('CN06_B00002_BD0002', 'CN06_B00002', 'CN06_P0012', 5, GETDATE(), GETDATE()),
('CN06_B00002_BD0003', 'CN06_B00002', 'CN06_P0018', 10, GETDATE(), GETDATE()),
('CN06_B00002_BD0004', 'CN06_B00002', 'CN06_P0026', 2, GETDATE(), GETDATE()),
('CN06_B00003_BD0001', 'CN06_B00003', 'CN06_P0004', 5, GETDATE(), GETDATE()),
('CN06_B00003_BD0002', 'CN06_B00003', 'CN06_P0013', 3, GETDATE(), GETDATE()),
('CN06_B00003_BD0003', 'CN06_B00003', 'CN06_P0022', 2, GETDATE(), GETDATE()),
('CN06_B00004_BD0001', 'CN06_B00004', 'CN06_P0005', 3, GETDATE(), GETDATE()),
('CN06_B00004_BD0002', 'CN06_B00004', 'CN06_P0014', 5, GETDATE(), GETDATE()),
('CN06_B00004_BD0003', 'CN06_B00004', 'CN06_P0019', 8, GETDATE(), GETDATE()),
('CN06_B00005_BD0001', 'CN06_B00005', 'CN06_P0006', 3, GETDATE(), GETDATE()),
('CN06_B00005_BD0002', 'CN06_B00005', 'CN06_P0015', 2, GETDATE(), GETDATE()),
('CN06_B00005_BD0003', 'CN06_B00005', 'CN06_P0020', 5, GETDATE(), GETDATE()),
('CN06_B00005_BD0004', 'CN06_B00005', 'CN06_P0008', 4, GETDATE(), GETDATE()),
('CN06_B00006_BD0001', 'CN06_B00006', 'CN06_P0007', 8, GETDATE(), GETDATE()),
('CN06_B00006_BD0002', 'CN06_B00006', 'CN06_P0016', 4, GETDATE(), GETDATE()),
('CN06_B00006_BD0003', 'CN06_B00006', 'CN06_P0023', 10, GETDATE(), GETDATE()),
('CN06_B00006_BD0004', 'CN06_B00006', 'CN06_P0027', 1, GETDATE(), GETDATE()),
('CN06_B00007_BD0001', 'CN06_B00007', 'CN06_P0009', 6, GETDATE(), GETDATE()),
('CN06_B00007_BD0002', 'CN06_B00007', 'CN06_P0017', 15, GETDATE(), GETDATE()),
('CN06_B00007_BD0003', 'CN06_B00007', 'CN06_P0029', 1, GETDATE(), GETDATE()),
('CN06_B00008_BD0001', 'CN06_B00008', 'CN06_P0010', 8, GETDATE(), GETDATE()),
('CN06_B00008_BD0002', 'CN06_B00008', 'CN06_P0018', 10, GETDATE(), GETDATE()),
('CN06_B00008_BD0003', 'CN06_B00008', 'CN06_P0025', 12, GETDATE(), GETDATE()),
('CN06_B00008_BD0004', 'CN06_B00008', 'CN06_P0028', 1, GETDATE(), GETDATE()),
('CN06_B00008_BD0005', 'CN06_B00008', 'CN06_P0030', 1, GETDATE(), GETDATE()),
('CN06_B00009_BD0001', 'CN06_B00009', 'CN06_P0001', 6, GETDATE(), GETDATE()),
('CN06_B00009_BD0002', 'CN06_B00009', 'CN06_P0011', 15, GETDATE(), GETDATE()),
('CN06_B00009_BD0003', 'CN06_B00009', 'CN06_P0019', 10, GETDATE(), GETDATE()),
('CN06_B00009_BD0004', 'CN06_B00009', 'CN06_P0023', 5, GETDATE(), GETDATE()),
('CN06_B00010_BD0001', 'CN06_B00010', 'CN06_P0002', 5, GETDATE(), GETDATE()),
('CN06_B00010_BD0002', 'CN06_B00010', 'CN06_P0012', 2, GETDATE(), GETDATE()),
('CN06_B00010_BD0003', 'CN06_B00010', 'CN06_P0021', 1, GETDATE(), GETDATE());

-- CN07
INSERT INTO bill_details (id, bill_id, prod_id, quantity, created_date, updated_date) VALUES
('CN07_B00001_BD0001', 'CN07_B00001', 'CN07_P0001', 10, GETDATE(), GETDATE()),
('CN07_B00001_BD0002', 'CN07_B00001', 'CN07_P0002', 10, GETDATE(), GETDATE()),
('CN07_B00001_BD0003', 'CN07_B00001', 'CN07_P0011', 20, GETDATE(), GETDATE()),
('CN07_B00001_BD0004', 'CN07_B00001', 'CN07_P0017', 25, GETDATE(), GETDATE()),
('CN07_B00001_BD0005', 'CN07_B00001', 'CN07_P0021', 3, GETDATE(), GETDATE()),
('CN07_B00002_BD0001', 'CN07_B00002', 'CN07_P0003', 8, GETDATE(), GETDATE()),
('CN07_B00002_BD0002', 'CN07_B00002', 'CN07_P0012', 5, GETDATE(), GETDATE()),
('CN07_B00002_BD0003', 'CN07_B00002', 'CN07_P0018', 10, GETDATE(), GETDATE()),
('CN07_B00002_BD0004', 'CN07_B00002', 'CN07_P0026', 2, GETDATE(), GETDATE()),
('CN07_B00003_BD0001', 'CN07_B00003', 'CN07_P0004', 5, GETDATE(), GETDATE()),
('CN07_B00003_BD0002', 'CN07_B00003', 'CN07_P0013', 3, GETDATE(), GETDATE()),
('CN07_B00003_BD0003', 'CN07_B00003', 'CN07_P0022', 2, GETDATE(), GETDATE()),
('CN07_B00004_BD0001', 'CN07_B00004', 'CN07_P0005', 3, GETDATE(), GETDATE()),
('CN07_B00004_BD0002', 'CN07_B00004', 'CN07_P0014', 5, GETDATE(), GETDATE()),
('CN07_B00004_BD0003', 'CN07_B00004', 'CN07_P0019', 8, GETDATE(), GETDATE()),
('CN07_B00005_BD0001', 'CN07_B00005', 'CN07_P0006', 3, GETDATE(), GETDATE()),
('CN07_B00005_BD0002', 'CN07_B00005', 'CN07_P0015', 2, GETDATE(), GETDATE()),
('CN07_B00005_BD0003', 'CN07_B00005', 'CN07_P0020', 5, GETDATE(), GETDATE()),
('CN07_B00005_BD0004', 'CN07_B00005', 'CN07_P0008', 4, GETDATE(), GETDATE()),
('CN07_B00006_BD0001', 'CN07_B00006', 'CN07_P0007', 8, GETDATE(), GETDATE()),
('CN07_B00006_BD0002', 'CN07_B00006', 'CN07_P0016', 4, GETDATE(), GETDATE()),
('CN07_B00006_BD0003', 'CN07_B00006', 'CN07_P0023', 10, GETDATE(), GETDATE()),
('CN07_B00006_BD0004', 'CN07_B00006', 'CN07_P0027', 1, GETDATE(), GETDATE()),
('CN07_B00007_BD0001', 'CN07_B00007', 'CN07_P0009', 6, GETDATE(), GETDATE()),
('CN07_B00007_BD0002', 'CN07_B00007', 'CN07_P0017', 15, GETDATE(), GETDATE()),
('CN07_B00007_BD0003', 'CN07_B00007', 'CN07_P0029', 1, GETDATE(), GETDATE()),
('CN07_B00008_BD0001', 'CN07_B00008', 'CN07_P0010', 8, GETDATE(), GETDATE()),
('CN07_B00008_BD0002', 'CN07_B00008', 'CN07_P0018', 10, GETDATE(), GETDATE()),
('CN07_B00008_BD0003', 'CN07_B00008', 'CN07_P0025', 12, GETDATE(), GETDATE()),
('CN07_B00008_BD0004', 'CN07_B00008', 'CN07_P0028', 1, GETDATE(), GETDATE()),
('CN07_B00008_BD0005', 'CN07_B00008', 'CN07_P0030', 1, GETDATE(), GETDATE()),
('CN07_B00009_BD0001', 'CN07_B00009', 'CN07_P0001', 6, GETDATE(), GETDATE()),
('CN07_B00009_BD0002', 'CN07_B00009', 'CN07_P0011', 15, GETDATE(), GETDATE()),
('CN07_B00009_BD0003', 'CN07_B00009', 'CN07_P0019', 10, GETDATE(), GETDATE()),
('CN07_B00009_BD0004', 'CN07_B00009', 'CN07_P0023', 5, GETDATE(), GETDATE()),
('CN07_B00010_BD0001', 'CN07_B00010', 'CN07_P0002', 5, GETDATE(), GETDATE()),
('CN07_B00010_BD0002', 'CN07_B00010', 'CN07_P0012', 2, GETDATE(), GETDATE()),
('CN07_B00010_BD0003', 'CN07_B00010', 'CN07_P0021', 1, GETDATE(), GETDATE());

PRINT 'BillDetail: 259 chi tiết hóa đơn (37 x 7 chi nhánh) ✓';
GO

-- ============================================
-- 8. PAY_ROLL - Bảng lương tháng 10/2024
-- Format: {storeId}_{MMyyyy}_001, {storeId}_{MMyyyy}_002, ...
-- Lưu ý: Đảm bảo Employee đã được seed trước khi seed PayRoll
-- ============================================
-- Debug: Kiểm tra số lượng Employee đã được seed
DECLARE @empCount INT = (SELECT COUNT(*) FROM employee);
PRINT 'DEBUG: Số lượng Employee trong database: ' + CAST(@empCount AS VARCHAR(10));

-- Seed PayRoll CN01 - Chỉ insert nếu Employee tồn tại
INSERT INTO pay_roll (pay_id, emp_id, pay_month, working_hours, bonus, total, created_date, updated_date)
SELECT 'CN01_102024_001', 'CN01_EMP001', '2024-10-01', 176, 5000000, 22600000, GETDATE(), GETDATE()
WHERE EXISTS (SELECT 1 FROM employee WHERE id = 'CN01_EMP001');

INSERT INTO pay_roll (pay_id, emp_id, pay_month, working_hours, bonus, total, created_date, updated_date)
SELECT 'CN01_102024_002', 'CN01_EMP002', '2024-10-01', 176, 2000000, 10800000, GETDATE(), GETDATE()
WHERE EXISTS (SELECT 1 FROM employee WHERE id = 'CN01_EMP002');

INSERT INTO pay_roll (pay_id, emp_id, pay_month, working_hours, bonus, total, created_date, updated_date)
SELECT 'CN01_102024_003', 'CN01_EMP003', '2024-10-01', 176, 1500000, 9420000, GETDATE(), GETDATE()
WHERE EXISTS (SELECT 1 FROM employee WHERE id = 'CN01_EMP003');

INSERT INTO pay_roll (pay_id, emp_id, pay_month, working_hours, bonus, total, created_date, updated_date)
SELECT 'CN01_102024_004', 'CN01_EMP004', '2024-10-01', 176, 500000, 5780000, GETDATE(), GETDATE()
WHERE EXISTS (SELECT 1 FROM employee WHERE id = 'CN01_EMP004');

INSERT INTO pay_roll (pay_id, emp_id, pay_month, working_hours, bonus, total, created_date, updated_date)
SELECT 'CN01_102024_005', 'CN01_EMP005', '2024-10-01', 168, 400000, 5440000, GETDATE(), GETDATE()
WHERE EXISTS (SELECT 1 FROM employee WHERE id = 'CN01_EMP005');

INSERT INTO pay_roll (pay_id, emp_id, pay_month, working_hours, bonus, total, created_date, updated_date)
SELECT 'CN01_102024_006', 'CN01_EMP006', '2024-10-01', 176, 300000, 5228000, GETDATE(), GETDATE()
WHERE EXISTS (SELECT 1 FROM employee WHERE id = 'CN01_EMP006');

INSERT INTO pay_roll (pay_id, emp_id, pay_month, working_hours, bonus, total, created_date, updated_date)
SELECT 'CN01_102024_007', 'CN01_EMP007', '2024-10-01', 160, 200000, 4680000, GETDATE(), GETDATE()
WHERE EXISTS (SELECT 1 FROM employee WHERE id = 'CN01_EMP007');

INSERT INTO pay_roll (pay_id, emp_id, pay_month, working_hours, bonus, total, created_date, updated_date)
SELECT 'CN01_102024_008', 'CN01_EMP008', '2024-10-01', 176, 400000, 6032000, GETDATE(), GETDATE()
WHERE EXISTS (SELECT 1 FROM employee WHERE id = 'CN01_EMP008');

INSERT INTO pay_roll (pay_id, emp_id, pay_month, working_hours, bonus, total, created_date, updated_date)
SELECT 'CN01_102024_009', 'CN01_EMP009', '2024-10-01', 168, 300000, 5676000, GETDATE(), GETDATE()
WHERE EXISTS (SELECT 1 FROM employee WHERE id = 'CN01_EMP009');

INSERT INTO pay_roll (pay_id, emp_id, pay_month, working_hours, bonus, total, created_date, updated_date)
SELECT 'CN01_102024_010', 'CN01_EMP010', '2024-10-01', 176, 100000, 4500000, GETDATE(), GETDATE()
WHERE EXISTS (SELECT 1 FROM employee WHERE id = 'CN01_EMP010');

INSERT INTO pay_roll (pay_id, emp_id, pay_month, working_hours, bonus, total, created_date, updated_date)
SELECT 'CN01_102024_011', 'CN01_EMP011', '2024-10-01', 176, 50000, 3922000, GETDATE(), GETDATE()
WHERE EXISTS (SELECT 1 FROM employee WHERE id = 'CN01_EMP011');
GO

-- ============================================
-- PAY_ROLL - Bảng lương CN02 (10 nhân viên)
-- ============================================
INSERT INTO pay_roll (pay_id, emp_id, pay_month, working_hours, bonus, total, created_date, updated_date)
SELECT 'CN02_102024_001', 'CN02_EMP001', '2024-10-01', 176, 5000000, 22600000, GETDATE(), GETDATE()
WHERE EXISTS (SELECT 1 FROM employee WHERE id = 'CN02_EMP001');

INSERT INTO pay_roll (pay_id, emp_id, pay_month, working_hours, bonus, total, created_date, updated_date)
SELECT 'CN02_102024_002', 'CN02_EMP002', '2024-10-01', 176, 2000000, 10800000, GETDATE(), GETDATE()
WHERE EXISTS (SELECT 1 FROM employee WHERE id = 'CN02_EMP002');

INSERT INTO pay_roll (pay_id, emp_id, pay_month, working_hours, bonus, total, created_date, updated_date)
SELECT 'CN02_102024_003', 'CN02_EMP003', '2024-10-01', 176, 1500000, 9420000, GETDATE(), GETDATE()
WHERE EXISTS (SELECT 1 FROM employee WHERE id = 'CN02_EMP003');

INSERT INTO pay_roll (pay_id, emp_id, pay_month, working_hours, bonus, total, created_date, updated_date)
SELECT 'CN02_102024_004', 'CN02_EMP004', '2024-10-01', 176, 500000, 5780000, GETDATE(), GETDATE()
WHERE EXISTS (SELECT 1 FROM employee WHERE id = 'CN02_EMP004');

INSERT INTO pay_roll (pay_id, emp_id, pay_month, working_hours, bonus, total, created_date, updated_date)
SELECT 'CN02_102024_005', 'CN02_EMP005', '2024-10-01', 168, 400000, 5440000, GETDATE(), GETDATE()
WHERE EXISTS (SELECT 1 FROM employee WHERE id = 'CN02_EMP005');

INSERT INTO pay_roll (pay_id, emp_id, pay_month, working_hours, bonus, total, created_date, updated_date)
SELECT 'CN02_102024_006', 'CN02_EMP006', '2024-10-01', 176, 300000, 5228000, GETDATE(), GETDATE()
WHERE EXISTS (SELECT 1 FROM employee WHERE id = 'CN02_EMP006');

INSERT INTO pay_roll (pay_id, emp_id, pay_month, working_hours, bonus, total, created_date, updated_date)
SELECT 'CN02_102024_007', 'CN02_EMP007', '2024-10-01', 160, 200000, 4680000, GETDATE(), GETDATE()
WHERE EXISTS (SELECT 1 FROM employee WHERE id = 'CN02_EMP007');

INSERT INTO pay_roll (pay_id, emp_id, pay_month, working_hours, bonus, total, created_date, updated_date)
SELECT 'CN02_102024_008', 'CN02_EMP008', '2024-10-01', 176, 400000, 6032000, GETDATE(), GETDATE()
WHERE EXISTS (SELECT 1 FROM employee WHERE id = 'CN02_EMP008');

INSERT INTO pay_roll (pay_id, emp_id, pay_month, working_hours, bonus, total, created_date, updated_date)
SELECT 'CN02_102024_009', 'CN02_EMP009', '2024-10-01', 168, 300000, 5676000, GETDATE(), GETDATE()
WHERE EXISTS (SELECT 1 FROM employee WHERE id = 'CN02_EMP009');

INSERT INTO pay_roll (pay_id, emp_id, pay_month, working_hours, bonus, total, created_date, updated_date)
SELECT 'CN02_102024_010', 'CN02_EMP010', '2024-10-01', 176, 100000, 4500000, GETDATE(), GETDATE()
WHERE EXISTS (SELECT 1 FROM employee WHERE id = 'CN02_EMP010');
GO

-- CN03
INSERT INTO pay_roll (pay_id, emp_id, pay_month, working_hours, bonus, total, created_date, updated_date)
SELECT 'CN03_102024_001', 'CN03_EMP001', '2024-10-01', 176, 5000000, 22600000, GETDATE(), GETDATE()
WHERE EXISTS (SELECT 1 FROM employee WHERE id = 'CN03_EMP001');

INSERT INTO pay_roll (pay_id, emp_id, pay_month, working_hours, bonus, total, created_date, updated_date)
SELECT 'CN03_102024_002', 'CN03_EMP002', '2024-10-01', 176, 2000000, 10800000, GETDATE(), GETDATE()
WHERE EXISTS (SELECT 1 FROM employee WHERE id = 'CN03_EMP002');

INSERT INTO pay_roll (pay_id, emp_id, pay_month, working_hours, bonus, total, created_date, updated_date)
SELECT 'CN03_102024_003', 'CN03_EMP003', '2024-10-01', 176, 1500000, 9420000, GETDATE(), GETDATE()
WHERE EXISTS (SELECT 1 FROM employee WHERE id = 'CN03_EMP003');

INSERT INTO pay_roll (pay_id, emp_id, pay_month, working_hours, bonus, total, created_date, updated_date)
SELECT 'CN03_102024_004', 'CN03_EMP004', '2024-10-01', 176, 500000, 5780000, GETDATE(), GETDATE()
WHERE EXISTS (SELECT 1 FROM employee WHERE id = 'CN03_EMP004');

INSERT INTO pay_roll (pay_id, emp_id, pay_month, working_hours, bonus, total, created_date, updated_date)
SELECT 'CN03_102024_005', 'CN03_EMP005', '2024-10-01', 168, 400000, 5440000, GETDATE(), GETDATE()
WHERE EXISTS (SELECT 1 FROM employee WHERE id = 'CN03_EMP005');

INSERT INTO pay_roll (pay_id, emp_id, pay_month, working_hours, bonus, total, created_date, updated_date)
SELECT 'CN03_102024_006', 'CN03_EMP006', '2024-10-01', 176, 300000, 5228000, GETDATE(), GETDATE()
WHERE EXISTS (SELECT 1 FROM employee WHERE id = 'CN03_EMP006');

INSERT INTO pay_roll (pay_id, emp_id, pay_month, working_hours, bonus, total, created_date, updated_date)
SELECT 'CN03_102024_007', 'CN03_EMP007', '2024-10-01', 160, 200000, 4680000, GETDATE(), GETDATE()
WHERE EXISTS (SELECT 1 FROM employee WHERE id = 'CN03_EMP007');

INSERT INTO pay_roll (pay_id, emp_id, pay_month, working_hours, bonus, total, created_date, updated_date)
SELECT 'CN03_102024_008', 'CN03_EMP008', '2024-10-01', 176, 400000, 6032000, GETDATE(), GETDATE()
WHERE EXISTS (SELECT 1 FROM employee WHERE id = 'CN03_EMP008');

INSERT INTO pay_roll (pay_id, emp_id, pay_month, working_hours, bonus, total, created_date, updated_date)
SELECT 'CN03_102024_009', 'CN03_EMP009', '2024-10-01', 168, 300000, 5676000, GETDATE(), GETDATE()
WHERE EXISTS (SELECT 1 FROM employee WHERE id = 'CN03_EMP009');

INSERT INTO pay_roll (pay_id, emp_id, pay_month, working_hours, bonus, total, created_date, updated_date)
SELECT 'CN03_102024_010', 'CN03_EMP010', '2024-10-01', 176, 100000, 4500000, GETDATE(), GETDATE()
WHERE EXISTS (SELECT 1 FROM employee WHERE id = 'CN03_EMP010');
GO

-- CN04
INSERT INTO pay_roll (pay_id, emp_id, pay_month, working_hours, bonus, total, created_date, updated_date)
SELECT 'CN04_102024_001', 'CN04_EMP001', '2024-10-01', 176, 5000000, 22600000, GETDATE(), GETDATE()
WHERE EXISTS (SELECT 1 FROM employee WHERE id = 'CN04_EMP001');

INSERT INTO pay_roll (pay_id, emp_id, pay_month, working_hours, bonus, total, created_date, updated_date)
SELECT 'CN04_102024_002', 'CN04_EMP002', '2024-10-01', 176, 2000000, 10800000, GETDATE(), GETDATE()
WHERE EXISTS (SELECT 1 FROM employee WHERE id = 'CN04_EMP002');

INSERT INTO pay_roll (pay_id, emp_id, pay_month, working_hours, bonus, total, created_date, updated_date)
SELECT 'CN04_102024_003', 'CN04_EMP003', '2024-10-01', 176, 1500000, 9420000, GETDATE(), GETDATE()
WHERE EXISTS (SELECT 1 FROM employee WHERE id = 'CN04_EMP003');

INSERT INTO pay_roll (pay_id, emp_id, pay_month, working_hours, bonus, total, created_date, updated_date)
SELECT 'CN04_102024_004', 'CN04_EMP004', '2024-10-01', 176, 500000, 5780000, GETDATE(), GETDATE()
WHERE EXISTS (SELECT 1 FROM employee WHERE id = 'CN04_EMP004');

INSERT INTO pay_roll (pay_id, emp_id, pay_month, working_hours, bonus, total, created_date, updated_date)
SELECT 'CN04_102024_005', 'CN04_EMP005', '2024-10-01', 168, 400000, 5440000, GETDATE(), GETDATE()
WHERE EXISTS (SELECT 1 FROM employee WHERE id = 'CN04_EMP005');

INSERT INTO pay_roll (pay_id, emp_id, pay_month, working_hours, bonus, total, created_date, updated_date)
SELECT 'CN04_102024_006', 'CN04_EMP006', '2024-10-01', 176, 300000, 5228000, GETDATE(), GETDATE()
WHERE EXISTS (SELECT 1 FROM employee WHERE id = 'CN04_EMP006');

INSERT INTO pay_roll (pay_id, emp_id, pay_month, working_hours, bonus, total, created_date, updated_date)
SELECT 'CN04_102024_007', 'CN04_EMP007', '2024-10-01', 160, 200000, 4680000, GETDATE(), GETDATE()
WHERE EXISTS (SELECT 1 FROM employee WHERE id = 'CN04_EMP007');

INSERT INTO pay_roll (pay_id, emp_id, pay_month, working_hours, bonus, total, created_date, updated_date)
SELECT 'CN04_102024_008', 'CN04_EMP008', '2024-10-01', 176, 400000, 6032000, GETDATE(), GETDATE()
WHERE EXISTS (SELECT 1 FROM employee WHERE id = 'CN04_EMP008');

INSERT INTO pay_roll (pay_id, emp_id, pay_month, working_hours, bonus, total, created_date, updated_date)
SELECT 'CN04_102024_009', 'CN04_EMP009', '2024-10-01', 168, 300000, 5676000, GETDATE(), GETDATE()
WHERE EXISTS (SELECT 1 FROM employee WHERE id = 'CN04_EMP009');

INSERT INTO pay_roll (pay_id, emp_id, pay_month, working_hours, bonus, total, created_date, updated_date)
SELECT 'CN04_102024_010', 'CN04_EMP010', '2024-10-01', 176, 100000, 4500000, GETDATE(), GETDATE()
WHERE EXISTS (SELECT 1 FROM employee WHERE id = 'CN04_EMP010');
GO

-- CN05
INSERT INTO pay_roll (pay_id, emp_id, pay_month, working_hours, bonus, total, created_date, updated_date)
SELECT 'CN05_102024_001', 'CN05_EMP001', '2024-10-01', 176, 5000000, 22600000, GETDATE(), GETDATE()
WHERE EXISTS (SELECT 1 FROM employee WHERE id = 'CN05_EMP001');

INSERT INTO pay_roll (pay_id, emp_id, pay_month, working_hours, bonus, total, created_date, updated_date)
SELECT 'CN05_102024_002', 'CN05_EMP002', '2024-10-01', 176, 2000000, 10800000, GETDATE(), GETDATE()
WHERE EXISTS (SELECT 1 FROM employee WHERE id = 'CN05_EMP002');

INSERT INTO pay_roll (pay_id, emp_id, pay_month, working_hours, bonus, total, created_date, updated_date)
SELECT 'CN05_102024_003', 'CN05_EMP003', '2024-10-01', 176, 1500000, 9420000, GETDATE(), GETDATE()
WHERE EXISTS (SELECT 1 FROM employee WHERE id = 'CN05_EMP003');

INSERT INTO pay_roll (pay_id, emp_id, pay_month, working_hours, bonus, total, created_date, updated_date)
SELECT 'CN05_102024_004', 'CN05_EMP004', '2024-10-01', 176, 500000, 5780000, GETDATE(), GETDATE()
WHERE EXISTS (SELECT 1 FROM employee WHERE id = 'CN05_EMP004');

INSERT INTO pay_roll (pay_id, emp_id, pay_month, working_hours, bonus, total, created_date, updated_date)
SELECT 'CN05_102024_005', 'CN05_EMP005', '2024-10-01', 168, 400000, 5440000, GETDATE(), GETDATE()
WHERE EXISTS (SELECT 1 FROM employee WHERE id = 'CN05_EMP005');

INSERT INTO pay_roll (pay_id, emp_id, pay_month, working_hours, bonus, total, created_date, updated_date)
SELECT 'CN05_102024_006', 'CN05_EMP006', '2024-10-01', 176, 300000, 5228000, GETDATE(), GETDATE()
WHERE EXISTS (SELECT 1 FROM employee WHERE id = 'CN05_EMP006');

INSERT INTO pay_roll (pay_id, emp_id, pay_month, working_hours, bonus, total, created_date, updated_date)
SELECT 'CN05_102024_007', 'CN05_EMP007', '2024-10-01', 160, 200000, 4680000, GETDATE(), GETDATE()
WHERE EXISTS (SELECT 1 FROM employee WHERE id = 'CN05_EMP007');

INSERT INTO pay_roll (pay_id, emp_id, pay_month, working_hours, bonus, total, created_date, updated_date)
SELECT 'CN05_102024_008', 'CN05_EMP008', '2024-10-01', 176, 400000, 6032000, GETDATE(), GETDATE()
WHERE EXISTS (SELECT 1 FROM employee WHERE id = 'CN05_EMP008');

INSERT INTO pay_roll (pay_id, emp_id, pay_month, working_hours, bonus, total, created_date, updated_date)
SELECT 'CN05_102024_009', 'CN05_EMP009', '2024-10-01', 168, 300000, 5676000, GETDATE(), GETDATE()
WHERE EXISTS (SELECT 1 FROM employee WHERE id = 'CN05_EMP009');

INSERT INTO pay_roll (pay_id, emp_id, pay_month, working_hours, bonus, total, created_date, updated_date)
SELECT 'CN05_102024_010', 'CN05_EMP010', '2024-10-01', 176, 100000, 4500000, GETDATE(), GETDATE()
WHERE EXISTS (SELECT 1 FROM employee WHERE id = 'CN05_EMP010');
GO

-- CN06
INSERT INTO pay_roll (pay_id, emp_id, pay_month, working_hours, bonus, total, created_date, updated_date)
SELECT 'CN06_102024_001', 'CN06_EMP001', '2024-10-01', 176, 5000000, 22600000, GETDATE(), GETDATE()
WHERE EXISTS (SELECT 1 FROM employee WHERE id = 'CN06_EMP001');

INSERT INTO pay_roll (pay_id, emp_id, pay_month, working_hours, bonus, total, created_date, updated_date)
SELECT 'CN06_102024_002', 'CN06_EMP002', '2024-10-01', 176, 2000000, 10800000, GETDATE(), GETDATE()
WHERE EXISTS (SELECT 1 FROM employee WHERE id = 'CN06_EMP002');

INSERT INTO pay_roll (pay_id, emp_id, pay_month, working_hours, bonus, total, created_date, updated_date)
SELECT 'CN06_102024_003', 'CN06_EMP003', '2024-10-01', 176, 1500000, 9420000, GETDATE(), GETDATE()
WHERE EXISTS (SELECT 1 FROM employee WHERE id = 'CN06_EMP003');

INSERT INTO pay_roll (pay_id, emp_id, pay_month, working_hours, bonus, total, created_date, updated_date)
SELECT 'CN06_102024_004', 'CN06_EMP004', '2024-10-01', 176, 500000, 5780000, GETDATE(), GETDATE()
WHERE EXISTS (SELECT 1 FROM employee WHERE id = 'CN06_EMP004');

INSERT INTO pay_roll (pay_id, emp_id, pay_month, working_hours, bonus, total, created_date, updated_date)
SELECT 'CN06_102024_005', 'CN06_EMP005', '2024-10-01', 168, 400000, 5440000, GETDATE(), GETDATE()
WHERE EXISTS (SELECT 1 FROM employee WHERE id = 'CN06_EMP005');

INSERT INTO pay_roll (pay_id, emp_id, pay_month, working_hours, bonus, total, created_date, updated_date)
SELECT 'CN06_102024_006', 'CN06_EMP006', '2024-10-01', 176, 300000, 5228000, GETDATE(), GETDATE()
WHERE EXISTS (SELECT 1 FROM employee WHERE id = 'CN06_EMP006');

INSERT INTO pay_roll (pay_id, emp_id, pay_month, working_hours, bonus, total, created_date, updated_date)
SELECT 'CN06_102024_007', 'CN06_EMP007', '2024-10-01', 160, 200000, 4680000, GETDATE(), GETDATE()
WHERE EXISTS (SELECT 1 FROM employee WHERE id = 'CN06_EMP007');

INSERT INTO pay_roll (pay_id, emp_id, pay_month, working_hours, bonus, total, created_date, updated_date)
SELECT 'CN06_102024_008', 'CN06_EMP008', '2024-10-01', 176, 400000, 6032000, GETDATE(), GETDATE()
WHERE EXISTS (SELECT 1 FROM employee WHERE id = 'CN06_EMP008');

INSERT INTO pay_roll (pay_id, emp_id, pay_month, working_hours, bonus, total, created_date, updated_date)
SELECT 'CN06_102024_009', 'CN06_EMP009', '2024-10-01', 168, 300000, 5676000, GETDATE(), GETDATE()
WHERE EXISTS (SELECT 1 FROM employee WHERE id = 'CN06_EMP009');

INSERT INTO pay_roll (pay_id, emp_id, pay_month, working_hours, bonus, total, created_date, updated_date)
SELECT 'CN06_102024_010', 'CN06_EMP010', '2024-10-01', 176, 100000, 4500000, GETDATE(), GETDATE()
WHERE EXISTS (SELECT 1 FROM employee WHERE id = 'CN06_EMP010');
GO

-- CN07
INSERT INTO pay_roll (pay_id, emp_id, pay_month, working_hours, bonus, total, created_date, updated_date)
SELECT 'CN07_102024_001', 'CN07_EMP001', '2024-10-01', 176, 5000000, 22600000, GETDATE(), GETDATE()
WHERE EXISTS (SELECT 1 FROM employee WHERE id = 'CN07_EMP001');

INSERT INTO pay_roll (pay_id, emp_id, pay_month, working_hours, bonus, total, created_date, updated_date)
SELECT 'CN07_102024_002', 'CN07_EMP002', '2024-10-01', 176, 2000000, 10800000, GETDATE(), GETDATE()
WHERE EXISTS (SELECT 1 FROM employee WHERE id = 'CN07_EMP002');

INSERT INTO pay_roll (pay_id, emp_id, pay_month, working_hours, bonus, total, created_date, updated_date)
SELECT 'CN07_102024_003', 'CN07_EMP003', '2024-10-01', 176, 1500000, 9420000, GETDATE(), GETDATE()
WHERE EXISTS (SELECT 1 FROM employee WHERE id = 'CN07_EMP003');

INSERT INTO pay_roll (pay_id, emp_id, pay_month, working_hours, bonus, total, created_date, updated_date)
SELECT 'CN07_102024_004', 'CN07_EMP004', '2024-10-01', 176, 500000, 5780000, GETDATE(), GETDATE()
WHERE EXISTS (SELECT 1 FROM employee WHERE id = 'CN07_EMP004');

INSERT INTO pay_roll (pay_id, emp_id, pay_month, working_hours, bonus, total, created_date, updated_date)
SELECT 'CN07_102024_005', 'CN07_EMP005', '2024-10-01', 168, 400000, 5440000, GETDATE(), GETDATE()
WHERE EXISTS (SELECT 1 FROM employee WHERE id = 'CN07_EMP005');

INSERT INTO pay_roll (pay_id, emp_id, pay_month, working_hours, bonus, total, created_date, updated_date)
SELECT 'CN07_102024_006', 'CN07_EMP006', '2024-10-01', 176, 300000, 5228000, GETDATE(), GETDATE()
WHERE EXISTS (SELECT 1 FROM employee WHERE id = 'CN07_EMP006');

INSERT INTO pay_roll (pay_id, emp_id, pay_month, working_hours, bonus, total, created_date, updated_date)
SELECT 'CN07_102024_007', 'CN07_EMP007', '2024-10-01', 160, 200000, 4680000, GETDATE(), GETDATE()
WHERE EXISTS (SELECT 1 FROM employee WHERE id = 'CN07_EMP007');

INSERT INTO pay_roll (pay_id, emp_id, pay_month, working_hours, bonus, total, created_date, updated_date)
SELECT 'CN07_102024_008', 'CN07_EMP008', '2024-10-01', 176, 400000, 6032000, GETDATE(), GETDATE()
WHERE EXISTS (SELECT 1 FROM employee WHERE id = 'CN07_EMP008');

INSERT INTO pay_roll (pay_id, emp_id, pay_month, working_hours, bonus, total, created_date, updated_date)
SELECT 'CN07_102024_009', 'CN07_EMP009', '2024-10-01', 168, 300000, 5676000, GETDATE(), GETDATE()
WHERE EXISTS (SELECT 1 FROM employee WHERE id = 'CN07_EMP009');

INSERT INTO pay_roll (pay_id, emp_id, pay_month, working_hours, bonus, total, created_date, updated_date)
SELECT 'CN07_102024_010', 'CN07_EMP010', '2024-10-01', 176, 100000, 4500000, GETDATE(), GETDATE()
WHERE EXISTS (SELECT 1 FROM employee WHERE id = 'CN07_EMP010');
GO

PRINT 'PayRoll: 71 bảng lương (11 CN01 + 10 x 6 chi nhánh) ✓';

-- ============================================
-- HOÀN THÀNH SEED DATA
-- ============================================
PRINT '================================================';
PRINT 'SEED DATA COMPLETED SUCCESSFULLY!';
PRINT '================================================';
PRINT 'Store: 1 trụ sở + 7 chi nhánh';
PRINT 'Category: 8 danh mục';
PRINT 'Product: 210 sản phẩm (30 sản phẩm x 7 chi nhánh)';
PRINT 'Employee: 71 nhân viên (1 ADMIN + 10 x 7 chi nhánh)';
PRINT 'Customer: 10 khách hàng';
PRINT 'Bill: 70 hóa đơn (10 hóa đơn x 7 chi nhánh)';
PRINT 'BillDetail: 259 chi tiết hóa đơn (37 x 7 chi nhánh)';
PRINT 'PayRoll: 71 bảng lương (11 CN01 + 10 x 6 chi nhánh, tháng 10/2024)';
PRINT '================================================';
PRINT 'LOGIN CREDENTIALS:';
PRINT 'Admin - Phone: 0900000000, Password: 123456';
PRINT 'Quản lý - Phone: 0901234567, Password: 123456';
PRINT 'Bán hàng - Phone: 0901234569, Password: 123456';
PRINT '================================================';
PRINT 'Payment methods: CASH, TRANSFER, CARD, MOMO, VNPAY';
PRINT '================================================';
PRINT 'NOTE: Nếu gặp lỗi FOREIGN KEY, có thể do database đã có constraint cũ.';
PRINT 'Hãy chạy script xóa constraint cũ trước khi seed data.';
PRINT '================================================';
GO


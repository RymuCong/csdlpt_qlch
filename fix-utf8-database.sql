-- ============================================
-- FIX UTF-8 ENCODING: ALTER VARCHAR -> NVARCHAR
-- Chuyển tất cả text columns sang NVARCHAR để hỗ trợ tiếng Việt
-- ============================================

USE QLCH_CN01;
GO

PRINT '================================================';
PRINT 'BẮT ĐẦU CHUYỂN VARCHAR → NVARCHAR (UTF-8)';
PRINT '================================================';

-- ============================================
-- 1. STORE - Cửa hàng
-- ============================================
PRINT 'Fixing STORE table...';

ALTER TABLE store 
ALTER COLUMN address NVARCHAR(200) NOT NULL;

PRINT '✓ Store.address: VARCHAR → NVARCHAR(200)';

-- ============================================
-- 2. CATEGORY - Danh mục
-- ============================================
PRINT 'Fixing CATEGORY table...';

ALTER TABLE category 
ALTER COLUMN name NVARCHAR(100) NOT NULL;

PRINT '✓ Category.name: VARCHAR → NVARCHAR(100)';

-- ============================================
-- 3. EMPLOYEE - Nhân viên
-- ============================================
PRINT 'Fixing EMPLOYEE table...';

ALTER TABLE employee 
ALTER COLUMN name NVARCHAR(100) NOT NULL;

ALTER TABLE employee 
ALTER COLUMN address NVARCHAR(200);

ALTER TABLE employee 
ALTER COLUMN password NVARCHAR(255) NOT NULL;

PRINT '✓ Employee.name: VARCHAR → NVARCHAR(100)';
PRINT '✓ Employee.address: VARCHAR → NVARCHAR(200)';
PRINT '✓ Employee.password: VARCHAR → NVARCHAR(255)';

-- ============================================
-- 4. CUSTOMER - Khách hàng
-- ============================================
PRINT 'Fixing CUSTOMER table...';

ALTER TABLE customer 
ALTER COLUMN name NVARCHAR(100) NOT NULL;

PRINT '✓ Customer.name: VARCHAR → NVARCHAR(100)';

-- ============================================
-- 5. PRODUCT - Sản phẩm
-- ============================================
PRINT 'Fixing PRODUCT table...';

ALTER TABLE product 
ALTER COLUMN name NVARCHAR(255) NOT NULL;

ALTER TABLE product 
ALTER COLUMN image NVARCHAR(255);

PRINT '✓ Product.name: VARCHAR → NVARCHAR(255)';
PRINT '✓ Product.image: VARCHAR → NVARCHAR(255)';

-- ============================================
-- HOÀN THÀNH
-- ============================================
PRINT '';
PRINT '================================================';
PRINT 'HOÀN THÀNH CHUYỂN ĐỔI UTF-8!';
PRINT '================================================';
PRINT 'Tất cả text columns đã được chuyển sang NVARCHAR';
PRINT 'Hệ thống đã hỗ trợ tiếng Việt đầy đủ ✓';
PRINT '================================================';

-- Kiểm tra kết quả
PRINT '';
PRINT 'Kiểm tra lại columns:';
SELECT 
    t.name AS TableName,
    c.name AS ColumnName,
    ty.name AS DataType,
    c.max_length AS MaxLength
FROM sys.tables t
INNER JOIN sys.columns c ON t.object_id = c.object_id
INNER JOIN sys.types ty ON c.user_type_id = ty.user_type_id
WHERE t.name IN ('store', 'category', 'employee', 'customer', 'product')
    AND c.name IN ('name', 'address', 'password', 'image')
ORDER BY t.name, c.name;

GO

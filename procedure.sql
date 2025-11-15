USE NHOM_CN2
GO

-- SP thêm mới Employee cho chi nhánh
CREATE PROCEDURE sp_AddEmployee
    @name NVARCHAR(100),
    @phone VARCHAR(15),
    @address NVARCHAR(200),
    @position NVARCHAR(50),
    @base_salary INT,
    @store_id NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
BEGIN TRY
BEGIN TRANSACTION;

        -- Kiểm tra store_id tồn tại
        IF NOT EXISTS (SELECT 1 FROM store WHERE id = @store_id)
BEGIN
            RAISERROR(N'Mã chi nhánh không tồn tại.', 16, 1);
ROLLBACK TRANSACTION;
RETURN;
END

        -- Kiểm tra position hợp lệ
        IF @position NOT IN (N'Quản lý chi nhánh', N'Nhân viên bán hàng')
BEGIN
            RAISERROR(N'Ví trí làm việc không hợp lệ.', 16, 1);
ROLLBACK TRANSACTION;
RETURN;
END

        -- Kiểm tra nếu là quản lý thì chi nhánh chưa có (bỏ WHERE store_id)
        IF @position = N'Quản lý chi nhánh'
           AND EXISTS (SELECT 1 FROM employee WHERE position = N'Quản lý chi nhánh')
BEGIN
            RAISERROR(N'Chi nhánh đã có quản lý.', 16, 1);
ROLLBACK TRANSACTION;
RETURN;
END

        -- Kiểm tra phone unique PER STORE (bỏ WHERE store_id, chỉ check phone)
        IF EXISTS (SELECT 1 FROM employee WHERE phone = @phone)
BEGIN
            RAISERROR(N'Số điện thoại đã được đăng ký cho nhân viên khác', 16, 1);
ROLLBACK TRANSACTION;
RETURN;
END

        -- Tạo mã nhân viên tự động (bỏ WHERE store_id)
        DECLARE @current_count INT = (SELECT COUNT(*) FROM employee WHERE store_id = @store_id);
        DECLARE @next_number INT = @current_count + 1;
        DECLARE @formatted_number VARCHAR(3) = RIGHT('000' + CAST(@next_number AS VARCHAR(3)), 3);
        DECLARE @emp_id NVARCHAR(50) = 'EMP' + @formatted_number + '_' + @store_id;

        -- Thêm nhân viên
INSERT INTO employee (id, name, phone, address, position, base_salary, store_id)
VALUES (@emp_id, @name, @phone, @address, @position, @base_salary, @store_id);

COMMIT TRANSACTION;

-- Xem bảng sau khi cập nhật
SELECT * FROM employee WHERE store_id = @store_id;
END TRY
BEGIN CATCH
IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION; -- Đảm bảo không có transaction nào đang mở
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE(); -- Lấy thông tin lỗi từ SQL Server
        RAISERROR(@ErrorMessage, 16, 1);
END CATCH
END
GO
-- Dùng SP
EXEC sp_AddEmployee
@name =  N'Test',
@phone = '0123456789',
@address =  N'Cầu Giấy, Hà Nội',
@position = N'Nhân viên bán hàng',
@base_salary = 35000,
@store_id = 'CN02'
GO

-- SP thêm Product
CREATE PROCEDURE sp_AddProduct
    @name NVARCHAR(100),
    @exp_date DATE,
    @price DECIMAL(12, 2),
    @quantity INT,
    @cate_id NVARCHAR(50),
    @store_id NVARCHAR(50) -- Validate local store
AS
BEGIN
    SET NOCOUNT ON
BEGIN TRY
BEGIN TRANSACTION

        -- Kiểm tra category tồn tại
        IF NOT EXISTS (SELECT 1 FROM category WHERE id = @cate_id)
BEGIN
            RAISERROR(N'Mã danh mục không tồn tại.', 16, 1);
ROLLBACK TRANSACTION;
RETURN;
END

        -- Kiểm tra store tồn tại
        IF NOT EXISTS (SELECT 1 FROM store WHERE id = @store_id)
BEGIN
            RAISERROR(N'Mã chi nhánh không tồn tại.', 16, 1);
ROLLBACK TRANSACTION;
RETURN;
END

        -- Kiểm tra unique name per store
        IF EXISTS (SELECT 1 FROM product WHERE name = @name AND store_id = @store_id)
BEGIN
            RAISERROR(N'Sản phẩm đã có tại chi nhánh', 16, 1);
ROLLBACK TRANSACTION;
RETURN;
END

        -- Kiểm tra hạn
        IF @exp_date IS NOT NULL AND @exp_date < CAST(GETDATE() AS DATE)
BEGIN
            RAISERROR(N'Sản phẩm đã hết hạn sử dụng', 16, 1);
ROLLBACK TRANSACTION;
RETURN;
END

        -- Tạo ID tự động per store (sharding)
        DECLARE @current_count INT = (SELECT COUNT(*) FROM product WHERE store_id = @store_id);
        DECLARE @next_number INT = @current_count + 1;
        DECLARE @formatted_number VARCHAR(3) = RIGHT('000' + CAST(@next_number AS VARCHAR(3)), 3);
        DECLARE @prod_id NVARCHAR(50) = 'P' + @formatted_number + '_' + @store_id;

        -- Insert
INSERT INTO product (id, name, exp_date, price, quantity, cate_id, store_id)
VALUES (@prod_id, @name, @exp_date, @price, @quantity, @cate_id, @store_id);

COMMIT TRANSACTION
-- Hiển thị danh sách sản phẩm sau cập nhật
SELECT * FROM product WHERE store_id = @store_id

END TRY
BEGIN CATCH
IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        DECLARE @ErrorMsg NVARCHAR(4000) = ERROR_MESSAGE()
        RAISERROR(@ErrorMsg, 16, 1)
END CATCH
END
GO
-- Dùng SP
EXEC sp_AddProduct
@name = N'Test1',
@exp_date = '2025-11-04',
@price = 30000.00,
@quantity = 30,
@cate_id = N'CAT01',
@store_id = N'CN02'
GO

-- SP thêm Pay_Roll
CREATE PROCEDURE sp_AddPayRoll
    @emp_id NVARCHAR(50),
    @pay_month DATE,
    @working_hours INT,
    @bonus INT = 0
AS
BEGIN
    SET NOCOUNT ON;
BEGIN TRY
BEGIN TRANSACTION;

        -- Kiểm tra emp_id tồn tại (local)
        IF NOT EXISTS (SELECT 1 FROM employee WHERE id = @emp_id)
BEGIN
            RAISERROR(N'Mã nhân viên không tồn tại.', 16, 1);
ROLLBACK TRANSACTION;
RETURN;
END

        -- Kiểm tra unique pay_month per emp (business, local)
        IF EXISTS (SELECT 1 FROM pay_roll WHERE emp_id = @emp_id AND pay_month = @pay_month)
BEGIN
            RAISERROR(N'Bảng lương cho tháng này đã tồn tại.', 16, 1);
ROLLBACK TRANSACTION;
RETURN;
END

        -- Kiểm tra CHECK working_hours >= 0, bonus >= 0
        IF @working_hours < 0 OR @bonus < 0
BEGIN
            RAISERROR(N'Giờ làm và thưởng phải >= 0.', 16, 1);
ROLLBACK TRANSACTION;
RETURN;
END

        -- Tạo pay_id per emp (local)
        DECLARE @emp_number VARCHAR(3) = SUBSTRING(@emp_id, 4, 3);  -- Lấy '001' từ 'EMP001_CN02'
        DECLARE @store_id NVARCHAR(50) = SUBSTRING(@emp_id, CHARINDEX('_', @emp_id) + 1, LEN(@emp_id));  -- Lấy 'CN02' từ 'EMP001_CN02'
        DECLARE @month_str VARCHAR(2) = FORMAT(MONTH(@pay_month), '00');  -- '10' cho tháng 10
        DECLARE @year_str VARCHAR(4) = CAST(YEAR(@pay_month) AS VARCHAR(4));  -- '2025'
        DECLARE @pay_id NVARCHAR(50) = 'PAY' + @emp_number + @store_id + @month_str + @year_str;  -- 'PAY001CN02102025'

        -- Tính total từ base_salary (local)
        DECLARE @base_salary INT = (SELECT base_salary FROM employee WHERE id = @emp_id);
        DECLARE @total INT = (@base_salary * @working_hours) + @bonus;

        -- Insert local
INSERT INTO pay_roll (pay_id, emp_id, pay_month, working_hours, bonus, total)
VALUES (@pay_id, @emp_id, @pay_month, @working_hours, @bonus, @total);

COMMIT TRANSACTION;
SELECT * FROM pay_roll;
END TRY
BEGIN CATCH
IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
END CATCH
END
GO
-- Dùng SP
EXEC sp_AddPayRoll
@emp_id = N'EMP005_CN02',
@pay_month = '2025-10-27',
@working_hours = 180,
@bonus = 0
GO

-- SP nhập hàng
CREATE PROCEDURE sp_ImportProduct
    @store_id NVARCHAR(50),
    @prod_id NVARCHAR(50),
    @quantity INT
AS
BEGIN
    SET NOCOUNT ON;
BEGIN TRY
BEGIN TRANSACTION;

        IF @quantity <= 0
BEGIN
            RAISERROR(N'Số lượng nhập phải > 0.', 16, 1);
ROLLBACK TRANSACTION;
RETURN;
END;

        IF NOT EXISTS (SELECT 1 FROM product WHERE id = @prod_id AND store_id = @store_id)
BEGIN
            RAISERROR(N'Sản phẩm chưa tồn tại trong cửa hàng này.', 16, 1);
ROLLBACK TRANSACTION;
RETURN;
END;

        -- Cập nhật tồn kho
UPDATE product
SET quantity = quantity + @quantity
WHERE id = @prod_id;

COMMIT TRANSACTION;

-- Hiển thị thông tin sau cập nhật
SELECT * FROM product WHERE id = @prod_id;
END TRY
BEGIN CATCH
IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
END CATCH
END;
GO
-- Dùng SP
EXEC sp_ImportProduct
@store_id = 'CN02',
@prod_id = 'P011_CN02',
@quantity = 30


-- Khuyến mãi
CREATE PROCEDURE sp_apply_promotion
    @bill_id NVARCHAR(50), -- Mã hóa đơn được áp dụng
    @max_discount DECIMAL(14,2) – Số tiền tối đa được giảm
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE
@cus_id NVARCHAR(50),
        @level TINYINT,
        @discount TINYINT = 0,
        @total_price DECIMAL(14,2),
        @discount_amount DECIMAL(14,2)

    -- Lấy thông tin khách hàng
SELECT @cus_id = cus_id
FROM bill
WHERE id = @bill_id;

IF @cus_id IS NULL
BEGIN
        PRINT N'Hóa đơn không có thông tin khách hàng → không áp dụng khuyến mãi.';
        RETURN;
END

    -- Lấy level khách hàng
SELECT @level = level
FROM customer
WHERE id = @cus_id;

-- Tính tổng tiền hóa đơn (trước khi giảm)
SELECT @total_price = SUM(bd.quantity * p.price)
FROM bill_details bd
         JOIN product p ON bd.prod_id = p.id
WHERE bd.bill_id = @bill_id;

IF @total_price IS NULL
BEGIN
        PRINT N'Hóa đơn chưa có sản phẩm → không áp dụng khuyến mãi.';
        RETURN;
END

    -- Tính phần trăm khuyến mãi
    IF @level = 2 SET @discount = 5;
ELSE IF @level = 3 SET @discount = 10;
ELSE IF @level = 4 SET @discount = 15;

    -- Tính số tiền giảm
    SET @discount_amount = @total_price * @discount / 100.0;

    -- Giới hạn giảm tối đa
    IF @discount_amount > @max_discount
        SET @discount_amount = @max_discount;

    -- Cập nhật hóa đơn
UPDATE bill
SET
    discount = @discount,
    total_price = @total_price - @discount_amount
WHERE id = @bill_id;

PRINT N'Áp dụng khuyến mãi: '
        + CAST(@discount AS NVARCHAR(5)) + N'% (Giảm tối đa 300k).'
        + CHAR(13) + N'Số tiền giảm thực tế: ' + CAST(@discount_amount AS NVARCHAR(20))
        + N' VNĐ';
SELECT * FROM bill WHERE id = @bill_id
END
GO



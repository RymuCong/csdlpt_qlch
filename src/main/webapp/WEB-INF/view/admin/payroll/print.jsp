<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Phiếu lương ${payroll.payId}</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Courier New', monospace;
            font-size: 12px;
            line-height: 1.4;
            color: #000;
            background: #fff;
            padding: 20px;
            max-width: 80mm;
            margin: 0 auto;
        }
        
        .receipt {
            border: 1px dashed #000;
            padding: 10px;
        }
        
        .header {
            text-align: center;
            border-bottom: 1px dashed #000;
            padding-bottom: 10px;
            margin-bottom: 10px;
        }
        
        .header h1 {
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 5px;
        }
        
        .header p {
            font-size: 11px;
            margin: 2px 0;
        }
        
        .section {
            margin: 10px 0;
            border-bottom: 1px dashed #ccc;
            padding-bottom: 10px;
        }
        
        .section:last-child {
            border-bottom: 2px solid #000;
        }
        
        .row {
            display: flex;
            justify-content: space-between;
            margin: 3px 0;
        }
        
        .label {
            font-weight: bold;
        }
        
        .total-section {
            margin-top: 10px;
            font-size: 13px;
        }
        
        .total-row {
            display: flex;
            justify-content: space-between;
            margin: 5px 0;
            font-weight: bold;
        }
        
        .grand-total {
            font-size: 16px;
            border-top: 2px solid #000;
            border-bottom: 2px solid #000;
            padding: 8px 0;
            margin-top: 5px;
        }
        
        .footer {
            text-align: center;
            margin-top: 15px;
            font-size: 11px;
        }
        
        .footer p {
            margin: 3px 0;
        }
        
        .barcode {
            text-align: center;
            font-family: 'Libre Barcode 128', cursive;
            font-size: 40px;
            margin: 10px 0;
        }
        
        @media print {
            body {
                padding: 0;
                margin: 0;
            }
            
            .receipt {
                border: none;
            }
            
            .no-print {
                display: none !important;
            }
        }
        
        .print-button {
            position: fixed;
            top: 10px;
            right: 10px;
            padding: 10px 20px;
            background: #007bff;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
        }
        
        .print-button:hover {
            background: #0056b3;
        }
    </style>
</head>
<body>
    <button class="print-button no-print" onclick="window.print()">
        🖨️ In phiếu lương
    </button>
    
    <div class="receipt">
        <!-- Header -->
        <div class="header">
            <h1>🏪 RedMart</h1>
            <p>Chuỗi Cửa Hàng Tiện Lợi</p>
            <c:if test="${payroll.employee.store != null}">
                <p>${payroll.employee.store.address}</p>
                <p>Hotline: ${payroll.employee.store.phone}</p>
            </c:if>
        </div>
        
        <!-- Payroll Info -->
        <div class="section">
            <div class="row">
                <span class="label">Mã phiếu lương:</span>
                <span>${payroll.payId}</span>
            </div>
            <div class="row">
                <span class="label">Tháng:</span>
                <span>
                    <c:set var="payMonth" value="${payroll.payMonth}" />
                    ${payMonth.monthValue < 10 ? '0' : ''}${payMonth.monthValue}/${payMonth.year}
                </span>
            </div>
            <div class="row">
                <span class="label">Nhân viên:</span>
                <span>${payroll.employee.name}</span>
            </div>
            <div class="row">
                <span class="label">Chức vụ:</span>
                <span>${payroll.employee.position.displayName}</span>
            </div>
            <div class="row">
                <span class="label">Cửa hàng:</span>
                <span>${payroll.employee.store.id}</span>
            </div>
        </div>
        
        <!-- Salary Details -->
        <div class="section">
            <div class="row">
                <span class="label">Lương cơ bản/giờ:</span>
                <span><fmt:formatNumber value="${payroll.employee.baseSalary}" type="number" pattern="#,##0" />đ</span>
            </div>
            <div class="row">
                <span class="label">Số giờ làm:</span>
                <span>${payroll.workingHours} giờ</span>
            </div>
            <div class="row">
                <span class="label">Lương cơ bản:</span>
                <span><fmt:formatNumber value="${payroll.employee.baseSalary * payroll.workingHours}" type="number" pattern="#,##0" />đ</span>
            </div>
            <c:if test="${payroll.bonus > 0}">
                <div class="row">
                    <span class="label">Thưởng:</span>
                    <span><fmt:formatNumber value="${payroll.bonus}" type="number" pattern="#,##0" />đ</span>
                </div>
            </c:if>
        </div>
        
        <!-- Totals -->
        <div class="total-section">
            <div class="total-row grand-total">
                <span>TỔNG LƯƠNG:</span>
                <span><fmt:formatNumber value="${payroll.total}" type="number" pattern="#,##0" />đ</span>
            </div>
        </div>
        
        <!-- Barcode -->
        <div class="barcode">
            *${payroll.payId}*
        </div>
        
        <!-- Footer -->
        <div class="footer">
            <p>───────────────────────────</p>
            <p><strong>Cảm ơn bạn đã làm việc!</strong></p>
            <p>Hẹn gặp lại</p>
            <p>───────────────────────────</p>
            <p style="font-size: 10px; margin-top: 10px;">
                Giờ in: <%=new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(new java.util.Date())%>
            </p>
        </div>
    </div>
    
    <script>
        // Auto print when page loads (optional)
        // window.onload = function() { window.print(); }
    </script>
</body>
</html>


<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>In hóa đơn ${bill.id}</title>
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
        
        .items-table {
            width: 100%;
            margin: 10px 0;
        }
        
        .items-table th {
            text-align: left;
            border-bottom: 1px solid #000;
            padding: 5px 0;
            font-size: 11px;
        }
        
        .items-table td {
            padding: 5px 0;
            border-bottom: 1px dashed #ccc;
        }
        
        .items-table .item-name {
            max-width: 120px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
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
        🖨️ In hóa đơn
    </button>
    
    <div class="receipt">
        <!-- Header -->
        <div class="header">
            <h1>🏪 MINIMART PLUS</h1>
            <p>Chuỗi Cửa Hàng Tiện Lợi</p>
            <c:if test="${bill.employee.store != null}">
                <p>${bill.employee.store.address}</p>
                <p>Hotline: ${bill.employee.store.phone}</p>
            </c:if>
        </div>
        
        <!-- Bill Info -->
        <div class="section">
            <div class="row">
                <span class="label">Mã hóa đơn:</span>
                <span>${bill.id}</span>
            </div>
            <div class="row">
                <span class="label">Ngày:</span>
                <span>${bill.paymentDate.toString().replace('T', ' ').substring(0, 16)}</span>
            </div>
            <div class="row">
                <span class="label">Nhân viên:</span>
                <span>${bill.employee.name}</span>
            </div>
            <c:if test="${bill.customer != null}">
                <div class="row">
                    <span class="label">Khách hàng:</span>
                    <span>${bill.customer.name}</span>
                </div>
                <div class="row">
                    <span class="label">Điện thoại:</span>
                    <span>${bill.customer.phone}</span>
                </div>
                <div class="row">
                    <span class="label">Level:</span>
                    <span>⭐ ${bill.customer.level}</span>
                </div>
            </c:if>
        </div>
        
        <!-- Items -->
        <table class="items-table">
            <thead>
                <tr>
                    <th>Sản phẩm</th>
                    <th style="text-align: right;">SL</th>
                    <th style="text-align: right;">Đơn giá</th>
                    <th style="text-align: right;">Thành tiền</th>
                </tr>
            </thead>
            <tbody>
                <c:set var="subtotal" value="0" />
                <c:forEach var="detail" items="${bill.billDetails}">
                    <c:set var="itemTotal" value="${detail.product.price * detail.quantity}" />
                    <c:set var="subtotal" value="${subtotal + itemTotal}" />
                    <tr>
                        <td class="item-name">${detail.product.name}</td>
                        <td style="text-align: right;">${detail.quantity}</td>
                        <td style="text-align: right;">
                            <fmt:formatNumber value="${detail.product.price}" type="number" pattern="#,##0" />đ
                        </td>
                        <td style="text-align: right;">
                            <fmt:formatNumber value="${itemTotal}" type="number" pattern="#,##0" />đ
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        
        <!-- Totals -->
        <div class="total-section">
            <div class="total-row">
                <span>Tổng cộng:</span>
                <span><fmt:formatNumber value="${subtotal}" type="number" pattern="#,##0" />đ</span>
            </div>
            
            <c:if test="${bill.discount > 0}">
                <div class="total-row">
                    <span>Giảm giá (${bill.discount}%):</span>
                    <span>-<fmt:formatNumber value="${subtotal * bill.discount / 100}" type="number" pattern="#,##0" />đ</span>
                </div>
            </c:if>
            
            <div class="total-row grand-total">
                <span>THANH TOÁN:</span>
                <span><fmt:formatNumber value="${bill.totalPrice}" type="number" pattern="#,##0" />đ</span>
            </div>
            
            <div class="row" style="margin-top: 10px;">
                <span class="label">Hình thức:</span>
                <span>
                    <c:choose>
                        <c:when test="${bill.paymentMethod.name() == 'CASH'}">💵 Tiền mặt</c:when>
                        <c:when test="${bill.paymentMethod.name() == 'TRANSFER'}">🏦 Chuyển khoản</c:when>
                        <c:when test="${bill.paymentMethod.name() == 'CARD'}">💳 Thẻ</c:when>
                        <c:when test="${bill.paymentMethod.name() == 'MOMO'}">📱 MoMo</c:when>
                        <c:when test="${bill.paymentMethod.name() == 'VNPAY'}">📱 VNPay</c:when>
                        <c:otherwise>${bill.paymentMethod.displayName}</c:otherwise>
                    </c:choose>
                </span>
            </div>
        </div>
        
        <!-- Barcode -->
        <div class="barcode">
            *${bill.id}*
        </div>
        
        <!-- Footer -->
        <div class="footer">
            <p>───────────────────────────</p>
            <p><strong>Cảm ơn quý khách!</strong></p>
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


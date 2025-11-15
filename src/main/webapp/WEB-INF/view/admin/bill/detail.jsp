<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <title>Chi tiết hóa đơn ${bill.id} - Hệ thống POS</title>
    <link href="/css/styles.css" rel="stylesheet" />
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
    <style>
        @media print {
            .no-print {
                display: none !important;
            }
            .card {
                border: none !important;
                box-shadow: none !important;
            }
        }
    </style>
</head>
<body class="sb-nav-fixed">
    <jsp:include page="../layout/header.jsp" />
    <div id="layoutSidenav">
        <jsp:include page="../layout/sidebar.jsp" />
        <div id="layoutSidenav_content">
            <main>
                <div class="container-fluid px-4">
                    <h1 class="mt-4">Chi tiết hóa đơn</h1>
                    <ol class="breadcrumb mb-4">
                        <li class="breadcrumb-item"><a href="/admin">Dashboard</a></li>
                        <li class="breadcrumb-item"><a href="/admin/bill">Hóa đơn</a></li>
                        <li class="breadcrumb-item active">${bill.id}</li>
                    </ol>

                    <!-- Action Buttons -->
                    <div class="row mb-4 no-print">
                        <div class="col-12">
                            <a href="/admin/bill" class="btn btn-secondary">
                                <i class="fas fa-arrow-left me-1"></i>Quay lại
                            </a>
                            <a href="/admin/bill/${bill.id}/print" class="btn btn-primary" target="_blank">
                                <i class="fas fa-print me-1"></i>In hóa đơn
                            </a>
                            <button onclick="window.print()" class="btn btn-info">
                                <i class="fas fa-file-pdf me-1"></i>In nhanh
                            </button>
                        </div>
                    </div>

                    <div class="row">
                        <!-- Bill Information -->
                        <div class="col-lg-8">
                            <div class="card mb-4">
                                <div class="card-header bg-primary text-white">
                                    <h5 class="mb-0">
                                        <i class="fas fa-receipt me-2"></i>Hóa đơn: ${bill.id}
                                    </h5>
                                </div>
                                <div class="card-body">
                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <p class="mb-2">
                                                <strong><i class="fas fa-calendar me-2"></i>Ngày tạo:</strong><br>
                                                <span class="ms-4">${bill.paymentDate}</span>
                                            </p>
                                            <p class="mb-2">
                                                <strong><i class="fas fa-user-tie me-2"></i>Nhân viên:</strong><br>
                                                <span class="ms-4">${bill.employee.name}</span><br>
                                                <small class="text-muted ms-4">${bill.employee.position.displayName}</small>
                                            </p>
                                        </div>
                                        <div class="col-md-6">
                                            <p class="mb-2">
                                                <strong><i class="fas fa-user me-2"></i>Khách hàng:</strong><br>
                                                <c:choose>
                                                    <c:when test="${bill.customer != null}">
                                                        <span class="ms-4">${bill.customer.name}</span><br>
                                                        <small class="text-muted ms-4">${bill.customer.phone}</small><br>
                                                        <span class="badge bg-info ms-4">Level ${bill.customer.level}</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="ms-4 text-muted">Khách lẻ</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </p>
                                            <p class="mb-2">
                                                <strong><i class="fas fa-credit-card me-2"></i>Thanh toán:</strong><br>
                                                <span class="badge ms-4
                                                    <c:choose>
                                                        <c:when test="${bill.paymentMethod.name() == 'CASH'}">bg-success</c:when>
                                                        <c:when test="${bill.paymentMethod.name() == 'TRANSFER'}">bg-info</c:when>
                                                        <c:when test="${bill.paymentMethod.name() == 'CARD'}">bg-primary</c:when>
                                                        <c:otherwise>bg-warning text-dark</c:otherwise>
                                                    </c:choose>
                                                ">
                                                    ${bill.paymentMethod.displayName}
                                                </span>
                                            </p>
                                        </div>
                                    </div>

                                    <hr>

                                    <!-- Bill Details Table -->
                                    <h6 class="mb-3"><i class="fas fa-shopping-cart me-2"></i>Chi tiết sản phẩm</h6>
                                    <div class="table-responsive">
                                        <table class="table table-bordered table-hover">
                                            <thead class="table-light">
                                                <tr>
                                                    <th width="5%">STT</th>
                                                    <th width="45%">Sản phẩm</th>
                                                    <th width="15%" class="text-end">Đơn giá</th>
                                                    <th width="10%" class="text-center">SL</th>
                                                    <th width="25%" class="text-end">Thành tiền</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:set var="subtotal" value="0" />
                                                <c:forEach var="detail" items="${billDetails}" varStatus="status">
                                                    <c:set var="lineTotal" value="${detail.product.price * detail.quantity}" />
                                                    <c:set var="subtotal" value="${subtotal + lineTotal}" />
                                                    <tr>
                                                        <td class="text-center">${status.index + 1}</td>
                                                        <td>
                                                            <strong>${detail.product.name}</strong><br>
                                                            <small class="text-muted">Mã: ${detail.product.id}</small>
                                                        </td>
                                                        <td class="text-end">
                                                            <fmt:formatNumber value="${detail.product.price}" type="currency" currencySymbol="₫" maxFractionDigits="0" />
                                                        </td>
                                                        <td class="text-center">
                                                            <span class="badge bg-secondary">${detail.quantity}</span>
                                                        </td>
                                                        <td class="text-end">
                                                            <strong>
                                                                <fmt:formatNumber value="${lineTotal}" type="currency" currencySymbol="₫" maxFractionDigits="0" />
                                                            </strong>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Bill Summary -->
                        <div class="col-lg-4">
                            <div class="card mb-4">
                                <div class="card-header bg-success text-white">
                                    <h5 class="mb-0"><i class="fas fa-calculator me-2"></i>Tổng kết</h5>
                                </div>
                                <div class="card-body">
                                    <div class="d-flex justify-content-between mb-2">
                                        <span>Tạm tính:</span>
                                        <strong><fmt:formatNumber value="${subtotal}" type="currency" currencySymbol="₫" maxFractionDigits="0" /></strong>
                                    </div>

                                    <c:if test="${bill.discount > 0}">
                                        <div class="d-flex justify-content-between mb-2 text-danger">
                                            <span>Giảm giá (${bill.discount}%):</span>
                                            <strong>-<fmt:formatNumber value="${subtotal * bill.discount / 100}" type="currency" currencySymbol="₫" maxFractionDigits="0" /></strong>
                                        </div>
                                    </c:if>

                                    <hr>

                                    <div class="d-flex justify-content-between mb-3">
                                        <h5>Tổng cộng:</h5>
                                        <h4 class="text-success">
                                            <fmt:formatNumber value="${bill.totalPrice}" type="currency" currencySymbol="₫" maxFractionDigits="0" />
                                        </h4>
                                    </div>

                                    <div class="alert alert-info mb-0">
                                        <small>
                                            <i class="fas fa-info-circle me-1"></i>
                                            Số lượng sản phẩm: <strong>${billDetails.size()}</strong><br>
                                            Tổng số lượng: <strong>
                                                <c:set var="totalQty" value="0" />
                                                <c:forEach var="detail" items="${billDetails}">
                                                    <c:set var="totalQty" value="${totalQty + detail.quantity}" />
                                                </c:forEach>
                                                ${totalQty}
                                            </strong>
                                        </small>
                                    </div>
                                </div>
                            </div>

                            <!-- Store Information -->
                            <div class="card mb-4">
                                <div class="card-header">
                                    <i class="fas fa-store me-2"></i>Thông tin cửa hàng
                                </div>
                                <div class="card-body">
                                    <p class="mb-2">
                                        <strong>Cửa hàng:</strong><br>
                                        ${bill.employee.store.id}
                                    </p>
                                    <p class="mb-2">
                                        <strong>Địa chỉ:</strong><br>
                                        ${bill.employee.store.address}
                                    </p>
                                    <p class="mb-0">
                                        <strong>Điện thoại:</strong><br>
                                        ${bill.employee.store.phone}
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
            <jsp:include page="../layout/footer.jsp" />
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="/js/scripts.js"></script>
</body>
</html>


<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <title>Chi tiết khách hàng - Hệ thống POS</title>
    <link href="/css/styles.css" rel="stylesheet" />
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
</head>
<body class="sb-nav-fixed">
    <jsp:include page="../layout/header.jsp" />
    <div id="layoutSidenav">
        <jsp:include page="../layout/sidebar.jsp" />
        <div id="layoutSidenav_content">
            <main>
                <div class="container-fluid px-4">
                    <h1 class="mt-4">Chi tiết khách hàng</h1>
                    <ol class="breadcrumb mb-4">
                        <li class="breadcrumb-item"><a href="/admin">Dashboard</a></li>
                        <li class="breadcrumb-item"><a href="/admin/customer">Khách hàng</a></li>
                        <li class="breadcrumb-item active">${customer.id}</li>
                    </ol>

                    <div class="row">
                        <!-- Customer Info Card -->
                        <div class="col-md-6">
                            <div class="card mb-4">
                                <div class="card-header bg-info text-white">
                                    <i class="fas fa-user-circle me-2"></i>Thông tin khách hàng
                                </div>
                                <div class="card-body">
                                    <table class="table table-borderless">
                                        <tbody>
                                            <tr>
                                                <th width="40%"><i class="fas fa-id-card me-2 text-muted"></i>Mã khách hàng</th>
                                                <td><strong class="text-primary">${customer.id}</strong></td>
                                            </tr>
                                            <tr>
                                                <th><i class="fas fa-user me-2 text-muted"></i>Họ và tên</th>
                                                <td><strong>${customer.name}</strong></td>
                                            </tr>
                                            <tr>
                                                <th><i class="fas fa-phone me-2 text-muted"></i>Số điện thoại</th>
                                                <td>
                                                    <a href="tel:${customer.phone}">${customer.phone}</a>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th><i class="fas fa-star me-2 text-muted"></i>Cấp độ thành viên</th>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${customer.level == 1}">
                                                            <span class="badge bg-secondary">Cấp 1 - Thành viên mới</span>
                                                        </c:when>
                                                        <c:when test="${customer.level == 2}">
                                                            <span class="badge bg-info">Cấp 2 - Bạc</span>
                                                        </c:when>
                                                        <c:when test="${customer.level == 3}">
                                                            <span class="badge bg-warning text-dark">Cấp 3 - Vàng</span>
                                                        </c:when>
                                                        <c:when test="${customer.level == 4}">
                                                            <span class="badge bg-primary">
                                                                <i class="fas fa-crown"></i> Cấp 4 - Kim cương
                                                            </span>
                                                        </c:when>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th><i class="fas fa-percent me-2 text-muted"></i>Ưu đãi giảm giá</th>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${customer.level == 1}">
                                                            <span class="badge bg-secondary">0%</span>
                                                        </c:when>
                                                        <c:when test="${customer.level == 2}">
                                                            <span class="badge bg-info">5%</span>
                                                        </c:when>
                                                        <c:when test="${customer.level == 3}">
                                                            <span class="badge bg-warning text-dark">10%</span>
                                                        </c:when>
                                                        <c:when test="${customer.level == 4}">
                                                            <span class="badge bg-primary">15%</span>
                                                        </c:when>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th><i class="fas fa-money-bill-wave me-2 text-muted"></i>Tổng chi tiêu</th>
                                                <td>
                                                    <strong class="text-success">
                                                        <fmt:formatNumber value="${customer.totalPayment}" type="currency" currencySymbol="₫" maxFractionDigits="0" />
                                                    </strong>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                                <div class="card-footer">
                                    <a href="/admin/customer/update/${customer.id}" class="btn btn-warning btn-sm">
                                        <i class="fas fa-edit me-1"></i>Chỉnh sửa
                                    </a>
                                    <a href="/admin/customer" class="btn btn-secondary btn-sm">
                                        <i class="fas fa-arrow-left me-1"></i>Quay lại
                                    </a>
                                </div>
                            </div>
                        </div>

                        <!-- Level Progress Card -->
                        <div class="col-md-6">
                            <div class="card mb-4">
                                <div class="card-header bg-success text-white">
                                    <i class="fas fa-chart-line me-2"></i>Tiến độ thành viên
                                </div>
                                <div class="card-body">
                                    <c:set var="totalPaymentValue" value="${customer.totalPayment}" />
                                    <c:set var="nextLevelAmount" value="5000000" />
                                    <c:set var="progressPercent" value="0" />
                                    
                                    <c:if test="${customer.level == 1}">
                                        <c:set var="nextLevelAmount" value="5000000" />
                                        <c:set var="progressPercent" value="${(totalPaymentValue / 5000000) * 100}" />
                                    </c:if>
                                    <c:if test="${customer.level == 2}">
                                        <c:set var="nextLevelAmount" value="20000000" />
                                        <c:set var="progressPercent" value="${((totalPaymentValue - 5000000) / 15000000) * 100}" />
                                    </c:if>
                                    <c:if test="${customer.level == 3}">
                                        <c:set var="nextLevelAmount" value="50000000" />
                                        <c:set var="progressPercent" value="${((totalPaymentValue - 20000000) / 30000000) * 100}" />
                                    </c:if>
                                    
                                    <c:choose>
                                        <c:when test="${customer.level < 4}">
                                            <div class="mb-3">
                                                <h6>Còn <fmt:formatNumber value="${nextLevelAmount - totalPaymentValue}" type="currency" currencySymbol="₫" maxFractionDigits="0" /> để lên cấp ${customer.level + 1}</h6>
                                                <div class="progress" style="height: 25px;">
                                                    <div class="progress-bar bg-success" role="progressbar" 
                                                         style="width: ${progressPercent > 100 ? 100 : progressPercent}%">
                                                        <fmt:formatNumber value="${progressPercent}" maxFractionDigits="0" />%
                                                    </div>
                                                </div>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="alert alert-success text-center">
                                                <i class="fas fa-trophy fa-3x mb-2"></i>
                                                <h5>Khách hàng VIP</h5>
                                                <p class="mb-0">Đã đạt cấp độ cao nhất!</p>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                    
                                    <hr>
                                    
                                    <h6 class="mb-3">Các mốc cấp độ:</h6>
                                    <ul class="list-unstyled">
                                        <li class="mb-2">
                                            <i class="fas ${customer.level >= 1 ? 'fa-check-circle text-success' : 'fa-circle text-muted'}"></i>
                                            Cấp 1: Dưới 5 triệu
                                        </li>
                                        <li class="mb-2">
                                            <i class="fas ${customer.level >= 2 ? 'fa-check-circle text-success' : 'fa-circle text-muted'}"></i>
                                            Cấp 2: 5 - 20 triệu (5% giảm giá)
                                        </li>
                                        <li class="mb-2">
                                            <i class="fas ${customer.level >= 3 ? 'fa-check-circle text-success' : 'fa-circle text-muted'}"></i>
                                            Cấp 3: 20 - 50 triệu (10% giảm giá)
                                        </li>
                                        <li class="mb-2">
                                            <i class="fas ${customer.level >= 4 ? 'fa-check-circle text-success' : 'fa-circle text-muted'}"></i>
                                            Cấp 4: Trên 50 triệu (15% giảm giá)
                                        </li>
                                    </ul>
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


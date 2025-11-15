<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <title>Chi tiết cửa hàng - Hệ thống POS</title>
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
                    <h1 class="mt-4">Chi tiết cửa hàng</h1>
                    <ol class="breadcrumb mb-4">
                        <li class="breadcrumb-item"><a href="/admin">Dashboard</a></li>
                        <li class="breadcrumb-item"><a href="/admin/store">Cửa hàng</a></li>
                        <li class="breadcrumb-item active">Chi tiết</li>
                    </ol>
                    
                    <div class="row">
                        <!-- Store Information -->
                        <div class="col-xl-6">
                            <div class="card mb-4">
                                <div class="card-header bg-primary text-white">
                                    <i class="fas fa-store me-2"></i>
                                    Thông tin cửa hàng
                                </div>
                                <div class="card-body">
                                    <div class="mb-3">
                                        <h5 class="text-muted">Mã cửa hàng</h5>
                                        <p class="lead"><strong>${store.id}</strong></p>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <h5 class="text-muted">
                                            <i class="fas fa-map-marker-alt me-2"></i>Địa chỉ
                                        </h5>
                                        <p class="fs-6">${store.address}</p>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <h5 class="text-muted">
                                            <i class="fas fa-phone me-2"></i>Số điện thoại
                                        </h5>
                                        <p class="fs-6">${store.phone}</p>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <h5 class="text-muted">
                                            <i class="fas fa-expand-arrows-alt me-2"></i>Diện tích
                                        </h5>
                                        <p class="fs-6">
                                            <fmt:formatNumber value="${store.area}" type="number" groupingUsed="true" /> m²
                                        </p>
                                    </div>
                                </div>
                                <div class="card-footer">
                                    <div class="d-flex justify-content-between">
                                        <a href="/admin/store" class="btn btn-secondary">
                                            <i class="fas fa-arrow-left me-2"></i>Quay lại
                                        </a>
                                        <a href="/admin/store/update/${store.id}" class="btn btn-warning">
                                            <i class="fas fa-edit me-2"></i>Chỉnh sửa
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Store Statistics -->
                        <div class="col-xl-6">
                            <div class="card mb-4">
                                <div class="card-header bg-success text-white">
                                    <i class="fas fa-chart-pie me-2"></i>
                                    Thống kê
                                </div>
                                <div class="card-body">
                                    <c:if test="${stats != null}">
                                        <div class="row text-center">
                                            <div class="col-md-6 mb-3">
                                                <div class="card bg-light">
                                                    <div class="card-body">
                                                        <h6 class="text-muted">Tổng nhân viên</h6>
                                                        <h2 class="text-primary">
                                                            <i class="fas fa-users"></i>
                                                            ${stats.employeeCount}
                                                        </h2>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-md-6 mb-3">
                                                <div class="card bg-light">
                                                    <div class="card-body">
                                                        <h6 class="text-muted">Tổng sản phẩm</h6>
                                                        <h2 class="text-info">
                                                            <i class="fas fa-boxes"></i>
                                                            ${stats.productCount}
                                                        </h2>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-md-12 mb-3">
                                                <div class="card bg-light">
                                                    <div class="card-body">
                                                        <h6 class="text-muted">Doanh thu tháng này</h6>
                                                        <h2 class="text-success">
                                                            <i class="fas fa-money-bill-wave"></i>
                                                            <fmt:formatNumber value="${stats.monthlyRevenue}" type="currency" currencySymbol="₫" />
                                                        </h2>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:if>
                                    
                                    <c:if test="${stats == null}">
                                        <div class="alert alert-info">
                                            <i class="fas fa-info-circle me-2"></i>
                                            Chưa có dữ liệu thống kê
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                            
                            <!-- Quick Links -->
                            <div class="card mb-4">
                                <div class="card-header">
                                    <i class="fas fa-link me-2"></i>
                                    Liên kết nhanh
                                </div>
                                <div class="card-body">
                                    <div class="d-grid gap-2">
                                        <a href="/admin/employee?storeId=${store.id}" class="btn btn-outline-primary">
                                            <i class="fas fa-users me-2"></i>Xem nhân viên
                                        </a>
                                        <a href="/admin/product?storeId=${store.id}" class="btn btn-outline-info">
                                            <i class="fas fa-boxes me-2"></i>Xem sản phẩm
                                        </a>
                                        <a href="/admin/bill?storeId=${store.id}" class="btn btn-outline-success">
                                            <i class="fas fa-receipt me-2"></i>Xem hóa đơn
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
            <jsp:include page="../layout/footer.jsp" />
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
    <script src="/js/scripts.js"></script>
</body>
</html>


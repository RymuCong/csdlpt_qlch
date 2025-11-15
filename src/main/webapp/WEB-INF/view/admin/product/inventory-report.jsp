<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <title>Báo cáo kho hàng - Hệ thống POS</title>
    <link href="/css/styles.css" rel="stylesheet" />
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body class="sb-nav-fixed">
    <jsp:include page="../layout/header.jsp" />
    <div id="layoutSidenav">
        <jsp:include page="../layout/sidebar.jsp" />
        <div id="layoutSidenav_content">
            <main>
                <div class="container-fluid px-4">
                    <h1 class="mt-4">
                        <i class="fas fa-warehouse text-primary"></i>
                        Báo cáo kho hàng
                    </h1>
                    <ol class="breadcrumb mb-4">
                        <li class="breadcrumb-item"><a href="/admin">Dashboard</a></li>
                        <li class="breadcrumb-item"><a href="/admin/product">Sản phẩm</a></li>
                        <li class="breadcrumb-item active">Báo cáo kho</li>
                    </ol>
                    
                    <!-- Summary Cards -->
                    <div class="row">
                        <div class="col-xl-3 col-md-6">
                            <div class="card bg-primary text-white mb-4">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <div class="text-white-75 small">Tổng sản phẩm</div>
                                            <div class="h2 mb-0">${report.totalProducts}</div>
                                        </div>
                                        <div>
                                            <i class="fas fa-boxes fa-3x"></i>
                                        </div>
                                    </div>
                                </div>
                                <div class="card-footer d-flex align-items-center justify-content-between">
                                    <a class="small text-white stretched-link" href="/admin/product">Xem chi tiết</a>
                                    <div class="small text-white"><i class="fas fa-angle-right"></i></div>
                                </div>
                            </div>
                        </div>
                        <div class="col-xl-3 col-md-6">
                            <div class="card bg-warning text-white mb-4">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <div class="text-white-75 small">Tổng số lượng</div>
                                            <div class="h2 mb-0">
                                                <fmt:formatNumber value="${report.totalQuantity != null ? report.totalQuantity : 0}" type="number" groupingUsed="true" />
                                            </div>
                                        </div>
                                        <div>
                                            <i class="fas fa-layer-group fa-3x"></i>
                                        </div>
                                    </div>
                                </div>
                                <div class="card-footer d-flex align-items-center justify-content-between">
                                    <span class="small text-white">Tổng tồn kho</span>
                                </div>
                            </div>
                        </div>
                        <div class="col-xl-3 col-md-6">
                            <div class="card bg-success text-white mb-4">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <div class="text-white-75 small">Giá trị kho</div>
                                            <div class="h5 mb-0">
                                                <fmt:formatNumber value="${report.inventoryValue}" type="currency" currencySymbol="₫" maxFractionDigits="0" />
                                            </div>
                                        </div>
                                        <div>
                                            <i class="fas fa-money-bill-wave fa-3x"></i>
                                        </div>
                                    </div>
                                </div>
                                <div class="card-footer d-flex align-items-center justify-content-between">
                                    <span class="small text-white">Tổng giá trị hàng hóa</span>
                                </div>
                            </div>
                        </div>
                        <div class="col-xl-3 col-md-6">
                            <div class="card bg-danger text-white mb-4">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <div class="text-white-75 small">Sắp hết hàng</div>
                                            <div class="h2 mb-0">${report.lowStockCount}</div>
                                        </div>
                                        <div>
                                            <i class="fas fa-exclamation-triangle fa-3x"></i>
                                        </div>
                                    </div>
                                </div>
                                <div class="card-footer d-flex align-items-center justify-content-between">
                                    <a class="small text-white stretched-link" href="/admin/product/low-stock">Xem chi tiết</a>
                                    <div class="small text-white"><i class="fas fa-angle-right"></i></div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    
                    <!-- Inventory Summary -->
                    <div class="row">
                        <div class="col-xl-6">
                            <div class="card mb-4">
                                <div class="card-header bg-info text-white">
                                    <i class="fas fa-chart-pie me-1"></i>
                                    Phân loại tồn kho
                                </div>
                                <div class="card-body">
                                    <div class="row text-center g-3">
                                        <div class="col-6">
                                            <div class="border rounded p-3">
                                                <i class="fas fa-check-circle text-success fa-2x mb-2"></i>
                                                <h5 class="text-success mb-0">
                                                    <fmt:formatNumber value="${report.totalProducts - report.lowStockCount - report.outOfStockCount}" 
                                                                     type="number" groupingUsed="true" />
                                                </h5>
                                                <small class="text-muted">Tồn kho ổn định</small>
                                            </div>
                                        </div>
                                        <div class="col-6">
                                            <div class="border rounded p-3">
                                                <i class="fas fa-exclamation-triangle text-warning fa-2x mb-2"></i>
                                                <h5 class="text-warning mb-0">
                                                    <fmt:formatNumber value="${report.lowStockCount}" type="number" groupingUsed="true" />
                                                </h5>
                                                <small class="text-muted">Sắp hết hàng</small>
                                            </div>
                                        </div>
                                        <div class="col-6">
                                            <div class="border rounded p-3">
                                                <i class="fas fa-times-circle text-danger fa-2x mb-2"></i>
                                                <h5 class="text-danger mb-0">
                                                    <fmt:formatNumber value="${report.outOfStockCount}" type="number" groupingUsed="true" />
                                                </h5>
                                                <small class="text-muted">Hết hàng</small>
                                            </div>
                                        </div>
                                        <div class="col-6">
                                            <div class="border rounded p-3">
                                                <i class="fas fa-calendar-times text-info fa-2x mb-2"></i>
                                                <h5 class="text-info mb-0">
                                                    <fmt:formatNumber value="${report.expiringCount}" type="number" groupingUsed="true" />
                                                </h5>
                                                <small class="text-muted">Sắp hết hạn</small>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-xl-6">
                            <div class="card mb-4">
                                <div class="card-header bg-success text-white">
                                    <i class="fas fa-link me-1"></i>
                                    Liên kết nhanh
                                </div>
                                <div class="card-body">
                                    <div class="list-group">
                                        <a href="/admin/product/low-stock?threshold=10" class="list-group-item list-group-item-action">
                                            <div class="d-flex w-100 justify-content-between align-items-center">
                                                <div>
                                                    <i class="fas fa-exclamation-triangle text-warning me-2"></i>
                                                    <strong>Sản phẩm sắp hết hàng</strong>
                                                </div>
                                                <span class="badge bg-warning text-dark rounded-pill">
                                                    ${report.lowStockCount}
                                                </span>
                                            </div>
                                            <small class="text-muted">Xem danh sách sản phẩm cần nhập thêm</small>
                                        </a>
                                        <a href="/admin/product/expiring?days=30" class="list-group-item list-group-item-action">
                                            <div class="d-flex w-100 justify-content-between align-items-center">
                                                <div>
                                                    <i class="fas fa-calendar-times text-info me-2"></i>
                                                    <strong>Sản phẩm sắp hết hạn</strong>
                                                </div>
                                                <span class="badge bg-info rounded-pill">
                                                    ${report.expiringCount}
                                                </span>
                                            </div>
                                            <small class="text-muted">Xem sản phẩm sắp hết hạn trong 30 ngày</small>
                                        </a>
                                        <a href="/admin/product" class="list-group-item list-group-item-action">
                                            <div class="d-flex w-100 justify-content-between align-items-center">
                                                <div>
                                                    <i class="fas fa-list text-primary me-2"></i>
                                                    <strong>Tất cả sản phẩm</strong>
                                                </div>
                                                <span class="badge bg-primary rounded-pill">
                                                    ${report.totalProducts}
                                                </span>
                                            </div>
                                            <small class="text-muted">Xem danh sách đầy đủ</small>
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Old section - Commented out (needs product list data)
                    <div class="row d-none">
                        <div class="col-xl-6">
                            <div class="card mb-4">
                                <div class="card-header bg-success text-white">
                                    <i class="fas fa-arrow-up me-1"></i>
                                    Top 10 sản phẩm tồn kho nhiều nhất
                                </div>
                                <div class="card-body">
                                    <div class="alert alert-info mb-0">
                                        <i class="fas fa-info-circle me-2"></i>
                                        Chức năng này đang được phát triển
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-xl-6">
                            <div class="card mb-4">
                                <div class="card-header bg-warning text-dark">
                                    <i class="fas fa-arrow-down me-1"></i>
                                    Top 10 sản phẩm tồn kho ít nhất
                                </div>
                                <div class="card-body">
                                    <div class="alert alert-info mb-0">
                                        <i class="fas fa-info-circle me-2"></i>
                                        Chức năng này đang được phát triển
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    -->
                    
                    
                    <!-- Quick Actions -->
                    <div class="card mb-4">
                        <div class="card-header">
                            <i class="fas fa-bolt me-1"></i>
                            Thao tác nhanh
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-3 mb-2">
                                    <a href="/admin/product/create" class="btn btn-primary w-100">
                                        <i class="fas fa-plus-circle me-2"></i>Thêm sản phẩm mới
                                    </a>
                                </div>
                                <div class="col-md-3 mb-2">
                                    <a href="/admin/product/low-stock" class="btn btn-warning w-100">
                                        <i class="fas fa-exclamation-triangle me-2"></i>Sản phẩm sắp hết
                                    </a>
                                </div>
                                <div class="col-md-3 mb-2">
                                    <a href="/admin/product/expiring" class="btn btn-danger w-100">
                                        <i class="fas fa-calendar-times me-2"></i>Sắp hết hạn
                                    </a>
                                </div>
                                <div class="col-md-3 mb-2">
                                    <a href="/admin/product" class="btn btn-info w-100">
                                        <i class="fas fa-list me-2"></i>Tất cả sản phẩm
                                    </a>
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


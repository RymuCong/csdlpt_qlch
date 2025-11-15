<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <title>Báo cáo doanh thu ngày - Hệ thống POS</title>
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
                        <i class="fas fa-chart-line text-success"></i>
                        Báo cáo doanh thu theo ngày
                    </h1>
                    <ol class="breadcrumb mb-4">
                        <li class="breadcrumb-item"><a href="/admin">Dashboard</a></li>
                        <li class="breadcrumb-item"><a href="/admin/bill">Hóa đơn</a></li>
                        <li class="breadcrumb-item active">Báo cáo ngày</li>
                    </ol>
                    
                    <!-- Date Selector -->
                    <div class="card mb-4">
                        <div class="card-body">
                            <form action="/admin/bill/report/daily" method="get" class="row g-3">
                                <div class="col-md-4">
                                    <label class="form-label">Chọn ngày</label>
                                    <input type="date" name="date" class="form-control" 
                                           value="${selectedDate}" required />
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label">&nbsp;</label>
                                    <div>
                                        <button type="submit" class="btn btn-primary">
                                            <i class="fas fa-search me-1"></i>Xem báo cáo
                                        </button>
                                        <a href="/admin/bill/report/range" class="btn btn-secondary">
                                            <i class="fas fa-calendar-alt me-1"></i>Theo khoảng
                                        </a>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                    
                    <!-- Summary Cards -->
                    <div class="row">
                        <div class="col-xl-3 col-md-6">
                            <div class="card bg-primary text-white mb-4">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <div class="text-white-75 small">Tổng doanh thu</div>
                                            <div class="h4 mb-0">
                                                <fmt:formatNumber value="${report.revenue}" type="currency" currencySymbol="₫" maxFractionDigits="0" />
                                            </div>
                                        </div>
                                        <div>
                                            <i class="fas fa-dollar-sign fa-3x"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-xl-3 col-md-6">
                            <div class="card bg-success text-white mb-4">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <div class="text-white-75 small">Số hóa đơn</div>
                                            <div class="h2 mb-0">${report.billCount}</div>
                                        </div>
                                        <div>
                                            <i class="fas fa-receipt fa-3x"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-xl-3 col-md-6">
                            <div class="card bg-warning text-white mb-4">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <div class="text-white-75 small">Giá trị TB/HĐ</div>
                                            <div class="h5 mb-0">
                                                <fmt:formatNumber value="${report.averageOrderValue}" type="currency" currencySymbol="₫" maxFractionDigits="0" />
                                            </div>
                                        </div>
                                        <div>
                                            <i class="fas fa-calculator fa-3x"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-xl-3 col-md-6">
                            <div class="card bg-info text-white mb-4">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <div class="text-white-75 small">Tổng hóa đơn</div>
                                            <div class="h5 mb-0">
                                                ${report.billCount}
                                            </div>
                                        </div>
                                        <div>
                                            <i class="fas fa-percent fa-3x"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    
                    <!-- Action Buttons -->
                    <div class="card mb-4">
                        <div class="card-body text-center">
                            <a href="/admin/bill" class="btn btn-secondary me-2">
                                <i class="fas fa-arrow-left me-1"></i>Quay lại
                            </a>
                            <button onclick="window.print()" class="btn btn-primary me-2">
                                <i class="fas fa-print me-1"></i>In báo cáo
                            </button>
                            <a href="/admin/bill/report/range" class="btn btn-info">
                                <i class="fas fa-calendar-alt me-1"></i>Báo cáo theo khoảng
                            </a>
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


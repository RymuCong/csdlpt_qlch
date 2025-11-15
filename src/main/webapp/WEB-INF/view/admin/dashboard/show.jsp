<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <title>Dashboard - Hệ thống POS</title>
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
                    <h1 class="mt-4">Bảng điều khiển</h1>
                    <ol class="breadcrumb mb-4">
                        <li class="breadcrumb-item active">Dashboard</li>
                    </ol>
                    
                    <!-- Thông tin nhân viên đăng nhập -->
                    <div class="row mb-4">
                        <div class="col-xl-12">
                            <div class="card bg-primary text-white mb-4">
                                <div class="card-body">
                                    <h5><i class="fas fa-user-circle me-2"></i>Xin chào, ${sessionScope.employeeName}!</h5>
                                    <p class="mb-0">
                                        <i class="fas fa-briefcase me-2"></i>Chức vụ: ${sessionScope.employeePositionDisplay}
                                        <span class="ms-3"><i class="fas fa-store me-2"></i>Cửa hàng: ${sessionScope.storeId}</span>
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Thống kê theo cửa hàng -->
                    <c:if test="${storeId != null}">
                        <div class="row">
                            <div class="col-xl-3 col-md-6">
                                <div class="card bg-success text-white mb-4">
                                    <div class="card-body">
                                        <div class="d-flex justify-content-between align-items-center">
                                            <div>
                                                <div class="small">Nhân viên</div>
                                                <div class="h2 mb-0">${employeeCount}</div>
                                            </div>
                                            <div><i class="fas fa-users fa-3x opacity-50"></i></div>
                                        </div>
                                    </div>
                                    <div class="card-footer d-flex align-items-center justify-content-between">
                                        <a class="small text-white stretched-link" href="/admin/employee">Xem chi tiết</a>
                                        <div class="small text-white"><i class="fas fa-angle-right"></i></div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="col-xl-3 col-md-6">
                                <div class="card bg-info text-white mb-4">
                                    <div class="card-body">
                                        <div class="d-flex justify-content-between align-items-center">
                                            <div>
                                                <div class="small">Sản phẩm</div>
                                                <div class="h2 mb-0">${productCount}</div>
                                            </div>
                                            <div><i class="fas fa-boxes fa-3x opacity-50"></i></div>
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
                                                <div class="small">Sắp hết hàng</div>
                                                <div class="h2 mb-0">${lowStockCount}</div>
                                            </div>
                                            <div><i class="fas fa-exclamation-triangle fa-3x opacity-50"></i></div>
                                        </div>
                                    </div>
                                    <div class="card-footer d-flex align-items-center justify-content-between">
                                        <a class="small text-white stretched-link" href="/admin/product/low-stock">Xem chi tiết</a>
                                        <div class="small text-white"><i class="fas fa-angle-right"></i></div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="col-xl-3 col-md-6">
                                <div class="card bg-primary text-white mb-4">
                                    <div class="card-body">
                                        <div class="d-flex justify-content-between align-items-center">
                                            <div>
                                                <div class="small">Doanh thu hôm nay</div>
                                                <div class="h5 mb-0">
                                                    <fmt:formatNumber value="${dailyRevenue.revenue}" type="currency" currencySymbol="₫" maxFractionDigits="0" />
                                                </div>
                                            </div>
                                            <div><i class="fas fa-dollar-sign fa-3x opacity-50"></i></div>
                                        </div>
                                    </div>
                                    <div class="card-footer d-flex align-items-center justify-content-between">
                                        <a class="small text-white stretched-link" href="/admin/bill/report/daily">Xem chi tiết</a>
                                        <div class="small text-white"><i class="fas fa-angle-right"></i></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Doanh thu hôm nay -->
                        <c:if test="${dailyRevenue != null}">
                            <div class="row">
                                <div class="col-xl-6">
                                    <div class="card mb-4">
                                        <div class="card-header">
                                            <i class="fas fa-chart-bar me-1"></i>
                                            Thống kê hóa đơn hôm nay
                                        </div>
                                        <div class="card-body">
                                            <h4>Tổng số hóa đơn: <span class="badge bg-success">${dailyRevenue.billCount}</span></h4>
                                            <h5>Giá trị trung bình: 
                                                <fmt:formatNumber value="${dailyRevenue.averageOrderValue}" type="currency" currencySymbol="₫" maxFractionDigits="0" />
                                            </h5>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:if>
                    </c:if>
                    
                    <!-- Thống kê toàn hệ thống (Admin) -->
                    <c:if test="${storeId == null}">
                        <div class="row">
                            <div class="col-xl-4 col-md-6">
                                <div class="card bg-primary text-white mb-4">
                                    <div class="card-body">
                                        <div class="d-flex justify-content-between align-items-center">
                                            <div>
                                                <div class="small">Tổng nhân viên</div>
                                                <div class="h2 mb-0">${totalEmployees}</div>
                                            </div>
                                            <div><i class="fas fa-users fa-3x opacity-50"></i></div>
                                        </div>
                                    </div>
                                    <div class="card-footer d-flex align-items-center justify-content-between">
                                        <a class="small text-white stretched-link" href="/admin/employee">Quản lý</a>
                                        <div class="small text-white"><i class="fas fa-angle-right"></i></div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="col-xl-4 col-md-6">
                                <div class="card bg-success text-white mb-4">
                                    <div class="card-body">
                                        <div class="d-flex justify-content-between align-items-center">
                                            <div>
                                                <div class="small">Tổng cửa hàng</div>
                                                <div class="h2 mb-0">${totalStores}</div>
                                            </div>
                                            <div><i class="fas fa-store fa-3x opacity-50"></i></div>
                                        </div>
                                    </div>
                                    <div class="card-footer d-flex align-items-center justify-content-between">
                                        <a class="small text-white stretched-link" href="/admin/store">Quản lý</a>
                                        <div class="small text-white"><i class="fas fa-angle-right"></i></div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="col-xl-4 col-md-6">
                                <div class="card bg-info text-white mb-4">
                                    <div class="card-body">
                                        <div class="d-flex justify-content-between align-items-center">
                                            <div>
                                                <div class="small">Tổng hóa đơn</div>
                                                <div class="h2 mb-0">${totalBills}</div>
                                            </div>
                                            <div><i class="fas fa-receipt fa-3x opacity-50"></i></div>
                                        </div>
                                    </div>
                                    <div class="card-footer d-flex align-items-center justify-content-between">
                                        <a class="small text-white stretched-link" href="/admin/bill">Xem tất cả</a>
                                        <div class="small text-white"><i class="fas fa-angle-right"></i></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:if>
                    
                    <!-- Quick Actions -->
                    <div class="row">
                        <div class="col-xl-12">
                            <div class="card mb-4">
                                <div class="card-header">
                                    <i class="fas fa-bolt me-1"></i>
                                    Thao tác nhanh
                                </div>
                                <div class="card-body">
                                    <div class="row">
                                        <c:if test="${sessionScope.employeePosition == 'BAN_HANG' || sessionScope.employeePosition == 'QUAN_LY' || sessionScope.employeePosition == 'ADMIN'}">
                                            <div class="col-md-3 mb-3">
                                                <a href="/admin/bill/create" class="btn btn-success btn-lg w-100">
                                                    <i class="fas fa-cash-register fa-2x mb-2"></i><br>
                                                    Tạo hóa đơn
                                                </a>
                                            </div>
                                        </c:if>
                                        <div class="col-md-3 mb-3">
                                            <a href="/admin/product" class="btn btn-info btn-lg w-100">
                                                <i class="fas fa-boxes fa-2x mb-2"></i><br>
                                                Quản lý sản phẩm
                                            </a>
                                        </div>
                                        <c:if test="${sessionScope.employeePosition == 'ADMIN' || sessionScope.employeePosition == 'QUAN_LY' || sessionScope.employeePosition == 'KE_TOAN'}">
                                            <div class="col-md-3 mb-3">
                                                <a href="/admin/bill/report/daily" class="btn btn-warning btn-lg w-100">
                                                    <i class="fas fa-chart-line fa-2x mb-2"></i><br>
                                                    Báo cáo doanh thu
                                                </a>
                                            </div>
                                            <div class="col-md-3 mb-3">
                                                <a href="/admin/customer" class="btn btn-primary btn-lg w-100">
                                                    <i class="fas fa-users fa-2x mb-2"></i><br>
                                                    Khách hàng
                                                </a>
                                            </div>
                                        </c:if>
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

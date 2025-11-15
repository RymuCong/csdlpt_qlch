<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div id="layoutSidenav_nav">
    <nav class="sb-sidenav accordion sb-sidenav-dark" id="sidenavAccordion">
        <div class="sb-sidenav-menu">
            <div class="nav">
                <div class="sb-sidenav-menu-heading">Hệ thống POS</div>
                
                <!-- Dashboard -->
                <a class="nav-link" href="/admin">
                    <div class="sb-nav-link-icon"><i class="fas fa-tachometer-alt"></i></div>
                    Bảng điều khiển
                </a>

                <!-- Quản lý nhân viên (Chỉ ADMIN, QUAN_LY, KE_TOAN) -->
                <c:if test="${sessionScope.employeePosition == 'ADMIN' || sessionScope.employeePosition == 'QUAN_LY' || sessionScope.employeePosition == 'KE_TOAN'}">
                    <div class="sb-sidenav-menu-heading">Quản lý</div>
                    
                    <a class="nav-link" href="/admin/employee">
                        <div class="sb-nav-link-icon"><i class="fas fa-users"></i></div>
                        Nhân viên
                    </a>
                    
                    <a class="nav-link" href="/admin/store">
                        <div class="sb-nav-link-icon"><i class="fas fa-store"></i></div>
                        Cửa hàng
                    </a>
                    
                    <a class="nav-link" href="/admin/category">
                        <div class="sb-nav-link-icon"><i class="fas fa-tags"></i></div>
                        Danh mục
                    </a>
                    
                    <a class="nav-link" href="/admin/customer">
                        <div class="sb-nav-link-icon"><i class="fas fa-user-friends"></i></div>
                        Khách hàng
                    </a>
                </c:if>

                <!-- Quản lý sản phẩm (Tất cả trừ BAO_VE, VE_SINH) -->
                <c:if test="${sessionScope.employeePosition != 'BAO_VE' && sessionScope.employeePosition != 'VE_SINH'}">
                    <div class="sb-sidenav-menu-heading">Kho hàng</div>
                    
                    <a class="nav-link" href="/admin/product">
                        <div class="sb-nav-link-icon"><i class="fas fa-boxes"></i></div>
                        Sản phẩm
                    </a>
                    
                    <a class="nav-link" href="/admin/product/low-stock?threshold=10">
                        <div class="sb-nav-link-icon"><i class="fas fa-exclamation-triangle text-warning"></i></div>
                        Sắp hết hàng
                    </a>
                    
                    <a class="nav-link" href="/admin/product/expiring?days=30">
                        <div class="sb-nav-link-icon"><i class="fas fa-calendar-times text-danger"></i></div>
                        Sắp hết hạn
                    </a>
                </c:if>

                <!-- POS & Hóa đơn -->
                <c:if test="${sessionScope.employeePosition == 'BAN_HANG' || sessionScope.employeePosition == 'QUAN_LY' || sessionScope.employeePosition == 'ADMIN'}">
                    <div class="sb-sidenav-menu-heading">Bán hàng</div>
                    
                    <a class="nav-link" href="/admin/bill/create">
                        <div class="sb-nav-link-icon"><i class="fas fa-cash-register text-success"></i></div>
                        Tạo hóa đơn (POS)
                    </a>
                    
                    <a class="nav-link" href="/admin/bill">
                        <div class="sb-nav-link-icon"><i class="fas fa-receipt"></i></div>
                        Danh sách hóa đơn
                    </a>
                </c:if>

                <!-- Báo cáo & Lương (Chỉ ADMIN, QUAN_LY, KE_TOAN) -->
                <c:if test="${sessionScope.employeePosition == 'ADMIN' || sessionScope.employeePosition == 'QUAN_LY' || sessionScope.employeePosition == 'KE_TOAN'}">
                    <div class="sb-sidenav-menu-heading">Báo cáo</div>
                    
                    <a class="nav-link collapsed" href="#" data-bs-toggle="collapse" data-bs-target="#collapseBill" 
                       aria-expanded="false" aria-controls="collapseBill">
                        <div class="sb-nav-link-icon"><i class="fas fa-chart-line"></i></div>
                        Doanh thu
                        <div class="sb-sidenav-collapse-arrow"><i class="fas fa-angle-down"></i></div>
                    </a>
                    <div class="collapse" id="collapseBill" aria-labelledby="headingOne" data-bs-parent="#sidenavAccordion">
                        <nav class="sb-sidenav-menu-nested nav">
                            <a class="nav-link" href="/admin/bill/report/daily">Theo ngày</a>
                            <a class="nav-link" href="/admin/bill/report/range">Theo khoảng thời gian</a>
                        </nav>
                    </div>
                    
                    <a class="nav-link" href="/admin/payroll">
                        <div class="sb-nav-link-icon"><i class="fas fa-money-bill-wave"></i></div>
                        Bảng lương
                    </a>
                    
                    <a class="nav-link" href="/admin/product/inventory-report">
                        <div class="sb-nav-link-icon"><i class="fas fa-warehouse"></i></div>
                        Báo cáo kho
                    </a>
                </c:if>
            </div>
        </div>
        <div class="sb-sidenav-footer">
            <div class="small">Đăng nhập với tư cách:</div>
            <strong>${sessionScope.employeeName}</strong>
            <div class="small text-muted">${sessionScope.employeePositionDisplay}</div>
            <div class="small text-muted">Cửa hàng: ${sessionScope.storeId}</div>
        </div>
    </nav>
</div>

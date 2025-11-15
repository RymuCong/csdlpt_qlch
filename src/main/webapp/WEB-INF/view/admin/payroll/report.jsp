<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8" />
    <title>Báo cáo lương - Hệ thống POS</title>
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
                    <h1 class="mt-4">Báo cáo lương</h1>
                    <ol class="breadcrumb mb-4">
                        <li class="breadcrumb-item"><a href="/admin">Dashboard</a></li>
                        <li class="breadcrumb-item"><a href="/admin/payroll">Bảng lương</a></li>
                        <li class="breadcrumb-item active">Báo cáo</li>
                    </ol>
                    
                    <div class="card mb-4">
                        <div class="card-header">
                            <i class="fas fa-chart-bar me-1"></i>
                            Báo cáo lương theo cửa hàng và tháng
                        </div>
                        <div class="card-body">
                            <!-- Filter Form -->
                            <form action="/admin/payroll/report" method="get" class="row g-3 mb-4">
                                <div class="col-md-4">
                                    <label class="form-label">Cửa hàng</label>
                                    <input type="text" name="storeId" class="form-control" 
                                           value="${report.storeId}" placeholder="CN01, CN02, ..." />
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label">Tháng</label>
                                    <c:choose>
                                        <c:when test="${report != null && report.payMonth != null}">
                                            <c:set var="monthValue" value="${report.payMonth.monthValue}" />
                                            <input type="month" name="payMonth" class="form-control" 
                                                   value="${report.payMonth.year}-${monthValue < 10 ? '0' : ''}${monthValue}" />
                                        </c:when>
                                        <c:otherwise>
                                            <input type="month" name="payMonth" class="form-control" />
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label">&nbsp;</label>
                                    <div>
                                        <button type="submit" class="btn btn-primary">
                                            <i class="fas fa-search me-1"></i>Tìm kiếm
                                        </button>
                                        <a href="/admin/payroll" class="btn btn-secondary">
                                            <i class="fas fa-arrow-left me-1"></i>Quay lại
                                        </a>
                                    </div>
                                </div>
                            </form>
                            
                            <c:if test="${report != null}">
                                <!-- Report Summary -->
                                <div class="row mb-4">
                                    <div class="col-md-3">
                                        <div class="card bg-primary text-white">
                                            <div class="card-body">
                                                <h5 class="card-title">Cửa hàng</h5>
                                                <h3>${report.storeId}</h3>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="card bg-success text-white">
                                            <div class="card-body">
                                                <h5 class="card-title">Số nhân viên</h5>
                                                <h3>${report.employeeCount}</h3>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="card bg-info text-white">
                                            <div class="card-body">
                                                <h5 class="card-title">Tổng giờ làm</h5>
                                                <h3><fmt:formatNumber value="${report.totalWorkingHours}" /></h3>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="card bg-warning text-white">
                                            <div class="card-body">
                                                <h5 class="card-title">Tổng thưởng</h5>
                                                <h3><fmt:formatNumber value="${report.totalBonus}" type="currency" currencyCode="VND" maxFractionDigits="0" /></h3>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Financial Summary -->
                                <div class="row mb-4">
                                    <div class="col-md-6">
                                        <div class="card border-primary">
                                            <div class="card-header bg-primary text-white">
                                                <h5 class="mb-0"><i class="fas fa-money-bill-wave me-1"></i>Tổng lương</h5>
                                            </div>
                                            <div class="card-body">
                                                <h2 class="text-primary">
                                                    <fmt:formatNumber value="${report.totalSalary}" type="currency" currencyCode="VND" maxFractionDigits="0" />
                                                </h2>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="card border-success">
                                            <div class="card-header bg-success text-white">
                                                <h5 class="mb-0"><i class="fas fa-chart-line me-1"></i>Lương trung bình</h5>
                                            </div>
                                            <div class="card-body">
                                                <h2 class="text-success">
                                                    <fmt:formatNumber value="${report.averageSalary}" type="currency" currencyCode="VND" maxFractionDigits="0" />
                                                </h2>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Details Table -->
                                <div class="table-responsive">
                                    <table class="table table-bordered table-striped">
                                        <thead>
                                            <tr>
                                                <th>Tháng</th>
                                                <th>Cửa hàng</th>
                                                <th>Số nhân viên</th>
                                                <th>Tổng giờ làm</th>
                                                <th>Tổng thưởng</th>
                                                <th>Tổng lương</th>
                                                <th>Lương trung bình</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>
                                                    <c:if test="${report.payMonth != null}">
                                                        <c:set var="monthValue" value="${report.payMonth.monthValue}" />
                                                        ${monthValue < 10 ? '0' : ''}${monthValue}/${report.payMonth.year}
                                                    </c:if>
                                                </td>
                                                <td>${report.storeId}</td>
                                                <td><fmt:formatNumber value="${report.employeeCount}" /></td>
                                                <td><fmt:formatNumber value="${report.totalWorkingHours}" /></td>
                                                <td><fmt:formatNumber value="${report.totalBonus}" type="currency" currencyCode="VND" maxFractionDigits="0" /></td>
                                                <td><fmt:formatNumber value="${report.totalSalary}" type="currency" currencyCode="VND" maxFractionDigits="0" /></td>
                                                <td><fmt:formatNumber value="${report.averageSalary}" type="currency" currencyCode="VND" maxFractionDigits="0" /></td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </c:if>
                            
                            <c:if test="${report == null}">
                                <div class="alert alert-info">
                                    <i class="fas fa-info-circle me-1"></i>
                                    Vui lòng chọn cửa hàng và tháng để xem báo cáo.
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>
            </main>
            <jsp:include page="../layout/footer.jsp" />
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>


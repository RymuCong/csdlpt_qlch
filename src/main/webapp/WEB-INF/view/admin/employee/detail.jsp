<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <title>Chi tiết nhân viên - Hệ thống POS</title>
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
                    <h1 class="mt-4">Chi tiết nhân viên</h1>
                    <ol class="breadcrumb mb-4">
                        <li class="breadcrumb-item"><a href="/admin">Dashboard</a></li>
                        <li class="breadcrumb-item"><a href="/admin/employee">Nhân viên</a></li>
                        <li class="breadcrumb-item active">Chi tiết</li>
                    </ol>
                    
                    <div class="row">
                        <div class="col-xl-8 col-lg-10 mx-auto">
                            <div class="card mb-4">
                                <div class="card-header bg-primary text-white">
                                    <i class="fas fa-user-circle me-2"></i>
                                    Thông tin nhân viên
                                </div>
                                <div class="card-body">
                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <h5 class="text-muted">Mã nhân viên</h5>
                                            <p class="lead"><strong>${employee.id}</strong></p>
                                        </div>
                                        <div class="col-md-6">
                                            <h5 class="text-muted">Chức vụ</h5>
                                            <p>
                                                <span class="badge fs-6
                                                    <c:choose>
                                                        <c:when test="${employee.position == 'ADMIN'}">bg-dark</c:when>
                                                        <c:when test="${employee.position == 'QUAN_LY'}">bg-danger</c:when>
                                                        <c:when test="${employee.position == 'KE_TOAN'}">bg-warning</c:when>
                                                        <c:when test="${employee.position == 'BAN_HANG'}">bg-info</c:when>
                                                        <c:otherwise>bg-secondary</c:otherwise>
                                                    </c:choose>
                                                ">
                                                    ${employee.position.displayName}
                                                </span>
                                            </p>
                                        </div>
                                    </div>
                                    
                                    <hr />
                                    
                                    <div class="row mb-3">
                                        <div class="col-md-12">
                                            <h5 class="text-muted">
                                                <i class="fas fa-user me-2"></i>Họ và tên
                                            </h5>
                                            <p class="fs-5">${employee.name}</p>
                                        </div>
                                    </div>
                                    
                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <h5 class="text-muted">
                                                <i class="fas fa-phone me-2"></i>Số điện thoại
                                            </h5>
                                            <p class="fs-6">${employee.phone}</p>
                                        </div>
                                        <div class="col-md-6">
                                            <h5 class="text-muted">
                                                <i class="fas fa-map-marker-alt me-2"></i>Địa chỉ
                                            </h5>
                                            <p class="fs-6">${employee.address}</p>
                                        </div>
                                    </div>
                                    
                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <h5 class="text-muted">
                                                <i class="fas fa-store me-2"></i>Cửa hàng
                                            </h5>
                                            <p class="fs-6">
                                                <span class="badge bg-info text-white fs-6">
                                                    ${employee.store.id}
                                                </span>
                                                <br />
                                                <small class="text-muted">${employee.store.address}</small>
                                            </p>
                                        </div>
                                        <div class="col-md-6">
                                            <h5 class="text-muted">
                                                <i class="fas fa-money-bill-wave me-2"></i>Lương cơ bản
                                            </h5>
                                            <p class="fs-5 text-success">
                                                <strong>
                                                    <fmt:formatNumber value="${employee.baseSalary}" type="number" groupingUsed="true" /> ₫/giờ
                                                </strong>
                                            </p>
                                        </div>
                                    </div>
                                </div>
                                <div class="card-footer">
                                    <div class="d-flex justify-content-between">
                                        <a href="/admin/employee" class="btn btn-secondary">
                                            <i class="fas fa-arrow-left me-2"></i>Quay lại
                                        </a>
                                        <div>
                                            <c:if test="${sessionScope.employeePosition == 'ADMIN'}">
                                                <a href="/admin/employee/update/${employee.id}" class="btn btn-warning">
                                                    <i class="fas fa-edit me-2"></i>Chỉnh sửa
                                                </a>
                                            </c:if>
                                            <a href="/admin/payroll/create?employeeId=${employee.id}" class="btn btn-primary">
                                                <i class="fas fa-calculator me-2"></i>Tính lương
                                            </a>
                                        </div>
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


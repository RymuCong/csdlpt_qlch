<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <title>Xóa nhân viên - Hệ thống POS</title>
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
                    <h1 class="mt-4">Xóa nhân viên</h1>
                    <ol class="breadcrumb mb-4">
                        <li class="breadcrumb-item"><a href="/admin">Dashboard</a></li>
                        <li class="breadcrumb-item"><a href="/admin/employee">Nhân viên</a></li>
                        <li class="breadcrumb-item active">Xóa</li>
                    </ol>
                    
                    <div class="row">
                        <div class="col-xl-8 col-lg-10 mx-auto">
                            <div class="card border-danger mb-4">
                                <div class="card-header bg-danger text-white">
                                    <i class="fas fa-exclamation-triangle me-2"></i>
                                    Xác nhận xóa nhân viên
                                </div>
                                <div class="card-body">
                                    <div class="alert alert-danger">
                                        <h5 class="alert-heading">
                                            <i class="fas fa-exclamation-circle me-2"></i>
                                            Cảnh báo!
                                        </h5>
                                        <p>Bạn có chắc chắn muốn xóa nhân viên này? Hành động này không thể hoàn tác!</p>
                                        <hr>
                                        <p class="mb-0">
                                            <i class="fas fa-info-circle me-2"></i>
                                            Tất cả dữ liệu liên quan đến nhân viên này sẽ bị ảnh hưởng.
                                        </p>
                                    </div>
                                    
                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <h6 class="text-muted">Mã nhân viên</h6>
                                            <p class="fs-5"><strong>${employee.id}</strong></p>
                                        </div>
                                        <div class="col-md-6">
                                            <h6 class="text-muted">Họ và tên</h6>
                                            <p class="fs-5">${employee.name}</p>
                                        </div>
                                    </div>
                                    
                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <h6 class="text-muted">Số điện thoại</h6>
                                            <p>${employee.phone}</p>
                                        </div>
                                        <div class="col-md-6">
                                            <h6 class="text-muted">Chức vụ</h6>
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
                                    
                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <h6 class="text-muted">Cửa hàng</h6>
                                            <p>
                                                <span class="badge bg-info text-white fs-6">${employee.store.id}</span>
                                            </p>
                                        </div>
                                        <div class="col-md-6">
                                            <h6 class="text-muted">Lương cơ bản</h6>
                                            <p class="text-success">
                                                <strong>
                                                    <fmt:formatNumber value="${employee.baseSalary}" type="number" groupingUsed="true" /> ₫/giờ
                                                </strong>
                                            </p>
                                        </div>
                                    </div>
                                </div>
                                <div class="card-footer">
                                    <form method="post" action="/admin/employee/delete">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                        <input type="hidden" name="id" value="${employee.id}" />
                                        <div class="d-flex justify-content-between">
                                            <a href="/admin/employee" class="btn btn-secondary">
                                                <i class="fas fa-arrow-left me-2"></i>Hủy
                                            </a>
                                            <button type="submit" class="btn btn-danger">
                                                <i class="fas fa-trash me-2"></i>Xác nhận xóa
                                            </button>
                                        </div>
                                    </form>
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


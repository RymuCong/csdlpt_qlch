<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8" />
    <title>Thêm nhân viên - Hệ thống POS</title>
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
                    <h1 class="mt-4">Thêm nhân viên mới</h1>
                    <ol class="breadcrumb mb-4">
                        <li class="breadcrumb-item"><a href="/admin">Dashboard</a></li>
                        <li class="breadcrumb-item"><a href="/admin/employee">Nhân viên</a></li>
                        <li class="breadcrumb-item active">Thêm mới</li>
                    </ol>
                    
                    <div class="row">
                        <div class="col-md-8 mx-auto">
                            <div class="card">
                                <div class="card-header">
                                    <i class="fas fa-user-plus me-1"></i>
                                    Thông tin nhân viên
                                </div>
                                <div class="card-body">
                                    <c:if test="${error != null}">
                                        <div class="alert alert-danger">${error}</div>
                                    </c:if>
                                    
                                    <form:form method="post" action="/admin/employee/create" 
                                               modelAttribute="newEmployee" acceptCharset="UTF-8">
                                        <div class="row mb-3">
                                            <div class="col-md-6">
                                                <label class="form-label">Mã nhân viên:</label>
                                                <form:input path="id" class="form-control" required="true" />
                                            </div>
                                            <div class="col-md-6">
                                                <label class="form-label">Họ tên:</label>
                                                <form:input path="name" class="form-control" required="true" />
                                            </div>
                                        </div>
                                        
                                        <div class="row mb-3">
                                            <div class="col-md-6">
                                                <label class="form-label">Số điện thoại:</label>
                                                <form:input path="phone" class="form-control" required="true" />
                                                <small class="text-muted">Sử dụng để đăng nhập</small>
                                            </div>
                                            <div class="col-md-6">
                                                <label class="form-label">Mật khẩu:</label>
                                                <form:password path="password" class="form-control" required="true" />
                                            </div>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <label class="form-label">Địa chỉ:</label>
                                            <form:textarea path="address" class="form-control" rows="2" />
                                        </div>
                                        
                                        <div class="row mb-3">
                                            <div class="col-md-6">
                                                <label class="form-label">Chức vụ:</label>
                                                <form:select path="position" class="form-select" required="true">
                                                    <option value="">-- Chọn chức vụ --</option>
                                                    <c:forEach var="pos" items="${positions}">
                                                        <option value="${pos}">${pos.displayName}</option>
                                                    </c:forEach>
                                                </form:select>
                                            </div>
                                            <div class="col-md-6">
                                                <label class="form-label">Lương cơ bản (₫/giờ):</label>
                                                <form:input path="baseSalary" type="number" class="form-control" 
                                                           required="true" min="1" />
                                            </div>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <label class="form-label">Cửa hàng:</label>
                                            <form:select path="store.id" class="form-select" required="true">
                                                <option value="">-- Chọn cửa hàng --</option>
                                                <c:forEach var="store" items="${stores}">
                                                    <option value="${store.id}">${store.id} - ${store.address}</option>
                                                </c:forEach>
                                            </form:select>
                                        </div>
                                        
                                        <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                            <a href="/admin/employee" class="btn btn-secondary">
                                                <i class="fas fa-arrow-left me-1"></i>Quay lại
                                            </a>
                                            <button type="submit" class="btn btn-primary">
                                                <i class="fas fa-save me-1"></i>Lưu
                                            </button>
                                        </div>
                                    </form:form>
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


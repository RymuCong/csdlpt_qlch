<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <title>Cập nhật cửa hàng - Hệ thống POS</title>
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
                    <h1 class="mt-4">Cập nhật cửa hàng</h1>
                    <ol class="breadcrumb mb-4">
                        <li class="breadcrumb-item"><a href="/admin">Dashboard</a></li>
                        <li class="breadcrumb-item"><a href="/admin/store">Cửa hàng</a></li>
                        <li class="breadcrumb-item active">Cập nhật</li>
                    </ol>
                    
                    <div class="row">
                        <div class="col-xl-8 col-lg-10 mx-auto">
                            <c:if test="${error != null}">
                                <div class="alert alert-danger alert-dismissible fade show">
                                    <i class="fas fa-exclamation-circle me-2"></i>${error}
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                </div>
                            </c:if>
                            
                            <div class="card mb-4">
                                <div class="card-header">
                                    <i class="fas fa-edit me-2"></i>
                                    Chỉnh sửa thông tin cửa hàng
                                </div>
                                <div class="card-body">
                                    <form:form method="post" action="/admin/store/update" modelAttribute="store" acceptCharset="UTF-8">
                                        <div class="mb-3" style="display: none;">
                                            <form:input type="text" path="id" />
                                        </div>
                                        
                                        <div class="mb-3">
                                            <label class="form-label">Mã cửa hàng</label>
                                            <input type="text" class="form-control" value="${store.id}" disabled />
                                            <small class="text-muted">Mã cửa hàng không thể thay đổi</small>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <label class="form-label">Địa chỉ <span class="text-danger">*</span></label>
                                            <form:input type="text" path="address" class="form-control" required="true" />
                                            <form:errors path="address" cssClass="text-danger" />
                                        </div>
                                        
                                        <div class="mb-3">
                                            <label class="form-label">Số điện thoại <span class="text-danger">*</span></label>
                                            <form:input type="text" path="phone" class="form-control" required="true" />
                                            <form:errors path="phone" cssClass="text-danger" />
                                        </div>
                                        
                                        <div class="mb-3">
                                            <label class="form-label">Diện tích (m²) <span class="text-danger">*</span></label>
                                            <form:input type="number" path="area" class="form-control" 
                                                       required="true" min="0.01" step="0.01" />
                                            <form:errors path="area" cssClass="text-danger" />
                                        </div>
                                        
                                        <div class="d-flex justify-content-between mt-4">
                                            <a href="/admin/store/${store.id}" class="btn btn-secondary">
                                                <i class="fas fa-times me-2"></i>Hủy
                                            </a>
                                            <button type="submit" class="btn btn-warning">
                                                <i class="fas fa-save me-2"></i>Cập nhật
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
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
    <script src="/js/scripts.js"></script>
</body>
</html>


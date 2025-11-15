<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <title>Cập nhật danh mục - Hệ thống POS</title>
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
                    <h1 class="mt-4">Cập nhật danh mục</h1>
                    <ol class="breadcrumb mb-4">
                        <li class="breadcrumb-item"><a href="/admin">Dashboard</a></li>
                        <li class="breadcrumb-item"><a href="/admin/category">Danh mục</a></li>
                        <li class="breadcrumb-item active">Cập nhật</li>
                    </ol>

                    <div class="row">
                        <div class="col-md-6 mx-auto">
                            <div class="card mb-4">
                                <div class="card-header bg-warning text-dark">
                                    <i class="fas fa-edit me-2"></i>Cập nhật danh mục #${category.id}
                                </div>
                                <div class="card-body">
                                    <c:if test="${error != null}">
                                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                            <i class="fas fa-exclamation-triangle me-2"></i>${error}
                                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                        </div>
                                    </c:if>

                                    <form:form action="/admin/category/update" method="post" modelAttribute="category" acceptCharset="UTF-8">
                                        <!-- Category ID (Hidden) -->
                                        <form:input path="id" type="hidden" />
                                        
                                        <!-- Display ID -->
                                        <div class="mb-3">
                                            <label class="form-label">
                                                <i class="fas fa-id-card me-1"></i>Mã danh mục
                                            </label>
                                            <input type="text" class="form-control" value="${category.id}" disabled />
                                            <small class="form-text text-muted">Mã danh mục không thể thay đổi</small>
                                        </div>

                                        <!-- Name -->
                                        <div class="mb-3">
                                            <label class="form-label">
                                                <i class="fas fa-tag me-1"></i>Tên danh mục
                                                <span class="text-danger">*</span>
                                            </label>
                                            <form:input path="name" cssClass="form-control" placeholder="VD: Đồ uống, Thực phẩm..." required="required" />
                                            <form:errors path="name" cssClass="invalid-feedback d-block" />
                                        </div>

                                        <!-- Buttons -->
                                        <div class="mt-4">
                                            <button type="submit" class="btn btn-warning">
                                                <i class="fas fa-save me-1"></i>Cập nhật
                                            </button>
                                            <a href="/admin/category" class="btn btn-secondary">
                                                <i class="fas fa-times me-1"></i>Hủy
                                            </a>
                                            <a href="/admin/category/${category.id}" class="btn btn-info">
                                                <i class="fas fa-eye me-1"></i>Xem chi tiết
                                            </a>
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


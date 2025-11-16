<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8" />
    <title>Tạo danh mục mới - Hệ thống POS</title>
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
                    <h1 class="mt-4">Tạo danh mục mới</h1>
                    <ol class="breadcrumb mb-4">
                        <li class="breadcrumb-item"><a href="/admin">Dashboard</a></li>
                        <li class="breadcrumb-item"><a href="/admin/category">Danh mục</a></li>
                        <li class="breadcrumb-item active">Tạo mới</li>
                    </ol>
                    
                    <div class="row">
                        <div class="col-md-6 col-12 mx-auto">
                            <div class="card">
                                <div class="card-header">
                                    <i class="fas fa-tag me-1"></i>
                                    Thông tin danh mục
                                </div>
                                <div class="card-body">
                                    <form:form method="post" action="/admin/category/create" 
                                              modelAttribute="newCategory" class="row">
                                        
                                        <!-- Tên danh mục -->
                                        <div class="mb-3 col-12">
                                            <label class="form-label">
                                                <i class="fas fa-tag me-1"></i>Tên danh mục:
                                                <span class="text-danger">*</span>
                                            </label>
                                            <form:input type="text" class="form-control" path="name" 
                                                       placeholder="VD: Đồ uống, Thực phẩm..." required="required" />
                                            <form:errors path="name" cssClass="text-danger" />
                                            <small class="form-text text-muted">Mã danh mục sẽ được tự động tạo (VD: CAT001, CAT002...)</small>
                                        </div>
                                        
                                        <!-- Error message -->
                                        <c:if test="${not empty error}">
                                            <div class="alert alert-danger">${error}</div>
                                        </c:if>
                                        
                                        <!-- Buttons -->
                                        <div class="col-12 mb-3">
                                            <div class="d-flex justify-content-between">
                                                <a href="/admin/category" class="btn btn-secondary">
                                                    <i class="fas fa-arrow-left me-1"></i>Quay lại
                                                </a>
                                                <button type="submit" class="btn btn-primary">
                                                    <i class="fas fa-save me-1"></i>Tạo danh mục
                                                </button>
                                            </div>
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


<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <title>Chi tiết danh mục - Hệ thống POS</title>
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
                    <h1 class="mt-4">Chi tiết danh mục</h1>
                    <ol class="breadcrumb mb-4">
                        <li class="breadcrumb-item"><a href="/admin">Dashboard</a></li>
                        <li class="breadcrumb-item"><a href="/admin/category">Danh mục</a></li>
                        <li class="breadcrumb-item active">${category.id}</li>
                    </ol>

                    <div class="row">
                        <div class="col-md-6 mx-auto">
                            <div class="card mb-4">
                                <div class="card-header bg-info text-white">
                                    <i class="fas fa-tags me-2"></i>Thông tin danh mục
                                </div>
                                <div class="card-body">
                                    <table class="table table-borderless">
                                        <tbody>
                                            <tr>
                                                <th width="40%"><i class="fas fa-id-card me-2 text-muted"></i>Mã danh mục</th>
                                                <td><strong class="text-primary">${category.id}</strong></td>
                                            </tr>
                                            <tr>
                                                <th><i class="fas fa-tag me-2 text-muted"></i>Tên danh mục</th>
                                                <td><strong>${category.name}</strong></td>
                                            </tr>
                                            <tr>
                                                <th><i class="fas fa-box me-2 text-muted"></i>Số lượng sản phẩm</th>
                                                <td>
                                                    <span class="badge bg-success fs-6">${productCount}</span>
                                                    sản phẩm
                                                    <c:if test="${not empty sessionScope.storeId}">
                                                        <br/><small class="text-muted">(trong chi nhánh ${sessionScope.storeId})</small>
                                                    </c:if>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                                <div class="card-footer">
                                    <c:if test="${sessionScope.employeePosition == 'ADMIN'}">
                                        <a href="/admin/category/update/${category.id}" class="btn btn-warning btn-sm">
                                            <i class="fas fa-edit me-1"></i>Chỉnh sửa
                                        </a>
                                        <a href="/admin/category/delete/${category.id}" class="btn btn-danger btn-sm">
                                            <i class="fas fa-trash me-1"></i>Xóa
                                        </a>
                                    </c:if>
                                    <a href="/admin/category" class="btn btn-secondary btn-sm">
                                        <i class="fas fa-arrow-left me-1"></i>Quay lại
                                    </a>
                                </div>
                            </div>

                            <!-- Products in Category -->
                            <div class="card">
                                <div class="card-header bg-secondary text-white">
                                    <i class="fas fa-list me-2"></i>Danh sách sản phẩm
                                </div>
                                <div class="card-body">
                                    <c:choose>
                                        <c:when test="${productCount > 0}">
                                            <a href="/admin/product?categoryId=${category.id}" class="btn btn-primary">
                                                <i class="fas fa-eye me-1"></i>
                                                Xem ${productCount} sản phẩm
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="alert alert-info mb-0">
                                                <i class="fas fa-info-circle me-2"></i>
                                                Chưa có sản phẩm nào trong danh mục này
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
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


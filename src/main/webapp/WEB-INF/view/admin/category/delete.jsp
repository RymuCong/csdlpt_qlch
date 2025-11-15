<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <title>Xóa danh mục - Hệ thống POS</title>
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
                    <h1 class="mt-4">Xóa danh mục</h1>
                    <ol class="breadcrumb mb-4">
                        <li class="breadcrumb-item"><a href="/admin">Dashboard</a></li>
                        <li class="breadcrumb-item"><a href="/admin/category">Danh mục</a></li>
                        <li class="breadcrumb-item active">Xóa</li>
                    </ol>

                    <div class="row">
                        <div class="col-md-6 mx-auto">
                            <div class="card mb-4 border-danger">
                                <div class="card-header bg-danger text-white">
                                    <i class="fas fa-exclamation-triangle me-2"></i>Xác nhận xóa danh mục
                                </div>
                                <div class="card-body">
                                    <div class="alert alert-danger">
                                        <i class="fas fa-exclamation-triangle me-2"></i>
                                        <strong>Cảnh báo!</strong> Bạn có chắc chắn muốn xóa danh mục này không?
                                    </div>

                                    <table class="table table-bordered">
                                        <tbody>
                                            <tr>
                                                <th width="40%">Mã danh mục</th>
                                                <td><strong>${category.id}</strong></td>
                                            </tr>
                                            <tr>
                                                <th>Tên danh mục</th>
                                                <td><strong>${category.name}</strong></td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <div class="alert alert-warning">
                                        <small>
                                            <i class="fas fa-info-circle me-1"></i>
                                            <strong>Lưu ý:</strong> Việc xóa danh mục sẽ ảnh hưởng đến các sản phẩm thuộc danh mục này.
                                        </small>
                                    </div>

                                    <form:form action="/admin/category/delete" method="post" modelAttribute="category" acceptCharset="UTF-8">
                                        <form:input path="id" type="hidden" />
                                        
                                        <div class="mt-4">
                                            <button type="submit" class="btn btn-danger">
                                                <i class="fas fa-trash me-1"></i>Xác nhận xóa
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


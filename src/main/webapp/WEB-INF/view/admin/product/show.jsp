<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <title>Quản lý sản phẩm - Hệ thống POS</title>
    <link href="/css/styles.css" rel="stylesheet" />
    <link href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css" rel="stylesheet" />
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
</head>
<body class="sb-nav-fixed">
    <jsp:include page="../layout/header.jsp" />
    <div id="layoutSidenav">
        <jsp:include page="../layout/sidebar.jsp" />
        <div id="layoutSidenav_content">
            <main>
                <div class="container-fluid px-4">
                    <h1 class="mt-4">Quản lý sản phẩm</h1>
                    <ol class="breadcrumb mb-4">
                        <li class="breadcrumb-item"><a href="/admin">Dashboard</a></li>
                        <li class="breadcrumb-item active">Sản phẩm</li>
                    </ol>
                    
                    <!-- Alert messages -->
                    <c:if test="${param.success != null}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="fas fa-check-circle me-2"></i>Thao tác thành công!
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    
                    <!-- Stock Alerts -->
                    <c:if test="${lowStockCount != null && lowStockCount > 0}">
                        <div class="alert alert-warning alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            <strong>Cảnh báo!</strong> Có ${lowStockCount} sản phẩm sắp hết hàng.
                            <a href="/admin/product/low-stock" class="alert-link">Xem ngay</a>
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    
                    <!-- Quick Stats -->
                    <div class="row mb-4">
                        <div class="col-md-3">
                            <div class="card bg-info text-white">
                                <div class="card-body">
                                    <h6>Tổng sản phẩm</h6>
                                    <h3>${totalPages * 10}</h3>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card bg-warning text-white">
                                <div class="card-body">
                                    <h6>Sắp hết hàng</h6>
                                    <h3>${lowStockCount != null ? lowStockCount : 0}</h3>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <a href="/admin/product/low-stock" class="text-decoration-none">
                                <div class="card bg-danger text-white">
                                    <div class="card-body">
                                        <h6>Hết hàng</h6>
                                        <h3>
                                            <i class="fas fa-eye"></i> Xem
                                        </h3>
                                    </div>
                                </div>
                            </a>
                        </div>
                        <div class="col-md-3">
                            <a href="/admin/product/expiring" class="text-decoration-none">
                                <div class="card bg-secondary text-white">
                                    <div class="card-body">
                                        <h6>Sắp hết hạn</h6>
                                        <h3>
                                            <i class="fas fa-calendar-times"></i> Xem
                                        </h3>
                                    </div>
                                </div>
                            </a>
                        </div>
                    </div>
                    
                    <div class="card mb-4">
                        <div class="card-header">
                            <div class="row">
                                <div class="col-md-6">
                                    <i class="fas fa-boxes me-1"></i>
                                    Danh sách sản phẩm
                                </div>
                                <div class="col-md-6 text-end">
                                    <a href="/admin/product/create" class="btn btn-primary btn-sm">
                                        <i class="fas fa-plus me-1"></i>Thêm sản phẩm
                                    </a>
                                    <a href="/admin/product/inventory-report" class="btn btn-info btn-sm">
                                        <i class="fas fa-chart-bar me-1"></i>Báo cáo kho
                                    </a>
                                </div>
                            </div>
                        </div>
                        <div class="card-body">
                            <table id="datatablesSimple" class="table table-striped table-hover">
                                <thead>
                                    <tr>
                                        <th>Mã SP</th>
                                        <th>Tên sản phẩm</th>
                                        <th>Danh mục</th>
                                        <th>Giá</th>
                                        <th>Tồn kho</th>
                                        <th>HSD</th>
                                        <th>Cửa hàng</th>
                                        <th>Trạng thái</th>
                                        <th>Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="product" items="${products}">
                                        <tr class="${product.quantity == 0 ? 'table-danger' : product.quantity < 10 ? 'table-warning' : ''}">
                                            <td>${product.id}</td>
                                            <td>
                                                <strong>${product.name}</strong>
                                            </td>
                                            <td>
                                                <span class="badge bg-secondary">${product.category.name}</span>
                                            </td>
                                            <td>
                                                <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="₫" />
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${product.quantity == 0}">
                                                        <span class="badge bg-danger">
                                                            <i class="fas fa-times"></i> Hết hàng
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${product.quantity < 10}">
                                                        <span class="badge bg-warning text-dark">
                                                            <i class="fas fa-exclamation-triangle"></i> ${product.quantity}
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-success">${product.quantity}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${product.expDate != null}">
                                                        ${product.expDate}
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">-</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <i class="fas fa-store me-1"></i>${product.store.id}
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${product.quantity > 10}">
                                                        <span class="badge bg-success">Sẵn có</span>
                                                    </c:when>
                                                    <c:when test="${product.quantity > 0}">
                                                        <span class="badge bg-warning text-dark">Sắp hết</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-danger">Hết hàng</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <a href="/admin/product/${product.id}" class="btn btn-info btn-sm" title="Chi tiết">
                                                    <i class="fas fa-eye"></i>
                                                </a>
                                                <a href="/admin/product/update/${product.id}" class="btn btn-warning btn-sm" title="Sửa">
                                                    <i class="fas fa-edit"></i>
                                                </a>
                                                <a href="/admin/product/delete/${product.id}" class="btn btn-danger btn-sm" title="Xóa">
                                                    <i class="fas fa-trash"></i>
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                            
                            <!-- Pagination -->
                            <nav aria-label="Page navigation">
                                <ul class="pagination justify-content-center">
                                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                        <a class="page-link" href="/admin/product?page=${currentPage - 1}">
                                            <i class="fas fa-chevron-left"></i> Trước
                                        </a>
                                    </li>
                                    
                                    <c:forEach begin="1" end="${totalPages}" var="i">
                                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                                            <a class="page-link" href="/admin/product?page=${i}">${i}</a>
                                        </li>
                                    </c:forEach>
                                    
                                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                        <a class="page-link" href="/admin/product?page=${currentPage + 1}">
                                            Sau <i class="fas fa-chevron-right"></i>
                                        </a>
                                    </li>
                                </ul>
                            </nav>
                        </div>
                    </div>
                </div>
            </main>
            <jsp:include page="../layout/footer.jsp" />
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
    <script src="/js/scripts.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js" crossorigin="anonymous"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js" crossorigin="anonymous"></script>
    <script>
        $(document).ready(function() {
            $('#datatablesSimple').DataTable({
                language: {
                    url: '//cdn.datatables.net/plug-ins/1.13.6/i18n/vi.json'
                },
                order: [[4, 'asc']] // Sắp xếp theo số lượng tồn kho
            });
        });
    </script>
</body>
</html>

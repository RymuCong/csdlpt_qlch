<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <title>Sản phẩm sắp hết hàng - Hệ thống POS</title>
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
                    <h1 class="mt-4">
                        <i class="fas fa-exclamation-triangle text-warning"></i>
                        Sản phẩm sắp hết hàng
                    </h1>
                    <ol class="breadcrumb mb-4">
                        <li class="breadcrumb-item"><a href="/admin">Dashboard</a></li>
                        <li class="breadcrumb-item"><a href="/admin/product">Sản phẩm</a></li>
                        <li class="breadcrumb-item active">Cảnh báo tồn kho</li>
                    </ol>
                    
                    <!-- Alert -->
                    <div class="alert alert-warning alert-dismissible fade show" role="alert">
                        <i class="fas fa-info-circle me-2"></i>
                        <strong>Cảnh báo:</strong> Các sản phẩm có số lượng tồn kho dưới <strong>${threshold}</strong> đơn vị.
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    
                    <!-- Filter -->
                    <div class="card mb-4">
                        <div class="card-body">
                            <form action="/admin/product/low-stock" method="get" class="row g-3">
                                <div class="col-md-3">
                                    <label class="form-label">Ngưỡng cảnh báo</label>
                                    <input type="number" name="threshold" class="form-control" 
                                           value="${threshold}" min="1" />
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label">&nbsp;</label>
                                    <div>
                                        <button type="submit" class="btn btn-primary">
                                            <i class="fas fa-filter me-1"></i>Áp dụng
                                        </button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                    
                    <!-- Products Table -->
                    <div class="card mb-4">
                        <div class="card-header">
                            <i class="fas fa-box-open me-1"></i>
                            Danh sách sản phẩm cần nhập thêm
                            <span class="badge bg-danger ms-2">${products.size()} sản phẩm</span>
                        </div>
                        <div class="card-body">
                            <c:if test="${products.isEmpty()}">
                                <div class="alert alert-success">
                                    <i class="fas fa-check-circle me-2"></i>
                                    Tuyệt vời! Không có sản phẩm nào sắp hết hàng.
                                </div>
                            </c:if>
                            
                            <c:if test="${!products.isEmpty()}">
                                <table id="datatablesSimple" class="table table-striped table-hover">
                                    <thead>
                                        <tr>
                                            <th>Mã SP</th>
                                            <th>Tên sản phẩm</th>
                                            <th>Danh mục</th>
                                            <th>Số lượng</th>
                                            <th>Giá</th>
                                            <th>Ngày hết hạn</th>
                                            <th>Cửa hàng</th>
                                            <th>Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="product" items="${products}">
                                            <tr class="
                                                <c:if test="${product.quantity == 0}">table-danger</c:if>
                                                <c:if test="${product.quantity > 0 && product.quantity < threshold}">table-warning</c:if>
                                            ">
                                                <td>${product.id}</td>
                                                <td>
                                                    <strong>${product.name}</strong>
                                                    <c:if test="${product.quantity == 0}">
                                                        <span class="badge bg-danger ms-2">Hết hàng</span>
                                                    </c:if>
                                                </td>
                                                <td>${product.category.name}</td>
                                                <td>
                                                    <span class="badge 
                                                        <c:choose>
                                                            <c:when test="${product.quantity == 0}">bg-danger</c:when>
                                                            <c:when test="${product.quantity < 5}">bg-warning text-dark</c:when>
                                                            <c:otherwise>bg-secondary</c:otherwise>
                                                        </c:choose>
                                                    " style="font-size: 1em;">
                                                        ${product.quantity}
                                                    </span>
                                                </td>
                                                <td>
                                                    <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="₫" />
                                                </td>
                                                <td>
                                                    ${product.expDate}
                                                </td>
                                                <td>
                                                    <span class="badge bg-info">${product.store.id}</span>
                                                </td>
                                                <td>
                                                    <a href="/admin/product/${product.id}" class="btn btn-info btn-sm" title="Chi tiết">
                                                        <i class="fas fa-eye"></i>
                                                    </a>
                                                    <button class="btn btn-success btn-sm" title="Nhập hàng" 
                                                            onclick="showAddStockModal('${product.id}', '${product.name}')">
                                                        <i class="fas fa-plus-circle"></i> Nhập
                                                    </button>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </c:if>
                        </div>
                    </div>
                </div>
            </main>
            <jsp:include page="../layout/footer.jsp" />
        </div>
    </div>
    
    <!-- Add Stock Modal -->
    <div class="modal fade" id="addStockModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Nhập hàng</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="/admin/product/add-stock" method="post">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                    <input type="hidden" name="productId" id="modalProductId" />
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label">Sản phẩm</label>
                            <input type="text" class="form-control" id="modalProductName" readonly />
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Số lượng nhập thêm</label>
                            <input type="number" name="quantity" class="form-control" min="1" required />
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-success">
                            <i class="fas fa-save me-2"></i>Nhập hàng
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="/js/scripts.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
    <script>
        $(document).ready(function() {
            $('#datatablesSimple').DataTable({
                language: {
                    url: '//cdn.datatables.net/plug-ins/1.13.6/i18n/vi.json'
                },
                order: [[3, 'asc']] // Sắp xếp theo số lượng tăng dần
            });
        });
        
        function showAddStockModal(productId, productName) {
            $('#modalProductId').val(productId);
            $('#modalProductName').val(productName);
            var modal = new bootstrap.Modal(document.getElementById('addStockModal'));
            modal.show();
        }
    </script>
</body>
</html>


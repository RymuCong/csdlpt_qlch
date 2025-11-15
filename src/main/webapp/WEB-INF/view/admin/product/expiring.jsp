<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <title>Sản phẩm sắp hết hạn - Hệ thống POS</title>
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
                        <i class="fas fa-calendar-times text-danger"></i>
                        Sản phẩm sắp hết hạn
                    </h1>
                    <ol class="breadcrumb mb-4">
                        <li class="breadcrumb-item"><a href="/admin">Dashboard</a></li>
                        <li class="breadcrumb-item"><a href="/admin/product">Sản phẩm</a></li>
                        <li class="breadcrumb-item active">Cảnh báo hết hạn</li>
                    </ol>
                    
                    <!-- Alert -->
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        <strong>Cảnh báo:</strong> Các sản phẩm sẽ hết hạn trong vòng <strong>${days}</strong> ngày tới.
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    
                    <!-- Filter -->
                    <div class="card mb-4">
                        <div class="card-body">
                            <form action="/admin/product/expiring" method="get" class="row g-3">
                                <div class="col-md-3">
                                    <label class="form-label">Số ngày cảnh báo</label>
                                    <select name="days" class="form-select">
                                        <option value="7" ${days == 7 ? 'selected' : ''}>7 ngày</option>
                                        <option value="15" ${days == 15 ? 'selected' : ''}>15 ngày</option>
                                        <option value="30" ${days == 30 ? 'selected' : ''}>30 ngày</option>
                                        <option value="60" ${days == 60 ? 'selected' : ''}>60 ngày</option>
                                        <option value="90" ${days == 90 ? 'selected' : ''}>90 ngày</option>
                                    </select>
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
                            <i class="fas fa-clock me-1"></i>
                            Danh sách sản phẩm cần xử lý
                            <span class="badge bg-danger ms-2">${products.size()} sản phẩm</span>
                        </div>
                        <div class="card-body">
                            <c:if test="${products.isEmpty()}">
                                <div class="alert alert-success">
                                    <i class="fas fa-check-circle me-2"></i>
                                    Tuyệt vời! Không có sản phẩm nào sắp hết hạn trong ${days} ngày tới.
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
                                            <th>Còn lại</th>
                                            <th>Cửa hàng</th>
                                            <th>Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="product" items="${products}">
                                            <tr>
                                                <td>${product.id}</td>
                                                <td>
                                                    <strong>${product.name}</strong>
                                                </td>
                                                <td>${product.category.name}</td>
                                                <td>
                                                    <span class="badge bg-secondary" style="font-size: 1em;">
                                                        ${product.quantity}
                                                    </span>
                                                </td>
                                                <td>
                                                    <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="₫" maxFractionDigits="0" />
                                                </td>
                                                <td>
                                                    <strong>${product.expDate}</strong>
                                                </td>
                                                <td>
                                                    <span class="badge bg-warning text-dark">
                                                        <i class="fas fa-clock"></i> Sắp hết hạn
                                                    </span>
                                                </td>
                                                <td>
                                                    <span class="badge bg-info">${product.store.id}</span>
                                                </td>
                                                <td>
                                                    <a href="/admin/product/${product.id}" class="btn btn-info btn-sm" title="Chi tiết">
                                                        <i class="fas fa-eye"></i>
                                                    </a>
                                                    <a href="/admin/product/update/${product.id}" class="btn btn-warning btn-sm" title="Cập nhật">
                                                        <i class="fas fa-edit"></i>
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </c:if>
                        </div>
                    </div>
                    
                    <!-- Recommendations -->
                    <c:if test="${!products.isEmpty()}">
                        <div class="card mb-4 border-info">
                            <div class="card-header bg-info text-white">
                                <i class="fas fa-lightbulb me-2"></i>
                                Gợi ý xử lý
                            </div>
                            <div class="card-body">
                                <ul class="mb-0">
                                    <li>Tạo chương trình khuyến mãi cho sản phẩm sắp hết hạn</li>
                                    <li>Điều chuyển sản phẩm đến cửa hàng có nhu cầu cao hơn</li>
                                    <li>Liên hệ nhà cung cấp để trả lại hàng còn HSD dài</li>
                                    <li>Loại bỏ sản phẩm đã hết hạn khỏi kho</li>
                                </ul>
                            </div>
                        </div>
                    </c:if>
                </div>
            </main>
            <jsp:include page="../layout/footer.jsp" />
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="/js/scripts.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
    <script>
        $(document).ready(function() {
            let table = $('#datatablesSimple').DataTable({
                language: {
                    url: '//cdn.datatables.net/plug-ins/1.13.6/i18n/vi.json',
                    search: "Tìm kiếm:",
                    lengthMenu: "Hiển thị _MENU_ bản ghi",
                    info: "Hiển thị _START_ đến _END_ trong tổng số _TOTAL_ bản ghi",
                    infoEmpty: "Không có dữ liệu",
                    infoFiltered: "(lọc từ _MAX_ tổng số bản ghi)",
                    paginate: {
                        first: "Đầu",
                        last: "Cuối",
                        next: "Sau",
                        previous: "Trước"
                    }
                },
                order: [[5, 'asc']], // Sắp xếp theo ngày hết hạn tăng dần
                pageLength: 10,
                lengthMenu: [[10, 25, 50, -1], [10, 25, 50, "Tất cả"]],
                responsive: true,
                dom: '<"row"<"col-sm-12 col-md-6"l><"col-sm-12 col-md-6"f>>rt<"row"<"col-sm-12 col-md-5"i><"col-sm-12 col-md-7"p>>',
                columnDefs: [
                    { orderable: false, targets: 8 } // Cột "Thao tác" không sắp xếp được
                ]
            });
        });
    </script>
</body>
</html>


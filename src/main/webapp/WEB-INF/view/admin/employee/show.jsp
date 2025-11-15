<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <title>Quản lý nhân viên - Hệ thống POS</title>
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
                    <h1 class="mt-4">Quản lý nhân viên</h1>
                    <ol class="breadcrumb mb-4">
                        <li class="breadcrumb-item"><a href="/admin">Dashboard</a></li>
                        <li class="breadcrumb-item active">Nhân viên</li>
                    </ol>
                    
                    <!-- Alert messages -->
                    <c:if test="${param.success != null}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="fas fa-check-circle me-2"></i>Thao tác thành công!
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    
                    <c:if test="${param.deleted != null}">
                        <div class="alert alert-info alert-dismissible fade show" role="alert">
                            <i class="fas fa-info-circle me-2"></i>Đã xóa nhân viên thành công!
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    
                    <c:if test="${param.error != null}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-circle me-2"></i>Có lỗi xảy ra: ${param.error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    
                    <div class="card mb-4">
                        <div class="card-header">
                            <div class="row">
                                <div class="col-md-6">
                                    <i class="fas fa-users me-1"></i>
                                    Danh sách nhân viên
                                </div>
                                <div class="col-md-6 text-end">
                                    <c:if test="${sessionScope.employeePosition == 'ADMIN'}">
                                        <a href="/admin/employee/create" class="btn btn-primary btn-sm">
                                            <i class="fas fa-plus me-1"></i>Thêm nhân viên
                                        </a>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                        <div class="card-body">
                            <!-- Filter -->
                            <div class="row mb-3">
                                <div class="col-md-12">
                                    <form action="/admin/employee/filter" method="get" class="row g-3">
                                        <div class="col-md-4">
                                            <label class="form-label">Chức vụ</label>
                                            <select name="position" class="form-select">
                                                <option value="">Tất cả</option>
                                                <c:forEach var="pos" items="${positions}">
                                                    <option value="${pos}" ${pos == selectedPosition ? 'selected' : ''}>
                                                        ${pos.displayName}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label">&nbsp;</label>
                                            <div>
                                                <button type="submit" class="btn btn-primary">
                                                    <i class="fas fa-filter me-1"></i>Lọc
                                                </button>
                                                <a href="/admin/employee" class="btn btn-secondary">
                                                    <i class="fas fa-redo me-1"></i>Làm mới
                                                </a>
                                            </div>
                                        </div>
                                    </form>
                                </div>
                            </div>
                            
                            <table id="datatablesSimple" class="table table-striped table-hover">
                                <thead>
                                    <tr>
                                        <th>Mã NV</th>
                                        <th>Họ tên</th>
                                        <th>Số điện thoại</th>
                                        <th>Chức vụ</th>
                                        <th>Lương cơ bản</th>
                                        <th>Cửa hàng</th>
                                        <th>Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="employee" items="${employees}">
                                        <tr>
                                            <td>${employee.id}</td>
                                            <td>
                                                <i class="fas fa-user-circle me-1"></i>
                                                <strong>${employee.name}</strong>
                                            </td>
                                            <td>
                                                <i class="fas fa-phone me-1"></i>
                                                ${employee.phone}
                                            </td>
                                            <td>
                                                <span class="badge 
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
                                            </td>
                                            <td>
                                                <fmt:formatNumber value="${employee.baseSalary}" type="number" groupingUsed="true" /> ₫/giờ
                                            </td>
                                            <td>
                                                <i class="fas fa-store me-1"></i>
                                                ${employee.store.id}
                                            </td>
                                            <td>
                                                <a href="/admin/employee/${employee.id}" class="btn btn-info btn-sm" title="Chi tiết">
                                                    <i class="fas fa-eye"></i>
                                                </a>
                                                <c:if test="${sessionScope.employeePosition == 'ADMIN'}">
                                                    <a href="/admin/employee/update/${employee.id}" class="btn btn-warning btn-sm" title="Sửa">
                                                        <i class="fas fa-edit"></i>
                                                    </a>
                                                    <a href="/admin/employee/delete/${employee.id}" class="btn btn-danger btn-sm" title="Xóa">
                                                        <i class="fas fa-trash"></i>
                                                    </a>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
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
                order: [[0, 'asc']], // Sắp xếp theo mã NV
                pageLength: 10,
                lengthMenu: [[10, 25, 50, -1], [10, 25, 50, "Tất cả"]],
                responsive: true,
                dom: '<"row"<"col-sm-12 col-md-6"l><"col-sm-12 col-md-6"f>>rt<"row"<"col-sm-12 col-md-5"i><"col-sm-12 col-md-7"p>>',
                columnDefs: [
                    { orderable: false, targets: 6 } // Cột "Thao tác" không sắp xếp được
                ]
            });
        });
    </script>
</body>
</html>


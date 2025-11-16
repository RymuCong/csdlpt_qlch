<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8" />
    <title>Quản lý bảng lương - Hệ thống POS</title>
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
                    <h1 class="mt-4">Quản lý bảng lương</h1>
                    <ol class="breadcrumb mb-4">
                        <li class="breadcrumb-item"><a href="/admin">Dashboard</a></li>
                        <li class="breadcrumb-item active">Bảng lương</li>
                    </ol>
                    
                    <c:if test="${param.success != null}">
                        <div class="alert alert-success alert-dismissible fade show">
                            Thao tác thành công!
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    
                    <div class="card mb-4">
                        <div class="card-header">
                            <div class="row">
                                <div class="col-md-6">
                                    <i class="fas fa-money-check-alt me-1"></i>
                                    Danh sách bảng lương
                                </div>
                                <div class="col-md-6 text-end">
                                    <a href="/admin/payroll/create" class="btn btn-primary btn-sm">
                                        <i class="fas fa-user-plus me-1"></i>Tính lương cho 1 nhân viên
                                    </a>
                                    <a href="/admin/payroll/batch-create" class="btn btn-success btn-sm">
                                        <i class="fas fa-users me-1"></i>Tính lương hàng loạt
                                    </a>
                                    <a href="/admin/payroll/report" class="btn btn-info btn-sm">
                                        <i class="fas fa-chart-bar me-1"></i>Báo cáo
                                    </a>
                                </div>
                            </div>
                        </div>
                        <div class="card-body">
                            <!-- Filter -->
                            <div class="row mb-3">
                                <div class="col-md-12">
                                    <form action="/admin/payroll/filter" method="get" class="row g-3">
                                        <div class="col-md-3">
                                            <label class="form-label">Tháng (để trống = tất cả)</label>
                                            <c:choose>
                                                <c:when test="${selectedMonth != null}">
                                                    <c:set var="monthValue" value="${selectedMonth.monthValue}" />
                                                    <c:choose>
                                                        <c:when test="${monthValue < 10}">
                                                            <input type="month" name="month" class="form-control" 
                                                                   value="${selectedMonth.year}-0${monthValue}" />
                                                        </c:when>
                                                        <c:otherwise>
                                                            <input type="month" name="month" class="form-control" 
                                                                   value="${selectedMonth.year}-${monthValue}" />
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:when>
                                                <c:otherwise>
                                                    <input type="month" name="month" class="form-control" 
                                                           placeholder="Chọn tháng để lọc" />
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="col-md-3">
                                            <label class="form-label">&nbsp;</label>
                                            <div>
                                                <button type="submit" class="btn btn-primary">
                                                    <i class="fas fa-filter me-1"></i>Lọc
                                                </button>
                                                <a href="/admin/payroll" class="btn btn-secondary">
                                                    <i class="fas fa-redo me-1"></i>Làm mới
                                                </a>
                                            </div>
                                        </div>
                                    </form>
                                </div>
                            </div>
                            
                            <c:choose>
                                <c:when test="${empty payrolls}">
                                    <div class="alert alert-info">
                                        <i class="fas fa-info-circle me-2"></i>
                                        <strong>Không có dữ liệu bảng lương cho tháng được chọn.</strong>
                                        <br>
                                        <c:if test="${not empty availableMonths}">
                                            <span class="mt-2 d-block">
                                                <strong>Các tháng có dữ liệu:</strong>
                                                <c:forEach var="month" items="${availableMonths}" varStatus="status">
                                                    <a href="/admin/payroll/filter?month=${month.year}-${month.monthValue < 10 ? '0' : ''}${month.monthValue}" 
                                                       class="badge bg-primary me-1">
                                                        ${month.monthValue}/${month.year}
                                                    </a>
                                                </c:forEach>
                                            </span>
                                        </c:if>
                                        <span class="mt-2 d-block">
                                            Hoặc <a href="/admin/payroll/create" class="alert-link">tạo bảng lương mới</a> cho tháng này.
                                        </span>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <table id="datatablesSimple" class="table table-striped table-hover">
                                        <thead>
                                            <tr>
                                                <th>Mã BL</th>
                                                <th>Nhân viên</th>
                                                <th>Tháng</th>
                                                <th>Số giờ làm</th>
                                                <th>Lương cơ bản</th>
                                                <th>Thưởng</th>
                                                <th>Tổng lương</th>
                                                <th>Thao tác</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="payroll" items="${payrolls}">
                                                <tr>
                                                    <td><strong>${payroll.payId}</strong></td>
                                                    <td>
                                                        <i class="fas fa-user me-1"></i>
                                                        ${payroll.employee.name}
                                                        <br>
                                                        <small class="text-muted">${payroll.employee.position.displayName}</small>
                                                    </td>
                                                    <td>
                                                        ${payroll.payMonth}
                                                    </td>
                                                    <td>
                                                        <span class="badge bg-info">${payroll.workingHours} giờ</span>
                                                    </td>
                                                    <td>
                                                        <fmt:formatNumber value="${payroll.employee.baseSalary * payroll.workingHours}" 
                                                                          type="currency" currencySymbol="₫" maxFractionDigits="0" />
                                                    </td>
                                                    <td>
                                                        <c:if test="${payroll.bonus > 0}">
                                                            <span class="badge bg-success">
                                                                <fmt:formatNumber value="${payroll.bonus}" type="currency" currencySymbol="₫" maxFractionDigits="0" />
                                                            </span>
                                                        </c:if>
                                                    </td>
                                                    <td>
                                                        <strong class="text-success">
                                                            <fmt:formatNumber value="${payroll.total}" type="currency" currencySymbol="₫" maxFractionDigits="0" />
                                                        </strong>
                                                    </td>
                                                    <td>
                                                        <a href="/admin/payroll/${payroll.payId}" class="btn btn-info btn-sm" title="Chi tiết">
                                                            <i class="fas fa-eye"></i>
                                                        </a>
                                                        <a href="/admin/payroll/${payroll.payId}/print" class="btn btn-success btn-sm" title="In phiếu">
                                                            <i class="fas fa-print"></i>
                                                        </a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                        <tfoot>
                                            <tr class="table-warning">
                                                <th colspan="6" class="text-end">Tổng cộng:</th>
                                                <th>
                                                    <fmt:formatNumber value="${totalSalary}" type="currency" currencySymbol="₫" maxFractionDigits="0" />
                                                </th>
                                                <th></th>
                                            </tr>
                                        </tfoot>
                                    </table>
                                </c:otherwise>
                            </c:choose>
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
                order: [[2, 'desc']], // Sắp xếp theo tháng (cột thứ 3, index 2)
                pageLength: 10, // Hiển thị 10 bản ghi mỗi trang
                lengthMenu: [[10, 25, 50, -1], [10, 25, 50, "Tất cả"]], // Tùy chọn số bản ghi
                responsive: true, // Responsive cho mobile
                dom: '<"row"<"col-sm-12 col-md-6"l><"col-sm-12 col-md-6"f>>rt<"row"<"col-sm-12 col-md-5"i><"col-sm-12 col-md-7"p>>',
                columnDefs: [
                    { orderable: false, targets: 7 } // Cột "Thao tác" không sắp xếp được
                ]
            });
        });
    </script>
</body>
</html>


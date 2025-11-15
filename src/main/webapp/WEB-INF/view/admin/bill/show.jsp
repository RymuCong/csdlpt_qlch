<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8" />
    <title>Danh sách hóa đơn - Hệ thống POS</title>
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
                    <h1 class="mt-4">Danh sách hóa đơn</h1>
                    <ol class="breadcrumb mb-4">
                        <li class="breadcrumb-item"><a href="/admin">Dashboard</a></li>
                        <li class="breadcrumb-item active">Hóa đơn</li>
                    </ol>
                    
                    <c:if test="${param.deleted != null}">
                        <div class="alert alert-info alert-dismissible fade show">
                            Đã xóa hóa đơn thành công!
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    
                    <div class="card mb-4">
                        <div class="card-header">
                            <div class="row">
                                <div class="col-md-6">
                                    <i class="fas fa-receipt me-1"></i>
                                    Tất cả hóa đơn
                                </div>
                                <div class="col-md-6 text-end">
                                    <a href="/admin/bill/create" class="btn btn-success btn-sm">
                                        <i class="fas fa-plus me-1"></i>Tạo hóa đơn
                                    </a>
                                    <a href="/admin/bill/report/daily" class="btn btn-info btn-sm">
                                        <i class="fas fa-chart-bar me-1"></i>Báo cáo
                                    </a>
                                </div>
                            </div>
                        </div>
                        <div class="card-body">
                            <table id="datatablesSimple" class="table table-striped table-hover">
                                <thead>
                                    <tr>
                                        <th>Mã HĐ</th>
                                        <th>Ngày tạo</th>
                                        <th>Nhân viên</th>
                                        <th>Khách hàng</th>
                                        <th>Tổng tiền</th>
                                        <th>Giảm giá</th>
                                        <th>PT thanh toán</th>
                                        <th>Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="bill" items="${bills}">
                                        <tr>
                                            <td><strong>${bill.id}</strong></td>
                                            <td>
                                                ${bill.paymentDate}
                                            </td>
                                            <td>
                                                <i class="fas fa-user me-1"></i>
                                                ${bill.employee.name}
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${bill.customer != null}">
                                                        <i class="fas fa-user-tag me-1"></i>
                                                        ${bill.customer.name}
                                                        <span class="badge bg-info">Level ${bill.customer.level}</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">Khách lẻ</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <strong class="text-success">
                                                    <fmt:formatNumber value="${bill.totalPrice}" type="currency" currencySymbol="₫" />
                                                </strong>
                                            </td>
                                            <td>
                                                <c:if test="${bill.discount > 0}">
                                                    <span class="badge bg-warning text-dark">${bill.discount}%</span>
                                                </c:if>
                                            </td>
                                            <td>
                                                <span class="badge 
                                                    <c:choose>
                                                        <c:when test="${bill.paymentMethod.name() == 'CASH'}">bg-success</c:when>
                                                        <c:when test="${bill.paymentMethod.name() == 'TRANSFER'}">bg-info</c:when>
                                                        <c:when test="${bill.paymentMethod.name() == 'CARD'}">bg-primary</c:when>
                                                        <c:otherwise>bg-warning text-dark</c:otherwise>
                                                    </c:choose>
                                                ">
                                                    ${bill.paymentMethod.displayName}
                                                </span>
                                            </td>
                                            <td>
                                                <a href="/admin/bill/${bill.id}" class="btn btn-info btn-sm" title="Chi tiết">
                                                    <i class="fas fa-eye"></i>
                                                </a>
                                                <a href="/admin/bill/${bill.id}/print" class="btn btn-success btn-sm" title="In">
                                                    <i class="fas fa-print"></i>
                                                </a>
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
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
    <script>
        $(document).ready(function() {
            $('#datatablesSimple').DataTable({
                language: {
                    url: '//cdn.datatables.net/plug-ins/1.13.6/i18n/vi.json'
                },
                order: [[1, 'desc']] // Sắp xếp theo ngày giảm dần
            });
        });
    </script>
</body>
</html>


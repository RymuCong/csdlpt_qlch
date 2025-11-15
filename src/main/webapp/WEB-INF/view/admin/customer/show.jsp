<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8" />
    <title>Quản lý khách hàng - Hệ thống POS</title>
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
                    <h1 class="mt-4">Quản lý khách hàng</h1>
                    <ol class="breadcrumb mb-4">
                        <li class="breadcrumb-item"><a href="/admin">Dashboard</a></li>
                        <li class="breadcrumb-item active">Khách hàng</li>
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
                                    <i class="fas fa-users me-1"></i>
                                    Danh sách khách hàng
                                </div>
                                <div class="col-md-6 text-end">
                                    <a href="/admin/customer/create" class="btn btn-primary btn-sm">
                                        <i class="fas fa-plus me-1"></i>Thêm khách hàng
                                    </a>
                                    <a href="/admin/customer/top" class="btn btn-warning btn-sm">
                                        <i class="fas fa-crown me-1"></i>Top VIP
                                    </a>
                                </div>
                            </div>
                        </div>
                        <div class="card-body">
                            <table id="datatablesSimple" class="table table-striped table-hover">
                                <thead>
                                    <tr>
                                        <th>Mã KH</th>
                                        <th>Họ tên</th>
                                        <th>Số điện thoại</th>
                                        <th>Level</th>
                                        <th>Tổng chi tiêu</th>
                                        <th>Giảm giá</th>
                                        <th>Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="customer" items="${customers}">
                                        <tr>
                                            <td>${customer.id}</td>
                                            <td>
                                                <i class="fas fa-user me-1"></i>
                                                <strong>${customer.name}</strong>
                                            </td>
                                            <td>
                                                <i class="fas fa-phone me-1"></i>
                                                ${customer.phone}
                                            </td>
                                            <td>
                                                <span class="badge 
                                                    <c:choose>
                                                        <c:when test="${customer.level == 4}">bg-danger</c:when>
                                                        <c:when test="${customer.level == 3}">bg-warning</c:when>
                                                        <c:when test="${customer.level == 2}">bg-info</c:when>
                                                        <c:otherwise>bg-secondary</c:otherwise>
                                                    </c:choose>
                                                ">
                                                    Level ${customer.level}
                                                    <c:if test="${customer.level == 4}">
                                                        <i class="fas fa-crown"></i>
                                                    </c:if>
                                                </span>
                                            </td>
                                            <td>
                                                <strong class="text-success">
                                                    <fmt:formatNumber value="${customer.totalPayment}" type="currency" currencySymbol="₫" />
                                                </strong>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${customer.level == 4}">
                                                        <span class="badge bg-danger">15%</span>
                                                    </c:when>
                                                    <c:when test="${customer.level == 3}">
                                                        <span class="badge bg-warning text-dark">10%</span>
                                                    </c:when>
                                                    <c:when test="${customer.level == 2}">
                                                        <span class="badge bg-info">5%</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary">0%</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <a href="/admin/customer/${customer.id}" class="btn btn-info btn-sm" title="Chi tiết">
                                                    <i class="fas fa-eye"></i>
                                                </a>
                                                <a href="/admin/customer/update/${customer.id}" class="btn btn-warning btn-sm" title="Sửa">
                                                    <i class="fas fa-edit"></i>
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
                order: [[4, 'desc']] // Sắp xếp theo tổng chi tiêu
            });
        });
    </script>
</body>
</html>


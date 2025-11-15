<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8" />
    <title>Quản lý cửa hàng - Hệ thống POS</title>
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
                    <h1 class="mt-4">Quản lý cửa hàng</h1>
                    <ol class="breadcrumb mb-4">
                        <li class="breadcrumb-item"><a href="/admin">Dashboard</a></li>
                        <li class="breadcrumb-item active">Cửa hàng</li>
                    </ol>
                    
                    <c:if test="${param.success != null}">
                        <div class="alert alert-success alert-dismissible fade show">
                            Thao tác thành công!
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    
                    <div class="row">
                        <c:forEach var="store" items="${stores}">
                            <div class="col-md-4 mb-4">
                                <div class="card h-100">
                                    <div class="card-header bg-primary text-white">
                                        <h5><i class="fas fa-store me-2"></i>${store.id}</h5>
                                    </div>
                                    <div class="card-body">
                                        <p><i class="fas fa-map-marker-alt me-2"></i><strong>Địa chỉ:</strong><br>${store.address}</p>
                                        <p><i class="fas fa-phone me-2"></i><strong>SĐT:</strong> ${store.phone}</p>
                                        <p><i class="fas fa-ruler-combined me-2"></i><strong>Diện tích:</strong> 
                                           <fmt:formatNumber value="${store.area}" pattern="#,##0.00" /> m²</p>
                                    </div>
                                    <div class="card-footer">
                                        <div class="d-grid gap-2">
                                            <a href="/admin/store/${store.id}" class="btn btn-info btn-sm">
                                                <i class="fas fa-eye me-1"></i>Chi tiết
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
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


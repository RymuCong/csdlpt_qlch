<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Trang chủ - RedMart - Chuỗi Cửa Hàng Tiện Lợi</title>

                <!-- Google Web Fonts -->
                <link rel="preconnect" href="https://fonts.googleapis.com">
                <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
                <link
                    href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;600&family=Raleway:wght@600;800&display=swap"
                    rel="stylesheet">

                <!-- Icon Font Stylesheet -->
                <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.15.4/css/all.css" />
                <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css"
                    rel="stylesheet">

                <!-- Libraries Stylesheet -->
                <link href="/client/lib/lightbox/css/lightbox.min.css" rel="stylesheet">
                <link href="/client/lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">


                <!-- Customized Bootstrap Stylesheet -->
                <link href="/client/css/bootstrap.min.css" rel="stylesheet">

                <!-- Template Stylesheet -->
                <link href="/client/css/style.css" rel="stylesheet">
                
                <!-- Custom Styles for Homepage -->
                <style>
                    .product-card {
                        transition: transform 0.3s ease, box-shadow 0.3s ease;
                    }
                    .product-card:hover {
                        transform: translateY(-10px);
                        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15) !important;
                    }
                    .product-card img {
                        transition: transform 0.3s ease;
                    }
                    .product-card:hover img {
                        transform: scale(1.1);
                    }
                    .product-card .btn-danger {
                        transition: all 0.3s ease;
                    }
                    .product-card:hover .btn-danger {
                        background-color: #dc3545 !important;
                        transform: scale(1.05);
                    }
                </style>

            </head>

            <body>

                <!-- Spinner Start -->
                <div id="spinner"
                    class="show w-100 vh-100 bg-white position-fixed translate-middle top-50 start-50  d-flex align-items-center justify-content-center">
                    <div class="spinner-grow text-primary" role="status"></div>
                </div>
                <!-- Spinner End -->

                <jsp:include page="../layout/header.jsp" />              

                <!-- <jsp:include page="../homepage/capybara.jsp" />   -->
                <jsp:include page="../layout/banner.jsp" />
                <!-- Featured Products Start -->
                <div class="container-fluid py-5" style="background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);">
                    <div class="container py-5">
                        <div class="row mb-5">
                            <div class="col-lg-8 mx-auto text-center">
                                <h1 class="display-5 fw-bold text-danger mb-3">
                                    <i class="fas fa-star me-2"></i>Sản Phẩm Mới Nhất
                                </h1>
                                <p class="lead text-muted">Khám phá những sản phẩm mới nhất tại RedMart</p>
                                <a href="/products" class="btn btn-danger btn-lg rounded-pill px-5 mt-3">
                                    <i class="fas fa-shopping-bag me-2"></i>Xem Tất Cả Sản Phẩm
                                </a>
                            </div>
                        </div>
                        <div class="row g-4">
                            <c:forEach var="product" items="${products}">
                                <div class="col-md-6 col-lg-4 col-xl-3">
                                    <div class="card h-100 shadow-sm border-0 rounded-4 overflow-hidden product-card" style="transition: transform 0.3s ease, box-shadow 0.3s ease;">
                                        <div class="position-relative" style="height: 250px; overflow: hidden; background: #f8f9fa;">
                                            <c:choose>
                                                <c:when test="${not empty product.image}">
                                                    <img src="/images/product/${product.image}"
                                                        class="card-img-top h-100 w-100" 
                                                        alt="${product.name}"
                                                        style="object-fit: cover; transition: transform 0.3s ease;"
                                                        onerror="this.onerror=null; this.src='data:image/svg+xml,%3Csvg xmlns=%27http://www.w3.org/2000/svg%27 width=%27300%27 height=%27250%27%3E%3Cdefs%3E%3ClinearGradient id=%27grad%27 x1=%270%25%27 y1=%270%25%27 x2=%27100%25%27 y2=%27100%25%27%3E%3Cstop offset=%270%25%27 style=%27stop-color:%23f0f0f0;stop-opacity:1%27 /%3E%3Cstop offset=%27100%25%27 style=%27stop-color:%23e0e0e0;stop-opacity:1%27 /%3E%3C/linearGradient%3E%3C/defs%3E%3Crect fill=%27url(%23grad)%27 width=%27300%27 height=%27250%27/%3E%3Ctext fill=%27%23999%27 font-family=%27Arial, sans-serif%27 font-size=%2718%27 font-weight=%27bold%27 x=%2750%25%27 y=%2745%25%27 text-anchor=%27middle%27 dominant-baseline=%27middle%27%3E%3Ctspan x=%2750%25%27 dy=%27-10%27%3E🛍️%3C/tspan%3E%3Ctspan x=%2750%25%27 dy=%2720%27%3ENo Image%3C/tspan%3E%3C/text%3E%3C/svg%3E'">
                                                </c:when>
                                                <c:otherwise>
                                                    <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='300' height='250'%3E%3Cdefs%3E%3ClinearGradient id='grad' x1='0%25' y1='0%25' x2='100%25' y2='100%25'%3E%3Cstop offset='0%25' style='stop-color:%23f0f0f0;stop-opacity:1' /%3E%3Cstop offset='100%25' style='stop-color:%23e0e0e0;stop-opacity:1' /%3E%3C/linearGradient%3E%3C/defs%3E%3Crect fill='url(%23grad)' width='300' height='250'/%3E%3Ctext fill='%23999' font-family='Arial, sans-serif' font-size='18' font-weight='bold' x='50%25' y='45%25' text-anchor='middle' dominant-baseline='middle'%3E%3Ctspan x='50%25' dy='-10'%3E🛍️%3C/tspan%3E%3Ctspan x='50%25' dy='20'%3ENo Image%3C/tspan%3E%3C/text%3E%3C/svg%3E"
                                                        class="card-img-top h-100 w-100" 
                                                        alt="${product.name}"
                                                        style="object-fit: cover;">
                                                </c:otherwise>
                                            </c:choose>
                                            <c:if test="${product.category != null}">
                                                <span class="badge bg-danger position-absolute top-0 start-0 m-3 px-3 py-2 rounded-pill">
                                                    ${product.category.name}
                                                </span>
                                            </c:if>
                                            <c:if test="${product.quantity > 0 && product.quantity < 10}">
                                                <span class="badge bg-warning position-absolute top-0 end-0 m-3 px-2 py-1 rounded-pill">
                                                    <i class="fas fa-exclamation-triangle me-1"></i>Sắp hết
                                                </span>
                                            </c:if>
                                        </div>
                                        <div class="card-body d-flex flex-column">
                                            <h5 class="card-title fw-bold mb-2" style="min-height: 48px; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">
                                                <a href="/product/${product.id}" class="text-dark text-decoration-none">
                                                    ${product.name}
                                                </a>
                                            </h5>
                                            <div class="mb-3">
                                                <span class="badge bg-info text-white me-2">
                                                    <i class="fas fa-box me-1"></i>Còn: ${product.quantity}
                                                </span>
                                                <c:if test="${product.expDate != null}">
                                                    <span class="badge bg-secondary">
                                                        <i class="fas fa-calendar me-1"></i>HSD: 
                                                        <c:set var="expDate" value="${product.expDate}" />
                                                        ${expDate.dayOfMonth < 10 ? '0' : ''}${expDate.dayOfMonth}/${expDate.monthValue < 10 ? '0' : ''}${expDate.monthValue}/${expDate.year}
                                                    </span>
                                                </c:if>
                                            </div>
                                            <div class="mt-auto">
                                                <div class="d-flex justify-content-between align-items-center mb-3">
                                                    <span class="h4 text-danger fw-bold mb-0">
                                                        <fmt:formatNumber type="number" value="${product.price}" maxFractionDigits="0" groupingUsed="true" />₫
                                                    </span>
                                                </div>
                                                <a href="/product/${product.id}" class="btn btn-danger w-100 rounded-pill">
                                                    <i class="fas fa-eye me-2"></i>Xem chi tiết
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                        <c:if test="${empty products}">
                            <div class="alert alert-info text-center my-5">
                                <i class="fas fa-info-circle fa-3x mb-3"></i>
                                <h5>Chưa có sản phẩm mới</h5>
                                <p>Hiện tại chưa có sản phẩm mới để hiển thị.</p>
                            </div>
                        </c:if>
                    </div>
                </div>
                <!-- Featured Products End -->

                <jsp:include page="../layout/feature.jsp" />

                <jsp:include page="../layout/footer.jsp" />


                <!-- Back to Top -->
                <a href="#" class="btn btn-primary border-3 border-primary rounded-circle back-to-top"><i
                        class="fa fa-arrow-up"></i></a>


                <!-- JavaScript Libraries -->
                <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"></script>
                <script src="/client/lib/easing/easing.min.js"></script>
                <script src="/client/lib/waypoints/waypoints.min.js"></script>
                <script src="/client/lib/lightbox/js/lightbox.min.js"></script>
                <script src="/client/lib/owlcarousel/owl.carousel.min.js"></script>

                <!-- Template Javascript -->
                <script src="/client/js/main.js"></script>
            </body>

            </html>
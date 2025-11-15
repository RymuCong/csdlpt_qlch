<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="utf-8">
                <title> ${product.name} - Nhóm 3 CSDLPT</title>
                <meta content="width=device-width, initial-scale=1.0" name="viewport">
                <meta content="" name="keywords">
                <meta content="" name="description">

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
            </head>

            <body>

                <!-- Spinner Start -->
                <div id="spinner"
                    class="show w-100 vh-100 bg-white position-fixed translate-middle top-50 start-50  d-flex align-items-center justify-content-center">
                    <div class="spinner-grow text-primary" role="status"></div>
                </div>
                <!-- Spinner End -->

                <jsp:include page="../layout/header.jsp" />

                <!-- Single Product Start -->
                <div class="container-fluid py-5 mt-5">
                    <div class="container py-5" >
                        <div class="row g-4 mb-5">
                            <div>
                                <nav aria-label="breadcrumb">
                                    <ol class="breadcrumb">
                                        <li class="breadcrumb-item"><a href="/">Home</a></li>
                                        <li class="breadcrumb-item active" aria-current="page">Chi Tiết Sản Phẩm</li>
                                    </ol>
                                </nav>
                            </div>
                            <div class="col-lg-8 col-xl-9">
                                <div class="row g-4">
                                    <div class="col-lg-6">
                                        <div class="border rounded p-3 bg-light">
                                            <c:choose>
                                                <c:when test="${not empty product.image}">
                                                    <img src="/images/product/${product.image}" 
                                                         class="img-fluid rounded product-detail-image" 
                                                         alt="${product.name}"
                                                         style="max-height: 500px; width: 100%; object-fit: contain;"
                                                         onerror="this.onerror=null; this.src='data:image/svg+xml,%3Csvg xmlns=%27http://www.w3.org/2000/svg%27 width=%27500%27 height=%27500%27%3E%3Cdefs%3E%3ClinearGradient id=%27grad%27 x1=%270%25%27 y1=%270%25%27 x2=%27100%25%27 y2=%27100%25%27%3E%3Cstop offset=%270%25%27 style=%27stop-color:%23f0f0f0;stop-opacity:1%27 /%3E%3Cstop offset=%27100%25%27 style=%27stop-color:%23e0e0e0;stop-opacity:1%27 /%3E%3C/linearGradient%3E%3C/defs%3E%3Crect fill=%27url(%23grad)%27 width=%27500%27 height=%27500%27/%3E%3Ctext fill=%27%23999%27 font-family=%27Arial, sans-serif%27 font-size=%2724%27 font-weight=%27bold%27 x=%2750%25%27 y=%2745%25%27 text-anchor=%27middle%27 dominant-baseline=%27middle%27%3E%3Ctspan x=%2750%25%27 dy=%27-15%27%3E🛍️%3C/tspan%3E%3Ctspan x=%2750%25%27 dy=%2730%27%3ENo Image%3C/tspan%3E%3C/text%3E%3C/svg%3E'">
                                                </c:when>
                                                <c:otherwise>
                                                    <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='500' height='500'%3E%3Cdefs%3E%3ClinearGradient id='grad' x1='0%25' y1='0%25' x2='100%25' y2='100%25'%3E%3Cstop offset='0%25' style='stop-color:%23f0f0f0;stop-opacity:1' /%3E%3Cstop offset='100%25' style='stop-color:%23e0e0e0;stop-opacity:1' /%3E%3C/linearGradient%3E%3C/defs%3E%3Crect fill='url(%23grad)' width='500' height='500'/%3E%3Ctext fill='%23999' font-family='Arial, sans-serif' font-size='24' font-weight='bold' x='50%25' y='45%25' text-anchor='middle' dominant-baseline='middle'%3E%3Ctspan x='50%25' dy='-15'%3E🛍️%3C/tspan%3E%3Ctspan x='50%25' dy='30'%3ENo Image%3C/tspan%3E%3C/text%3E%3C/svg%3E"
                                                         class="img-fluid rounded product-detail-image" 
                                                         alt="${product.name}"
                                                         style="max-height: 500px; width: 100%; object-fit: contain;">
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                    <div class="col-lg-6">
                                        <h4 class="fw-bold mb-3"> ${product.name}</h4>
                                        <p class="mb-3">Danh mục: ${product.category.name}</p>
                                        <h5 class="fw-bold mb-3">
                                            <fmt:formatNumber type="number" value="${product.price}" maxFractionDigits="0" groupingUsed="true" /> đ

                                        </h5>
                                        <div class="d-flex mb-4">
                                            <i class="fa fa-star text-secondary"></i>
                                            <i class="fa fa-star text-secondary"></i>
                                            <i class="fa fa-star text-secondary"></i>
                                            <i class="fa fa-star text-secondary"></i>
                                            <i class="fa fa-star"></i>
                                        </div>
                                        <p class="mb-4">
                                            <span class="badge bg-success">Còn hàng: ${product.quantity}</span>
                                            <c:if test="${product.expDate != null}">
                                                <br/><small class="text-muted">Hạn sử dụng: 
                                                    <c:set var="expDate" value="${product.expDate}" />
                                                    ${expDate.dayOfMonth < 10 ? '0' : ''}${expDate.dayOfMonth}/${expDate.monthValue < 10 ? '0' : ''}${expDate.monthValue}/${expDate.year}
                                                </small>
                                            </c:if>
                                        </p>

                                        <div class="input-group quantity mb-5" style="width: 100px;">
                                            <div class="input-group-btn">
                                                <button class="btn btn-sm btn-minus rounded-circle bg-light border">
                                                    <i class="fa fa-minus"></i>
                                                </button>
                                            </div>
                                            <input type="text" class="form-control form-control-sm text-center border-0"
                                                value="1">
                                            <div class="input-group-btn">
                                                <button class="btn btn-sm btn-plus rounded-circle bg-light border">
                                                    <i class="fa fa-plus"></i>
                                                </button>
                                            </div>
                                        </div>
                                        <a href="#"
                                            class="btn border border-secondary rounded-pill px-4 py-2 mb-4 text-primary"><i
                                                class="fa fa-shopping-bag me-2 text-primary"></i> Thêm vào giỏ hàng</a>
                                    </div>
                                    <div class="col-lg-12">
                                        <nav>
                                            <div class="nav nav-tabs mb-3">
                                                <button class="nav-link active border-white border-bottom-0"
                                                    type="button" role="tab" id="nav-about-tab" data-bs-toggle="tab"
                                                    data-bs-target="#nav-about" aria-controls="nav-about"
                                                    aria-selected="true">Description</button>
                                            </div>
                                        </nav>
                                        <div class="tab-content mb-5">
                                            <div class="tab-pane active" id="nav-about" role="tabpanel"
                                                aria-labelledby="nav-about-tab">
                                                <p>
                                                    <strong>Tên sản phẩm:</strong> ${product.name}<br/>
                                                    <strong>Danh mục:</strong> ${product.category.name}<br/>
                                                    <strong>Giá:</strong> <fmt:formatNumber type="number" value="${product.price}" /> đ<br/>
                                                    <strong>Số lượng:</strong> ${product.quantity}<br/>
                                                    <c:if test="${product.expDate != null}">
                                                        <strong>Hạn sử dụng:</strong> 
                                                        <c:set var="expDateDetail" value="${product.expDate}" />
                                                        ${expDateDetail.dayOfMonth < 10 ? '0' : ''}${expDateDetail.dayOfMonth}/${expDateDetail.monthValue < 10 ? '0' : ''}${expDateDetail.monthValue}/${expDateDetail.year}<br/>
                                                    </c:if>
                                                    <strong>Cửa hàng:</strong> ${product.store.id}
                                                </p>

                                            </div>

                                        </div>
                                    </div>

                                </div>
                            </div>
                            <div class="col-lg-4 col-xl-3">
                                <div class="row g-4 fruite">
                                    <div class="col-lg-12">

                                        <!-- <div class="mb-4">
                                            <h4>Categories</h4>
                                            <ul class="list-unstyled fruite-categorie">
                                                <li>
                                                    <div class="d-flex justify-content-between fruite-name">
                                                        <a href="#"><i class="fas fa-apple-alt me-2"></i>Apples</a>
                                                        <span>(3)</span>
                                                    </div>
                                                </li>
                                                <li>
                                                    <div class="d-flex justify-content-between fruite-name">
                                                        <a href="#"><i class="fas fa-apple-alt me-2"></i>Dell</a>
                                                        <span>(5)</span>
                                                    </div>
                                                </li>
                                                <li>
                                                    <div class="d-flex justify-content-between fruite-name">
                                                        <a href="#"><i class="fas fa-apple-alt me-2"></i>Asus</a>
                                                        <span>(2)</span>
                                                    </div>
                                                </li>
                                                <li>
                                                    <div class="d-flex justify-content-between fruite-name">
                                                        <a href="#"><i class="fas fa-apple-alt me-2"></i>Acer</a>
                                                        <span>(8)</span>
                                                    </div>
                                                </li>
                                                <li>
                                                    <div class="d-flex justify-content-between fruite-name">
                                                        <a href="#"><i class="fas fa-apple-alt me-2"></i>Lenovo</a>
                                                        <span>(5)</span>
                                                    </div>
                                                </li>
                                            </ul>
                                        </div> -->
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
                <!-- Single Product End -->

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
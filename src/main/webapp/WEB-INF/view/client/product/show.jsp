<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="utf-8">
                    <title>Sản Phẩm - RedMart</title>
                    <meta content="width=device-width, initial-scale=1.0" name="viewport">
                    <meta content="Cửa hàng tiện lợi, thực phẩm, đồ uống" name="keywords">
                    <meta content="Hệ thống cửa hàng tiện lợi RedMart" name="description">

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
                    
                    <!-- Custom Styles for Pagination -->
                    <style>
                        /* Pagination Styles */
                        #pagination-container {
                            width: 100%;
                            margin: 2rem 0;
                        }
                        
                        #pagination {
                            display: flex !important;
                            flex-direction: row !important;
                            flex-wrap: wrap;
                            justify-content: center;
                            align-items: center;
                            list-style: none;
                            padding: 0;
                            margin: 0;
                            gap: 0.5rem;
                        }
                        
                        #pagination .page-item {
                            display: inline-block;
                            margin: 0;
                        }
                        
                        #pagination .page-link {
                            display: inline-flex;
                            align-items: center;
                            justify-content: center;
                            min-width: 45px;
                            height: 45px;
                            padding: 0.5rem 1rem;
                            margin: 0;
                            color: #6c757d;
                            background-color: #fff;
                            border: 2px solid #dee2e6;
                            border-radius: 50px;
                            text-decoration: none;
                            font-weight: 500;
                            transition: all 0.3s ease;
                            cursor: pointer;
                        }
                        
                        #pagination .page-link:hover:not(.disabled):not(.active) {
                            color: #dc3545;
                            background-color: #fff5f5;
                            border-color: #dc3545;
                            transform: translateY(-2px);
                            box-shadow: 0 4px 8px rgba(220, 53, 69, 0.2);
                        }
                        
                        #pagination .page-item.active .page-link {
                            color: #fff;
                            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
                            border-color: #dc3545;
                            box-shadow: 0 4px 12px rgba(220, 53, 69, 0.4);
                            font-weight: 600;
                        }
                        
                        #pagination .page-item.disabled .page-link {
                            color: #adb5bd;
                            background-color: #f8f9fa;
                            border-color: #e9ecef;
                            cursor: not-allowed;
                            opacity: 0.6;
                        }
                        
                        #pagination .page-item.disabled .page-link:hover {
                            transform: none;
                            box-shadow: none;
                        }
                        
                        #pagination .page-link span {
                            display: inline-block;
                        }
                        
                        /* Page Info Styles */
                        #pagination .page-info {
                            display: inline-flex !important;
                            align-items: center;
                            padding: 0.5rem 1rem;
                            margin-left: 1rem;
                            color: #6c757d;
                            font-size: 0.9rem;
                            white-space: nowrap;
                        }
                        
                        /* Search Bar Styles */
                        #productSearch {
                            border: 2px solid #dee2e6;
                            transition: all 0.3s ease;
                        }
                        
                        #productSearch:focus {
                            border-color: #dc3545;
                            box-shadow: 0 0 0 0.2rem rgba(220, 53, 69, 0.25);
                        }
                        
                        #btnSearch {
                            border-left: none;
                            transition: all 0.3s ease;
                        }
                        
                        #btnSearch:hover {
                            background-color: #c82333;
                            transform: scale(1.05);
                        }
                        
                        /* Responsive */
                        @media (max-width: 576px) {
                            #pagination .page-link {
                                min-width: 40px;
                                height: 40px;
                                padding: 0.4rem 0.8rem;
                                font-size: 0.9rem;
                            }
                            
                            #pagination .page-info {
                                display: none !important;
                            }
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

                    <!-- Single Product Start -->
                    <div class="container-fluid py-5 mt-5">
                        <div class="container py-5">
                            <div class="row g-4 mb-5">
                                <div>
                                    <nav aria-label="breadcrumb">
                                        <ol class="breadcrumb">
                                            <li class="breadcrumb-item"><a href="/">Home</a></li>
                                            <li class="breadcrumb-item active" aria-current="page">Danh Sách Sản Phẩm
                                            </li>
                                        </ol>
                                    </nav>
                                </div>

                                <div class="row g-4 fruite">
                                    <div class="col-12 col-md-4">
                                        <div class="row g-4">
                                            <!-- Search Bar -->
                                            <div class="col-12">
                                                <div class="mb-3">
                                                    <label for="productSearch" class="form-label"><b><i class="fas fa-search me-2"></i>Tìm kiếm sản phẩm</b></label>
                                                    <div class="input-group">
                                                        <input type="text" 
                                                               class="form-control rounded-pill" 
                                                               id="productSearch" 
                                                               placeholder="Nhập tên sản phẩm..."
                                                               value="${searchKeyword}">
                                                        <button class="btn btn-danger rounded-pill px-4" type="button" id="btnSearch">
                                                            <i class="fas fa-search"></i>
                                                        </button>
                                                    </div>
                                                    <small class="text-muted">Tìm kiếm kết hợp với bộ lọc bên dưới</small>
                                                </div>
                                            </div>
                                            
                                            <div class="col-12" id="categoryFilter">
                                                <div class="mb-2"><b>Danh mục sản phẩm</b></div>
                                                <c:forEach var="cat" items="${categories}">
                                                    <div class="form-check form-check-inline">
                                                        <input class="form-check-input" type="checkbox" 
                                                               id="cat-${cat.id}" value="${cat.id}">
                                                        <label class="form-check-label" for="cat-${cat.id}">${cat.name}</label>
                                                    </div>
                                                </c:forEach>
                                            </div>
                                            <div class="col-12">
                                                <div class="mb-2"><b>Tình trạng</b></div>
                                                <div class="form-check form-check-inline">
                                                    <input class="form-check-input" type="checkbox" id="stock-1"
                                                        value="in-stock">
                                                    <label class="form-check-label" for="stock-1">Còn hàng</label>
                                                </div>
                                                <div class="form-check form-check-inline">
                                                    <input class="form-check-input" type="checkbox" id="stock-2"
                                                        value="low-stock">
                                                    <label class="form-check-label" for="stock-2">Sắp hết</label>
                                                </div>
                                            </div>
                                            <div class="col-12" id="priceFilter">
                                                 <div class="mb-2"><b>Mức giá</b></div>

                                                <div class="form-check form-check-inline">
                                                    <input class="form-check-input" type="checkbox" id="price-1"
                                                        value="duoi-50k">
                                                    <label class="form-check-label" for="price-1">Dưới 50k</label>
                                                </div>

                                                <div class="form-check form-check-inline">
                                                    <input class="form-check-input" type="checkbox" id="price-2"
                                                        value="50k-100k">
                                                    <label class="form-check-label" for="price-2">50k - 100k</label>
                                                </div>

                                                <div class="form-check form-check-inline">
                                                    <input class="form-check-input" type="checkbox" id="price-3"
                                                        value="100k-200k">
                                                    <label class="form-check-label" for="price-3">100k - 200k</label>
                                                </div>

                                                <div class="form-check form-check-inline">
                                                    <input class="form-check-input" type="checkbox" id="price-4"
                                                        value="tren-200k">
                                                    <label class="form-check-label" for="price-4">Trên 200k</label>
                                                </div>
                                            </div>
                                            <div class="col-12">
                                                <div class="mb-2"><b>Sắp xếp</b></div>

                                                <div class="form-check form-check-inline">
                                                    <input class="form-check-input" type="radio" id="sort-1"
                                                        value="gia-tang-dan" name="radio-sort">
                                                    <label class="form-check-label" for="sort-1">Giá tăng dần</label>
                                                </div>

                                                <div class="form-check form-check-inline">
                                                    <input class="form-check-input" type="radio" id="sort-2"
                                                        value="gia-giam-dan" name="radio-sort">
                                                    <label class="form-check-label" for="sort-2">Giá giảm dần</label>
                                                </div>

                                                <div class="form-check form-check-inline">
                                                    <input class="form-check-input" type="radio" id="sort-3"
                                                        value="gia-nothing" name="radio-sort" checked>
                                                    <label class="form-check-label" for="sort-3">Không sắp xếp</label>
                                                </div>

                                            </div>
                                            <div class="col-12">
                                                <button id="btnFilter"
                                                    class="btn btn-primary rounded-pill px-4 py-3 text-white text-uppercase mb-4">
                                                    <i class="fas fa-filter me-2"></i>Lọc Sản Phẩm
                                                </button>
                                                <button id="btnResetFilter"
                                                    class="btn btn-outline-secondary rounded-pill px-3 py-2 text-uppercase mb-4">
                                                    <i class="fas fa-redo me-2"></i>Đặt lại
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-12 col-md-8 text-center">
                                        <!-- Search Results Header -->
                                        <c:if test="${not empty searchKeyword}">
                                            <div class="alert alert-info d-flex justify-content-between align-items-center mb-4">
                                                <div>
                                                    <i class="fas fa-search me-2"></i>
                                                    <strong>Kết quả tìm kiếm cho: "${searchKeyword}"</strong>
                                                    <span class="badge bg-danger ms-2" id="search-result-count">0</span> sản phẩm
                                                </div>
                                                <a href="/products" class="btn btn-sm btn-outline-danger">
                                                    <i class="fas fa-times me-1"></i>Xóa bộ lọc
                                                </a>
                                            </div>
                                        </c:if>
                                        <div class="row g-4">
                                            <c:forEach var="product" items="${products}">
                                                <div class="col-md-6 col-lg-4 product-item" 
                                                     data-category="${product.category != null ? product.category.id : ''}"
                                                     data-price="${product.price}"
                                                     data-quantity="${product.quantity}"
                                                     data-name="${fn:toLowerCase(product.name)}">
                                                    <div class="rounded position-relative fruite-item">
                                                        <div class="fruite-img">
                                                            <c:choose>
                                                                <c:when test="${not empty product.image}">
                                                                    <img src="/images/product/${product.image}"
                                                                        class="img-fluid w-100 rounded-top product-image" 
                                                                        alt="${product.name}"
                                                                        style="height: 250px; object-fit: cover;"
                                                                        onerror="this.onerror=null; this.src='data:image/svg+xml,%3Csvg xmlns=%27http://www.w3.org/2000/svg%27 width=%27300%27 height=%27250%27%3E%3Cdefs%3E%3ClinearGradient id=%27grad%27 x1=%270%25%27 y1=%270%25%27 x2=%27100%25%27 y2=%27100%25%27%3E%3Cstop offset=%270%25%27 style=%27stop-color:%23f0f0f0;stop-opacity:1%27 /%3E%3Cstop offset=%27100%25%27 style=%27stop-color:%23e0e0e0;stop-opacity:1%27 /%3E%3C/linearGradient%3E%3C/defs%3E%3Crect fill=%27url(%23grad)%27 width=%27300%27 height=%27250%27/%3E%3Ctext fill=%27%23999%27 font-family=%27Arial, sans-serif%27 font-size=%2718%27 font-weight=%27bold%27 x=%2750%25%27 y=%2745%25%27 text-anchor=%27middle%27 dominant-baseline=%27middle%27%3E%3Ctspan x=%2750%25%27 dy=%27-10%27%3E🛍️%3C/tspan%3E%3Ctspan x=%2750%25%27 dy=%2720%27%3ENo Image%3C/tspan%3E%3C/text%3E%3C/svg%3E'">
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='300' height='250'%3E%3Cdefs%3E%3ClinearGradient id='grad' x1='0%25' y1='0%25' x2='100%25' y2='100%25'%3E%3Cstop offset='0%25' style='stop-color:%23f0f0f0;stop-opacity:1' /%3E%3Cstop offset='100%25' style='stop-color:%23e0e0e0;stop-opacity:1' /%3E%3C/linearGradient%3E%3C/defs%3E%3Crect fill='url(%23grad)' width='300' height='250'/%3E%3Ctext fill='%23999' font-family='Arial, sans-serif' font-size='18' font-weight='bold' x='50%25' y='45%25' text-anchor='middle' dominant-baseline='middle'%3E%3Ctspan x='50%25' dy='-10'%3E🛍️%3C/tspan%3E%3Ctspan x='50%25' dy='20'%3ENo Image%3C/tspan%3E%3C/text%3E%3C/svg%3E"
                                                                        class="img-fluid w-100 rounded-top product-image" 
                                                                        alt="${product.name}"
                                                                        style="height: 250px; object-fit: cover;">
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                        <c:if test="${product.category != null}">
                                                            <div class="text-white bg-secondary px-3 py-1 rounded position-absolute"
                                                                style="top: 10px; left: 10px;">${product.category.name}
                                                            </div>
                                                        </c:if>
                                                        <div
                                                            class="p-4 border border-secondary border-top-0 rounded-bottom">
                                                            <h4 style="font-size: 15px;">
                                                                <a href="/product/${product.id}">
                                                                    ${product.name}
                                                                </a>

                                                            </h4>
                                                            <p style="font-size: 13px;">
                                                                <span class="badge bg-info">Còn: ${product.quantity}</span>
                                                                <c:if test="${product.expDate != null}">
                                                                    | HSD: 
                                                                    <c:set var="expDate" value="${product.expDate}" />
                                                                    ${expDate.dayOfMonth < 10 ? '0' : ''}${expDate.dayOfMonth}/${expDate.monthValue < 10 ? '0' : ''}${expDate.monthValue}/${expDate.year}
                                                                </c:if>
                                                            </p>
                                                            <div
                                                                class="d-flex  flex-lg-wrap justify-content-center flex-column">
                                                                <p style="font-size: 15px; text-align: center; width: 100%;"
                                                                    class="text-dark  fw-bold mb-3">
                                                                    <fmt:formatNumber type="number"
                                                                        value="${product.price}" maxFractionDigits="0" groupingUsed="true" />
                                                                    đ
                                                                </p>
                                                                <a href="/product/${product.id}"
                                                                    class="mx-auto btn border border-secondary rounded-pill px-3 text-primary">
                                                                    <i class="fa fa-eye me-2 text-primary"></i>
                                                                    Xem chi tiết
                                                                </a>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:forEach>

                                            <!-- Pagination (Client-side) -->
                                            <div id="pagination-container" class="w-100 mt-5 mb-4" style="display: none;">
                                                <div class="d-flex flex-column align-items-center">
                                                    <nav aria-label="Phân trang sản phẩm" class="d-flex justify-content-center">
                                                        <ul class="pagination mb-0" id="pagination">
                                                            <!-- Pagination sẽ được tạo bởi JavaScript -->
                                                        </ul>
                                                    </nav>
                                                    <div id="page-info" class="mt-3 text-muted d-none d-md-block">
                                                        <small><i class="fas fa-info-circle me-1"></i>Trang <span id="current-page-num">1</span> / <span id="total-pages-num">1</span></small>
                                                    </div>
                                                </div>
                                            </div>
                                            
                                            <!-- No products message -->
                                            <div id="no-products-message" class="alert alert-info text-center my-5" style="display: none;">
                                                <i class="fas fa-info-circle fa-3x mb-3"></i>
                                                <h5>Không tìm thấy sản phẩm</h5>
                                                <p>Không có sản phẩm nào phù hợp với bộ lọc của bạn.</p>
                                            </div>
                                            
                                            <!-- Empty state -->
                                            <c:if test="${empty products}">
                                                <div class="alert alert-info text-center my-5">
                                                    <i class="fas fa-info-circle fa-3x mb-3"></i>
                                                    <h5>Chưa có sản phẩm nào</h5>
                                                    <p>Hiện tại cửa hàng chưa có sản phẩm để hiển thị.</p>
                                                </div>
                                            </c:if>
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
                    
                    <!-- Product Filter & Pagination Script -->
                    <script>
                        // Pass search keyword from server to JavaScript
                        var searchKeyword = '<c:out value="${searchKeyword}" />';
                        
                        $(document).ready(function() {
                            const itemsPerPage = 12;
                            let currentPage = 1;
                            let filteredProducts = [];
                            
                            // Initialize: Hide all products first
                            $('.product-item').hide();
                            
                            // Filter function
                            function filterProducts() {
                                // Get search keyword
                                const searchKeyword = $('#productSearch').val().toLowerCase().trim();
                                
                                // Get selected categories
                                const selectedCategories = [];
                                $('#categoryFilter input[type="checkbox"]:checked').each(function() {
                                    selectedCategories.push($(this).val());
                                });
                                
                                // Get selected price ranges
                                const selectedPrices = [];
                                $('#priceFilter input[type="checkbox"]:checked').each(function() {
                                    selectedPrices.push($(this).val());
                                });
                                
                                // Get selected stock status
                                const selectedStock = [];
                                $('input[id^="stock-"]:checked').each(function() {
                                    selectedStock.push($(this).val());
                                });
                                
                                // Get sort option
                                const sortOption = $('input[name="radio-sort"]:checked').val();
                                
                                // Filter products
                                filteredProducts = [];
                                $('.product-item').each(function() {
                                    let show = true;
                                    const $item = $(this);
                                    const category = $item.data('category');
                                    const price = parseFloat($item.data('price'));
                                    const quantity = parseInt($item.data('quantity'));
                                    const productName = $item.data('name') || '';
                                    
                                    // Search filter (by product name)
                                    if (show && searchKeyword !== '') {
                                        if (!productName.includes(searchKeyword)) {
                                            show = false;
                                        }
                                    }
                                    
                                    // Category filter
                                    if (show && selectedCategories.length > 0 && !selectedCategories.includes(category)) {
                                        show = false;
                                    }
                                    
                                    // Price filter
                                    if (show && selectedPrices.length > 0) {
                                        let priceMatch = false;
                                        selectedPrices.forEach(function(priceRange) {
                                            if (priceRange === 'duoi-50k' && price < 50000) priceMatch = true;
                                            else if (priceRange === '50k-100k' && price >= 50000 && price <= 100000) priceMatch = true;
                                            else if (priceRange === '100k-200k' && price > 100000 && price <= 200000) priceMatch = true;
                                            else if (priceRange === 'tren-200k' && price > 200000) priceMatch = true;
                                        });
                                        if (!priceMatch) show = false;
                                    }
                                    
                                    // Stock filter
                                    if (show && selectedStock.length > 0) {
                                        let stockMatch = false;
                                        selectedStock.forEach(function(stock) {
                                            if (stock === 'in-stock' && quantity > 0) stockMatch = true;
                                            else if (stock === 'low-stock' && quantity > 0 && quantity < 10) stockMatch = true;
                                        });
                                        if (!stockMatch) show = false;
                                    }
                                    
                                    if (show) {
                                        filteredProducts.push($item);
                                    }
                                });
                                
                                // Sort products
                                if (sortOption !== 'gia-nothing') {
                                    filteredProducts.sort(function(a, b) {
                                        const priceA = parseFloat($(a).data('price'));
                                        const priceB = parseFloat($(b).data('price'));
                                        if (sortOption === 'gia-tang-dan') {
                                            return priceA - priceB;
                                        } else if (sortOption === 'gia-giam-dan') {
                                            return priceB - priceA;
                                        }
                                        return 0;
                                    });
                                }
                                
                                // Reset to first page
                                currentPage = 1;
                                
                                // Display products
                                displayProducts();
                            }
                            
                            // Display products with pagination
                            function displayProducts() {
                                // Hide all products
                                $('.product-item').hide();
                                
                                // Calculate pagination
                                const totalPages = Math.ceil(filteredProducts.length / itemsPerPage);
                                const startIndex = (currentPage - 1) * itemsPerPage;
                                const endIndex = startIndex + itemsPerPage;
                                
                                // Show products for current page
                                for (let i = startIndex; i < endIndex && i < filteredProducts.length; i++) {
                                    $(filteredProducts[i]).fadeIn(300);
                                }
                                
                                // Update search result count if exists
                                if ($('#search-result-count').length) {
                                    $('#search-result-count').text(filteredProducts.length);
                                }
                                
                                // Show/hide "No products" message
                                if (filteredProducts.length === 0) {
                                    $('#no-products-message').fadeIn(300);
                                    $('#pagination-container').hide();
                                } else {
                                    $('#no-products-message').hide();
                                    $('#pagination-container').fadeIn(300);
                                }
                                
                                // Update pagination
                                updatePagination(totalPages);
                            }
                            
                            // Update pagination UI
                            function updatePagination(totalPages) {
                                const $pagination = $('#pagination');
                                $pagination.empty();
                                
                                if (totalPages <= 1) {
                                    $('#pagination-container').hide();
                                    return;
                                }
                                
                                $('#pagination-container').fadeIn(300);
                                
                                // Previous button
                                const $prev = $('<li>').addClass('page-item' + (currentPage === 1 ? ' disabled' : ''));
                                const $prevLink = $('<a>').addClass('page-link').attr('href', '#').attr('aria-label', 'Trang trước');
                                $prevLink.append($('<i>').addClass('fas fa-chevron-left'));
                                $prevLink.on('click', function(e) {
                                    e.preventDefault();
                                    if (currentPage > 1) {
                                        currentPage--;
                                        displayProducts();
                                        $('html, body').animate({scrollTop: $('.row.g-4').offset().top - 100}, 500);
                                    }
                                });
                                $prev.append($prevLink);
                                $pagination.append($prev);
                                
                                // Page numbers
                                let startPage = Math.max(1, currentPage - 2);
                                let endPage = Math.min(totalPages, currentPage + 2);
                                
                                // Show first page
                                if (startPage > 1) {
                                    const $firstPage = $('<li>').addClass('page-item');
                                    const $firstLink = $('<a>').addClass('page-link').attr('href', '#').text('1');
                                    $firstLink.on('click', function(e) {
                                        e.preventDefault();
                                        currentPage = 1;
                                        displayProducts();
                                        $('html, body').animate({scrollTop: $('.row.g-4').offset().top - 100}, 500);
                                    });
                                    $firstPage.append($firstLink);
                                    $pagination.append($firstPage);
                                    
                                    if (startPage > 2) {
                                        const $ellipsis = $('<li>').addClass('page-item disabled');
                                        $ellipsis.append($('<span>').addClass('page-link').html('<i class="fas fa-ellipsis-h"></i>'));
                                        $pagination.append($ellipsis);
                                    }
                                }
                                
                                // Show page range
                                for (let i = startPage; i <= endPage; i++) {
                                    const $page = $('<li>').addClass('page-item' + (i === currentPage ? ' active' : ''));
                                    const $pageLink = $('<a>').addClass('page-link').attr('href', '#').text(i);
                                    $pageLink.on('click', function(e) {
                                        e.preventDefault();
                                        currentPage = i;
                                        displayProducts();
                                        $('html, body').animate({scrollTop: $('.row.g-4').offset().top - 100}, 500);
                                    });
                                    $page.append($pageLink);
                                    $pagination.append($page);
                                }
                                
                                // Show last page
                                if (endPage < totalPages) {
                                    if (endPage < totalPages - 1) {
                                        const $ellipsis = $('<li>').addClass('page-item disabled');
                                        $ellipsis.append($('<span>').addClass('page-link').html('<i class="fas fa-ellipsis-h"></i>'));
                                        $pagination.append($ellipsis);
                                    }
                                    
                                    const $lastPage = $('<li>').addClass('page-item');
                                    const $lastLink = $('<a>').addClass('page-link').attr('href', '#').text(totalPages);
                                    $lastLink.on('click', function(e) {
                                        e.preventDefault();
                                        currentPage = totalPages;
                                        displayProducts();
                                        $('html, body').animate({scrollTop: $('.row.g-4').offset().top - 100}, 500);
                                    });
                                    $lastPage.append($lastLink);
                                    $pagination.append($lastPage);
                                }
                                
                                // Next button
                                const $next = $('<li>').addClass('page-item' + (currentPage === totalPages ? ' disabled' : ''));
                                const $nextLink = $('<a>').addClass('page-link').attr('href', '#').attr('aria-label', 'Trang sau');
                                $nextLink.append($('<i>').addClass('fas fa-chevron-right'));
                                $nextLink.on('click', function(e) {
                                    e.preventDefault();
                                    if (currentPage < totalPages) {
                                        currentPage++;
                                        displayProducts();
                                        $('html, body').animate({scrollTop: $('.row.g-4').offset().top - 100}, 500);
                                    }
                                });
                                $next.append($nextLink);
                                $pagination.append($next);
                                
                                // Update page info
                                $('#current-page-num').text(currentPage);
                                $('#total-pages-num').text(totalPages);
                                if (totalPages > 1) {
                                    $('#page-info').fadeIn(300);
                                } else {
                                    $('#page-info').hide();
                                }
                            }
                            
                            // Initialize: Show all products on first load
                            filterProducts();
                            
                            // If there's a search keyword, update result count after initial filter
                            if (searchKeyword && searchKeyword.trim() !== '') {
                                setTimeout(function() {
                                    $('#search-result-count').text(filteredProducts.length);
                                }, 100);
                            }
                            
                            // Event listeners
                            $('#categoryFilter input[type="checkbox"], #priceFilter input[type="checkbox"], input[id^="stock-"]').on('change', function() {
                                filterProducts();
                                $('#btnFilter').addClass('btn-primary text-white').removeClass('border-secondary text-primary');
                            });
                            
                            $('input[name="radio-sort"]').on('change', function() {
                                filterProducts();
                            });
                            
                            // Search input - real-time search with debounce
                            let searchTimeout;
                            $('#productSearch').on('input', function() {
                                clearTimeout(searchTimeout);
                                searchTimeout = setTimeout(function() {
                                    filterProducts();
                                }, 300); // Wait 300ms after user stops typing
                            });
                            
                            // Search button
                            $('#btnSearch').on('click', function() {
                                filterProducts();
                                // Scroll to products
                                $('html, body').animate({scrollTop: $('.row.g-4').offset().top - 100}, 500);
                            });
                            
                            // Search on Enter key
                            $('#productSearch').on('keypress', function(e) {
                                if (e.which === 13) {
                                    e.preventDefault();
                                    filterProducts();
                                    $('html, body').animate({scrollTop: $('.row.g-4').offset().top - 100}, 500);
                                }
                            });
                            
                            // Filter button (manual trigger)
                            $('#btnFilter').on('click', function() {
                                filterProducts();
                                $(this).addClass('btn-primary text-white').removeClass('border-secondary text-primary');
                            });
                            
                            // Reset button
                            $('#btnResetFilter').on('click', function() {
                                // Clear search
                                $('#productSearch').val('');
                                
                                // Uncheck all filters
                                $('#categoryFilter input[type="checkbox"]:checked').prop('checked', false);
                                $('#priceFilter input[type="checkbox"]:checked').prop('checked', false);
                                $('input[id^="stock-"]:checked').prop('checked', false);
                                $('input[name="radio-sort"][value="gia-nothing"]').prop('checked', true);
                                
                                // Reset filter button style
                                $('#btnFilter').removeClass('btn-primary text-white').addClass('border-secondary text-primary');
                                
                                // Re-filter
                                filterProducts();
                            });
                        });
                    </script>
                </body>

                </html>
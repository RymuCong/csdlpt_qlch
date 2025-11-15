<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="utf-8">
                    <title>Sản Phẩm - MiniMart Plus</title>
                    <meta content="width=device-width, initial-scale=1.0" name="viewport">
                    <meta content="Cửa hàng tiện lợi, thực phẩm, đồ uống" name="keywords">
                    <meta content="Hệ thống cửa hàng tiện lợi MiniMart Plus" name="description">

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
                                                    class="btn border-secondary rounded-pill px-4 py-3 text-primary text-uppercase mb-4">
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
                                        <div class="row g-4">
                                            <c:forEach var="product" items="${products}">
                                                <div class="col-md-6 col-lg-4 product-item" 
                                                     data-category="${product.category != null ? product.category.id : ''}"
                                                     data-price="${product.price}"
                                                     data-quantity="${product.quantity}">
                                                    <div class="rounded position-relative fruite-item">
                                                        <div class="fruite-img">
                                                            <c:choose>
                                                                <c:when test="${not empty product.image}">
                                                                    <img src="/images/product/${product.image}"
                                                                        class="img-fluid w-100 rounded-top" alt="${product.name}">
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <img src="/images/product/default.png"
                                                                        class="img-fluid w-100 rounded-top" alt="${product.name}"
                                                                        onerror="this.src='data:image/svg+xml,%3Csvg xmlns=\'http://www.w3.org/2000/svg\' width=\'300\' height=\'200\'%3E%3Crect fill=\'%23ddd\' width=\'300\' height=\'200\'/%3E%3Ctext fill=\'%23999\' font-family=\'sans-serif\' font-size=\'16\' x=\'50%25\' y=\'50%25\' text-anchor=\'middle\' dominant-baseline=\'middle\'%3ENo Image%3C/text%3E%3C/svg%3E'">
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
                                                                    | HSD: ${product.expDate}
                                                                </c:if>
                                                            </p>
                                                            <div
                                                                class="d-flex  flex-lg-wrap justify-content-center flex-column">
                                                                <p style="font-size: 15px; text-align: center; width: 100%;"
                                                                    class="text-dark  fw-bold mb-3">
                                                                    <fmt:formatNumber type="number"
                                                                        value="${product.price}" />
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

                                            <!-- Pagination -->
                                            <c:if test="${totalPages > 0}">
                                                <div class="pagination d-flex justify-content-center mt-5">
                                                    <li class="page-item">
                                                        <a class="${1 eq currentPage ? 'disabled page-link' : 'page-link'}"
                                                            href="/products?page=${currentPage - 1}" aria-label="Previous">
                                                            <span aria-hidden="true">&laquo;</span>
                                                        </a>
                                                    </li>
                                                    <c:forEach begin="0" end="${totalPages - 1}" varStatus="loop">
                                                        <li class="page-item">
                                                            <a class="${(loop.index + 1) eq currentPage ? 'active page-link' : 'page-link'}"
                                                                href="/products?page=${loop.index + 1}">
                                                                ${loop.index + 1}
                                                            </a>
                                                        </li>
                                                    </c:forEach>
                                                    <li class="page-item">
                                                        <a class="${totalPages eq currentPage ? 'disabled page-link' : 'page-link'}"
                                                            href="/products?page=${currentPage + 1}" aria-label="Next">
                                                            <span aria-hidden="true">&raquo;</span>
                                                        </a>
                                                    </li>
                                                </div>
                                            </c:if>
                                            
                                            <!-- No products message -->
                                            <c:if test="${totalPages == 0 || empty products}">
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
                    
                    <!-- Product Filter Script -->
                    <script>
                        $(document).ready(function() {
                            // Filter function
                            function filterProducts() {
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
                                let visibleCount = 0;
                                $('.product-item').each(function() {
                                    let show = true;
                                    const $item = $(this);
                                    const category = $item.data('category');
                                    const price = parseFloat($item.data('price'));
                                    const quantity = parseInt($item.data('quantity'));
                                    
                                    // Category filter
                                    if (selectedCategories.length > 0 && !selectedCategories.includes(category)) {
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
                                    
                                    // Show/hide product
                                    if (show) {
                                        $item.fadeIn(300);
                                        visibleCount++;
                                    } else {
                                        $item.fadeOut(300);
                                    }
                                });
                                
                                // Show "No products" message
                                if (visibleCount === 0) {
                                    if ($('#no-products-message').length === 0) {
                                        $('.row.g-4').append(
                                            '<div id="no-products-message" class="col-12 alert alert-info text-center my-5">' +
                                            '<i class="fas fa-info-circle fa-3x mb-3"></i>' +
                                            '<h5>Không tìm thấy sản phẩm</h5>' +
                                            '<p>Không có sản phẩm nào phù hợp với bộ lọc của bạn.</p>' +
                                            '</div>'
                                        );
                                    }
                                } else {
                                    $('#no-products-message').remove();
                                }
                                
                                // Sort products
                                if (sortOption !== 'gia-nothing') {
                                    const $container = $('.row.g-4');
                                    const $items = $('.product-item').detach().sort(function(a, b) {
                                        const priceA = parseFloat($(a).data('price'));
                                        const priceB = parseFloat($(b).data('price'));
                                        if (sortOption === 'gia-tang-dan') {
                                            return priceA - priceB;
                                        } else if (sortOption === 'gia-giam-dan') {
                                            return priceB - priceA;
                                        }
                                        return 0;
                                    });
                                    $container.append($items);
                                }
                            }
                            
                            // Event listeners
                            $('#categoryFilter input[type="checkbox"], #priceFilter input[type="checkbox"], input[id^="stock-"]').on('change', filterProducts);
                            $('input[name="radio-sort"]').on('change', filterProducts);
                            
                            // Filter button (manual trigger)
                            $('#btnFilter').on('click', function() {
                                filterProducts();
                                $(this).addClass('btn-primary').removeClass('border-secondary');
                            });
                            
                            // Reset button
                            $('#btnResetFilter').on('click', function() {
                                // Uncheck all filters
                                $('#categoryFilter input[type="checkbox"]:checked').prop('checked', false);
                                $('#priceFilter input[type="checkbox"]:checked').prop('checked', false);
                                $('input[id^="stock-"]:checked').prop('checked', false);
                                $('input[name="radio-sort"][value="gia-nothing"]').prop('checked', true);
                                
                                // Show all products
                                $('.product-item').fadeIn(300);
                                $('#no-products-message').remove();
                                
                                // Reset filter button style
                                $('#btnFilter').removeClass('btn-primary').addClass('border-secondary');
                            });
                        });
                    </script>
                </body>

                </html>
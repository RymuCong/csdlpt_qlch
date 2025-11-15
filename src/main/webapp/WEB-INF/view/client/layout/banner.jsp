<!-- Hero Start -->
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<div class="container-fluid py-5 mb-5 hero-header" style="background: linear-gradient(135deg, #28a745 0%, #20c997 100%) !important;">
    <div class="container py-5">
        <div class="row g-5 align-items-center">
            <div class="col-md-12 col-lg-7">
                <h4 class="mb-3 text-white"><i class="fas fa-store-alt me-2"></i>Chuỗi Cửa Hàng Tiện Lợi</h4>
                <h1 class="mb-4 display-3 text-white">MiniMart Plus</h1>
                <p class="text-white mb-5">
                    <i class="fas fa-shopping-basket me-2"></i>Mua sắm tiện lợi - Giá cả phải chăng - Phục vụ 24/7
                </p>
                <div class="position-relative mx-auto">
                    <input class="form-control border-2 border-white w-75 py-3 px-4 rounded-pill"
                        type="text" placeholder="Tìm kiếm sản phẩm...">
                    <button type="submit"
                        class="btn btn-light border-2 border-white py-3 px-4 position-absolute rounded-pill text-success h-100"
                        style="top: 0; right: 25%;">
                        <i class="fas fa-search"></i> Tìm kiếm
                    </button>
                </div>
            </div>
            <div class="col-md-12 col-lg-5">
                <div id="carouselId" class="carousel slide position-relative" data-bs-ride="carousel">
                    <div class="carousel-inner" role="listbox">
                        <div class="carousel-item active rounded">
                            <img src="/client/img/Banner_1.png"
                                class="img-fluid w-100 h-100 bg-secondary rounded" alt="First slide">
                            <!-- <a href="#" class="btn px-4 py-2 text-white rounded">Fruites</a> -->
                        </div>
                        <div class="carousel-item rounded">
                            <img src="/client/img/Banner_2.png" class="img-fluid w-100 h-100 rounded"
                                alt="Second slide">
                            <!-- <a href="#" class="btn px-4 py-2 text-white rounded">Vesitables</a> -->
                        </div>
                    </div>
                    <button class="carousel-control-prev" type="button" data-bs-target="#carouselId"
                        data-bs-slide="prev">
                        <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                        <span class="visually-hidden">Previous</span>
                    </button>
                    <button class="carousel-control-next" type="button" data-bs-target="#carouselId"
                        data-bs-slide="next">
                        <span class="carousel-control-next-icon" aria-hidden="true"></span>
                        <span class="visually-hidden">Next</span>
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- Hero End -->
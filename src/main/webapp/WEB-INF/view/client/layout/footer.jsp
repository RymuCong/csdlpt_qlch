<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
 <!-- Footer Start -->
 <div class="container-fluid bg-dark text-white-50 footer pt-5 mt-5">
    <div class="container py-5">
        <div class="pb-4 mb-4" style="border-bottom: 1px solid rgba(226, 175, 24, 0.5) ;">
            <div class="row g-4">
                <div class="col-lg-3">
                    <a href="#">
                        <h1 class="text-danger mb-0 fw-bold">
                            <i class="fas fa-store-alt me-2"></i>RedMart
                        </h1>
                        <p class="text-secondary mb-0">Chuỗi cửa hàng tiện lợi uy tín</p>
                    </a>
                </div>
                <div class="col-lg-6">
                    <div class="text-center">
                        <h5 class="text-white mb-3">Liên hệ với chúng tôi</h5>
                        <p class="text-secondary">
                            <i class="fas fa-phone me-2"></i>Hotline: 1900 xxxx<br>
                            <i class="fas fa-envelope me-2"></i>Email: support@redmart.vn
                        </p>
                    </div>
                </div>
                <div class="col-lg-3">
                    <div class="d-flex justify-content-end pt-3">
                        <a class="btn  btn-outline-secondary me-2 btn-md-square rounded-circle" href=""><i
                                class="fab fa-twitter"></i></a>
                        <a class="btn btn-outline-secondary me-2 btn-md-square rounded-circle" href=""><i
                                class="fab fa-facebook-f"></i></a>
                        <a class="btn btn-outline-secondary me-2 btn-md-square rounded-circle" href=""><i
                                class="fab fa-youtube"></i></a>
                        <a class="btn btn-outline-secondary btn-md-square rounded-circle" href=""><i
                                class="fab fa-linkedin-in"></i></a>
                    </div>
                </div>
            </div>
        </div>
        <div class="row g-5">
            <div class="col-lg-3 col-md-6">
                <div class="footer-item">
                    <h4 class="text-light mb-3">Về RedMart</h4>
                    <p class="mb-4">Chuỗi cửa hàng tiện lợi uy tín, cung cấp đa dạng sản phẩm thiết yếu với giá cả hợp lý. Mở cửa 24/7 để phục vụ mọi nhu cầu của bạn!</p>
                    <a href="/products" class="btn border-secondary py-2 px-4 rounded-pill text-danger">
                        <i class="fas fa-shopping-basket me-2"></i>Xem sản phẩm
                    </a>
                </div>
            </div>
            <div class="col-lg-3 col-md-6">
                <div class="d-flex flex-column text-start footer-item">
                    <h4 class="text-light mb-3">Hệ thống cửa hàng</h4>
                    <c:choose>
                        <c:when test="${not empty stores}">
                            <c:forEach var="store" items="${stores}" varStatus="status">
                                <c:if test="${status.index < 7}">
                                    <a class="btn-link text-white-50 mb-2" href="#" title="${store.address}">
                                        <i class="fas fa-map-marker-alt me-2 text-danger"></i>
                                        <strong>${store.id}</strong> - 
                                        <c:choose>
                                            <c:when test="${fn:length(store.address) > 40}">
                                                ${fn:substring(store.address, 0, 40)}...
                                            </c:when>
                                            <c:otherwise>
                                                ${store.address}
                                            </c:otherwise>
                                        </c:choose>
                                    </a>
                                </c:if>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <a class="btn-link" href="#"><i class="fas fa-map-marker-alt me-2"></i>TS01 - Trụ sở chính</a>
                            <a class="btn-link" href="#"><i class="fas fa-map-marker-alt me-2"></i>CN01 - Chi nhánh 01</a>
                            <a class="btn-link" href="#"><i class="fas fa-map-marker-alt me-2"></i>CN02 - Chi nhánh 02</a>
                            <a class="btn-link" href="#"><i class="fas fa-map-marker-alt me-2"></i>CN03 - Chi nhánh 03</a>
                            <a class="btn-link" href="#"><i class="fas fa-map-marker-alt me-2"></i>CN04 - Chi nhánh 04</a>
                            <a class="btn-link" href="#"><i class="fas fa-map-marker-alt me-2"></i>CN05 - Chi nhánh 05</a>
                            <a class="btn-link" href="#"><i class="fas fa-map-marker-alt me-2"></i>CN06 - Chi nhánh 06</a>
                            <a class="btn-link" href="#"><i class="fas fa-map-marker-alt me-2"></i>CN07 - Chi nhánh 07</a>
                        </c:otherwise>
                    </c:choose>
                    <a class="btn-link" href=""><i class="fas fa-clock me-2"></i>Phục vụ 24/7</a>
                    <a class="btn-link" href=""><i class="fas fa-shield-alt me-2"></i>Cam kết chất lượng</a>
                    <a class="btn-link" href=""><i class="fas fa-headset me-2"></i>Hỗ trợ khách hàng</a>
                </div>
            </div>
            <div class="col-lg-3 col-md-6">
                <div class="d-flex flex-column text-start footer-item">
                    <h4 class="text-light mb-3">Sản phẩm</h4>
                    <a class="btn-link" href=""><i class="fas fa-box me-2"></i>Thực phẩm tươi sống</a>
                    <a class="btn-link" href=""><i class="fas fa-box me-2"></i>Đồ uống</a>
                    <a class="btn-link" href=""><i class="fas fa-box me-2"></i>Đồ dùng cá nhân</a>
                    <a class="btn-link" href=""><i class="fas fa-box me-2"></i>Đồ gia dụng</a>
                    <a class="btn-link" href=""><i class="fas fa-box me-2"></i>Văn phòng phẩm</a>
                </div>
            </div>
            <div class="col-lg-3 col-md-6">
                <div class="footer-item">
                    <h4 class="text-light mb-3">Liên hệ</h4>
                    <p><i class="fas fa-home me-2"></i>Trụ sở chính: Hà Nội, Việt Nam</p>
                    <p><i class="fas fa-envelope me-2"></i>Email: support@redmart.vn</p>
                    <p><i class="fas fa-phone me-2"></i>Hotline: 1900 xxxx</p>
                    <p><i class="fas fa-clock me-2"></i>Mở cửa: 24/7</p>
                    <p>Phương thức thanh toán:</p>
                    <img src="/client/img/payment.png" class="img-fluid" alt="">
                </div>
            </div>
        </div>
    </div>
</div>
<!-- Footer End -->

<!-- Copyright Start -->
<div class="container-fluid copyright bg-dark py-4">
    <div class="container">
        <div class="row">
            <div class="col-md-6 text-center text-md-start mb-3 mb-md-0">
                <span class="text-light">
                    <a href="#" class="text-danger">
                        <i class="fas fa-copyright text-light me-2"></i>© 2025 RedMart
                    </a>, Chuỗi Cửa Hàng Tiện Lợi. Bảo lưu mọi quyền.
                </span>
            </div>
            <div class="col-md-6 my-auto text-center text-md-end text-white">
                <!--/*** This template is free as long as you keep the below author’s credit link/attribution link/backlink. ***/-->
                <!--/*** If you'd like to use the template without the below author’s credit link/attribution link/backlink, ***/-->
                <!--/*** you can purchase the Credit Removal License from "https://htmlcodex.com/credit-removal". ***/-->
                Thiết kế bởi <a class="border-bottom" href="https://htmlcodex.com">HTML Codex</a> Cung cấp bởi <a class="border-bottom" href="https://themewagon.com">ThemeWagon</a>
            </div>
        </div>
    </div>
</div>
<!-- Copyright End -->

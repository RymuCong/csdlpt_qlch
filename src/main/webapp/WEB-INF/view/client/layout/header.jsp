<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!-- Navbar start -->
        <div class="container-fluid fixed-top" style="z-index: 10000;">
            <div class="container px-0">
                <nav class="navbar navbar-light bg-white navbar-expand-xl">
                    <a href="/" class="navbar-brand">
                        <h1 class="text-primary display-6">
                            <i class="fas fa-store-alt me-2"></i>MiniMart Plus
                        </h1>
                    </a>
                    <button class="navbar-toggler py-2 px-3" type="button" data-bs-toggle="collapse"
                        data-bs-target="#navbarCollapse">
                        <span class="fa fa-bars text-primary"></span>
                    </button>
                    <div class="collapse navbar-collapse bg-white justify-content-between mx-5" id="navbarCollapse">
                        <div class="navbar-nav">
                            <a href="/" class="nav-item nav-link active ">Trang Chủ</a>
                            <a href="/products" class="nav-item nav-link">Sản Phẩm</a>

                        </div>
                        <div class="d-flex m-3 me-0">
                            <c:if test="${not empty pageContext.request.userPrincipal}">
                                <!-- POS System - No cart needed -->
                                <c:if test="${not empty sessionScope.employeeId}">
                                    <a href="/admin/bill/create" class="position-relative me-4 my-auto" title="Tạo hóa đơn (POS)">
                                        <i class="fa fa-cash-register fa-2x text-success"></i>
                                    </a>
                                </c:if>
                                <div class="dropdown my-auto">
                                    <a href="#" class="dropdown" role="button" id="dropdownMenuLink"
                                        data-bs-toggle="dropdown" aria-expanded="false" data-bs-toggle="dropdown"
                                        aria-expanded="false">
                                        <i class="fas fa-user fa-2x"></i>
                                    </a>

                                    <ul class="dropdown-menu dropdown-menu-end p-4" aria-labelledby="dropdownMenuLink">
                                        <li class="d-flex align-items-center flex-column" style="min-width: 300px;">
                                            <c:choose>
                                                <c:when test="${not empty sessionScope.employeeName}">
                                                    <i class="fas fa-user-tie fa-5x text-primary mb-3"></i>
                                                    <div class="text-center my-3">
                                                        <strong><c:out value="${sessionScope.employeeName}" /></strong>
                                                        <br><small class="text-muted">${sessionScope.employeePositionDisplay}</small>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <img style="width: 150px; height: 150px; border-radius: 50%; overflow: hidden;"
                                                        src="/images/avatar/default.png" />
                                                    <div class="text-center my-3">
                                                        <c:out value="${pageContext.request.userPrincipal.name}" />
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </li>

                                        <c:if test="${not empty sessionScope.employeeId}">
                                            <li><a class="dropdown-item" href="/admin"><i class="fas fa-tachometer-alt me-2"></i>Hệ thống quản lý</a></li>
                                            <li><a class="dropdown-item" href="/admin/bill"><i class="fas fa-file-invoice me-2"></i>Hóa đơn</a></li>
                                        </c:if>
                                        <li>
                                            <hr class="dropdown-divider">
                                        </li>
                                        <li>
                                            <form method="post" action="/logout">
                                                <input type="hidden" name="${_csrf.parameterName}"
                                                    value="${_csrf.token}" />
                                                <button class="dropdown-item">Đăng xuất</button>
                                            </form>
                                        </li>
                                    </ul>
                                </div>
                            </c:if>
                            <c:if test="${empty pageContext.request.userPrincipal}">
                                <a href="/login" class="position-relative me-4 my-auto">
                                    Đăng nhập
                                </a>
                            </c:if>
                        </div>
                    </div>
                </nav>
            </div>
        </div>
        <!-- Navbar End -->
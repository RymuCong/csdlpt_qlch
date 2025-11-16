<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <title>Thêm khách hàng - Hệ thống POS</title>
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
                    <h1 class="mt-4">Thêm khách hàng mới</h1>
                    <ol class="breadcrumb mb-4">
                        <li class="breadcrumb-item"><a href="/admin">Dashboard</a></li>
                        <li class="breadcrumb-item"><a href="/admin/customer">Khách hàng</a></li>
                        <li class="breadcrumb-item active">Thêm mới</li>
                    </ol>

                    <div class="row">
                        <div class="col-md-8 col-lg-6 mx-auto">
                            <div class="card mb-4">
                                <div class="card-header bg-primary text-white">
                                    <i class="fas fa-user-plus me-2"></i>Thông tin khách hàng
                                </div>
                                <div class="card-body">
                                    <c:if test="${error != null}">
                                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                            <i class="fas fa-exclamation-triangle me-2"></i>${error}
                                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                        </div>
                                    </c:if>

                                    <form:form action="/admin/customer/create" method="post" modelAttribute="newCustomer" class="row g-3" acceptCharset="UTF-8">
                                        <!-- Name -->
                                        <div class="col-md-12">
                                            <label class="form-label">
                                                <i class="fas fa-user me-1"></i>Họ và tên
                                                <span class="text-danger">*</span>
                                            </label>
                                            <form:input path="name" cssClass="form-control" placeholder="Nguyễn Văn A" required="required" />
                                            <form:errors path="name" cssClass="invalid-feedback d-block" />
                                        </div>

                                        <!-- Phone -->
                                        <div class="col-md-12">
                                            <label class="form-label">
                                                <i class="fas fa-phone me-1"></i>Số điện thoại
                                                <span class="text-danger">*</span>
                                            </label>
                                            <form:input path="phone" cssClass="form-control" placeholder="0901234567" 
                                                       pattern="[0-9]{10}" title="Số điện thoại phải có 10 chữ số" required="required" />
                                            <form:errors path="phone" cssClass="invalid-feedback d-block" />
                                            <small class="form-text text-muted">Định dạng: 10 chữ số</small>
                                        </div>

                                        <!-- Total Payment -->
                                        <div class="col-md-12">
                                            <label class="form-label">
                                                <i class="fas fa-money-bill-wave me-1"></i>Tổng chi tiêu (₫)
                                            </label>
                                            <form:input path="totalPayment" type="number" id="totalPaymentInput" cssClass="form-control" 
                                                       placeholder="0" value="0" min="0" step="1000" oninput="updateCustomerLevel()" />
                                            <form:errors path="totalPayment" cssClass="invalid-feedback d-block" />
                                            <small class="form-text text-muted">Nhập số tiền khách hàng đã chi tiêu trước đây (nếu có)</small>
                                        </div>

                                        <!-- Auto-calculated Level Display -->
                                        <div class="col-12">
                                            <div class="alert alert-success" id="levelDisplay">
                                                <i class="fas fa-star me-2"></i>
                                                <strong>Cấp độ thành viên:</strong> 
                                                <span id="levelText">Cấp 1 - Thành viên mới (0% giảm giá)</span>
                                            </div>
                                        </div>

                                        <!-- Alert Information -->
                                        <div class="col-12">
                                            <div class="alert alert-info mb-0">
                                                <small>
                                                    <i class="fas fa-info-circle me-1"></i>
                                                    <strong>Lưu ý:</strong> 
                                                    <ul class="mb-0 mt-1 ps-3">
                                                        <li>Mã khách hàng sẽ tự động sinh theo chi nhánh (VD: CN02_CUS0001, CN02_CUS0002,...)</li>
                                                        <li>Cấp độ thành viên tự động tính dựa trên tổng chi tiêu</li>
                                                        <li>Tổng chi tiêu sẽ cập nhật khi khách hàng mua hàng</li>
                                                    </ul>
                                                </small>
                                            </div>
                                        </div>

                                        <!-- Buttons -->
                                        <div class="col-12 mt-4">
                                            <button type="submit" class="btn btn-success">
                                                <i class="fas fa-save me-1"></i>Lưu khách hàng
                                            </button>
                                            <a href="/admin/customer" class="btn btn-secondary">
                                                <i class="fas fa-times me-1"></i>Hủy
                                            </a>
                                        </div>
                                    </form:form>
                                </div>
                            </div>

                            <!-- Help Card -->
                            <div class="card">
                                <div class="card-header">
                                    <i class="fas fa-question-circle me-2"></i>Hướng dẫn - Cấp độ thành viên
                                </div>
                                <div class="card-body">
                                    <div class="row g-2">
                                        <div class="col-6">
                                            <div class="card border-secondary">
                                                <div class="card-body p-2 text-center">
                                                    <i class="fas fa-user text-secondary fa-2x mb-2"></i>
                                                    <h6 class="mb-1">Cấp 1</h6>
                                                    <small class="text-muted">Dưới 5 triệu</small>
                                                    <div class="badge bg-secondary mt-1">0% giảm giá</div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-6">
                                            <div class="card border-info">
                                                <div class="card-body p-2 text-center">
                                                    <i class="fas fa-user text-info fa-2x mb-2"></i>
                                                    <h6 class="mb-1">Cấp 2 - Bạc</h6>
                                                    <small class="text-muted">5-20 triệu</small>
                                                    <div class="badge bg-info mt-1">5% giảm giá</div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-6">
                                            <div class="card border-warning">
                                                <div class="card-body p-2 text-center">
                                                    <i class="fas fa-user text-warning fa-2x mb-2"></i>
                                                    <h6 class="mb-1">Cấp 3 - Vàng</h6>
                                                    <small class="text-muted">20-50 triệu</small>
                                                    <div class="badge bg-warning text-dark mt-1">10% giảm giá</div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-6">
                                            <div class="card border-primary">
                                                <div class="card-body p-2 text-center">
                                                    <i class="fas fa-crown text-primary fa-2x mb-2"></i>
                                                    <h6 class="mb-1">Cấp 4 - Kim cương</h6>
                                                    <small class="text-muted">Trên 50 triệu</small>
                                                    <div class="badge bg-primary mt-1">15% giảm giá</div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
            <jsp:include page="../layout/footer.jsp" />
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="/js/scripts.js"></script>
    <script>
        // Hàm tính cấp độ thành viên dựa trên tổng chi tiêu
        function updateCustomerLevel() {
            const totalPayment = parseFloat(document.getElementById('totalPaymentInput').value) || 0;
            const levelDisplay = document.getElementById('levelDisplay');
            const levelText = document.getElementById('levelText');
            
            let level = 1;
            let levelName = 'Cấp 1 - Thành viên mới';
            let discount = '0%';
            let levelClass = 'alert-secondary';
            
            if (totalPayment >= 50000000) {
                level = 4;
                levelName = 'Cấp 4 - Kim cương';
                discount = '15%';
                levelClass = 'alert-primary';
            } else if (totalPayment >= 20000000) {
                level = 3;
                levelName = 'Cấp 3 - Vàng';
                discount = '10%';
                levelClass = 'alert-warning';
            } else if (totalPayment >= 5000000) {
                level = 2;
                levelName = 'Cấp 2 - Bạc';
                discount = '5%';
                levelClass = 'alert-info';
            }
            
            // Cập nhật hiển thị
            levelDisplay.className = 'alert ' + levelClass;
            levelText.innerHTML = levelName + ' (' + discount + ' giảm giá)';
        }
        
        // Gọi hàm khi trang load để hiển thị level mặc định
        window.onload = function() {
            updateCustomerLevel();
        };
    </script>
</body>
</html>


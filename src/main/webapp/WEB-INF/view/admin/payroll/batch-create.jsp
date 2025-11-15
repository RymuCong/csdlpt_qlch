<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8" />
    <title>Tính lương hàng loạt - Hệ thống POS</title>
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
                    <h1 class="mt-4">Tính lương hàng loạt</h1>
                    <ol class="breadcrumb mb-4">
                        <li class="breadcrumb-item"><a href="/admin">Dashboard</a></li>
                        <li class="breadcrumb-item"><a href="/admin/payroll">Bảng lương</a></li>
                        <li class="breadcrumb-item active">Tính lương hàng loạt</li>
                    </ol>
                    
                    <div class="row">
                        <div class="col-xl-8 col-lg-10 mx-auto">
                            <div class="card mb-4">
                                <div class="card-header bg-success text-white">
                                    <i class="fas fa-calculator me-2"></i>
                                    Tính lương cho tất cả nhân viên
                                </div>
                                <div class="card-body">
                                    <div class="alert alert-info">
                                        <i class="fas fa-info-circle me-2"></i>
                                        <strong>Lưu ý:</strong> Tính lương hàng loạt sẽ tạo bảng lương cho tất cả nhân viên của cửa hàng <strong>${storeId}</strong> với cùng số giờ làm và thưởng.
                                    </div>
                                    
                                    <form method="post" action="/admin/payroll/batch-create" acceptCharset="UTF-8">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                        <input type="hidden" name="storeId" value="${storeId}" />
                                        
                                        <div class="mb-3">
                                            <label class="form-label">Tháng tính lương <span class="text-danger">*</span></label>
                                            <input type="month" name="payMonth" class="form-control" required />
                                            <small class="text-muted">Chọn tháng và năm (ví dụ: 10/2024)</small>
                                        </div>
                                        
                                        <div class="row mb-3">
                                            <div class="col-md-6">
                                                <label class="form-label">Số giờ làm mặc định <span class="text-danger">*</span></label>
                                                <input type="number" name="defaultWorkingHours" class="form-control" 
                                                       required min="0" step="1" value="176" />
                                                <small class="text-muted">Số giờ làm chung cho tất cả nhân viên</small>
                                            </div>
                                            <div class="col-md-6">
                                                <label class="form-label">Thưởng mặc định (₫)</label>
                                                <input type="number" name="defaultBonus" class="form-control" 
                                                       min="0" step="1000" value="0" />
                                                <small class="text-muted">Thưởng chung cho tất cả nhân viên</small>
                                            </div>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <label class="form-label">Danh sách nhân viên sẽ được tính lương:</label>
                                            <div class="list-group">
                                                <c:forEach var="emp" items="${employees}">
                                                    <div class="list-group-item">
                                                        <i class="fas fa-user me-2"></i>
                                                        <strong>${emp.id}</strong> - ${emp.name} 
                                                        <span class="badge bg-secondary">${emp.position.displayName}</span>
                                                        <br>
                                                        <small class="text-muted">Lương cơ bản: 
                                                            <fmt:formatNumber value="${emp.baseSalary}" type="currency" currencySymbol="₫" maxFractionDigits="0" />/giờ
                                                        </small>
                                                    </div>
                                                </c:forEach>
                                            </div>
                                            <small class="text-muted">Tổng cộng: ${employees.size()} nhân viên</small>
                                        </div>
                                        
                                        <div class="alert alert-warning">
                                            <i class="fas fa-exclamation-triangle me-2"></i>
                                            <strong>Cảnh báo:</strong> Hệ thống sẽ tự động bỏ qua những nhân viên đã có bảng lương trong tháng được chọn.
                                        </div>
                                        
                                        <div class="d-flex justify-content-between mt-4">
                                            <a href="/admin/payroll" class="btn btn-secondary">
                                                <i class="fas fa-times me-2"></i>Hủy
                                            </a>
                                            <button type="submit" class="btn btn-success">
                                                <i class="fas fa-calculator me-2"></i>Tính lương hàng loạt
                                            </button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
            <jsp:include page="../layout/footer.jsp" />
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
    <script src="/js/scripts.js"></script>
</body>
</html>


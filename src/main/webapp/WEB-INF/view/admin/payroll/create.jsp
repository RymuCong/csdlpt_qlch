<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8" />
    <title>Tạo bảng lương - Hệ thống POS</title>
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
                    <h1 class="mt-4">Tạo bảng lương</h1>
                    <ol class="breadcrumb mb-4">
                        <li class="breadcrumb-item"><a href="/admin">Dashboard</a></li>
                        <li class="breadcrumb-item"><a href="/admin/payroll">Bảng lương</a></li>
                        <li class="breadcrumb-item active">Tạo mới</li>
                    </ol>
                    
                    <div class="row">
                        <div class="col-xl-8 col-lg-10 mx-auto">
                            <c:if test="${error != null}">
                                <div class="alert alert-danger alert-dismissible fade show">
                                    <i class="fas fa-exclamation-circle me-2"></i>${error}
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                </div>
                            </c:if>
                            
                            <div class="card mb-4">
                                <div class="card-header">
                                    <i class="fas fa-money-check-alt me-2"></i>
                                    Thông tin bảng lương
                                </div>
                                <div class="card-body">
                                    <form method="post" action="/admin/payroll/create" acceptCharset="UTF-8">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                        <div class="mb-3">
                                            <label class="form-label">Nhân viên <span class="text-danger">*</span></label>
                                            <select name="employeeId" class="form-select" required>
                                                <option value="">-- Chọn nhân viên --</option>
                                                <c:forEach var="emp" items="${employees}">
                                                    <option value="${emp.id}" ${emp.id == selectedEmployeeId ? 'selected' : ''}>
                                                        ${emp.id} - ${emp.name} (${emp.position.displayName}) - ${emp.store.id}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <label class="form-label">Tháng tính lương <span class="text-danger">*</span></label>
                                            <input name="payMonth" type="month" class="form-control" required />
                                            <small class="text-muted">Chọn tháng và năm (ví dụ: 10/2024)</small>
                                        </div>
                                        
                                        <div class="row mb-3">
                                            <div class="col-md-6">
                                                <label class="form-label">Số giờ làm <span class="text-danger">*</span></label>
                                                <input name="workingHours" type="number" class="form-control" 
                                                       required min="0" step="1" />
                                                <small class="text-muted">Tổng số giờ làm trong tháng</small>
                                            </div>
                                            <div class="col-md-6">
                                                <label class="form-label">Thưởng (₫)</label>
                                                <input name="bonus" type="number" class="form-control" 
                                                       min="0" step="1000" value="0" />
                                                <small class="text-muted">Thưởng thêm (nếu có)</small>
                                            </div>
                                        </div>
                                        
                                        <div class="alert alert-info">
                                            <i class="fas fa-info-circle me-2"></i>
                                            <strong>Lưu ý:</strong> Tổng lương = (Lương cơ bản × Số giờ làm) + Thưởng
                                        </div>
                                        
                                        <div class="d-flex justify-content-between mt-4">
                                            <a href="/admin/payroll" class="btn btn-secondary">
                                                <i class="fas fa-times me-2"></i>Hủy
                                            </a>
                                            <button type="submit" class="btn btn-primary">
                                                <i class="fas fa-save me-2"></i>Tạo bảng lương
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


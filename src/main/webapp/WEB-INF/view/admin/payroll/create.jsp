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
                                    <form method="post" action="/admin/payroll/create" acceptCharset="UTF-8" id="payrollForm">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                        <div class="mb-3">
                                            <label class="form-label">Nhân viên <span class="text-danger">*</span></label>
                                            <select name="employeeId" id="employeeSelect" class="form-select" required onchange="onEmployeeChange()">
                                                <option value="">-- Chọn nhân viên --</option>
                                                <c:forEach var="emp" items="${employees}">
                                                    <option value="${emp.id}" 
                                                            data-name="${emp.name}"
                                                            data-base-salary="${emp.baseSalary}"
                                                            data-position="${emp.position.displayName}"
                                                            data-store="${emp.store.id}"
                                                            ${emp.id == selectedEmployeeId ? 'selected' : ''}>
                                                        ${emp.id} - ${emp.name} (${emp.position.displayName}) - ${emp.store.id}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        
                                        <!-- Hiển thị thông tin nhân viên đã chọn -->
                                        <c:if test="${selectedEmployee != null}">
                                            <div class="alert alert-info mb-3" id="employeeInfo">
                                                <h6><i class="fas fa-user me-2"></i>Thông tin nhân viên:</h6>
                                                <div class="row">
                                                    <div class="col-md-6">
                                                        <strong>Tên:</strong> ${selectedEmployee.name}<br>
                                                        <strong>Chức vụ:</strong> ${selectedEmployee.position.displayName}<br>
                                                        <strong>Cửa hàng:</strong> ${selectedEmployee.store.id}
                                                    </div>
                                                    <div class="col-md-6">
                                                        <strong>Lương cơ bản:</strong> 
                                                        <span class="text-success">
                                                            <fmt:formatNumber value="${selectedEmployee.baseSalary}" type="number" groupingUsed="true" /> ₫/giờ
                                                        </span>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:if>
                                        
                                        <div class="alert alert-info mb-3" id="employeeInfoDynamic" style="display: none;">
                                            <h6><i class="fas fa-user me-2"></i>Thông tin nhân viên:</h6>
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <strong>Tên:</strong> <span id="empName"></span><br>
                                                    <strong>Chức vụ:</strong> <span id="empPosition"></span><br>
                                                    <strong>Cửa hàng:</strong> <span id="empStore"></span>
                                                </div>
                                                <div class="col-md-6">
                                                    <strong>Lương cơ bản:</strong> 
                                                    <span class="text-success" id="empBaseSalary"></span> ₫/giờ
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <label class="form-label">Tháng tính lương <span class="text-danger">*</span></label>
                                            <input name="payMonth" type="month" class="form-control" required />
                                            <small class="text-muted">Chọn tháng và năm (ví dụ: 10/2024)</small>
                                        </div>
                                        
                                        <div class="row mb-3">
                                            <div class="col-md-6">
                                                <label class="form-label">Số giờ làm <span class="text-danger">*</span></label>
                                                <input name="workingHours" id="workingHours" type="number" class="form-control" 
                                                       required min="0" step="1" oninput="calculateEstimatedSalary()" />
                                                <small class="text-muted">Tổng số giờ làm trong tháng</small>
                                            </div>
                                            <div class="col-md-6">
                                                <label class="form-label">Thưởng (₫)</label>
                                                <input name="bonus" id="bonus" type="number" class="form-control" 
                                                       min="0" step="1000" value="0" oninput="calculateEstimatedSalary()" />
                                                <small class="text-muted">Thưởng thêm (nếu có)</small>
                                            </div>
                                        </div>
                                        
                                        <!-- Hiển thị lương dự kiến -->
                                        <div class="alert alert-success mb-3" id="estimatedSalary" style="display: none;">
                                            <i class="fas fa-calculator me-2"></i>
                                            <strong>Lương dự kiến:</strong> 
                                            <span id="estimatedTotal" class="fs-5"></span>
                                            <br>
                                            <small class="text-muted">
                                                (Lương cơ bản × Số giờ làm) + Thưởng = 
                                                <span id="baseSalaryCalc"></span> + 
                                                <span id="bonusCalc"></span> = 
                                                <span id="totalCalc"></span>
                                            </small>
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
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script>
        // Hiển thị thông tin nhân viên khi chọn
        function onEmployeeChange() {
            const select = document.getElementById('employeeSelect');
            const selectedOption = select.options[select.selectedIndex];
            
            if (selectedOption.value) {
                const empName = selectedOption.getAttribute('data-name');
                const empBaseSalary = selectedOption.getAttribute('data-base-salary');
                const empPosition = selectedOption.getAttribute('data-position');
                const empStore = selectedOption.getAttribute('data-store');
                
                // Hiển thị thông tin nhân viên
                document.getElementById('empName').textContent = empName;
                document.getElementById('empPosition').textContent = empPosition;
                document.getElementById('empStore').textContent = empStore;
                document.getElementById('empBaseSalary').textContent = formatCurrency(parseInt(empBaseSalary));
                document.getElementById('employeeInfoDynamic').style.display = 'block';
                
                // Ẩn thông tin nhân viên cố định nếu có
                const staticInfo = document.getElementById('employeeInfo');
                if (staticInfo) {
                    staticInfo.style.display = 'none';
                }
                
                // Tính lại lương dự kiến nếu đã có số giờ làm
                calculateEstimatedSalary();
            } else {
                document.getElementById('employeeInfoDynamic').style.display = 'none';
                document.getElementById('estimatedSalary').style.display = 'none';
                
                // Hiển thị lại thông tin nhân viên cố định nếu có
                const staticInfo = document.getElementById('employeeInfo');
                if (staticInfo) {
                    staticInfo.style.display = 'block';
                }
            }
        }
        
        // Tính lương dự kiến
        function calculateEstimatedSalary() {
            const select = document.getElementById('employeeSelect');
            const selectedOption = select.options[select.selectedIndex];
            const workingHours = parseInt(document.getElementById('workingHours').value) || 0;
            const bonus = parseInt(document.getElementById('bonus').value) || 0;
            
            if (selectedOption.value && workingHours > 0) {
                const baseSalary = parseInt(selectedOption.getAttribute('data-base-salary')) || 0;
                const baseSalaryTotal = baseSalary * workingHours;
                const total = baseSalaryTotal + bonus;
                
                // Hiển thị kết quả
                document.getElementById('baseSalaryCalc').textContent = formatCurrency(baseSalaryTotal);
                document.getElementById('bonusCalc').textContent = formatCurrency(bonus);
                document.getElementById('totalCalc').textContent = formatCurrency(total);
                document.getElementById('estimatedTotal').textContent = formatCurrency(total);
                document.getElementById('estimatedSalary').style.display = 'block';
            } else {
                document.getElementById('estimatedSalary').style.display = 'none';
            }
        }
        
        // Format số tiền
        function formatCurrency(amount) {
            return new Intl.NumberFormat('vi-VN').format(amount) + ' ₫';
        }
        
        // Gọi hàm khi trang load nếu đã có nhân viên được chọn
        window.onload = function() {
            const select = document.getElementById('employeeSelect');
            if (select.value) {
                onEmployeeChange();
            }
        };
    </script>
</body>
</html>


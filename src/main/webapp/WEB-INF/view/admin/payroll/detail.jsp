<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Chi tiết bảng lương - ${payRoll.payId}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.15.4/css/all.css" />
    <style>
        .payroll-detail-card {
            box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
            border: 1px solid rgba(0, 0, 0, 0.125);
        }
    </style>
</head>
<body>
    <jsp:include page="../layout/header.jsp" />
    
    <div class="container-fluid py-4">
        <div class="container">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2 class="mb-0">
                    <i class="fas fa-file-invoice-dollar text-danger me-2"></i>
                    Chi tiết bảng lương
                </h2>
                <div>
                    <a href="/admin/payroll/${payRoll.payId}/print" class="btn btn-danger me-2" target="_blank">
                        <i class="fas fa-print me-1"></i>In phiếu lương
                    </a>
                    <a href="/admin/payroll" class="btn btn-outline-secondary">
                        <i class="fas fa-arrow-left me-1"></i>Quay lại
                    </a>
                </div>
            </div>
            
            <div class="row">
                <div class="col-md-8">
                    <div class="card payroll-detail-card mb-4">
                        <div class="card-header bg-danger text-white">
                            <h5 class="mb-0"><i class="fas fa-info-circle me-2"></i>Thông tin bảng lương</h5>
                        </div>
                        <div class="card-body">
                            <div class="row mb-3">
                                <div class="col-md-4"><strong>Mã phiếu lương:</strong></div>
                                <div class="col-md-8">
                                    <span class="badge bg-primary">${payRoll.payId}</span>
                                </div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-4"><strong>Tháng tính lương:</strong></div>
                                <div class="col-md-8">
                                    <c:set var="payMonth" value="${payRoll.payMonth}" />
                                    <span class="badge bg-info">${payMonth.monthValue < 10 ? '0' : ''}${payMonth.monthValue}/${payMonth.year}</span>
                                </div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-4"><strong>Nhân viên:</strong></div>
                                <div class="col-md-8">${payRoll.employee.name}</div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-4"><strong>Mã nhân viên:</strong></div>
                                <div class="col-md-8">
                                    <span class="badge bg-secondary">${payRoll.employee.id}</span>
                                </div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-4"><strong>Chức vụ:</strong></div>
                                <div class="col-md-8">${payRoll.employee.position.displayName}</div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-4"><strong>Cửa hàng:</strong></div>
                                <div class="col-md-8">
                                    <span class="badge bg-success">${payRoll.employee.store.id}</span>
                                    <c:if test="${payRoll.employee.store != null}">
                                        <br><small class="text-muted">${payRoll.employee.store.address}</small>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="card payroll-detail-card">
                        <div class="card-header bg-success text-white">
                            <h5 class="mb-0"><i class="fas fa-calculator me-2"></i>Chi tiết tính lương</h5>
                        </div>
                        <div class="card-body">
                            <div class="row mb-3">
                                <div class="col-md-4"><strong>Lương cơ bản/giờ:</strong></div>
                                <div class="col-md-8">
                                    <fmt:formatNumber value="${payRoll.employee.baseSalary}" type="number" pattern="#,##0" /> đ
                                </div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-4"><strong>Số giờ làm việc:</strong></div>
                                <div class="col-md-8">
                                    <span class="badge bg-warning text-dark">${payRoll.workingHours} giờ</span>
                                </div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-4"><strong>Lương cơ bản:</strong></div>
                                <div class="col-md-8">
                                    <fmt:formatNumber value="${payRoll.employee.baseSalary * payRoll.workingHours}" type="number" pattern="#,##0" /> đ
                                    <small class="text-muted">(${payRoll.employee.baseSalary} × ${payRoll.workingHours})</small>
                                </div>
                            </div>
                            <c:if test="${payRoll.bonus > 0}">
                                <div class="row mb-3">
                                    <div class="col-md-4"><strong>Thưởng:</strong></div>
                                    <div class="col-md-8">
                                        <span class="text-success">
                                            <i class="fas fa-gift me-1"></i>
                                            <fmt:formatNumber value="${payRoll.bonus}" type="number" pattern="#,##0" /> đ
                                        </span>
                                    </div>
                                </div>
                            </c:if>
                            <c:if test="${payRoll.bonus == 0}">
                                <div class="row mb-3">
                                    <div class="col-md-4"><strong>Thưởng:</strong></div>
                                    <div class="col-md-8">
                                        <span class="text-muted">0 đ</span>
                                    </div>
                                </div>
                            </c:if>
                            <hr>
                            <div class="row">
                                <div class="col-md-4"><strong class="text-danger fs-5">TỔNG LƯƠNG:</strong></div>
                                <div class="col-md-8">
                                    <span class="text-danger fs-4 fw-bold">
                                        <fmt:formatNumber value="${payRoll.total}" type="number" pattern="#,##0" /> đ
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="col-md-4">
                    <div class="card payroll-detail-card">
                        <div class="card-header bg-info text-white">
                            <h5 class="mb-0"><i class="fas fa-clock me-2"></i>Thông tin thời gian</h5>
                        </div>
                        <div class="card-body">
                            <div class="mb-3">
                                <strong>Ngày tạo:</strong><br>
                                <c:set var="createdDate" value="${payRoll.createdDate}" />
                                <small class="text-muted">
                                    ${createdDate.dayOfMonth < 10 ? '0' : ''}${createdDate.dayOfMonth}/${createdDate.monthValue < 10 ? '0' : ''}${createdDate.monthValue}/${createdDate.year}
                                    ${createdDate.hour < 10 ? '0' : ''}${createdDate.hour}:${createdDate.minute < 10 ? '0' : ''}${createdDate.minute}
                                </small>
                            </div>
                            <div class="mb-3">
                                <strong>Ngày cập nhật:</strong><br>
                                <c:set var="updatedDate" value="${payRoll.updatedDate}" />
                                <small class="text-muted">
                                    ${updatedDate.dayOfMonth < 10 ? '0' : ''}${updatedDate.dayOfMonth}/${updatedDate.monthValue < 10 ? '0' : ''}${updatedDate.monthValue}/${updatedDate.year}
                                    ${updatedDate.hour < 10 ? '0' : ''}${updatedDate.hour}:${updatedDate.minute < 10 ? '0' : ''}${updatedDate.minute}
                                </small>
                            </div>
                        </div>
                    </div>
                    
                    <div class="card payroll-detail-card mt-3">
                        <div class="card-header bg-warning text-dark">
                            <h5 class="mb-0"><i class="fas fa-tools me-2"></i>Thao tác</h5>
                        </div>
                        <div class="card-body">
                            <a href="/admin/payroll/update/${payRoll.payId}" class="btn btn-warning w-100 mb-2">
                                <i class="fas fa-edit me-1"></i>Cập nhật
                            </a>
                            <a href="/admin/payroll/${payRoll.payId}/print" class="btn btn-danger w-100 mb-2" target="_blank">
                                <i class="fas fa-print me-1"></i>In phiếu lương
                            </a>
                            <a href="/admin/payroll" class="btn btn-outline-secondary w-100">
                                <i class="fas fa-arrow-left me-1"></i>Quay lại danh sách
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <jsp:include page="../layout/footer.jsp" />
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>


<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <title>Báo cáo doanh thu theo khoảng - Hệ thống POS</title>
    <link href="/css/styles.css" rel="stylesheet" />
    <link href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css" rel="stylesheet" />
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body class="sb-nav-fixed">
    <jsp:include page="../layout/header.jsp" />
    <div id="layoutSidenav">
        <jsp:include page="../layout/sidebar.jsp" />
        <div id="layoutSidenav_content">
            <main>
                <div class="container-fluid px-4">
                    <h1 class="mt-4">
                        <i class="fas fa-calendar-alt text-primary"></i>
                        Báo cáo doanh thu theo khoảng thời gian
                    </h1>
                    <ol class="breadcrumb mb-4">
                        <li class="breadcrumb-item"><a href="/admin">Dashboard</a></li>
                        <li class="breadcrumb-item"><a href="/admin/bill">Hóa đơn</a></li>
                        <li class="breadcrumb-item active">Báo cáo khoảng thời gian</li>
                    </ol>
                    
                    <!-- Date Range Selector -->
                    <div class="card mb-4">
                        <div class="card-header bg-primary text-white">
                            <i class="fas fa-filter me-2"></i>
                            Chọn khoảng thời gian
                        </div>
                        <div class="card-body">
                            <form action="/admin/bill/report/range" method="get" class="row g-3">
                                <div class="col-md-3">
                                    <label class="form-label">Từ ngày</label>
                                    <input type="date" name="startDate" class="form-control" 
                                           value="${startDate}" required />
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label">Đến ngày</label>
                                    <input type="date" name="endDate" class="form-control" 
                                           value="${endDate}" required />
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label">&nbsp;</label>
                                    <div>
                                        <button type="submit" class="btn btn-primary">
                                            <i class="fas fa-search me-1"></i>Xem báo cáo
                                        </button>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label">Nhanh chọn</label>
                                    <div class="btn-group w-100" role="group">
                                        <button type="button" class="btn btn-outline-secondary btn-sm" onclick="setDateRange(7)">7 ngày</button>
                                        <button type="button" class="btn btn-outline-secondary btn-sm" onclick="setDateRange(30)">30 ngày</button>
                                        <button type="button" class="btn btn-outline-secondary btn-sm" onclick="setDateRange(90)">90 ngày</button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                    
                    <c:if test="${bills != null}">
                        <!-- Summary Cards -->
                        <div class="row">
                            <div class="col-xl-3 col-md-6">
                                <div class="card bg-success text-white mb-4">
                                    <div class="card-body">
                                        <div class="d-flex justify-content-between align-items-center">
                                            <div>
                                                <div class="text-white-75 small">Tổng doanh thu</div>
                                                <div class="h4 mb-0">
                                                    <fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="₫" />
                                                </div>
                                            </div>
                                            <div>
                                                <i class="fas fa-money-bill-wave fa-3x"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="col-xl-3 col-md-6">
                                <div class="card bg-primary text-white mb-4">
                                    <div class="card-body">
                                        <div class="d-flex justify-content-between align-items-center">
                                            <div>
                                                <div class="text-white-75 small">Tổng hóa đơn</div>
                                                <div class="h2 mb-0">${bills.size()}</div>
                                            </div>
                                            <div>
                                                <i class="fas fa-receipt fa-3x"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="col-xl-3 col-md-6">
                                <div class="card bg-warning text-white mb-4">
                                    <div class="card-body">
                                        <div class="d-flex justify-content-between align-items-center">
                                            <div>
                                                <div class="text-white-75 small">Tổng hóa đơn</div>
                                                <div class="h5 mb-0">
                                                    ${bills.size()}
                                                </div>
                                            </div>
                                            <div>
                                                <i class="fas fa-chart-line fa-3x"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="col-xl-3 col-md-6">
                                <div class="card bg-info text-white mb-4">
                                    <div class="card-body">
                                        <div class="d-flex justify-content-between align-items-center">
                                            <div>
                                                <div class="text-white-75 small">TB giá trị/HĐ</div>
                                                <div class="h5 mb-0">
                                                    <c:if test="${bills.size() > 0}">
                                                        <fmt:formatNumber value="${totalRevenue / bills.size()}" type="currency" currencySymbol="₫" />
                                                    </c:if>
                                                    <c:if test="${bills.size() == 0}">0 ₫</c:if>
                                                </div>
                                            </div>
                                            <div>
                                                <i class="fas fa-calculator fa-3x"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Revenue Chart -->
                        <div class="card mb-4">
                            <div class="card-header">
                                <i class="fas fa-chart-area me-1"></i>
                                Biểu đồ doanh thu
                                <span class="small text-muted">
                                    (${startDate} - ${endDate})
                                </span>
                            </div>
                            <div class="card-body">
                                <canvas id="revenueChart" width="100%" height="30"></canvas>
                            </div>
                        </div>
                        
                        <!-- Bills Table -->
                        <div class="card mb-4">
                            <div class="card-header">
                                <i class="fas fa-table me-1"></i>
                                Chi tiết hóa đơn
                            </div>
                            <div class="card-body">
                                <table id="datatablesSimple" class="table table-striped table-hover">
                                    <thead>
                                        <tr>
                                            <th>Mã HĐ</th>
                                            <th>Ngày tạo</th>
                                            <th>Nhân viên</th>
                                            <th>Khách hàng</th>
                                            <th>Tổng tiền</th>
                                            <th>Giảm giá</th>
                                            <th>PT thanh toán</th>
                                            <th>Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="bill" items="${bills}">
                                            <tr>
                                                <td><strong>${bill.id}</strong></td>
                                                <td>
                                                    ${bill.paymentDate}
                                                </td>
                                                <td>
                                                    <i class="fas fa-user me-1"></i>
                                                    ${bill.employee.name}
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${bill.customer != null}">
                                                            ${bill.customer.name}
                                                            <span class="badge bg-info">Level ${bill.customer.level}</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted">Khách lẻ</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <strong class="text-success">
                                                        <fmt:formatNumber value="${bill.totalPrice}" type="currency" currencySymbol="₫" />
                                                    </strong>
                                                </td>
                                                <td>
                                                    <c:if test="${bill.discount > 0}">
                                                        <span class="badge bg-warning text-dark">${bill.discount}%</span>
                                                    </c:if>
                                                </td>
                                                <td>
                                                    <span class="badge 
                                                        <c:choose>
                                                            <c:when test="${bill.paymentMethod.name() == 'CASH'}">bg-success</c:when>
                                                            <c:when test="${bill.paymentMethod.name() == 'TRANSFER'}">bg-info</c:when>
                                                            <c:when test="${bill.paymentMethod.name() == 'CARD'}">bg-primary</c:when>
                                                            <c:otherwise>bg-warning text-dark</c:otherwise>
                                                        </c:choose>
                                                    ">
                                                        ${bill.paymentMethod.displayName}
                                                    </span>
                                                </td>
                                                <td>
                                                    <a href="/admin/bill/${bill.id}" class="btn btn-info btn-sm" title="Chi tiết">
                                                        <i class="fas fa-eye"></i>
                                                    </a>
                                                    <a href="/admin/bill/${bill.id}/print" class="btn btn-success btn-sm" title="In">
                                                        <i class="fas fa-print"></i>
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                    <tfoot>
                                        <tr class="table-success">
                                            <td colspan="4" class="text-end"><strong>TỔNG CỘNG:</strong></td>
                                            <td colspan="4">
                                                <strong class="text-success h5">
                                                    <fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="₫" />
                                                </strong>
                                            </td>
                                        </tr>
                                    </tfoot>
                                </table>
                            </div>
                        </div>
                        
                        <!-- Action Buttons -->
                        <div class="card mb-4">
                            <div class="card-body text-center">
                                <a href="/admin/bill" class="btn btn-secondary me-2">
                                    <i class="fas fa-arrow-left me-1"></i>Quay lại
                                </a>
                                <button onclick="window.print()" class="btn btn-primary me-2">
                                    <i class="fas fa-print me-1"></i>In báo cáo
                                </button>
                                <button onclick="exportToExcel()" class="btn btn-success">
                                    <i class="fas fa-file-excel me-1"></i>Xuất Excel
                                </button>
                            </div>
                        </div>
                    </c:if>
                    
                    <c:if test="${bills == null}">
                        <div class="alert alert-info">
                            <i class="fas fa-info-circle me-2"></i>
                            Vui lòng chọn khoảng thời gian để xem báo cáo.
                        </div>
                    </c:if>
                </div>
            </main>
            <jsp:include page="../layout/footer.jsp" />
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="/js/scripts.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
    
    <script>
        // Set date range helper
        function setDateRange(days) {
            const endDate = new Date();
            const startDate = new Date();
            startDate.setDate(endDate.getDate() - days);
            
            document.querySelector('input[name="startDate"]').value = startDate.toISOString().split('T')[0];
            document.querySelector('input[name="endDate"]').value = endDate.toISOString().split('T')[0];
        }
        
        // DataTable
        $(document).ready(function() {
            $('#datatablesSimple').DataTable({
                language: {
                    url: '//cdn.datatables.net/plug-ins/1.13.6/i18n/vi.json'
                },
                order: [[1, 'desc']] // Sắp xếp theo ngày giảm dần
            });
        });
        
        // Revenue Chart
        <c:if test="${bills != null && bills.size() > 0}">
            const revenueCtx = document.getElementById('revenueChart');
            if (revenueCtx) {
                // Group bills by date
                const dailyRevenue = {};
                <c:forEach var="bill" items="${bills}">
                    const dateStr = '${bill.paymentDate}';
                    const date = dateStr.substring(0, 10); // YYYY-MM-DD
                    const revenue = ${bill.totalPrice};
                    
                    if (!dailyRevenue[date]) {
                        dailyRevenue[date] = 0;
                    }
                    dailyRevenue[date] += revenue;
                </c:forEach>
                
                const dates = Object.keys(dailyRevenue).sort((a, b) => {
                    const [dayA, monthA, yearA] = a.split('/');
                    const [dayB, monthB, yearB] = b.split('/');
                    return new Date(yearA, monthA - 1, dayA) - new Date(yearB, monthB - 1, dayB);
                });
                const revenues = dates.map(date => dailyRevenue[date]);
                
                new Chart(revenueCtx, {
                    type: 'line',
                    data: {
                        labels: dates,
                        datasets: [{
                            label: 'Doanh thu (₫)',
                            data: revenues,
                            borderColor: 'rgba(25, 135, 84, 1)',
                            backgroundColor: 'rgba(25, 135, 84, 0.1)',
                            fill: true,
                            tension: 0.4,
                            pointRadius: 5,
                            pointHoverRadius: 7
                        }]
                    },
                    options: {
                        responsive: true,
                        scales: {
                            y: {
                                beginAtZero: true,
                                ticks: {
                                    callback: function(value) {
                                        return value.toLocaleString('vi-VN') + ' ₫';
                                    }
                                }
                            }
                        },
                        plugins: {
                            legend: {
                                display: false
                            },
                            tooltip: {
                                callbacks: {
                                    label: function(context) {
                                        return 'Doanh thu: ' + context.parsed.y.toLocaleString('vi-VN') + ' ₫';
                                    }
                                }
                            }
                        }
                    }
                });
            }
        </c:if>
        
        // Export to Excel (simple implementation)
        function exportToExcel() {
            alert('Tính năng xuất Excel đang được phát triển!');
        }
    </script>
</body>
</html>


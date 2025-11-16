<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <title>Tạo hóa đơn (POS) - Hệ thống POS</title>
    <link href="/css/styles.css" rel="stylesheet" />
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
    <style>
        .product-item {
            cursor: pointer;
            transition: all 0.3s;
        }
        .product-item:hover {
            background-color: #f8f9fa;
            transform: scale(1.02);
        }
        .cart-item {
            border-bottom: 1px solid #dee2e6;
            padding: 10px 0;
        }
        .total-section {
            position: sticky;
            top: 20px;
        }
        .btn-number {
            width: 40px;
        }
    </style>
</head>
<body class="sb-nav-fixed">
    <jsp:include page="../layout/header.jsp" />
    <div id="layoutSidenav">
        <jsp:include page="../layout/sidebar.jsp" />
        <div id="layoutSidenav_content">
            <main>
                <div class="container-fluid px-4">
                    <h1 class="mt-4">
                        <i class="fas fa-cash-register me-2"></i>Tạo hóa đơn (POS)
                    </h1>
                    <ol class="breadcrumb mb-4">
                        <li class="breadcrumb-item"><a href="/admin">Dashboard</a></li>
                        <li class="breadcrumb-item"><a href="/admin/bill">Hóa đơn</a></li>
                        <li class="breadcrumb-item active">Tạo mới</li>
                    </ol>
                    
                    <div class="row">
                        <!-- Sản phẩm -->
                        <div class="col-md-7">
                            <div class="card mb-4">
                                <div class="card-header">
                                    <i class="fas fa-boxes me-1"></i>
                                    Chọn sản phẩm
                                </div>
                                <div class="card-body">
                                    <!-- Search -->
                                    <div class="mb-3">
                                        <input type="text" id="searchProduct" class="form-control" 
                                               placeholder="Tìm kiếm sản phẩm..." />
                                    </div>
                                    
                                    <!-- Product List -->
                                    <div class="row" id="productList">
                                        <c:forEach var="product" items="${products}">
                                            <div class="col-md-4 mb-3 product-card" data-name="${product.name}">
                                                <div class="card product-item h-100" 
                                                     onclick="addToCart('${product.id}', '${product.name}', ${product.price}, ${product.quantity})">
                                                    <div class="card-body text-center">
                                                        <i class="fas fa-box fa-2x text-primary mb-2"></i>
                                                        <h6 class="card-title">${product.name}</h6>
                                                        <p class="card-text">
                                                            <strong>
                                                                <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="₫" maxFractionDigits="0" />
                                                            </strong>
                                                        </p>
                                                        <c:choose>
                                                            <c:when test="${product.quantity > 0}">
                                                                <span class="badge bg-success">Còn: ${product.quantity}</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-danger">Hết hàng</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Giỏ hàng và thanh toán -->
                        <div class="col-md-5">
                            <div class="card mb-4 total-section">
                                <div class="card-header bg-success text-white">
                                    <i class="fas fa-shopping-cart me-1"></i>
                                    Giỏ hàng
                                </div>
                                <div class="card-body">
                                    <div id="cartItems">
                                        <p class="text-center text-muted">
                                            <i class="fas fa-cart-plus fa-3x mb-3"></i><br>
                                            Chưa có sản phẩm nào
                                        </p>
                                    </div>
                                    
                                    <hr>
                                    
                                    <!-- Customer info -->
                                    <div class="mb-3">
                                        <label class="form-label">
                                            <i class="fas fa-user me-1"></i>Khách hàng (không bắt buộc)
                                        </label>
                                        <div class="input-group">
                                            <select id="customerId" class="form-select">
                                                <option value="">Khách lẻ</option>
                                                <c:forEach var="customer" items="${customers}">
                                                    <option value="${customer.id}">
                                                        ${customer.name} - ${customer.phone} (Level ${customer.level})
                                                    </option>
                                                </c:forEach>
                                            </select>
                                            <button type="button" class="btn btn-outline-primary" data-bs-toggle="modal" data-bs-target="#quickCustomerModal">
                                                <i class="fas fa-user-plus me-1"></i>Tạo nhanh
                                            </button>
                                        </div>
                                    </div>
                                    
                                    <!-- Payment method -->
                                    <div class="mb-3">
                                        <label class="form-label">
                                            <i class="fas fa-credit-card me-1"></i>Phương thức thanh toán
                                        </label>
                                        <select id="paymentMethod" class="form-select" required>
                                            <c:forEach var="method" items="${paymentMethods}">
                                                <option value="${method}">${method.displayName}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    
                                    <!-- Summary -->
                                    <div class="bg-light p-3 rounded mb-3">
                                        <div class="d-flex justify-content-between mb-2">
                                            <span>Tạm tính:</span>
                                            <strong id="subtotal">0 ₫</strong>
                                        </div>
                                        <div class="d-flex justify-content-between mb-2 text-success">
                                            <span>Giảm giá (<span id="discountPercent">0</span>%):</span>
                                            <strong id="discountAmount">0 ₫</strong>
                                        </div>
                                        <hr>
                                        <div class="d-flex justify-content-between">
                                            <h5>Tổng cộng:</h5>
                                            <h5 class="text-primary" id="totalAmount">0 ₫</h5>
                                        </div>
                                    </div>
                                    
                                    <!-- Actions -->
                                    <div class="d-grid gap-2">
                                        <button type="button" class="btn btn-success btn-lg" onclick="submitBill()">
                                            <i class="fas fa-check-circle me-2"></i>Thanh toán
                                        </button>
                                        <button type="button" class="btn btn-outline-danger" onclick="clearCart()">
                                            <i class="fas fa-trash me-2"></i>Xóa giỏ hàng
                                        </button>
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
    
    <!-- Quick Create Customer Modal -->
    <div class="modal fade" id="quickCustomerModal" tabindex="-1" aria-labelledby="quickCustomerModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="quickCustomerModalLabel"><i class="fas fa-user-plus me-2"></i>Tạo nhanh khách hàng</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">Tên khách hàng</label>
                        <input type="text" id="qcName" class="form-control" placeholder="VD: Nguyễn Văn A">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Số điện thoại</label>
                        <input type="text" id="qcPhone" class="form-control" placeholder="VD: 0987654321">
                    </div>
                    <div class="alert alert-danger d-none" id="qcError"></div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="button" class="btn btn-primary" id="btnQuickCreateCustomer">
                        <i class="fas fa-save me-1"></i>Lưu và chọn
                    </button>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="/js/scripts.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
        let cart = [];
        const employeeId = '${defaultEmployeeId}';
        
        // Add product to cart
        function addToCart(id, name, price, maxQty) {
            if (maxQty <= 0) {
                Swal.fire({
                    icon: 'warning',
                    title: 'Hết hàng',
                    text: 'Sản phẩm đã hết hàng!'
                });
                return;
            }
            
            const existingItem = cart.find(item => item.productId === id);
            if (existingItem) {
                if (existingItem.quantity < maxQty) {
                    existingItem.quantity++;
                } else {
                    Swal.fire({
                        icon: 'error',
                        title: 'Không đủ hàng',
                        text: 'Không đủ hàng trong kho!'
                    });
                    return;
                }
            } else {
                cart.push({
                    productId: id,
                    name: name,
                    price: price,
                    quantity: 1,
                    maxQty: maxQty
                });
            }
            updateCart();
        }
        
        // Update cart display
        function updateCart() {
            const cartDiv = document.getElementById('cartItems');
            
            if (cart.length === 0) {
                cartDiv.innerHTML = '<p class="text-center text-muted"><i class="fas fa-cart-plus fa-3x mb-3"></i><br>Chưa có sản phẩm nào</p>';
                updateTotal();
                return;
            }
            
            let html = '';
            cart.forEach((item, index) => {
                html += `
                    <div class="cart-item">
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <strong>\${item.name}</strong>
                            <button class="btn btn-sm btn-danger" onclick="removeFromCart(\${index})">
                                <i class="fas fa-times"></i>
                            </button>
                        </div>
                        <div class="d-flex justify-content-between align-items-center">
                            <div class="btn-group btn-group-sm">
                                <button class="btn btn-outline-secondary btn-number" onclick="decreaseQty(\${index})">
                                    <i class="fas fa-minus"></i>
                                </button>
                                <input type="text" class="form-control text-center" value="\${item.quantity}" readonly style="width: 50px;">
                                <button class="btn btn-outline-secondary btn-number" onclick="increaseQty(\${index})">
                                    <i class="fas fa-plus"></i>
                                </button>
                            </div>
                            <strong>\${formatCurrency(item.price * item.quantity)}</strong>
                        </div>
                    </div>
                `;
            });
            
            cartDiv.innerHTML = html;
            updateTotal();
        }
        
        // Increase quantity
        function increaseQty(index) {
            if (cart[index].quantity < cart[index].maxQty) {
                cart[index].quantity++;
                updateCart();
            } else {
                Swal.fire({
                    icon: 'error',
                    title: 'Không đủ hàng',
                    text: 'Không đủ hàng trong kho!'
                });
            }
        }
        
        // Decrease quantity
        function decreaseQty(index) {
            if (cart[index].quantity > 1) {
                cart[index].quantity--;
                updateCart();
            }
        }
        
        // Remove from cart
        function removeFromCart(index) {
            cart.splice(index, 1);
            updateCart();
        }
        
        // Clear cart
        function clearCart() {
            Swal.fire({
                title: 'Xóa giỏ hàng?',
                text: 'Bạn có chắc muốn xóa tất cả sản phẩm?',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonText: 'Xóa',
                cancelButtonText: 'Hủy'
            }).then((result) => {
                if (result.isConfirmed) {
                    cart = [];
                    updateCart();
                    Swal.fire({
                        icon: 'success',
                        title: 'Đã xóa giỏ hàng',
                        timer: 1200,
                        showConfirmButton: false
                    });
                }
            });
        }
        
        // Update total
        function updateTotal() {
            const subtotal = cart.reduce((sum, item) => sum + (item.price * item.quantity), 0);
            
            // Get discount based on customer level
            const customerId = document.getElementById('customerId').value;
            const customerSelect = document.getElementById('customerId');
            const selectedOption = customerSelect.options[customerSelect.selectedIndex];
            const customerText = selectedOption.text;
            
            let discountPercent = 0;
            if (customerText.includes('Level 2')) discountPercent = 5;
            else if (customerText.includes('Level 3')) discountPercent = 10;
            else if (customerText.includes('Level 4')) discountPercent = 15;
            
            const discountAmount = subtotal * discountPercent / 100;
            const total = subtotal - discountAmount;
            
            document.getElementById('subtotal').textContent = formatCurrency(subtotal);
            document.getElementById('discountPercent').textContent = discountPercent;
            document.getElementById('discountAmount').textContent = formatCurrency(discountAmount);
            document.getElementById('totalAmount').textContent = formatCurrency(total);
        }
        
        // Submit bill
        function submitBill() {
            if (cart.length === 0) {
                Swal.fire({
                    icon: 'info',
                    title: 'Giỏ hàng trống',
                    text: 'Vui lòng chọn sản phẩm trước khi thanh toán.'
                });
                return;
            }
            
            const customerId = document.getElementById('customerId').value;
            const paymentMethod = document.getElementById('paymentMethod').value;
            
            const billData = {
                employeeId: employeeId,
                customerId: customerId || null,
                paymentMethod: paymentMethod,
                billDetails: cart.map(item => ({
                    productId: item.productId,
                    quantity: item.quantity
                }))
            };
            
            // Send to server
            fetch('/admin/bill/create', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    '${_csrf.headerName}': '${_csrf.token}'
                },
                body: JSON.stringify(billData)
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    Swal.fire({
                        icon: 'success',
                        title: 'Tạo hóa đơn thành công',
                        html: 'Mã hóa đơn: <strong>' + data.billId + '</strong><br>Bạn có muốn in hóa đơn ngay?',
                        showCancelButton: true,
                        confirmButtonText: 'In hóa đơn',
                        cancelButtonText: 'Xem danh sách'
                    }).then((result) => {
                        if (result.isConfirmed) {
                            window.open('/admin/bill/' + data.billId + '/print', '_blank');
                            window.location.href = '/admin/bill';
                        } else {
                            window.location.href = '/admin/bill';
                        }
                    });
                } else {
                    Swal.fire({
                        icon: 'error',
                        title: 'Không thể tạo hóa đơn',
                        text: (data.message || 'Đã xảy ra lỗi không xác định')
                    });
                }
            })
            .catch(error => {
                Swal.fire({
                    icon: 'error',
                    title: 'Có lỗi xảy ra',
                    text: String(error)
                });
            });
        }
        
        // Quick create customer
        document.getElementById('btnQuickCreateCustomer').addEventListener('click', function() {
            const name = document.getElementById('qcName').value.trim();
            const phone = document.getElementById('qcPhone').value.trim();
            const err = document.getElementById('qcError');
            err.classList.add('d-none');
            err.textContent = '';
            
            if (!name || !phone) {
                err.textContent = 'Vui lòng nhập đầy đủ tên và số điện thoại.';
                err.classList.remove('d-none');
                return;
            }
            
            fetch('/admin/customer/quick-create', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    '${_csrf.headerName}': '${_csrf.token}'
                },
                body: JSON.stringify({ name: name, phone: phone })
            })
            .then(r => r.json())
            .then(data => {
                if (data.success) {
                    // Thêm vào dropdown và chọn luôn
                    const sel = document.getElementById('customerId');
                    const opt = document.createElement('option');
                    opt.value = data.id;
                    opt.text = data.name + ' - ' + data.phone + ' (Level ' + data.level + ')';
                    sel.add(opt);
                    sel.value = data.id;
                    updateTotal();
                    // Đóng modal
                    const modalEl = document.getElementById('quickCustomerModal');
                    const modal = bootstrap.Modal.getInstance(modalEl);
                    modal.hide();
                    // Reset form
                    document.getElementById('qcName').value = '';
                    document.getElementById('qcPhone').value = '';
                    
                    Swal.fire({
                        icon: 'success',
                        title: 'Đã tạo khách hàng',
                        text: data.name + ' (' + data.phone + ')',
                        timer: 1500,
                        showConfirmButton: false
                    });
                } else {
                    err.textContent = data.message || 'Không thể tạo khách hàng.';
                    err.classList.remove('d-none');
                }
            })
            .catch(e => {
                err.textContent = 'Có lỗi xảy ra: ' + e;
                err.classList.remove('d-none');
            });
        });
        
        // Format currency
        function formatCurrency(amount) {
            return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(amount);
        }
        
        // Search products
        document.getElementById('searchProduct').addEventListener('input', function(e) {
            const searchTerm = e.target.value.toLowerCase();
            const productCards = document.querySelectorAll('.product-card');
            
            productCards.forEach(card => {
                const productName = card.getAttribute('data-name').toLowerCase();
                if (productName.includes(searchTerm)) {
                    card.style.display = 'block';
                } else {
                    card.style.display = 'none';
                }
            });
        });
        
        // Update total when customer changes (for discount)
        document.getElementById('customerId').addEventListener('change', updateTotal);
    </script>
</body>
</html>


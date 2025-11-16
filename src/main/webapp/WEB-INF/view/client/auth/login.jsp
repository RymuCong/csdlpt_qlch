<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - RedMart POS System</title>
    
    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    
    <!-- Animate.css for smooth animations -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css">
    
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    
    <style>
        :root {
            --redmart-primary: #E31837;
            --redmart-primary-dark: #C1121F;
            --redmart-primary-light: #FF3B52;
            --redmart-secondary: #FF6B35;
            --redmart-accent: #FFA500;
            --redmart-dark: #1A1A1A;
            --redmart-gray: #6C757D;
            --redmart-light: #F8F9FA;
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            background: linear-gradient(135deg, #E31837 0%, #FF6B35 50%, #FFA500 100%);
            background-size: 400% 400%;
            animation: gradientShift 15s ease infinite;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            overflow: hidden;
        }
        
        @keyframes gradientShift {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }
        
        /* Animated background shapes */
        body::before,
        body::after {
            content: '';
            position: absolute;
            border-radius: 50%;
            opacity: 0.1;
            animation: float 20s infinite ease-in-out;
        }
        
        body::before {
            width: 500px;
            height: 500px;
            background: white;
            top: -250px;
            right: -250px;
            animation-delay: 0s;
        }
        
        body::after {
            width: 400px;
            height: 400px;
            background: white;
            bottom: -200px;
            left: -200px;
            animation-delay: 5s;
        }
        
        @keyframes float {
            0%, 100% { transform: translate(0, 0) rotate(0deg); }
            33% { transform: translate(30px, -30px) rotate(120deg); }
            66% { transform: translate(-20px, 20px) rotate(240deg); }
        }
        
        .login-wrapper {
            position: relative;
            z-index: 1;
            width: 100%;
            max-width: 480px;
            padding: 20px;
        }
        
        .login-container {
            background: rgba(255, 255, 255, 0.98);
            backdrop-filter: blur(20px);
            border-radius: 24px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3),
                        0 0 0 1px rgba(255, 255, 255, 0.1);
            overflow: visible;
            animation: slideUp 0.6s ease-out;
            position: relative;
        }
        
        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .login-header {
            background: linear-gradient(135deg, var(--redmart-primary) 0%, var(--redmart-primary-dark) 100%);
            color: white;
            padding: 50px 30px 40px;
            text-align: center;
            position: relative;
            overflow: hidden;
            border-radius: 24px 24px 0 0;
        }
        
        .login-header::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 70%);
            animation: rotate 20s linear infinite;
        }
        
        @keyframes rotate {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
        }
        
        .login-header .logo-wrapper {
            position: relative;
            z-index: 1;
            margin-bottom: 20px;
        }
        
        .login-header .logo-icon {
            width: 80px;
            height: 80px;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 20px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 15px;
            backdrop-filter: blur(10px);
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            animation: pulse 2s ease-in-out infinite;
        }
        
        @keyframes pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.05); }
        }
        
        .login-header .logo-icon i {
            font-size: 2.5rem;
            color: white;
        }
        
        .login-header h1 {
            font-size: 2rem;
            font-weight: 800;
            margin: 0;
            letter-spacing: -0.5px;
            text-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
        }
        
        .login-header .subtitle {
            font-size: 0.95rem;
            opacity: 0.95;
            margin-top: 8px;
            font-weight: 400;
        }
        
        .login-header .tagline {
            font-size: 0.85rem;
            opacity: 0.85;
            margin-top: 12px;
            font-weight: 300;
        }
        
        .login-body {
            padding: 40px 35px;
        }
        
        .form-group-custom {
            margin-bottom: 24px;
            position: relative;
        }
        
        .input-wrapper {
            position: relative;
            display: flex;
            align-items: center;
            background: var(--redmart-light);
            border: 2px solid transparent;
            border-radius: 12px;
            transition: all 0.3s ease;
            overflow: visible;
            min-height: 56px;
        }
        
        .input-wrapper:focus-within {
            border-color: var(--redmart-primary);
            background: white;
            box-shadow: 0 0 0 4px rgba(227, 24, 55, 0.1);
            transform: translateY(-2px);
        }
        
        .input-wrapper:focus-within,
        .input-wrapper.has-value {
            padding-top: 8px;
            align-items: flex-start;
            min-height: 64px;
        }
        
        .input-icon {
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 0 18px;
            color: var(--redmart-gray);
            font-size: 1.1rem;
            transition: all 0.3s ease;
            height: 100%;
            min-height: 56px;
            flex-shrink: 0;
        }
        
        .input-wrapper:focus-within .input-icon,
        .input-wrapper.has-value .input-icon {
            padding-top: 8px;
            align-items: flex-start;
            min-height: 64px;
        }
        
        .input-wrapper:focus-within .input-icon {
            color: var(--redmart-primary);
            transform: scale(1.1);
        }
        
        .form-control-custom {
            border: none;
            background: transparent;
            padding: 16px 18px 16px 0;
            font-size: 1rem;
            font-weight: 400;
            color: var(--redmart-dark);
            flex: 1;
            outline: none;
            width: 100%;
            z-index: 2;
            position: relative;
            line-height: 1.5;
            display: flex;
            align-items: center;
            min-height: 24px;
        }
        
        .form-control-custom::placeholder {
            color: transparent;
            opacity: 0;
        }
        
        .form-label-custom {
            position: absolute;
            left: 60px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--redmart-gray);
            font-size: 1rem;
            font-weight: 400;
            pointer-events: none;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            background: transparent;
            z-index: 3;
            white-space: nowrap;
            line-height: 1.5;
        }
        
        .input-wrapper:focus-within .form-label-custom,
        .input-wrapper.has-value .form-label-custom {
            top: -10px;
            left: 50px;
            font-size: 0.7rem;
            color: var(--redmart-primary);
            background: white;
            padding: 2px 8px;
            transform: translateY(0);
            font-weight: 600;
            z-index: 10;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.08);
            border-radius: 4px;
        }
        
        .input-wrapper:focus-within .form-control-custom,
        .input-wrapper.has-value .form-control-custom {
            padding-top: 8px;
            padding-bottom: 16px;
            align-items: flex-start;
        }
        
        .remember-me-wrapper {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 28px;
        }
        
        .form-check-custom {
            display: flex;
            align-items: center;
            cursor: pointer;
        }
        
        .form-check-custom input[type="checkbox"] {
            width: 20px;
            height: 20px;
            margin-right: 10px;
            cursor: pointer;
            accent-color: var(--redmart-primary);
        }
        
        .form-check-custom label {
            margin: 0;
            cursor: pointer;
            font-size: 0.9rem;
            color: var(--redmart-gray);
            user-select: none;
        }
        
        .btn-login {
            width: 100%;
            padding: 16px;
            background: linear-gradient(135deg, var(--redmart-primary) 0%, var(--redmart-primary-dark) 100%);
            border: none;
            border-radius: 12px;
            color: white;
            font-size: 1.05rem;
            font-weight: 600;
            letter-spacing: 0.5px;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(227, 24, 55, 0.3);
        }
        
        .btn-login::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 0;
            height: 0;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.3);
            transform: translate(-50%, -50%);
            transition: width 0.6s, height 0.6s;
        }
        
        .btn-login:hover::before {
            width: 300px;
            height: 300px;
        }
        
        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(227, 24, 55, 0.4);
        }
        
        .btn-login:active {
            transform: translateY(0);
        }
        
        .btn-login span {
            position: relative;
            z-index: 1;
        }
        
        .alert-custom {
            border-radius: 12px;
            border: none;
            padding: 16px 20px;
            margin-bottom: 24px;
            animation: shake 0.5s ease;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }
        
        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-10px); }
            75% { transform: translateX(10px); }
        }
        
        .alert-danger-custom {
            background: linear-gradient(135deg, #fee 0%, #fdd 100%);
            color: #c1121f;
            border-left: 4px solid #c1121f;
        }
        
        .alert-success-custom {
            background: linear-gradient(135deg, #d4edda 0%, #c3e6cb 100%);
            color: #155724;
            border-left: 4px solid #28a745;
        }
        
        .info-section {
            margin-top: 32px;
            padding-top: 24px;
            border-top: 1px solid #e9ecef;
        }
        
        .info-item {
            display: flex;
            align-items: center;
            margin-bottom: 12px;
            color: var(--redmart-gray);
            font-size: 0.85rem;
        }
        
        .info-item:last-child {
            margin-bottom: 0;
        }
        
        .info-item i {
            margin-right: 10px;
            color: var(--redmart-primary);
            width: 18px;
        }
        
        /* Responsive */
        @media (max-width: 576px) {
            .login-wrapper {
                padding: 15px;
            }
            
            .login-header {
                padding: 40px 25px 35px;
            }
            
            .login-header h1 {
                font-size: 1.75rem;
            }
            
            .login-body {
                padding: 30px 25px;
            }
        }
        
        /* Loading spinner */
        .spinner-border-sm {
            width: 1rem;
            height: 1rem;
            border-width: 0.15em;
        }
        
        /* Home button */
        .home-button {
            position: absolute;
            top: 20px;
            left: 20px;
            z-index: 100;
            width: 48px;
            height: 48px;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border: 2px solid rgba(255, 255, 255, 0.3);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--redmart-primary);
            font-size: 1.3rem;
            text-decoration: none;
            transition: all 0.3s ease;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        }
        
        .home-button:hover {
            background: white;
            color: var(--redmart-primary-dark);
            transform: translateY(-2px) scale(1.05);
            box-shadow: 0 6px 20px rgba(227, 24, 55, 0.3);
            border-color: var(--redmart-primary);
        }
        
        .home-button:active {
            transform: translateY(0) scale(0.98);
        }
        
        .home-button i {
            transition: transform 0.3s ease;
        }
        
        .home-button:hover i {
            transform: scale(1.1);
        }
        
        /* Responsive home button */
        @media (max-width: 576px) {
            .home-button {
                width: 44px;
                height: 44px;
                top: 15px;
                left: 15px;
                font-size: 1.2rem;
            }
        }
    </style>
</head>
<body>
    <div class="login-wrapper">
        <div class="login-container animate__animated animate__fadeInUp">
            <!-- Home Button -->
            <a href="/" class="home-button" title="Về trang chủ">
                <i class="fas fa-home"></i>
            </a>
            
            <div class="login-header">
                <div class="logo-wrapper">
                    <div class="logo-icon">
                        <i class="fas fa-store"></i>
                    </div>
                    <h1>RedMart</h1>
                    <p class="subtitle">Hệ thống Quản lý Chuỗi Cửa hàng</p>
                    <p class="tagline">
                        <i class="fas fa-bolt me-1"></i>
                        POS System - Quản lý bán hàng thông minh
                    </p>
                </div>
            </div>
            
            <div class="login-body">
                <c:if test="${param.error != null}">
                    <div class="alert-custom alert-danger-custom alert-dismissible fade show animate__animated animate__shakeX" role="alert">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        <strong>Đăng nhập thất bại!</strong> Số điện thoại hoặc mật khẩu không đúng.
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>
                
                <c:if test="${param.logout != null}">
                    <div class="alert-custom alert-success-custom alert-dismissible fade show animate__animated animate__fadeInDown" role="alert">
                        <i class="fas fa-check-circle me-2"></i>
                        <strong>Thành công!</strong> Đã đăng xuất khỏi hệ thống.
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>
                
                <form method="post" action="/login" id="loginForm">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                    
                    <div class="form-group-custom">
                        <div class="input-wrapper">
                            <div class="input-icon">
                                <i class="fas fa-phone"></i>
                            </div>
                            <input class="form-control-custom" 
                                   type="text" 
                                   id="username" 
                                   name="username" 
                                   placeholder=" "
                                   required 
                                   autofocus
                                   autocomplete="tel"/>
                            <label class="form-label-custom" for="username">Số điện thoại</label>
                        </div>
                    </div>
                    
                    <div class="form-group-custom">
                        <div class="input-wrapper">
                            <div class="input-icon">
                                <i class="fas fa-lock"></i>
                            </div>
                            <input class="form-control-custom" 
                                   type="password" 
                                   id="password" 
                                   name="password" 
                                   placeholder=" "
                                   required
                                   autocomplete="current-password"/>
                            <label class="form-label-custom" for="password">Mật khẩu</label>
                        </div>
                    </div>
                    
                    <div class="remember-me-wrapper">
                        <div class="form-check-custom">
                            <input type="checkbox" 
                                   id="remember-me" 
                                   name="remember-me"/>
                            <label for="remember-me">Ghi nhớ đăng nhập</label>
                        </div>
                        <a href="#" class="text-decoration-none" style="color: var(--redmart-primary); font-size: 0.9rem;">
                            <i class="fas fa-question-circle me-1"></i>Quên mật khẩu?
                        </a>
                    </div>
                    
                    <button class="btn btn-login" type="submit" id="loginBtn">
                        <span>
                            <i class="fas fa-sign-in-alt me-2"></i>Đăng nhập
                        </span>
                    </button>
                </form>
                
                <div class="info-section">
                    <div class="info-item">
                        <i class="fas fa-user-tie"></i>
                        <span><strong>Dành cho nhân viên:</strong> Đăng nhập bằng số điện thoại đã đăng ký</span>
                    </div>
                    <div class="info-item">
                        <i class="fas fa-headset"></i>
                        <span>Liên hệ quản lý nếu quên mật khẩu hoặc cần hỗ trợ</span>
                    </div>
                    <div class="info-item">
                        <i class="fas fa-shield-alt"></i>
                        <span>Hệ thống được bảo mật và mã hóa an toàn</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- SweetAlert2 for better alerts (optional enhancement) -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    
    <script>
        // Form submission with loading state
        document.getElementById('loginForm').addEventListener('submit', function(e) {
            const btn = document.getElementById('loginBtn');
            const btnSpan = btn.querySelector('span');
            
            // Disable button and show loading
            btn.disabled = true;
            btnSpan.innerHTML = '<span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span>Đang xử lý...';
            
            // Re-enable after 3 seconds (in case of slow response)
            setTimeout(() => {
                btn.disabled = false;
                btnSpan.innerHTML = '<i class="fas fa-sign-in-alt me-2"></i>Đăng nhập';
            }, 3000);
        });
        
        // Add input validation feedback and floating label logic
        const inputs = document.querySelectorAll('.form-control-custom');
        inputs.forEach(input => {
            // Check initial value
            if (input.value.trim() !== '') {
                input.closest('.input-wrapper').classList.add('has-value');
            }
            
            // Handle input events
            input.addEventListener('input', function() {
                const wrapper = this.closest('.input-wrapper');
                if (this.value.trim() !== '') {
                    wrapper.classList.add('has-value');
                } else {
                    wrapper.classList.remove('has-value');
                }
            });
            
            // Handle focus events
            input.addEventListener('focus', function() {
                const wrapper = this.closest('.input-wrapper');
                wrapper.classList.add('has-value');
            });
            
            // Handle blur events
            input.addEventListener('blur', function() {
                const wrapper = this.closest('.input-wrapper');
                if (this.value.trim() === '') {
                    wrapper.classList.remove('has-value');
                } else {
                    wrapper.classList.add('has-value');
                }
            });
        });
        
        // Auto-dismiss alerts after 5 seconds
        setTimeout(() => {
            const alerts = document.querySelectorAll('.alert-custom');
            alerts.forEach(alert => {
                const bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            });
        }, 5000);
        
        // Add enter key support for form submission
        document.addEventListener('keypress', function(e) {
            if (e.key === 'Enter' && document.activeElement.tagName !== 'BUTTON') {
                document.getElementById('loginForm').requestSubmit();
            }
        });
    </script>
</body>
</html>

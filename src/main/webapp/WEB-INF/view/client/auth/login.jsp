<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - Hệ thống POS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .login-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            overflow: hidden;
            max-width: 450px;
            width: 100%;
        }
        .login-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 40px 30px;
            text-align: center;
        }
        .login-header h2 {
            margin: 0;
            font-weight: 600;
        }
        .login-header p {
            margin: 10px 0 0;
            opacity: 0.9;
        }
        .login-body {
            padding: 40px 30px;
        }
        .form-floating {
            margin-bottom: 20px;
        }
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        .btn-login {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            padding: 12px;
            font-weight: 600;
            transition: all 0.3s;
        }
        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 20px rgba(102, 126, 234, 0.4);
        }
        .alert {
            border-radius: 10px;
            margin-bottom: 20px;
        }
        .input-group-text {
            background: #f8f9fa;
            border-right: none;
        }
        .form-control {
            border-left: none;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="login-header">
            <i class="fas fa-store-alt fa-3x mb-3"></i>
            <h2>Chuỗi Cửa Hàng Tiện Lợi</h2>
            <p>Hệ thống quản lý bán hàng (POS)</p>
        </div>
        
        <div class="login-body">
            <c:if test="${param.error != null}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-circle me-2"></i>
                    <strong>Đăng nhập thất bại!</strong> Số điện thoại hoặc mật khẩu không đúng.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            
            <c:if test="${param.logout != null}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle me-2"></i>
                    Đã đăng xuất thành công!
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            
            <form method="post" action="/login">
                <c:if test="${param.error != null}">
                    <input type="hidden" name="error" value="true" />
                </c:if>
                
                <div class="input-group mb-3">
                    <span class="input-group-text">
                        <i class="fas fa-phone"></i>
                    </span>
                    <div class="form-floating flex-grow-1">
                        <input class="form-control" 
                               type="text" 
                               id="username" 
                               name="username" 
                               placeholder="Số điện thoại"
                               required 
                               autofocus/>
                        <label for="username">Số điện thoại</label>
                    </div>
                </div>
                
                <div class="input-group mb-3">
                    <span class="input-group-text">
                        <i class="fas fa-lock"></i>
                    </span>
                    <div class="form-floating flex-grow-1">
                        <input class="form-control" 
                               type="password" 
                               id="password" 
                               name="password" 
                               placeholder="Mật khẩu"
                               required/>
                        <label for="password">Mật khẩu</label>
                    </div>
                </div>
                
                <div class="form-check mb-3">
                    <input class="form-check-input" 
                           type="checkbox" 
                           id="remember-me" 
                           name="remember-me"/>
                    <label class="form-check-label" for="remember-me">
                        Ghi nhớ đăng nhập
                    </label>
                </div>
                
                <div>
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                </div>
                
                <button class="btn btn-primary btn-login w-100" type="submit">
                    <i class="fas fa-sign-in-alt me-2"></i>Đăng nhập
                </button>
            </form>
            
            <div class="text-center mt-4">
                <p class="text-muted mb-2">
                    <small>
                        <i class="fas fa-info-circle me-1"></i>
                        <strong>Dành cho nhân viên:</strong> Đăng nhập bằng số điện thoại đã đăng ký
                    </small>
                </p>
                <p class="text-muted mb-0">
                    <small>
                        <i class="fas fa-headset me-1"></i>
                        Liên hệ quản lý nếu quên mật khẩu hoặc cần hỗ trợ
                    </small>
                </p>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

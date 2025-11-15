<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Truy cập bị từ chối - MiniMart Plus</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            text-align: center;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: #721c24;
            padding: 50px;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .container {
            background: white;
            padding: 50px;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            display: inline-block;
            max-width: 500px;
        }
        .icon {
            color: #dc3545;
            font-size: 80px;
            margin-bottom: 20px;
        }
        h1 {
            font-size: 48px;
            margin-bottom: 10px;
            color: #dc3545;
        }
        h2 {
            font-size: 24px;
            color: #333;
            margin-bottom: 20px;
        }
        p {
            font-size: 16px;
            color: #666;
            line-height: 1.6;
        }
        .back-btn {
            display: inline-block;
            margin-top: 30px;
            padding: 12px 30px;
            font-size: 16px;
            color: white;
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            border: none;
            border-radius: 25px;
            cursor: pointer;
            text-decoration: none;
            transition: all 0.3s;
        }
        .back-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 20px rgba(40, 167, 69, 0.4);
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="icon">
            <i class="fas fa-lock"></i>
        </div>
        <h1>403</h1>
        <h2>Truy cập bị từ chối</h2>
        <p>
            <i class="fas fa-exclamation-triangle me-2"></i>
            Bạn không có quyền truy cập vào trang này.<br>
            Vui lòng đăng nhập với tài khoản có quyền phù hợp hoặc liên hệ quản lý để được hỗ trợ.
        </p>
        <a href="/" class="back-btn">
            <i class="fas fa-home me-2"></i>Quay về trang chủ
        </a>
    </div>
</body>
</html>

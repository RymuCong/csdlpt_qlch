<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thông Báo Lỗi</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            text-align: center;
            padding: 50px;
            background-color: #f8d7da;
        }
        .error-container {
            max-width: 400px;
            margin: auto;
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            border-left: 5px solid #721c24;
        }
        .error-message {
            color: #721c24;
            font-size: 18px;
            font-weight: bold;
        }
        p {
            color: #721c24;
            margin: 10px 0;
        }
        img {
            margin-top: 20px;
            width: 150px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
    </style>
</head>
<body>
    <div class="error-container">
        <h2 class="error-message">Lỗi</h2>
        <p>Hành động thực hiện không thành công</p>
    </div>
    <br>
    <img src="https://i.pinimg.com/736x/89/f3/6c/89f36ce0ef58d2d23056fee39c18e3ee.jpg" alt="Lỗi xảy ra">
</body>
</html>

<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Logout.aspx.cs" Inherits="Admin_Logout" %>

<!DOCTYPE html>
<html lang="fa">
<head>
    <title>خروج از پنل ادمین</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <style>
        body {
            background: #f6f7fb;
            font-family: 'Vazirmatn', Tahoma, sans-serif;
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            margin: 0;
        }
        .logout-container {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            padding: 40px;
            text-align: center;
            max-width: 400px;
            width: 90%;
        }
        .logout-icon {
            font-size: 3rem;
            color: #ff6b6b;
            margin-bottom: 20px;
        }
        .logout-title {
            font-size: 1.5rem;
            color: #333;
            margin-bottom: 15px;
            font-weight: bold;
        }
        .logout-message {
            color: #666;
            margin-bottom: 25px;
            line-height: 1.6;
        }
        .logout-btn {
            background: #4CAF50;
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 6px;
            font-size: 1rem;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            transition: background 0.3s;
        }
        .logout-btn:hover {
            background: #45a049;
        }
    </style>
</head>
<body>
    <div class="logout-container">
        <div class="logout-icon">👋</div>
        <div class="logout-title">خروج موفق</div>
        <div class="logout-message">
            شما با موفقیت از پنل ادمین خارج شدید.
        </div>
        <a href="Login.aspx" class="logout-btn">ورود مجدد</a>
    </div>
</body>
</html> 
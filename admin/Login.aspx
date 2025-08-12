<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Admin_Login" %>
<!DOCTYPE html>
<html lang="fa">
<head>
    <title>ورود ادمین</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
    <style>
        body {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Vazirmatn', Tahoma, sans-serif;
            position: relative;
            overflow: hidden;
        }
        
        /* اسلایدشو پس‌زمینه */
        .admin-slideshow {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: -1;
        }
        
        .admin-slide {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            opacity: 0;
            transition: opacity 2s ease-in-out;
        }
        
        .admin-slide img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .admin-slide-overlay {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0,0,0,0.4);
        }
        .login-container {
            background: rgba(255,255,255,0.97);
            border-radius: 18px;
            box-shadow: 0 8px 32px rgba(93,64,55,0.18);
            padding: 40px 32px 32px 32px;
            min-width: 340px;
            max-width: 95vw;
            border: 2px solid #8D6E63;
        }
        .login-title {
            text-align: center;
            font-size: 2rem;
            color: #5D4037;
            margin-bottom: 24px;
            font-weight: bold;
            letter-spacing: 1px;
        }
        .login-input {
            width: 100%;
            padding: 10px 12px;
            margin-bottom: 18px;
            border-radius: 8px;
            border: 1.5px solid #BCAAA4;
            font-size: 1rem;
            background: #f7f3ef;
            transition: border 0.2s;
        }
        .login-input:focus {
            border: 2px solid #8D6E63;
            outline: none;
        }
        .login-btn {
            width: 100%;
            background: linear-gradient(45deg, #ffda67, #ff7c7d);
            color: #3E2723;
            border: none;
            border-radius: 8px;
            padding: 12px 0;
            font-size: 1.1rem;
            font-weight: bold;
            cursor: pointer;
            transition: background 0.2s;
            margin-top: 8px;
        }
        .login-btn:hover {
            background: linear-gradient(45deg, #ff7c7d, #ffda67);
        }
        .login-icon {
            color: #8D6E63;
            font-size: 2.2rem;
            display: block;
            text-align: center;
            margin-bottom: 10px;
        }
        .login-error {
            color: #d32f2f;
            text-align: center;
            margin-bottom: 10px;
            font-size: 1rem;
        }
    </style>
</head>
<body>
    <!-- اسلایدشو پس‌زمینه -->
    <div id="adminSlideshow" class="admin-slideshow">
        <div class="admin-slide" style="opacity: 1;">
            <img src="../images/admin-slideshow/admin-bg1.jpg" alt="پنل مدیریت" />
            <div class="admin-slide-overlay"></div>
        </div>
        <div class="admin-slide">
            <img src="../images/admin-slideshow/admin-bg2.jpg" alt="امکانات پیشرفته" />
            <div class="admin-slide-overlay"></div>
        </div>
        <div class="admin-slide">
            <img src="../images/admin-slideshow/admin-bg3.jpg" alt="مدیریت حرفه‌ای" />
            <div class="admin-slide-overlay"></div>
        </div>
    </div>

    <div class="login-container">
        <i class="fas fa-user-shield login-icon"></i>
        <div class="login-title">ورود ادمین</div>
        <form id="form1" runat="server">
            <asp:Label ID="lblMsg" runat="server" CssClass="login-error" />
            <asp:TextBox ID="txtUsername" runat="server" CssClass="login-input" placeholder="نام کاربری"></asp:TextBox>
            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="login-input" placeholder="رمز عبور"></asp:TextBox>
            <asp:Button ID="btnLogin" runat="server" Text="ورود" CssClass="login-btn" OnClick="btnLogin_Click" />
        </form>
    </div>

    <script>
        // اسلایدشو پس‌زمینه صفحه ورود ادمین
        let adminSlideIndex = 0;
        let adminSlides = document.querySelectorAll('.admin-slide');

        function showAdminSlide(n) {
            // مخفی کردن همه اسلایدها
            for (let i = 0; i < adminSlides.length; i++) {
                adminSlides[i].style.opacity = "0";
            }
            
            // نمایش اسلاید فعلی
            if (adminSlides[n]) {
                adminSlides[n].style.opacity = "1";
            }
        }

        function nextAdminSlide() {
            adminSlideIndex++;
            if (adminSlideIndex >= adminSlides.length) {
                adminSlideIndex = 0;
            }
            showAdminSlide(adminSlideIndex);
        }

        // شروع اسلایدشو
        setInterval(nextAdminSlide, 5000); // تغییر هر 5 ثانیه
    </script>
</body>
</html> 
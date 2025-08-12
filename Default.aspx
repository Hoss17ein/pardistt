<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="Pardis.Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>باشگاه تنیس روی میز پردیس</title>
        <style>
            body {
                font-family: 'Vazirmatn', sans-serif;
                scroll-behavior: smooth;
            }

            .hero-pattern {
                background-color: #0f172a;
                background-image: radial-gradient(circle at 25px 25px, rgba(255, 255, 255, 0.2) 2%, transparent 0%), radial-gradient(circle at 75px 75px, rgba(255, 255, 255, 0.2) 2%, transparent 0%);
                background-size: 100px 100px;
            }

            .ping-pong-animation {
                animation: pingpong 3s infinite ease-in-out;
            }

            @keyframes pingpong {
                0%, 100% {
                    transform: translateX(0);
                }

                50% {
                    transform: translateX(30px);
                }
            }

            .tab-content {
                display: none;
            }

                .tab-content.active {
                    display: block;
                }

            .gallery-item {
                transition: all 0.3s ease;
            }

                .gallery-item:hover {
                    transform: scale(1.03);
                    box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
                }

            .coach-card {
                transition: all 0.3s ease;
            }

                .coach-card:hover {
                    transform: translateY(-10px);
                }

            .news-card {
                transition: all 0.3s ease;
            }

                .news-card:hover {
                    transform: translateY(-5px);
                }

            .nav-link {
                position: relative;
            }

                .nav-link::after {
                    content: '';
                    position: absolute;
                    width: 0;
                    height: 2px;
                    bottom: -4px;
                    left: 0;
                    background-color: #ffffff;
                    transition: width 0.3s ease;
                }

                .nav-link:hover::after {
                    width: 100%;
                }

            .custom-shape-divider {
                position: absolute;
                bottom: 0;
                left: 0;
                width: 100%;
                overflow: hidden;
                line-height: 0;
            }

                .custom-shape-divider svg {
                    position: relative;
                    display: block;
                    width: calc(100% + 1.3px);
                    height: 70px;
                }

                .custom-shape-divider .shape-fill {
                    fill: #FFFFFF;
                }

            .mobile-menu {
                transition: transform 0.3s ease-in-out;
                transform: translateX(100%);
            }

                .mobile-menu.active {
                    transform: translateX(0);
                }

            /* استایل‌های اسلایدشو */
            .slide-btn {
                cursor: pointer;
                position: absolute;
                top: 50%;
                width: auto;
                padding: 16px;
                margin-top: -22px;
                color: white;
                font-weight: bold;
                font-size: 18px;
                transition: 0.6s ease;
                border-radius: 50%;
                user-select: none;
                background: rgba(0,0,0,0.5);
                border: none;
                z-index: 25;
            }
            .slide-btn:hover {
                background-color: rgba(0,0,0,0.8);
            }
            .dot {
                cursor: pointer;
                height: 12px;
                width: 12px;
                margin: 0 4px;
                background-color: rgba(255,255,255,0.5);
                border-radius: 50%;
                display: inline-block;
                transition: background-color 0.6s ease;
            }
            .dot.active, .dot:hover {
                background-color: #ffffff;
            }
            .slide-title {
                animation: slideInFromTop 1s ease-out;
            }
            .slide-description {
                animation: slideInFromBottom 1s ease-out 0.3s both;
            }
            @keyframes slideInFromTop {
                from {
                    opacity: 0;
                    transform: translateY(-50px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }
            @keyframes slideInFromBottom {
                from {
                    opacity: 0;
                    transform: translateY(50px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }
        </style>

        <script>
            // اسلایدشو اصلی - فقط تغییر خودکار
            let mainSlideIndex = 0;
            let mainSlides = [];

            function showMainSlide(n) {
                // مخفی کردن همه اسلایدها
                for (let i = 0; i < mainSlides.length; i++) {
                    mainSlides[i].style.opacity = "0";
                }
                
                // نمایش اسلاید فعلی
                if (mainSlides[n]) {
                    mainSlides[n].style.opacity = "1";
                }
            }

            function nextMainSlide() {
                mainSlideIndex++;
                if (mainSlideIndex >= mainSlides.length) {
                    mainSlideIndex = 0;
                }
                showMainSlide(mainSlideIndex);
            }

            // نمایش اسلاید اول و شروع تغییر خودکار
            document.addEventListener('DOMContentLoaded', function() {
                // انتخاب اسلایدها پس از رندر شدن رپیتر
                mainSlides = document.querySelectorAll('#mainSlideshow .slide');
                showMainSlide(mainSlideIndex);
                
                // تغییر خودکار اسلایدها
                if (mainSlides.length > 1) {
                    setInterval(nextMainSlide, 6000);
                }
            });
        </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- اسلایدشو اصلی -->
    <section id="home" class="relative text-white overflow-hidden" style="height: 80vh; min-height: 600px;">
        <!-- اسلایدشو -->
        <div id="mainSlideshow" class="slideshow-container" style="height: 100%; position: relative; overflow: hidden;">
            <asp:Repeater ID="rptMainSlideshow" runat="server">
                <ItemTemplate>
                    <div class="slide" style="position: absolute; top: 0; left: 0; width: 100%; height: 100%; opacity: 0; transition: opacity 1.5s ease-in-out;">
                        <img src='<%# Eval("ImageUrl") %>' alt='<%# Eval("Title") %>' style="width: 100%; height: 100%; object-fit: cover;" />
                        <div class="slide-overlay" style="position: absolute; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0,0,0,0.4);"></div>
                        <div class="slide-content" style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); text-align: center; z-index: 10; max-width: 800px; width: 90%;">
                            <h2 class="text-4xl md:text-6xl font-bold mb-6 leading-tight slide-title" style="text-shadow: 2px 2px 4px rgba(0,0,0,0.7);">
                                <%# Eval("Title") %>
                            </h2>
                            <p class="text-lg md:text-xl mb-8 text-gray-200 slide-description" style="text-shadow: 1px 1px 2px rgba(0,0,0,0.7);">
                                <%# Eval("Description") %>
                            </p>
                            <a href='<%# string.IsNullOrEmpty(Eval("Link").ToString()) ? "#" : Eval("Link") %>' class='bg-blue-600 hover:bg-blue-700 text-white font-bold py-3 px-8 rounded-lg transition duration-300 shadow-lg inline-block'>بیشتر بدانید</a>
                    </div>
                </div>
                </ItemTemplate>
            </asp:Repeater>
            

        </div>
        


        <!-- شکل موج پایین -->
        <div class="custom-shape-divider" style="position: absolute; bottom: 0; left: 0; width: 100%; z-index: 15;">
            <svg data-name="Layer 1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1200 120" preserveAspectRatio="none">
                <path d="M321.39,56.44c58-10.79,114.16-30.13,172-41.86,82.39-16.72,168.19-17.73,250.45-.39C823.78,31,906.67,72,985.66,92.83c70.05,18.48,146.53,26.09,214.34,3V0H0V27.35A600.21,600.21,0,0,0,321.39,56.44Z" class="shape-fill"></path>
            </svg>
        </div>
    </section>

    <!-- میانبرهای سریع (الهام از Tickets) -->
    <section class="py-10 site-gradient-dark">
        <div class="container mx-auto px-4">
            <h3 class="text-2xl font-extrabold mb-5">میانبرهای باشگاه</h3>
            <div class="carousel">
                <button type="button" class="carousel-arrow carousel-prev" onclick="this.nextElementSibling.scrollBy({left:-320,behavior:'smooth'})">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path d="M15 18L9 12L15 6" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                    </svg>
                </button>
                <div class="carousel-track">
                    <a href="/Competitions.aspx" class="quick-card card-hover">
                        <div class="tile"><h4>مسابقات</h4>
                            <div class="quick-illus">
                                <svg viewBox="0 0 120 90" xmlns="http://www.w3.org/2000/svg">
                                    <g transform="translate(24,16) rotate(25)">
                                        <rect x="0" y="20" width="12" height="50" rx="5" fill="#ef4444"/>
                                        <ellipse cx="6" cy="20" rx="24" ry="30" fill="#ef4444"/>
                                        <ellipse cx="6" cy="20" rx="18" ry="24" fill="#0b1226"/>
                                    </g>
                                    <g transform="translate(62,18) rotate(-20)">
                                        <rect x="0" y="20" width="12" height="50" rx="5" fill="#2563eb"/>
                                        <ellipse cx="6" cy="20" rx="24" ry="30" fill="#2563eb"/>
                                        <ellipse cx="6" cy="20" rx="18" ry="24" fill="#0b1226"/>
                                    </g>
                                    <circle cx="90" cy="46" r="6" fill="#fff"/>
                                </svg>
                            </div>
                        </div>
                    </a>
                    <a href="#fees" class="quick-card card-hover">
                        <div class="tile"><h4>شهریه دوره‌ها</h4>
                            <div class="quick-illus">
                                <svg viewBox="0 0 120 90" xmlns="http://www.w3.org/2000/svg">
                                    <rect x="18" y="50" width="84" height="28" rx="6" fill="#1e3a8a"/>
                                    <rect x="24" y="56" width="72" height="16" rx="3" fill="#3b82f6"/>
                                    <line x1="24" y1="64" x2="96" y2="64" stroke="#1e3a8a" stroke-width="3"/>
                                    <circle cx="44" cy="64" r="5" fill="#fff"/>
                                </svg>
                            </div>
                        </div>
                    </a>
                    <a href="/Store.aspx" class="quick-card card-hover">
                        <div class="tile"><h4>فروشگاه</h4>
                            <div class="quick-illus">
                                <svg viewBox="0 0 120 90" xmlns="http://www.w3.org/2000/svg">
                                    <g transform="translate(24,16) rotate(20)">
                                        <rect x="0" y="20" width="12" height="50" rx="5" fill="#22c55e"/>
                                        <ellipse cx="6" cy="20" rx="24" ry="30" fill="#22c55e"/>
                                        <ellipse cx="6" cy="20" rx="18" ry="24" fill="#0b1226"/>
                                    </g>
                                    <circle cx="88" cy="46" r="6" fill="#fff"/>
                                </svg>
                            </div>
                        </div>
                    </a>
                    <a href="#contact" class="quick-card card-hover">
                        <div class="tile"><h4>تماس با ما</h4>
                            <div class="quick-illus">
                                <svg viewBox="0 0 120 90" xmlns="http://www.w3.org/2000/svg">
                                    <rect x="18" y="50" width="84" height="28" rx="6" fill="#1e3a8a"/>
                                    <rect x="24" y="56" width="72" height="16" rx="3" fill="#3b82f6"/>
                                    <circle cx="92" cy="64" r="5" fill="#fff"/>
                                </svg>
                            </div>
                        </div>
                    </a>
                </div>
                <button type="button" class="carousel-arrow carousel-next" onclick="this.previousElementSibling.scrollBy({left:320,behavior:'smooth'})">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path d="M9 18L15 12L9 6" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                    </svg>
                </button>
            </div>
        </div>
    </section>

    <!-- بخش ویژگی‌ها -->
    <section class="py-16">
        <div class="container mx-auto px-4">
            <div class="text-center mb-12">
                <h2 class="text-3xl font-bold mb-4 text-blue-900">چرا باشگاه تنیس روی میز پردیس؟</h2>
                <p class="text-gray-600 max-w-2xl mx-auto">ما با ارائه بهترین خدمات و امکانات، محیطی حرفه‌ای برای رشد و پیشرفت شما فراهم کرده‌ایم</p>
            </div>

            <asp:Repeater ID="rptFeatures" runat="server">
                <HeaderTemplate><div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8"></HeaderTemplate>
                <ItemTemplate>
                <div class="bg-white p-6 rounded-xl shadow-md text-center hover:shadow-xl transition-all duration-300 border-t-4 border-<%# Eval("BorderColor") %>">
                    <div class="bg-<%# Eval("BackgroundColor") %> w-16 h-16 mx-auto rounded-full flex items-center justify-center mb-4">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8 text-<%# Eval("IconColor") %>" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="<%# Eval("IconPath") %>"></path>
                        </svg>
                    </div>
                    <h3 class="text-xl font-bold mb-2 text-blue-900"><%# Eval("Title") %></h3>
                    <p class="text-gray-600"><%# Eval("Description") %></p>
                </div>
                </ItemTemplate>
                <FooterTemplate></div></FooterTemplate>
            </asp:Repeater>
        </div>
    </section>
    <!-- بخش اخبار -->
    <section id="news" class="py-16 bg-gradient-to-br from-gray-100 to-blue-50">
        <div class="container mx-auto px-4">
            <div class="mb-4 flex items-center justify-between">
                <div>
                    <span class="inline-block bg-blue-100 text-blue-800 text-xs px-2 py-1 rounded mb-1">آخرین رویدادها</span>
                    <h2 class="section-title text-2xl md:text-3xl">اخبار و رویدادهای باشگاه</h2>
                </div>
                <a href="/News.aspx" class="text-blue-700 font-bold">مشاهده همه</a>
            </div>
            <div class="carousel">
                <button type="button" class="carousel-arrow carousel-prev" onclick="this.nextElementSibling.scrollBy({left:-320,behavior:'smooth'})">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path d="M15 18L9 12L15 6" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                    </svg>
                </button>
                <div class="carousel-track">
            <asp:Repeater ID="rptNews" runat="server">
                <ItemTemplate>
                            <a class="card-wide card-hover" href='<%# Eval("Id", "/NewsDetail.aspx?id={0}") %>'>
                                <img class="thumb" src="<%# Eval("ImageUrl") %>" alt=""/>
                                <div class="content">
                                    <div class="muted"><%# Eval("CreatedDate", "{0:yyyy/MM/dd}") %> · <%# Eval("Category") %></div>
                                    <div class="title mt-1"><%# Eval("Title") %></div>
                        </div>
                            </a>
                </ItemTemplate>
            </asp:Repeater>
                </div>
                <button type="button" class="carousel-arrow carousel-next" onclick="this.previousElementSibling.scrollBy({left:320,behavior:'smooth'})">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path d="M9 18L15 12L9 6" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                    </svg>
                </button>
            </div>
        </div>
    </section>

    <!-- بخش معرفی مربیان -->
    <section id="coaches" class="py-16 site-gradient-dark">
        <div class="container mx-auto px-4">
            <div class="mb-4 flex items-center justify-between">
                <div>
                    <span class="inline-block bg-white/20 text-white text-xs px-2 py-1 rounded mb-1">کادر آموزشی</span>
                    <h2 class="section-title text-2xl md:text-3xl text-white">مربیان حرفه‌ای ما</h2>
                </div>
                <div class="flex gap-2">
                    <button type="button" class="carousel-arrow carousel-prev" onclick="this.parentElement.previousElementSibling.querySelector('.carousel-track').scrollBy({left:-320,behavior:'smooth'})">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <path d="M15 18L9 12L15 6" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                        </svg>
                    </button>
                    <button type="button" class="carousel-arrow carousel-next" onclick="this.parentElement.previousElementSibling.querySelector('.carousel-track').scrollBy({left:320,behavior:'smooth'})">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <path d="M9 18L15 12L9 6" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                        </svg>
                    </button>
                </div>
            </div>

            <div class="carousel">
                <div class="carousel-track">
            <asp:Repeater ID="rptCoaches" runat="server">
                <ItemTemplate>
                            <div class="coach-modern card-hover">
                                <div class="coach-avatar">
                            <asp:Image ID="imgCoach" runat="server" ImageUrl='<%# Eval("ImageUrl") %>' CssClass="w-full h-full object-cover" />
                                    <div class="coach-number"><%# Container.ItemIndex + 1 %></div>
                        </div>
                                <div class="coach-info">
                                    <div class="coach-name"><%# Eval("Name") %></div>
                                    <div class="coach-role"><%# Eval("Position") %></div>
                                    <div class="coach-stats">
                                        <div class="stat">
                                            <div class="stat-value"><%# Eval("Experience") %></div>
                                            <div class="stat-label">سال سابقه</div>
                        </div>
                                        <div class="stat">
                                            <div class="stat-value"><%# Eval("Rating") %></div>
                                            <div class="stat-label">امتیاز</div>
                    </div>
                                        <div class="stat">
                                            <div class="stat-value"><%# Eval("Specialty") %></div>
                                            <div class="stat-label">تخصص</div>
                            </div>
                        </div>
                    </div>
                </div>
                </ItemTemplate>
            </asp:Repeater>
                </div>
            </div>
            
            <div class="pagination-dots">
                <div class="pagination-dot active"></div>
                <div class="pagination-dot"></div>
                <div class="pagination-dot"></div>
            </div>
        </div>
    </section>

    <!-- بخش گالری تصاویر -->
    <section id="gallery" class="py-16 site-gradient-dark">
        <div class="container mx-auto px-4">
            <div class="mb-4 flex items-center justify-between">
                <div>
                    <span class="inline-block bg-white/20 text-white text-xs px-2 py-1 rounded mb-1">لحظات ماندگار</span>
                    <h2 class="section-title text-2xl md:text-3xl">گالری تصاویر باشگاه</h2>
                </div>
                <a href="/Gallery.aspx" class="text-white font-bold">مشاهده همه</a>
            </div>
            <div class="carousel">
                <button type="button" class="carousel-arrow carousel-prev" onclick="this.nextElementSibling.scrollBy({left:-320,behavior:'smooth'})">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path d="M15 18L9 12L15 6" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                    </svg>
                </button>
                <div class="carousel-track">
            <asp:Repeater ID="rptGallery" runat="server">
                <ItemTemplate>
                            <div class="card-wide card-hover" style="background:#0d1b3a;color:#fff">
                                <img class="thumb" src="<%# Eval("ImageUrl") %>" alt=""/>
                                <div class="content">
                                    <div class="title"><%# Eval("Title") %></div>
                                    <div class="muted" style="color:#cbd5e1"><%# Eval("Description") %></div>
                    </div>
                </div>
                </ItemTemplate>
            </asp:Repeater>
                </div>
                <button type="button" class="carousel-arrow carousel-next" onclick="this.previousElementSibling.scrollBy({left:320,behavior:'smooth'})">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path d="M9 18L15 12L9 6" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                    </svg>
                </button>
            </div>
        </div>
    </section>

    <!-- بخش شهریه -->
    <section id="fees" class="py-16 bg-white">
        <div class="container mx-auto px-4">
            <div class="text-center mb-12">
                <span class="inline-block bg-blue-100 text-blue-800 text-sm px-3 py-1 rounded-full mb-2">هزینه‌ها</span>
                <h2 class="text-3xl font-bold mb-4 text-blue-900">شهریه دوره‌های آموزشی</h2>
                <p class="text-gray-600 max-w-2xl mx-auto">تعرفه‌های باشگاه تنیس روی میز پردیس برای دوره‌های مختلف آموزشی</p>
            </div>

            <div class="max-w-5xl mx-auto">
                <div class="bg-gradient-to-br from-blue-50 to-indigo-50 rounded-2xl shadow-lg overflow-hidden border border-blue-100">
                    <div class="bg-gradient-to-r from-blue-600 to-indigo-600 text-white py-6 px-6">
                        <h3 class="text-2xl font-bold">تعرفه‌های باشگاه تنیس روی میز پردیس</h3>
                        <p class="text-blue-100">قابل اجرا از تاریخ ۱ مرداد ۱۴۰۲</p>
                    </div>
                    <div class="p-6">
                        <div class="overflow-x-auto w-full">
                            <table class="min-w-max w-full text-right text-sm md:text-base">
                                <thead>
                                    <tr class="bg-blue-900 text-white">
                                        <th class="py-3 px-3 md:py-4 md:px-6 whitespace-nowrap rounded-tr-lg">نوع دوره</th>
                                        <th class="py-3 px-3 md:py-4 md:px-6 whitespace-nowrap">جلسات</th>
                                        <th class="py-3 px-3 md:py-4 md:px-6 whitespace-nowrap">شهریه (تومان)</th>
                                        <th class="py-3 px-3 md:py-4 md:px-6 whitespace-nowrap rounded-tl-lg">توضیحات</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <asp:Repeater ID="rptFees" runat="server">
                                        <ItemTemplate>
                                    <tr class="hover:bg-blue-50 border-b border-blue-100">
                                                <td class="py-3 px-3 md:py-4 md:px-6 font-medium whitespace-nowrap"><%# Eval("CourseName") %></td>
                                                <td class="py-3 px-3 md:py-4 md:px-6 whitespace-nowrap"><%# Eval("Sessions") %></td>
                                                <td class="py-3 px-3 md:py-4 md:px-6 font-bold text-blue-800 whitespace-nowrap"><%# Eval("Fee", "{0:N0}") %></td>
                                                <td class="py-3 px-3 md:py-4 md:px-6 whitespace-normal"><%# Eval("Description") %></td>
                                    </tr>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- بخش اطلاعیه‌ها -->
   <section id="announcements" class="py-16 bg-gradient-to-br from-blue-50 to-indigo-50">
        <div class="container mx-auto px-4">
            <div class="mb-4 flex items-center justify-between">
                <div>
                    <span class="inline-block bg-blue-100 text-blue-800 text-xs px-2 py-1 rounded mb-1">اطلاعیه‌های مهم</span>
                    <h2 class="section-title text-2xl md:text-3xl text-blue-900">اطلاعیه‌های باشگاه</h2>
                </div>
                <a href="/Announcements.aspx" class="text-blue-700 font-bold">مشاهده همه</a>
            </div>

            <div class="carousel">
                <button type="button" class="carousel-arrow carousel-prev" onclick="this.nextElementSibling.scrollBy({left:-320,behavior:'smooth'})">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path d="M15 18L9 12L15 6" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                    </svg>
                </button>
                <div class="carousel-track">
        <asp:Repeater ID="rptAnnouncements" runat="server">
            <ItemTemplate>
                            <div class="card-wide card-hover">
                                <div class="content">
                                    <div class="muted"><%# Eval("CreatedDate", "{0:yyyy/MM/dd}") %> · <%# (Convert.ToBoolean(Eval("IsActive"))?"فعال":"غیرفعال") %></div>
                                    <div class="title mt-1"><%# Eval("Title") %></div>
                                    <div class="mt-2" style="color:#334155"><%# Eval("Body") %></div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
                </div>
                <button type="button" class="carousel-arrow carousel-next" onclick="this.previousElementSibling.scrollBy({left:320,behavior:'smooth'})">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path d="M9 18L15 12L9 6" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
                </button>
            </div>
        </div>
    </section>

    <!-- بخش تماس با ما -->
    <section id="contact" class="py-16 bg-white">
        <div class="container mx-auto px-4">
            <div class="text-center mb-12">
                <span class="inline-block bg-blue-100 text-blue-800 text-sm px-3 py-1 rounded-full mb-2">ارتباط با ما</span>
                <h2 class="text-3xl font-bold mb-4 text-blue-900">تماس با باشگاه پردیس</h2>
                <p class="text-gray-600 max-w-2xl mx-auto">برای کسب اطلاعات بیشتر، رزرو کلاس یا هرگونه سوال با ما در ارتباط باشید</p>
            </div>

            <div class="max-w-6xl mx-auto">
                <div class="bg-gradient-to-br from-blue-50 to-indigo-50 rounded-2xl shadow-lg overflow-hidden">
                    <div class="grid grid-cols-1 md:grid-cols-2">
                        <div class="p-8 md:p-12">
                            <h3 class="text-2xl font-bold mb-6 text-blue-900">اطلاعات تماس</h3>
                            <div class="space-y-6">
                                <div class="flex items-start">
                                    <div class="bg-blue-100 rounded-full p-3 ml-4">
                                        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-blue-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"></path>
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"></path>
                                        </svg>
                                    </div>
                                    <div>
                                        <h4 class="font-bold text-blue-900">آدرس:</h4>
                                        <p class="text-gray-600"><asp:Literal ID="litContactAddress" runat="server" /></p>
                                    </div>
                                </div>

                                <div class="flex items-start">
                                    <div class="bg-blue-100 rounded-full p-3 ml-4">
                                        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-blue-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z"></path>
                                        </svg>
                                    </div>
                                    <div>
                                        <h4 class="font-bold text-blue-900">تلفن تماس:</h4>
                                        <p class="text-gray-600"><asp:Literal ID="litContactPhone" runat="server" /></p>
                                    </div>
                                </div>

                                <div class="flex items-start">
                                    <div class="bg-blue-100 rounded-full p-3 ml-4">
                                        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-blue-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"></path>
                                        </svg>
                                    </div>
                                    <div>
                                        <h4 class="font-bold text-blue-900">ایمیل:</h4>
                                        <p class="text-gray-600"><asp:Literal ID="litContactEmail" runat="server" /></p>
                                    </div>
                                </div>

                                <div class="flex items-start">
                                    <div class="bg-blue-100 rounded-full p-3 ml-4">
                                        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-blue-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                                        </svg>
                                    </div>
                                    <div>
                                        <h4 class="font-bold text-blue-900">ساعات کاری:</h4>
                                        <p class="text-gray-600">شنبه تا چهارشنبه: ۱۰ صبح تا ۱۰ شب</p>
                                        <p class="text-gray-600">پنجشنبه: ۹ صبح تا ۱۱ شب</p>
                                        <p class="text-gray-600">جمعه: ۱۰ صبح تا ۸ شب</p>
                                    </div>
                                </div>
                            </div>

                            <div class="mt-8">
                                <h3 class="text-xl font-bold mb-4 text-blue-900">ما را در شبکه‌های اجتماعی دنبال کنید</h3>
                                <div class="flex space-x-4 space-x-reverse">
                                    <a href="#" class="bg-blue-600 hover:bg-blue-700 h-10 w-10 rounded-full flex items-center justify-center transition-colors duration-300 text-white">
                                        <span class="text-xl">📱</span>
                                    </a>
                                    <a href="#" class="bg-pink-600 hover:bg-pink-700 h-10 w-10 rounded-full flex items-center justify-center transition-colors duration-300 text-white">
                                        <span class="text-xl">📷</span>
                                    </a>
                                    <a href="#" class="bg-blue-400 hover:bg-blue-500 h-10 w-10 rounded-full flex items-center justify-center transition-colors duration-300 text-white">
                                        <span class="text-xl">📧</span>
                                    </a>
                                    <a href="#" class="bg-red-600 hover:bg-red-700 h-10 w-10 rounded-full flex items-center justify-center transition-colors duration-300 text-white">
                                        <span class="text-xl">📺</span>
                                    </a>
                                </div>
                            </div>
                        </div>

                        <div class="bg-gradient-to-br from-blue-600 to-indigo-700 p-8 md:p-12 text-white">
                            <h3 class="text-2xl font-bold mb-6">فرم تماس با ما</h3>
                            <div class="space-y-4">
                                <div>
                                    <label class="block text-sm font-medium mb-2">نام و نام خانوادگی</label>
                                    <asp:TextBox ID="txtContactName" runat="server" CssClass="w-full px-4 py-3 rounded-lg bg-white bg-opacity-20 border border-blue-300 text-white focus:outline-none focus:ring-2 focus:ring-white" placeholder="نام خود را وارد کنید"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvCN" runat="server" ControlToValidate="txtContactName" ErrorMessage="نام الزامی است" CssClass="text-red-200 text-xs" Display="Dynamic" />
                                </div>
                                <div>
                                    <label class="block text-sm font-medium mb-2">شماره تماس</label>
                                    <asp:TextBox ID="txtContactPhone" runat="server" CssClass="w-full px-4 py-3 rounded-lg bg-white bg-opacity-20 border border-blue-300 text-white focus:outline-none focus:ring-2 focus:ring-white" placeholder="شماره تماس خود را وارد کنید"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvCP" runat="server" ControlToValidate="txtContactPhone" ErrorMessage="شماره تماس الزامی است" CssClass="text-red-200 text-xs" Display="Dynamic" />
                                </div>
                                <div>
                                    <label class="block text-sm font-medium mb-2">موضوع پیام</label>
                                    <asp:DropDownList ID="ddlContactSubject" runat="server" CssClass="w-full px-4 py-3 rounded-lg bg-white bg-opacity-20 border border-blue-300 text-white focus:outline-none focus:ring-2 focus:ring-white">
                                        <asp:ListItem Text="ثبت نام در کلاس‌ها" Value="ثبت نام در کلاس‌ها" />
                                        <asp:ListItem Text="سوال درباره شهریه" Value="سوال درباره شهریه" />
                                        <asp:ListItem Text="رزرو سالن" Value="رزرو سالن" />
                                        <asp:ListItem Text="سایر موارد" Value="سایر موارد" />
                                    </asp:DropDownList>
                                </div>
                                <div>
                                    <label class="block text-sm font-medium mb-2">متن پیام</label>
                                    <asp:TextBox ID="txtContactBody" runat="server" TextMode="MultiLine" Rows="4" CssClass="w-full px-4 py-3 rounded-lg bg-white bg-opacity-20 border border-blue-300 text-white focus:outline-none focus:ring-2 focus:ring-white" placeholder="پیام خود را بنویسید"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvCB" runat="server" ControlToValidate="txtContactBody" ErrorMessage="متن پیام الزامی است" CssClass="text-red-200 text-xs" Display="Dynamic" />
                                </div>
                                <div>
                                    <asp:Button ID="btnContactSubmit" runat="server" Text="ارسال پیام" CssClass="w-full bg-white hover:bg-blue-50 text-blue-800 font-bold py-3 px-6 rounded-lg transition duration-300 shadow-lg" OnClick="btnContactSubmit_Click" />
                                </div>
                                <asp:Literal ID="litContactResult" runat="server" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</asp:Content>

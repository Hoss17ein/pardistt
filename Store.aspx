<%@ Page Title="فروشگاه" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeFile="Store.aspx.cs" Inherits="Pardis.Store" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <meta name="robots" content="noindex" />
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
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
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Store Hero with Banner Carousel -->
    <section class="site-gradient-dark py-10">
        <div class="container mx-auto px-4">
            <div class="mb-6">
                <span class="inline-block bg-white/15 text-white text-xs px-2 py-1 rounded mb-2">فروشگاه رسمی</span>
                <h1 class="text-3xl md:text-4xl font-extrabold text-white">به فروشگاه پردیس خوش آمدید</h1>
                <p class="text-blue-200 mt-2">راکت، رویه، توپ، میز و لوازم جانبی با ارسال سریع.</p>
                <div class="mt-4 flex gap-3">
                    <a href="#cats" class="btn-secondary">دسته‌بندی‌ها</a>
                    <a href="/Cart.aspx" class="btn-primary">مشاهده سبد</a>
                </div>
            </div>

                <div class="relative">
                <button type="button" class="carousel-arrow carousel-prev" onclick="this.nextElementSibling.scrollBy({left:-600,behavior:'smooth'})">‹</button>
                <div class="carousel-track" style="scroll-snap-type:x mandatory;">
                    <asp:Repeater ID="rptStoreBanners" runat="server">
                        <ItemTemplate>
                            <a href="<%# string.IsNullOrEmpty(Convert.ToString(Eval("LinkUrl")))?"#":Convert.ToString(Eval("LinkUrl")) %>" class="block w-full min-w-full">
                                <div class="relative rounded-2xl overflow-hidden" style="height: 220px;">
                                    <img src="<%# Eval("ImageUrl") %>" alt="" class="w-full h-full object-cover" />
                                    <div class="absolute inset-0 bg-gradient-to-t from-black/50 to-transparent"></div>
                                    <div class="absolute bottom-0 right-0 p-4 text-white">
                                        <div class="text-lg font-bold"><%# Eval("Title") %></div>
                    </div>
                </div>
                            </a>
                        </ItemTemplate>
                    </asp:Repeater>
            </div>
                <button type="button" class="carousel-arrow carousel-next" onclick="this.previousElementSibling.scrollBy({left:600,behavior:'smooth'})">›</button>
        </div>
        </div>
    </section>

            <!-- Categories Landing -->
        <asp:Panel ID="pnlCategories" runat="server">
            <div id="cats" class="container mx-auto px-4 grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4 my-8">
                <a href="/Store.aspx?cat=Tables" class="category-tile relative rounded-xl overflow-hidden bg-gradient-to-br from-blue-600 to-indigo-700 p-6 text-white">
                    <div class="text-xl font-bold">میز پینگ‌پنگ</div>
                    <div class="text-white/80 text-sm mt-1">جدیدترین مدل‌ها</div>
                    <span class="absolute left-4 bottom-4 text-sm">خرید</span>
                    <div class="illus">
                        <svg viewBox="0 0 160 120" xmlns="http://www.w3.org/2000/svg">
                            <rect x="20" y="50" width="120" height="60" rx="6" fill="#1e3a8a"/>
                            <rect x="26" y="56" width="108" height="48" rx="3" fill="#3b82f6"/>
                            <line x1="26" y1="80" x2="134" y2="80" stroke="#1e3a8a" stroke-width="4"/>
                            <rect x="78" y="56" width="4" height="48" fill="#1e3a8a"/>
                            <circle cx="64" cy="74" r="6" fill="#fff"/>
                        </svg>
                    </div>
                </a>
                <a href="/Store.aspx?cat=Blades" class="category-tile relative rounded-xl overflow-hidden bg-gradient-to-br from-blue-600 to-indigo-700 p-6 text-white">
                    <div class="text-xl font-bold">انواع چوب راکت</div>
                    <div class="text-white/80 text-sm mt-1">برندهای تخصصی</div>
                    <span class="absolute left-4 bottom-4 text-sm">خرید</span>
                    <div class="illus">
                        <svg viewBox="0 0 160 120" xmlns="http://www.w3.org/2000/svg">
                            <g transform="translate(50,20) rotate(25)">
                                <rect x="0" y="20" width="14" height="60" rx="5" fill="#ef4444"/>
                                <ellipse cx="7" cy="20" rx="28" ry="36" fill="#ef4444"/>
                                <ellipse cx="7" cy="20" rx="22" ry="30" fill="#111827"/>
                            </g>
                            <g transform="translate(90,26) rotate(-20)">
                                <rect x="0" y="20" width="14" height="60" rx="5" fill="#2563eb"/>
                                <ellipse cx="7" cy="20" rx="28" ry="36" fill="#2563eb"/>
                                <ellipse cx="7" cy="20" rx="22" ry="30" fill="#0b1226"/>
                            </g>
                            <circle cx="80" cy="64" r="7" fill="#fff"/>
                        </svg>
                    </div>
                </a>
                <a href="/Store.aspx?cat=ReadyRackets" class="category-tile relative rounded-xl overflow-hidden bg-gradient-to-br from-blue-600 to-indigo-700 p-6 text-white">
                    <div class="text-xl font-bold">راکت آماده</div>
                    <div class="text-white/80 text-sm mt-1">راحت و آماده بازی</div>
                    <span class="absolute left-4 bottom-4 text-sm">خرید</span>
                    <div class="illus">
                        <svg viewBox="0 0 160 120" xmlns="http://www.w3.org/2000/svg">
                            <g transform="translate(60,24) rotate(15)">
                                <rect x="0" y="20" width="14" height="60" rx="5" fill="#22c55e"/>
                                <ellipse cx="7" cy="20" rx="28" ry="36" fill="#22c55e"/>
                                <ellipse cx="7" cy="20" rx="22" ry="30" fill="#0b1226"/>
                            </g>
                            <circle cx="92" cy="64" r="7" fill="#fff"/>
                        </svg>
                    </div>
                </a>
                <a href="/Store.aspx?cat=Balls" class="category-tile relative rounded-xl overflow-hidden bg-gradient-to-br from-blue-600 to-indigo-700 p-6 text-white">
                    <div class="text-xl font-bold">انواع توپ</div>
                    <div class="text-white/80 text-sm mt-1">رده‌های مختلف</div>
                    <span class="absolute left-4 bottom-4 text-sm">خرید</span>
                    <div class="illus">
                        <svg viewBox="0 0 160 120" xmlns="http://www.w3.org/2000/svg">
                            <circle cx="110" cy="80" r="18" fill="#fff"/>
                        </svg>
                    </div>
                </a>
                <a href="/Store.aspx?cat=Rubbers" class="category-tile relative rounded-xl overflow-hidden bg-gradient-to-br from-blue-600 to-indigo-700 p-6 text-white">
                    <div class="text-xl font-bold">رویه راکت</div>
                    <div class="text-white/80 text-sm mt-1">حرفه‌ای و خوش‌چسب</div>
                    <span class="absolute left-4 bottom-4 text-sm">خرید</span>
                    <div class="illus">
                        <svg viewBox="0 0 160 120" xmlns="http://www.w3.org/2000/svg">
                            <rect x="30" y="70" width="100" height="10" rx="5" fill="#ef4444"/>
                        </svg>
                    </div>
                </a>
                <a href="/Store.aspx?cat=Accessories" class="category-tile relative rounded-xl overflow-hidden bg-gradient-to-br from-blue-600 to-indigo-700 p-6 text-white">
                    <div class="text-xl font-bold">لوازم جانبی</div>
                    <div class="text-white/80 text-sm mt-1">چسب، کاور، ...</div>
                    <span class="absolute left-4 bottom-4 text-sm">خرید</span>
                    <div class="illus">
                        <svg viewBox="0 0 160 120" xmlns="http://www.w3.org/2000/svg">
                            <rect x="30" y="70" width="26" height="10" rx="3" fill="#64748b"/>
                            <rect x="60" y="70" width="26" height="10" rx="3" fill="#64748b"/>
                            <rect x="90" y="70" width="26" height="10" rx="3" fill="#64748b"/>
                        </svg>
                    </div>
                </a>
                <a href="/Store.aspx?cat=Clothing" class="category-tile relative rounded-xl overflow-hidden bg-gradient-to-br from-blue-600 to-indigo-700 p-6 text-white">
                    <div class="text-xl font-bold">پوشاک</div>
                    <div class="text-white/80 text-sm mt-1">تیشرت، شلوارک، ...</div>
                    <span class="absolute left-4 bottom-4 text-sm">خرید</span>
                    <div class="illus">
                        <svg viewBox="0 0 160 120" xmlns="http://www.w3.org/2000/svg">
                            <path d="M60 40 L80 30 L100 40 L108 60 L108 90 L52 90 L52 60 Z" fill="#60a5fa"/>
                        </svg>
                    </div>
                </a>
                <a href="/Store.aspx?cat=all" class="category-tile relative rounded-xl overflow-hidden bg-gradient-to-br from-blue-600 to-indigo-700 p-6 text-white">
                    <div class="text-xl font-bold">همه محصولات</div>
                    <div class="text-white/80 text-sm mt-1">مشاهده لیست کامل</div>
                    <span class="absolute left-4 bottom-4 text-sm">مشاهده</span>
                    <div class="illus">
                        <svg viewBox="0 0 160 120" xmlns="http://www.w3.org/2000/svg">
                            <circle cx="30" cy="90" r="6" fill="#fff"/>
                            <circle cx="46" cy="90" r="6" fill="#fff"/>
                            <circle cx="62" cy="90" r="6" fill="#fff"/>
                            <circle cx="78" cy="90" r="6" fill="#fff"/>
                        </svg>
                    </div>
                </a>
            </div>
        </asp:Panel>

        <asp:Panel ID="pnlProducts" runat="server">
            <div class="container mx-auto px-4 py-8">
            <asp:Repeater ID="rptProducts" runat="server">
                <HeaderTemplate>
                        <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
                </HeaderTemplate>
                <ItemTemplate>
                        <div class="product-card card-hover">
                            <a href='<%# Eval("Id", "/Product.aspx?id={0}") %>'>
                                <asp:Image ID="img" runat="server" ImageUrl='<%# Eval("ImageUrl") %>' CssClass="product-thumb" />
                            </a>
                            <div class="product-body">
                                <a href='<%# Eval("Id", "/Product.aspx?id={0}") %>' class="product-title text-sm"><%# Eval("Name") %></a>
                                <div class="product-price"><%# Eval("Price", "{0:N0}") %> تومان</div>
                                <div class="product-actions">
                                    <asp:Button ID="btnAddToCart" runat="server" Text="افزودن" CssClass="btn-primary" CommandName="add" CommandArgument='<%# Eval("Id") %>' />
                                    <a class="btn-secondary" href='<%# Eval("Id", "/Product.aspx?id={0}") %>'>جزئیات</a>
                        </div>
                            <asp:HiddenField ID="hfName" runat="server" Value='<%# Eval("Name") %>' />
                            <asp:HiddenField ID="hfPrice" runat="server" Value='<%# Eval("Price") %>' />
                            <asp:HiddenField ID="hfImg" runat="server" Value='<%# Eval("ImageUrl") %>' />
                        </div>
                    </div>
                </ItemTemplate>
                <FooterTemplate>
                    </div>
                </FooterTemplate>
            </asp:Repeater>
            </div>
        </asp:Panel>
    </section>
</asp:Content>



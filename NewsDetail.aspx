<%@ Page Title="جزئیات خبر" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeFile="NewsDetail.aspx.cs" Inherits="Pardis.NewsDetailPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <section class="py-12">
        <div class="container mx-auto px-4">
            <div class="max-w-4xl mx-auto">
                <!-- Breadcrumb -->
                <nav class="mb-6">
                    <ol class="flex items-center space-x-2 text-sm text-gray-600">
                        <li><a href="/" class="hover:text-blue-600">خانه</a></li>
                        <li><span class="mx-2">›</span></li>
                        <li><a href="/News.aspx" class="hover:text-blue-600">اخبار</a></li>
                        <li><span class="mx-2">›</span></li>
                        <li class="text-blue-600"><asp:Literal ID="litBreadcrumbTitle" runat="server" /></li>
                    </ol>
                </nav>

                <!-- خبر اصلی -->
                <article class="bg-white rounded-xl shadow-lg overflow-hidden">
                    <!-- تصویر خبر -->
                    <div class="relative h-64 md:h-96 bg-gray-100">
                        <asp:Image ID="imgNews" runat="server" CssClass="w-full h-full object-cover" />
                        <div class="absolute top-4 right-4">
                            <span class="bg-blue-600 text-white px-3 py-1 rounded-full text-sm font-medium">
                                <asp:Literal ID="litCategory" runat="server" />
                            </span>
                        </div>
                    </div>

                    <!-- محتوای خبر -->
                    <div class="p-6 md:p-8">
                        <!-- عنوان و تاریخ -->
                        <div class="mb-6">
                            <h1 class="text-2xl md:text-3xl font-bold text-blue-900 mb-4">
                                <asp:Literal ID="litTitle" runat="server" />
                            </h1>
                            <div class="flex items-center text-gray-500 text-sm">
                                <i class="fas fa-calendar-alt ml-2"></i>
                                <span><asp:Literal ID="litDate" runat="server" /></span>
                                <span class="mx-3">•</span>
                                <i class="fas fa-user ml-2"></i>
                                <span>تیم تحریریه</span>
                            </div>
                        </div>

                        <!-- خلاصه خبر -->
                        <div class="bg-blue-50 border-r-4 border-blue-500 p-4 mb-6">
                            <p class="text-blue-800 font-medium">
                                <asp:Literal ID="litSummary" runat="server" />
                            </p>
                        </div>

                        <!-- محتوای کامل -->
                        <div class="prose prose-lg max-w-none">
                            <asp:Literal ID="litContent" runat="server" />
                        </div>

                        <!-- تگ‌ها -->
                        <div class="mt-8 pt-6 border-t border-gray-200">
                            <div class="flex items-center">
                                <span class="text-gray-600 ml-3">برچسب‌ها:</span>
                                <div class="flex flex-wrap gap-2">
                                    <span class="bg-gray-100 text-gray-700 px-3 py-1 rounded-full text-sm">
                                        <asp:Literal ID="litCategoryTag" runat="server" />
                                    </span>
                                    <span class="bg-gray-100 text-gray-700 px-3 py-1 rounded-full text-sm">تنیس روی میز</span>
                                    <span class="bg-gray-100 text-gray-700 px-3 py-1 rounded-full text-sm">باشگاه پردیس</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </article>

                <!-- اخبار مرتبط -->
                <div class="mt-12">
                    <h2 class="text-xl font-bold text-blue-900 mb-6">اخبار مرتبط</h2>
                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                        <asp:Repeater ID="rptRelatedNews" runat="server">
                            <ItemTemplate>
                                <article class="bg-white rounded-lg shadow overflow-hidden hover:shadow-lg transition-shadow">
                                    <div class="h-40 bg-gray-100">
                                        <img src='<%# Eval("ImageUrl") %>' alt='<%# Eval("Title") %>' class="w-full h-full object-cover" />
                                    </div>
                                    <div class="p-4">
                                        <div class="flex items-center justify-between text-xs text-gray-500 mb-2">
                                            <span><%# Eval("Category") %></span>
                                            <span><%# Eval("CreatedDate", "{0:yyyy/MM/dd}") %></span>
                                        </div>
                                        <h3 class="font-bold text-blue-900 mb-2 text-sm line-clamp-2"><%# Eval("Title") %></h3>
                                        <p class="text-gray-600 text-xs mb-3 line-clamp-2"><%# Eval("Summary") %></p>
                                        <a href='<%# Eval("Id", "NewsDetail.aspx?id={0}") %>' class="text-blue-600 hover:text-blue-800 text-sm font-medium">ادامه مطلب</a>
                                    </div>
                                </article>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                </div>

                <!-- دکمه بازگشت -->
                <div class="mt-8 text-center">
                    <a href="/News.aspx" class="inline-flex items-center bg-blue-600 hover:bg-blue-700 text-white px-6 py-3 rounded-lg font-medium transition-colors">
                        <i class="fas fa-arrow-right ml-2"></i>
                        بازگشت به لیست اخبار
                    </a>
                </div>
            </div>
        </div>
    </section>

    <style>
        .line-clamp-2 {
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        
        .prose {
            line-height: 1.8;
        }
        
        .prose p {
            margin-bottom: 1rem;
        }
        
        .prose h2, .prose h3, .prose h4 {
            color: #1e3a8a;
            font-weight: bold;
            margin-top: 1.5rem;
            margin-bottom: 0.75rem;
        }
        
        .prose ul, .prose ol {
            margin-left: 1.5rem;
            margin-bottom: 1rem;
        }
        
        .prose li {
            margin-bottom: 0.5rem;
        }
        
        .prose blockquote {
            border-right: 4px solid #3b82f6;
            padding-right: 1rem;
            margin: 1.5rem 0;
            font-style: italic;
            background-color: #f8fafc;
            padding: 1rem;
            border-radius: 0.5rem;
        }
    </style>
</asp:Content>

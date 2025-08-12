<%@ Page Title="داشبورد ادمین" Language="C#" MasterPageFile="~/admin/AdminMaster.Master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="shop1.Admin.AdminDefault" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="content-wrapper">
        <div class="content-header">
            <div class="container-fluid">
                <div class="row mb-2">
                    <div class="col-sm-6">
                        <h1 class="m-0">داشبورد</h1>
                    </div>
                </div>
            </div>
        </div>

        <section class="content">
            <div class="container-fluid">
                <!-- آمار کلی -->
                <div class="row">
                    <div class="col-lg-3 col-6">
                        <div class="small-box bg-info">
                            <div class="inner">
                                <h3>
                                    <asp:Literal ID="litNewsCount" runat="server">0</asp:Literal></h3>
                                <p>اخبار</p>
                            </div>
                            <div class="icon">
                                <i class="fas fa-newspaper"></i>
                            </div>
                            <a href="NewsAdmin.aspx" class="small-box-footer">مشاهده بیشتر <i class="fas fa-arrow-circle-left"></i>
                            </a>
                        </div>
                    </div>

                    <div class="col-lg-3 col-6">
                        <div class="small-box bg-success">
                            <div class="inner">
                                <h3>
                                    <asp:Literal ID="litCoachesCount" runat="server">0</asp:Literal></h3>
                                <p>مربیان</p>
                            </div>
                            <div class="icon">
                                <i class="fas fa-user-tie"></i>
                            </div>
                            <a href="CoachesAdmin.aspx" class="small-box-footer">مشاهده بیشتر <i class="fas fa-arrow-circle-left"></i>
                            </a>
                        </div>
                    </div>

                    <div class="col-lg-3 col-6">
                        <div class="small-box bg-warning">
                            <div class="inner">
                                <h3>
                                    <asp:Literal ID="litGalleryCount" runat="server">0</asp:Literal></h3>
                                <p>تصاویر گالری</p>
                            </div>
                            <div class="icon">
                                <i class="fas fa-images"></i>
                            </div>
                            <a href="GalleryAdmin.aspx" class="small-box-footer">مشاهده بیشتر <i class="fas fa-arrow-circle-left"></i>
                            </a>
                        </div>
                    </div>

                    <div class="col-lg-3 col-6">
                        <div class="small-box bg-danger">
                            <div class="inner">
                                <h3>
                                    <asp:Literal ID="litMessagesCount" runat="server">0</asp:Literal></h3>
                                <p>پیام‌های تماس</p>
                            </div>
                            <div class="icon">
                                <i class="fas fa-envelope"></i>
                            </div>
                            <a href="GenericTableAdmin.aspx?t=ContactMessages" class="small-box-footer">مشاهده بیشتر <i class="fas fa-arrow-circle-left"></i>
                            </a>
                        </div>
                    </div>
                    <!-- Features count -->
                    <div class="col-lg-3 col-6">
                        <div class="small-box bg-info">
                            <div class="inner">
                                <h3>
                                    <asp:Literal ID="litFeaturesCount" runat="server">0</asp:Literal></h3>
                                <p>ویژگی‌ها</p>
                            </div>
                            <div class="icon">
                                <i class="fas fa-star"></i>
                            </div>
                            <a href="FeaturesAdmin.aspx" class="small-box-footer">مدیریت ویژگی‌ها <i class="fas fa-arrow-circle-left"></i>
                            </a>
                        </div>
                    </div>
                </div>

                <!-- منوی دسترسی سریع -->
                <div class="row">
                    <div class="col-md-12">
                        <div class="card">
                            <div class="card-header">
                                <h3 class="card-title">دسترسی سریع</h3>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-3">
                                        <a href="GenericTableAdmin.aspx?t=HeaderSettings" class="btn btn-primary btn-block">
                                            <i class="fas fa-cogs"></i>تنظیمات سایت
                                        </a>
                                    </div>
                                    <div class="col-md-3">
                                        <a href="GenericTableAdmin.aspx?t=Menus" class="btn btn-info btn-block">
                                            <i class="fas fa-bars"></i>مدیریت منو
                                        </a>
                                    </div>
                                    <div class="col-md-3">
                                        <a href="GenericTableAdmin.aspx?t=[new]" class="btn btn-warning btn-block">
                                            <i class="fas fa-plus"></i>افزودن خبر
                                        </a>
                                    </div>
                                    <div class="col-md-3">
                                        <a href="GenericTableAdmin.aspx?t=ContactInfo" class="btn btn-success btn-block">
                                            <i class="fas fa-address-book"></i>اطلاعات تماس
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- آخرین اخبار -->
                <div class="row">
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-header">
                                <h3 class="card-title">آخرین اخبار</h3>
                            </div>
                            <div class="card-body">
                                <asp:Repeater ID="rptLatestNews" runat="server">
                                    <ItemTemplate>
                                        <div class="media mb-3">
                                            <div class="media-body">
                                                <h6 class="mt-0"><%# Eval("Title") %></h6>
                                                <small class="text-muted"><%# Eval("CreatedDate", "{0:yyyy/MM/dd}") %></small>
                                                <p class="mb-0"><%# Eval("Summary") %></p>
                                            </div>
                                        </div>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-header">
                                <h3 class="card-title">آخرین پیام‌ها</h3>
                            </div>
                            <div class="card-body">
                                <asp:Repeater ID="rptLatestMessages" runat="server">
                                    <ItemTemplate>
                                        <div class="media mb-3">
                                            <div class="media-body">
                                                <h6 class="mt-0"><%# Eval("Name") %></h6>
                                                <small class="text-muted"><%# Eval("CreatedDate", "{0:yyyy/MM/dd}") %></small>
                                                <p class="mb-0"><%# Eval("Subject") %></p>
                                            </div>
                                        </div>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </div>
</asp:Content>

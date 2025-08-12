<%@ Page Title="مدیریت اسلایدشو ادمین" Language="C#" MasterPageFile="~/admin/AdminMaster.Master" AutoEventWireup="true" CodeFile="AdminSlideshowAdmin.aspx.cs" Inherits="shop1.Admin.AdminSlideshowAdmin" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="content-wrapper">
        <div class="content-header">
            <div class="container-fluid">
                <div class="row mb-2">
                    <div class="col-sm-6">
                        <h1 class="m-0">مدیریت اسلایدشو صفحه ورود ادمین</h1>
                    </div>
                </div>
            </div>
        </div>

        <section class="content">
            <div class="container-fluid">
                <!-- فرم اضافه کردن تصویر جدید -->
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title">افزودن تصویر جدید</h3>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label>عنوان (اختیاری)</label>
                                    <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control" placeholder="عنوان تصویر"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label>توضیحات (اختیاری)</label>
                                    <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" placeholder="توضیحات تصویر"></asp:TextBox>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label>ترتیب نمایش</label>
                                    <asp:TextBox ID="txtSortOrder" runat="server" CssClass="form-control" TextMode="Number" Text="1"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label>وضعیت</label>
                                    <asp:CheckBox ID="chkIsActive" runat="server" Text="فعال" Checked="true" />
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label>انتخاب تصویر</label>
                                    <asp:FileUpload ID="fileUpload" runat="server" CssClass="form-control" accept="image/*" />
                                    <small class="form-text text-muted">فقط فایل‌های تصویری (JPG, PNG, GIF) تا حداکثر 5 مگابایت</small>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-12">
                                <asp:Button ID="btnAdd" runat="server" Text="افزودن تصویر" CssClass="btn btn-primary" OnClick="btnAdd_Click" />
                                <asp:Button ID="btnUpdate" runat="server" Text="بروزرسانی" CssClass="btn btn-success" Visible="false" OnClick="btnUpdate_Click" />
                                <asp:Button ID="btnCancel" runat="server" Text="انصراف" CssClass="btn btn-secondary" Visible="false" OnClick="btnCancel_Click" />
                                <asp:HiddenField ID="hdnEditId" runat="server" />
                            </div>
                        </div>
                    </div>
                </div>

                <!-- جدول تصاویر -->
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title">تصاویر اسلایدشو</h3>
                    </div>
                    <div class="card-body">
                        <asp:GridView ID="gvAdminSlideshow" runat="server" CssClass="table table-bordered table-striped" 
                                      AutoGenerateColumns="false" OnRowCommand="gvAdminSlideshow_RowCommand" 
                                      OnRowDeleting="gvAdminSlideshow_RowDeleting" DataKeyNames="Id">
                            <Columns>
                                <asp:BoundField DataField="Id" HeaderText="شناسه" />
                                <asp:TemplateField HeaderText="تصویر">
                                    <ItemTemplate>
                                        <img src='<%# Eval("ImageUrl") %>' alt="تصویر" style="width: 100px; height: 60px; object-fit: cover;" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="Title" HeaderText="عنوان" />
                                <asp:BoundField DataField="Description" HeaderText="توضیحات" />
                                <asp:BoundField DataField="SortOrder" HeaderText="ترتیب" />
                                <asp:CheckBoxField DataField="IsActive" HeaderText="فعال" />
                                <asp:BoundField DataField="CreatedDate" HeaderText="تاریخ ایجاد" DataFormatString="{0:yyyy/MM/dd}" />
                                <asp:TemplateField HeaderText="عملیات">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="lnkEdit" runat="server" CommandName="EditItem" CommandArgument='<%# Eval("Id") %>' 
                                                       CssClass="btn btn-sm btn-info">ویرایش</asp:LinkButton>
                                        <asp:LinkButton ID="lnkDelete" runat="server" CommandName="Delete" CommandArgument='<%# Eval("Id") %>' 
                                                       CssClass="btn btn-sm btn-danger" OnClientClick="return confirm('آیا از حذف این تصویر اطمینان دارید؟')">حذف</asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>

                <!-- پیش‌نمایش اسلایدشو -->
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title">پیش‌نمایش اسلایدشو</h3>
                    </div>
                    <div class="card-body">
                        <div id="adminSlideshowPreview" class="slideshow-container" style="height: 300px; position: relative; overflow: hidden; border-radius: 8px;">
                            <asp:Repeater ID="rptAdminSlideshowPreview" runat="server">
                                <ItemTemplate>
                                    <div class="slide" style="position: absolute; top: 0; left: 0; width: 100%; height: 100%; opacity: 0; transition: opacity 1.5s ease-in-out;">
                                        <img src='<%# Eval("ImageUrl") %>' alt='<%# Eval("Title") %>' style="width: 100%; height: 100%; object-fit: cover;" />
                                        <div class="slide-overlay" style="position: absolute; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0,0,0,0.3);"></div>
                                        <div class="slide-content" style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); text-align: center; z-index: 10; color: white;">
                                            <h3 style="text-shadow: 2px 2px 4px rgba(0,0,0,0.7);"><%# Eval("Title") %></h3>
                                            <p style="text-shadow: 1px 1px 2px rgba(0,0,0,0.7);"><%# Eval("Description") %></p>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                            
                                                         <!-- دکمه‌های کنترل -->
                             <button class="slide-btn prev" onclick="changeAdminSlide(-1)" style="left: 10px;">
                                 <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                                     <path d="M15 18L9 12L15 6" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                                 </svg>
                             </button>
                             <button class="slide-btn next" onclick="changeAdminSlide(1)" style="right: 10px;">
                                 <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                                     <path d="M9 18L15 12L9 6" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                                 </svg>
                             </button>
                        </div>
                        
                        <!-- نقاط کنترل -->
                        <div class="slide-dots" style="text-align: center; margin-top: 10px;">
                            <asp:Repeater ID="rptAdminSlideDots" runat="server">
                                <ItemTemplate>
                                    <span class="dot" onclick="currentAdminSlide(<%# Container.ItemIndex + 1 %>)"></span>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </div>

    <style>
        .slide-btn {
            cursor: pointer;
            position: absolute;
            top: 50%;
            width: 48px;
            height: 48px;
            margin-top: -24px;
            color: white;
            transition: all 0.3s ease;
            border-radius: 50%;
            user-select: none;
            background: rgba(0,0,0,0.7);
            border: 2px solid rgba(255,255,255,0.3);
            z-index: 25;
            display: flex;
            align-items: center;
            justify-content: center;
            backdrop-filter: blur(10px);
        }
        .slide-btn:hover {
            background-color: rgba(0,0,0,0.9);
            border-color: rgba(255,255,255,0.6);
            transform: scale(1.1);
        }
        .slide-btn svg {
            width: 20px;
            height: 20px;
        }
        .dot {
            cursor: pointer;
            height: 10px;
            width: 10px;
            margin: 0 3px;
            background-color: rgba(255,255,255,0.5);
            border-radius: 50%;
            display: inline-block;
            transition: background-color 0.6s ease;
        }
        .dot.active, .dot:hover {
            background-color: #ffffff;
        }
    </style>

    <script>
        // اسلایدشو ادمین
        let adminSlideIndex = 1;
        let adminSlides = document.querySelectorAll('#adminSlideshowPreview .slide');
        let adminDots = document.querySelectorAll('#adminSlideshowPreview .dot');

        function showAdminSlides(n) {
            if (n > adminSlides.length) { adminSlideIndex = 1 }
            if (n < 1) { adminSlideIndex = adminSlides.length }

            for (let i = 0; i < adminSlides.length; i++) {
                adminSlides[i].style.opacity = "0";
            }
            for (let i = 0; i < adminDots.length; i++) {
                adminDots[i].className = adminDots[i].className.replace(" active", "");
            }

            if (adminSlides[adminSlideIndex - 1]) {
                adminSlides[adminSlideIndex - 1].style.opacity = "1";
            }
            if (adminDots[adminSlideIndex - 1]) {
                adminDots[adminSlideIndex - 1].className += " active";
            }
        }

        function changeAdminSlide(n) {
            showAdminSlides(adminSlideIndex += n);
        }

        function currentAdminSlide(n) {
            showAdminSlides(adminSlideIndex = n);
        }

        // نمایش اسلاید اول
        document.addEventListener('DOMContentLoaded', function() {
            showAdminSlides(adminSlideIndex);
            
            // تغییر خودکار اسلایدها
            setInterval(function() {
                changeAdminSlide(1);
            }, 5000);
        });
    </script>
</asp:Content>

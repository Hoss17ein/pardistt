<%@ Page Title="مدیریت اسلایدشو" Language="C#" MasterPageFile="~/admin/AdminMaster.Master" AutoEventWireup="true" CodeFile="SlideshowAdmin.aspx.cs" Inherits="shop1.Admin.SlideshowAdmin" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="content-wrapper">
        <div class="content-header">
            <div class="container-fluid">
                <div class="row mb-2">
                    <div class="col-sm-6">
                        <h1 class="m-0">مدیریت اسلایدشو</h1>
                    </div>
                </div>
            </div>
        </div>

        <section class="content">
            <div class="container-fluid">
                <!-- افزودن تصویر جدید -->
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title">افزودن تصویر جدید</h3>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label>عنوان تصویر:</label>
                                    <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control" placeholder="عنوان تصویر را وارد کنید"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvTitle" runat="server" ControlToValidate="txtTitle" ErrorMessage="عنوان الزامی است" CssClass="text-danger" Display="Dynamic" />
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label>توضیحات:</label>
                                    <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" placeholder="توضیحات تصویر (اختیاری)"></asp:TextBox>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label>تصویر:</label>
                                    <asp:FileUpload ID="fuImage" runat="server" CssClass="form-control" accept="image/*" />
                                    <asp:RequiredFieldValidator ID="rfvImage" runat="server" ControlToValidate="fuImage" ErrorMessage="انتخاب تصویر الزامی است" CssClass="text-danger" Display="Dynamic" />
                                    <small class="form-text text-muted">فرمت‌های مجاز: JPG, PNG, GIF - حداکثر اندازه: 2MB</small>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label>لینک (اختیاری):</label>
                                    <asp:TextBox ID="txtLink" runat="server" CssClass="form-control" placeholder="لینک مورد نظر (اختیاری)"></asp:TextBox>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label>ترتیب نمایش:</label>
                                    <asp:TextBox ID="txtSortOrder" runat="server" CssClass="form-control" TextMode="Number" Text="1"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label>وضعیت:</label>
                                    <asp:CheckBox ID="chkIsActive" runat="server" Text="فعال" Checked="true" CssClass="form-check-input" />
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <asp:Button ID="btnAdd" runat="server" Text="افزودن تصویر" CssClass="btn btn-primary" OnClick="btnAdd_Click" />
                            <asp:Button ID="btnUpdate" runat="server" Text="بروزرسانی" CssClass="btn btn-success" Visible="false" OnClick="btnUpdate_Click" />
                            <asp:Button ID="btnCancel" runat="server" Text="انصراف" CssClass="btn btn-secondary" Visible="false" OnClick="btnCancel_Click" />
                        </div>
                        <asp:Literal ID="litMessage" runat="server" />
                    </div>
                </div>

                <!-- لیست تصاویر -->
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title">تصاویر اسلایدشو</h3>
                    </div>
                    <div class="card-body">
                        <asp:GridView ID="gvSlideshow" runat="server" CssClass="table table-bordered table-striped" 
                                      AutoGenerateColumns="false" OnRowCommand="gvSlideshow_RowCommand"
                                      OnRowDeleting="gvSlideshow_RowDeleting" DataKeyNames="Id">
                            <Columns>
                                <asp:BoundField DataField="Id" HeaderText="شناسه" />
                                <asp:TemplateField HeaderText="تصویر">
                                    <ItemTemplate>
                                        <img src='<%# Eval("ImageUrl") %>' alt='<%# Eval("Title") %>' style="width: 100px; height: 60px; object-fit: cover;" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="Title" HeaderText="عنوان" />
                                <asp:BoundField DataField="Description" HeaderText="توضیحات" />
                                <asp:BoundField DataField="Link" HeaderText="لینک" />
                                <asp:BoundField DataField="SortOrder" HeaderText="ترتیب" />
                                <asp:CheckBoxField DataField="IsActive" HeaderText="فعال" />
                                <asp:BoundField DataField="CreatedDate" HeaderText="تاریخ ایجاد" DataFormatString="{0:yyyy/MM/dd}" />
                                <asp:TemplateField HeaderText="عملیات">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="lnkEdit" runat="server" CommandName="EditItem" CommandArgument='<%# Eval("Id") %>' 
                                                       CssClass="btn btn-sm btn-info" Text="ویرایش" />
                                        <asp:LinkButton ID="lnkDelete" runat="server" CommandName="Delete" CommandArgument='<%# Eval("Id") %>' 
                                                       CssClass="btn btn-sm btn-danger" Text="حذف" 
                                                       OnClientClick="return confirm('آیا از حذف این تصویر اطمینان دارید؟');" />
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
                        <div id="slideshowPreview" class="slideshow-container" style="height: 400px; position: relative; overflow: hidden; border-radius: 8px;">
                            <asp:Repeater ID="rptSlideshowPreview" runat="server">
                                <ItemTemplate>
                                    <div class="slide" style="position: absolute; top: 0; left: 0; width: 100%; height: 100%; opacity: 0; transition: opacity 1s ease-in-out;">
                                        <img src='<%# Eval("ImageUrl") %>' alt='<%# Eval("Title") %>' style="width: 100%; height: 100%; object-fit: cover;" />
                                        <div class="slide-content" style="position: absolute; bottom: 0; left: 0; right: 0; background: rgba(0,0,0,0.7); color: white; padding: 20px;">
                                            <h3><%# Eval("Title") %></h3>
                                            <p><%# Eval("Description") %></p>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                            <button class="slide-btn prev" onclick="changeSlide(-1)">
                                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                                    <path d="M15 18L9 12L15 6" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                                </svg>
                            </button>
                            <button class="slide-btn next" onclick="changeSlide(1)">
                                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                                    <path d="M9 18L15 12L9 6" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                                </svg>
                            </button>
                        </div>
                        <div class="slide-dots" style="text-align: center; margin-top: 10px;">
                            <asp:Repeater ID="rptSlideDots" runat="server">
                                <ItemTemplate>
                                    <span class="dot" onclick="currentSlide(<%# Container.ItemIndex + 1 %>)"></span>
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
        .slide-btn.prev {
            left: 10px;
        }
        .slide-btn.next {
            right: 10px;
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
            height: 12px;
            width: 12px;
            margin: 0 4px;
            background-color: #bbb;
            border-radius: 50%;
            display: inline-block;
            transition: background-color 0.6s ease;
        }
        .dot.active, .dot:hover {
            background-color: #717171;
        }
    </style>

    <script>
        let slideIndex = 1;
        let slides = document.querySelectorAll('.slide');
        let dots = document.querySelectorAll('.dot');

        function showSlides(n) {
            if (n > slides.length) { slideIndex = 1 }
            if (n < 1) { slideIndex = slides.length }

            for (let i = 0; i < slides.length; i++) {
                slides[i].style.opacity = "0";
            }
            for (let i = 0; i < dots.length; i++) {
                dots[i].className = dots[i].className.replace(" active", "");
            }

            if (slides[slideIndex - 1]) {
                slides[slideIndex - 1].style.opacity = "1";
            }
            if (dots[slideIndex - 1]) {
                dots[slideIndex - 1].className += " active";
            }
        }

        function changeSlide(n) {
            showSlides(slideIndex += n);
        }

        function currentSlide(n) {
            showSlides(slideIndex = n);
        }

        // نمایش اسلاید اول
        showSlides(slideIndex);

        // تغییر خودکار اسلایدها
        setInterval(function() {
            changeSlide(1);
        }, 5000);
    </script>
</asp:Content>

<%@ Page Title="مدیریت تنظیمات هدر" Language="C#" MasterPageFile="~/admin/AdminMaster.Master" AutoEventWireup="true" CodeFile="HeaderAdmin.aspx.cs" Inherits="shop1.Admin.HeaderAdmin" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="content-wrapper">
        <div class="content-header">
            <div class="container-fluid">
                <div class="row mb-2">
                    <div class="col-sm-6">
                        <h1 class="m-0">مدیریت تنظیمات هدر سایت</h1>
                    </div>
                </div>
            </div>
        </div>

        <section class="content">
            <div class="container-fluid">
                <div class="row">
                    <div class="col-md-8">
                        <div class="card card-primary">
                            <div class="card-header">
                                <h3 class="card-title">تنظیمات اصلی سایت</h3>
                            </div>
                            <div class="card-body">
                                <asp:HiddenField ID="hfSettingsId" runat="server" />
                                
                                <div class="form-group">
                                    <label>عنوان سایت</label>
                                    <asp:TextBox ID="txtSiteTitle" runat="server" CssClass="form-control" placeholder="عنوان اصلی سایت"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvSiteTitle" runat="server" ControlToValidate="txtSiteTitle" 
                                        ErrorMessage="عنوان سایت الزامی است" CssClass="text-danger" Display="Dynamic"></asp:RequiredFieldValidator>
                                    <small class="form-text text-muted">این عنوان در هدر سایت و فوتر نمایش داده می‌شود</small>
                                </div>

                                <div class="form-group">
                                    <label>لوگوی سایت</label>
                                    <asp:FileUpload ID="fuLogo" runat="server" CssClass="form-control-file" />
                                    <asp:Literal ID="litCurrentLogo" runat="server"></asp:Literal>
                                    <small class="form-text text-muted">فرمت‌های مجاز: JPG, PNG, GIF - اندازه پیشنهادی: 200x80 پیکسل</small>
                                </div>

                                <hr/>
                                <h5 class="mb-3">اطلاعات فوتر</h5>
                                <div class="form-group">
                                    <label>عنوان فوتر</label>
                                    <asp:TextBox ID="txtFooterTitle" runat="server" CssClass="form-control" placeholder="عنوان فوتر"></asp:TextBox>
                                </div>
                                <div class="form-group">
                                    <label>توضیحات فوتر</label>
                                    <asp:TextBox ID="txtFooterDescription" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3"></asp:TextBox>
                                </div>
                                <div class="form-group">
                                    <label>متن کپی‌رایت</label>
                                    <asp:TextBox ID="txtCopyright" runat="server" CssClass="form-control" placeholder="© ۱۴۰۲ ..."></asp:TextBox>
                                </div>

                                <div class="form-group">
                                    <label>توضیحات متا (Meta Description)</label>
                                    <asp:TextBox ID="txtMetaDescription" runat="server" CssClass="form-control" TextMode="MultiLine" 
                                        Rows="3" placeholder="توضیح کوتاهی از سایت برای موتورهای جستجو"></asp:TextBox>
                                    <small class="form-text text-muted">حداکثر 160 کاراکتر - برای SEO مهم است</small>
                                </div>

                                <div class="form-group">
                                    <label>کلمات کلیدی (Meta Keywords)</label>
                                    <asp:TextBox ID="txtMetaKeywords" runat="server" CssClass="form-control" 
                                        placeholder="کلمات کلیدی را با کاما جدا کنید"></asp:TextBox>
                                    <small class="form-text text-muted">مثال: تنیس روی میز، باشگاه ورزشی، پردیس، آموزش</small>
                                </div>

                                <div class="form-group">
                                    <asp:Button ID="btnSave" runat="server" Text="ذخیره تنظیمات" CssClass="btn btn-primary btn-lg" 
                                        OnClick="btnSave_Click" />
                                    <asp:Button ID="btnReset" runat="server" Text="بازنشانی" CssClass="btn btn-secondary" 
                                        OnClick="btnReset_Click" CausesValidation="false" />
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="card card-info">
                            <div class="card-header">
                                <h3 class="card-title">پیش‌نمایش</h3>
                            </div>
                            <div class="card-body">
                                <div class="preview-box border p-3 bg-light">
                                    <div class="d-flex align-items-center mb-3">
                                        <asp:Image ID="imgPreviewLogo" runat="server" CssClass="mr-3" style="max-height: 40px;" />
                                        <h5 class="mb-0">
                                            <asp:Literal ID="litPreviewTitle" runat="server">عنوان سایت</asp:Literal>
                                        </h5>
                                    </div>
                                    <hr>
                                    <small class="text-muted">
                                        <strong>توضیحات:</strong><br>
                                        <asp:Literal ID="litPreviewDescription" runat="server">توضیحات متا در اینجا نمایش داده می‌شود</asp:Literal>
                                    </small>
                                </div>
                                
                                <div class="mt-3">
                                    <h6>راهنمای تنظیمات:</h6>
                                    <ul class="list-unstyled small">
                                        <li><i class="fas fa-check text-success"></i> عنوان سایت در تمام صفحات نمایش داده می‌شود</li>
                                        <li><i class="fas fa-check text-success"></i> لوگو در هدر و فوتر سایت قرار می‌گیرد</li>
                                        <li><i class="fas fa-check text-success"></i> توضیحات متا برای SEO مهم است</li>
                                        <li><i class="fas fa-check text-success"></i> کلمات کلیدی به بهبود رتبه سایت کمک می‌کند</li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <!-- آمار سایت -->
                        <div class="card card-success">
                            <div class="card-header">
                                <h3 class="card-title">آمار سایت</h3>
                            </div>
                            <div class="card-body">
                                <div class="row text-center">
                                    <div class="col-6">
                                        <div class="border-right">
                                            <h4><asp:Literal ID="litTotalNews" runat="server">0</asp:Literal></h4>
                                            <small>اخبار</small>
                                        </div>
                                    </div>
                                    <div class="col-6">
                                        <h4><asp:Literal ID="litTotalCoaches" runat="server">0</asp:Literal></h4>
                                        <small>مربیان</small>
                                    </div>
                                </div>
                                <hr>
                                <div class="row text-center">
                                    <div class="col-6">
                                        <div class="border-right">
                                            <h4><asp:Literal ID="litTotalGallery" runat="server">0</asp:Literal></h4>
                                            <small>تصاویر</small>
                                        </div>
                                    </div>
                                    <div class="col-6">
                                        <h4><asp:Literal ID="litTotalMenus" runat="server">0</asp:Literal></h4>
                                        <small>منوها</small>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </div>

    <script>
        // پیش‌نمایش زنده
        function updatePreview() {
            var title = document.getElementById('<%= txtSiteTitle.ClientID %>').value;
            var description = document.getElementById('<%= txtMetaDescription.ClientID %>').value;
            
            document.getElementById('<%= litPreviewTitle.ClientID %>').innerText = title || 'عنوان سایت';
            document.getElementById('<%= litPreviewDescription.ClientID %>').innerText = description || 'توضیحات متا در اینجا نمایش داده می‌شود';
        }

        // اتصال رویدادها
        document.addEventListener('DOMContentLoaded', function() {
            document.getElementById('<%= txtSiteTitle.ClientID %>').addEventListener('input', updatePreview);
            document.getElementById('<%= txtMetaDescription.ClientID %>').addEventListener('input', updatePreview);
        });
    </script>
</asp:Content>

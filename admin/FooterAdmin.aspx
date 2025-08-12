<%@ Page Title="مدیریت فوتر" Language="C#" MasterPageFile="~/admin/AdminMaster.Master" AutoEventWireup="true" CodeFile="FooterAdmin.aspx.cs" Inherits="shop1.Admin.FooterAdmin" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="content-wrapper">
        <div class="content-header">
            <div class="container-fluid">
                <div class="row mb-2">
                    <div class="col-sm-6">
                        <h1 class="m-0">مدیریت فوتر سایت</h1>
                    </div>
                </div>
            </div>
        </div>

        <section class="content">
            <div class="container-fluid">
                <div class="row">
                    <!-- تنظیمات کلی فوتر -->
                    <div class="col-lg-6">
                        <div class="card card-primary">
                            <div class="card-header"><h3 class="card-title">تنظیمات کلی</h3></div>
                            <div class="card-body">
                                <div class="form-group">
                                    <label>لوگوی سایت</label>
                                    <asp:FileUpload ID="fuLogo" runat="server" CssClass="form-control-file" />
                                    <asp:Literal ID="litCurrentLogo" runat="server" />
                                </div>
                                <div class="form-group">
                                    <label>عنوان فوتر</label>
                                    <asp:TextBox ID="txtFooterTitle" runat="server" CssClass="form-control" />
                                </div>
                                <div class="form-group">
                                    <label>توضیحات فوتر</label>
                                    <asp:TextBox ID="txtFooterDescription" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" />
                                </div>
                                <div class="form-group">
                                    <label>متن کپی‌رایت</label>
                                    <asp:TextBox ID="txtCopyright" runat="server" CssClass="form-control" />
                                </div>
                                <asp:Button ID="btnSaveFooter" runat="server" Text="ذخیره" CssClass="btn btn-primary" OnClick="btnSaveFooter_Click" />
                            </div>
                        </div>
                    </div>

                    <!-- اطلاعات تماس -->
                    <div class="col-lg-6">
                        <div class="card card-info">
                            <div class="card-header"><h3 class="card-title">اطلاعات تماس</h3></div>
                            <div class="card-body">
                                <div class="form-group">
                                    <label>آدرس</label>
                                    <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control" />
                                </div>
                                <div class="form-group">
                                    <label>تلفن</label>
                                    <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" />
                                </div>
                                <div class="form-group">
                                    <label>ایمیل</label>
                                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" />
                                </div>
                                <asp:Button ID="btnSaveContact" runat="server" Text="ذخیره اطلاعات تماس" CssClass="btn btn-success" OnClick="btnSaveContact_Click" />
                            </div>
                        </div>
                    </div>

                </div>

                <div class="row">
                    <!-- لینک‌های سریع فوتر -->
                    <div class="col-lg-6">
                        <div class="card">
                            <div class="card-header d-flex justify-content-between align-items-center">
                                <h3 class="card-title">لینک‌های سریع فوتر (از منوها)</h3>
                                <a href="MenuAdmin.aspx" class="btn btn-sm btn-secondary">مدیریت منوها</a>
                            </div>
                            <div class="card-body">
                                <asp:GridView ID="gvFooterMenus" runat="server" CssClass="table table-bordered table-striped" AutoGenerateColumns="False" DataKeyNames="Id" OnRowCommand="gvFooterMenus_RowCommand">
                                    <Columns>
                                        <asp:BoundField DataField="Title" HeaderText="عنوان" />
                                        <asp:BoundField DataField="Url" HeaderText="لینک" />
                                        <asp:TemplateField HeaderText="نمایش در فوتر" ItemStyle-Width="120px" ItemStyle-CssClass="text-center">
                                            <ItemTemplate>
                                                <asp:Button ID="btnToggle" runat="server" Text='<%# (Convert.ToBoolean(Eval("ShowInFooter") ?? false) ? "غیرفعال" : "فعال") %>' CssClass='<%# (Convert.ToBoolean(Eval("ShowInFooter") ?? false) ? "btn btn-sm btn-danger" : "btn btn-sm btn-success") %>' CommandName="ToggleFooter" CommandArgument='<%# Eval("Id") %>' />
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                            </div>
                        </div>
                    </div>

                    <!-- شبکه‌های اجتماعی -->
                    <div class="col-lg-6">
                        <div class="card">
                            <div class="card-header d-flex justify-content-between align-items-center">
                                <h3 class="card-title">شبکه‌های اجتماعی</h3>
                                <a href="SocialLinksAdmin.aspx" class="btn btn-sm btn-primary">مدیریت پیشرفته</a>
                            </div>
                            <div class="card-body">
                                <asp:GridView ID="gvSocial" runat="server" CssClass="table table-bordered table-striped" AutoGenerateColumns="False" DataKeyNames="Id" OnRowCommand="gvSocial_RowCommand">
                                    <Columns>
                                        <asp:BoundField DataField="Url" HeaderText="لینک" />
                                        <asp:BoundField DataField="IconClass" HeaderText="کلاس آیکن" />
                                        <asp:TemplateField HeaderText="عملیات">
                                            <ItemTemplate>
                                                <asp:Button ID="btnEdit" runat="server" Text="ویرایش" CssClass="btn btn-sm btn-warning" CommandName="EditRow" CommandArgument='<%# Eval("Id") %>' />
                                                <asp:Button ID="btnDelete" runat="server" Text="حذف" CssClass="btn btn-sm btn-danger" CommandName="DeleteRow" CommandArgument='<%# Eval("Id") %>' OnClientClick="return confirm('حذف شود؟');" />
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </section>
    </div>
</asp:Content>


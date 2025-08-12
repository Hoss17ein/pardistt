<%@ Page Title="مدیریت منوها" Language="C#" MasterPageFile="~/admin/AdminMaster.Master" AutoEventWireup="true" CodeFile="MenuAdmin.aspx.cs" Inherits="shop1.Admin.MenuAdmin" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="content-wrapper">
        <div class="content-header">
            <div class="container-fluid">
                <div class="row mb-2">
                    <div class="col-sm-6">
                        <h1 class="m-0">مدیریت منوهای سایت</h1>
                    </div>
                </div>
            </div>
        </div>

        <section class="content">
            <div class="container-fluid">
                <div class="row">
                    <!-- فرم افزودن/ویرایش منو -->
                    <div class="col-md-4">
                        <div class="card card-primary">
                            <div class="card-header">
                                <h3 class="card-title">
                                    <asp:Literal ID="litFormTitle" runat="server">افزودن منوی جدید</asp:Literal>
                                </h3>
                            </div>
                            <div class="card-body">
                                <asp:HiddenField ID="hfMenuId" runat="server" />
                                
                                <div class="form-group">
                                    <label>عنوان منو</label>
                                    <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control" placeholder="عنوان منو"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvTitle" runat="server" ControlToValidate="txtTitle" 
                                        ErrorMessage="عنوان منو الزامی است" CssClass="text-danger" Display="Dynamic"></asp:RequiredFieldValidator>
                                </div>

                                <div class="form-group">
                                    <label>آدرس لینک</label>
                                    <asp:TextBox ID="txtUrl" runat="server" CssClass="form-control" placeholder="مثال: #home یا Default.aspx"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvUrl" runat="server" ControlToValidate="txtUrl" 
                                        ErrorMessage="آدرس لینک الزامی است" CssClass="text-danger" Display="Dynamic"></asp:RequiredFieldValidator>
                                    <small class="form-text text-muted">برای لینک داخلی از # استفاده کنید (مثل #home)</small>
                                </div>

                                <div class="form-group">
                                    <label>ترتیب نمایش</label>
                                    <asp:TextBox ID="txtSortOrder" runat="server" CssClass="form-control" placeholder="1" TextMode="Number"></asp:TextBox>
                                    <small class="form-text text-muted">عدد کمتر = نمایش زودتر</small>
                                </div>

                                <div class="form-group">
                                    <label>منوی والد</label>
                                    <asp:DropDownList ID="ddlParentMenu" runat="server" CssClass="form-control">
                                        <asp:ListItem Value="">منوی اصلی (بدون والد)</asp:ListItem>
                                    </asp:DropDownList>
                                    <small class="form-text text-muted">برای ایجاد زیرمنو، منوی والد را انتخاب کنید</small>
                                </div>

                                <div class="form-group">
                                    <div class="custom-control custom-checkbox">
                                        <asp:CheckBox ID="chkIsActive" runat="server" CssClass="custom-control-input" Checked="true" />
                                        <label class="custom-control-label" for="<%= chkIsActive.ClientID %>">فعال</label>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <asp:Button ID="btnSave" runat="server" Text="ذخیره" CssClass="btn btn-primary" 
                                        OnClick="btnSave_Click" />
                                    <asp:Button ID="btnCancel" runat="server" Text="انصراف" CssClass="btn btn-secondary" 
                                        OnClick="btnCancel_Click" CausesValidation="false" />
                                </div>
                            </div>
                        </div>

                        <!-- راهنمای سریع -->
                        <div class="card card-info">
                            <div class="card-header">
                                <h3 class="card-title">راهنمای سریع</h3>
                            </div>
                            <div class="card-body">
                                <small>
                                    <strong>نمونه‌هایی از آدرس لینک:</strong><br>
                                    • <code>#home</code> - لینک به بخش خانه<br>
                                    • <code>#about</code> - لینک به درباره ما<br>
                                    • <code>#contact</code> - لینک به تماس با ما<br>
                                    • <code>Default.aspx</code> - لینک به صفحه اصلی<br>
                                    • <code>http://example.com</code> - لینک خارجی<br><br>
                                    
                                    <strong>نکات:</strong><br>
                                    • ترتیب نمایش با عدد کنترل می‌شود<br>
                                    • منوهای غیرفعال نمایش داده نمی‌شوند<br>
                                    • زیرمنو با انتخاب منوی والد ایجاد می‌شود
                                </small>
                            </div>
                        </div>

                        <!-- مدیریت شبکه های اجتماعی -->
                        <div class="card card-secondary">
                            <div class="card-header d-flex justify-content-between align-items-center">
                                <h3 class="card-title">شبکه‌های اجتماعی فوتر</h3>
                                <a href="SocialLinksAdmin.aspx" class="btn btn-sm btn-primary">مدیریت</a>
                            </div>
                            <div class="card-body">
                                <small>
                                    برای مدیریت آیکن‌ها و لینک‌های شبکه‌های اجتماعی فوتر، از دکمه مدیریت استفاده کنید.
                                </small>
                            </div>
                        </div>
                    </div>

                    <!-- لیست منوها -->
                    <div class="col-md-8">
                        <div class="card">
                            <div class="card-header">
                                <h3 class="card-title">لیست منوهای سایت</h3>
                                <div class="card-tools">
                                    <asp:Button ID="btnReorderMenus" runat="server" Text="مرتب‌سازی خودکار" 
                                        CssClass="btn btn-sm btn-info" OnClick="btnReorderMenus_Click" />
                                </div>
                            </div>
                            <div class="card-body">
                                <asp:GridView ID="gvMenus" runat="server" CssClass="table table-bordered table-striped" 
                                    AutoGenerateColumns="False" DataKeyNames="Id" AllowPaging="True" PageSize="10"
                                    OnPageIndexChanging="gvMenus_PageIndexChanging" OnRowCommand="gvMenus_RowCommand">
                                    <Columns>
                                        <asp:BoundField DataField="SortOrder" HeaderText="ترتیب" ItemStyle-Width="60px" ItemStyle-CssClass="text-center" />
                                        <asp:BoundField DataField="Title" HeaderText="عنوان منو" />
                                        <asp:BoundField DataField="Url" HeaderText="آدرس لینک" />
                                        <asp:TemplateField HeaderText="والد" ItemStyle-Width="100px">
                                            <ItemTemplate>
                                                <%# GetParentMenuTitle(Eval("ParentId")) %>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="وضعیت" ItemStyle-Width="80px" ItemStyle-CssClass="text-center">
                                            <ItemTemplate>
                                                <%# Convert.ToBoolean(Eval("IsActive") ?? true) ? "<span class='badge badge-success'>فعال</span>" : "<span class='badge badge-secondary'>غیرفعال</span>" %>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="عملیات" ItemStyle-Width="150px">
                                            <ItemTemplate>
                                                <asp:Button ID="btnEdit" runat="server" Text="ویرایش" CssClass="btn btn-sm btn-warning"
                                                    CommandName="EditMenu" CommandArgument='<%# Eval("Id") %>' />
                                                <asp:Button ID="btnDelete" runat="server" Text="حذف" CssClass="btn btn-sm btn-danger"
                                                    CommandName="DeleteMenu" CommandArgument='<%# Eval("Id") %>' 
                                                    OnClientClick="return confirm('آیا مطمئن هستید؟');" />
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                    <EmptyDataTemplate>
                                        <div class="text-center text-muted p-4">
                                            <i class="fas fa-bars fa-3x mb-3"></i><br>
                                            هنوز منویی تعریف نشده است.
                                        </div>
                                    </EmptyDataTemplate>
                                </asp:GridView>
                            </div>
                        </div>

                        <!-- پیش‌نمایش منو -->
                        <div class="card card-success">
                            <div class="card-header">
                                <h3 class="card-title">پیش‌نمایش منوی سایت</h3>
                            </div>
                            <div class="card-body">
                                <nav class="navbar navbar-expand-lg navbar-light bg-light">
                                    <div class="navbar-nav">
                                        <asp:Repeater ID="rptMenuPreview" runat="server">
                                            <ItemTemplate>
                                                <a class="nav-item nav-link" href="<%# Eval("Url") %>"><%# Eval("Title") %></a>
                                            </ItemTemplate>
                                        </asp:Repeater>
                                    </div>
                                </nav>
                                <small class="text-muted">این پیش‌نمایش نحوه نمایش منوها در سایت را نشان می‌دهد</small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </div>
</asp:Content>

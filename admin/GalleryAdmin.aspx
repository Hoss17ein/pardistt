<%@ Page Title="مدیریت گالری" Language="C#" MasterPageFile="~/admin/AdminMaster.Master" AutoEventWireup="true" CodeFile="GalleryAdmin.aspx.cs" Inherits="shop1.Admin.GalleryAdmin" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="content-wrapper">
        <div class="content-header">
            <div class="container-fluid">
                <div class="row mb-2">
                    <div class="col-sm-6">
                        <h1 class="m-0">مدیریت گالری تصاویر</h1>
                    </div>
                </div>
            </div>
        </div>

        <section class="content">
            <div class="container-fluid">
                <!-- فرم افزودن/ویرایش تصویر -->
                <div class="row">
                    <div class="col-md-4">
                        <div class="card card-success">
                            <div class="card-header">
                                <h3 class="card-title">
                                    <asp:Literal ID="litFormTitle" runat="server">افزودن تصویر جدید</asp:Literal>
                                </h3>
                            </div>
                            <div class="card-body">
                                <asp:HiddenField ID="hfImageId" runat="server" />
                                
                                <div class="form-group">
                                    <label>عنوان تصویر</label>
                                    <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control" placeholder="عنوان تصویر"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvTitle" runat="server" ControlToValidate="txtTitle" 
                                        ErrorMessage="عنوان تصویر الزامی است" CssClass="text-danger" Display="Dynamic"></asp:RequiredFieldValidator>
                                </div>

                                <div class="form-group">
                                    <label>توضیحات</label>
                                    <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" TextMode="MultiLine" 
                                        Rows="3" placeholder="توضیحاتی در مورد تصویر"></asp:TextBox>
                                </div>

                                <div class="form-group">
                                    <label>انتخاب تصویر</label>
                                    <asp:FileUpload ID="fuImage" runat="server" CssClass="form-control-file" />
                                    <asp:RequiredFieldValidator ID="rfvImage" runat="server" ControlToValidate="fuImage" 
                                        ErrorMessage="انتخاب تصویر الزامی است" CssClass="text-danger" Display="Dynamic"></asp:RequiredFieldValidator>
                                    <asp:Literal ID="litCurrentImage" runat="server"></asp:Literal>
                                </div>

                                <div class="form-group">
                                    <asp:Button ID="btnSave" runat="server" Text="ذخیره" CssClass="btn btn-success" 
                                        OnClick="btnSave_Click" />
                                    <asp:Button ID="btnCancel" runat="server" Text="انصراف" CssClass="btn btn-secondary" 
                                        OnClick="btnCancel_Click" CausesValidation="false" />
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- گالری تصاویر -->
                    <div class="col-md-8">
                        <div class="card">
                            <div class="card-header">
                                <h3 class="card-title">گالری تصاویر</h3>
                            </div>
                            <div class="card-body">
                                <asp:Repeater ID="rptGallery" runat="server" OnItemCommand="rptGallery_ItemCommand">
                                    <HeaderTemplate>
                                        <div class="row">
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <div class="col-md-4 mb-3">
                                            <div class="card">
                                                <img src="../<%# Eval("ImageUrl") %>" class="card-img-top" style="height: 150px; object-fit: cover;" alt="<%# Eval("Title") %>">
                                                <div class="card-body p-2">
                                                    <h6 class="card-title"><%# Eval("Title") %></h6>
                                                    <p class="card-text small"><%# Eval("Description") %></p>
                                                    <small class="text-muted"><%# Eval("CreatedDate", "{0:yyyy/MM/dd}") %></small>
                                                    <div class="mt-2">
                                                        <asp:Button ID="btnEdit" runat="server" Text="ویرایش" CssClass="btn btn-sm btn-warning"
                                                            CommandName="EditImage" CommandArgument='<%# Eval("Id") %>' />
                                                        <asp:Button ID="btnDelete" runat="server" Text="حذف" CssClass="btn btn-sm btn-danger"
                                                            CommandName="DeleteImage" CommandArgument='<%# Eval("Id") %>' 
                                                            OnClientClick="return confirm('آیا مطمئن هستید؟');" />
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </ItemTemplate>
                                    <FooterTemplate>
                                        </div>
                                    </FooterTemplate>
                                </asp:Repeater>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </div>
</asp:Content>

<%@ Page Title="مدیریت اخبار" Language="C#" MasterPageFile="~/admin/AdminMaster.Master" AutoEventWireup="true" CodeFile="NewsAdmin.aspx.cs" Inherits="shop1.Admin.NewsAdmin" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="content-wrapper">
        <div class="content-header">
            <div class="container-fluid">
                <div class="row mb-2">
                    <div class="col-sm-6">
                        <h1 class="m-0">مدیریت اخبار</h1>
                    </div>
                </div>
            </div>
        </div>

        <section class="content">
            <div class="container-fluid">
                <!-- فرم افزودن/ویرایش خبر -->
                <div class="row">
                    <div class="col-md-6">
                        <div class="card card-primary">
                            <div class="card-header">
                                <h3 class="card-title">
                                    <asp:Literal ID="litFormTitle" runat="server">افزودن خبر جدید</asp:Literal>
                                </h3>
                            </div>
                            <div class="card-body">
                                <asp:HiddenField ID="hfNewsId" runat="server" />
                                
                                <div class="form-group">
                                    <label>عنوان خبر</label>
                                    <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control" placeholder="عنوان خبر را وارد کنید"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvTitle" runat="server" ControlToValidate="txtTitle" 
                                        ErrorMessage="عنوان خبر الزامی است" CssClass="text-danger" Display="Dynamic"></asp:RequiredFieldValidator>
                                </div>

                                <div class="form-group">
                                    <label>خلاصه خبر</label>
                                    <asp:TextBox ID="txtSummary" runat="server" CssClass="form-control" TextMode="MultiLine" 
                                        Rows="3" placeholder="خلاصه‌ای از خبر بنویسید"></asp:TextBox>
                                </div>

                                <div class="form-group">
                                    <label>محتوای کامل</label>
                                    <asp:TextBox ID="txtContent" runat="server" CssClass="form-control" TextMode="MultiLine" 
                                        Rows="5" placeholder="محتوای کامل خبر"></asp:TextBox>
                                </div>

                                <div class="form-group">
                                    <label>دسته‌بندی</label>
                                    <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-control">
                                        <asp:ListItem Value="اخبار عمومی">اخبار عمومی</asp:ListItem>
                                        <asp:ListItem Value="مسابقات">مسابقات</asp:ListItem>
                                        <asp:ListItem Value="آموزش">آموزش</asp:ListItem>
                                        <asp:ListItem Value="رویدادها">رویدادها</asp:ListItem>
                                    </asp:DropDownList>
                                </div>

                                <div class="form-group">
                                    <label>تصویر خبر</label>
                                    <asp:FileUpload ID="fuImage" runat="server" CssClass="form-control-file" />
                                    <asp:Literal ID="litCurrentImage" runat="server"></asp:Literal>
                                </div>

                                <div class="form-group">
                                    <asp:Button ID="btnSave" runat="server" Text="ذخیره" CssClass="btn btn-primary" 
                                        OnClick="btnSave_Click" />
                                    <asp:Button ID="btnCancel" runat="server" Text="انصراف" CssClass="btn btn-secondary" 
                                        OnClick="btnCancel_Click" CausesValidation="false" />
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- لیست اخبار -->
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-header">
                                <h3 class="card-title">لیست اخبار</h3>
                            </div>
                            <div class="card-body">
                                <asp:GridView ID="gvNews" runat="server" CssClass="table table-bordered table-striped" 
                                    AutoGenerateColumns="False" DataKeyNames="Id" AllowPaging="True" PageSize="5"
                                    OnPageIndexChanging="gvNews_PageIndexChanging" OnRowCommand="gvNews_RowCommand">
                                    <Columns>
                                        <asp:BoundField DataField="Title" HeaderText="عنوان" />
                                        <asp:BoundField DataField="Category" HeaderText="دسته" />
                                        <asp:BoundField DataField="CreatedDate" HeaderText="تاریخ" DataFormatString="{0:yyyy/MM/dd}" />
                                        <asp:TemplateField HeaderText="عملیات">
                                            <ItemTemplate>
                                                <asp:Button ID="btnEdit" runat="server" Text="ویرایش" CssClass="btn btn-sm btn-warning"
                                                    CommandName="EditNews" CommandArgument='<%# Eval("Id") %>' />
                                                <asp:Button ID="btnDelete" runat="server" Text="حذف" CssClass="btn btn-sm btn-danger"
                                                    CommandName="DeleteNews" CommandArgument='<%# Eval("Id") %>' 
                                                    OnClientClick="return confirm('آیا مطمئن هستید؟');" />
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

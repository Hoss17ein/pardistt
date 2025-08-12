<%@ Page Title="مدیریت اطلاعیه‌ها" Language="C#" MasterPageFile="~/admin/AdminMaster.Master" AutoEventWireup="true" CodeFile="AnnouncementsAdmin.aspx.cs" Inherits="shop1.Admin.AnnouncementsAdmin" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="content-wrapper">
        <div class="content-header">
            <div class="container-fluid">
                <div class="row mb-2">
                    <div class="col-sm-6">
                        <h1 class="m-0">مدیریت اطلاعیه‌ها</h1>
                    </div>
                </div>
            </div>
        </div>

        <section class="content">
            <div class="container-fluid">
                <div class="row">
                    <div class="col-md-5">
                        <div class="card card-warning">
                            <div class="card-header"><h3 class="card-title">افزودن/ویرایش اطلاعیه</h3></div>
                            <div class="card-body">
                                <asp:HiddenField ID="hfId" runat="server" />
                                <div class="form-group">
                                    <label>عنوان</label>
                                    <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control" />
                                </div>
                                <div class="form-group">
                                    <label>متن اطلاعیه</label>
                                    <asp:TextBox ID="txtBody" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="4" />
                                </div>
                                <div class="form-group">
                                    <div class="custom-control custom-checkbox">
                                        <asp:CheckBox ID="chkActive" runat="server" CssClass="custom-control-input" Checked="true" />
                                        <label class="custom-control-label" for="<%= chkActive.ClientID %>">فعال</label>
                                    </div>
                                </div>
                                <asp:Button ID="btnSave" runat="server" Text="ذخیره" CssClass="btn btn-primary" OnClick="btnSave_Click" />
                                <asp:Button ID="btnCancel" runat="server" Text="انصراف" CssClass="btn btn-secondary" OnClick="btnCancel_Click" />
                            </div>
                        </div>
                    </div>
                    <div class="col-md-7">
                        <div class="card">
                            <div class="card-header"><h3 class="card-title">لیست اطلاعیه‌ها</h3></div>
                            <div class="card-body">
                                <asp:GridView ID="gvAnn" runat="server" CssClass="table table-bordered table-striped" AutoGenerateColumns="False" DataKeyNames="Id" OnRowCommand="gvAnn_RowCommand">
                                    <Columns>
                                        <asp:BoundField DataField="Title" HeaderText="عنوان" />
                                        <asp:BoundField DataField="CreatedDate" HeaderText="تاریخ" DataFormatString="{0:yyyy/MM/dd}" />
                                        <asp:TemplateField HeaderText="وضعیت">
                                            <ItemTemplate>
                                                <%# Convert.ToBoolean(Eval("IsActive") ?? true) ? "<span class='badge badge-success'>فعال</span>" : "<span class='badge badge-secondary'>غیرفعال</span>" %>
                                            </ItemTemplate>
                                        </asp:TemplateField>
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


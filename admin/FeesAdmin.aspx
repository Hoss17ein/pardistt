<%@ Page Title="مدیریت شهریه‌ها" Language="C#" MasterPageFile="~/admin/AdminMaster.Master" AutoEventWireup="true" CodeFile="FeesAdmin.aspx.cs" Inherits="shop1.Admin.FeesAdmin" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="content-wrapper">
        <div class="content-header">
            <div class="container-fluid">
                <div class="row mb-2">
                    <div class="col-sm-6">
                        <h1 class="m-0">مدیریت شهریه‌ها</h1>
                    </div>
                </div>
            </div>
        </div>
        <section class="content">
            <div class="container-fluid">
                <div class="row">
                    <div class="col-md-5">
                        <div class="card card-success">
                            <div class="card-header"><h3 class="card-title">افزودن/ویرایش شهریه</h3></div>
                            <div class="card-body">
                                <asp:HiddenField ID="hfId" runat="server" />
                                <div class="form-group">
                                    <label>نام دوره</label>
                                    <asp:TextBox ID="txtCourseName" runat="server" CssClass="form-control" />
                                </div>
                                <div class="form-group">
                                    <label>تعداد جلسات</label>
                                    <asp:TextBox ID="txtSessions" runat="server" CssClass="form-control" />
                                </div>
                                <div class="form-group">
                                    <label>مبلغ (تومان)</label>
                                    <asp:TextBox ID="txtFee" runat="server" CssClass="form-control" />
                                </div>
                                <div class="form-group">
                                    <label>توضیحات</label>
                                    <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" />
                                </div>
                                <asp:Button ID="btnSave" runat="server" Text="ذخیره" CssClass="btn btn-primary" OnClick="btnSave_Click" />
                                <asp:Button ID="btnCancel" runat="server" Text="انصراف" CssClass="btn btn-secondary" OnClick="btnCancel_Click" />
                            </div>
                        </div>
                    </div>
                    <div class="col-md-7">
                        <div class="card">
                            <div class="card-header"><h3 class="card-title">لیست شهریه‌ها</h3></div>
                            <div class="card-body">
                                <asp:GridView ID="gvFees" runat="server" CssClass="table table-bordered table-striped" AutoGenerateColumns="False" DataKeyNames="Id" OnRowCommand="gvFees_RowCommand">
                                    <Columns>
                                        <asp:BoundField DataField="CourseName" HeaderText="نام دوره" />
                                        <asp:BoundField DataField="Sessions" HeaderText="جلسات" />
                                        <asp:BoundField DataField="Fee" HeaderText="شهریه" DataFormatString="{0:N0}" />
                                        <asp:BoundField DataField="Description" HeaderText="توضیحات" />
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


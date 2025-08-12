<%@ Page Title="مدیریت سفارش‌ها" Language="C#" MasterPageFile="~/admin/AdminMaster.Master" AutoEventWireup="true" CodeFile="OrdersAdmin.aspx.cs" Inherits="shop1.Admin.OrdersAdmin" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container-fluid px-2">
        <div class="card">
            <div class="card-header"><h3 class="card-title mb-0">سفارش‌ها</h3></div>
            <div class="card-body p-0">
                <asp:GridView ID="gvOrders" runat="server" AutoGenerateColumns="False" CssClass="table table-striped table-hover mb-0" DataKeyNames="Id" OnRowCommand="gvOrders_RowCommand">
                    <Columns>
                        <asp:BoundField DataField="Id" HeaderText="شناسه" />
                        <asp:BoundField DataField="Username" HeaderText="کاربر" />
                        <asp:BoundField DataField="TotalAmount" HeaderText="جمع" DataFormatString="{0:N0}" />
                        <asp:BoundField DataField="Status" HeaderText="وضعیت" />
                        <asp:BoundField DataField="CreatedDate" HeaderText="تاریخ" DataFormatString="{0:yyyy/MM/dd HH:mm}" />
                        <asp:TemplateField HeaderText="عملیات">
                            <ItemTemplate>
                                <asp:LinkButton ID="lnkDetails" runat="server" CommandName="details" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm btn-info">آیتم‌ها</asp:LinkButton>
                                <asp:LinkButton ID="lnkComplete" runat="server" CommandName="complete" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm btn-success">تکمیل</asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>

        <div class="card mt-3">
            <div class="card-header"><h3 class="card-title mb-0">اقلام سفارش</h3></div>
            <div class="card-body p-0">
                <asp:GridView ID="gvItems" runat="server" AutoGenerateColumns="False" CssClass="table table-striped table-hover mb-0">
                    <Columns>
                        <asp:BoundField DataField="ProductId" HeaderText="کد محصول" />
                        <asp:BoundField DataField="Name" HeaderText="نام محصول" />
                        <asp:BoundField DataField="Price" HeaderText="قیمت" DataFormatString="{0:N0}" />
                        <asp:BoundField DataField="Quantity" HeaderText="تعداد" />
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>
</asp:Content>



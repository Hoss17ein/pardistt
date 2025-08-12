<%@ Page Title="مدیریت جدول" Language="C#" AutoEventWireup="true" CodeFile="GenericTableAdmin.aspx.cs" Inherits="shop1.Admin.GenericTableAdmin" MasterPageFile="~/Admin/AdminMaster.Master" %>
<%@ MasterType VirtualPath="~/Admin/AdminMaster.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <h2 style="direction:rtl">مدیریت جدول: <asp:Literal ID="litTableName" runat="server"></asp:Literal></h2>
    <asp:PlaceHolder ID="phMessages" runat="server"></asp:PlaceHolder>
    <asp:GridView ID="gvData" runat="server" AutoGenerateColumns="true" DataKeyNames="Id"
        CssClass="table table-bordered table-striped" AllowPaging="true" PageSize="20"
        OnPageIndexChanging="gvData_PageIndexChanging" OnRowEditing="gvData_RowEditing"
        OnRowCancelingEdit="gvData_RowCancelingEdit" OnRowUpdating="gvData_RowUpdating"
        OnRowDeleting="gvData_RowDeleting">
    </asp:GridView>

    <h3 style="direction:rtl;margin-top:24px">افزودن رکورد جدید</h3>
    <asp:PlaceHolder ID="phInsert" runat="server"></asp:PlaceHolder>
    <div style="margin-top:10px">
        <asp:Button ID="btnInsert" runat="server" Text="افزودن" CssClass="btn btn-primary" OnClick="btnInsert_Click" />
        <asp:Button ID="btnSeed" runat="server" Text="افزودن ۴ رکورد پیش‌فرض" CssClass="btn btn-secondary" OnClick="btnSeed_Click" style="margin-right:8px" />
    </div>
</asp:Content>



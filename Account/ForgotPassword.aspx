<%@ Page Title="فراموشی رمز" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeFile="ForgotPassword.aspx.cs" Inherits="Pardis.Account.ForgotPassword" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <section class="py-12">
        <div class="container mx-auto px-4">
            <div class="max-w-md mx-auto bg-white rounded-xl shadow p-6">
                <h2 class="text-2xl font-bold text-blue-900 mb-4">بازیابی رمز عبور</h2>
                <div class="space-y-3">
                    <div>
                        <label class="block text-sm mb-1">نام کاربری</label>
                        <asp:TextBox ID="txtUser" runat="server" CssClass="w-full border rounded px-3 py-2" />
                    </div>
                    <asp:Button ID="btnSend" runat="server" Text="ارسال رمز جدید" CssClass="bg-indigo-600 hover:bg-indigo-700 text-white font-bold py-2 px-4 rounded" OnClick="btnSend_Click" />
                    <asp:Literal ID="litMsg" runat="server" />
                </div>
            </div>
        </div>
    </section>
</asp:Content>



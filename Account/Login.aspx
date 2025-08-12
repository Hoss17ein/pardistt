<%@ Page Title="ورود" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Pardis.Account.Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <section class="py-12">
        <div class="container mx-auto px-4">
            <div class="max-w-md mx-auto bg-white rounded-xl shadow p-6">
                <h2 class="text-2xl font-bold text-blue-900 mb-4">ورود</h2>
                <div class="space-y-3">
                    <div>
                        <label class="block text-sm mb-1">نام کاربری</label>
                        <asp:TextBox ID="txtUser" runat="server" CssClass="w-full border rounded px-3 py-2" />
                    </div>
                    <div>
                        <label class="block text-sm mb-1">کلمه عبور</label>
                        <asp:TextBox ID="txtPass" runat="server" TextMode="Password" CssClass="w-full border rounded px-3 py-2" />
                    </div>
                    <asp:Button ID="btnLogin" runat="server" Text="ورود" CssClass="bg-blue-600 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded" OnClick="btnLogin_Click" />
                    <div class="text-sm mt-3">
                        حساب ندارید؟ <a href="/Account/Register.aspx" class="text-blue-700">ثبت‌نام</a>
                    </div>
                    <asp:Literal ID="litMsg" runat="server" />
                </div>
            </div>
        </div>
    </section>
</asp:Content>



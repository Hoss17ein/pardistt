<%@ Page Title="تغییر رمز" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeFile="ChangePassword.aspx.cs" Inherits="Pardis.Account.ChangePassword" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <section class="py-12">
        <div class="container mx-auto px-4">
            <div class="max-w-md mx-auto bg-white rounded-xl shadow p-6">
                <h2 class="text-2xl font-bold text-blue-900 mb-4">تغییر رمز</h2>
                <div class="space-y-3">
                    <div>
                        <label class="block text-sm mb-1">رمز فعلی</label>
                        <asp:TextBox ID="txtOld" runat="server" TextMode="Password" CssClass="w-full border rounded px-3 py-2" />
                    </div>
                    <div>
                        <label class="block text-sm mb-1">رمز جدید</label>
                        <asp:TextBox ID="txtNew" runat="server" TextMode="Password" CssClass="w-full border rounded px-3 py-2" />
                    </div>
                    <asp:Button ID="btnChange" runat="server" Text="ذخیره" CssClass="bg-green-600 hover:bg-green-700 text-white font-bold py-2 px-4 rounded" OnClick="btnChange_Click" />
                    <asp:Literal ID="litMsg" runat="server" />
                </div>
            </div>
        </div>
    </section>
</asp:Content>



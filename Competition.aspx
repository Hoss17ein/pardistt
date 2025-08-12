<%@ Page Title="جزئیات مسابقه" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeFile="Competition.aspx.cs" Inherits="Pardis.CompetitionPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <section class="py-12">
        <div class="container mx-auto px-4">
            <asp:Panel ID="pnlNotFound" runat="server" Visible="false" CssClass="bg-red-50 text-red-700 p-4 rounded mb-6">مسابقه پیدا نشد.</asp:Panel>
            <asp:Panel ID="pnlComp" runat="server" Visible="false">
                <div class="bg-white rounded-xl shadow p-6">
                    <div class="flex items-start justify-between">
                        <div>
                            <h1 class="text-2xl font-bold text-blue-900 mb-2"><asp:Literal ID="litTitle" runat="server" /></h1>
                            <div class="text-gray-600 mb-2"><asp:Literal ID="litMeta" runat="server" /></div>
                        </div>
                        <a id="lnkRegister" runat="server" class="bg-blue-600 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded">ثبت‌نام</a>
                    </div>
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mt-6">
                        <div class="md:col-span-2">
                            <asp:Image ID="imgCover" runat="server" CssClass="w-full max-h-72 md:max-h-96 object-contain bg-gray-100 rounded" />
                            <div class="prose max-w-none text-gray-800 mt-4 leading-7"><asp:Literal ID="litDescription" runat="server" /></div>
                        </div>
                        <div>
                            <h3 class="text-lg font-bold mb-3">افراد ثبت‌نام شده</h3>
                            <asp:Repeater ID="rptRegs" runat="server">
                                <HeaderTemplate><ul class="space-y-2"></HeaderTemplate>
                                <ItemTemplate>
                                    <li class="flex items-center justify-between bg-gray-50 rounded p-2">
                                        <span class="font-medium"><%# Eval("FullName") %></span>
                                        <span class="text-xs text-gray-500"><%# Eval("CreatedDate", "{0:yyyy/MM/dd}") %></span>
                                    </li>
                                </ItemTemplate>
                                <FooterTemplate></ul></FooterTemplate>
                            </asp:Repeater>
                            <asp:Literal ID="litNoRegs" runat="server" Visible="false" Text="<span class='text-gray-500 text-sm'>هنوز ثبت‌نامی انجام نشده است.</span>" />
                        </div>
                    </div>
                </div>
            </asp:Panel>
        </div>
    </section>
</asp:Content>



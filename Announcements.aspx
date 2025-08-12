<%@ Page Title="همه اطلاعیه‌ها" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeFile="Announcements.aspx.cs" Inherits="Pardis.AnnouncementsPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <section class="py-12">
        <div class="container mx-auto px-4">
            <h1 class="text-2xl md:text-3xl font-bold text-blue-900 mb-6">همه اطلاعیه‌ها</h1>
            <asp:Repeater ID="rptAnnouncements" runat="server">
                <HeaderTemplate><div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6"></HeaderTemplate>
                <ItemTemplate>
                    <article class="announcement-card bg-white rounded-xl overflow-hidden shadow-md border-l-4 border-blue-500 hover:shadow-lg transition-all duration-300">
                        <div class="p-6">
                            <div class="flex justify-between items-center mb-3 text-xs">
                                <span class="font-semibold text-blue-600 bg-blue-50 px-2 py-1 rounded"><%# Eval("CreatedDate", "{0:yyyy/MM/dd}") %></span>
                                <span class="text-gray-500"><%# Convert.ToBoolean(Eval("IsActive")) ? "فعال" : "غیرفعال" %></span>
                            </div>
                            <h3 class="text-lg font-bold mb-3 text-blue-900"><%# Eval("Title") %></h3>
                            <p class="text-gray-600 mb-0"><%# Eval("Body") %></p>
                        </div>
                    </article>
                </ItemTemplate>
                <FooterTemplate></div></FooterTemplate>
            </asp:Repeater>
        </div>
    </section>
</asp:Content>



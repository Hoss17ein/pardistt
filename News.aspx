<%@ Page Title="همه اخبار" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeFile="News.aspx.cs" Inherits="Pardis.NewsPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <section class="py-12">
        <div class="container mx-auto px-4">
            <h1 class="text-2xl md:text-3xl font-bold text-blue-900 mb-6">همه اخبار</h1>
            <asp:Repeater ID="rptNews" runat="server">
                <HeaderTemplate><div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6"></HeaderTemplate>
                <ItemTemplate>
                    <article class="bg-white rounded-xl shadow overflow-hidden flex flex-col">
                        <div class="h-48 bg-gray-100">
                            <asp:Image ID="img" runat="server" ImageUrl='<%# Eval("ImageUrl") %>' CssClass="w-full h-full object-cover" />
                        </div>
                        <div class="p-4 flex-1 flex flex-col">
                            <div class="flex items-center justify-between text-xs text-gray-500 mb-2">
                                <span><%# Eval("Category") %></span>
                                <span><%# Eval("CreatedDate", "{0:yyyy/MM/dd}") %></span>
                            </div>
                            <h3 class="font-bold text-blue-900 mb-2"><%# Eval("Title") %></h3>
                            <p class="text-gray-600 text-sm mb-4 flex-1"><%# Eval("Summary") %></p>
                            <a href='<%# Eval("Id", "NewsDetail.aspx?id={0}") %>' class="mt-auto text-blue-600 hover:text-blue-800">ادامه مطلب</a>
                        </div>
                    </article>
                </ItemTemplate>
                <FooterTemplate></div></FooterTemplate>
            </asp:Repeater>
        </div>
    </section>
</asp:Content>



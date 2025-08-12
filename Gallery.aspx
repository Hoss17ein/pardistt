<%@ Page Title="گالری کامل" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeFile="Gallery.aspx.cs" Inherits="Pardis.GalleryPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <section class="py-12">
        <div class="container mx-auto px-4">
            <h1 class="text-2xl md:text-3xl font-bold text-blue-900 mb-6">گالری تصاویر</h1>
            <asp:Repeater ID="rptGallery" runat="server">
                <HeaderTemplate><div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6"></HeaderTemplate>
                <ItemTemplate>
                    <figure class="bg-white rounded-xl shadow overflow-hidden">
                        <div class="h-64 bg-gray-100">
                            <asp:Image ID="img" runat="server" ImageUrl='<%# Eval("ImageUrl") %>' CssClass="w-full h-full object-cover" />
                        </div>
                        <figcaption class="p-4">
                            <h3 class="font-bold text-blue-900"><%# Eval("Title") %></h3>
                            <p class="text-gray-600 text-sm mt-1"><%# Eval("Description") %></p>
                        </figcaption>
                    </figure>
                </ItemTemplate>
                <FooterTemplate></div></FooterTemplate>
            </asp:Repeater>
        </div>
    </section>
</asp:Content>



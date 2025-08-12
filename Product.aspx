<%@ Page Title="جزئیات محصول" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeFile="Product.aspx.cs" Inherits="Pardis.ProductPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <section class="py-12">
        <div class="container mx-auto px-4">
            <asp:Panel ID="pnlNotFound" runat="server" Visible="false" CssClass="bg-red-50 text-red-700 p-4 rounded mb-6">
                محصول پیدا نشد.
            </asp:Panel>

            <asp:Panel ID="pnlProduct" runat="server" Visible="false">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div>
                        <div class="relative w-full overflow-hidden rounded-xl bg-gray-100">
                            <asp:Image ID="imgMain" runat="server" CssClass="w-full max-h-96 object-contain" />
                        </div>
                        <asp:Repeater ID="rptThumbs" runat="server">
                            <HeaderTemplate><div class="grid grid-cols-5 gap-2 mt-3"></HeaderTemplate>
                            <ItemTemplate>
                                <img src="<%# Eval("ImageUrl") %>" class="h-20 w-full object-cover rounded cursor-pointer hover:opacity-80" onclick="document.getElementById('<%= imgMain.ClientID %>').src=this.src" />
                            </ItemTemplate>
                            <FooterTemplate></div></FooterTemplate>
                        </asp:Repeater>
                    </div>
                    <div>
                        <h1 class="text-2xl font-bold text-blue-900 mb-2"><asp:Literal ID="litName" runat="server" /></h1>
                        <div class="text-blue-700 font-bold text-xl mb-4"><asp:Literal ID="litPrice" runat="server" /></div>
                        <div class="prose max-w-none text-gray-700 leading-7 mb-6"><asp:Literal ID="litDescription" runat="server" /></div>
                        <asp:HiddenField ID="hfProductId" runat="server" />
                        <asp:Button ID="btnAdd" runat="server" Text="افزودن به سبد" CssClass="bg-blue-600 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded" OnClick="btnAdd_Click" />
                    </div>
                </div>
            </asp:Panel>
        </div>
    </section>
</asp:Content>



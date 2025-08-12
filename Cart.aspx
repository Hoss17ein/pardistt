<%@ Page Title="سبد خرید" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeFile="Cart.aspx.cs" Inherits="Pardis.CartPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <section class="py-12">
        <div class="container mx-auto px-4">
            <h2 class="text-2xl font-bold text-blue-900 mb-6">سبد خرید</h2>
            <asp:Repeater ID="rptCart" runat="server">
                <HeaderTemplate><div class="space-y-3"></HeaderTemplate>
                <ItemTemplate>
                    <div class="bg-white rounded shadow p-4 flex items-center justify-between">
                        <div class="flex items-center gap-3">
                            <img src="<%# Eval("ImageUrl") %>" class="w-16 h-16 object-cover rounded" />
                            <div>
                                <div class="font-bold"><%# Eval("Name") %></div>
                                <div class="text-blue-700 font-bold text-sm"><%# Eval("Price", "{0:N0}") %> تومان</div>
                            </div>
                        </div>
                        <div class="flex items-center gap-2">
                            <asp:LinkButton ID="btnDec" runat="server" CommandName="dec" CommandArgument='<%# Eval("ProductId") %>' CssClass="w-8 h-8 flex items-center justify-center rounded bg-gray-200">-</asp:LinkButton>
                            <span class="w-10 text-center"><%# Eval("Quantity") %></span>
                            <asp:LinkButton ID="btnInc" runat="server" CommandName="inc" CommandArgument='<%# Eval("ProductId") %>' CssClass="w-8 h-8 flex items-center justify-center rounded bg-gray-200">+</asp:LinkButton>
                            <asp:LinkButton ID="btnRemove" runat="server" CommandName="rem" CommandArgument='<%# Eval("ProductId") %>' CssClass="btn btn-sm btn-danger">حذف</asp:LinkButton>
                        </div>
                    </div>
                </ItemTemplate>
                <FooterTemplate></div></FooterTemplate>
            </asp:Repeater>
            <div class="mt-6 flex items-center justify-between">
                <div class="text-xl font-bold text-blue-900">جمع کل: <asp:Literal ID="litTotal" runat="server" /></div>
                <a href="/Checkout.aspx" class="bg-green-600 hover:bg-green-700 text-white px-5 py-3 rounded">ادامه به تسویه</a>
            </div>
        </div>
    </section>
</asp:Content>



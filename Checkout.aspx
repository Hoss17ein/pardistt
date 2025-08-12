<%@ Page Title="تسویه حساب" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeFile="Checkout.aspx.cs" Inherits="Pardis.Checkout" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <section class="py-8 md:py-12">
        <div class="container mx-auto px-4">
            <h2 class="text-2xl font-bold text-blue-900 mb-6">تسویه حساب</h2>
            <asp:PlaceHolder ID="phAuth" runat="server"></asp:PlaceHolder>
            <asp:Panel ID="pnlCheckout" runat="server">
                <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
                    <!-- Billing/Shipping form - Step Wizard -->
                    <div class="lg:col-span-2">
                        <div class="bg-white rounded-xl shadow p-6 space-y-5">
                            <asp:Panel ID="pnlStep1" runat="server">
                            <div class="flex items-center gap-3 mb-2">
                                <span class="step-indicator" style="display:inline-block;width:24px;height:24px;border-radius:9999px;background:#2563eb;color:#fff;line-height:24px;text-align:center;">1</span>
                                <h3 class="text-lg font-bold text-blue-900 m-0">اطلاعات کاربر</h3>
                            </div>
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                                <div>
                                    <label class="block text-sm mb-1">نام</label>
                                    <asp:TextBox ID="txtFirstName" runat="server" CssClass="w-full border rounded px-3 py-2" />
                                    <asp:RequiredFieldValidator ID="rfvFN" runat="server" ControlToValidate="txtFirstName" ValidationGroup="s1" ErrorMessage="نام الزامی است" CssClass="text-red-600 text-xs" Display="Dynamic" />
                                </div>
                                <div>
                                    <label class="block text-sm mb-1">نام خانوادگی</label>
                                    <asp:TextBox ID="txtLastName" runat="server" CssClass="w-full border rounded px-3 py-2" />
                                    <asp:RequiredFieldValidator ID="rfvLN" runat="server" ControlToValidate="txtLastName" ValidationGroup="s1" ErrorMessage="نام خانوادگی الزامی است" CssClass="text-red-600 text-xs" Display="Dynamic" />
                                </div>
                                <div>
                                    <label class="block text-sm mb-1">موبایل</label>
                                    <asp:TextBox ID="txtPhone" runat="server" CssClass="w-full border rounded px-3 py-2" />
                                    <asp:RequiredFieldValidator ID="rfvPhone" runat="server" ControlToValidate="txtPhone" ValidationGroup="s1" ErrorMessage="شماره موبایل الزامی است" CssClass="text-red-600 text-xs" Display="Dynamic" />
                                </div>
                                <div>
                                    <label class="block text-sm mb-1">استان</label>
                                    <asp:DropDownList ID="ddlProvince" runat="server" CssClass="w-full border rounded px-3 py-2"></asp:DropDownList>
                                </div>
                            </div>
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mt-2">
                                <div>
                                    <label class="block text-sm mb-1">شهر</label>
                                    <asp:TextBox ID="txtCity" runat="server" CssClass="w-full border rounded px-3 py-2" />
                                </div>
                            </div>
                            <asp:Button ID="btnNext1" runat="server" Text="ادامه" ValidationGroup="s1" CssClass="mt-2 bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded" OnClick="btnNext1_Click" />
                            </asp:Panel>

                            <hr class="my-4" />
                            <asp:Panel ID="pnlStep2" runat="server">
                            <div class="flex items-center gap-3 mb-2">
                                <span class="step-indicator" style="display:inline-block;width:24px;height:24px;border-radius:9999px;background:#2563eb;color:#fff;line-height:24px;text-align:center;">2</span>
                                <h3 class="text-lg font-bold text-blue-900 m-0">آدرس</h3>
                            </div>
                            <div>
                                <label class="block text-sm mb-1">آدرس کامل</label>
                                <asp:TextBox ID="txtAddress" runat="server" TextMode="MultiLine" Rows="2" CssClass="w-full border rounded px-3 py-2" />
                                <asp:RequiredFieldValidator ID="rfvAddr" runat="server" ControlToValidate="txtAddress" ValidationGroup="s2" ErrorMessage="آدرس الزامی است" CssClass="text-red-600 text-xs" Display="Dynamic" />
                            </div>
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                                <div>
                                    <label class="block text-sm mb-1">کدپستی</label>
                                    <asp:TextBox ID="txtPostal" runat="server" CssClass="w-full border rounded px-3 py-2" />
                                </div>
                                <div>
                                    <label class="block text-sm mb-1">توضیحات سفارش</label>
                                    <asp:TextBox ID="txtNotes" runat="server" CssClass="w-full border rounded px-3 py-2" />
                                </div>
                            </div>
                            <asp:Button ID="btnNext2" runat="server" Text="ادامه" ValidationGroup="s2" CssClass="mt-2 bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded" OnClick="btnNext2_Click" />
                            </asp:Panel>

                            <hr class="my-4" />
                            <asp:Panel ID="pnlStep3" runat="server">
                            <div class="flex items-center gap-3 mb-2">
                                <span class="step-indicator" style="display:inline-block;width:24px;height:24px;border-radius:9999px;background:#2563eb;color:#fff;line-height:24px;text-align:center;">3</span>
                                <h3 class="text-lg font-bold text-blue-900 m-0">روش ارسال</h3>
                            </div>
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                                <div>
                                    <label class="block text-sm mb-1">روش ارسال</label>
                                    <asp:DropDownList ID="ddlShipping" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlShipping_SelectedIndexChanged" CssClass="w-full border rounded px-3 py-2">
                                        <asp:ListItem Text="پست پیشتاز (پس‌کرایه)" Value="0" />
                                        <asp:ListItem Text="تیپاکس (پس‌کرایه)" Value="0" />
                                    </asp:DropDownList>
                                </div>
                                <div>
                                    <label class="block text-sm mb-1">روش پرداخت</label>
                                    <asp:RadioButtonList ID="rblPayment" runat="server" RepeatDirection="Horizontal" AutoPostBack="true" OnSelectedIndexChanged="rblPayment_SelectedIndexChanged">
                                        <asp:ListItem Text="آنلاین" Value="Online" Selected="True" />
                                        <asp:ListItem Text="در محل" Value="COD" />
                                    </asp:RadioButtonList>
                                </div>
                            </div>
                            </asp:Panel>
                        </div>
                    </div>

                    <!-- Order summary -->
                    <div>
                        <div class="bg-white rounded-xl shadow p-6">
                            <h3 class="text-lg font-bold text-blue-900 mb-4">خلاصه سفارش</h3>
                            <asp:Repeater ID="rptSummary" runat="server">
                                <HeaderTemplate><ul class="space-y-3"></HeaderTemplate>
                                <ItemTemplate>
                                    <li class="flex items-center justify-between text-sm">
                                        <span><%# Eval("Name") %> × <%# Eval("Quantity") %></span>
                                        <span class="font-bold"><%# Eval("LineTotal", "{0:N0}") %></span>
                                    </li>
                                </ItemTemplate>
                                <FooterTemplate></ul></FooterTemplate>
                            </asp:Repeater>
                            <div class="border-t mt-4 pt-4 space-y-2 text-sm">
                                <div class="flex justify-between"><span>جمع جزء</span><span><asp:Literal ID="litSubTotal" runat="server" /></span></div>
                                <div class="flex justify-between"><span>هزینه ارسال</span><span><asp:Literal ID="litShipping" runat="server" /></span></div>
                                <div class="flex justify-between text-lg font-bold text-blue-900"><span>مبلغ نهایی</span><span><asp:Literal ID="litGrand" runat="server" /></span></div>
                            </div>
                            <asp:Button ID="btnPlaceOrder" runat="server" Text="ثبت سفارش" CssClass="mt-4 w-full bg-green-600 hover:bg-green-700 text-white px-5 py-3 rounded" OnClick="btnPlaceOrder_Click" />
                            <asp:Literal ID="litMsg" runat="server" />
                        </div>
                    </div>
                </div>
            </asp:Panel>
        </div>
    </section>
</asp:Content>



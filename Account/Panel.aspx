<%@ Page Title="پنل کاربری" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeFile="Panel.aspx.cs" Inherits="Pardis.Account.Panel" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <section class="py-12">
        <div class="container mx-auto px-4">
            <div class="grid grid-cols-1 md:grid-cols-12 gap-6">
                <!-- Sidebar (desktop) -->
                <aside class="hidden md:block md:col-span-3">
                    <div class="bg-white rounded-xl shadow p-4 sticky" style="top: 96px;">
                        <nav class="space-y-2">
                            <a href="#profile" class="block px-3 py-2 rounded hover:bg-blue-50 text-blue-900">اطلاعات حساب</a>
                            <a href="#orders" class="block px-3 py-2 rounded hover:bg-blue-50 text-blue-900">سفارش‌های من</a>
                            <a href="#addresses" class="block px-3 py-2 rounded hover:bg-blue-50 text-blue-900">آدرس‌های من</a>
                            <a href="#regs" class="block px-3 py-2 rounded hover:bg-blue-50 text-blue-900">ثبت‌نام‌های من</a>
                            <a href="/Account/ChangePassword.aspx" class="block px-3 py-2 rounded hover:bg-blue-50 text-blue-900">تغییر رمز</a>
                            <a href="/Account/Logout.aspx" class="block px-3 py-2 rounded bg-red-50 text-red-700 hover:bg-red-100">خروج از حساب</a>
                        </nav>
            </div>
                </aside>

                <!-- Content area -->
                <div class="md:col-span-9 space-y-6">
                    <div id="profile" class="bg-white rounded-xl shadow p-6">
                    <h3 class="text-xl font-bold text-blue-900 mb-4">اطلاعات حساب</h3>
                    <p class="mb-1"><strong>کاربر:</strong> <asp:Literal ID="litUsername" runat="server" /></p>
                    <p class="mb-4"><strong>ایمیل:</strong> <asp:Literal ID="litEmail" runat="server" /></p>

                    <div class="space-y-3">
                        <div>
                            <label class="block text-sm mb-1">نام</label>
                            <asp:TextBox ID="txtFirstName" runat="server" CssClass="w-full border rounded px-3 py-2" />
                        </div>
                        <div>
                            <label class="block text-sm mb-1">نام خانوادگی</label>
                            <asp:TextBox ID="txtLastName" runat="server" CssClass="w-full border rounded px-3 py-2" />
                        </div>
                        <div>
                            <label class="block text-sm mb-1">موبایل</label>
                            <asp:TextBox ID="txtPhone" runat="server" CssClass="w-full border rounded px-3 py-2" />
                        </div>
                        <asp:Button ID="btnSaveProfile" runat="server" Text="ذخیره پروفایل" CssClass="bg-green-600 hover:bg-green-700 text-white px-4 py-2 rounded" OnClick="btnSaveProfile_Click" />
                        <a href="/Account/ChangePassword.aspx" class="inline-block bg-indigo-600 hover:bg-indigo-700 text-white px-4 py-2 rounded">تغییر رمز</a>
                        <asp:Literal ID="litProfileMsg" runat="server" />
                    </div>
                </div>

                    <div id="orders" class="bg-white rounded-xl shadow p-6">
                        <h3 class="text-xl font-bold text-blue-900 mb-4">سفارش‌های من</h3>
                        <asp:Literal ID="litOrdersMsg" runat="server" />
                        <asp:Repeater ID="rptOrders" runat="server">
                            <HeaderTemplate><ul class="space-y-3"></HeaderTemplate>
                            <ItemTemplate>
                                <li class="border rounded p-3">
                                    <div class="flex justify-between items-center">
                                        <div>
                                            <div class="font-semibold">سفارش #<%# Eval("Id") %></div>
                                            <div class="text-sm text-gray-600">تاریخ: <%# Eval("CreatedDate", "{0:yyyy/MM/dd HH:mm}") %> - وضعیت: <%# Eval("Status") %></div>
                                        </div>
                                        <div class="text-blue-900 font-bold"><%# Eval("TotalAmount", "{0:N0}") %> تومان</div>
                                    </div>
                                </li>
                            </ItemTemplate>
                            <FooterTemplate></ul></FooterTemplate>
                        </asp:Repeater>
                    </div>

                    <div id="addresses" class="bg-white rounded-xl shadow p-6">
                        <h3 class="text-xl font-bold text-blue-900 mb-4">آدرس‌های من</h3>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
                            <div>
                                <label class="block text-sm mb-1">عنوان آدرس</label>
                                <asp:TextBox ID="txtAddrTitle" runat="server" CssClass="w-full border rounded px-3 py-2" />
                            </div>
                            <div>
                                <label class="block text-sm mb-1">نام گیرنده</label>
                                <asp:TextBox ID="txtAddrReceiver" runat="server" CssClass="w-full border rounded px-3 py-2" />
                            </div>
                            <div>
                                <label class="block text-sm mb-1">استان</label>
                                <asp:TextBox ID="txtAddrProvince" runat="server" CssClass="w-full border rounded px-3 py-2" />
                            </div>
                            <div>
                                <label class="block text-sm mb-1">شهر</label>
                                <asp:TextBox ID="txtAddrCity" runat="server" CssClass="w-full border rounded px-3 py-2" />
                            </div>
                            <div class="md:col-span-2">
                                <label class="block text-sm mb-1">نشانی کامل</label>
                                <asp:TextBox ID="txtAddrAddress" runat="server" TextMode="MultiLine" Rows="2" CssClass="w-full border rounded px-3 py-2" />
                            </div>
                            <div>
                                <label class="block text-sm mb-1">کد پستی</label>
                                <asp:TextBox ID="txtAddrPostal" runat="server" CssClass="w-full border rounded px-3 py-2" />
                            </div>
                            <div class="flex items-center mt-6">
                                <asp:CheckBox ID="chkAddrDefault" runat="server" CssClass="mr-2" />
                                <label class="text-sm">به عنوان آدرس پیش‌فرض</label>
                            </div>
                        </div>
                        <div class="flex gap-2">
                            <asp:HiddenField ID="hdnAddrId" runat="server" />
                            <asp:Button ID="btnSaveAddress" runat="server" Text="ذخیره آدرس" CssClass="bg-green-600 hover:bg-green-700 text-white px-4 py-2 rounded" OnClick="btnSaveAddress_Click" />
                            <asp:Button ID="btnCancelAddress" runat="server" Text="انصراف" CssClass="bg-gray-200 px-4 py-2 rounded" OnClick="btnCancelAddress_Click" />
                            <asp:Literal ID="litAddrMsg" runat="server" />
                        </div>

                        <div class="mt-6">
                            <asp:Repeater ID="rptAddresses" runat="server" OnItemCommand="rptAddresses_ItemCommand">
                                <HeaderTemplate><ul class="space-y-3"></HeaderTemplate>
                                <ItemTemplate>
                                    <li class="border rounded p-3">
                                        <div class="flex justify-between items-start">
                                            <div>
                                                <div class="font-semibold"><%# Eval("Title") %> <%# Convert.ToBoolean(Eval("IsDefault")) ? "<span class='text-xs text-green-700 bg-green-100 px-2 py-1 rounded ml-2'>پیش‌فرض</span>" : "" %></div>
                                                <div class="text-sm text-gray-700 mt-1"><%# Eval("Receiver") %> - <%# Eval("Province") %> / <%# Eval("City") %></div>
                                                <div class="text-sm text-gray-600 mt-1"><%# Eval("AddressLine") %></div>
                                                <div class="text-xs text-gray-500 mt-1">کدپستی: <%# Eval("PostalCode") %></div>
                                            </div>
                                            <div class="flex gap-2">
                                                <asp:LinkButton ID="btnDefault" runat="server" CommandName="setDefault" CommandArgument='<%# Eval("Id") %>' CssClass="text-blue-700">پیش‌فرض</asp:LinkButton>
                                                <asp:LinkButton ID="btnEdit" runat="server" CommandName="edit" CommandArgument='<%# Eval("Id") %>' CssClass="text-indigo-700">ویرایش</asp:LinkButton>
                                                <asp:LinkButton ID="btnDelete" runat="server" CommandName="delete" CommandArgument='<%# Eval("Id") %>' CssClass="text-red-700" OnClientClick="return confirm('حذف این آدرس؟');">حذف</asp:LinkButton>
                                            </div>
                                        </div>
                                    </li>
                                </ItemTemplate>
                                <FooterTemplate></ul></FooterTemplate>
                            </asp:Repeater>
                        </div>
                    </div>

                    <div id="regs" class="bg-white rounded-xl shadow p-6">
                    <h3 class="text-xl font-bold text-blue-900 mb-4">ثبت‌نام‌های مسابقات من</h3>
                    <asp:Repeater ID="rptMyRegs" runat="server">
                        <HeaderTemplate><ul class="space-y-3"></HeaderTemplate>
                        <ItemTemplate>
                            <li class="border rounded p-3 flex justify-between items-center">
                                <div>
                                    <div class="font-semibold"><%# Eval("CompetitionTitle") %></div>
                                    <div class="text-sm text-gray-600">وضعیت: <%# Eval("Status") %> - تاریخ: <%# Eval("CreatedDate", "{0:yyyy/MM/dd}") %></div>
                                </div>
                                <span class="text-blue-700 text-sm"><%# Eval("Phone") %></span>
                            </li>
                        </ItemTemplate>
                        <FooterTemplate></ul></FooterTemplate>
                    </asp:Repeater>
                    </div>
                </div>
            </div>
        </div>
    </section>
</asp:Content>



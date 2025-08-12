<%@ Page Title="مسابقات" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeFile="Competitions.aspx.cs" Inherits="Pardis.Competitions" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="manifest" href="/manifest.webmanifest" />
    <meta name="theme-color" content="#0f172a" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <section class="py-12">
        <div class="container mx-auto px-4">
            <div class="flex items-center justify-between mb-6">
                <h2 class="text-2xl font-bold text-blue-900">مسابقات</h2>
            </div>

            <asp:Repeater ID="rptCompetitions" runat="server">
                <HeaderTemplate><div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6"></HeaderTemplate>
                <ItemTemplate>
                    <div class="bg-white rounded-xl shadow-md overflow-hidden">
                        <div class="h-40 bg-gradient-to-br from-blue-400 to-indigo-600 relative">
                            <asp:Image ID="imgCover" runat="server" ImageUrl='<%# Eval("CoverImageUrl") %>' CssClass="w-full h-full object-cover" />
                            <div class="absolute inset-0 bg-gradient-to-br from-blue-500 to-indigo-700 opacity-30"></div>
                        </div>
                        <div class="p-5">
                            <h3 class="text-xl font-bold text-blue-900 mb-2"><%# Eval("Title") %></h3>
                            <p class="text-gray-600 mb-3"><%# Eval("Location") %></p>
                            <div class="text-sm text-gray-500 mb-4">
                                <span>شروع: <%# Eval("StartDate", "{0:yyyy/MM/dd HH:mm}") %></span>
                                <span class="mr-4">ددلاین: <%# Eval("RegistrationDeadline", "{0:yyyy/MM/dd HH:mm}") %></span>
                            </div>
                            <div class="flex gap-2 items-center">
                                <a href='<%# Eval("Id", "Competition.aspx?id={0}") %>' class="inline-flex items-center bg-gray-100 hover:bg-gray-200 text-blue-900 font-bold py-2 px-4 rounded-lg">جزئیات</a>
                                <%# Convert.ToBoolean(Eval("IsActive")) ? "<a href='" + Eval("Id", "Register.aspx?id={0}") + "' class='inline-flex items-center bg-blue-600 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded-lg'>ثبت نام</a>" : "<span class='text-red-600 font-bold'>مهلت ثبت‌نام به پایان رسید</span>" %>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
                <FooterTemplate></div></FooterTemplate>
            </asp:Repeater>
        </div>
    </section>
</asp:Content>



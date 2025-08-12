<%@ Page Title="پرداخت ثبت‌نام مسابقه" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeFile="CompetitionPay.aspx.cs" Inherits="Pardis.CompetitionPay" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
  <section class="py-12">
    <div class="container mx-auto px-4">
      <div class="max-w-xl mx-auto bg-white rounded-xl shadow p-6">
        <h2 class="text-2xl font-bold text-blue-900 mb-4">پرداخت هزینه ثبت‌نام</h2>
        <asp:Panel ID="pnlInvalid" runat="server" Visible="false" CssClass="bg-red-50 text-red-700 p-3 rounded mb-4">اطلاعات ثبت‌نام یافت نشد.</asp:Panel>
        <asp:Panel ID="pnlPay" runat="server" Visible="false">
          <p class="mb-2">مسابقه: <asp:Literal ID="litCompTitle" runat="server" /></p>
          <div class="mb-4">
            <label class="block mb-2 font-semibold">نوع ثبت‌نام</label>
            <asp:RadioButtonList ID="rblGroupType" runat="server" CssClass="space-y-2" AutoPostBack="true" OnSelectedIndexChanged="rblGroupType_SelectedIndexChanged">
              <asp:ListItem Value="single" Selected="True">انفرادی</asp:ListItem>
              <asp:ListItem Value="double">دوبل</asp:ListItem>
            </asp:RadioButtonList>
          </div>
          <div class="mb-2 text-sm text-gray-700">هزینه‌ها:</div>
          <ul class="mb-4 list-disc pr-6 text-gray-800">
            <li>انفرادی: <span class="font-bold text-blue-900"><asp:Literal ID="litSingle" runat="server" /></span> تومان</li>
            <li>دوبل: <span class="font-bold text-blue-900"><asp:Literal ID="litDouble" runat="server" /></span> تومان</li>
          </ul>
          <p class="mb-4">مبلغ قابل پرداخت: <span class="font-bold text-blue-900"><asp:Literal ID="litAmount" runat="server" /></span> تومان</p>
          <asp:Button ID="btnPay" runat="server" Text="پرداخت و نهایی‌سازی" CssClass="bg-green-600 hover:bg-green-700 text-white font-bold py-2 px-4 rounded" OnClick="btnPay_Click" />
          <asp:Literal ID="litMsg" runat="server" />
        </asp:Panel>
      </div>
    </div>
  </section>
</asp:Content>



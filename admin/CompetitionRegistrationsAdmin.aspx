<%@ Page Title="ثبت‌نام‌های مسابقات" Language="C#" MasterPageFile="~/admin/AdminMaster.Master" AutoEventWireup="true" CodeFile="CompetitionRegistrationsAdmin.aspx.cs" Inherits="shop1.Admin.CompetitionRegistrationsAdmin" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container-fluid px-2">
        <div class="card">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h3 class="card-title mb-0">لیست ثبت‌نام‌ها</h3>
                <a href="CompetitionsAdmin.aspx" class="btn btn-secondary btn-sm">مدیریت مسابقات</a>
            </div>
            <div class="card-body p-0">
                <asp:GridView ID="gvRegs" runat="server" AutoGenerateColumns="False" CssClass="table table-striped table-hover mb-0" DataKeyNames="Id" OnRowCommand="gvRegs_RowCommand">
                    <Columns>
                        <asp:BoundField DataField="Id" HeaderText="شناسه" />
                        <asp:BoundField DataField="CompetitionTitle" HeaderText="مسابقه" />
                        <asp:BoundField DataField="FullName" HeaderText="نام" />
                        <asp:BoundField DataField="Phone" HeaderText="تلفن" />
                        <asp:BoundField DataField="Age" HeaderText="سن" />
                        <asp:BoundField DataField="Gender" HeaderText="جنسیت" />
                        <asp:BoundField DataField="Status" HeaderText="وضعیت" />
                        <asp:TemplateField HeaderText="بیمه">
                            <ItemTemplate>
                                <div>
                                    <%# string.IsNullOrEmpty(Eval("InsuranceImageUrl") as string) 
                                        ? "—" 
                                        : ("<img src='" + Eval("InsuranceImageUrl") + "' alt='بیمه' style='width:60px;height:40px;object-fit:cover;border-radius:6px;cursor:pointer' onerror=\"this.style.display='none'\" onclick=\"showInsuranceModal('" + Eval("InsuranceImageUrl") + "')\"/>") %>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="CreatedDate" HeaderText="تاریخ" DataFormatString="{0:yyyy/MM/dd HH:mm}" />
                        <asp:TemplateField HeaderText="عملیات">
                            <ItemTemplate>
                                <asp:LinkButton ID="lnkApprove" runat="server" CommandName="approve" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm btn-success">تایید</asp:LinkButton>
                                <asp:LinkButton ID="lnkReject" runat="server" CommandName="reject" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm btn-danger">رد</asp:LinkButton>
                                <asp:LinkButton ID="lnkDelete" runat="server" CommandName="deleteReg" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm btn-secondary" OnClientClick="return confirm('حذف شود؟');">حذف</asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>
    <style>
        .modal-overlay {position:fixed; inset:0; background:rgba(0,0,0,.6); display:none; align-items:center; justify-content:center; z-index:9999}
        .modal-overlay.active {display:flex}
        .modal-box {background:#fff; border-radius:8px; padding:8px; max-width:95vw; max-height:95vh}
        .modal-box img {max-width:90vw; max-height:85vh; display:block}
        .modal-actions {text-align:left; margin-top:6px}
        .modal-close {background:#ef4444; color:#fff; border:none; border-radius:6px; padding:6px 10px; cursor:pointer}
    </style>
    <div id="insuranceModal" class="modal-overlay" onclick="hideInsuranceModal(event)">
        <div class="modal-box">
            <img id="insuranceModalImg" src="" alt="تصویر بیمه" />
            <div class="modal-actions">
                <button type="button" class="modal-close" onclick="closeInsuranceModal()">بستن</button>
            </div>
        </div>
    </div>
    <script>
        function showInsuranceModal(src) {
            var modal = document.getElementById('insuranceModal');
            var img = document.getElementById('insuranceModalImg');
            img.src = src; modal.classList.add('active');
        }
        function closeInsuranceModal() {
            var modal = document.getElementById('insuranceModal');
            modal.classList.remove('active');
        }
        function hideInsuranceModal(e) {
            if (e.target && e.target.id === 'insuranceModal') closeInsuranceModal();
        }
    </script>
</asp:Content>



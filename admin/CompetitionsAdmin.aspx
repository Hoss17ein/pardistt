<%@ Page Title="مدیریت مسابقات" Language="C#" MasterPageFile="~/admin/AdminMaster.Master" AutoEventWireup="true" CodeFile="CompetitionsAdmin.aspx.cs" Inherits="shop1.Admin.CompetitionsAdmin" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container-fluid px-2">
        <div class="card mb-4">
            <div class="card-header"><h3 class="card-title mb-0">افزودن/ویرایش مسابقه</h3></div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label>عنوان</label>
                            <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control" />
                            <asp:RequiredFieldValidator ID="rfvTitle" runat="server" ControlToValidate="txtTitle" ErrorMessage="عنوان الزامی است" CssClass="text-danger small" Display="Dynamic" />
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label>محل برگزاری</label>
                            <asp:TextBox ID="txtLocation" runat="server" CssClass="form-control" />
                        </div>
                    </div>

                    <div class="col-md-6">
                        <div class="form-group">
                            <label>تاریخ شروع</label>
                            <asp:TextBox ID="txtStartDate" runat="server" CssClass="form-control" placeholder="YYYY-MM-DD HH:MM" />
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label>ددلاین ثبت‌نام</label>
                            <asp:TextBox ID="txtDeadline" runat="server" CssClass="form-control" placeholder="YYYY-MM-DD HH:MM" />
                        </div>
                    </div>

                    <div class="col-12">
                        <div class="form-group">
                            <label>توضیحات</label>
                            <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control" />
                        </div>
                    </div>

                    <div class="col-md-3">
                        <div class="form-group">
                            <label>هزینه انفرادی (تومان)</label>
                            <asp:TextBox ID="txtSingleFee" runat="server" CssClass="form-control" />
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="form-group">
                            <label>هزینه دوبل (تومان)</label>
                            <asp:TextBox ID="txtDoubleFee" runat="server" CssClass="form-control" />
                        </div>
                    </div>

                    <div class="col-md-6">
                        <div class="form-group">
                            <label>کاور</label>
                            <asp:FileUpload ID="fuCover" runat="server" CssClass="form-control-file" />
                            <small class="text-muted">(jpg/png)</small>
                        </div>
                    </div>
                    <div class="col-md-3 d-flex align-items-center">
                        <div class="form-check mt-4">
                            <asp:CheckBox ID="chkIsActive" runat="server" CssClass="form-check-input" Checked="true" />
                            <label class="form-check-label" for="chkIsActive">فعال</label>
                        </div>
                    </div>
                </div>
                <div class="mt-2">
                    <asp:Button ID="btnSave" runat="server" Text="ذخیره" CssClass="btn btn-success" OnClick="btnSave_Click" />
                    <asp:Button ID="btnCancel" runat="server" Text="انصراف" CssClass="btn btn-secondary ml-2" OnClick="btnCancel_Click" />
                </div>
                <asp:HiddenField ID="hdnId" runat="server" />
            </div>
        </div>

        <div class="card">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h3 class="card-title mb-0">لیست مسابقات</h3>
                <a href="CompetitionRegistrationsAdmin.aspx" class="btn btn-primary btn-sm">مشاهده ثبت‌نام‌ها</a>
            </div>
            <div class="card-body p-0">
                <asp:GridView ID="gvCompetitions" runat="server" AutoGenerateColumns="False" CssClass="table table-striped table-hover mb-0" DataKeyNames="Id" OnRowCommand="gvCompetitions_RowCommand">
                    <Columns>
                        <asp:BoundField DataField="Id" HeaderText="شناسه" />
                        <asp:BoundField DataField="Title" HeaderText="عنوان" />
                        <asp:BoundField DataField="Location" HeaderText="محل" />
                        <asp:BoundField DataField="StartDate" HeaderText="شروع" DataFormatString="{0:yyyy/MM/dd HH:mm}" />
                        <asp:BoundField DataField="RegistrationDeadline" HeaderText="ددلاین" DataFormatString="{0:yyyy/MM/dd HH:mm}" />
                        <asp:TemplateField HeaderText="وضعیت">
                            <ItemTemplate>
                                <span class='<%# Convert.ToBoolean(Eval("IsActive")) ? "badge badge-success" : "badge badge-danger" %>'>
                                    <%# Convert.ToBoolean(Eval("IsActive")) ? "فعال" : "غیرفعال" %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="SingleFee" HeaderText="انفرادی" />
                        <asp:BoundField DataField="DoubleFee" HeaderText="دوبل" />
                        <asp:TemplateField HeaderText="عملیات">
                            <ItemTemplate>
                                <asp:LinkButton ID="lnkEdit" runat="server" CommandName="editItem" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm btn-info">ویرایش</asp:LinkButton>
                                <asp:LinkButton ID="lnkDelete" runat="server" CommandName="deleteItem" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm btn-danger" OnClientClick="return confirm('حذف شود؟');">حذف</asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>
</asp:Content>



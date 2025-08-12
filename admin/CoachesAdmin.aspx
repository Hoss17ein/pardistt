<%@ Page Title="مدیریت مربیان" Language="C#" MasterPageFile="~/admin/AdminMaster.Master" AutoEventWireup="true" CodeFile="CoachesAdmin.aspx.cs" Inherits="shop1.Admin.CoachesAdmin" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="content-wrapper">
        <div class="content-header">
            <div class="container-fluid">
                <div class="row mb-2">
                    <div class="col-sm-6">
                        <h1 class="m-0">مدیریت مربیان</h1>
                    </div>
                </div>
            </div>
        </div>

        <section class="content">
            <div class="container-fluid">
                <!-- فرم افزودن/ویرایش مربی -->
                <div class="row">
                    <div class="col-md-6">
                        <div class="card card-info">
                            <div class="card-header">
                                <h3 class="card-title">
                                    <asp:Literal ID="litFormTitle" runat="server">افزودن مربی جدید</asp:Literal>
                                </h3>
                            </div>
                            <div class="card-body">
                                <asp:HiddenField ID="hfCoachId" runat="server" />
                                
                                <div class="form-group">
                                    <label>نام و نام خانوادگی</label>
                                    <asp:TextBox ID="txtName" runat="server" CssClass="form-control" placeholder="نام کامل مربی"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvName" runat="server" ControlToValidate="txtName" 
                                        ErrorMessage="نام مربی الزامی است" CssClass="text-danger" Display="Dynamic"></asp:RequiredFieldValidator>
                                </div>

                                <div class="form-group">
                                    <label>سمت</label>
                                    <asp:TextBox ID="txtPosition" runat="server" CssClass="form-control" placeholder="مثال: مربی ارشد، مربی بانوان"></asp:TextBox>
                                </div>

                                <div class="form-group">
                                    <label>تخصص</label>
                                    <asp:TextBox ID="txtSpecialty" runat="server" CssClass="form-control" placeholder="مثال: تکنیک پیشرفته، آموزش پایه"></asp:TextBox>
                                </div>

                                <div class="form-group">
                                    <label>رده سنی</label>
                                    <asp:DropDownList ID="ddlAgeGroup" runat="server" CssClass="form-control">
                                        <asp:ListItem Value="همه سنین">همه سنین</asp:ListItem>
                                        <asp:ListItem Value="کودکان">کودکان</asp:ListItem>
                                        <asp:ListItem Value="نونهالان">نونهالان</asp:ListItem>
                                        <asp:ListItem Value="نوجوانان">نوجوانان</asp:ListItem>
                                        <asp:ListItem Value="بزرگسالان">بزرگسالان</asp:ListItem>
                                        <asp:ListItem Value="بانوان">بانوان</asp:ListItem>
                                    </asp:DropDownList>
                                </div>

                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>امتیاز (1-5)</label>
                                            <asp:DropDownList ID="ddlRating" runat="server" CssClass="form-control">
                                                <asp:ListItem Value="1">1 ستاره</asp:ListItem>
                                                <asp:ListItem Value="2">2 ستاره</asp:ListItem>
                                                <asp:ListItem Value="3">3 ستاره</asp:ListItem>
                                                <asp:ListItem Value="4">4 ستاره</asp:ListItem>
                                                <asp:ListItem Value="5" Selected="True">5 ستاره</asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>سابقه (سال)</label>
                                            <asp:TextBox ID="txtExperience" runat="server" CssClass="form-control" placeholder="0" TextMode="Number"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label>توضیحات</label>
                                    <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" TextMode="MultiLine" 
                                        Rows="3" placeholder="معرفی مربی، سوابق و دستاوردها"></asp:TextBox>
                                </div>

                                <div class="form-group">
                                    <label>تصویر مربی</label>
                                    <asp:FileUpload ID="fuImage" runat="server" CssClass="form-control-file" />
                                    <asp:Literal ID="litCurrentImage" runat="server"></asp:Literal>
                                </div>

                                <div class="form-group">
                                    <asp:Button ID="btnSave" runat="server" Text="ذخیره" CssClass="btn btn-info" 
                                        OnClick="btnSave_Click" />
                                    <asp:Button ID="btnCancel" runat="server" Text="انصراف" CssClass="btn btn-secondary" 
                                        OnClick="btnCancel_Click" CausesValidation="false" />
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- لیست مربیان -->
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-header">
                                <h3 class="card-title">لیست مربیان</h3>
                            </div>
                            <div class="card-body">
                                <asp:Repeater ID="rptCoaches" runat="server" OnItemCommand="rptCoaches_ItemCommand">
                                    <ItemTemplate>
                                        <div class="card mb-3">
                                            <div class="row no-gutters">
                                                <div class="col-md-4">
                                                    <img src="../<%# Eval("ImageUrl") %>" class="card-img" style="height: 120px; object-fit: cover;" alt="<%# Eval("Name") %>">
                                                </div>
                                                <div class="col-md-8">
                                                    <div class="card-body p-2">
                                                        <h6 class="card-title"><%# Eval("Name") %></h6>
                                                        <p class="card-text small">
                                                            <strong>سمت:</strong> <%# Eval("Position") %><br>
                                                            <strong>تخصص:</strong> <%# Eval("Specialty") %><br>
                                                            <strong>سابقه:</strong> <%# Eval("Experience") %> سال<br>
                                                            <strong>امتیاز:</strong> 
                                                            <%# new string('★', Convert.ToInt32(Eval("Rating") ?? 5)) %>
                                                        </p>
                                                        <div class="mt-2">
                                                            <asp:Button ID="btnEdit" runat="server" Text="ویرایش" CssClass="btn btn-sm btn-warning"
                                                                CommandName="EditCoach" CommandArgument='<%# Eval("Id") %>' />
                                                            <asp:Button ID="btnDelete" runat="server" Text="حذف" CssClass="btn btn-sm btn-danger"
                                                                CommandName="DeleteCoach" CommandArgument='<%# Eval("Id") %>' 
                                                                OnClientClick="return confirm('آیا مطمئن هستید؟');" />
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </div>
</asp:Content>

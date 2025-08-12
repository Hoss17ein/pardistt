<%@ Page Title="" Language="C#" MasterPageFile="~/admin/AdminMaster.Master" AutoEventWireup="true" CodeFile="FeaturesAdmin.aspx.cs" Inherits="Pardis.FeaturesAdmin" %>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container-fluid px-4">
        <h1 class="mt-4 mb-4">مدیریت ویژگی‌های باشگاه</h1>

        <!-- Add/Edit Form -->
        <div class="card mb-4">
            <div class="card-header">
                <h2 class="card-title mb-0"><asp:Literal ID="litFormTitle" runat="server" Text="افزودن ویژگی جدید" /></h2>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label>عنوان ویژگی</label>
                            <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control" placeholder="عنوان ویژگی را وارد کنید"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvTitle" runat="server" ControlToValidate="txtTitle"
                                ErrorMessage="عنوان ویژگی الزامی است" CssClass="text-danger small" Display="Dynamic"></asp:RequiredFieldValidator>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label>ترتیب نمایش</label>
                            <asp:TextBox ID="txtSortOrder" runat="server" TextMode="Number" CssClass="form-control" placeholder="0"></asp:TextBox>
                        </div>
                    </div>

                    <div class="col-12">
                        <div class="form-group">
                            <label>توضیحات</label>
                            <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control" placeholder="توضیحات ویژگی را وارد کنید"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvDescription" runat="server" ControlToValidate="txtDescription"
                                ErrorMessage="توضیحات الزامی است" CssClass="text-danger small" Display="Dynamic"></asp:RequiredFieldValidator>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="form-group">
                            <label>رنگ حاشیه</label>
                            <asp:DropDownList ID="ddlBorderColor" runat="server" CssClass="form-control">
                                <asp:ListItem Text="آبی" Value="blue-600" />
                                <asp:ListItem Text="نیلی" Value="indigo-600" />
                                <asp:ListItem Text="بنفش" Value="purple-600" />
                                <asp:ListItem Text="صورتی" Value="pink-600" />
                                <asp:ListItem Text="سبز" Value="green-600" />
                                <asp:ListItem Text="قرمز" Value="red-600" />
                                <asp:ListItem Text="نارنجی" Value="orange-600" />
                                <asp:ListItem Text="زرد" Value="yellow-600" />
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="form-group">
                            <label>رنگ پس‌زمینه آیکون</label>
                            <asp:DropDownList ID="ddlBackgroundColor" runat="server" CssClass="form-control">
                                <asp:ListItem Text="آبی روشن" Value="blue-100" />
                                <asp:ListItem Text="نیلی روشن" Value="indigo-100" />
                                <asp:ListItem Text="بنفش روشن" Value="purple-100" />
                                <asp:ListItem Text="صورتی روشن" Value="pink-100" />
                                <asp:ListItem Text="سبز روشن" Value="green-100" />
                                <asp:ListItem Text="قرمز روشن" Value="red-100" />
                                <asp:ListItem Text="نارنجی روشن" Value="orange-100" />
                                <asp:ListItem Text="زرد روشن" Value="yellow-100" />
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="form-group">
                            <label>رنگ آیکون</label>
                            <asp:DropDownList ID="ddlIconColor" runat="server" CssClass="form-control">
                                <asp:ListItem Text="آبی" Value="blue-600" />
                                <asp:ListItem Text="نیلی" Value="indigo-600" />
                                <asp:ListItem Text="بنفش" Value="purple-600" />
                                <asp:ListItem Text="صورتی" Value="pink-600" />
                                <asp:ListItem Text="سبز" Value="green-600" />
                                <asp:ListItem Text="قرمز" Value="red-600" />
                                <asp:ListItem Text="نارنجی" Value="orange-600" />
                                <asp:ListItem Text="زرد" Value="yellow-600" />
                            </asp:DropDownList>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <div class="form-group">
                            <label>مسیر آیکون SVG</label>
                            <asp:TextBox ID="txtIconPath" runat="server" CssClass="form-control" placeholder="مسیر آیکون SVG را وارد کنید"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvIconPath" runat="server" ControlToValidate="txtIconPath"
                                ErrorMessage="مسیر آیکون الزامی است" CssClass="text-danger small" Display="Dynamic"></asp:RequiredFieldValidator>
                        </div>
                    </div>
                    <div class="col-md-6 d-flex align-items-center">
                        <div class="form-check mt-4">
                            <asp:CheckBox ID="chkIsActive" runat="server" Checked="true" CssClass="form-check-input" />
                            <label class="form-check-label" for="chkIsActive">فعال</label>
                        </div>
                    </div>
                </div>

                <div class="mt-3">
                    <asp:Button ID="btnSave" runat="server" Text="ذخیره" CssClass="btn btn-success" OnClick="btnSave_Click" />
                    <asp:Button ID="btnCancel" runat="server" Text="انصراف" CssClass="btn btn-secondary ml-2" OnClick="btnCancel_Click" />
                </div>
            </div>
        </div>

        <!-- Features List -->
        <div class="card">
            <div class="card-header">
                <h2 class="card-title mb-0">لیست ویژگی‌ها</h2>
            </div>
            <div class="card-body p-0">
                <asp:GridView ID="gvFeatures" runat="server" AutoGenerateColumns="False"
                    CssClass="table table-striped table-hover mb-0"
                    OnRowCommand="gvFeatures_RowCommand"
                    OnRowDataBound="gvFeatures_RowDataBound"
                    DataKeyNames="Id">
                    <Columns>
                        <asp:BoundField DataField="Id" HeaderText="شناسه" />
                        <asp:BoundField DataField="Title" HeaderText="عنوان" />
                        <asp:BoundField DataField="Description" HeaderText="توضیحات" />
                        <asp:BoundField DataField="SortOrder" HeaderText="ترتیب" />
                        <asp:TemplateField HeaderText="وضعیت">
                            <ItemTemplate>
                                <span class='<%# Convert.ToBoolean(Eval("IsActive")) ? "badge badge-success" : "badge badge-danger" %>'>
                                    <%# Convert.ToBoolean(Eval("IsActive")) ? "فعال" : "غیرفعال" %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="عملیات">
                            <ItemTemplate>
                                <asp:LinkButton ID="lnkEdit" runat="server" CommandName="EditFeature" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm btn-primary">ویرایش</asp:LinkButton>
                                <asp:LinkButton ID="lnkDelete" runat="server" CommandName="DeleteFeature" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm btn-danger" OnClientClick="return confirm('آیا از حذف این ویژگی اطمینان دارید؟');">حذف</asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>

        <!-- Hidden Fields -->
        <asp:HiddenField ID="hdnFeatureId" runat="server" />
    </div>
</asp:Content>

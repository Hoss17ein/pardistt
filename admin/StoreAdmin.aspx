<%@ Page Title="مدیریت محصولات" Language="C#" MasterPageFile="~/admin/AdminMaster.Master" AutoEventWireup="true" CodeFile="StoreAdmin.aspx.cs" Inherits="shop1.Admin.StoreAdmin" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container-fluid px-2">
        <div class="card mb-4">
            <div class="card-header"><h3 class="card-title mb-0">افزودن/ویرایش محصول</h3></div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label>نام محصول</label>
                            <asp:TextBox ID="txtName" runat="server" CssClass="form-control" />
                            <asp:RequiredFieldValidator ID="rfvName" runat="server" ControlToValidate="txtName" ErrorMessage="نام الزامی است" CssClass="text-danger small" Display="Dynamic" />
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="form-group">
                            <label>قیمت (تومان)</label>
                            <asp:TextBox ID="txtPrice" runat="server" TextMode="Number" CssClass="form-control" />
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="form-group">
                            <label>دسته‌بندی</label>
                            <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-control">
                                <asp:ListItem Text="— انتخاب کنید —" Value="" />
                                <asp:ListItem Text="پوشاک" Value="Clothing" />
                                <asp:ListItem Text="پوشاک / جوراب" Value="Clothing.Socks" />
                                <asp:ListItem Text="پوشاک / کفش" Value="Clothing.Shoes" />
                                <asp:ListItem Text="پوشاک / تیشرت" Value="Clothing.Tshirt" />
                                <asp:ListItem Text="پوشاک / شلوارک" Value="Clothing.Shorts" />
                                <asp:ListItem Text="میز پینگ پنگ" Value="Tables" />
                                <asp:ListItem Text="توپ ها" Value="Balls" />
                                <asp:ListItem Text="چوب ها" Value="Blades" />
                                <asp:ListItem Text="رویه ها" Value="Rubbers" />
                                <asp:ListItem Text="لوازم جانبی" Value="Accessories" />
                                <asp:ListItem Text="راکت آماده" Value="ReadyRackets" />
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="form-group">
                            <label>موجودی</label>
                            <asp:TextBox ID="txtStock" runat="server" TextMode="Number" CssClass="form-control" />
                        </div>
                    </div>
                    <div class="col-12">
                        <div class="form-group">
                            <label>توضیحات</label>
                            <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control" />
                        </div>
                    </div>
                    <div class="col-md-12">
                        <div class="form-group">
                            <label>تصاویر محصول (حداقل 1 و حداکثر 5)</label>
                            <div class="row">
                                <div class="col-6 col-md-4 col-lg-2 mb-3">
                                    <div class="border rounded p-2 text-center">
                                        <asp:FileUpload ID="fuImg1" runat="server" CssClass="form-control-file mb-2" />
                                        <img id="imgPrev1" alt="" style="display:none;height:90px;width:100%;object-fit:cover;border-radius:6px;" />
                                        <asp:TextBox ID="txtCap1" runat="server" CssClass="form-control form-control-sm mt-2" placeholder="توضیح تصویر ۱ (اختیاری)" />
                                    </div>
                                </div>
                                <div class="col-6 col-md-4 col-lg-2 mb-3">
                                    <div class="border rounded p-2 text-center">
                                        <asp:FileUpload ID="fuImg2" runat="server" CssClass="form-control-file mb-2" />
                                        <img id="imgPrev2" alt="" style="display:none;height:90px;width:100%;object-fit:cover;border-radius:6px;" />
                                        <asp:TextBox ID="txtCap2" runat="server" CssClass="form-control form-control-sm mt-2" placeholder="توضیح تصویر ۲ (اختیاری)" />
                                    </div>
                                </div>
                                <div class="col-6 col-md-4 col-lg-2 mb-3">
                                    <div class="border rounded p-2 text-center">
                                        <asp:FileUpload ID="fuImg3" runat="server" CssClass="form-control-file mb-2" />
                                        <img id="imgPrev3" alt="" style="display:none;height:90px;width:100%;object-fit:cover;border-radius:6px;" />
                                        <asp:TextBox ID="txtCap3" runat="server" CssClass="form-control form-control-sm mt-2" placeholder="توضیح تصویر ۳ (اختیاری)" />
                                    </div>
                                </div>
                                <div class="col-6 col-md-4 col-lg-2 mb-3">
                                    <div class="border rounded p-2 text-center">
                                        <asp:FileUpload ID="fuImg4" runat="server" CssClass="form-control-file mb-2" />
                                        <img id="imgPrev4" alt="" style="display:none;height:90px;width:100%;object-fit:cover;border-radius:6px;" />
                                        <asp:TextBox ID="txtCap4" runat="server" CssClass="form-control form-control-sm mt-2" placeholder="توضیح تصویر ۴ (اختیاری)" />
                                    </div>
                                </div>
                                <div class="col-6 col-md-4 col-lg-2 mb-3">
                                    <div class="border rounded p-2 text-center">
                                        <asp:FileUpload ID="fuImg5" runat="server" CssClass="form-control-file mb-2" />
                                        <img id="imgPrev5" alt="" style="display:none;height:90px;width:100%;object-fit:cover;border-radius:6px;" />
                                        <asp:TextBox ID="txtCap5" runat="server" CssClass="form-control form-control-sm mt-2" placeholder="توضیح تصویر ۵ (اختیاری)" />
                                    </div>
                                </div>
                            </div>
                            <small class="text-muted">فرمت‌های مجاز: jpg, jpeg, png</small>
                            <asp:Literal ID="litImgMsg" runat="server" />
                        </div>
                    </div>
                    <div class="col-md-3 d-flex align-items-center">
                        <div class="form-check mt-4">
                            <asp:CheckBox ID="chkActive" runat="server" Checked="true" CssClass="form-check-input" />
                            <label class="form-check-label" for="chkActive">فعال</label>
                        </div>
                    </div>
                </div>
                <div class="mt-2">
                    <asp:Button ID="btnSave" runat="server" Text="ذخیره" CssClass="btn btn-success" OnClick="btnSave_Click" />
                    <asp:Button ID="btnCancel" runat="server" Text="انصراف" CssClass="btn btn-secondary ml-2" OnClick="btnCancel_Click" />
                    <asp:HiddenField ID="hdnId" runat="server" />
                </div>
            </div>
        </div>

        <div class="card">
            <div class="card-header"><h3 class="card-title mb-0">لیست محصولات</h3></div>
            <div class="card-body p-0">
                <asp:GridView ID="gvProducts" runat="server" AutoGenerateColumns="False" CssClass="table table-striped table-hover mb-0" DataKeyNames="Id" OnRowCommand="gvProducts_RowCommand">
                    <Columns>
                        <asp:BoundField DataField="Id" HeaderText="شناسه" />
                        <asp:BoundField DataField="Name" HeaderText="نام" />
                        <asp:BoundField DataField="Category" HeaderText="دسته" />
                        <asp:BoundField DataField="Price" HeaderText="قیمت" DataFormatString="{0:N0}" />
                        <asp:BoundField DataField="Stock" HeaderText="موجودی" />
                        <asp:TemplateField HeaderText="وضعیت">
                            <ItemTemplate>
                                <span class='<%# Convert.ToBoolean(Eval("IsActive")) ? "badge badge-success" : "badge badge-danger" %>'>
                                    <%# Convert.ToBoolean(Eval("IsActive")) ? "فعال" : "غیرفعال" %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>
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

    <script type="text/javascript">
    (function () {
        function bindPreview(inputId, imgId) {
            var inp = document.getElementById(inputId);
            var img = document.getElementById(imgId);
            if (!inp || !img) return;
            inp.addEventListener('change', function () {
                if (this.files && this.files[0]) {
                    var reader = new FileReader();
                    reader.onload = function (e) {
                        img.src = e.target.result;
                        img.style.display = 'block';
                    };
                    reader.readAsDataURL(this.files[0]);
                } else {
                    img.src = '';
                    img.style.display = 'none';
                }
            });
        }
        bindPreview('<%= fuImg1.ClientID %>', 'imgPrev1');
        bindPreview('<%= fuImg2.ClientID %>', 'imgPrev2');
        bindPreview('<%= fuImg3.ClientID %>', 'imgPrev3');
        bindPreview('<%= fuImg4.ClientID %>', 'imgPrev4');
        bindPreview('<%= fuImg5.ClientID %>', 'imgPrev5');
    })();
    </script>

</asp:Content>

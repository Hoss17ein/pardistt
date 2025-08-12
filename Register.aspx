<%@ Page Title="ثبت‌نام مسابقه" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeFile="Register.aspx.cs" Inherits="Pardis.Register" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="manifest" href="/manifest.webmanifest" />
    <meta name="theme-color" content="#0f172a" />
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/persian-datepicker@1.2.0/dist/css/persian-datepicker.min.css" />
    <style>
        .registration-form {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 2rem 0;
        }
        .form-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        .form-header {
            background: linear-gradient(135deg, #1e3a8a 0%, #3b82f6 100%);
            color: white;
            padding: 2rem;
            text-align: center;
        }
        .form-body {
            padding: 2rem;
        }
        .form-group {
            margin-bottom: 1.5rem;
        }
        .form-label {
            display: block;
            font-weight: 600;
            color: #374151;
            margin-bottom: 0.5rem;
            font-size: 0.9rem;
        }
        .form-input {
            width: 100%;
            padding: 0.75rem 1rem;
            border: 2px solid #e5e7eb;
            border-radius: 10px;
            font-size: 1rem;
            transition: all 0.3s ease;
            background: #f9fafb;
        }
        .form-input:focus {
            outline: none;
            border-color: #3b82f6;
            background: white;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        }
        .form-select {
            width: 100%;
            padding: 0.75rem 1rem;
            border: 2px solid #e5e7eb;
            border-radius: 10px;
            font-size: 1rem;
            background: #f9fafb;
            transition: all 0.3s ease;
        }
        .form-select:focus {
            outline: none;
            border-color: #3b82f6;
            background: white;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        }
        .file-upload {
            position: relative;
            display: inline-block;
            width: 100%;
        }
        .file-upload input[type=file] {
            position: absolute;
            opacity: 0;
            width: 100%;
            height: 100%;
            cursor: pointer;
        }
        .file-upload-label {
            display: block;
            padding: 0.75rem 1rem;
            border: 2px dashed #d1d5db;
            border-radius: 10px;
            text-align: center;
            background: #f9fafb;
            color: #6b7280;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .file-upload-label:hover {
            border-color: #3b82f6;
            background: #eff6ff;
            color: #3b82f6;
        }
        .registration-type {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
            margin-bottom: 1.5rem;
        }
        .type-option {
            position: relative;
            cursor: pointer;
        }
        .type-option input[type="radio"] {
            position: absolute;
            opacity: 0;
        }
        .type-option label {
            display: block;
            padding: 1rem;
            border: 2px solid #e5e7eb;
            border-radius: 10px;
            text-align: center;
            background: #f9fafb;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .type-option input[type="radio"]:checked + label {
            border-color: #3b82f6;
            background: #eff6ff;
            color: #1e40af;
            font-weight: 600;
        }
        .submit-btn {
            width: 100%;
            padding: 1rem 2rem;
            background: linear-gradient(135deg, #3b82f6 0%, #1e40af 100%);
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(59, 130, 246, 0.3);
        }
        .submit-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(59, 130, 246, 0.4);
        }
        .error-message {
            color: #dc2626;
            font-size: 0.875rem;
            margin-top: 0.25rem;
        }
        .success-message {
            color: #059669;
            font-size: 0.875rem;
            margin-top: 0.25rem;
        }
        .competition-info {
            background: #f3f4f6;
            border-radius: 10px;
            padding: 1rem;
            margin-bottom: 1.5rem;
        }
        .competition-title {
            font-size: 1.25rem;
            font-weight: 700;
            color: #1f2937;
            margin-bottom: 0.5rem;
        }
        .competition-details {
            color: #6b7280;
            font-size: 0.875rem;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <section class="registration-form">
        <div class="container mx-auto px-4">
            <div class="max-w-2xl mx-auto">
                <div class="form-container">
                    <div class="form-header">
                        <h1 class="text-3xl font-bold mb-2">ثبت نام مسابقه</h1>
                        <p class="text-blue-100">فرم ثبت نام آنلاین مسابقات باشگاه</p>
                    </div>
                    
                    <div class="form-body">
                        <!-- اطلاعات مسابقه -->
                        <div class="competition-info">
                            <div class="competition-title">
                                <asp:Literal ID="litCompTitle" runat="server" />
                            </div>
                            <div class="competition-details">
                                <asp:Literal ID="litCompDetails" runat="server" />
                            </div>
                        </div>

                        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
                            <!-- نوع ثبت نام -->
                            <div class="form-group">
                                <label class="form-label">نوع ثبت نام *</label>
                                <div class="registration-type">
                                    <div class="type-option">
                                        <asp:RadioButton ID="rbSingleGroup" runat="server" GroupName="RegistrationType" Value="Single" Checked="true" ClientIDMode="Static" />
                                        <label id="lblSingle" runat="server" for="rbSingleGroup">
                                            <div class="text-lg font-semibold mb-1">انفرادی</div>
                                            <div class="text-sm text-gray-600">ثبت‌نام یک جا</div>
                                            <div class="text-xs text-blue-700 mt-1">هزینه: <span class="font-bold"><asp:Literal ID="litSingleFee" runat="server" /></span> تومان</div>
                                        </label>
                                    </div>
                                    <div class="type-option">
                                        <asp:RadioButton ID="rbDoubleGroup" runat="server" GroupName="RegistrationType" Value="Double" ClientIDMode="Static" />
                                        <label id="lblDouble" runat="server" for="rbDoubleGroup">
                                            <div class="text-lg font-semibold mb-1">انفرادی</div>
                                            <div class="text-sm text-gray-600">ثبت‌نام دو جا</div>
                                            <div class="text-xs text-blue-700 mt-1">هزینه: <span class="font-bold"><asp:Literal ID="litDoubleFee" runat="server" /></span> تومان</div>
                                        </label>
                                    </div>
                                </div>
                            </div>

                            <!-- اطلاعات شخصی -->
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                                <div class="form-group">
                                    <label class="form-label">نام *</label>
                                    <asp:TextBox ID="txtFirstName" runat="server" CssClass="form-input" placeholder="نام خود را وارد کنید" />
                                    <asp:RequiredFieldValidator ID="rfvFirst" runat="server" ControlToValidate="txtFirstName" 
                                        ErrorMessage="نام الزامی است" CssClass="error-message" Display="Dynamic" />
                                </div>
                                <div class="form-group">
                                    <label class="form-label">نام خانوادگی *</label>
                                    <asp:TextBox ID="txtLastName" runat="server" CssClass="form-input" placeholder="نام خانوادگی خود را وارد کنید" />
                                    <asp:RequiredFieldValidator ID="rfvLast" runat="server" ControlToValidate="txtLastName" 
                                        ErrorMessage="نام خانوادگی الزامی است" CssClass="error-message" Display="Dynamic" />
                                </div>
                            </div>

                            

                            <!-- اطلاعات تماس -->
                            <div class="form-group">
                                <label class="form-label">شماره تماس *</label>
                                <asp:TextBox ID="txtPhone" runat="server" CssClass="form-input" placeholder="مثال: 09123456789" />
                                <asp:RequiredFieldValidator ID="rfvPhone" runat="server" ControlToValidate="txtPhone" 
                                    ErrorMessage="شماره تماس الزامی است" CssClass="error-message" Display="Dynamic" />
                            </div>

                            <!-- اطلاعات شخصی -->
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                                <div class="form-group">
                                    <label class="form-label">تاریخ تولد</label>
                                    <asp:TextBox ID="txtBirthDate" runat="server" CssClass="form-input" ClientIDMode="Static" placeholder="YYYY/MM/DD (شمسی)" />
                                </div>
                                <div class="form-group">
                                    <label class="form-label">جنسیت</label>
                                    <asp:DropDownList ID="ddlGender" runat="server" CssClass="form-select">
                                        <asp:ListItem Text="انتخاب کنید" Value="" />
                                        <asp:ListItem Text="مرد" Value="Male" />
                                        <asp:ListItem Text="زن" Value="Female" />
                                    </asp:DropDownList>
                                </div>
                            </div>

                            <!-- بارگذاری فایل -->
                            <div class="form-group">
                                <label class="form-label">تصویر بیمه ورزشی *</label>
                                <div class="file-upload">
                                    <asp:FileUpload ID="fuInsurance" runat="server" CssClass="form-input" />
                                    <label class="file-upload-label" for="fuInsurance">
                                        <div class="text-lg mb-2">📁</div>
                                        <div>برای انتخاب فایل کلیک کنید</div>
                                        <div class="text-sm text-gray-500 mt-1">فرمت‌های مجاز: JPG, PNG</div>
                                    </label>
                                </div>
                                <asp:RequiredFieldValidator ID="rfvInsurance" runat="server" ControlToValidate="fuInsurance" 
                                    ErrorMessage="بارگذاری تصویر بیمه الزامی است" CssClass="error-message" Display="Dynamic" />
                            </div>

                            <!-- توضیحات -->
                            <div class="form-group">
                                <label class="form-label">توضیحات اضافی</label>
                                <asp:TextBox ID="txtNotes" runat="server" TextMode="MultiLine" Rows="4" 
                                    CssClass="form-input" placeholder="توضیحات اضافی خود را اینجا بنویسید..." />
                            </div>

                            <!-- دکمه ثبت نام -->
                            <div class="form-group">
                                <asp:Button ID="btnSubmit" runat="server" Text="ثبت نام در مسابقه" 
                                    CssClass="submit-btn" OnClick="btnSubmit_OnClick" />
                            </div>

                            <!-- پیام‌های سیستم -->
                            <asp:Literal ID="litMsg" runat="server" />
                            <asp:HiddenField ID="hdnCompetitionId" runat="server" />
                    </div>
                </div>
            </div>
        </div>
    </section>

    <script src="https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/persian-date@1.1.0/dist/persian-date.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/persian-datepicker@1.2.0/dist/js/persian-datepicker.min.js"></script>
    <script>
        // sync label clicks to radio buttons in case the browser doesn't connect them
        document.addEventListener('DOMContentLoaded', function() {
            var lblSingle = document.getElementById('lblSingle');
            var lblDouble = document.getElementById('lblDouble');
            if (lblSingle) lblSingle.addEventListener('click', function(e){
                var r = document.getElementById('rbSingleGroup'); if (r) r.checked = true;
            });
            if (lblDouble) lblDouble.addEventListener('click', function(e){
                var r = document.getElementById('rbDoubleGroup'); if (r) r.checked = true;
            });
        });
        // Persian datepicker
        $(function(){
            if ($('#txtBirthDate').length) {
                $('#txtBirthDate').persianDatepicker({
                    format: 'YYYY/MM/DD',
                    initialValue: false,
                    autoClose: true,
                    persianDigit: true
                });
            }
        });
        // بهبود تجربه کاربری برای انتخاب فایل
        document.addEventListener('DOMContentLoaded', function() {
            const fileInput = document.querySelector('input[type="file"]');
            const fileLabel = document.querySelector('.file-upload-label');
            
            if (fileInput && fileLabel) {
                fileInput.addEventListener('change', function() {
                    if (this.files.length > 0) {
                        const fileName = this.files[0].name;
                        fileLabel.innerHTML = `
                            <div class="text-lg mb-2">✅</div>
                            <div class="font-semibold text-green-600">فایل انتخاب شد</div>
                            <div class="text-sm text-gray-600">${fileName}</div>
                        `;
                    } else {
                        fileLabel.innerHTML = `
                            <div class="text-lg mb-2">📁</div>
                            <div>برای انتخاب فایل کلیک کنید</div>
                            <div class="text-sm text-gray-500 mt-1">فرمت‌های مجاز: JPG, PNG</div>
                        `;
                    }
                });
            }

            // بهبود تجربه کاربری برای انتخاب نوع ثبت نام
            const typeOptions = document.querySelectorAll('.type-option input[type="radio"]');
            typeOptions.forEach(option => {
                option.addEventListener('change', function() {
                    // حذف کلاس active از همه گزینه‌ها
                    document.querySelectorAll('.type-option label').forEach(label => {
                        label.classList.remove('active');
                    });
                    
                    // اضافه کردن کلاس active به گزینه انتخاب شده
                    if (this.checked) {
                        this.nextElementSibling.classList.add('active');
                    }
                });
            });
        });
    </script>
</asp:Content>



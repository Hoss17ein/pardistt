using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;

namespace shop1.Admin
{
    public partial class HeaderAdmin : System.Web.UI.Page
    {
        private string ConnStr
        {
            get { return ConfigurationManager.ConnectionStrings["my dataConnectionString"].ConnectionString; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!AdminAuth.IsAdminAuthenticated())
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadHeaderSettings();
                LoadStatistics();
            }
        }

        private void LoadHeaderSettings()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                using (SqlCommand cmd = new SqlCommand("SELECT TOP 1 * FROM HeaderSettings", conn))
                {
                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            hfSettingsId.Value = reader["Id"].ToString();
                            txtSiteTitle.Text = reader["SiteTitle"].ToString();
                            txtMetaDescription.Text = reader["MetaDescription"] != DBNull.Value ? reader["MetaDescription"].ToString() : "";
                            txtMetaKeywords.Text = reader["MetaKeywords"] != DBNull.Value ? reader["MetaKeywords"].ToString() : "";
                            
                            string logoUrl = reader["LogoUrl"] != DBNull.Value ? reader["LogoUrl"].ToString() : "";
                            if (!string.IsNullOrEmpty(logoUrl))
                            {
                                litCurrentLogo.Text = "<br><div class='mt-2'><strong>لوگوی فعلی:</strong><br><img src='../" + logoUrl + "' style='max-width:150px; border: 1px solid #ddd; padding: 5px;' /></div>";
                                imgPreviewLogo.ImageUrl = "../" + logoUrl;
                            }
                            
                            // Footers
                            try
                            {
                                using (SqlConnection c2 = new SqlConnection(ConnStr))
                                using (SqlCommand fcmd = new SqlCommand("SELECT TOP 1 * FROM FooterSettings", c2))
                                {
                                    c2.Open();
                                    using (SqlDataReader fr = fcmd.ExecuteReader())
                                    {
                                        if (fr.Read())
                                        {
                                            txtFooterTitle.Text = fr["FooterTitle"] != DBNull.Value ? fr["FooterTitle"].ToString() : "";
                                            txtFooterDescription.Text = fr["FooterDescription"] != DBNull.Value ? fr["FooterDescription"].ToString() : "";
                                            txtCopyright.Text = fr["CopyrightText"] != DBNull.Value ? fr["CopyrightText"].ToString() : "";
                                        }
                                    }
                                }
                            }
                            catch { }

                            // به‌روزرسانی پیش‌نمایش
                            litPreviewTitle.Text = txtSiteTitle.Text;
                            litPreviewDescription.Text = !string.IsNullOrEmpty(txtMetaDescription.Text) ? txtMetaDescription.Text : "توضیحات متا در اینجا نمایش داده می‌شود";
                        }
                        else
                        {
                            // اگر رکوردی وجود ندارد، مقادیر پیش‌فرض
                            txtSiteTitle.Text = "باشگاه تنیس روی میز پردیس";
                            litPreviewTitle.Text = txtSiteTitle.Text;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                // Handle error
            }
        }

        private void LoadStatistics()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                {
                    conn.Open();

                    // تعداد اخبار
                    using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM [new]", conn))
                    {
                        object result = cmd.ExecuteScalar();
                        litTotalNews.Text = result != null ? result.ToString() : "0";
                    }

                    // تعداد مربیان
                    using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Coaches", conn))
                    {
                        object result = cmd.ExecuteScalar();
                        litTotalCoaches.Text = result != null ? result.ToString() : "0";
                    }

                    // تعداد تصاویر گالری
                    using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Gallery", conn))
                    {
                        object result = cmd.ExecuteScalar();
                        litTotalGallery.Text = result != null ? result.ToString() : "0";
                    }

                    // تعداد منوها
                    using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Menus", conn))
                    {
                        object result = cmd.ExecuteScalar();
                        litTotalMenus.Text = result != null ? result.ToString() : "0";
                    }
                }
            }
            catch (Exception ex)
            {
                // در صورت خطا، مقادیر پیش‌فرض
                litTotalNews.Text = "0";
                litTotalCoaches.Text = "0";
                litTotalGallery.Text = "0";
                litTotalMenus.Text = "0";
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                try
                {
                    string logoUrl = HandleLogoUpload();
                    
                    using (SqlConnection conn = new SqlConnection(ConnStr))
                    {
                        conn.Open();
                        SqlCommand cmd;

                        if (string.IsNullOrEmpty(hfSettingsId.Value)) // افزودن
                        {
                            string sql = "INSERT INTO HeaderSettings (SiteTitle, LogoUrl, MetaDescription, MetaKeywords) VALUES (@SiteTitle, @LogoUrl, @MetaDescription, @MetaKeywords)";
                            cmd = new SqlCommand(sql, conn);
                        }
                        else // ویرایش
                        {
                            string sql = "UPDATE HeaderSettings SET SiteTitle=@SiteTitle, MetaDescription=@MetaDescription, MetaKeywords=@MetaKeywords";
                            if (!string.IsNullOrEmpty(logoUrl))
                            {
                                sql += ", LogoUrl=@LogoUrl";
                            }
                            sql += " WHERE Id=@Id";
                            cmd = new SqlCommand(sql, conn);
                            cmd.Parameters.AddWithValue("@Id", hfSettingsId.Value);
                        }

                        cmd.Parameters.AddWithValue("@SiteTitle", txtSiteTitle.Text.Trim());
                        cmd.Parameters.AddWithValue("@MetaDescription", txtMetaDescription.Text.Trim());
                        cmd.Parameters.AddWithValue("@MetaKeywords", txtMetaKeywords.Text.Trim());
                        
                        if (!string.IsNullOrEmpty(logoUrl))
                        {
                            cmd.Parameters.AddWithValue("@LogoUrl", logoUrl);
                        }

                        cmd.ExecuteNonQuery();
                    }

                    // نمایش پیام موفقیت
                    ClientScript.RegisterStartupScript(this.GetType(), "success", "alert('تنظیمات با موفقیت ذخیره شد!');", true);
                    
                    // ذخیره FooterSettings
                    try
                    {
                        using (SqlConnection c2 = new SqlConnection(ConnStr))
                        {
                            c2.Open();
                            string up = @"IF EXISTS (SELECT 1 FROM FooterSettings)
UPDATE FooterSettings SET FooterTitle=@t, FooterDescription=@d, CopyrightText=@c
ELSE INSERT INTO FooterSettings(FooterTitle, FooterDescription, CopyrightText) VALUES(@t, @d, @c)";
                            using (SqlCommand f = new SqlCommand(up, c2))
                            {
                                f.Parameters.AddWithValue("@t", txtFooterTitle.Text.Trim());
                                f.Parameters.AddWithValue("@d", txtFooterDescription.Text.Trim());
                                f.Parameters.AddWithValue("@c", txtCopyright.Text.Trim());
                                f.ExecuteNonQuery();
                            }
                        }
                    }
                    catch { }

                    // بارگذاری مجدد اطلاعات
                    LoadHeaderSettings();
                }
                catch (Exception ex)
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "error", "alert('خطا در ذخیره تنظیمات: " + ex.Message + "');", true);
                }
            }
        }

        private string HandleLogoUpload()
        {
            if (fuLogo.HasFile)
            {
                try
                {
                    // بررسی نوع فایل
                    string fileExtension = Path.GetExtension(fuLogo.FileName).ToLower();
                    string[] allowedExtensions = { ".jpg", ".jpeg", ".png", ".gif" };
                    
                    bool isValidExtension = false;
                    foreach (string ext in allowedExtensions)
                    {
                        if (fileExtension == ext)
                        {
                            isValidExtension = true;
                            break;
                        }
                    }
                    
                    if (!isValidExtension)
                    {
                        ClientScript.RegisterStartupScript(this.GetType(), "error", "alert('فرمت فایل مجاز نیست. فقط JPG, PNG, GIF مجاز است.');", true);
                        return null;
                    }

                    // بررسی اندازه فایل (حداکثر 2MB)
                    if (fuLogo.PostedFile.ContentLength > 2 * 1024 * 1024)
                    {
                        ClientScript.RegisterStartupScript(this.GetType(), "error", "alert('اندازه فایل نباید بیشتر از 2 مگابایت باشد.');", true);
                        return null;
                    }

                    string fileName = "logo_" + DateTime.Now.ToString("yyyyMMdd_HHmmss") + fileExtension;
                    string uploadPath = Server.MapPath("~/uploads/");
                    
                    if (!Directory.Exists(uploadPath))
                    {
                        Directory.CreateDirectory(uploadPath);
                    }
                    
                    string fullPath = Path.Combine(uploadPath, fileName);
                    fuLogo.SaveAs(fullPath);
                    
                    return "uploads/" + fileName;
                }
                catch (Exception ex)
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "error", "alert('خطا در آپلود فایل: " + ex.Message + "');", true);
                    return null;
                }
            }
            return null;
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            txtSiteTitle.Text = "";
            txtMetaDescription.Text = "";
            txtMetaKeywords.Text = "";
            litCurrentLogo.Text = "";
            imgPreviewLogo.ImageUrl = "";
            litPreviewTitle.Text = "عنوان سایت";
            litPreviewDescription.Text = "توضیحات متا در اینجا نمایش داده می‌شود";
            hfSettingsId.Value = "";
        }
    }
}

using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace shop1.Admin
{
    public partial class AdminSlideshowAdmin : System.Web.UI.Page
    {
        private string ConnStr { get { return ConfigurationManager.ConnectionStrings["my dataConnectionString"].ConnectionString; } }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!AdminAuth.IsAdminAuthenticated())
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadAdminSlideshow();
                LoadAdminSlideshowPreview();
            }
        }

        private void LoadAdminSlideshow()
        {
            try
            {
                string connStr = ConfigurationManager.ConnectionStrings["my dataConnectionString"].ConnectionString;
                DataTable dt = new DataTable();
                using (SqlConnection conn = new SqlConnection(connStr))
                using (SqlDataAdapter da = new SqlDataAdapter("SELECT Id, Title, Description, ImageUrl, SortOrder, IsActive, CreatedDate FROM AdminSlideshow ORDER BY SortOrder, Id", conn))
                {
                    da.Fill(dt);
                }
                gvAdminSlideshow.DataSource = dt;
                gvAdminSlideshow.DataBind();
            }
            catch (Exception ex)
            {
                // اگر جدول AdminSlideshow وجود نداشته باشد، خطا نده
            }
        }

        private void LoadAdminSlideshowPreview()
        {
            try
            {
                string connStr = ConfigurationManager.ConnectionStrings["my dataConnectionString"].ConnectionString;
                DataTable dt = new DataTable();
                using (SqlConnection conn = new SqlConnection(connStr))
                using (SqlDataAdapter da = new SqlDataAdapter("SELECT Id, Title, Description, ImageUrl FROM AdminSlideshow WHERE IsActive = 1 ORDER BY SortOrder, Id", conn))
                {
                    da.Fill(dt);
                }
                rptAdminSlideshowPreview.DataSource = dt;
                rptAdminSlideshowPreview.DataBind();
                rptAdminSlideDots.DataSource = dt;
                rptAdminSlideDots.DataBind();
            }
            catch (Exception ex)
            {
                // اگر جدول AdminSlideshow وجود نداشته باشد، خطا نده
            }
        }

        protected void btnAdd_Click(object sender, EventArgs e)
        {
            if (fileUpload.HasFile)
            {
                // بررسی نوع فایل
                string extension = Path.GetExtension(fileUpload.FileName).ToLower();
                if (extension != ".jpg" && extension != ".jpeg" && extension != ".png" && extension != ".gif")
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('فقط فایل‌های تصویری مجاز هستند.');", true);
                    return;
                }

                // بررسی اندازه فایل (حداکثر 5 مگابایت)
                if (fileUpload.FileBytes.Length > 5 * 1024 * 1024)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('حجم فایل نباید بیشتر از 5 مگابایت باشد.');", true);
                    return;
                }

                try
                {
                    // ذخیره فایل
                    string fileName = "admin-slide_" + DateTime.Now.Ticks + extension;
                    string filePath = Server.MapPath("~/images/admin-slideshow/" + fileName);
                    fileUpload.SaveAs(filePath);

                    // ذخیره در دیتابیس
                    string imageUrl = "/images/admin-slideshow/" + fileName;
                    using (SqlConnection conn = new SqlConnection(ConnStr))
                    {
                        conn.Open();
                        string sql = "INSERT INTO AdminSlideshow (Title, Description, ImageUrl, SortOrder, IsActive, CreatedDate) VALUES (@Title, @Description, @ImageUrl, @SortOrder, @IsActive, GETDATE())";
                        using (SqlCommand cmd = new SqlCommand(sql, conn))
                        {
                            cmd.Parameters.AddWithValue("@Title", txtTitle.Text.Trim());
                            cmd.Parameters.AddWithValue("@Description", txtDescription.Text.Trim());
                            cmd.Parameters.AddWithValue("@ImageUrl", imageUrl);
                            cmd.Parameters.AddWithValue("@SortOrder", Convert.ToInt32(txtSortOrder.Text));
                            cmd.Parameters.AddWithValue("@IsActive", chkIsActive.Checked);
                            cmd.ExecuteNonQuery();
                        }
                    }

                    ClearForm();
                    LoadAdminSlideshow();
                    LoadAdminSlideshowPreview();
                    ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('تصویر با موفقیت اضافه شد.');", true);
                }
                catch (Exception ex)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('خطا در ذخیره تصویر: " + ex.Message + "');", true);
                }
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('لطفاً یک تصویر انتخاب کنید.');", true);
            }
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            int slideshowId = Convert.ToInt32(hdnEditId.Value);
            string currentImageUrl = "";

            // دریافت آدرس تصویر فعلی
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand("SELECT ImageUrl FROM AdminSlideshow WHERE Id = @Id", conn))
                {
                    cmd.Parameters.AddWithValue("@Id", slideshowId);
                    object result = cmd.ExecuteScalar();
                    if (result != null)
                    {
                        currentImageUrl = result.ToString();
                    }
                }
            }

            string newImageUrl = currentImageUrl;

            // اگر تصویر جدید انتخاب شده باشد
            if (fileUpload.HasFile)
            {
                // بررسی نوع فایل
                string extension = Path.GetExtension(fileUpload.FileName).ToLower();
                if (extension != ".jpg" && extension != ".jpeg" && extension != ".png" && extension != ".gif")
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('فقط فایل‌های تصویری مجاز هستند.');", true);
                    return;
                }

                // بررسی اندازه فایل
                if (fileUpload.FileBytes.Length > 5 * 1024 * 1024)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('حجم فایل نباید بیشتر از 5 مگابایت باشد.');", true);
                    return;
                }

                // حذف تصویر قبلی
                if (!string.IsNullOrEmpty(currentImageUrl))
                {
                    string oldFilePath = Server.MapPath("~" + currentImageUrl);
                    if (File.Exists(oldFilePath))
                    {
                        File.Delete(oldFilePath);
                    }
                }

                // ذخیره تصویر جدید
                string fileName = "admin-slide_" + DateTime.Now.Ticks + extension;
                string filePath = Server.MapPath("~/images/admin-slideshow/" + fileName);
                fileUpload.SaveAs(filePath);
                newImageUrl = "/images/admin-slideshow/" + fileName;
            }

            try
            {
                // بروزرسانی در دیتابیس
                using (SqlConnection conn = new SqlConnection(ConnStr))
                {
                    conn.Open();
                    string sql = "UPDATE AdminSlideshow SET Title = @Title, Description = @Description, ImageUrl = @ImageUrl, SortOrder = @SortOrder, IsActive = @IsActive WHERE Id = @Id";
                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@Title", txtTitle.Text.Trim());
                        cmd.Parameters.AddWithValue("@Description", txtDescription.Text.Trim());
                        cmd.Parameters.AddWithValue("@ImageUrl", newImageUrl);
                        cmd.Parameters.AddWithValue("@SortOrder", Convert.ToInt32(txtSortOrder.Text));
                        cmd.Parameters.AddWithValue("@IsActive", chkIsActive.Checked);
                        cmd.Parameters.AddWithValue("@Id", slideshowId);
                        cmd.ExecuteNonQuery();
                    }
                }

                ClearForm();
                LoadAdminSlideshow();
                LoadAdminSlideshowPreview();
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('تصویر با موفقیت بروزرسانی شد.');", true);
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('خطا در بروزرسانی تصویر: " + ex.Message + "');", true);
            }
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            ClearForm();
        }

        protected void gvAdminSlideshow_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EditItem")
            {
                int slideshowId = Convert.ToInt32(e.CommandArgument);
                LoadAdminSlideshowForEdit(slideshowId);
            }
        }

        protected void gvAdminSlideshow_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int slideshowId = Convert.ToInt32(gvAdminSlideshow.DataKeys[e.RowIndex].Value);
            string imageUrl = "";

            // دریافت آدرس تصویر
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand("SELECT ImageUrl FROM AdminSlideshow WHERE Id = @Id", conn))
                {
                    cmd.Parameters.AddWithValue("@Id", slideshowId);
                    object result = cmd.ExecuteScalar();
                    if (result != null)
                    {
                        imageUrl = result.ToString();
                    }
                }
            }

            try
            {
                // حذف از دیتابیس
                using (SqlConnection conn = new SqlConnection(ConnStr))
                {
                    conn.Open();
                    using (SqlCommand cmd = new SqlCommand("DELETE FROM AdminSlideshow WHERE Id = @Id", conn))
                    {
                        cmd.Parameters.AddWithValue("@Id", slideshowId);
                        cmd.ExecuteNonQuery();
                    }
                }

                // حذف فایل
                if (!string.IsNullOrEmpty(imageUrl))
                {
                    string filePath = Server.MapPath("~" + imageUrl);
                    if (File.Exists(filePath))
                    {
                        File.Delete(filePath);
                    }
                }

                LoadAdminSlideshow();
                LoadAdminSlideshowPreview();
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('تصویر با موفقیت حذف شد.');", true);
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('خطا در حذف تصویر: " + ex.Message + "');", true);
            }
        }

        private void LoadAdminSlideshowForEdit(int slideshowId)
        {
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand("SELECT Id, Title, Description, ImageUrl, SortOrder, IsActive FROM AdminSlideshow WHERE Id = @Id", conn))
                {
                    cmd.Parameters.AddWithValue("@Id", slideshowId);
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            hdnEditId.Value = reader["Id"].ToString();
                            txtTitle.Text = reader["Title"].ToString();
                            txtDescription.Text = reader["Description"].ToString();
                            txtSortOrder.Text = reader["SortOrder"].ToString();
                            chkIsActive.Checked = Convert.ToBoolean(reader["IsActive"]);

                            btnAdd.Visible = false;
                            btnUpdate.Visible = true;
                            btnCancel.Visible = true;
                        }
                    }
                }
            }
        }

        private void ClearForm()
        {
            txtTitle.Text = "";
            txtDescription.Text = "";
            txtSortOrder.Text = "1";
            chkIsActive.Checked = true;
            hdnEditId.Value = "";

            btnAdd.Visible = true;
            btnUpdate.Visible = false;
            btnCancel.Visible = false;
        }
    }
}

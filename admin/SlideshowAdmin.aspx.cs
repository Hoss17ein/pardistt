using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace shop1.Admin
{
    public partial class SlideshowAdmin : System.Web.UI.Page
    {
        private string ConnStr
        {
            get { return ConfigurationManager.ConnectionStrings["my dataConnectionString"].ConnectionString; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // بررسی احراز هویت ادمین
            if (!AdminAuth.IsAdminAuthenticated())
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadSlideshow();
                LoadSlideshowPreview();
            }
        }

        private void LoadSlideshow()
        {
            DataTable dt = new DataTable();
            using (SqlConnection conn = new SqlConnection(ConnStr))
            using (SqlDataAdapter da = new SqlDataAdapter("SELECT Id, Title, Description, ImageUrl, Link, SortOrder, IsActive, CreatedDate FROM Slideshow ORDER BY SortOrder, Id", conn))
            {
                da.Fill(dt);
            }
            gvSlideshow.DataSource = dt;
            gvSlideshow.DataBind();
        }

        private void LoadSlideshowPreview()
        {
            DataTable dt = new DataTable();
            using (SqlConnection conn = new SqlConnection(ConnStr))
            using (SqlDataAdapter da = new SqlDataAdapter("SELECT Id, Title, Description, ImageUrl, Link FROM Slideshow WHERE IsActive = 1 ORDER BY SortOrder, Id", conn))
            {
                da.Fill(dt);
            }
            rptSlideshowPreview.DataSource = dt;
            rptSlideshowPreview.DataBind();
            rptSlideDots.DataSource = dt;
            rptSlideDots.DataBind();
        }

        protected void btnAdd_Click(object sender, EventArgs e)
        {
            if (fuImage.HasFile)
            {
                try
                {
                    // بررسی نوع فایل
                    string extension = Path.GetExtension(fuImage.FileName).ToLower();
                    if (extension != ".jpg" && extension != ".jpeg" && extension != ".png" && extension != ".gif")
                    {
                        litMessage.Text = "<div class='alert alert-danger'>فقط فایل‌های تصویری مجاز هستند.</div>";
                        return;
                    }

                    // بررسی اندازه فایل (حداکثر 2MB)
                    if (fuImage.FileBytes.Length > 2 * 1024 * 1024)
                    {
                        litMessage.Text = "<div class='alert alert-danger'>حجم فایل نباید بیشتر از 2MB باشد.</div>";
                        return;
                    }

                    // ذخیره فایل
                    string fileName = "slideshow_" + DateTime.Now.Ticks + extension;
                    string filePath = Server.MapPath("~/uploads/slideshow/");
                    
                    // ایجاد پوشه اگر وجود نداشته باشد
                    if (!Directory.Exists(filePath))
                    {
                        Directory.CreateDirectory(filePath);
                    }

                    string fullPath = Path.Combine(filePath, fileName);
                    fuImage.SaveAs(fullPath);

                    // ذخیره در دیتابیس
                    using (SqlConnection conn = new SqlConnection(ConnStr))
                    using (SqlCommand cmd = new SqlCommand("INSERT INTO Slideshow (Title, Description, ImageUrl, Link, SortOrder, IsActive, CreatedDate) VALUES (@Title, @Description, @ImageUrl, @Link, @SortOrder, @IsActive, GETDATE())", conn))
                    {
                        cmd.Parameters.AddWithValue("@Title", txtTitle.Text.Trim());
                        cmd.Parameters.AddWithValue("@Description", txtDescription.Text.Trim());
                        cmd.Parameters.AddWithValue("@ImageUrl", "/uploads/slideshow/" + fileName);
                        cmd.Parameters.AddWithValue("@Link", txtLink.Text.Trim());
                        cmd.Parameters.AddWithValue("@SortOrder", Convert.ToInt32(txtSortOrder.Text));
                        cmd.Parameters.AddWithValue("@IsActive", chkIsActive.Checked);

                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }

                    ClearForm();
                    LoadSlideshow();
                    LoadSlideshowPreview();
                    litMessage.Text = "<div class='alert alert-success'>تصویر با موفقیت اضافه شد.</div>";
                }
                catch (Exception ex)
                {
                    litMessage.Text = "<div class='alert alert-danger'>خطا در ذخیره تصویر: " + ex.Message + "</div>";
                }
            }
            else
            {
                litMessage.Text = "<div class='alert alert-danger'>لطفاً یک تصویر انتخاب کنید.</div>";
            }
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                int slideshowId = Convert.ToInt32(ViewState["EditSlideshowId"]);
                string imageUrl = ViewState["CurrentImageUrl"].ToString();

                // اگر تصویر جدید انتخاب شده باشد
                if (fuImage.HasFile)
                {
                    // بررسی نوع فایل
                    string extension = Path.GetExtension(fuImage.FileName).ToLower();
                    if (extension != ".jpg" && extension != ".jpeg" && extension != ".png" && extension != ".gif")
                    {
                        litMessage.Text = "<div class='alert alert-danger'>فقط فایل‌های تصویری مجاز هستند.</div>";
                        return;
                    }

                    // بررسی اندازه فایل
                    if (fuImage.FileBytes.Length > 2 * 1024 * 1024)
                    {
                        litMessage.Text = "<div class='alert alert-danger'>حجم فایل نباید بیشتر از 2MB باشد.</div>";
                        return;
                    }

                    // حذف فایل قدیمی
                    string oldFilePath = Server.MapPath(imageUrl);
                    if (File.Exists(oldFilePath))
                    {
                        File.Delete(oldFilePath);
                    }

                    // ذخیره فایل جدید
                    string fileName = "slideshow_" + DateTime.Now.Ticks + extension;
                    string filePath = Server.MapPath("~/uploads/slideshow/");
                    string fullPath = Path.Combine(filePath, fileName);
                    fuImage.SaveAs(fullPath);
                    imageUrl = "/uploads/slideshow/" + fileName;
                }

                // بروزرسانی در دیتابیس
                using (SqlConnection conn = new SqlConnection(ConnStr))
                using (SqlCommand cmd = new SqlCommand("UPDATE Slideshow SET Title=@Title, Description=@Description, ImageUrl=@ImageUrl, Link=@Link, SortOrder=@SortOrder, IsActive=@IsActive WHERE Id=@Id", conn))
                {
                    cmd.Parameters.AddWithValue("@Id", slideshowId);
                    cmd.Parameters.AddWithValue("@Title", txtTitle.Text.Trim());
                    cmd.Parameters.AddWithValue("@Description", txtDescription.Text.Trim());
                    cmd.Parameters.AddWithValue("@ImageUrl", imageUrl);
                    cmd.Parameters.AddWithValue("@Link", txtLink.Text.Trim());
                    cmd.Parameters.AddWithValue("@SortOrder", Convert.ToInt32(txtSortOrder.Text));
                    cmd.Parameters.AddWithValue("@IsActive", chkIsActive.Checked);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                ClearForm();
                LoadSlideshow();
                LoadSlideshowPreview();
                litMessage.Text = "<div class='alert alert-success'>تصویر با موفقیت بروزرسانی شد.</div>";
            }
            catch (Exception ex)
            {
                litMessage.Text = "<div class='alert alert-danger'>خطا در بروزرسانی: " + ex.Message + "</div>";
            }
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            ClearForm();
        }

        protected void gvSlideshow_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EditItem")
            {
                int slideshowId = Convert.ToInt32(e.CommandArgument);
                LoadSlideshowForEdit(slideshowId);
            }
        }

        protected void gvSlideshow_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            try
            {
                int slideshowId = Convert.ToInt32(gvSlideshow.DataKeys[e.RowIndex].Value);

                // دریافت مسیر فایل
                string imageUrl = "";
                using (SqlConnection conn = new SqlConnection(ConnStr))
                using (SqlCommand cmd = new SqlCommand("SELECT ImageUrl FROM Slideshow WHERE Id=@Id", conn))
                {
                    cmd.Parameters.AddWithValue("@Id", slideshowId);
                    conn.Open();
                    object result = cmd.ExecuteScalar();
                    if (result != null)
                    {
                        imageUrl = result.ToString();
                    }
                }

                // حذف از دیتابیس
                using (SqlConnection conn = new SqlConnection(ConnStr))
                using (SqlCommand cmd = new SqlCommand("DELETE FROM Slideshow WHERE Id=@Id", conn))
                {
                    cmd.Parameters.AddWithValue("@Id", slideshowId);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                // حذف فایل
                if (!string.IsNullOrEmpty(imageUrl))
                {
                    string filePath = Server.MapPath(imageUrl);
                    if (File.Exists(filePath))
                    {
                        File.Delete(filePath);
                    }
                }

                LoadSlideshow();
                LoadSlideshowPreview();
                litMessage.Text = "<div class='alert alert-success'>تصویر با موفقیت حذف شد.</div>";
            }
            catch (Exception ex)
            {
                litMessage.Text = "<div class='alert alert-danger'>خطا در حذف: " + ex.Message + "</div>";
            }
        }

        private void LoadSlideshowForEdit(int slideshowId)
        {
            using (SqlConnection conn = new SqlConnection(ConnStr))
            using (SqlCommand cmd = new SqlCommand("SELECT Id, Title, Description, ImageUrl, Link, SortOrder, IsActive FROM Slideshow WHERE Id=@Id", conn))
            {
                cmd.Parameters.AddWithValue("@Id", slideshowId);
                conn.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        txtTitle.Text = reader["Title"].ToString();
                        txtDescription.Text = reader["Description"].ToString();
                        txtLink.Text = reader["Link"].ToString();
                        txtSortOrder.Text = reader["SortOrder"].ToString();
                        chkIsActive.Checked = Convert.ToBoolean(reader["IsActive"]);

                        ViewState["EditSlideshowId"] = slideshowId;
                        ViewState["CurrentImageUrl"] = reader["ImageUrl"].ToString();

                        btnAdd.Visible = false;
                        btnUpdate.Visible = true;
                        btnCancel.Visible = true;
                    }
                }
            }
        }

        private void ClearForm()
        {
            txtTitle.Text = "";
            txtDescription.Text = "";
            txtLink.Text = "";
            txtSortOrder.Text = "1";
            chkIsActive.Checked = true;

            ViewState["EditSlideshowId"] = null;
            ViewState["CurrentImageUrl"] = null;

            btnAdd.Visible = true;
            btnUpdate.Visible = false;
            btnCancel.Visible = false;
        }
    }
}

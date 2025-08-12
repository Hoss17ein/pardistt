using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace shop1.Admin
{
    public partial class GalleryAdmin : System.Web.UI.Page
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
                LoadGallery();
            }
        }

        private void LoadGallery()
        {
            try
            {
                DataTable dt = new DataTable();
                using (SqlConnection conn = new SqlConnection(ConnStr))
                using (SqlDataAdapter da = new SqlDataAdapter("SELECT Id, Title, Description, ImageUrl, CreatedDate FROM Gallery ORDER BY CreatedDate DESC", conn))
                {
                    da.Fill(dt);
                }
                rptGallery.DataSource = dt;
                rptGallery.DataBind();
            }
            catch (Exception ex)
            {
                // Handle error
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                try
                {
                    string imageUrl = HandleImageUpload();
                    
                    using (SqlConnection conn = new SqlConnection(ConnStr))
                    {
                        conn.Open();
                        SqlCommand cmd;

                        if (string.IsNullOrEmpty(hfImageId.Value)) // افزودن
                        {
                            if (string.IsNullOrEmpty(imageUrl))
                            {
                                return; // تصویر الزامی است
                            }
                            
                            string sql = "INSERT INTO Gallery (Title, Description, ImageUrl, CreatedDate) VALUES (@Title, @Description, @ImageUrl, GETDATE())";
                            cmd = new SqlCommand(sql, conn);
                        }
                        else // ویرایش
                        {
                            string sql = "UPDATE Gallery SET Title=@Title, Description=@Description";
                            if (!string.IsNullOrEmpty(imageUrl))
                            {
                                sql += ", ImageUrl=@ImageUrl";
                            }
                            sql += " WHERE Id=@Id";
                            cmd = new SqlCommand(sql, conn);
                            cmd.Parameters.AddWithValue("@Id", hfImageId.Value);
                        }

                        cmd.Parameters.AddWithValue("@Title", txtTitle.Text.Trim());
                        cmd.Parameters.AddWithValue("@Description", txtDescription.Text.Trim());
                        
                        if (!string.IsNullOrEmpty(imageUrl))
                        {
                            cmd.Parameters.AddWithValue("@ImageUrl", imageUrl);
                        }

                        cmd.ExecuteNonQuery();
                    }

                    ClearForm();
                    LoadGallery();
                }
                catch (Exception ex)
                {
                    // Handle error
                }
            }
        }

        private string HandleImageUpload()
        {
            if (fuImage.HasFile)
            {
                try
                {
                    // بررسی نوع فایل
                    string fileExtension = Path.GetExtension(fuImage.FileName).ToLower();
                    string[] allowedExtensions = { ".jpg", ".jpeg", ".png", ".gif", ".bmp" };
                    
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
                        return null;
                    }

                    string fileName = DateTime.Now.ToString("yyyyMMdd_HHmmss_") + fuImage.FileName;
                    string uploadPath = Server.MapPath("~/uploads/gallery/");
                    
                    if (!Directory.Exists(uploadPath))
                    {
                        Directory.CreateDirectory(uploadPath);
                    }
                    
                    string fullPath = Path.Combine(uploadPath, fileName);
                    fuImage.SaveAs(fullPath);
                    
                    return "uploads/gallery/" + fileName;
                }
                catch
                {
                    return null;
                }
            }
            return null;
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            ClearForm();
        }

        private void ClearForm()
        {
            hfImageId.Value = "";
            txtTitle.Text = "";
            txtDescription.Text = "";
            litFormTitle.Text = "افزودن تصویر جدید";
            litCurrentImage.Text = "";
            rfvImage.Enabled = true;
        }

        protected void rptGallery_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int imageId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "EditImage")
            {
                LoadImageForEdit(imageId);
            }
            else if (e.CommandName == "DeleteImage")
            {
                DeleteImage(imageId);
            }
        }

        private void LoadImageForEdit(int imageId)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                using (SqlCommand cmd = new SqlCommand("SELECT * FROM Gallery WHERE Id=@Id", conn))
                {
                    cmd.Parameters.AddWithValue("@Id", imageId);
                    conn.Open();
                    
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            hfImageId.Value = reader["Id"].ToString();
                            txtTitle.Text = reader["Title"].ToString();
                            txtDescription.Text = reader["Description"].ToString();
                            litFormTitle.Text = "ویرایش تصویر";
                            rfvImage.Enabled = false; // در ویرایش، تصویر اختیاری است
                            
                            string imageUrl = reader["ImageUrl"].ToString();
                            if (!string.IsNullOrEmpty(imageUrl))
                            {
                                litCurrentImage.Text = "<br><img src='../" + imageUrl + "' style='max-width:150px;' class='mt-2' />";
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                // Handle error
            }
        }

        private void DeleteImage(int imageId)
        {
            try
            {
                // حذف فایل تصویر
                string imageUrl = "";
                using (SqlConnection conn = new SqlConnection(ConnStr))
                using (SqlCommand cmd = new SqlCommand("SELECT ImageUrl FROM Gallery WHERE Id=@Id", conn))
                {
                    cmd.Parameters.AddWithValue("@Id", imageId);
                    conn.Open();
                    object result = cmd.ExecuteScalar();
                    if (result != null)
                    {
                        imageUrl = result.ToString();
                    }
                }
                
                // حذف از دیتابیس
                using (SqlConnection conn = new SqlConnection(ConnStr))
                using (SqlCommand cmd = new SqlCommand("DELETE FROM Gallery WHERE Id=@Id", conn))
                {
                    cmd.Parameters.AddWithValue("@Id", imageId);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
                
                // حذف فایل فیزیکی
                if (!string.IsNullOrEmpty(imageUrl))
                {
                    string filePath = Server.MapPath("~/" + imageUrl);
                    if (File.Exists(filePath))
                    {
                        File.Delete(filePath);
                    }
                }
                
                LoadGallery();
            }
            catch (Exception ex)
            {
                // Handle error
            }
        }
    }
}

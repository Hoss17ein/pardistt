using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace shop1.Admin
{
    public partial class NewsAdmin : System.Web.UI.Page
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
                LoadNews();
            }
        }

        private void LoadNews()
        {
            try
            {
                DataTable dt = new DataTable();
                using (SqlConnection conn = new SqlConnection(ConnStr))
                using (SqlDataAdapter da = new SqlDataAdapter("SELECT Id, Title, Summary, Category, CreatedDate FROM [new] ORDER BY CreatedDate DESC", conn))
                {
                    da.Fill(dt);
                }
                gvNews.DataSource = dt;
                gvNews.DataBind();
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

                        if (string.IsNullOrEmpty(hfNewsId.Value)) // افزودن
                        {
                            string sql = "INSERT INTO [new] (Title, Summary, Content, Category, ImageUrl, CreatedDate) VALUES (@Title, @Summary, @Content, @Category, @ImageUrl, GETDATE())";
                            cmd = new SqlCommand(sql, conn);
                        }
                        else // ویرایش
                        {
                            string sql = "UPDATE [new] SET Title=@Title, Summary=@Summary, Content=@Content, Category=@Category";
                            if (!string.IsNullOrEmpty(imageUrl))
                            {
                                sql += ", ImageUrl=@ImageUrl";
                            }
                            sql += " WHERE Id=@Id";
                            cmd = new SqlCommand(sql, conn);
                            cmd.Parameters.AddWithValue("@Id", hfNewsId.Value);
                        }

                        cmd.Parameters.AddWithValue("@Title", txtTitle.Text.Trim());
                        cmd.Parameters.AddWithValue("@Summary", txtSummary.Text.Trim());
                        cmd.Parameters.AddWithValue("@Content", txtContent.Text.Trim());
                        cmd.Parameters.AddWithValue("@Category", ddlCategory.SelectedValue);
                        
                        if (!string.IsNullOrEmpty(imageUrl))
                        {
                            cmd.Parameters.AddWithValue("@ImageUrl", imageUrl);
                        }

                        cmd.ExecuteNonQuery();
                    }

                    ClearForm();
                    LoadNews();
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
                    string fileName = DateTime.Now.ToString("yyyyMMdd_HHmmss_") + fuImage.FileName;
                    string uploadPath = Server.MapPath("~/uploads/news/");
                    
                    if (!Directory.Exists(uploadPath))
                    {
                        Directory.CreateDirectory(uploadPath);
                    }
                    
                    string fullPath = Path.Combine(uploadPath, fileName);
                    fuImage.SaveAs(fullPath);
                    
                    return "uploads/news/" + fileName;
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
            hfNewsId.Value = "";
            txtTitle.Text = "";
            txtSummary.Text = "";
            txtContent.Text = "";
            ddlCategory.SelectedIndex = 0;
            litFormTitle.Text = "افزودن خبر جدید";
            litCurrentImage.Text = "";
        }

        protected void gvNews_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int newsId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "EditNews")
            {
                LoadNewsForEdit(newsId);
            }
            else if (e.CommandName == "DeleteNews")
            {
                DeleteNews(newsId);
            }
        }

        private void LoadNewsForEdit(int newsId)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                using (SqlCommand cmd = new SqlCommand("SELECT * FROM [new] WHERE Id=@Id", conn))
                {
                    cmd.Parameters.AddWithValue("@Id", newsId);
                    conn.Open();
                    
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            hfNewsId.Value = reader["Id"].ToString();
                            txtTitle.Text = reader["Title"].ToString();
                            txtSummary.Text = reader["Summary"].ToString();
                            txtContent.Text = reader["Content"].ToString();
                            ddlCategory.SelectedValue = reader["Category"].ToString();
                            litFormTitle.Text = "ویرایش خبر";
                            
                            string imageUrl = reader["ImageUrl"].ToString();
                            if (!string.IsNullOrEmpty(imageUrl))
                            {
                                litCurrentImage.Text = "<br><img src='../" + imageUrl + "' style='max-width:100px;' />";
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

        private void DeleteNews(int newsId)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                using (SqlCommand cmd = new SqlCommand("DELETE FROM [new] WHERE Id=@Id", conn))
                {
                    cmd.Parameters.AddWithValue("@Id", newsId);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
                
                LoadNews();
            }
            catch (Exception ex)
            {
                // Handle error
            }
        }

        protected void gvNews_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvNews.PageIndex = e.NewPageIndex;
            LoadNews();
        }
    }
}

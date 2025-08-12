using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;

namespace Pardis
{
    public partial class NewsDetailPage : System.Web.UI.Page
    {
        private string ConnStr { get { return ConfigurationManager.ConnectionStrings["my dataConnectionString"].ConnectionString; } }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadNewsDetail();
            }
        }

        private void LoadNewsDetail()
        {
            string newsId = Request.QueryString["id"];
            
            if (string.IsNullOrEmpty(newsId))
            {
                Response.Redirect("/News.aspx");
                return;
            }

            try
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                {
                    conn.Open();
                    
                    // بارگذاری جزئیات خبر
                    using (SqlCommand cmd = new SqlCommand("SELECT Id, Title, Summary, Content, ImageUrl, Category, CreatedDate FROM [new] WHERE Id=@Id", conn))
                    {
                        cmd.Parameters.AddWithValue("@Id", newsId);
                        
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                // تنظیم عنوان صفحه
                                Page.Title = reader["Title"].ToString() + " - آکادمی تنیس روی میز پردیس";
                                
                                // پر کردن اطلاعات خبر
                                litTitle.Text = reader["Title"].ToString();
                                litSummary.Text = reader["Summary"].ToString();
                                litContent.Text = reader["Content"].ToString();
                                litCategory.Text = reader["Category"].ToString();
                                litCategoryTag.Text = reader["Category"].ToString();
                                litDate.Text = Convert.ToDateTime(reader["CreatedDate"]).ToString("yyyy/MM/dd");
                                litBreadcrumbTitle.Text = reader["Title"].ToString();
                                
                                string imageUrl = reader["ImageUrl"].ToString();
                                if (!string.IsNullOrEmpty(imageUrl))
                                {
                                    imgNews.ImageUrl = imageUrl;
                                }
                                else
                                {
                                    imgNews.ImageUrl = "/images/default-news.jpg";
                                }
                            }
                            else
                            {
                                // خبر پیدا نشد
                                Response.Redirect("/News.aspx");
                                return;
                            }
                        }
                    }

                    // بارگذاری اخبار مرتبط
                    string category = "";
                    using (SqlCommand cmdCategory = new SqlCommand("SELECT Category FROM [new] WHERE Id=@Id", conn))
                    {
                        cmdCategory.Parameters.AddWithValue("@Id", newsId);
                        object result = cmdCategory.ExecuteScalar();
                        if (result != null)
                        {
                            category = result.ToString();
                        }
                    }
                    LoadRelatedNews(conn, newsId, category);
                }
            }
            catch (Exception ex)
            {
                // در صورت خطا، به صفحه اخبار هدایت شود
                Response.Redirect("/News.aspx");
            }
        }

        private void LoadRelatedNews(SqlConnection conn, string currentNewsId, string category)
        {
            try
            {
                // اخبار مرتبط از همان دسته‌بندی (به جز خبر فعلی)
                string sql = @"SELECT TOP 3 Id, Title, Summary, ImageUrl, Category, CreatedDate 
                              FROM [new] 
                              WHERE Id != @CurrentId AND Category = @Category 
                              ORDER BY CreatedDate DESC";
                
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@CurrentId", currentNewsId);
                    cmd.Parameters.AddWithValue("@Category", category);
                    
                    DataTable dt = new DataTable();
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(dt);
                    }
                    
                    // اگر اخبار مرتبط از همان دسته‌بندی کم بود، اخبار دیگر را اضافه کن
                    if (dt.Rows.Count < 3)
                    {
                        int remainingCount = 3 - dt.Rows.Count;
                        string additionalSql = @"SELECT TOP " + remainingCount + @" Id, Title, Summary, ImageUrl, Category, CreatedDate 
                                                FROM [new] 
                                                WHERE Id != @CurrentId AND Category != @Category 
                                                ORDER BY CreatedDate DESC";
                        
                        using (SqlCommand additionalCmd = new SqlCommand(additionalSql, conn))
                        {
                            additionalCmd.Parameters.AddWithValue("@CurrentId", currentNewsId);
                            additionalCmd.Parameters.AddWithValue("@Category", category);
                            
                            DataTable additionalDt = new DataTable();
                            using (SqlDataAdapter additionalDa = new SqlDataAdapter(additionalCmd))
                            {
                                additionalDa.Fill(additionalDt);
                            }
                            
                            // ترکیب دو جدول
                            foreach (DataRow row in additionalDt.Rows)
                            {
                                dt.ImportRow(row);
                            }
                        }
                    }
                    
                    rptRelatedNews.DataSource = dt;
                    rptRelatedNews.DataBind();
                }
            }
            catch (Exception ex)
            {
                // در صورت خطا، اخبار مرتبط نمایش داده نمی‌شود
            }
        }
    }
}

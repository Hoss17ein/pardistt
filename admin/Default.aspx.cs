using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace shop1.Admin
{
    public partial class AdminDefault : System.Web.UI.Page
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
                LoadStatistics();
                LoadLatestNews();
                LoadLatestMessages();
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
                        litNewsCount.Text = result != null ? result.ToString() : "0";
                    }

                    // تعداد مربیان
                    using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Coaches", conn))
                    {
                        object result = cmd.ExecuteScalar();
                        litCoachesCount.Text = result != null ? result.ToString() : "0";
                    }

                    // تعداد تصاویر گالری
                    using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Gallery", conn))
                    {
                        object result = cmd.ExecuteScalar();
                        litGalleryCount.Text = result != null ? result.ToString() : "0";
                    }

                    // تعداد پیام‌های تماس
                    using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM ContactMessages", conn))
                    {
                        object result = cmd.ExecuteScalar();
                        litMessagesCount.Text = result != null ? result.ToString() : "0";
                    }

                    // تعداد ویژگی‌ها
                    using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Features", conn))
                    {
                        object result = cmd.ExecuteScalar();
                        litFeaturesCount.Text = result != null ? result.ToString() : "0";
                    }
                }
            }
            catch (Exception ex)
            {
                // در صورت خطا، مقادیر پیش‌فرض نمایش داده می‌شود
                litNewsCount.Text = "0";
                litCoachesCount.Text = "0";
                litGalleryCount.Text = "0";
                litMessagesCount.Text = "0";
                litFeaturesCount.Text = "0";
            }
        }

        private void LoadLatestNews()
        {
            try
            {
                DataTable dt = new DataTable();
                using (SqlConnection conn = new SqlConnection(ConnStr))
                using (SqlDataAdapter da = new SqlDataAdapter("SELECT TOP 5 Title, Summary, CreatedDate FROM [new] ORDER BY CreatedDate DESC", conn))
                {
                    da.Fill(dt);
                }
                rptLatestNews.DataSource = dt;
                rptLatestNews.DataBind();
            }
            catch (Exception ex)
            {
                // در صورت خطا، لیست خالی نمایش داده می‌شود
            }
        }

        private void LoadLatestMessages()
        {
            try
            {
                DataTable dt = new DataTable();
                using (SqlConnection conn = new SqlConnection(ConnStr))
                using (SqlDataAdapter da = new SqlDataAdapter("SELECT TOP 5 Name, Subject, CreatedDate FROM ContactMessages ORDER BY CreatedDate DESC", conn))
                {
                    da.Fill(dt);
                }
                rptLatestMessages.DataSource = dt;
                rptLatestMessages.DataBind();
            }
            catch (Exception ex)
            {
                // در صورت خطا، لیست خالی نمایش داده می‌شود
            }
        }
    }
}

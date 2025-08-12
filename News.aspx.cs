using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace Pardis
{
    public partial class NewsPage : System.Web.UI.Page
    {
        private string ConnStr { get { return ConfigurationManager.ConnectionStrings["my dataConnectionString"].ConnectionString; } }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindNews();
            }
        }

        private void BindNews()
        {
            DataTable dt = new DataTable();
            using (SqlConnection conn = new SqlConnection(ConnStr))
            using (SqlDataAdapter da = new SqlDataAdapter("SELECT Id, Title, Summary, ImageUrl, Category, CreatedDate FROM [new] ORDER BY CreatedDate DESC", conn))
            {
                da.Fill(dt);
            }
            rptNews.DataSource = dt; rptNews.DataBind();
        }
    }
}



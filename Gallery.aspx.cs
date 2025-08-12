using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace Pardis
{
    public partial class GalleryPage : System.Web.UI.Page
    {
        private string ConnStr { get { return ConfigurationManager.ConnectionStrings["my dataConnectionString"].ConnectionString; } }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindGallery();
            }
        }

        private void BindGallery()
        {
            DataTable dt = new DataTable();
            using (SqlConnection conn = new SqlConnection(ConnStr))
            using (SqlDataAdapter da = new SqlDataAdapter("SELECT Id, Title, Description, ImageUrl, CreatedDate FROM Gallery ORDER BY CreatedDate DESC", conn))
            {
                da.Fill(dt);
            }
            rptGallery.DataSource = dt; rptGallery.DataBind();
        }
    }
}



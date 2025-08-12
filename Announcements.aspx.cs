using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace Pardis
{
    public partial class AnnouncementsPage : System.Web.UI.Page
    {
        private string ConnStr { get { return ConfigurationManager.ConnectionStrings["my dataConnectionString"].ConnectionString; } }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindAnnouncements();
            }
        }

        private void BindAnnouncements()
        {
            DataTable dt = new DataTable();
            using (SqlConnection conn = new SqlConnection(ConnStr))
            using (SqlDataAdapter da = new SqlDataAdapter("SELECT Id, Title, Body, CreatedDate, IsActive FROM Announcements WHERE IsActive=1 ORDER BY CreatedDate DESC", conn))
            {
                da.Fill(dt);
            }
            rptAnnouncements.DataSource = dt; rptAnnouncements.DataBind();
        }
    }
}



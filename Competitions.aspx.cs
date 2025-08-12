using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace Pardis
{
    public partial class Competitions : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindCompetitions();
            }
        }

        private void BindCompetitions()
        {
            string connStr = ConfigurationManager.ConnectionStrings["my dataConnectionString"].ConnectionString;
            DataTable dt = new DataTable();
            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlDataAdapter da = new SqlDataAdapter("SELECT Id, Title, Location, StartDate, RegistrationDeadline, CoverImageUrl, IsActive FROM Competitions WHERE IsActive=1 ORDER BY StartDate DESC, Id DESC", conn))
            {
                da.Fill(dt);
            }
            rptCompetitions.DataSource = dt;
            rptCompetitions.DataBind();
        }
    }
}



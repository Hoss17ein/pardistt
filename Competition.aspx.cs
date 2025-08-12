using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace Pardis
{
    public partial class CompetitionPage : System.Web.UI.Page
    {
        private string ConnStr { get { return ConfigurationManager.ConnectionStrings["my dataConnectionString"].ConnectionString; } }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                int id;
                if (int.TryParse(Request.QueryString["id"], out id))
                {
                    LoadCompetition(id);
                    LoadRegistrations(id);
                }
                else
                {
                    pnlNotFound.Visible = true;
                }
            }
        }

        private void LoadCompetition(int id)
        {
            using (SqlConnection conn = new SqlConnection(ConnStr))
            using (SqlCommand cmd = new SqlCommand("SELECT Title, Description, Location, StartDate, RegistrationDeadline, CoverImageUrl, IsActive FROM Competitions WHERE Id=@Id", conn))
            {
                cmd.Parameters.AddWithValue("@Id", id);
                conn.Open();
                using (SqlDataReader r = cmd.ExecuteReader())
                {
                    if (r.Read())
                    {
                        pnlComp.Visible = true; pnlNotFound.Visible = false;
                        litTitle.Text = Convert.ToString(r["Title"]);
                        imgCover.ImageUrl = Convert.ToString(r["CoverImageUrl"]);
                        litDescription.Text = Convert.ToString(r["Description"]).Replace("\n", "<br/>");
                        string loc = Convert.ToString(r["Location"]);
                        string sd = r["StartDate"] == DBNull.Value ? "" : Convert.ToDateTime(r["StartDate"]).ToString("yyyy/MM/dd HH:mm");
                        string dl = r["RegistrationDeadline"] == DBNull.Value ? "" : Convert.ToDateTime(r["RegistrationDeadline"]).ToString("yyyy/MM/dd HH:mm");
                        litMeta.Text = string.Format("محل: {0} | شروع: {1} | ددلاین: {2}", loc, sd, dl);
                        lnkRegister.HRef = "/Register.aspx?id=" + id;
                    }
                    else
                    {
                        pnlNotFound.Visible = true; pnlComp.Visible = false;
                    }
                }
            }
        }

        private void LoadRegistrations(int competitionId)
        {
            DataTable dt = new DataTable();
            using (SqlConnection conn = new SqlConnection(ConnStr))
            using (SqlDataAdapter da = new SqlDataAdapter("SELECT FullName, CreatedDate FROM CompetitionRegistrations WHERE CompetitionId=@Id ORDER BY Id DESC", conn))
            {
                da.SelectCommand.Parameters.AddWithValue("@Id", competitionId);
                da.Fill(dt);
            }
            if (dt.Rows.Count == 0) { litNoRegs.Visible = true; }
            rptRegs.DataSource = dt; rptRegs.DataBind();
        }
    }
}



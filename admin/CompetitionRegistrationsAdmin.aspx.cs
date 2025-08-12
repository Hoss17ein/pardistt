using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace shop1.Admin
{
    public partial class CompetitionRegistrationsAdmin : System.Web.UI.Page
    {
        private string ConnStr { get { return ConfigurationManager.ConnectionStrings["my dataConnectionString"].ConnectionString; } }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!AdminAuth.IsAdminAuthenticated()) { Response.Redirect("Login.aspx"); return; }
            if (!IsPostBack)
            {
                BindGrid();
            }
        }

        private void BindGrid()
        {
            string q = @"SELECT r.Id, c.Title AS CompetitionTitle, r.FullName, r.Phone, r.Age, r.Gender, r.Status, r.CreatedDate, r.InsuranceImageUrl
                         FROM CompetitionRegistrations r INNER JOIN Competitions c ON r.CompetitionId=c.Id ORDER BY r.Id DESC";
            DataTable dt = new DataTable();
            using (SqlConnection conn = new SqlConnection(ConnStr))
            using (SqlDataAdapter da = new SqlDataAdapter(q, conn))
            {
                da.Fill(dt);
            }
            gvRegs.DataSource = dt;
            gvRegs.DataBind();
        }

        protected void gvRegs_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            int id = Convert.ToInt32(e.CommandArgument);
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                conn.Open();
                if (e.CommandName == "approve")
                {
                    using (SqlCommand cmd = new SqlCommand("UPDATE CompetitionRegistrations SET Status='Approved' WHERE Id=@Id", conn))
                    { cmd.Parameters.AddWithValue("@Id", id); cmd.ExecuteNonQuery(); }
                }
                else if (e.CommandName == "reject")
                {
                    using (SqlCommand cmd = new SqlCommand("UPDATE CompetitionRegistrations SET Status='Rejected' WHERE Id=@Id", conn))
                    { cmd.Parameters.AddWithValue("@Id", id); cmd.ExecuteNonQuery(); }
                }
                else if (e.CommandName == "deleteReg")
                {
                    using (SqlCommand cmd = new SqlCommand("DELETE FROM CompetitionRegistrations WHERE Id=@Id", conn))
                    { cmd.Parameters.AddWithValue("@Id", id); cmd.ExecuteNonQuery(); }
                }
            }
            BindGrid();
        }
    }
}



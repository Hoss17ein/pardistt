using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace shop1.Admin
{
    public partial class FeesAdmin : System.Web.UI.Page
    {
        private string ConnStr { get { return ConfigurationManager.ConnectionStrings["my dataConnectionString"].ConnectionString; } }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!AdminAuth.IsAdminAuthenticated()) { Response.Redirect("Login.aspx"); return; }
            if (!IsPostBack) { LoadGrid(); }
        }

        private void LoadGrid()
        {
            DataTable dt = new DataTable();
            using (SqlConnection conn = new SqlConnection(ConnStr))
            using (SqlDataAdapter da = new SqlDataAdapter("SELECT Id, CourseName, Sessions, Fee, Description FROM Fees ORDER BY Id DESC", conn))
            { da.Fill(dt); }
            gvFees.DataSource = dt; gvFees.DataBind();
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                conn.Open();
                SqlCommand cmd;
                if (string.IsNullOrEmpty(hfId.Value))
                {
                    cmd = new SqlCommand("INSERT INTO Fees (CourseName, Sessions, Fee, Description) VALUES (@n,@s,@f,@d)", conn);
                }
                else
                {
                    cmd = new SqlCommand("UPDATE Fees SET CourseName=@n, Sessions=@s, Fee=@f, Description=@d WHERE Id=@id", conn);
                    cmd.Parameters.AddWithValue("@id", hfId.Value);
                }
                cmd.Parameters.AddWithValue("@n", txtCourseName.Text.Trim());
                cmd.Parameters.AddWithValue("@s", txtSessions.Text.Trim());
                decimal fee; decimal.TryParse(txtFee.Text.Replace(",",""), out fee);
                cmd.Parameters.AddWithValue("@f", fee);
                cmd.Parameters.AddWithValue("@d", txtDescription.Text.Trim());
                cmd.ExecuteNonQuery();
            }
            ClearForm();
            LoadGrid();
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        { ClearForm(); }

        private void ClearForm()
        { hfId.Value = string.Empty; txtCourseName.Text = string.Empty; txtSessions.Text = string.Empty; txtFee.Text = string.Empty; txtDescription.Text = string.Empty; }

        protected void gvFees_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int id = Convert.ToInt32(e.CommandArgument);
            if (e.CommandName == "EditRow")
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                using (SqlCommand cmd = new SqlCommand("SELECT * FROM Fees WHERE Id=@id", conn))
                {
                    cmd.Parameters.AddWithValue("@id", id);
                    conn.Open();
                    using (SqlDataReader r = cmd.ExecuteReader())
                    {
                        if (r.Read())
                        {
                            hfId.Value = r["Id"].ToString();
                            txtCourseName.Text = r["CourseName"].ToString();
                            txtSessions.Text = r["Sessions"].ToString();
                            txtFee.Text = r["Fee"].ToString();
                            txtDescription.Text = r["Description"].ToString();
                        }
                    }
                }
            }
            else if (e.CommandName == "DeleteRow")
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                using (SqlCommand cmd = new SqlCommand("DELETE FROM Fees WHERE Id=@id", conn))
                {
                    conn.Open();
                    cmd.Parameters.AddWithValue("@id", id);
                    cmd.ExecuteNonQuery();
                }
                LoadGrid();
            }
        }
    }
}


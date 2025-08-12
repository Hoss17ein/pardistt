using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace shop1.Admin
{
    public partial class AnnouncementsAdmin : System.Web.UI.Page
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
            using (SqlDataAdapter da = new SqlDataAdapter("SELECT Id, Title, CreatedDate, IsActive FROM Announcements ORDER BY CreatedDate DESC", conn))
            { da.Fill(dt); }
            gvAnn.DataSource = dt; gvAnn.DataBind();
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                conn.Open();
                SqlCommand cmd;
                if (string.IsNullOrEmpty(hfId.Value))
                {
                    cmd = new SqlCommand("INSERT INTO Announcements (Title, Body, IsActive) VALUES (@t, @b, @a)", conn);
                }
                else
                {
                    cmd = new SqlCommand("UPDATE Announcements SET Title=@t, Body=@b, IsActive=@a WHERE Id=@id", conn);
                    cmd.Parameters.AddWithValue("@id", hfId.Value);
                }
                cmd.Parameters.AddWithValue("@t", txtTitle.Text.Trim());
                cmd.Parameters.AddWithValue("@b", txtBody.Text.Trim());
                cmd.Parameters.AddWithValue("@a", chkActive.Checked);
                cmd.ExecuteNonQuery();
            }
            ClearForm();
            LoadGrid();
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        { ClearForm(); }

        private void ClearForm()
        { hfId.Value = string.Empty; txtTitle.Text = string.Empty; txtBody.Text = string.Empty; chkActive.Checked = true; }

        protected void gvAnn_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int id = Convert.ToInt32(e.CommandArgument);
            if (e.CommandName == "EditRow")
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                using (SqlCommand cmd = new SqlCommand("SELECT * FROM Announcements WHERE Id=@id", conn))
                {
                    cmd.Parameters.AddWithValue("@id", id);
                    conn.Open();
                    using (SqlDataReader r = cmd.ExecuteReader())
                    {
                        if (r.Read())
                        {
                            hfId.Value = r["Id"].ToString();
                            txtTitle.Text = r["Title"].ToString();
                            txtBody.Text = r["Body"].ToString();
                            chkActive.Checked = r["IsActive"] != DBNull.Value ? Convert.ToBoolean(r["IsActive"]) : true;
                        }
                    }
                }
            }
            else if (e.CommandName == "DeleteRow")
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                using (SqlCommand cmd = new SqlCommand("DELETE FROM Announcements WHERE Id=@id", conn))
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


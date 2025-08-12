using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;

namespace shop1.Admin
{
    public partial class CompetitionsAdmin : System.Web.UI.Page
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
            DataTable dt = new DataTable();
            using (SqlConnection conn = new SqlConnection(ConnStr))
                using (SqlDataAdapter da = new SqlDataAdapter("SELECT Id, Title, Location, StartDate, RegistrationDeadline, IsActive, SingleFee, DoubleFee FROM Competitions ORDER BY StartDate DESC, Id DESC", conn))
            {
                da.Fill(dt);
            }
            gvCompetitions.DataSource = dt;
            gvCompetitions.DataBind();
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            string coverPath = null;
            if (fuCover.HasFile)
            {
                string ext = Path.GetExtension(fuCover.FileName).ToLower();
                if (ext == ".jpg" || ext == ".jpeg" || ext == ".png")
                {
                    string fileName = "images/uploads/competitions_" + DateTime.Now.Ticks + ext;
                    string physical = Server.MapPath("~/" + fileName);
                    Directory.CreateDirectory(Path.GetDirectoryName(physical));
                    fuCover.SaveAs(physical);
                    coverPath = fileName.Replace("\\", "/");
                }
            }

            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                conn.Open();
                if (string.IsNullOrEmpty(hdnId.Value))
                {
                    using (SqlCommand cmd = new SqlCommand(@"INSERT INTO Competitions (Title, Description, Location, StartDate, RegistrationDeadline, CoverImageUrl, IsActive, SingleFee, DoubleFee, CreatedDate, UpdatedDate)
VALUES (@Title, @Description, @Location, @StartDate, @Deadline, @Cover, @IsActive, @SingleFee, @DoubleFee, GETDATE(), GETDATE())", conn))
                    {
                        cmd.Parameters.AddWithValue("@Title", txtTitle.Text.Trim());
                        cmd.Parameters.AddWithValue("@Description", txtDescription.Text.Trim());
                        cmd.Parameters.AddWithValue("@Location", txtLocation.Text.Trim());
                        DateTime sd; DateTime.TryParse(txtStartDate.Text.Trim(), out sd);
                        DateTime dl; DateTime.TryParse(txtDeadline.Text.Trim(), out dl);
                        cmd.Parameters.AddWithValue("@StartDate", sd == DateTime.MinValue ? (object)DBNull.Value : sd);
                        cmd.Parameters.AddWithValue("@Deadline", dl == DateTime.MinValue ? (object)DBNull.Value : dl);
                        cmd.Parameters.AddWithValue("@Cover", (object)coverPath ?? DBNull.Value);
                        cmd.Parameters.AddWithValue("@IsActive", chkIsActive.Checked);
                        decimal sf = 0, df = 0; decimal.TryParse((txtSingleFee.Text ?? "").Replace(",",""), out sf); decimal.TryParse((txtDoubleFee.Text ?? "").Replace(",",""), out df);
                        cmd.Parameters.AddWithValue("@SingleFee", sf);
                        cmd.Parameters.AddWithValue("@DoubleFee", df > 0 ? df : sf * 2);
                        cmd.ExecuteNonQuery();
                    }
                }
                else
                {
                    using (SqlCommand cmd = new SqlCommand(@"UPDATE Competitions SET Title=@Title, Description=@Description, Location=@Location, StartDate=@StartDate, RegistrationDeadline=@Deadline, IsActive=@IsActive, SingleFee=@SingleFee, DoubleFee=@DoubleFee, UpdatedDate=GETDATE()" +
                        (coverPath != null ? ", CoverImageUrl=@Cover" : "") + " WHERE Id=@Id", conn))
                    {
                        cmd.Parameters.AddWithValue("@Id", Convert.ToInt32(hdnId.Value));
                        cmd.Parameters.AddWithValue("@Title", txtTitle.Text.Trim());
                        cmd.Parameters.AddWithValue("@Description", txtDescription.Text.Trim());
                        cmd.Parameters.AddWithValue("@Location", txtLocation.Text.Trim());
                        DateTime sd; DateTime.TryParse(txtStartDate.Text.Trim(), out sd);
                        DateTime dl; DateTime.TryParse(txtDeadline.Text.Trim(), out dl);
                        cmd.Parameters.AddWithValue("@StartDate", sd == DateTime.MinValue ? (object)DBNull.Value : sd);
                        cmd.Parameters.AddWithValue("@Deadline", dl == DateTime.MinValue ? (object)DBNull.Value : dl);
                        if (coverPath != null) cmd.Parameters.AddWithValue("@Cover", coverPath);
                        cmd.Parameters.AddWithValue("@IsActive", chkIsActive.Checked);
                        decimal sf = 0, df = 0; decimal.TryParse((txtSingleFee.Text ?? "").Replace(",",""), out sf); decimal.TryParse((txtDoubleFee.Text ?? "").Replace(",",""), out df);
                        cmd.Parameters.AddWithValue("@SingleFee", sf);
                        cmd.Parameters.AddWithValue("@DoubleFee", df > 0 ? df : sf * 2);
                        cmd.ExecuteNonQuery();
                    }
                }
            }

            ClearForm();
            BindGrid();
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            ClearForm();
        }

        private void ClearForm()
        {
            hdnId.Value = string.Empty;
            txtTitle.Text = string.Empty;
            txtLocation.Text = string.Empty;
            txtStartDate.Text = string.Empty;
            txtDeadline.Text = string.Empty;
            txtDescription.Text = string.Empty;
            chkIsActive.Checked = true;
        }

        protected void gvCompetitions_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            if (e.CommandName == "editItem")
            {
                int id = Convert.ToInt32(e.CommandArgument);
                using (SqlConnection conn = new SqlConnection(ConnStr))
                using (SqlCommand cmd = new SqlCommand("SELECT Id, Title, Description, Location, StartDate, RegistrationDeadline, IsActive FROM Competitions WHERE Id=@Id", conn))
                {
                    cmd.Parameters.AddWithValue("@Id", id);
                    conn.Open();
                    using (SqlDataReader r = cmd.ExecuteReader())
                    {
                        if (r.Read())
                        {
                            hdnId.Value = r["Id"].ToString();
                            txtTitle.Text = r["Title"].ToString();
                            txtDescription.Text = r["Description"].ToString();
                            txtLocation.Text = r["Location"].ToString();
                            object sd = r["StartDate"]; txtStartDate.Text = sd == DBNull.Value ? string.Empty : Convert.ToDateTime(sd).ToString("yyyy-MM-dd HH:mm");
                            object dl = r["RegistrationDeadline"]; txtDeadline.Text = dl == DBNull.Value ? string.Empty : Convert.ToDateTime(dl).ToString("yyyy-MM-dd HH:mm");
                            chkIsActive.Checked = r["IsActive"] != DBNull.Value && Convert.ToBoolean(r["IsActive"]);
                        }
                    }
                }
            }
            else if (e.CommandName == "deleteItem")
            {
                int id = Convert.ToInt32(e.CommandArgument);
                using (SqlConnection conn = new SqlConnection(ConnStr))
                using (SqlCommand cmd = new SqlCommand("DELETE FROM Competitions WHERE Id=@Id", conn))
                {
                    cmd.Parameters.AddWithValue("@Id", id);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
                BindGrid();
            }
        }
    }
}



using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace shop1.Admin
{
    public partial class CoachesAdmin : System.Web.UI.Page
    {
        private string ConnStr
        {
            get { return ConfigurationManager.ConnectionStrings["my dataConnectionString"].ConnectionString; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!AdminAuth.IsAdminAuthenticated())
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadCoaches();
            }
        }

        private void LoadCoaches()
        {
            try
            {
                DataTable dt = new DataTable();
                using (SqlConnection conn = new SqlConnection(ConnStr))
                using (SqlDataAdapter da = new SqlDataAdapter("SELECT Id, Name, Position, ImageUrl, Rating, Experience, Description, Specialty, AgeGroup FROM Coaches ORDER BY Id", conn))
                {
                    da.Fill(dt);
                }
                rptCoaches.DataSource = dt;
                rptCoaches.DataBind();
            }
            catch (Exception ex)
            {
                // Handle error
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                try
                {
                    string imageUrl = HandleImageUpload();
                    
                    using (SqlConnection conn = new SqlConnection(ConnStr))
                    {
                        conn.Open();
                        SqlCommand cmd;

                        if (string.IsNullOrEmpty(hfCoachId.Value)) // افزودن
                        {
                            string sql = "INSERT INTO Coaches (Name, Position, ImageUrl, Rating, Experience, Description, Specialty, AgeGroup) VALUES (@Name, @Position, @ImageUrl, @Rating, @Experience, @Description, @Specialty, @AgeGroup)";
                            cmd = new SqlCommand(sql, conn);
                        }
                        else // ویرایش
                        {
                            string sql = "UPDATE Coaches SET Name=@Name, Position=@Position, Rating=@Rating, Experience=@Experience, Description=@Description, Specialty=@Specialty, AgeGroup=@AgeGroup";
                            if (!string.IsNullOrEmpty(imageUrl))
                            {
                                sql += ", ImageUrl=@ImageUrl";
                            }
                            sql += " WHERE Id=@Id";
                            cmd = new SqlCommand(sql, conn);
                            cmd.Parameters.AddWithValue("@Id", hfCoachId.Value);
                        }

                        cmd.Parameters.AddWithValue("@Name", txtName.Text.Trim());
                        cmd.Parameters.AddWithValue("@Position", txtPosition.Text.Trim());
                        cmd.Parameters.AddWithValue("@Rating", Convert.ToInt32(ddlRating.SelectedValue));
                        cmd.Parameters.AddWithValue("@Experience", string.IsNullOrEmpty(txtExperience.Text) ? 0 : Convert.ToInt32(txtExperience.Text));
                        cmd.Parameters.AddWithValue("@Description", txtDescription.Text.Trim());
                        cmd.Parameters.AddWithValue("@Specialty", txtSpecialty.Text.Trim());
                        cmd.Parameters.AddWithValue("@AgeGroup", ddlAgeGroup.SelectedValue);
                        
                        if (!string.IsNullOrEmpty(imageUrl))
                        {
                            cmd.Parameters.AddWithValue("@ImageUrl", imageUrl);
                        }

                        cmd.ExecuteNonQuery();
                    }

                    ClearForm();
                    LoadCoaches();
                }
                catch (Exception ex)
                {
                    // Handle error
                }
            }
        }

        private string HandleImageUpload()
        {
            if (fuImage.HasFile)
            {
                try
                {
                    string fileName = DateTime.Now.ToString("yyyyMMdd_HHmmss_") + fuImage.FileName;
                    string uploadPath = Server.MapPath("~/uploads/coaches/");
                    
                    if (!Directory.Exists(uploadPath))
                    {
                        Directory.CreateDirectory(uploadPath);
                    }
                    
                    string fullPath = Path.Combine(uploadPath, fileName);
                    fuImage.SaveAs(fullPath);
                    
                    return "uploads/coaches/" + fileName;
                }
                catch
                {
                    return null;
                }
            }
            return null;
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            ClearForm();
        }

        private void ClearForm()
        {
            hfCoachId.Value = "";
            txtName.Text = "";
            txtPosition.Text = "";
            txtSpecialty.Text = "";
            txtDescription.Text = "";
            txtExperience.Text = "";
            ddlRating.SelectedValue = "5";
            ddlAgeGroup.SelectedIndex = 0;
            litFormTitle.Text = "افزودن مربی جدید";
            litCurrentImage.Text = "";
        }

        protected void rptCoaches_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int coachId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "EditCoach")
            {
                LoadCoachForEdit(coachId);
            }
            else if (e.CommandName == "DeleteCoach")
            {
                DeleteCoach(coachId);
            }
        }

        private void LoadCoachForEdit(int coachId)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                using (SqlCommand cmd = new SqlCommand("SELECT * FROM Coaches WHERE Id=@Id", conn))
                {
                    cmd.Parameters.AddWithValue("@Id", coachId);
                    conn.Open();
                    
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            hfCoachId.Value = reader["Id"].ToString();
                            txtName.Text = reader["Name"].ToString();
                            txtPosition.Text = reader["Position"].ToString();
                            txtSpecialty.Text = reader["Specialty"].ToString();
                            txtDescription.Text = reader["Description"].ToString();
                            txtExperience.Text = reader["Experience"].ToString();
                            ddlRating.SelectedValue = reader["Rating"].ToString();
                            ddlAgeGroup.SelectedValue = reader["AgeGroup"].ToString();
                            litFormTitle.Text = "ویرایش مربی";
                            
                            string imageUrl = reader["ImageUrl"].ToString();
                            if (!string.IsNullOrEmpty(imageUrl))
                            {
                                litCurrentImage.Text = "<br><img src='../" + imageUrl + "' style='max-width:100px;' />";
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                // Handle error
            }
        }

        private void DeleteCoach(int coachId)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                using (SqlCommand cmd = new SqlCommand("DELETE FROM Coaches WHERE Id=@Id", conn))
                {
                    cmd.Parameters.AddWithValue("@Id", coachId);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
                
                LoadCoaches();
            }
            catch (Exception ex)
            {
                // Handle error
            }
        }
    }
}

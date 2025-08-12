using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Pardis
{
    public partial class FeaturesAdmin : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadFeatures();
                SetDefaultColors();
            }
        }

        private void LoadFeatures()
        {
            string connStr = ConfigurationManager.ConnectionStrings["my dataConnectionString"].ConnectionString;
            DataTable dt = new DataTable();
            
            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlDataAdapter da = new SqlDataAdapter("SELECT Id, Title, Description, IconPath, BorderColor, BackgroundColor, IconColor, SortOrder, IsActive, CreatedDate, UpdatedDate FROM Features ORDER BY SortOrder, Id", conn))
            {
                da.Fill(dt);
            }
            
            gvFeatures.DataSource = dt;
            gvFeatures.DataBind();
        }

        private void SetDefaultColors()
        {
            if (ddlBorderColor.SelectedIndex == -1)
            {
                ddlBorderColor.SelectedValue = "blue-600";
                ddlBackgroundColor.SelectedValue = "blue-100";
                ddlIconColor.SelectedValue = "blue-600";
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                string connStr = ConfigurationManager.ConnectionStrings["my dataConnectionString"].ConnectionString;
                
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    
                    if (string.IsNullOrEmpty(hdnFeatureId.Value))
                    {
                        // Insert new feature
                        string insertQuery = @"INSERT INTO Features (Title, Description, IconPath, BorderColor, BackgroundColor, IconColor, SortOrder, IsActive, CreatedDate, UpdatedDate) 
                                             VALUES (@Title, @Description, @IconPath, @BorderColor, @BackgroundColor, @IconColor, @SortOrder, @IsActive, GETDATE(), GETDATE())";
                        
                        using (SqlCommand cmd = new SqlCommand(insertQuery, conn))
                        {
                            cmd.Parameters.AddWithValue("@Title", txtTitle.Text.Trim());
                            cmd.Parameters.AddWithValue("@Description", txtDescription.Text.Trim());
                            cmd.Parameters.AddWithValue("@IconPath", txtIconPath.Text.Trim());
                            cmd.Parameters.AddWithValue("@BorderColor", ddlBorderColor.SelectedValue);
                            cmd.Parameters.AddWithValue("@BackgroundColor", ddlBackgroundColor.SelectedValue);
                            cmd.Parameters.AddWithValue("@IconColor", ddlIconColor.SelectedValue);
                            cmd.Parameters.AddWithValue("@SortOrder", string.IsNullOrEmpty(txtSortOrder.Text) ? 0 : Convert.ToInt32(txtSortOrder.Text));
                            cmd.Parameters.AddWithValue("@IsActive", chkIsActive.Checked);
                            
                            cmd.ExecuteNonQuery();
                        }
                    }
                    else
                    {
                        // Update existing feature
                        string updateQuery = @"UPDATE Features SET Title = @Title, Description = @Description, IconPath = @IconPath, 
                                             BorderColor = @BorderColor, BackgroundColor = @BackgroundColor, IconColor = @IconColor, 
                                             SortOrder = @SortOrder, IsActive = @IsActive, UpdatedDate = GETDATE() 
                                             WHERE Id = @Id";
                        
                        using (SqlCommand cmd = new SqlCommand(updateQuery, conn))
                        {
                            cmd.Parameters.AddWithValue("@Id", Convert.ToInt32(hdnFeatureId.Value));
                            cmd.Parameters.AddWithValue("@Title", txtTitle.Text.Trim());
                            cmd.Parameters.AddWithValue("@Description", txtDescription.Text.Trim());
                            cmd.Parameters.AddWithValue("@IconPath", txtIconPath.Text.Trim());
                            cmd.Parameters.AddWithValue("@BorderColor", ddlBorderColor.SelectedValue);
                            cmd.Parameters.AddWithValue("@BackgroundColor", ddlBackgroundColor.SelectedValue);
                            cmd.Parameters.AddWithValue("@IconColor", ddlIconColor.SelectedValue);
                            cmd.Parameters.AddWithValue("@SortOrder", string.IsNullOrEmpty(txtSortOrder.Text) ? 0 : Convert.ToInt32(txtSortOrder.Text));
                            cmd.Parameters.AddWithValue("@IsActive", chkIsActive.Checked);
                            
                            cmd.ExecuteNonQuery();
                        }
                    }
                }
                
                ClearForm();
                LoadFeatures();
            }
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            ClearForm();
        }

        private void ClearForm()
        {
            hdnFeatureId.Value = string.Empty;
            txtTitle.Text = string.Empty;
            txtDescription.Text = string.Empty;
            txtIconPath.Text = string.Empty;
            txtSortOrder.Text = string.Empty;
            ddlBorderColor.SelectedIndex = 0;
            ddlBackgroundColor.SelectedIndex = 0;
            ddlIconColor.SelectedIndex = 0;
            chkIsActive.Checked = true;
            litFormTitle.Text = "افزودن ویژگی جدید";
        }

        protected void gvFeatures_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EditFeature")
            {
                int featureId = Convert.ToInt32(e.CommandArgument);
                LoadFeatureForEdit(featureId);
            }
            else if (e.CommandName == "DeleteFeature")
            {
                int featureId = Convert.ToInt32(e.CommandArgument);
                DeleteFeature(featureId);
            }
        }

        private void LoadFeatureForEdit(int featureId)
        {
            string connStr = ConfigurationManager.ConnectionStrings["my dataConnectionString"].ConnectionString;
            
            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand("SELECT Id, Title, Description, IconPath, BorderColor, BackgroundColor, IconColor, SortOrder, IsActive FROM Features WHERE Id = @Id", conn))
            {
                cmd.Parameters.AddWithValue("@Id", featureId);
                conn.Open();
                
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        hdnFeatureId.Value = reader["Id"].ToString();
                        txtTitle.Text = reader["Title"].ToString();
                        txtDescription.Text = reader["Description"].ToString();
                        txtIconPath.Text = reader["IconPath"].ToString();
                        txtSortOrder.Text = reader["SortOrder"].ToString();
                        ddlBorderColor.SelectedValue = reader["BorderColor"].ToString();
                        ddlBackgroundColor.SelectedValue = reader["BackgroundColor"].ToString();
                        ddlIconColor.SelectedValue = reader["IconColor"].ToString();
                        chkIsActive.Checked = Convert.ToBoolean(reader["IsActive"]);
                        litFormTitle.Text = "ویرایش ویژگی";
                    }
                }
            }
        }

        private void DeleteFeature(int featureId)
        {
            string connStr = ConfigurationManager.ConnectionStrings["my dataConnectionString"].ConnectionString;
            
            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand("DELETE FROM Features WHERE Id = @Id", conn))
            {
                cmd.Parameters.AddWithValue("@Id", featureId);
                conn.Open();
                cmd.ExecuteNonQuery();
            }
            
            LoadFeatures();
        }

        protected void gvFeatures_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                // Add any additional row styling if needed
            }
        }
    }
}

using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace shop1.Admin
{
    public partial class MenuAdmin : System.Web.UI.Page
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
                LoadParentMenus();
                LoadMenus();
                LoadMenuPreview();
            }
        }

        private void LoadParentMenus()
        {
            try
            {
                ddlParentMenu.Items.Clear();
                ddlParentMenu.Items.Add(new ListItem("منوی اصلی (بدون والد)", ""));

                using (SqlConnection conn = new SqlConnection(ConnStr))
                using (SqlCommand cmd = new SqlCommand("SELECT Id, Title FROM Menus WHERE ParentId IS NULL ORDER BY SortOrder, Title", conn))
                {
                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            ddlParentMenu.Items.Add(new ListItem(reader["Title"].ToString(), reader["Id"].ToString()));
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                // Handle error
            }
        }

        private void LoadMenus()
        {
            try
            {
                DataTable dt = new DataTable();
                using (SqlConnection conn = new SqlConnection(ConnStr))
                using (SqlDataAdapter da = new SqlDataAdapter(@"
                    SELECT Id, Title, Url, ParentId, SortOrder, 
                           ISNULL(IsActive, 1) as IsActive
                    FROM Menus 
                    ORDER BY ISNULL(SortOrder, 999), Title", conn))
                {
                    da.Fill(dt);
                }
                gvMenus.DataSource = dt;
                gvMenus.DataBind();
            }
            catch (Exception ex)
            {
                // Handle error
            }
        }

        private void LoadMenuPreview()
        {
            try
            {
                DataTable dt = new DataTable();
                using (SqlConnection conn = new SqlConnection(ConnStr))
                using (SqlDataAdapter da = new SqlDataAdapter(@"
                    SELECT Title, Url 
                    FROM Menus 
                    WHERE ParentId IS NULL AND ISNULL(IsActive, 1) = 1
                    ORDER BY ISNULL(SortOrder, 999), Title", conn))
                {
                    da.Fill(dt);
                }
                rptMenuPreview.DataSource = dt;
                rptMenuPreview.DataBind();
            }
            catch (Exception ex)
            {
                // Handle error
            }
        }

        protected string GetParentMenuTitle(object parentId)
        {
            if (parentId == null || parentId == DBNull.Value)
                return "-";

            try
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                using (SqlCommand cmd = new SqlCommand("SELECT Title FROM Menus WHERE Id = @ParentId", conn))
                {
                    cmd.Parameters.AddWithValue("@ParentId", parentId);
                    conn.Open();
                    object result = cmd.ExecuteScalar();
                    return result != null ? result.ToString() : "-";
                }
            }
            catch
            {
                return "-";
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                try
                {
                    using (SqlConnection conn = new SqlConnection(ConnStr))
                    {
                        conn.Open();
                        SqlCommand cmd;

                        if (string.IsNullOrEmpty(hfMenuId.Value)) // افزودن
                        {
                            string sql = "INSERT INTO Menus (Title, Url, ParentId, SortOrder, IsActive) VALUES (@Title, @Url, @ParentId, @SortOrder, @IsActive)";
                            cmd = new SqlCommand(sql, conn);
                        }
                        else // ویرایش
                        {
                            string sql = "UPDATE Menus SET Title=@Title, Url=@Url, ParentId=@ParentId, SortOrder=@SortOrder, IsActive=@IsActive WHERE Id=@Id";
                            cmd = new SqlCommand(sql, conn);
                            cmd.Parameters.AddWithValue("@Id", hfMenuId.Value);
                        }

                        cmd.Parameters.AddWithValue("@Title", txtTitle.Text.Trim());
                        cmd.Parameters.AddWithValue("@Url", txtUrl.Text.Trim());
                        
                        if (string.IsNullOrEmpty(ddlParentMenu.SelectedValue))
                            cmd.Parameters.AddWithValue("@ParentId", DBNull.Value);
                        else
                            cmd.Parameters.AddWithValue("@ParentId", ddlParentMenu.SelectedValue);
                        
                        int sortOrder = 0;
                        if (int.TryParse(txtSortOrder.Text, out sortOrder))
                            cmd.Parameters.AddWithValue("@SortOrder", sortOrder);
                        else
                            cmd.Parameters.AddWithValue("@SortOrder", DBNull.Value);

                        cmd.Parameters.AddWithValue("@IsActive", chkIsActive.Checked);

                        cmd.ExecuteNonQuery();
                    }

                    ClearForm();
                    LoadParentMenus();
                    LoadMenus();
                    LoadMenuPreview();

                    ClientScript.RegisterStartupScript(this.GetType(), "success", "alert('منو با موفقیت ذخیره شد!');", true);
                }
                catch (Exception ex)
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "error", "alert('خطا در ذخیره منو: " + ex.Message + "');", true);
                }
            }
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            ClearForm();
        }

        private void ClearForm()
        {
            hfMenuId.Value = "";
            txtTitle.Text = "";
            txtUrl.Text = "";
            txtSortOrder.Text = "";
            ddlParentMenu.SelectedIndex = 0;
            chkIsActive.Checked = true;
            litFormTitle.Text = "افزودن منوی جدید";
        }

        protected void gvMenus_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int menuId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "EditMenu")
            {
                LoadMenuForEdit(menuId);
            }
            else if (e.CommandName == "DeleteMenu")
            {
                DeleteMenu(menuId);
            }
        }

        private void LoadMenuForEdit(int menuId)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                using (SqlCommand cmd = new SqlCommand("SELECT * FROM Menus WHERE Id=@Id", conn))
                {
                    cmd.Parameters.AddWithValue("@Id", menuId);
                    conn.Open();
                    
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            hfMenuId.Value = reader["Id"].ToString();
                            txtTitle.Text = reader["Title"].ToString();
                            txtUrl.Text = reader["Url"].ToString();
                            txtSortOrder.Text = reader["SortOrder"] != DBNull.Value ? reader["SortOrder"].ToString() : "";
                            
                            if (reader["ParentId"] != DBNull.Value)
                                ddlParentMenu.SelectedValue = reader["ParentId"].ToString();
                            else
                                ddlParentMenu.SelectedIndex = 0;

                            chkIsActive.Checked = reader["IsActive"] != DBNull.Value ? Convert.ToBoolean(reader["IsActive"]) : true;
                            litFormTitle.Text = "ویرایش منو";
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "error", "alert('خطا در بارگذاری اطلاعات منو');", true);
            }
        }

        private void DeleteMenu(int menuId)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                {
                    conn.Open();
                    
                    // ابتدا بررسی کنیم که آیا این منو زیرمنو دارد یا نه
                    using (SqlCommand checkCmd = new SqlCommand("SELECT COUNT(*) FROM Menus WHERE ParentId = @MenuId", conn))
                    {
                        checkCmd.Parameters.AddWithValue("@MenuId", menuId);
                        int childCount = Convert.ToInt32(checkCmd.ExecuteScalar());
                        
                        if (childCount > 0)
                        {
                            ClientScript.RegisterStartupScript(this.GetType(), "error", "alert('این منو دارای زیرمنو است. ابتدا زیرمنوها را حذف کنید.');", true);
                            return;
                        }
                    }

                    // حذف منو
                    using (SqlCommand cmd = new SqlCommand("DELETE FROM Menus WHERE Id=@Id", conn))
                    {
                        cmd.Parameters.AddWithValue("@Id", menuId);
                        cmd.ExecuteNonQuery();
                    }
                }
                
                LoadParentMenus();
                LoadMenus();
                LoadMenuPreview();
                ClientScript.RegisterStartupScript(this.GetType(), "success", "alert('منو با موفقیت حذف شد!');", true);
            }
            catch (Exception ex)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "error", "alert('خطا در حذف منو: " + ex.Message + "');", true);
            }
        }

        protected void gvMenus_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvMenus.PageIndex = e.NewPageIndex;
            LoadMenus();
        }

        protected void btnReorderMenus_Click(object sender, EventArgs e)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                {
                    conn.Open();
                    
                    // مرتب‌سازی خودکار منوها بر اساس عنوان
                    string sql = @"
                        WITH OrderedMenus AS (
                            SELECT Id, ROW_NUMBER() OVER (ORDER BY Title) as NewOrder
                            FROM Menus 
                            WHERE ParentId IS NULL
                        )
                        UPDATE Menus 
                        SET SortOrder = om.NewOrder
                        FROM Menus m
                        INNER JOIN OrderedMenus om ON m.Id = om.Id";
                    
                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.ExecuteNonQuery();
                    }
                }
                
                LoadMenus();
                LoadMenuPreview();
                ClientScript.RegisterStartupScript(this.GetType(), "success", "alert('منوها مرتب‌سازی شدند!');", true);
            }
            catch (Exception ex)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "error", "alert('خطا در مرتب‌سازی منوها: " + ex.Message + "');", true);
            }
        }
    }
}

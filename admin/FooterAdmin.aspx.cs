using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace shop1.Admin
{
    public partial class FooterAdmin : System.Web.UI.Page
    {
        private string ConnStr { get { return ConfigurationManager.ConnectionStrings["my dataConnectionString"].ConnectionString; } }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!AdminAuth.IsAdminAuthenticated()) { Response.Redirect("Login.aspx"); return; }
            if (!IsPostBack)
            {
                LoadFooterSettings();
                LoadContactInfo();
                LoadFooterMenus();
                LoadSocial();
            }
        }

        private void LoadFooterSettings()
        {
            using (SqlConnection conn = new SqlConnection(ConnStr))
            using (SqlCommand cmd = new SqlCommand("SELECT TOP 1 * FROM HeaderSettings", conn))
            {
                conn.Open();
                using (SqlDataReader r = cmd.ExecuteReader())
                {
                    if (r.Read())
                    {
                        string logo = r["LogoUrl"] != DBNull.Value ? r["LogoUrl"].ToString() : "";
                        if (!string.IsNullOrEmpty(logo))
                            litCurrentLogo.Text = "<div class='mt-2'><img src='../" + logo + "' style='max-height:60px' /></div>";
                    }
                }
            }
            using (SqlConnection c2 = new SqlConnection(ConnStr))
            using (SqlCommand cmd2 = new SqlCommand("SELECT TOP 1 * FROM FooterSettings", c2))
            {
                c2.Open();
                using (SqlDataReader r = cmd2.ExecuteReader())
                {
                    if (r.Read())
                    {
                        txtFooterTitle.Text = r["FooterTitle"] != DBNull.Value ? r["FooterTitle"].ToString() : "";
                        txtFooterDescription.Text = r["FooterDescription"] != DBNull.Value ? r["FooterDescription"].ToString() : "";
                        txtCopyright.Text = r["CopyrightText"] != DBNull.Value ? r["CopyrightText"].ToString() : "";
                    }
                }
            }
        }

        private void LoadContactInfo()
        {
            using (SqlConnection conn = new SqlConnection(ConnStr))
            using (SqlCommand cmd = new SqlCommand("SELECT TOP 1 Address, Phone, Email FROM ContactInfo", conn))
            {
                conn.Open();
                using (SqlDataReader r = cmd.ExecuteReader())
                {
                    if (r.Read())
                    {
                        txtAddress.Text = r["Address"] != DBNull.Value ? r["Address"].ToString() : "";
                        txtPhone.Text = r["Phone"] != DBNull.Value ? r["Phone"].ToString() : "";
                        txtEmail.Text = r["Email"] != DBNull.Value ? r["Email"].ToString() : "";
                    }
                }
            }
        }

        private void LoadFooterMenus()
        {
            DataTable dt = new DataTable();
            using (SqlConnection conn = new SqlConnection(ConnStr))
            using (SqlDataAdapter da = new SqlDataAdapter("SELECT Id, Title, Url, ISNULL(ShowInFooter,0) as ShowInFooter FROM Menus ORDER BY ISNULL(SortOrder,999), Title", conn))
            { da.Fill(dt); }
            gvFooterMenus.DataSource = dt; gvFooterMenus.DataBind();
        }

        private void LoadSocial()
        {
            DataTable dt = new DataTable();
            using (SqlConnection conn = new SqlConnection(ConnStr))
            using (SqlDataAdapter da = new SqlDataAdapter("SELECT Id, Url, IconClass FROM SocialLinks ORDER BY Id DESC", conn))
            { da.Fill(dt); }
            gvSocial.DataSource = dt; gvSocial.DataBind();
        }

        protected void btnSaveFooter_Click(object sender, EventArgs e)
        {
            string logoUrl = HandleLogoUpload();
            // HeaderSettings logo
            if (!string.IsNullOrEmpty(logoUrl))
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                using (SqlCommand cmd = new SqlCommand(@"IF EXISTS(SELECT 1 FROM HeaderSettings)
UPDATE HeaderSettings SET LogoUrl=@LogoUrl
ELSE INSERT INTO HeaderSettings(SiteTitle, LogoUrl) VALUES(N'سایت', @LogoUrl)", conn))
                {
                    conn.Open();
                    cmd.Parameters.AddWithValue("@LogoUrl", logoUrl);
                    cmd.ExecuteNonQuery();
                }
            }

            // FooterSettings
            using (SqlConnection c2 = new SqlConnection(ConnStr))
            using (SqlCommand f = new SqlCommand(@"IF EXISTS (SELECT 1 FROM FooterSettings)
UPDATE FooterSettings SET FooterTitle=@t, FooterDescription=@d, CopyrightText=@c
ELSE INSERT INTO FooterSettings(FooterTitle, FooterDescription, CopyrightText) VALUES(@t, @d, @c)", c2))
            {
                c2.Open();
                f.Parameters.AddWithValue("@t", txtFooterTitle.Text.Trim());
                f.Parameters.AddWithValue("@d", txtFooterDescription.Text.Trim());
                f.Parameters.AddWithValue("@c", txtCopyright.Text.Trim());
                f.ExecuteNonQuery();
            }

            LoadFooterSettings();
        }

        private string HandleLogoUpload()
        {
            if (fuLogo.HasFile)
            {
                string ext = Path.GetExtension(fuLogo.FileName).ToLower();
                if (ext != ".jpg" && ext != ".jpeg" && ext != ".png" && ext != ".gif") return null;
                if (fuLogo.PostedFile.ContentLength > 2 * 1024 * 1024) return null;
                string fileName = "logo_" + DateTime.Now.ToString("yyyyMMdd_HHmmss") + ext;
                string upload = Server.MapPath("~/uploads/");
                if (!Directory.Exists(upload)) Directory.CreateDirectory(upload);
                fuLogo.SaveAs(Path.Combine(upload, fileName));
                return "uploads/" + fileName;
            }
            return null;
        }

        protected void btnSaveContact_Click(object sender, EventArgs e)
        {
            using (SqlConnection conn = new SqlConnection(ConnStr))
            using (SqlCommand cmd = new SqlCommand(@"IF EXISTS (SELECT 1 FROM ContactInfo)
UPDATE ContactInfo SET Address=@a, Phone=@p, Email=@e
ELSE INSERT INTO ContactInfo(Address, Phone, Email) VALUES(@a, @p, @e)", conn))
            {
                conn.Open();
                cmd.Parameters.AddWithValue("@a", txtAddress.Text.Trim());
                cmd.Parameters.AddWithValue("@p", txtPhone.Text.Trim());
                cmd.Parameters.AddWithValue("@e", txtEmail.Text.Trim());
                cmd.ExecuteNonQuery();
            }
            LoadContactInfo();
        }

        protected void gvFooterMenus_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ToggleFooter")
            {
                int id = Convert.ToInt32(e.CommandArgument);
                using (SqlConnection conn = new SqlConnection(ConnStr))
                using (SqlCommand cmd = new SqlCommand("UPDATE Menus SET ShowInFooter = CASE WHEN ISNULL(ShowInFooter,0)=1 THEN 0 ELSE 1 END WHERE Id=@Id", conn))
                {
                    conn.Open();
                    cmd.Parameters.AddWithValue("@Id", id);
                    cmd.ExecuteNonQuery();
                }
                LoadFooterMenus();
            }
        }

        protected void gvSocial_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int id = Convert.ToInt32(e.CommandArgument);
            if (e.CommandName == "EditRow")
            {
                Response.Redirect("SocialLinksAdmin.aspx?id=" + id);
            }
            else if (e.CommandName == "DeleteRow")
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                using (SqlCommand cmd = new SqlCommand("DELETE FROM SocialLinks WHERE Id=@Id", conn))
                {
                    conn.Open();
                    cmd.Parameters.AddWithValue("@Id", id);
                    cmd.ExecuteNonQuery();
                }
                LoadSocial();
            }
        }
    }
}


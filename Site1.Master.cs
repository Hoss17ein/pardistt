using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace Pardis
{
    public partial class Site1 : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadHeaderSettings();
                LoadMenus();
                LoadContactInfo();
                // Register PWA service worker on public pages
                try
                {
                    System.Web.UI.LiteralControl sw = new System.Web.UI.LiteralControl("<script>if('serviceWorker' in navigator){navigator.serviceWorker.register('/sw.js').catch(function(e){});}</script>");
                    this.Page.Header.Controls.Add(sw);
                }
                catch { }
                // cart count
                try
                {
                    var cart = CartHelper.GetCart();
                    var lit = FindControl("litCartCount") as System.Web.UI.WebControls.Literal;
                    if (lit != null) lit.Text = cart != null ? cart.Count.ToString() : "0";
                }
                catch { }
            }
        }

        private string ConnStr 
        { 
            get { return ConfigurationManager.ConnectionStrings["my dataConnectionString"].ConnectionString; }
        }

        private void LoadHeaderSettings()
        {
            using (SqlConnection conn = new SqlConnection(ConnStr))
            using (SqlCommand cmd = new SqlCommand("SELECT TOP 1 SiteTitle, LogoUrl FROM HeaderSettings", conn))
            {
                conn.Open();
                using (SqlDataReader r = cmd.ExecuteReader())
                {
                    if (r.Read())
                    {
                        string siteTitle = r["SiteTitle"] != null ? r["SiteTitle"].ToString() : "پردیس";
                        litSiteTitle.Text = siteTitle;
                        
                        string logo = r["LogoUrl"] != null ? r["LogoUrl"].ToString() : null;
                        if (!string.IsNullOrEmpty(logo))
                        {
                            string url = ResolveUrl("~/" + logo.TrimStart('/'));
                            imgLogo.ImageUrl = url;
                            // Use same logo in footer
                            if (imgFooterLogo != null) imgFooterLogo.ImageUrl = url;
                            // if a png provided, also set favicon
                            var fav = this.FindControl("lnkFavicon") as System.Web.UI.HtmlControls.HtmlLink;
                            if (fav != null) fav.Href = url;
                        }
                    }
                }
            }
            // Footer text/title from FooterSettings (fallback to header title)
            try
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                using (SqlCommand cmd = new SqlCommand("SELECT TOP 1 FooterTitle, FooterDescription FROM FooterSettings", conn))
                {
                    conn.Open();
                    using (SqlDataReader r = cmd.ExecuteReader())
                    {
                        if (r.Read())
                        {
                            string ft = r["FooterTitle"] != DBNull.Value ? r["FooterTitle"].ToString() : null;
                            string fd = r["FooterDescription"] != DBNull.Value ? r["FooterDescription"].ToString() : null;
                            if (!string.IsNullOrEmpty(ft)) litFooterTitle.Text = ft; else litFooterTitle.Text = litSiteTitle.Text;
                            if (!string.IsNullOrEmpty(fd)) litFooterDescription.Text = fd;
                        }
                        else
                        {
                            litFooterTitle.Text = litSiteTitle.Text;
                        }
                    }
                }
            }
            catch { litFooterTitle.Text = litSiteTitle.Text; }
        }

        private void LoadMenus()
        {
            DataTable dt = new DataTable();
            using (SqlConnection conn = new SqlConnection(ConnStr))
            using (SqlDataAdapter da = new SqlDataAdapter("SELECT Id, Title, Url FROM Menus ORDER BY Id", conn))
            {
                da.Fill(dt);
            }
            rptMenuDesktop.DataSource = dt;
            rptMenuDesktop.DataBind();
            rptMenuMobile.DataSource = dt;
            rptMenuMobile.DataBind();
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
                        litAddress.Text = r["Address"] != null ? r["Address"].ToString() : "";
                        litPhone.Text = r["Phone"] != null ? r["Phone"].ToString() : "";
                        litEmail.Text = r["Email"] != null ? r["Email"].ToString() : "";
                    }
                }
            }

            // Footer quick links from Menus
            DataTable links = new DataTable();
            using (SqlConnection conn = new SqlConnection(ConnStr))
            using (SqlDataAdapter da = new SqlDataAdapter("SELECT Title, Url FROM Menus WHERE ISNULL(IsActive,1)=1 AND ISNULL(ShowInFooter,0)=1 ORDER BY ISNULL(SortOrder,999), Title", conn))
            {
                da.Fill(links);
            }
            rptFooterLinks.DataSource = links;
            rptFooterLinks.DataBind();

            // Social icons if SocialLinks table exists
            try
            {
                DataTable socials = new DataTable();
                using (SqlConnection conn = new SqlConnection(ConnStr))
                using (SqlDataAdapter da = new SqlDataAdapter("SELECT Url, IconClass FROM SocialLinks ORDER BY Id", conn))
                {
                    da.Fill(socials);
                }
                if (socials.Rows.Count > 0)
                {
                    rptSocial.DataSource = socials;
                    rptSocial.DataBind();
                }
            }
            catch { }

            // Copyright from FooterSettings (fallback HeaderSettings)
            try
            {
                string copyText = null;
                using (SqlConnection conn = new SqlConnection(ConnStr))
                using (SqlCommand cmd = new SqlCommand("SELECT TOP 1 CopyrightText FROM FooterSettings", conn))
                {
                    conn.Open();
                    object t = cmd.ExecuteScalar();
                    if (t != null && t != DBNull.Value) copyText = t.ToString();
                }
                if (string.IsNullOrEmpty(copyText))
                {
                    using (SqlConnection conn = new SqlConnection(ConnStr))
                    using (SqlCommand cmd = new SqlCommand("SELECT TOP 1 '© ' + CONVERT(varchar(4), YEAR(GETDATE())) + ' - تمامی حقوق برای ' + SiteTitle + ' محفوظ است.' AS Copy FROM HeaderSettings", conn))
                    {
                        conn.Open();
                        object text = cmd.ExecuteScalar();
                        if (text != null) copyText = text.ToString();
                    }
                }
                Literal lit = this.FindControl("litCopyright") as Literal;
                if (lit != null && !string.IsNullOrEmpty(copyText)) lit.Text = copyText;
            }
            catch { }

            // Toggle bottom auth links based on authentication
            try
            {
                System.Web.UI.WebControls.HyperLink lnkAuth = this.FindControl("lnkBottomAuth") as System.Web.UI.WebControls.HyperLink;
                System.Web.UI.WebControls.HyperLink lnkPanel = this.FindControl("lnkBottomPanel") as System.Web.UI.WebControls.HyperLink;
                System.Web.UI.WebControls.HyperLink lnkTopAuth = this.FindControl("lnkTopAuth") as System.Web.UI.WebControls.HyperLink;
                System.Web.UI.WebControls.HyperLink lnkTopPanel = this.FindControl("lnkTopPanel") as System.Web.UI.WebControls.HyperLink;
                bool isAuth = System.Web.Security.Membership.GetUser() != null;
                if (lnkAuth != null) lnkAuth.Visible = !isAuth;
                if (lnkPanel != null) lnkPanel.Visible = isAuth;
                if (lnkTopAuth != null) lnkTopAuth.Visible = !isAuth;
                if (lnkTopPanel != null) lnkTopPanel.Visible = isAuth;
            }
            catch { }
        }
    }
}
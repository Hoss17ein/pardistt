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
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadMainSlideshow();
                LoadFeatures();
                LoadAnnouncements();
                LoadNews();
                LoadCoaches();
                LoadGallery();
                LoadFees();
                LoadContactInfoPublic();
            }
        }

        private void LoadAnnouncements()
        {
            string connStr = ConfigurationManager.ConnectionStrings["my dataConnectionString"].ConnectionString;
            DataTable dt = new DataTable();
            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlDataAdapter da = new SqlDataAdapter("SELECT TOP 3 Id, Title, Body, CreatedDate, IsActive FROM Announcements WHERE IsActive = 1 ORDER BY CreatedDate DESC", conn))
            {
                da.Fill(dt);
            }
            rptAnnouncements.DataSource = dt;
            rptAnnouncements.DataBind();
        }

        private void LoadContactInfoPublic()
        {
            string connStr = ConfigurationManager.ConnectionStrings["my dataConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand("SELECT TOP 1 Address, Phone, Email FROM ContactInfo", conn))
            {
                conn.Open();
                using (SqlDataReader r = cmd.ExecuteReader())
                {
                    if (r.Read())
                    {
                        if (litContactAddress != null) litContactAddress.Text = r["Address"] != DBNull.Value ? r["Address"].ToString() : "";
                        if (litContactPhone != null) litContactPhone.Text = r["Phone"] != DBNull.Value ? r["Phone"].ToString() : "";
                        if (litContactEmail != null) litContactEmail.Text = r["Email"] != DBNull.Value ? r["Email"].ToString() : "";
                    }
                }
            }
        }

        protected void btnContactSubmit_Click(object sender, EventArgs e)
        {
            string connStr = ConfigurationManager.ConnectionStrings["my dataConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand("INSERT INTO ContactMessages (Name, Phone, Subject, Body, CreatedDate) VALUES (@Name,@Phone,@Subject,@Body,GETDATE())", conn))
            {
                cmd.Parameters.AddWithValue("@Name", txtContactName.Text.Trim());
                cmd.Parameters.AddWithValue("@Phone", txtContactPhone.Text.Trim());
                cmd.Parameters.AddWithValue("@Subject", ddlContactSubject.SelectedValue);
                cmd.Parameters.AddWithValue("@Body", txtContactBody.Text.Trim());
                conn.Open();
                cmd.ExecuteNonQuery();
            }
            litContactResult.Text = "<span class='text-green-200'>پیام شما با موفقیت ارسال شد.</span>";
            txtContactName.Text = txtContactPhone.Text = txtContactBody.Text = string.Empty;
        }

        private void LoadNews()
        {
            string connStr = ConfigurationManager.ConnectionStrings["my dataConnectionString"].ConnectionString;
            DataTable dt = new DataTable();
            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlDataAdapter da = new SqlDataAdapter("SELECT TOP 3 Id, Title, Summary, ImageUrl, Category, CreatedDate FROM [new] ORDER BY CreatedDate DESC", conn))
            {
                da.Fill(dt);
            }
            rptNews.DataSource = dt;
            rptNews.DataBind();
        }
        private void LoadCoaches()
        {
            string connStr = ConfigurationManager.ConnectionStrings["my dataConnectionString"].ConnectionString;
            DataTable dt = new DataTable();
            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlDataAdapter da = new SqlDataAdapter("SELECT Id, Name, Position, ImageUrl, Rating, Experience, Description, Specialty, AgeGroup FROM Coaches ORDER BY Id", conn))
            {
                da.Fill(dt);
            }
            rptCoaches.DataSource = dt;
            rptCoaches.DataBind();
        }

        private void LoadGallery()
        {
            string connStr = ConfigurationManager.ConnectionStrings["my dataConnectionString"].ConnectionString;
            DataTable dt = new DataTable();
            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlDataAdapter da = new SqlDataAdapter("SELECT TOP 3 Id, Title, Description, ImageUrl FROM Gallery ORDER BY Id DESC", conn))
            {
                da.Fill(dt);
            }
            rptGallery.DataSource = dt;
            rptGallery.DataBind();
        }

        private void LoadFees()
        {
            string connStr = ConfigurationManager.ConnectionStrings["my dataConnectionString"].ConnectionString;
            DataTable dt = new DataTable();
            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlDataAdapter da = new SqlDataAdapter("SELECT Id, CourseName, Sessions, Fee, Description FROM Fees ORDER BY Id", conn))
            {
                da.Fill(dt);
            }
            rptFees.DataSource = dt;
            rptFees.DataBind();
        }

        private void LoadMainSlideshow()
        {
            try
            {
                string connStr = ConfigurationManager.ConnectionStrings["my dataConnectionString"].ConnectionString;
                DataTable dt = new DataTable();
                using (SqlConnection conn = new SqlConnection(connStr))
                using (SqlDataAdapter da = new SqlDataAdapter("SELECT Id, Title, Description, ImageUrl, Link FROM Slideshow WHERE IsActive = 1 ORDER BY SortOrder, Id", conn))
                {
                    da.Fill(dt);
                }
                rptMainSlideshow.DataSource = dt;
                rptMainSlideshow.DataBind();
            }
            catch (Exception ex)
            {
                // اگر جدول Slideshow وجود نداشته باشد، خطا نده
            }
        }

        private void LoadFeatures()
        {
            string connStr = ConfigurationManager.ConnectionStrings["my dataConnectionString"].ConnectionString;
            DataTable dt = new DataTable();
            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlDataAdapter da = new SqlDataAdapter("SELECT Id, Title, Description, IconPath, BorderColor, BackgroundColor, IconColor, SortOrder FROM Features WHERE IsActive = 1 ORDER BY SortOrder, Id", conn))
            {
                da.Fill(dt);
            }
            rptFeatures.DataSource = dt;
            rptFeatures.DataBind();
        }

        protected int[] GenerateStars(int count)
        {
            if (count <= 0) return new int[0];
            return new int[count];
        }
    }
}
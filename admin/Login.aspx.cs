using System;
using System.Data.SqlClient;
using System.Web.Security;

public partial class Admin_Login : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // اگر قبلاً وارد شده، به داشبورد هدایت شود
        if (shop1.AdminAuth.IsAdminAuthenticated())
        {
            Response.Redirect("Default.aspx");
        }
    }

    protected void btnLogin_Click(object sender, EventArgs e)
    {
        string username = txtUsername.Text.Trim();
        string password = txtPassword.Text;

        if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password))
        {
            lblMsg.Text = "لطفاً نام کاربری و رمز عبور را وارد کنید.";
            return;
        }

        if (shop1.AdminAuth.AuthenticateAdmin(username, password))
        {
            Response.Redirect("Default.aspx");
        }
        else
        {
            lblMsg.Text = "نام کاربری یا رمز عبور اشتباه است یا شما ادمین نیستید.";
        }
    }
} 
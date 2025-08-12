using System;

public partial class Admin_Logout : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // خروج از پنل ادمین
        shop1.AdminAuth.LogoutAdmin();
        
        // هدایت به صفحه ورود بعد از 2 ثانیه
        Response.AddHeader("Refresh", "2;url=Login.aspx");
    }
} 
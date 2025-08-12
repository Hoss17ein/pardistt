using System;
using System.Web.Security;

namespace Pardis.Account
{
    public partial class Login : System.Web.UI.Page
    {
        protected void btnLogin_Click(object sender, EventArgs e)
        {
            if (Membership.ValidateUser(txtUser.Text.Trim(), txtPass.Text.Trim()))
            {
                FormsAuthentication.SetAuthCookie(txtUser.Text.Trim(), true);
                Response.Redirect("~/");
            }
            else
            {
                litMsg.Text = "<span class='text-red-600'>نام کاربری یا کلمه عبور اشتباه است.</span>";
            }
        }
    }
}



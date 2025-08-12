using System;
using System.Web.Security;

namespace Pardis.Account
{
    public partial class Register : System.Web.UI.Page
    {
        protected void btnRegister_Click(object sender, EventArgs e)
        {
            try
            {
                Membership.CreateUser(txtUser.Text.Trim(), txtPass.Text.Trim(), txtEmail.Text.Trim());
                litMsg.Text = "<span class='text-green-600'>ثبت‌نام با موفقیت انجام شد. اکنون وارد شوید.</span>";
            }
            catch (Exception ex)
            {
                litMsg.Text = "<span class='text-red-600'>" + Server.HtmlEncode(ex.Message) + "</span>";
            }
        }
    }
}



using System;
using System.Web.Security;

namespace Pardis.Account
{
    public partial class ForgotPassword : System.Web.UI.Page
    {
        protected void btnSend_Click(object sender, EventArgs e)
        {
            try
            {
                MembershipUser user = Membership.GetUser(txtUser.Text.Trim());
                if (user == null)
                {
                    litMsg.Text = "<span class='text-red-600'>کاربر یافت نشد.</span>";
                    return;
                }
                // چون requiresQuestionAndAnswer=false و enablePasswordReset=true در Web.config است
                string newPass = user.ResetPassword();
                // در محیط واقعی باید ایمیل ارسال شود. اینجا فقط نمایش آموزشی می‌دهیم:
                litMsg.Text = "<span class='text-green-600'>رمز جدید: " + Server.HtmlEncode(newPass) + "</span>";
            }
            catch (Exception ex)
            {
                litMsg.Text = "<span class='text-red-600'>" + Server.HtmlEncode(ex.Message) + "</span>";
            }
        }
    }
}



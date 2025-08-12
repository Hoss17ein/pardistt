using System;
using System.Web.Security;

namespace Pardis.Account
{
    public partial class ChangePassword : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Membership.GetUser() == null) { Response.Redirect("/Account/Login.aspx"); }
        }

        protected void btnChange_Click(object sender, EventArgs e)
        {
            var u = Membership.GetUser();
            if (u == null) return;
            try
            {
                if (u.ChangePassword(txtOld.Text.Trim(), txtNew.Text.Trim()))
                {
                    litMsg.Text = "<span class='text-green-600'>رمز با موفقیت تغییر کرد.</span>";
                }
                else
                {
                    litMsg.Text = "<span class='text-red-600'>تغییر رمز ناموفق بود.</span>";
                }
            }
            catch (Exception ex)
            {
                litMsg.Text = "<span class='text-red-600'>" + Server.HtmlEncode(ex.Message) + "</span>";
            }
        }
    }
}



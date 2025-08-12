using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace shop1.Admin
{
    public partial class AdminMaster : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // بررسی احراز هویت ادمین - فقط با کوکی مسیر /admin معتبر است
            if (!shop1.AdminAuth.IsAdminAuthenticated())
            {
                Response.Redirect("Login.aspx");
                return;
            }

            // نمایش نام کاربر ادمین
            if (!IsPostBack)
            {
                string adminUsername = shop1.AdminAuth.GetCurrentAdminUsername();
                if (!string.IsNullOrEmpty(adminUsername))
                {
                    litAdminUsername.Text = adminUsername;
                }
                else
                {
                    litAdminUsername.Text = "ادمین";
                }
            }
        }
    }
}
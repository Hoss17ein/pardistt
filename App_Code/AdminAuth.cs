using System;
using System.Web;
using System.Web.Security;

namespace shop1
{
    public static class AdminAuth
    {
        private static readonly string[] AdminRoleNames = new string[] { "Admin", "Administrators" };

        public static bool AuthenticateAdmin(string username, string password)
        {
            if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password))
            {
                return false;
            }

            bool isValidUser = Membership.ValidateUser(username, password);
            if (!isValidUser)
            {
                return false;
            }

            // ایجاد کوکی احراز هویت فقط برای مسیر /admin تا ورود ادمین در سایت عمومی اثر نگذارد
            FormsAuthenticationTicket ticket = new FormsAuthenticationTicket(
                1,
                username,
                DateTime.Now,
                DateTime.Now.AddMinutes(60),
                false,
                "admin");
            string encTicket = FormsAuthentication.Encrypt(ticket);
            HttpCookie authCookie = new HttpCookie(FormsAuthentication.FormsCookieName, encTicket)
            {
                HttpOnly = true,
                Path = "/admin"
            };
            HttpContext.Current.Response.Cookies.Add(authCookie);

            if (Roles.Enabled)
            {
                try
                {
                    foreach (string roleName in AdminRoleNames)
                    {
                        if (Roles.IsUserInRole(username, roleName))
                        {
                            return true;
                        }
                    }
                    FormsAuthentication.SignOut();
                    return false;
                }
                catch
                {
                    // اگر نقش‌ها قابل بررسی نبود، دسترسی ادمین نده
                    return false;
                }
            }

            return true;
        }

        public static bool IsAdminAuthenticated()
        {
            if (HttpContext.Current == null || HttpContext.Current.User == null || 
                HttpContext.Current.User.Identity == null || !HttpContext.Current.User.Identity.IsAuthenticated)
            {
                return false;
            }

            if (Roles.Enabled)
            {
                try
                {
                    string userName = HttpContext.Current.User.Identity.Name;
                    foreach (string roleName in AdminRoleNames)
                    {
                        if (Roles.IsUserInRole(userName, roleName))
                        {
                            return true;
                        }
                    }
                    return false;
                }
                catch
                {
                    // در صورت بروز خطا در Role Provider، دسترسی ادمین نده
                    return false;
                }
            }

            return true;
        }

        public static string GetCurrentAdminUsername()
        {
            if (HttpContext.Current != null && HttpContext.Current.User != null && 
                HttpContext.Current.User.Identity != null)
            {
                return HttpContext.Current.User.Identity.Name;
            }
            return string.Empty;
        }

        public static void LogoutAdmin()
        {
            FormsAuthentication.SignOut();
            try
            {
                // ابطال کوکی مسیر /admin نیز لازم است
                HttpCookie c = new HttpCookie(FormsAuthentication.FormsCookieName, "")
                {
                    Expires = DateTime.Now.AddDays(-1),
                    Path = "/admin"
                };
                HttpContext.Current.Response.Cookies.Add(c);
            }
            catch {}
            try
            {
                HttpContext.Current.Session.Abandon();
            }
            catch
            {
            }
        }
    }
}
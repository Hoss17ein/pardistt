using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.Security;

namespace Pardis.Account
{
    public partial class Panel : System.Web.UI.Page
    {
        private string ConnStr { get { return ConfigurationManager.ConnectionStrings["my dataConnectionString"].ConnectionString; } }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Membership.GetUser() == null) { Response.Redirect("/Account/Login.aspx"); return; }
            if (!IsPostBack)
            {
                var u = Membership.GetUser();
                if (u != null)
                {
                    litUsername.Text = u.UserName;
                    litEmail.Text = Convert.ToString(u.Email);
                }
                // Prefill profile fields
                try
                {
                    object pf = Context.Profile.GetPropertyValue("FirstName");
                    object pl = Context.Profile.GetPropertyValue("LastName");
                    object ph = Context.Profile.GetPropertyValue("Phone");
                    if (pf != null) txtFirstName.Text = Convert.ToString(pf);
                    if (pl != null) txtLastName.Text = Convert.ToString(pl);
                    if (ph != null) txtPhone.Text = Convert.ToString(ph);
                }
                catch { }
                BindMyOrders();
                BindMyRegistrations();
                BindAddresses();
            }
        }
        private void BindMyOrders()
        {
            var u = Membership.GetUser();
            if (u == null) return;
            DataTable dt = new DataTable();
            try
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                using (SqlDataAdapter da = new SqlDataAdapter("SELECT Id, TotalAmount, Status, CreatedDate FROM Orders WHERE Username=@User ORDER BY Id DESC", conn))
                {
                    da.SelectCommand.Parameters.AddWithValue("@User", u.UserName);
                    da.Fill(dt);
                }
                if (dt.Rows.Count == 0 && litOrdersMsg != null)
                {
                    litOrdersMsg.Text = "<div class='text-sm text-gray-600 mb-3'>سفارشی ثبت نشده است.</div>";
                }
            }
            catch (SqlException)
            {
                if (litOrdersMsg != null)
                {
                    litOrdersMsg.Text = "<div class='text-sm text-yellow-800 bg-yellow-100 rounded p-3 mb-3'>جدول سفارش‌ها در دیتابیس موجود نیست. برای حذف این پیام، جدول 'Orders' را ایجاد کنید یا این بخش را غیرفعال نمایید.</div>";
                }
            }
            catch (Exception)
            {
                if (litOrdersMsg != null)
                {
                    litOrdersMsg.Text = "<div class='text-sm text-red-800 bg-red-100 rounded p-3 mb-3'>بروز خطا در بارگیری سفارش‌ها.</div>";
                }
            }
            rptOrders.DataSource = dt; rptOrders.DataBind();
        }

        private void BindMyRegistrations()
        {
            // فیلتر بر اساس موبایل کاربر در پروفایل (اگر در Membership ایمیل/موبایل ذخیره نشده باشد، می‌توانیم موبایل را از ورودی کاربر بگیریم)
            string phone = null;
            try
            {
                // تلاش برای خواندن از ProfileProvider اگر مقدار Phone موجود باشد
                object p = Context.Profile.GetPropertyValue("Phone");
                if (p != null) phone = Convert.ToString(p);
            }
            catch { }

            string sql = "SELECT TOP 50 r.Id, c.Title AS CompetitionTitle, r.Phone, r.Status, r.CreatedDate FROM CompetitionRegistrations r INNER JOIN Competitions c ON r.CompetitionId=c.Id" + (string.IsNullOrEmpty(phone) ? " ORDER BY r.Id DESC" : " WHERE r.Phone=@Phone ORDER BY r.Id DESC");
            DataTable dt = new DataTable();
            using (SqlConnection conn = new SqlConnection(ConnStr))
            using (SqlCommand cmd = new SqlCommand(sql, conn))
            using (SqlDataAdapter da = new SqlDataAdapter(cmd))
            {
                if (!string.IsNullOrEmpty(phone)) cmd.Parameters.AddWithValue("@Phone", phone);
                da.Fill(dt);
            }
            rptMyRegs.DataSource = dt;
            rptMyRegs.DataBind();
        }

        protected void btnSaveProfile_Click(object sender, EventArgs e)
        {
            try
            {
                Context.Profile.SetPropertyValue("FirstName", txtFirstName.Text.Trim());
                Context.Profile.SetPropertyValue("LastName", txtLastName.Text.Trim());
                Context.Profile.SetPropertyValue("Phone", txtPhone.Text.Trim());
                Context.Profile.Save();
                litProfileMsg.Text = "<span class='text-green-600'>پروفایل ذخیره شد.</span>";
                BindMyRegistrations();
            }
            catch (Exception ex)
            {
                litProfileMsg.Text = "<span class='text-red-600'>" + Server.HtmlEncode(ex.Message) + "</span>";
            }
        }

        private void BindAddresses()
        {
            var u = Membership.GetUser(); if (u == null) return;
            DataTable dt = new DataTable();
            using (SqlConnection conn = new SqlConnection(ConnStr))
            using (SqlDataAdapter da = new SqlDataAdapter("SELECT Id, Title, Receiver, Province, City, AddressLine, PostalCode, IsDefault FROM UserAddresses WHERE Username=@User ORDER BY IsDefault DESC, Id DESC", conn))
            {
                da.SelectCommand.Parameters.AddWithValue("@User", u.UserName);
                da.Fill(dt);
            }
            rptAddresses.DataSource = dt; rptAddresses.DataBind();
        }

        protected void btnSaveAddress_Click(object sender, EventArgs e)
        {
            var u = Membership.GetUser(); if (u == null) return;
            int id; int.TryParse(hdnAddrId.Value, out id);
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                conn.Open();
                if (chkAddrDefault.Checked)
                {
                    using (SqlCommand reset = new SqlCommand("UPDATE UserAddresses SET IsDefault=0 WHERE Username=@User", conn))
                    { reset.Parameters.AddWithValue("@User", u.UserName); reset.ExecuteNonQuery(); }
                }
                if (id == 0)
                {
                    using (SqlCommand cmd = new SqlCommand(@"INSERT INTO UserAddresses (Username, Title, Receiver, Province, City, AddressLine, PostalCode, IsDefault)
VALUES (@User, @Title, @Receiver, @Province, @City, @Addr, @Postal, @Def)", conn))
                    {
                        cmd.Parameters.AddWithValue("@User", u.UserName);
                        cmd.Parameters.AddWithValue("@Title", txtAddrTitle.Text.Trim());
                        cmd.Parameters.AddWithValue("@Receiver", txtAddrReceiver.Text.Trim());
                        cmd.Parameters.AddWithValue("@Province", txtAddrProvince.Text.Trim());
                        cmd.Parameters.AddWithValue("@City", txtAddrCity.Text.Trim());
                        cmd.Parameters.AddWithValue("@Addr", txtAddrAddress.Text.Trim());
                        cmd.Parameters.AddWithValue("@Postal", txtAddrPostal.Text.Trim());
                        cmd.Parameters.AddWithValue("@Def", chkAddrDefault.Checked);
                        cmd.ExecuteNonQuery();
                    }
                }
                else
                {
                    using (SqlCommand cmd = new SqlCommand(@"UPDATE UserAddresses SET Title=@Title, Receiver=@Receiver, Province=@Province, City=@City, AddressLine=@Addr, PostalCode=@Postal, IsDefault=@Def WHERE Id=@Id AND Username=@User", conn))
                    {
                        cmd.Parameters.AddWithValue("@Id", id);
                        cmd.Parameters.AddWithValue("@User", u.UserName);
                        cmd.Parameters.AddWithValue("@Title", txtAddrTitle.Text.Trim());
                        cmd.Parameters.AddWithValue("@Receiver", txtAddrReceiver.Text.Trim());
                        cmd.Parameters.AddWithValue("@Province", txtAddrProvince.Text.Trim());
                        cmd.Parameters.AddWithValue("@City", txtAddrCity.Text.Trim());
                        cmd.Parameters.AddWithValue("@Addr", txtAddrAddress.Text.Trim());
                        cmd.Parameters.AddWithValue("@Postal", txtAddrPostal.Text.Trim());
                        cmd.Parameters.AddWithValue("@Def", chkAddrDefault.Checked);
                        cmd.ExecuteNonQuery();
                    }
                }
            }
            ClearAddressForm();
            BindAddresses();
            litAddrMsg.Text = "<span class='text-green-600'>آدرس ذخیره شد.</span>";
        }

        protected void btnCancelAddress_Click(object sender, EventArgs e)
        {
            ClearAddressForm();
        }

        private void ClearAddressForm()
        {
            hdnAddrId.Value = string.Empty;
            txtAddrTitle.Text = txtAddrReceiver.Text = txtAddrProvince.Text = txtAddrCity.Text = txtAddrAddress.Text = txtAddrPostal.Text = string.Empty;
            chkAddrDefault.Checked = false;
            litAddrMsg.Text = string.Empty;
        }

        protected void rptAddresses_ItemCommand(object source, System.Web.UI.WebControls.RepeaterCommandEventArgs e)
        {
            var u = Membership.GetUser(); if (u == null) return;
            int id; if (!int.TryParse(Convert.ToString(e.CommandArgument), out id)) return;
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                conn.Open();
                if (e.CommandName == "setDefault")
                {
                    using (SqlCommand reset = new SqlCommand("UPDATE UserAddresses SET IsDefault=0 WHERE Username=@User", conn))
                    { reset.Parameters.AddWithValue("@User", u.UserName); reset.ExecuteNonQuery(); }
                    using (SqlCommand setd = new SqlCommand("UPDATE UserAddresses SET IsDefault=1 WHERE Id=@Id AND Username=@User", conn))
                    { setd.Parameters.AddWithValue("@Id", id); setd.Parameters.AddWithValue("@User", u.UserName); setd.ExecuteNonQuery(); }
                }
                else if (e.CommandName == "delete")
                {
                    using (SqlCommand del = new SqlCommand("DELETE FROM UserAddresses WHERE Id=@Id AND Username=@User", conn))
                    { del.Parameters.AddWithValue("@Id", id); del.Parameters.AddWithValue("@User", u.UserName); del.ExecuteNonQuery(); }
                }
                else if (e.CommandName == "edit")
                {
                    using (SqlCommand sel = new SqlCommand("SELECT Title, Receiver, Province, City, AddressLine, PostalCode, IsDefault FROM UserAddresses WHERE Id=@Id AND Username=@User", conn))
                    {
                        sel.Parameters.AddWithValue("@Id", id);
                        sel.Parameters.AddWithValue("@User", u.UserName);
                        using (SqlDataReader r = sel.ExecuteReader())
                        {
                            if (r.Read())
                            {
                                hdnAddrId.Value = id.ToString();
                                txtAddrTitle.Text = Convert.ToString(r["Title"]);
                                txtAddrReceiver.Text = Convert.ToString(r["Receiver"]);
                                txtAddrProvince.Text = Convert.ToString(r["Province"]);
                                txtAddrCity.Text = Convert.ToString(r["City"]);
                                txtAddrAddress.Text = Convert.ToString(r["AddressLine"]);
                                txtAddrPostal.Text = Convert.ToString(r["PostalCode"]);
                                chkAddrDefault.Checked = r["IsDefault"] != DBNull.Value && Convert.ToBoolean(r["IsDefault"]);
                            }
                        }
                    }
                }
            }
            BindAddresses();
        }
    }
}



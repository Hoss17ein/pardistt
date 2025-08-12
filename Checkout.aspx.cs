using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.Security;
using System.Linq;

namespace Pardis
{
    public partial class Checkout : System.Web.UI.Page
    {
        private string ConnStr { get { return ConfigurationManager.ConnectionStrings["my dataConnectionString"].ConnectionString; } }
        private static string GetStringSafe(SqlDataReader r, string col)
        {
            try { var v = r[col]; return (v == null || v == DBNull.Value) ? string.Empty : Convert.ToString(v); }
            catch { return string.Empty; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Prevent access when cart is empty
                if (CartHelper.GetCart().Count == 0)
                {
                    Response.Redirect("/Cart.aspx");
                    return;
                }
                // Require authentication
                if (Membership.GetUser() == null)
                {
                    phAuth.Controls.Add(new System.Web.UI.LiteralControl("<div class='bg-yellow-100 text-yellow-800 rounded p-3 mb-4'>برای ادامه باید <a class='text-blue-700' href='/Account/Login.aspx'>وارد</a> شوید.</div>"));
                    pnlCheckout.Visible = false;
                    return;
                }
                BindSummary();
                // Pre-fill default address if exists
                try
                {
                    using (SqlConnection conn = new SqlConnection(ConnStr))
                    using (SqlCommand cmd = new SqlCommand("SELECT TOP 1 * FROM UserAddresses WHERE Username=@u AND IsDefault = 1 ORDER BY Id DESC", conn))
                    {
                        cmd.Parameters.AddWithValue("@u", Membership.GetUser().UserName);
                        conn.Open();
                        using (SqlDataReader r = cmd.ExecuteReader())
                        {
                            if (r.Read())
                            {
                                string fullName = GetStringSafe(r, "FullName");
                                if (!string.IsNullOrEmpty(fullName))
                                {
                                    var parts = fullName.Trim().Split(' ');
                                    if (parts.Length > 0) txtFirstName.Text = parts[0];
                                    if (parts.Length > 1) txtLastName.Text = string.Join(" ", parts.Skip(1).ToArray());
                                }
                                string firstName = GetStringSafe(r, "FirstName");
                                string lastName = GetStringSafe(r, "LastName");
                                if (!string.IsNullOrEmpty(firstName)) txtFirstName.Text = firstName;
                                if (!string.IsNullOrEmpty(lastName)) txtLastName.Text = lastName;

                                string address = GetStringSafe(r, "AddressLine");
                                if (string.IsNullOrEmpty(address)) address = GetStringSafe(r, "Address");
                                if (!string.IsNullOrEmpty(address)) txtAddress.Text = address;

                                string city = GetStringSafe(r, "City");
                                if (!string.IsNullOrEmpty(city)) txtCity.Text = city;

                                string province = GetStringSafe(r, "Province");
                                if (!string.IsNullOrEmpty(province))
                                {
                                    var item = ddlProvince.Items.FindByValue(province);
                                    if (item != null) ddlProvince.SelectedValue = province;
                                }

                                string postal = GetStringSafe(r, "PostalCode");
                                if (!string.IsNullOrEmpty(postal)) txtPostal.Text = postal;

                                string phone = GetStringSafe(r, "Phone");
                                if (!string.IsNullOrEmpty(phone)) txtPhone.Text = phone;
                            }
                        }
                    }
                }
                catch { }
                // initialize steps
                pnlStep1.Visible = true; pnlStep2.Visible = false; pnlStep3.Visible = false;
                // provinces demo
                try
                {
                    ddlProvince.Items.Clear();
                    string[] provinces = new string[] {
                        "آذربایجان شرقی","آذربایجان غربی","اردبیل","اصفهان","البرز","ایلام","بوشهر","تهران",
                        "چهارمحال و بختیاری","خراسان جنوبی","خراسان رضوی","خراسان شمالی","خوزستان","زنجان","سمنان",
                        "سیستان و بلوچستان","فارس","قزوین","قم","کردستان","کرمان","کرمانشاه","کهگیلویه و بویراحمد",
                        "گلستان","گیلان","لرستان","مازندران","مرکزی","هرمزگان","همدان","یزد"
                    };
                    foreach (var p in provinces)
                    {
                        ddlProvince.Items.Add(new System.Web.UI.WebControls.ListItem(p, p));
                    }
                }
                catch { }
            }
        }

        private void BindSummary()
        {
            var items = CartHelper.GetCart();
            // Map for summary: add LineTotal for display
            var sumItems = items.Select(i => new { i.Name, i.Quantity, LineTotal = (decimal)i.Quantity * i.Price }).ToList();
            rptSummary.DataSource = sumItems; rptSummary.DataBind();
            decimal sub = CartHelper.GetTotal();
            int ship = 0; int.TryParse(ddlShipping.SelectedValue, out ship);
            litSubTotal.Text = string.Format("{0:N0}", sub);
            litShipping.Text = string.Format("{0:N0}", ship);
            litGrand.Text = string.Format("{0:N0}", sub + ship);
        }

        protected void ddlShipping_SelectedIndexChanged(object sender, EventArgs e)
        {
            BindSummary();
        }

        protected void rblPayment_SelectedIndexChanged(object sender, EventArgs e)
        {
            // reserved for future payment gateway toggle
        }

        protected void btnNext1_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                pnlStep1.Visible = false; pnlStep2.Visible = true; pnlStep3.Visible = false;
            }
        }

        protected void btnNext2_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                pnlStep1.Visible = false; pnlStep2.Visible = false; pnlStep3.Visible = true;
            }
        }

        protected void btnPlaceOrder_Click(object sender, EventArgs e)
        {
            var items = CartHelper.GetCart();
            if (items.Count == 0)
            {
                litMsg.Text = "<span class='text-red-600'>سبد خرید خالی است.</span>";
                return;
            }

            int orderId;
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand("INSERT INTO Orders (Username, TotalAmount, CreatedDate, Status) OUTPUT INSERTED.Id VALUES (@User, @Total, GETDATE(), 'Pending')", conn))
                {
                    cmd.Parameters.AddWithValue("@User", Membership.GetUser().UserName);
                    int ship = 0; int.TryParse(ddlShipping.SelectedValue, out ship);
                    cmd.Parameters.AddWithValue("@Total", CartHelper.GetTotal() + ship);
                    orderId = Convert.ToInt32(cmd.ExecuteScalar());
                }
                foreach (var it in items)
                {
                    using (SqlCommand cmd2 = new SqlCommand("INSERT INTO OrderItems (OrderId, ProductId, Name, Price, Quantity) VALUES (@OrderId, @Pid, @Name, @Price, @Qty)", conn))
                    {
                        cmd2.Parameters.AddWithValue("@OrderId", orderId);
                        cmd2.Parameters.AddWithValue("@Pid", it.ProductId);
                        cmd2.Parameters.AddWithValue("@Name", it.Name);
                        cmd2.Parameters.AddWithValue("@Price", it.Price);
                        cmd2.Parameters.AddWithValue("@Qty", it.Quantity);
                        cmd2.ExecuteNonQuery();
                    }
                }
            }

            CartHelper.Clear();
            litMsg.Text = "<span class='text-green-600'>سفارش با موفقیت ثبت شد.</span>";
        }
    }
}



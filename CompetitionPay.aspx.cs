using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Globalization;
using System.Collections.Generic;

namespace Pardis
{
    public partial class CompetitionPay : System.Web.UI.Page
    {
        private string ConnStr { get { return ConfigurationManager.ConnectionStrings["my dataConnectionString"].ConnectionString; } }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                var pending = Session["PendingCompReg"] as Dictionary<string, string>;
                int cid;
                if (pending == null || !int.TryParse(Request.QueryString["cid"], out cid))
                {
                    pnlInvalid.Visible = true; pnlPay.Visible = false; return;
                }

                // مبلغ پیش فرض از appSettings
                int defaultSingle = 0, defaultDouble = 0;
                int.TryParse(ConfigurationManager.AppSettings["CompetitionSingleFee"], out defaultSingle);
                int.TryParse(ConfigurationManager.AppSettings["CompetitionDoubleFee"], out defaultDouble);
                if (defaultSingle <= 0) int.TryParse(ConfigurationManager.AppSettings["CompetitionDefaultFee"], out defaultSingle);
                if (defaultDouble <= 0) defaultDouble = defaultSingle * 2;

                // عنوان مسابقه و شاید مبلغ اختصاصی از جدول مسابقات اگر ستون Fee وجود داشته باشد
                string title = null; int singleFee = defaultSingle; int doubleFee = defaultDouble;
                try
                {
                    using (SqlConnection conn = new SqlConnection(ConnStr))
                    using (SqlCommand cmd = new SqlCommand("SELECT Title, SingleFee, DoubleFee FROM Competitions WHERE Id=@Id", conn))
                    {
                        cmd.Parameters.AddWithValue("@Id", cid);
                        conn.Open();
                        using (SqlDataReader r = cmd.ExecuteReader())
                        {
                            if (r.Read())
                            {
                                if (r["Title"] != DBNull.Value) title = Convert.ToString(r["Title"]);
                                if (r["SingleFee"] != DBNull.Value) singleFee = Convert.ToInt32(r["SingleFee"]);
                                if (r["DoubleFee"] != DBNull.Value) doubleFee = Convert.ToInt32(r["DoubleFee"]);
                            }
                        }
                    }
                }
                catch { }

                litCompTitle.Text = title ?? ("شماره مسابقه " + cid);
                litSingle.Text = singleFee.ToString("N0", CultureInfo.GetCultureInfo("fa-IR"));
                litDouble.Text = doubleFee.ToString("N0", CultureInfo.GetCultureInfo("fa-IR"));
                // انتخاب نوع ثبت‌نام از سشن در صورت وجود
                var pendingType = (pending != null && pending.ContainsKey("RegistrationType")) ? pending["RegistrationType"] : "Single";
                string preselect = (pendingType ?? "Single").Equals("Double", StringComparison.OrdinalIgnoreCase) ? "double" : "single";
                rblGroupType.SelectedValue = preselect;
                int initialAmount = preselect == "double" ? doubleFee : singleFee;
                litAmount.Text = initialAmount.ToString("N0", CultureInfo.GetCultureInfo("fa-IR"));
                ViewState["SingleFee"] = singleFee; ViewState["DoubleFee"] = doubleFee;
                pnlPay.Visible = true; pnlInvalid.Visible = false;
            }
        }

        protected void rblGroupType_SelectedIndexChanged(object sender, EventArgs e)
        {
            int singleFee = Convert.ToInt32(ViewState["SingleFee"] ?? 0);
            int doubleFee = Convert.ToInt32(ViewState["DoubleFee"] ?? 0);
            int amount = (rblGroupType.SelectedValue == "double") ? doubleFee : singleFee;
            litAmount.Text = amount.ToString("N0", CultureInfo.GetCultureInfo("fa-IR"));
        }

        protected void btnPay_Click(object sender, EventArgs e)
        {
            var pending = Session["PendingCompReg"] as Dictionary<string, string>;
            int cid;
            if (pending == null || !pending.ContainsKey("CompetitionId") || !int.TryParse(pending["CompetitionId"], out cid))
            {
                pnlInvalid.Visible = true; pnlPay.Visible = false; return;
            }

            string groupType = rblGroupType.SelectedValue == "double" ? "double" : "single";
            int amount = groupType == "double" ? Convert.ToInt32(ViewState["DoubleFee"]) : Convert.ToInt32(ViewState["SingleFee"]);

            // TODO: ادغام درگاه واقعی — فعلاً پرداخت را شبیه سازی می‌کنیم و ثبت‌نام را درج می‌کنیم
            try
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                using (SqlCommand cmd = new SqlCommand(@"INSERT INTO CompetitionRegistrations (CompetitionId, FullName, FirstName, LastName, Phone, Age, Gender, Notes, InsuranceImageUrl, Status)
VALUES (@CompetitionId, @FullName, @FirstName, @LastName, @Phone, @Age, @Gender, @Notes, @Insurance, @Status)", conn))
                {
                    cmd.Parameters.AddWithValue("@CompetitionId", cid);
                    cmd.Parameters.AddWithValue("@FullName", pending.ContainsKey("FullName") ? pending["FullName"] : null);
                    cmd.Parameters.AddWithValue("@FirstName", pending.ContainsKey("FirstName") ? pending["FirstName"] : null);
                    cmd.Parameters.AddWithValue("@LastName", pending.ContainsKey("LastName") ? pending["LastName"] : null);
                    cmd.Parameters.AddWithValue("@Phone", pending.ContainsKey("Phone") ? pending["Phone"] : null);
                    // محاسبه سن بر اساس تاریخ تولد (در صورت ارسال)
                    DateTime birth;
                    int ageVal = 0;
                    if (pending.ContainsKey("BirthDate") && DateTime.TryParse(pending["BirthDate"], out birth))
                    {
                        var today = DateTime.Today;
                        ageVal = today.Year - birth.Year;
                        if (birth > today.AddYears(-ageVal)) ageVal--;
                    }
                    if (ageVal <= 0) cmd.Parameters.AddWithValue("@Age", DBNull.Value); else cmd.Parameters.AddWithValue("@Age", ageVal);
                    cmd.Parameters.AddWithValue("@Gender", pending.ContainsKey("Gender") ? pending["Gender"] : null);
                    cmd.Parameters.AddWithValue("@Notes", pending.ContainsKey("Notes") ? pending["Notes"] : null);
                    string ins = pending.ContainsKey("InsuranceImageUrl") ? pending["InsuranceImageUrl"] : null;
                    if (string.IsNullOrEmpty(ins)) cmd.Parameters.AddWithValue("@Insurance", DBNull.Value); else cmd.Parameters.AddWithValue("@Insurance", ins);
                    cmd.Parameters.AddWithValue("@Status", "Paid");
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
                Session.Remove("PendingCompReg");
                Response.Redirect("/Competition.aspx?id=" + cid);
            }
            catch (Exception ex)
            {
                litMsg.Text = "<div class='text-red-700 bg-red-100 rounded p-3 mt-3'>خطا در نهایی‌سازی ثبت‌نام: " + Server.HtmlEncode(ex.Message) + "</div>";
            }
        }
    }
}



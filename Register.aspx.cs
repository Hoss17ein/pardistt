using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

namespace Pardis
{
    public partial class Register : System.Web.UI.Page
    {
        private string ConnStr { get { return ConfigurationManager.ConnectionStrings["my dataConnectionString"].ConnectionString; } }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                int id;
                if (int.TryParse(Request.QueryString["id"], out id))
                {
                    hdnCompetitionId.Value = id.ToString();
                    LoadCompetition(id);
                }
                else
                {
                                            litMsg.Text = "<div class='error-message'>Invalid competition.</div>";
                    btnSubmit.Enabled = false;
                }
            }
        }

        private void LoadCompetition(int id)
        {
            using (SqlConnection conn = new SqlConnection(ConnStr))
            using (SqlCommand cmd = new SqlCommand("SELECT Title, Location, StartDate, RegistrationDeadline, Description, SingleFee, DoubleFee FROM Competitions WHERE Id=@Id AND IsActive=1", conn))
            {
                cmd.Parameters.AddWithValue("@Id", id);
                conn.Open();
                using (SqlDataReader r = cmd.ExecuteReader())
                {
                    if (r.Read())
                    {
                        string title = r["Title"].ToString();
                        string location = r["Location"]?.ToString() ?? "";
                        string description = r["Description"]?.ToString() ?? "";
                        int singleFee = r["SingleFee"] != DBNull.Value ? Convert.ToInt32(r["SingleFee"]) : 0;
                        int doubleFee = r["DoubleFee"] != DBNull.Value ? Convert.ToInt32(r["DoubleFee"]) : (singleFee > 0 ? singleFee * 2 : 0);
                        
                        // Display competition title
                        litCompTitle.Text = title;
                        // show fees on options
                        try
                        {
                            var culture = new System.Globalization.CultureInfo("fa-IR");
                            litSingleFee.Text = singleFee > 0 ? singleFee.ToString("N0", culture) : "-";
                            litDoubleFee.Text = doubleFee > 0 ? doubleFee.ToString("N0", culture) : "-";
                        }
                        catch { }
                        
                        // Display competition details
                        string details = "";
                        if (!string.IsNullOrEmpty(location))
                            details += $"<div class='mb-1'><strong>Location:</strong> {location}</div>";
                        
                        if (r["StartDate"] != null && r["StartDate"] != DBNull.Value)
                        {
                            DateTime startDate = Convert.ToDateTime(r["StartDate"]);
                            details += $"<div class='mb-1'><strong>Start Date:</strong> {startDate.ToString("yyyy/MM/dd HH:mm")}</div>";
                        }
                        
                        if (r["RegistrationDeadline"] != null && r["RegistrationDeadline"] != DBNull.Value)
                        {
                            DateTime deadline = Convert.ToDateTime(r["RegistrationDeadline"]);
                            details += $"<div class='mb-1'><strong>Registration Deadline:</strong> {deadline.ToString("yyyy/MM/dd HH:mm")}</div>";
                            
                            // Check registration deadline
                            if (DateTime.Now > deadline)
                            {
                                litMsg.Text = "<div class='error-message'>Registration deadline has passed.</div>";
                                btnSubmit.Enabled = false;
                                return;
                            }
                        }
                        
                        if (!string.IsNullOrEmpty(description))
                            details += $"<div class='mt-2 text-sm'>{description}</div>";
                        
                        litCompDetails.Text = details;
                    }
                    else
                    {
                        litMsg.Text = "<div class='error-message'>Competition not found.</div>";
                        btnSubmit.Enabled = false;
                    }
                }
            }
        }

        protected void btnSubmit_OnClick(object sender, EventArgs e)
        {
            try
            {
                int cid;
                if (!int.TryParse(hdnCompetitionId.Value, out cid))
                {
                    litMsg.Text = "<div class='error-message'>Error in competition ID.</div>";
                    return;
                }

                // Validate required fields
                if (string.IsNullOrEmpty(txtFirstName.Text.Trim()))
                {
                    litMsg.Text = "<div class='error-message'>First name is required.</div>";
                    return;
                }

                if (string.IsNullOrEmpty(txtLastName.Text.Trim()))
                {
                    litMsg.Text = "<div class='error-message'>Last name is required.</div>";
                    return;
                }

                if (string.IsNullOrEmpty(txtPhone.Text.Trim()))
                {
                    litMsg.Text = "<div class='error-message'>Phone number is required.</div>";
                    return;
                }

                // Check selected registration type
                string registrationType = "";
                if (rbSingleGroup.Checked)
                    registrationType = "Single";
                else if (rbDoubleGroup.Checked)
                    registrationType = "Double";
                else
                {
                    litMsg.Text = "<div class='error-message'>Please select registration type.</div>";
                    return;
                }

                // جلوگیری از ثبت نام تکراری: بر اساس شماره موبایل + شناسه مسابقه
                using (SqlConnection chkConn = new SqlConnection(ConnStr))
                using (SqlCommand chkCmd = new SqlCommand("SELECT COUNT(1) FROM CompetitionRegistrations WHERE CompetitionId=@Cid AND Phone=@Phone", chkConn))
                {
                    chkCmd.Parameters.AddWithValue("@Cid", cid);
                    chkCmd.Parameters.AddWithValue("@Phone", txtPhone.Text.Trim());
                    chkConn.Open();
                    int exists = Convert.ToInt32(chkCmd.ExecuteScalar());
                    if (exists > 0)
                    {
                        litMsg.Text = "<div class='error-message'>Already registered with this phone number for this competition.</div>";
                        return;
                    }
                }

                // ذخیره تصویر بیمه ورزشی
                string insurancePath = null;
                if (fuInsurance != null && fuInsurance.HasFile)
                {
                    string ext = System.IO.Path.GetExtension(fuInsurance.FileName).ToLower();
                    if (ext == ".jpg" || ext == ".jpeg" || ext == ".png")
                    {
                        string fileName = "images/uploads/insurance_" + DateTime.Now.Ticks + ext;
                        string physical = Server.MapPath("~/" + fileName);
                        System.IO.Directory.CreateDirectory(System.IO.Path.GetDirectoryName(physical));
                        fuInsurance.SaveAs(physical);
                        insurancePath = "/" + fileName.Replace("\\", "/");
                    }
                    else
                    {
                        litMsg.Text = "<div class='error-message'>Insurance file format must be JPG or PNG.</div>";
                        return;
                    }
                }
                else
                {
                    litMsg.Text = "<div class='error-message'>Insurance image is required.</div>";
                    return;
                }

                // ذخیره موقت اطلاعات در سشن و هدایت به صفحه پرداخت
                var pending = new System.Collections.Generic.Dictionary<string, string>();
                pending["CompetitionId"] = cid.ToString();
                pending["RegistrationType"] = registrationType;
                pending["FullName"] = (txtFirstName.Text.Trim() + " " + txtLastName.Text.Trim()).Trim();
                pending["FirstName"] = txtFirstName.Text.Trim();
                pending["LastName"] = txtLastName.Text.Trim();
                pending["Phone"] = txtPhone.Text.Trim();
                pending["BirthDate"] = txtBirthDate.Text.Trim();
                pending["Gender"] = ddlGender.SelectedValue;
                pending["Notes"] = txtNotes.Text.Trim();
                pending["InsuranceImageUrl"] = insurancePath ?? string.Empty;
                Session["PendingCompReg"] = pending;

                // نمایش پیام موفقیت
                litMsg.Text = "<div class='success-message'>Information saved successfully. Redirecting to payment page...</div>";
                
                // هدایت به صفحه پرداخت بعد از 2 ثانیه
                string script = @"
                    setTimeout(function() {
                        window.location.href = '/CompetitionPay.aspx?cid=" + cid + @"';
                    }, 2000);
                ";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "redirect", script, true);
            }
            catch (Exception ex)
            {
                litMsg.Text = "<div class='error-message'>Error saving information: " + ex.Message + "</div>";
            }
        }
    }
}



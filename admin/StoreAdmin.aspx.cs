using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;

namespace shop1.Admin
{
    public partial class StoreAdmin : System.Web.UI.Page
    {
        private string ConnStr { get { return ConfigurationManager.ConnectionStrings["my dataConnectionString"].ConnectionString; } }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!AdminAuth.IsAdminAuthenticated()) { Response.Redirect("Login.aspx"); return; }
            if (!IsPostBack)
            {
                BindGrid();
            }
        }

        private void BindGrid()
        {
            DataTable dt = new DataTable();
            using (SqlConnection conn = new SqlConnection(ConnStr))
            using (SqlDataAdapter da = new SqlDataAdapter("SELECT Id, Name, Category, Price, Stock, IsActive FROM Products ORDER BY Id DESC", conn))
            { da.Fill(dt); }
            gvProducts.DataSource = dt; gvProducts.DataBind();
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            // ذخیره محصول و تصاویر (۱ تا ۵ عکس)
            var uploadedImages = new System.Collections.Generic.List<string>();
            var imageCaptions = new System.Collections.Generic.List<string>();
            // جمع‌آوری ۵ ورودی تکی به‌همراه کپشن‌ها
            var inputs = new System.Web.UI.WebControls.FileUpload[] { fuImg1, fuImg2, fuImg3, fuImg4, fuImg5 };
            var captions = new System.Web.UI.WebControls.TextBox[] { txtCap1, txtCap2, txtCap3, txtCap4, txtCap5 };
            for (int i = 0; i < inputs.Length; i++)
            {
                var fu = inputs[i];
                if (fu != null && fu.HasFile)
                {
                    string ext = Path.GetExtension(fu.FileName).ToLower();
                    if (ext != ".jpg" && ext != ".jpeg" && ext != ".png") continue;
                    string fileName = "images/uploads/product_" + DateTime.Now.Ticks + "_" + uploadedImages.Count + ext;
                    string physical = Server.MapPath("~/" + fileName);
                    Directory.CreateDirectory(Path.GetDirectoryName(physical));
                    fu.SaveAs(physical);
                    uploadedImages.Add(fileName.Replace("\\", "/"));
                    string cap = captions[i] != null ? (captions[i].Text ?? string.Empty).Trim() : string.Empty;
                    imageCaptions.Add(cap);
                }
            }
            if (uploadedImages.Count == 0)
            {
                litImgMsg.Text = "<span class='text-danger small'>حداقل 1 تصویر انتخاب کنید.</span>";
                return;
            }

            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                conn.Open();
                if (string.IsNullOrEmpty(hdnId.Value))
                {
                    using (SqlCommand cmd = new SqlCommand(@"INSERT INTO Products (Name, Description, Category, Price, Stock, ImageUrl, IsActive, CreatedDate)
VALUES (@Name, @Description, @Category, @Price, @Stock, @ImageUrl, @IsActive, GETDATE()); SELECT SCOPE_IDENTITY();", conn))
                    {
                        cmd.Parameters.AddWithValue("@Name", txtName.Text.Trim());
                        cmd.Parameters.AddWithValue("@Description", txtDescription.Text.Trim());
                        cmd.Parameters.AddWithValue("@Category", (object)(ddlCategory.SelectedValue ?? string.Empty));
                        decimal price; decimal.TryParse(txtPrice.Text, out price); cmd.Parameters.AddWithValue("@Price", price);
                        int stock; int.TryParse(txtStock.Text, out stock); cmd.Parameters.AddWithValue("@Stock", stock);
                        string cover = uploadedImages.Count > 0 ? uploadedImages[0] : null;
                        cmd.Parameters.AddWithValue("@ImageUrl", (object)cover ?? DBNull.Value);
                        cmd.Parameters.AddWithValue("@IsActive", chkActive.Checked);
                        var newIdObj = cmd.ExecuteScalar();
                        int newId = 0; try { newId = Convert.ToInt32(newIdObj); } catch { }
                        // ذخیره سایر تصاویر در ProductImages
                        if (newId > 0 && uploadedImages.Count > 0)
                        {
                            for (int i = 0; i < uploadedImages.Count; i++)
                            {
                                using (SqlCommand ci = new SqlCommand("INSERT INTO ProductImages (ProductId, ImageUrl, Caption) VALUES (@Pid, @Img, @Cap)", conn))
                                {
                                    ci.Parameters.AddWithValue("@Pid", newId);
                                    ci.Parameters.AddWithValue("@Img", uploadedImages[i]);
                                    ci.Parameters.AddWithValue("@Cap", (object)(imageCaptions.Count > i ? imageCaptions[i] : string.Empty) ?? DBNull.Value);
                                    try { ci.ExecuteNonQuery(); } catch { }
                                }
                            }
                        }
                    }
                }
                else
                {
                    using (SqlCommand cmd = new SqlCommand(@"UPDATE Products SET Name=@Name, Description=@Description, Category=@Category, Price=@Price, Stock=@Stock, IsActive=@IsActive" + (uploadedImages.Count > 0 ? ", ImageUrl=@ImageUrl" : "") + " WHERE Id=@Id", conn))
                    {
                        cmd.Parameters.AddWithValue("@Id", Convert.ToInt32(hdnId.Value));
                        cmd.Parameters.AddWithValue("@Name", txtName.Text.Trim());
                        cmd.Parameters.AddWithValue("@Description", txtDescription.Text.Trim());
                        cmd.Parameters.AddWithValue("@Category", (object)(ddlCategory.SelectedValue ?? string.Empty));
                        decimal price; decimal.TryParse(txtPrice.Text, out price); cmd.Parameters.AddWithValue("@Price", price);
                        int stock; int.TryParse(txtStock.Text, out stock); cmd.Parameters.AddWithValue("@Stock", stock);
                        if (uploadedImages.Count > 0) cmd.Parameters.AddWithValue("@ImageUrl", uploadedImages[0]);
                        cmd.Parameters.AddWithValue("@IsActive", chkActive.Checked);
                        cmd.ExecuteNonQuery();
                    }
                    // اگر تصاویر جدیدی آپلود شد، آن‌ها را به جدول ProductImages اضافه کنیم
                    if (uploadedImages.Count > 0)
                    {
                        int pid = Convert.ToInt32(hdnId.Value);
                        for (int i = 0; i < uploadedImages.Count; i++)
                        {
                            using (SqlCommand ci = new SqlCommand("INSERT INTO ProductImages (ProductId, ImageUrl, Caption) VALUES (@Pid, @Img, @Cap)", conn))
                            {
                                ci.Parameters.AddWithValue("@Pid", pid);
                                ci.Parameters.AddWithValue("@Img", uploadedImages[i]);
                                ci.Parameters.AddWithValue("@Cap", (object)(imageCaptions.Count > i ? imageCaptions[i] : string.Empty) ?? DBNull.Value);
                                try { ci.ExecuteNonQuery(); } catch { }
                            }
                        }
                    }
                }
            }
            ClearForm(); BindGrid();
        }

        protected void btnCancel_Click(object sender, EventArgs e) { ClearForm(); }

        private void ClearForm()
        {
            hdnId.Value = string.Empty; txtName.Text = txtDescription.Text = txtPrice.Text = txtStock.Text = string.Empty; chkActive.Checked = true; litImgMsg.Text = string.Empty;
        }

        protected void gvProducts_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            if (e.CommandName == "editItem")
            {
                int id = Convert.ToInt32(e.CommandArgument);
                string cat = string.Empty;
                using (SqlConnection conn = new SqlConnection(ConnStr))
                using (SqlCommand cmd = new SqlCommand("SELECT Id, Name, Description, Category, Price, Stock, IsActive FROM Products WHERE Id=@Id", conn))
                {
                    cmd.Parameters.AddWithValue("@Id", id);
                    conn.Open();
                    using (SqlDataReader r = cmd.ExecuteReader())
                    {
                        if (r.Read())
                        {
                            hdnId.Value = r["Id"].ToString();
                            txtName.Text = r["Name"].ToString();
                            txtDescription.Text = r["Description"].ToString();
                            txtPrice.Text = Convert.ToDecimal(r["Price"]).ToString();
                            txtStock.Text = Convert.ToInt32(r["Stock"]).ToString();
                            chkActive.Checked = Convert.ToBoolean(r["IsActive"]);
                            if (r["Category"] != DBNull.Value) cat = r["Category"].ToString();
                        }
                    }
                }
                if (!string.IsNullOrEmpty(cat)) ddlCategory.SelectedValue = cat; else ddlCategory.SelectedIndex = 0;
            }
            else if (e.CommandName == "deleteItem")
            {
                int id = Convert.ToInt32(e.CommandArgument);
                using (SqlConnection conn = new SqlConnection(ConnStr))
                using (SqlCommand cmd = new SqlCommand("DELETE FROM Products WHERE Id=@Id", conn))
                { cmd.Parameters.AddWithValue("@Id", id); conn.Open(); cmd.ExecuteNonQuery(); }
                BindGrid();
            }
        }
    }
}



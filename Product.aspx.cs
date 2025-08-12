using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace Pardis
{
    public partial class ProductPage : System.Web.UI.Page
    {
        private string ConnStr { get { return ConfigurationManager.ConnectionStrings["my dataConnectionString"].ConnectionString; } }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                int id;
                if (int.TryParse(Request.QueryString["id"], out id))
                {
                    hfProductId.Value = id.ToString();
                    LoadProduct(id);
                    LoadImages(id);
                }
                else
                {
                    pnlNotFound.Visible = true;
                }
            }
        }

        private void LoadProduct(int id)
        {
            using (SqlConnection conn = new SqlConnection(ConnStr))
            using (SqlCommand cmd = new SqlCommand("SELECT Name, Description, Price, ISNULL(ImageUrl,'') AS ImageUrl FROM Products WHERE Id=@Id AND IsActive=1", conn))
            {
                cmd.Parameters.AddWithValue("@Id", id);
                conn.Open();
                using (SqlDataReader r = cmd.ExecuteReader())
                {
                    if (r.Read())
                    {
                        pnlProduct.Visible = true; pnlNotFound.Visible = false;
                        litName.Text = Convert.ToString(r["Name"]);
                        litDescription.Text = Convert.ToString(r["Description"]).Replace("\n", "<br/>");
                        decimal price = 0; if (r["Price"] != DBNull.Value) price = Convert.ToDecimal(r["Price"]);
                        litPrice.Text = string.Format("{0:N0} تومان", price);
                        string img = Convert.ToString(r["ImageUrl"]);
                        if (!string.IsNullOrEmpty(img)) imgMain.ImageUrl = img;
                    }
                    else
                    {
                        pnlNotFound.Visible = true; pnlProduct.Visible = false;
                    }
                }
            }
        }

        private void LoadImages(int productId)
        {
            DataTable dt = new DataTable();
            using (SqlConnection conn = new SqlConnection(ConnStr))
            using (SqlDataAdapter da = new SqlDataAdapter("SELECT ImageUrl FROM ProductImages WHERE ProductId=@Id ORDER BY Id", conn))
            {
                da.SelectCommand.Parameters.AddWithValue("@Id", productId);
                try { da.Fill(dt); } catch { }
            }
            // اگر جدول وجود نداشت یا عکسی نبود، از تصویر اصلی محصول استفاده می‌کنیم
            if (dt.Rows.Count == 0 && !string.IsNullOrEmpty(imgMain.ImageUrl))
            {
                if (!dt.Columns.Contains("ImageUrl"))
                {
                    dt.Columns.Add("ImageUrl", typeof(string));
                }
                var row = dt.NewRow();
                row["ImageUrl"] = imgMain.ImageUrl;
                dt.Rows.Add(row);
            }
            rptThumbs.DataSource = dt; rptThumbs.DataBind();
        }

        protected void btnAdd_Click(object sender, EventArgs e)
        {
            int id; if (!int.TryParse(hfProductId.Value, out id)) return;
            // دریافت نام، قیمت و تصویر برای افزودن به سبد
            string name = litName.Text;
            decimal price = 0;
            if (!string.IsNullOrEmpty(litPrice.Text))
            {
                decimal.TryParse(litPrice.Text.Replace(" تومان", string.Empty).Replace(",", string.Empty), out price);
            }
            string img = imgMain.ImageUrl;
            CartHelper.AddItem(new SimpleCartItem { ProductId = id, Name = name, Price = price, ImageUrl = img, Quantity = 1 });
            Response.Redirect("/Cart.aspx");
        }
    }
}



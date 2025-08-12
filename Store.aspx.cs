using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace Pardis
{
    public partial class Store : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadStoreBanners();
                // Show categories landing when no filter
                string qcat = Request.QueryString["cat"];
                if (string.IsNullOrEmpty(qcat))
                {
                    pnlCategories.Visible = true; pnlProducts.Visible = false;
                }
                else
                {
                    pnlCategories.Visible = false; pnlProducts.Visible = true;
                    // اگر "all" انتخاب شود یعنی بدون فیلتر
                    if (string.Equals(qcat, "all", StringComparison.OrdinalIgnoreCase) || qcat == "*")
                    {
                        _queryCategory = null;
                    }
                    else
                    {
                        // apply filter via query only
                        _queryCategory = qcat;
                    }
                    BindProducts();
                }
            }
            rptProducts.ItemCommand += rptProducts_ItemCommand;
        }

        private string _queryCategory;

        private void LoadStoreBanners()
        {
            string connStr = ConfigurationManager.ConnectionStrings["my dataConnectionString"].ConnectionString;
            DataTable dt = new DataTable();
            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlDataAdapter da = new SqlDataAdapter("IF OBJECT_ID('dbo.StoreBanners','U') IS NULL SELECT 0 AS Id, '' AS ImageUrl, '' AS LinkUrl, '' AS Title WHERE 1=0 ELSE SELECT Id, ImageUrl, LinkUrl, Title FROM StoreBanners WHERE ISNULL(IsActive,1)=1 ORDER BY ISNULL(SortOrder,Id)", conn))
            {
                da.Fill(dt);
            }
            rptStoreBanners.DataSource = dt;
            rptStoreBanners.DataBind();
        }

        private void BindProducts()
        {
            string connStr = ConfigurationManager.ConnectionStrings["my dataConnectionString"].ConnectionString;
            DataTable dt = new DataTable();
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT Id, Name, Description, Price, ImageUrl, Category FROM Products WHERE IsActive=1";
                string cat = _queryCategory;
                if (!string.IsNullOrEmpty(cat) && !string.Equals(cat, "all", StringComparison.OrdinalIgnoreCase) && cat != "*")
                {
                    sql += " AND (Category=@Cat OR Category LIKE @CatLike)";
                }
                sql += " ORDER BY Id DESC";
                using (SqlDataAdapter da = new SqlDataAdapter(sql, conn))
                {
                    if (!string.IsNullOrEmpty(cat) && !string.Equals(cat, "all", StringComparison.OrdinalIgnoreCase) && cat != "*")
                    {
                        da.SelectCommand.Parameters.AddWithValue("@Cat", cat);
                        da.SelectCommand.Parameters.AddWithValue("@CatLike", cat + ".%" );
                    }
                    da.Fill(dt);
                }
            }
            rptProducts.DataSource = dt;
            rptProducts.DataBind();
        }

        void rptProducts_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "add")
            {
                int id; int.TryParse(Convert.ToString(e.CommandArgument), out id);
                string name = ((HiddenField)e.Item.FindControl("hfName")).Value;
                decimal price = 0; decimal.TryParse(((HiddenField)e.Item.FindControl("hfPrice")).Value, out price);
                string img = ((HiddenField)e.Item.FindControl("hfImg")).Value;
                CartHelper.AddItem(new SimpleCartItem { ProductId = id, Name = name, Price = price, ImageUrl = img, Quantity = 1 });
                // show SweetAlert and redirect via JS
                ClientScript.RegisterStartupScript(this.GetType(), "added", "Swal.fire({title:'افزوده شد',text:'محصول به سبد خرید اضافه شد',icon:'success',confirmButtonText:'مشاهده سبد'}).then(()=>{window.location='/Cart.aspx';});", true);
            }
        }
    }
}



using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace shop1.Admin
{
    public partial class OrdersAdmin : System.Web.UI.Page
    {
        private string ConnStr { get { return ConfigurationManager.ConnectionStrings["my dataConnectionString"].ConnectionString; } }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!AdminAuth.IsAdminAuthenticated()) { Response.Redirect("Login.aspx"); return; }
            if (!IsPostBack)
            {
                BindOrders();
            }
        }

        private void BindOrders()
        {
            DataTable dt = new DataTable();
            using (SqlConnection conn = new SqlConnection(ConnStr))
            using (SqlDataAdapter da = new SqlDataAdapter("SELECT Id, Username, TotalAmount, Status, CreatedDate FROM [Order] ORDER BY Id DESC", conn))
            { da.Fill(dt); }
            gvOrders.DataSource = dt; gvOrders.DataBind();
        }

        protected void gvOrders_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            int id = Convert.ToInt32(e.CommandArgument);
            if (e.CommandName == "details")
            {
                DataTable dt = new DataTable();
                using (SqlConnection conn = new SqlConnection(ConnStr))
                using (SqlDataAdapter da = new SqlDataAdapter("SELECT ProductId, Name, Price, Quantity FROM [OrderItems] WHERE OrderId=@Id", conn))
                { da.SelectCommand.Parameters.AddWithValue("@Id", id); da.Fill(dt); }
                gvItems.DataSource = dt; gvItems.DataBind();
            }
            else if (e.CommandName == "complete")
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                using (SqlCommand cmd = new SqlCommand("UPDATE [Order] SET Status='Completed' WHERE Id=@Id", conn))
                { cmd.Parameters.AddWithValue("@Id", id); conn.Open(); cmd.ExecuteNonQuery(); }
                BindOrders();
            }
        }
    }
}



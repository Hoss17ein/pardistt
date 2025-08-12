using System;
using System.Linq;
using System.Web.UI.WebControls;

namespace Pardis
{
    public partial class CartPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindCart();
            }
            rptCart.ItemCommand += rptCart_ItemCommand;
        }

        private void BindCart()
        {
            var items = CartHelper.GetCart();
            rptCart.DataSource = items;
            rptCart.DataBind();
            litTotal.Text = string.Format("{0:N0} تومان", CartHelper.GetTotal());
        }

        void rptCart_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int pid = Convert.ToInt32(e.CommandArgument);
            if (e.CommandName == "inc")
            {
                var item = CartHelper.GetCart().FirstOrDefault(x => x.ProductId == pid);
                if (item != null) CartHelper.UpdateQuantity(pid, item.Quantity + 1);
            }
            else if (e.CommandName == "dec")
            {
                var item = CartHelper.GetCart().FirstOrDefault(x => x.ProductId == pid);
                if (item != null) CartHelper.UpdateQuantity(pid, item.Quantity - 1);
            }
            else if (e.CommandName == "rem")
            {
                CartHelper.RemoveItem(pid);
            }
            BindCart();
        }
    }
}



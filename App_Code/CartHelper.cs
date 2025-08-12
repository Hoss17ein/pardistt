using System;
using System.Collections.Generic;
using System.Linq;

public class SimpleCartItem
{
    public int ProductId { get; set; }
    public string Name { get; set; }
    public decimal Price { get; set; }
    public string ImageUrl { get; set; }
    public int Quantity { get; set; }
}

public static class CartHelper
{
    private const string SessionKey = "__CART_ITEMS__";

    public static List<SimpleCartItem> GetCart()
    {
        var ctx = System.Web.HttpContext.Current;
        var obj = ctx.Session[SessionKey] as List<SimpleCartItem>;
        if (obj == null)
        {
            obj = new List<SimpleCartItem>();
            ctx.Session[SessionKey] = obj;
        }
        return obj;
    }

    public static void AddItem(SimpleCartItem item)
    {
        var cart = GetCart();
        var existing = cart.FirstOrDefault(c => c.ProductId == item.ProductId);
        if (existing != null)
        {
            existing.Quantity += item.Quantity;
        }
        else
        {
            cart.Add(item);
        }
    }

    public static void UpdateQuantity(int productId, int quantity)
    {
        var cart = GetCart();
        var existing = cart.FirstOrDefault(c => c.ProductId == productId);
        if (existing != null)
        {
            existing.Quantity = quantity < 1 ? 1 : quantity;
        }
    }

    public static void RemoveItem(int productId)
    {
        var cart = GetCart();
        cart.RemoveAll(c => c.ProductId == productId);
    }

    public static void Clear()
    {
        var ctx = System.Web.HttpContext.Current;
        ctx.Session[SessionKey] = new List<SimpleCartItem>();
    }

    public static decimal GetTotal()
    {
        return GetCart().Aggregate(0m, (sum, item) => sum + (item.Price * item.Quantity));
    }
}



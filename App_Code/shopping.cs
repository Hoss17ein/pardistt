

using Microsoft.CSharp;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Diagnostics;
using System.Data.SqlClient;

[Serializable()]
public class CartItem
{
    private int _productID;
    private string _productGroup;
    private string _productName;
    private string _productImageUrl;
    private int _quantity;
    private int _price;
    private int _FeeNemayandeh;
    private int _lineTotal;
    private string _product_source;
    private string _product_color;
    private string _product_waranty;
    private string _product_config;
    private string _product_vasayel_hamrah;
    private string _product_explain;
    private string _product_pic_source;
    private int _product_old_price;
    private int _lineTotal_product_old_price;
    private string _product_persian_name;
    private string _product_url;
    private int _LineNemayndehTotal;
    private int _wazn;
    private int _lineTotal__wazn;

    
    public CartItem()
    {
    }


    public CartItem(int ProductID, string ProductName, string ProductGroup, string ProductImageUrl, int Quantity, double Price, int FeeNemayandeh, int Total_FeeNemayandeh, string product_source, string product_color, string product_waranty, string product_config, string product_vasayel_hamrah, string product_explain, string product_pic_source, int product_old_price, string product_persian_name, string product_url,int product_wazn)
    {
        _productID = ProductID;
        _productName = ProductName;
        _productImageUrl = ProductImageUrl;
        _quantity = Quantity;
        _price =Convert.ToInt32(Price);
        _lineTotal = Convert.ToInt32(Quantity * Price);
        _productGroup = ProductGroup;
        _FeeNemayandeh = FeeNemayandeh;
        _LineNemayndehTotal = Total_FeeNemayandeh;
        //new in database
        _product_source=product_source;
        _product_color=product_color;
        _product_waranty=product_waranty;
        _product_config = product_config;
        _product_vasayel_hamrah = product_vasayel_hamrah;
        _product_explain = product_explain;
        _product_pic_source = product_pic_source;
        _product_old_price =product_old_price;
        _lineTotal_product_old_price = Quantity * product_old_price;
        _product_persian_name = product_persian_name;
        _product_url = product_url;
        _wazn = product_wazn;
        _lineTotal__wazn = Convert.ToInt32(Quantity * product_wazn);


    }
    #region Card Item Made
    public int ProductID
    {
        get { return _productID; }
        set { _productID = value; }
    }

    public string ProductName
    {
        get { return _productName; }
        set { _productName = value; }
    }
    public string ProductGroup
    {
        get { return _productGroup; }
        set { _productGroup = value; }
    }

    public string ProductImageUrl
    {
        get { return _productImageUrl; }
        set { _productImageUrl = value; }
    }

    public int Quantity
    {
        get { return _quantity; }
        set { _quantity = value; }
    }

    public int Price
    {
        get { return _price; }
        set { _price = value; }
    }

    public int LineTotal
    {
        get { return _quantity * _price; }
    }

    public int LineNemayndehTotal
    {
        get { return _quantity * _FeeNemayandeh; }
    }

    public int FeeNemayandeh
    {
        get { return _FeeNemayandeh; }
        set { _FeeNemayandeh = value; }
    }
    public string product_source
    {
        get { return _product_source; }
        set { _product_source = value; }
    }

    public string product_color
    {
        get { return _product_color; }
        set { _product_color = value; }
    }

    public string product_waranty
    {
        get { return _product_waranty; }
        set { _product_waranty = value; }
    }

    public string product_config
    {
        get { return _product_config; }
        set { _product_config = value; }
    }
    public string product_vasayel_hamrah
    {
        get { return _product_vasayel_hamrah; }
        set { _product_vasayel_hamrah = value; }
    }

    public string product_explain
    {
        get { return _product_explain; }
        set { _product_explain = value; }
    }
    public string product_pic_source
    {
        get { return _product_pic_source; }
        set { _product_pic_source = value; }
    }
    public int product_old_price
    {
        get { return _product_old_price; }
        set { _product_old_price = value; }
    }
    public int lineTotal_product_old_price
    {
        get { return _quantity * _product_old_price; }
    }
    public string product_persian_name
    {
        get { return _product_persian_name; }
        set { _product_persian_name = value; }
    }
    public string product_url
    {
        get { return _product_url; }
        set { _product_url = value; }
    }
    public int product_wazn
    {
        get { return _wazn; }
        set { _wazn = value; }
    }
    public int lineTotal__wazn
    {
        get { return _quantity * _wazn; }
    }
    #endregion
}


[Serializable()]
public class WroxShoppingCart
{

    private DateTime _dateCreated;
    private DateTime _lastUpdate;

    private List<CartItem> _items;
    public WroxShoppingCart()
    {
        _items = new List<CartItem>();
        _dateCreated = DateTime.Now;
    }


    public List<CartItem> Items
    {
        get { return _items; }
        set { _items = value; }
    }


    public void Insert(int ProductID, int Price, int Quantity, string ProductName, string ProductGroup, string ProductImageUrl, int FeeNemayandeh, string product_source, string product_color, string product_waranty, string product_config, string product_vasayel_hamrah, string product_explain, string product_pic_source, int product_old_price, string product_persian_name, string product_url,int product_wazn)
    {
        int ItemIndex = ItemIndexOfID(ProductID);

        if (ItemIndex == -1)
        {
            CartItem NewItem = new CartItem();
            NewItem.ProductGroup = ProductGroup;
            NewItem.ProductID = ProductID;
            NewItem.Quantity = Quantity;
            NewItem.Price = Price;
            NewItem.ProductName = ProductName;
            NewItem.ProductImageUrl = ProductImageUrl;
            NewItem.FeeNemayandeh = FeeNemayandeh;
            NewItem.product_source = product_source;
            NewItem.product_color = product_color;
            NewItem.product_waranty = product_waranty;
            NewItem.product_config = product_config;
            NewItem.product_vasayel_hamrah = product_vasayel_hamrah;
            NewItem.product_explain = product_explain;
            NewItem.product_pic_source = product_pic_source;
            NewItem.product_old_price = product_old_price;
            NewItem.product_persian_name = product_persian_name;
            NewItem.product_url = product_url;
            NewItem.product_wazn = product_wazn;
            _items.Add(NewItem);
        }
        else
        {
            _items[ItemIndex].Quantity += 1;
        }

        _lastUpdate = DateTime.Now;

    }


    public void Update(int RowID, int ProductID, int Quantity, int Price, int FeeNemayandeh, int product_old_price,int product_wazn)
    {
        CartItem Item = _items[RowID];

        Item.ProductID = ProductID;
        Item.Quantity = Quantity;
        Item.Price = Price;
        Item.FeeNemayandeh = FeeNemayandeh;
        Item.product_old_price = product_old_price;
        Item.product_wazn = product_wazn;
        _lastUpdate = DateTime.Now;

    }

    private int ItemIndexOfID(int ProductID)
    {

        int index = 0;

        foreach (CartItem item in _items)
        {
            if (item.ProductID == ProductID)
            {
                return index;
            }
            index += 1;
        }

        return -1;

    }

    public void DeleteItem(int rowID)
    {
        _items.RemoveAt(rowID);
        _lastUpdate = DateTime.Now;

    }

    public int Total
    {
        get
        {
            int t = 0;

            if (_items == null)
            {
                return 0;
            }

            foreach (CartItem Item in _items)
            {
                t += Item.LineTotal;
            }

            return t;
        }
    }

    public int Total_old_rice
    {
        get
        {
            int y = 0;
            if (_items == null)
            {
                return 0;
            }

            foreach (CartItem Item in _items)
            {
                y += Item.lineTotal_product_old_price; 
            }

            return y;
        }
    }

    public int TotalNemayandeh
    {
        get
        {
            int t1 = 0;

            if (_items == null)
            {
                return 0;
            }

            foreach (CartItem Item in _items)
            {
                t1 += Item.LineNemayndehTotal;
            }

            return t1;
        }
    }

    public int TotalWazn
    {
        get
        {
            int t1 = 0;

            if (_items == null)
            {
                return 0;
            }

            foreach (CartItem Item in _items)
            {
                t1 += Item.lineTotal__wazn;
            }

            return t1;
        }
    }
}

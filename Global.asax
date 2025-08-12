<%@ Application Language="C#" %>
<%@ Import namespace="System.Web.Routing" %>

<%@ Import namespace="Microsoft.AspNet.FriendlyUrls" %>
<%@ Import namespace="PecPGW.Samples.WebApp.WebForms" %>
<script runat="server">

    public static void RegisterRoutes(RouteCollection routes)
    {
       
    }    
    
    void Application_Start(object sender, EventArgs e) 
    {
        // Code that runs on application startup

        RouteConfig.RegisterRoutes(RouteTable.Routes); 


    }
    
    void Application_End(object sender, EventArgs e) 
    {
        //  Code that runs on application shutdown

    }
        
    void Application_Error(object sender, EventArgs e) 
    { 
        // Code that runs when an unhandled error occurs

    }

    void Session_Start(object sender, EventArgs e) 
    {
        // Code that runs when a new session is started

    }

    void Session_End(object sender, EventArgs e) 
    {
        // Code that runs when a session ends. 
        // Note: The Session_End event is raised only when the sessionstate mode
        // is set to InProc in the Web.config file. If session mode is set to StateServer 
        // or SQLServer, the event is not raised.

    }
    void Profile_OnMigrateAnonymous(object sender, ProfileMigrateEventArgs e)
    {
        ProfileCommon anonymousProfile = Profile.GetProfile(e.AnonymousID);
        if (anonymousProfile.Cart != null)
        {
            if (Profile.Cart == null)
                Profile.Cart = new WroxShoppingCart();

            Profile.Cart.Items.AddRange(anonymousProfile.Cart.Items);

            anonymousProfile.Cart = null;
        }

        ProfileManager.DeleteProfile(e.AnonymousID);
        AnonymousIdentificationModule.ClearAnonymousIdentifier();
    }
</script>

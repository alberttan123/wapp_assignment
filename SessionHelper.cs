using System;
using System.Web;
using System.Web.Security;

public static class AuthCookieHelper
{
    private const string CookieName = "AuthCookie";
    public static HttpCookie BuildAuthCookie(string UserId, string userType)
    {
        FormsAuthenticationTicket ticket = new FormsAuthenticationTicket(
            1,                   // version
            UserId,   // stored as ticket.Name
            DateTime.Now,        // issued
            DateTime.Now.AddHours(2),  // expiry
            true,                // persistent
            userType,                // userData (store role)
            FormsAuthentication.FormsCookiePath
        );

        string encrypted = FormsAuthentication.Encrypt(ticket);

        HttpCookie cookie = new HttpCookie(CookieName, encrypted)
        {
            HttpOnly = true,
            Secure = true,
            SameSite = SameSiteMode.Strict
        };

        return cookie;
    }

    public static (bool success, string UserId, string userType) ReadAuthCookie()
    {
        HttpCookie cookie = HttpContext.Current.Request.Cookies[CookieName];

        if (cookie == null)
            return (false, null, null);

        try
        {
            FormsAuthenticationTicket ticket =
                FormsAuthentication.Decrypt(cookie.Value);

            string UserId = ticket.Name;
            string userType = ticket.UserData;

            return (true, UserId, userType);
        }
        catch
        {
            // invalid or tampered cookie
            return (false, null, null);
        }
    }

    public static void RemoveAuthCookie()
    {
        HttpCookie cookie = new HttpCookie(CookieName, "")
        {
            Expires = DateTime.Now.AddDays(-1)
        };

        HttpContext.Current.Response.Cookies.Add(cookie);
    }
}

using System;
using System.Data.SqlClient;
using System.Text.RegularExpressions;
using System.Web.UI;
using static WAPP_Assignment.DataAccess;

namespace WAPP_Assignment.Student
{
    public partial class ViewPage : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                LoadPageContent();
        }

        private void LoadPageContent()
        {
            string pageIdRaw = Request.QueryString["PageId"];

            if (string.IsNullOrEmpty(pageIdRaw) || !int.TryParse(pageIdRaw, out int pageId))
            {
                ShowError();
                return;
            }

            string title = null;
            string content = null;

            using (var conn = GetOpenConnection())
            using (var cmd = new SqlCommand(@"
                SELECT PageTitle, PageContent 
                FROM dbo.StaticPages
                WHERE PageId = @PageId;", conn))
            {
                cmd.Parameters.AddWithValue("@PageId", pageId);

                using (var rd = cmd.ExecuteReader())
                {
                    if (!rd.Read())
                    {
                        ShowError();
                        return;
                    }

                    title = rd["PageTitle"]?.ToString();
                    content = rd["PageContent"]?.ToString();
                }
            }

            pnlPage.Visible = true;
            pnlError.Visible = false;
            lblPageTitle.InnerText = title;

            if (string.IsNullOrWhiteSpace(content))
            {
                pnlEmpty.Visible = true;
                litHtmlContent.Visible = false;
                litPlainContent.Visible = false;
                return;
            }

            // Detect HTML-looking content
            bool looksLikeHtml =
                content.Contains("<") &&
                content.Contains(">");

            pnlEmpty.Visible = false;

            if (looksLikeHtml)
            {
                string safe = SanitizeHtml(content);

                litHtmlContent.Visible = true;
                litPlainContent.Visible = false;

                litHtmlContent.Text = safe;
            }
            else
            {
                litPlainContent.Visible = true;
                litHtmlContent.Visible = false;

                litPlainContent.Text = Server.HtmlEncode(content).Replace("\n", "<br/>");
            }
        }

        private string SanitizeHtml(string html)
        {
            if (string.IsNullOrEmpty(html))
                return "";

            string cleaned = html;

            // Remove script/style/iframe/object/embed
            cleaned = Regex.Replace(cleaned, @"<(script|style|iframe|object|embed)[\s\S]*?</\1>", "", RegexOptions.IgnoreCase);

            // Remove inline JS events (onclick, onload, etc.)
            cleaned = Regex.Replace(cleaned, @" on\w+\s*=\s*(""[^""]*""|'[^']*')", "", RegexOptions.IgnoreCase);

            // Remove javascript: URLs
            cleaned = Regex.Replace(cleaned, @"javascript\s*:", "", RegexOptions.IgnoreCase);

            return cleaned;
        }

        private void ShowError()
        {
            pnlPage.Visible = false;
            pnlError.Visible = true;
        }
    }
}

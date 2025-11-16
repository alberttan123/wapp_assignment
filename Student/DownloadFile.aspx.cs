using System;
using System.Data.SqlClient;
using System.IO;
using System.Web;
using System.Web.UI;
using static WAPP_Assignment.DataAccess;

namespace WAPP_Assignment.Student
{
    public partial class DownloadFile : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                ProcessDownload();
        }

        private void ProcessDownload()
        {
            string idRaw = Request.QueryString["FileId"];
            if (string.IsNullOrEmpty(idRaw) || !int.TryParse(idRaw, out int fileId))
            {
                ShowError();
                return;
            }

            // --- FETCH FILE PATH FROM DATABASE ---
            string filePathDb = null;

            using (var conn = GetOpenConnection())
            using (var cmd = new SqlCommand(
                "SELECT FilePath FROM dbo.Files WHERE FileId = @FileId;", conn))
            {
                cmd.Parameters.AddWithValue("@FileId", fileId);
                object result = cmd.ExecuteScalar();
                filePathDb = result?.ToString();
            }

            if (string.IsNullOrEmpty(filePathDb))
            {
                ShowError();
                return;
            }

            // --- MAP PATH TO SERVER DIRECTORY ---
            string fullPath = Server.MapPath(filePathDb);

            if (!File.Exists(fullPath))
            {
                ShowError();
                return;
            }

            // --- SEND FILE TO CLIENT ---
            string fileName = Path.GetFileName(fullPath);

            Response.Clear();
            Response.ContentType = MimeMapping.GetMimeMapping(fileName);
            Response.AddHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
            Response.TransmitFile(fullPath);
            Response.End();
        }

        private void ShowError()
        {
            pnlError.Visible = true;
        }
    }
}

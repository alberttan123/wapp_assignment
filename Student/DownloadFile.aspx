<%@ Page Language="C#" AutoEventWireup="true"
    CodeBehind="DownloadFile.aspx.cs"
    Inherits="WAPP_Assignment.Student.DownloadFile"
    MasterPageFile="~/Site.Master" %>

<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .error-panel {
            margin: 40px auto;
            padding: 20px;
            border: 1px solid #ff6666;
            background: rgba(255, 50, 50, 0.1);
            border-radius: 10px;
            text-align: center;
            max-width: 400px;
            color: #ff6666;
        }
    </style>
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">

    <asp:Panel ID="pnlError" runat="server" CssClass="error-panel" Visible="false">
        <h2>File not found</h2>
        <p>The file you requested does not exist or is unavailable.</p>
    </asp:Panel>

</asp:Content>

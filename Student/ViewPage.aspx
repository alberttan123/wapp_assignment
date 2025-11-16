<%@ Page Title="View Page" Language="C#" MasterPageFile="~/Site.Master" 
    AutoEventWireup="true" CodeBehind="ViewPage.aspx.cs" 
    Inherits="WAPP_Assignment.Student.ViewPage" %>

<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
      <link href="<%= ResolveUrl("~/Content/waplanding.css") %>" rel="stylesheet" />
        <style>
        .page-container {
            max-width: 820px;
            margin: 40px auto;
            padding: 0 20px;
        }

        .page-header {
            font-size: 32px;
            font-weight: 700;
            margin-bottom: 20px;
            color: #fff;
            text-shadow: 0 0 4px rgba(255,255,255,0.15);
        }

        .page-card {
            background: #1a1a1a;
            border: 1px solid #333;
            padding: 28px;
            border-radius: 12px;
            box-shadow: 0 0 24px rgba(0,0,0,0.3);
            margin-top: 10px;
            color: #eaeaea;
            line-height: 1.7;
        }

        .empty-message {
            font-size: 18px;
            font-weight: 500;
            padding: 40px;
            text-align: center;
            color: #bbb;
        }

        .btn-back {
            display: inline-block;
            background: #333;
            border: 1px solid #555;
            padding: 10px 18px;
            border-radius: 6px;
            text-decoration: none;
            color: #fafafa;
            margin-top: 20px;
            transition: 0.2s;
        }
        .btn-back:hover {
            background: #444;
            border-color: #777;
        }

        .error-box {
            background: #290000;
            border: 1px solid #550000;
            color: #ffb3b3;
            padding: 24px;
            border-radius: 10px;
            margin-top: 30px;
            text-align: center;
            font-size: 18px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="page-container">

        <asp:Panel ID="pnlError" runat="server" Visible="false">
            <div class="error-box">
                Page not found.
            </div>
        </asp:Panel>

        <asp:Panel ID="pnlPage" runat="server" Visible="false">

            <h1 class="page-header" id="lblPageTitle" runat="server"></h1>

            <div class="page-card">
                <asp:Literal ID="litHtmlContent" runat="server" Mode="PassThrough" Visible="false"></asp:Literal>
                <asp:Literal ID="litPlainContent" runat="server" Visible="false"></asp:Literal>

                <asp:Panel ID="pnlEmpty" runat="server" Visible="false">
                    <div class="empty-message">
                        This page has no content yet 👻
                    </div>
                </asp:Panel>
            </div>

            <a href="/Base/CourseDashboard.aspx" class="btn-back">← Back to Courses</a>

        </asp:Panel>

    </div>

</asp:Content>

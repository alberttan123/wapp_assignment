<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ViewPost.aspx.cs" Async="true" Inherits="WAPP_Assignment.Forum.ViewPost" %>
<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
    <link rel="stylesheet" href="<%= ResolveUrl("~/Content/waplanding.css") %>">
    <link rel="stylesheet" href="<%= ResolveUrl("~/Content/ViewPost.css") %>">
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <asp:Panel ID="container" runat="server">
        <div class="back-button-container">
            <asp:LinkButton CssClass="backButton" runat="server" OnClick="backToAllPosts" Text="go back"></asp:LinkButton>
        </div>
        <div class="postSection">
            <asp:Label ID="postCreatedAt" CssClass="postCreatedAt" runat="server"></asp:Label>
            <asp:Label ID="postUsername" CssClass="postUsername" runat="server"></asp:Label>
            <asp:Label ID="postCreatedByUserType" CssClass="postUsername" runat="server"></asp:Label>
            <asp:Label ID="postTitle" CssClass="postTitle" runat="server"></asp:Label>
            <asp:Label ID="postMessage" CssClass="postMessage" runat="server"></asp:Label>
            <asp:Panel ID="deletePostButton" CssClass="delete-post-button-container" runat="server" Visible="false"></asp:Panel>
            <asp:Label ID="postError" runat="server" Visible="false" CssClass="postError"></asp:Label>
        </div>

        <div class="aiSummarySection">
            <asp:Label ID="AI_OUTPUT" visible="true" runat="server" Text="Generate AI Summary of this post"></asp:Label>
            <asp:LinkButton ID="ai_summary_button" runat="server" OnClick="generateAISummary" Text="Generate" CssClass="aiSummaryButton"></asp:LinkButton>
        </div>

        <div class="addCommentSection">
            <asp:TextBox ID="addComment" runat="server" placeholder="Add your comment..."></asp:TextBox>
            <asp:Button ID="addCommentButton" runat="server" Text="Add Comment" OnClick="makeNewComment"></asp:Button>
            <asp:Label ID="commentError" runat="server" Visible="false" CssClass="commentError"></asp:Label>
        </div>

        <asp:Panel CssClass="commentSection" ID="commentSection" runat="server">
        </asp:Panel>

    </asp:Panel>
</asp:Content>

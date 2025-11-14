<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ViewPost.aspx.cs" Inherits="WAPP_Assignment.Forum.ViewPost" %>
<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
    <link rel="stylesheet" href="<%= ResolveUrl("~/Content/waplanding.css") %>">
    <link rel="stylesheet" href="<%= ResolveUrl("~/Content/ViewPost.css") %>">
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <asp:Panel ID="container" runat="server">
        <div class="viewpost-header">
            <div class="viewpost-header-content">
                <h1 class="viewpost-page-title">Post Details</h1>
                <p class="viewpost-page-subtitle">Explore the discussion and join the conversation</p>
            </div>
            <div class="back-button-container-header">
                <asp:LinkButton CssClass="backButton" runat="server" OnClick="backToAllPosts" Text="go back"></asp:LinkButton>
            </div>
        </div>
        <div class="postSection">
            <div class="post-detail-header">
                <asp:Label ID="postUsername" CssClass="postUsername" runat="server"></asp:Label>
                <asp:Label ID="postCreatedByUserType" CssClass="postUserType" runat="server"></asp:Label>
            </div>
            <asp:Label ID="postTitle" CssClass="postTitle" runat="server"></asp:Label>
            <asp:Label ID="postCreatedAt" CssClass="postCreatedAt" runat="server"></asp:Label>
            <asp:Label ID="postMessage" CssClass="postMessage" runat="server"></asp:Label>
            <asp:Panel ID="deletePostButton" CssClass="delete-post-button-container" runat="server" Visible="false"></asp:Panel>
            <asp:Label ID="postError" runat="server" Visible="false" CssClass="postError"></asp:Label>
        </div>

        <div class="addCommentSection">
            <asp:TextBox ID="addComment" TextMode="MultiLine" Rows="6" runat="server" placeholder="Add your comment..."></asp:TextBox>
            <asp:Button ID="addCommentButton" runat="server" Text="Add Comment" OnClick="makeNewComment"></asp:Button>
            <asp:Label ID="commentError" runat="server" Visible="false" CssClass="commentError"></asp:Label>
        </div>

        <div class="comments-heading-container">
            <h2 class="section-heading-comment">💬 Comments</h2>
        </div>

        <asp:Panel CssClass="commentSection" ID="commentSection" runat="server">
        </asp:Panel>

    </asp:Panel>
</asp:Content>

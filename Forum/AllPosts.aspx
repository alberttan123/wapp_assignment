<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AllPosts.aspx.cs" Inherits="WAPP_Assignment.Forum.AllPosts" MasterPageFile="~/Site.Master"%>

<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
  <link href="<%= ResolveUrl("~/Content/waplanding.css") %>" rel="stylesheet" />
  <link href="<%= ResolveUrl("~/Content/AllPosts.css") %>" rel="stylesheet" />
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <asp:Panel ID="addPostModal" Visible="false" runat="server" CssClass="addPostModalContainer">
        <asp:LinkButton ID="addPostBackdrop" runat="server" CssClass="backdrop" OnClick="hideAddPostModal" CausesValidation="false" />
        <div class="pages-modal">
            <div class="addPostModalMainContent sheet sheet-addPost">
                <div class="modal-header modal-header-addPost">
                    <span>Add a new post</span>
                </div>

                <asp:Label Text="Post Title" runat="server"></asp:Label>
                <asp:TextBox ID="postTitle" placeholder="Enter your post title..." runat="server"></asp:TextBox>
                <asp:Label Text="Post Message" runat="server"></asp:Label>
                <asp:TextBox ID="postMessage" TextMode="MultiLine" Rows="6" placeholder="Share your thoughts..." runat="server"></asp:TextBox>
                <asp:Label ID="addPostError" CssClass="addPostError" runat="server"></asp:Label>

                <div class="modalControls modalControls-addPost">
                    <asp:LinkButton ID="lnkCancelAddPost" runat="server" CssClass="btn cancel" OnClick="hideAddPostModal" CausesValidation="false">Cancel</asp:LinkButton>
                    <asp:LinkButton ID="lnkAddPost" runat="server" CssClass="btn primary" OnClick="addPost" CausesValidation="false">Add Post</asp:LinkButton>
                </div>
            </div>
        </div>
    </asp:Panel> 
    
    <div class="forum-header">
        <div class="forum-header-content">
            <h1 class="forum-page-title">Forum</h1>
            <p class="forum-page-subtitle">Share your thoughts and connect with the community</p>
        </div>
        <div class="addPostButtonContainer">
            <asp:Button ID="addPostButton" OnClick="showAddPostModal" CssClass="addPostButton" Text="Add Post" runat="server"></asp:Button>
        </div>
    </div>
    <div class="forum-controls">
        <div class="forum-search-container">
            <label>Search:</label>
            <asp:TextBox ID="searchBox" CssClass="forum-search" AutoPostBack="true" OnTextChanged="handleSearchAndSort" runat="server"></asp:TextBox>
        </div>
        <div class="forum-sort-container">
            <label>Sort by:</label>
            <asp:DropDownList ID="sortDropdown" runat="server" AutoPostBack="true" OnSelectedIndexChanged="handleSearchAndSort" CssClass="forum-sort">
                <asp:ListItem Text="Title Alphabetical (a -> z)" Value="a-to-z" />
                <asp:ListItem Text="Title Alphabetical (z -> a)" Value="z-to-a" />
                <asp:ListItem Text="Date Posted (Latest First)" Value="latest first" />
                <asp:ListItem Text="Date Posted (Latest Last)" Value="latest last" />
                <asp:ListItem Text="My Own Posts" Value="my own posts" ID="my_own_posts"/>
            </asp:DropDownList>
        </div>
    </div>
    <asp:Panel CssClass="forum-content" ID="forum_content" runat="server"></asp:Panel>
</asp:Content>
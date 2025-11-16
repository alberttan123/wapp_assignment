<%@ Page Language="C#" Title="Geography Pages - Explore" AutoEventWireup="true" CodeBehind="Landing.aspx.cs" Inherits="WAPP_Assignment.Landing" MasterPageFile="~/Site.Master" %>

<%-- Head Content START --%>
<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
  <link href="<%= ResolveUrl("~/Content/waplanding.css") %>" rel="stylesheet" />
</asp:Content>
<%-- Head Content END --%>

<%-- Main Content START --%>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">
  <header class="a">
    <div class="a-bg" role="img" aria-label="Adventure landscape background"></div>
    <div class="a-scrim"></div>
    <div class="a-fade"></div>

    <div class="a-content">
      <p class="eyebrow">START YOUR</p>
      <h1 class="a-title">Adventure</h1>
      <p class="a-sub">The most fun and beginner-friendly way to learn our geography. ✨</p>
      <div class="a-cta">
        <asp:LinkButton ID="get_started_button" CssClass="cta-btn" runat="server" OnClick="showLoginSignupModal" Text="Get Started"></asp:LinkButton>
      </div>
    </div>
  </header>

  <section class="courses">
    <div class="container">
      <h2 class="section-title">Journey through the world of geography</h2>
      <p class="section-sub">Explore our planet with fun, interactive lessons crafted by educators.</p>
      <div class="center">
          <asp:Button ID="bruh" CssClass="outline-btn" Text="Explore All Courses →" runat="server" OnClick="redirToCourses"></asp:Button>
      </div>
    </div>
  </section>
 </asp:Content>
<%-- Main Content END --%>
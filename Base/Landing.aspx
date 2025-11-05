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
        <button class="cta-btn">Get started</button>
      </div>
    </div>
  </header>

  <section class="courses">
    <div class="container">
      <h2 class="section-title">Journey through the world of geography</h2>
      <p class="section-sub">Explore our planet with fun, interactive lessons crafted by educators.</p>

      <div class="pill-row">
        <button class="pill active">Popular</button>
        <button class="pill">Physical Geography</button>
        <button class="pill">Human Geography</button>
        <button class="pill">Maps & Navigation</button>
      </div>

      <div class="grid">
        <article class="card">
          <div class="card-media"></div>
          <div class="card-body">
            <span class="badge">COURSE</span>
            <h3 class="card-title">World Geography</h3>
            <p class="card-text">Explore continents, countries, capitals, and physical features.</p>
            <div class="meta">
              <span class="dot"></span>
              <span class="level">Beginner</span>
            </div>
          </div>
        </article>

        <article class="card">
          <div class="card-media"></div>
          <div class="card-body">
            <span class="badge">COURSE</span>
            <h3 class="card-title">Climate & Weather</h3>
            <p class="card-text">Understand weather patterns, climate zones, and atmospheric processes.</p>
            <div class="meta">
              <span class="dot"></span>
              <span class="level">Beginner</span>
            </div>
          </div>
        </article>

        <article class="card">
          <div class="card-media"></div>
          <div class="card-body">
            <span class="badge">COURSE</span>
            <h3 class="card-title">Geology & Landforms</h3>
            <p class="card-text">Discover mountains, rivers, volcanoes, and Earth's geological processes.</p>
            <div class="meta">
              <span class="dot"></span>
              <span class="level">Beginner</span>
            </div>
          </div>
        </article>

        <article class="card">
          <div class="card-media"></div>
          <div class="card-body">
            <span class="badge">COURSE</span>
            <h3 class="card-title">Cultural Geography</h3>
            <p class="card-text">Explore human cultures, languages, religions, and social patterns.</p>
            <div class="meta">
              <span class="dot"></span>
              <span class="level">Beginner</span>
            </div>
          </div>
        </article>

        <article class="card">
          <div class="card-media"></div>
          <div class="card-body">
            <span class="badge">COURSE</span>
            <h3 class="card-title">Cartography</h3>
            <p class="card-text">Learn map reading, GPS navigation, and geographic information systems.</p>
            <div class="meta">
              <span class="dot"></span>
              <span class="level">Beginner</span>
            </div>
          </div>
        </article>
      </div>

      <div class="center">
        <button class="outline-btn">Explore All Courses →</button>
      </div>
    </div>
  </section>
 </asp:Content>
<%-- Main Content END --%>
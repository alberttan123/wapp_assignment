<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="flashcard.aspx.cs" Inherits="WAPP_Assignment.Student.flashcard" %>


<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head runat="server">
  <meta charset="utf-8" />
  <title>Flashcards — Geography Pages</title>
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <link href="<%= ResolveUrl("~/Content/waplanding.css") %>" rel="stylesheet" />
</head>
<body>
  <!-- NAV - Same as other pages -->
  <nav class="navbar">
    <div class="nav-container">
      <div class="brand">
        <a href="<%= ResolveUrl("~/Base/Landing.aspx") %>">
          <img src="<%= ResolveUrl("~/Content/images/pages.svg") %>" alt="Geography Pages Logo" class="brand-img" />
        </a>
      </div>

      <div class="nav-links">
        <div class="nav-item-dropdown">
          <a class="nav-link" href="<%= ResolveUrl("~/Base/CourseDashboard.aspx") %>">Learn <span class="chevron"></span></a>
          <div class="dropdown-menu">
            <div class="dropdown-grid">
              <div class="dropdown-column">
                <h4 class="dropdown-heading">Recommended</h4>
                <a href="#" class="dropdown-link">World Geography</a>
                <a href="#" class="dropdown-link">Climate & Weather</a>
              </div>
              <div class="dropdown-column">
                <h4 class="dropdown-heading">Physical Geography</h4>
                <a href="#" class="dropdown-link">Geology & Landforms</a>
                <a href="#" class="dropdown-link">Oceans & Tides</a>
                <a href="#" class="dropdown-link">Ecosystems</a>
              </div>
              <div class="dropdown-column">
                <h4 class="dropdown-heading">Human Geography</h4>
                <a href="#" class="dropdown-link">Cultural Geography</a>
                <a href="#" class="dropdown-link">Population Studies</a>
                <a href="#" class="dropdown-link">Political Geography</a>
              </div>
            </div>
          </div>
        </div>
        <a class="nav-link" href="#">Practice</a>
        <a class="nav-link" href="#">Build</a>
        <a class="nav-link" href="#">Community</a>
        <a class="nav-link" href="#">Pricing</a>
      </div>

      <div class="nav-actions">
        <button class="primary-btn">Sign up</button>
      </div>
    </div>
  </nav>

  <form id="form1" runat="server">
    <div>
      <!-- Your flashcard content here -->
    </div>
  </form>

  <!-- FOOTER - Same as other pages -->
  <footer class="footer">
    <p>© Geography Pages</p>
  </footer>
</body>
</html>

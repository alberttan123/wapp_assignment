<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CourseDashboard.aspx.cs" Inherits="WAPP_Assignment.Base.CourseDashboard" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head runat="server">
  <meta charset="utf-8" />
  <title>Courses — Geography Pages</title>
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <link href="<%= ResolveUrl("~/Content/waplanding.css") %>" rel="stylesheet" />
  <style>
    .a-bg {
        background-image: url('http://i.imgur.com/Mruq10X.gif');
    }

    .course-trilogy {
        padding: 4rem 0;
    }
    .trilogy-header {
        display: flex;
        align-items: center;
        gap: 1rem;
        margin-bottom: 1.5rem;
    }
    .trilogy-icon {
        font-size: 1.5rem;
    }
    .trilogy-title {
        font-size: 1.5rem;
        font-weight: 700;
        margin: 0;
    }
    .trilogy-subtitle {
        margin: 0;
        color: var(--muted);
    }
  </style>
</head>

<body>
  <!-- NAV - Consistent with Landing.aspx -->
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

  <header class="a">
    <div class="a-bg" role="img" aria-label="Pixel art world background"></div>
    <div class="a-scrim"></div>
    <div class="a-fade"></div>
    <div class="a-content">
      <p class="eyebrow">EXPLORE THE WORLD OF</p>
      <h1 class="a-title">Geography</h1>
      <p class="a-sub">Lorem ipsum dolor sit amet, consectetur adipiscing elit.</p>
      <div class="a-cta">
        <a href="#courses" class="cta-btn">Explore for free!</a>
      </div>
    </div>
  </header>

  <main id="courses" class="container">
    <section class="course-trilogy">
      <div class="trilogy-header">
        <span class="trilogy-icon">🌍</span>
        <div>
          <h2 class="trilogy-title">Lorem Ipsum Dolor</h2>
          <p class="trilogy-subtitle">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</p>
        </div>
      </div>
      <div class="grid">
        <article class="card">
          <div class="card-media" style="background-image:url('<%= ResolveUrl("~/Content/images/python-course.png") %>')"></div>
          <div class="card-body">
            <span class="badge">COURSE 1</span>
            <h3 class="card-title">Lorem Ipsum</h3>
            <p class="card-text">Lorem ipsum dolor sit amet, consectetur adipiscing elit.</p>
            <div class="meta">
              <span class="dot"></span>
              <span class="level">Beginner</span>
            </div>
          </div>
        </article>
      </div>
    </section>

    <section class="course-trilogy">
      <div class="trilogy-header">
        <span class="trilogy-icon">🗺️</span>
        <div>
          <h2 class="trilogy-title">Sit Amet Consectetur</h2>
          <p class="trilogy-subtitle">Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</p>
        </div>
      </div>
      <div class="grid">
        <article class="card">
          <div class="card-media" style="background-image:url('<%= ResolveUrl("~/Content/images/html-course.png") %>')"></div>
          <div class="card-body">
            <span class="badge">COURSE 1</span>
            <h3 class="card-title">Duis Aute</h3>
            <p class="card-text">Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.</p>
            <div class="meta">
              <span class="dot"></span>
              <span class="level">Beginner</span>
            </div>
          </div>
        </article>
      </div>
    </section>
  </main>

  <footer class="footer">
    <div class="container"><p>© Geography Pages</p>
  </footer>
</body>
</html>
<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CourseDashboard.aspx.cs" Inherits="WAPP_Assignment.Base.CourseDashboard" MasterPageFile="~/Site.Master" %>

<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
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
        margin-bottom: 2rem;
    }
    .trilogy-icon {
        font-size: 2.5rem;
    }
    .trilogy-title {
        font-size: 1.8rem;
        font-weight: 700;
        margin: 0;
    }
    .trilogy-subtitle {
        margin: 0.5rem 0 0 0;
        color: var(--muted);
        font-size: 1rem;
        line-height: 1.6;
    }


    /* Course Cards Grid */
    .garden-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(360px, 1fr));
        gap: 2rem;
    }

    /* Card Wrapper for Layered Effect */
    .garden-card-wrapper {
        position: relative;
        width: 100%;
        margin-bottom: 0.5rem;
    }

.garden-card-wrapper::before {
    content: '';
    position: absolute;
    bottom: -3px;
    left: 50%;
    transform: translateX(-50%);
    width: calc(100% + 10px);
    height: 100%;
    background: rgba(51, 65, 85, 0.8);
    clip-path: polygon(
        6px 0px, 6px 2px, 4px 2px, 4px 4px, 2px 4px, 2px 6px, 0px 6px, 0px calc(100% - 6px),
        2px calc(100% - 6px), 2px calc(100% - 4px), 4px calc(100% - 4px), 4px calc(100% - 2px),
        6px calc(100% - 2px), 6px calc(100% - 0px), calc(100% - 6px) calc(100% - 0px),
        calc(100% - 6px) calc(100% - 2px), calc(100% - 4px) calc(100% - 2px), 
        calc(100% - 4px) calc(100% - 4px), calc(100% - 2px) calc(100% - 4px), 
        calc(100% - 2px) calc(100% - 6px), calc(100% - 0px) calc(100% - 6px), 
        calc(100% - 0px) 6px, calc(100% - 2px) 6px, calc(100% - 2px) 4px, 
        calc(100% - 4px) 4px, calc(100% - 4px) 2px, calc(100% - 6px) 2px, 
        calc(100% - 6px) 0px
    );
    z-index: -1;
    transition: all 0.3s ease;
}

.garden-card-wrapper::after {
    content: '';
    position: absolute;
    bottom: -3px;
    left: 50%;
    transform: translateX(-50%);
    width: calc(100% + 10px);
    height: 100%;
    background: transparent;
    clip-path: polygon(
        6px 0px, 6px 2px, 4px 2px, 4px 4px, 2px 4px, 2px 6px, 0px 6px, 0px calc(100% - 6px),
        2px calc(100% - 6px), 2px calc(100% - 4px), 4px calc(100% - 4px), 4px calc(100% - 2px),
        6px calc(100% - 2px), 6px calc(100% - 0px), calc(100% - 6px) calc(100% - 0px),
        calc(100% - 6px) calc(100% - 2px), calc(100% - 4px) calc(100% - 2px), 
        calc(100% - 4px) calc(100% - 4px), calc(100% - 2px) calc(100% - 4px), 
        calc(100% - 2px) calc(100% - 6px), calc(100% - 0px) calc(100% - 6px), 
        calc(100% - 0px) 6px, calc(100% - 2px) 6px, calc(100% - 2px) 4px, 
        calc(100% - 4px) 4px, calc(100% - 4px) 2px, calc(100% - 6px) 2px, 
        calc(100% - 6px) 0px
    );
    box-shadow: inset 0 0 0 3px rgba(71, 85, 105, 0.5);
    z-index: -2;
    pointer-events: none;
}

    .garden-card-wrapper:hover::before {
        bottom: -4px;
        width: calc(100% + 14px);
        background: rgba(71, 85, 105, 0.9);
    }

    .garden-card-wrapper:hover::after {
        bottom: -4px;
        width: calc(100% + 14px);
        box-shadow: inset 0 0 0 3px rgba(100, 116, 139, 0.7);
    }

    /* Individual Garden-style Course Card with Pixelated Border */
    .garden-card {
        position: relative;
        background: transparent;
        width: 100%;
        height: auto;
        min-height:330px;
        border-radius: 0;
        overflow: hidden;
        transition: transform 0.3s ease, filter 0.3s ease;
        cursor: pointer;
        text-decoration: none;
        display: flex;
        flex-direction:column;
        box-sizing: border-box;
        padding: 3px;
        z-index: 1;
    }

.garden-card::before {
    content: '';
    position: absolute;
    inset: 0;
    background: rgba(102, 126, 234, 0.6);
    clip-path: polygon(
        6px 0px, 6px 2px, 4px 2px, 4px 4px, 2px 4px, 2px 6px, 0px 6px, 0px calc(100% - 6px),
        2px calc(100% - 6px), 2px calc(100% - 4px), 4px calc(100% - 4px), 4px calc(100% - 2px),
        6px calc(100% - 2px), 6px calc(100% - 0px), calc(100% - 6px) calc(100% - 0px),
        calc(100% - 6px) calc(100% - 2px), calc(100% - 4px) calc(100% - 2px), 
        calc(100% - 4px) calc(100% - 4px), calc(100% - 2px) calc(100% - 4px), 
        calc(100% - 2px) calc(100% - 6px), calc(100% - 0px) calc(100% - 6px), 
        calc(100% - 0px) 6px, calc(100% - 2px) 6px, calc(100% - 2px) 4px, 
        calc(100% - 4px) 4px, calc(100% - 4px) 2px, calc(100% - 6px) 2px, 
        calc(100% - 6px) 0px
    );
    z-index: 0;
    transition: background 0.3s ease;
    pointer-events: none;
}

    /* Inner card background with same clip-path */
    .garden-card::after {
        content: '';
        position: absolute;
        inset: 3px;
        background: rgb(30, 41, 59);
        clip-path: polygon(
            5px 0px, 5px 2px, 3px 2px, 3px 3px, 2px 3px, 2px 5px, 0px 5px, 0px calc(100% - 5px),
            2px calc(100% - 5px), 2px calc(100% - 3px), 3px calc(100% - 3px), 3px calc(100% - 2px),
            5px calc(100% - 2px), 5px calc(100% - 0px), calc(100% - 5px) calc(100% - 0px),
            calc(100% - 5px) calc(100% - 2px), calc(100% - 3px) calc(100% - 2px), 
            calc(100% - 3px) calc(100% - 3px), calc(100% - 2px) calc(100% - 3px), 
            calc(100% - 2px) calc(100% - 5px), calc(100% - 0px) calc(100% - 5px), 
            calc(100% - 0px) 5px, calc(100% - 2px) 5px, calc(100% - 2px) 3px, 
            calc(100% - 3px) 3px, calc(100% - 3px) 2px, calc(100% - 5px) 2px, 
            calc(100% - 5px) 0px
        );
        z-index: 0;
        pointer-events: none;
    }

    .garden-card:hover {
        transform: translateY(-6px);
        filter: drop-shadow(0 20px 40px rgba(0, 0, 0, 0.4));
    }

.garden-card:hover::before {
    background: linear-gradient(135deg, 
        rgba(102, 126, 234, 0.9) 0%, 
        rgba(168, 85, 247, 0.9) 50%,
        rgba(236, 72, 153, 0.9) 100%);
}

    /* Image Container at Top */
    .garden-image {
        width: calc(100% - 6px);
        height: 180px;
        margin: 3px 3px 0 3px;
        overflow: hidden;
        position: relative;
        background: linear-gradient(135deg, #1a1d2e 0%, #2d3748 100%);
        z-index: 1;
    }

    .garden-image img {
        width: 100%;
        height: 100%;
        object-fit: cover;
        transition: transform 0.3s ease;
        display: block;
    }

    .garden-card:hover .garden-image img {
        transform: scale(1.05);
    }

    /* NEW Badge */
    .garden-new-badge {
        position: absolute;
        top: 15px;
        right: 15px;
        background: linear-gradient(135deg, #d97706 0%, #f59e0b 100%);
        color: white;
        padding: 0.4rem 0.8rem;
        border-radius: 20px;
        font-size: 0.7rem;
        font-weight: 800;
        text-transform: uppercase;
        letter-spacing: 0.05em;
        box-shadow: 0 4px 12px rgba(217, 119, 6, 0.5);
        z-index: 10;
    }

.garden-content {
    padding: 16px 24px 30px 24px;
    background: transparent;
    height:auto;
    flex: 1;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    position: relative;
    z-index: 2;
    margin: 0 3px 3px 3px;
    box-sizing: border-box;
}

.garden-course-num {
    font-size: 0.7rem;
    font-weight: 700;
    color: rgba(255, 255, 255, 0.6);
    text-transform: uppercase;
    letter-spacing: 0.1em;
    margin-bottom: 0.5rem;
    position: relative;
    z-index: 10;
}

/* Course Title */
.garden-title {
    font-size: 18px;
    font-weight: 800;
    color: white;
    margin: 0 0 0.5rem 0;
    line-height: 1.2;
    position: relative;
    z-index: 10;
}

.garden-desc {
    font-size: 16px;
    color: rgba(255, 255, 255, 0.7);
    line-height: 1.5;
    margin-bottom: 1rem;
    overflow: hidden;
    text-overflow: ellipsis;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    position: relative;
    z-index: 10;
}

.garden-stats {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-top: auto;
    padding-top: 0.5rem;
    position: relative;
    z-index: 10;
}

.garden-level {
    display: inline-flex;
    align-items: center;
    gap: 0.4rem;
    padding: 5px 12px;
    background: rgba(102, 126, 234, 0.2);
    border: 1px solid rgba(102, 126, 234, 0.4);
    border-radius: 20px;
    font-size: 0.75rem;
    font-weight: 700;
    color: rgba(255, 255, 255, 0.9);
    text-transform: uppercase;
    white-space: nowrap;
    position: relative;
    z-index: 10;
    transition: all 0.3s ease;
}  

    .garden-level-icon {
        font-size: 0.85rem;
    }

  </style>
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
  
  <header class="a">
    <div class="a-bg" role="img" aria-label="Pixel art world background"></div>
    <div class="a-scrim"></div>
    <div class="a-fade"></div>
    <div class="a-content">
      <p class="eyebrow">LOREM IPSUM DOLOR</p>
      <h1 class="a-title">Sit Amet Consectetur</h1>
      <p class="a-sub">Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</p>
      <div class="a-cta">
        <a href="#courses" class="cta-btn">Explore for free!</a>
      </div>
    </div>
  </header>

  <main id="courses" class="container">
    
    <!-- First Course Category -->
    <section class="course-trilogy">
      <div class="trilogy-header">
        <span class="trilogy-icon">🌍</span>
        <div>
          <h2 class="trilogy-title">Lorem Ipsum Dolor</h2>
          <p class="trilogy-subtitle">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</p>
        </div>
      </div>
      
      <div class="garden-grid">
        
        <!-- Course Card 1 with Wrapper -->
        <div class="garden-card-wrapper">
          <a href="#" class="garden-card">
            <div class="garden-image">
              <img src="https://images.unsplash.com/photo-1477959858617-67f85cf4f1df?w=800" alt="Course Image" />
            </div>
            <div class="garden-content">
              <div>
                <p class="garden-course-num">COURSE 1</p>
                <h3 class="garden-title">Dolor Sit Amet</h3>
                <p class="garden-desc">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut enim ad minim veniam quis nostrud.</p>
              </div>
              <div class="garden-stats">
                <span class="garden-level">
                  <span class="garden-level-icon">📊</span>
                  BEGINNER
                </span>
                <span class="garden-progress-text">12 lessons</span>
              </div>
            </div>
          </a>
        </div>

        <!-- Course Card 2 with Wrapper -->
        <div class="garden-card-wrapper">
          <a href="#" class="garden-card">
            <div class="garden-image">
              <img src="https://wallpapercave.com/wp/wp2831095.jpg" alt="Course Image" />
            </div>
            <div class="garden-content">
              <div>
                <p class="garden-course-num">COURSE 2</p>
                <h3 class="garden-title">Consectetur Adipiscing</h3>
                <p class="garden-desc">Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</p>
              </div>
              <div class="garden-stats">
                <span class="garden-level">
                  <span class="garden-level-icon">📊</span>
                  INTERMEDIATE
                </span>
                <span class="garden-progress-text">18 lessons</span>
              </div>
            </div>
            <div class="garden-progress-bar">
              <div class="garden-progress-fill" style="width: 45%"></div>
            </div>
          </a>
        </div>

        <!-- Course Card 3 with Wrapper -->
        <div class="garden-card-wrapper">
          <a href="#" class="garden-card">
            <div class="garden-new-badge">NEW!</div>
            <div class="garden-image">
              <img src="https://wallpapercave.com/wp/wp4676582.jpg" alt="Course Image" />
            </div>
            <div class="garden-content">
              <div>
                <p class="garden-course-num">COURSE 3</p>
                <h3 class="garden-title">Tempor Incididunt</h3>
                <p class="garden-desc">Ut labore et dolore magna aliqua. Quis ipsum suspendisse ultrices gravida.</p>
              </div>
              <div class="garden-stats">
                <span class="garden-level">
                  <span class="garden-level-icon">📊</span>
                  INTERMEDIATE
                </span>
                <span class="garden-progress-text">15 lessons</span>
              </div>
            </div>
          </a>
        </div>

      </div>
    </section>

    <!-- Second Course Category -->
    <section class="course-trilogy">
      <div class="trilogy-header">
        <span class="trilogy-icon">🗺️</span>
        <div>
          <h2 class="trilogy-title">Ut Enim Ad Minim</h2>
          <p class="trilogy-subtitle">Quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit.</p>
        </div>
      </div>
      
      <div class="garden-grid">
        
        <!-- Course Card 1 with Wrapper -->
        <div class="garden-card-wrapper">
          <a href="#" class="garden-card">
            <div class="garden-image">
              <img src="https://images.unsplash.com/photo-1526778548025-fa2f459cd5c1?w=800" alt="Course Image" />
            </div>
            <div class="garden-content">
              <div>
                <p class="garden-course-num">COURSE 1</p>
                <h3 class="garden-title">Veniam Quis</h3>
                <p class="garden-desc">Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt.</p>
              </div>
              <div class="garden-stats">
                <span class="garden-level">
                  <span class="garden-level-icon">📊</span>
                  BEGINNER
                </span>
                <span class="garden-progress-text">20 lessons</span>
              </div>
            </div>
            <div class="garden-progress-bar">
              <div class="garden-progress-fill" style="width: 75%"></div>
            </div>
          </a>
        </div>

        <!-- Course Card 2 with Wrapper -->
        <div class="garden-card-wrapper">
          <a href="#" class="garden-card">
            <div class="garden-new-badge">NEW!</div>
            <div class="garden-image">
              <img src="https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=800" alt="Course Image" />
            </div>
            <div class="garden-content">
              <div>
                <p class="garden-course-num">COURSE 2</p>
                <h3 class="garden-title">Nostrud Exercitation</h3>
                <p class="garden-desc">Mollit anim id est laborum. Sed ut perspiciatis unde omnis iste natus error sit voluptatem.</p>
              </div>
              <div class="garden-stats">
                <span class="garden-level">
                  <span class="garden-level-icon">📊</span>
                  BEGINNER
                </span>
                <span class="garden-progress-text">16 lessons</span>
              </div>
            </div>
          </a>
        </div>

        <!-- Course Card 3 with Wrapper -->
        <div class="garden-card-wrapper">
          <a href="#" class="garden-card">
            <div class="garden-image">
              <img src="https://images.unsplash.com/photo-1569163139394-de4798aa62b0?w=800" alt="Course Image" />
            </div>
            <div class="garden-content">
              <div>
                <p class="garden-course-num">COURSE 3</p>
                <h3 class="garden-title">Ullamco Laboris</h3>
                <p class="garden-desc">Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit.</p>
              </div>
              <div class="garden-stats">
                <span class="garden-level">
                  <span class="garden-level-icon">📊</span>
                  INTERMEDIATE
                </span>
                <span class="garden-progress-text">22 lessons</span>
              </div>
            </div>
          </a>
        </div>

      </div>
    </section>

  </main>

  <footer class="footer">
    <div class="container">
      <p>© Geography Pages</p>
    </div>
  </footer>
</asp:Content>
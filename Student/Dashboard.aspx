<%@ Page Language="C#" Title="My Dashboard - Geography Pages" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="WAPP_Assignment.Student.Dashboard" MasterPageFile="~/Site.Master" %>

<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
  <link href="<%= ResolveUrl("~/Content/waplanding.css") %>" rel="stylesheet" />
  <link href="<%= ResolveUrl("~/Content/dashboard.css") %>" rel="stylesheet" />
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
  <main class="dashboard-main">
    <div class="dashboard-container">
      <!-- Left Content Area -->
      <div class="dashboard-content">
       <section class="jump-back">
  <h2 class="section-heading">Jump back in</h2>

  <div class="continue-card-new"
       role="link"
       tabindex="0"
       onclick='window.location.href="<%= ResolveUrl("~/Base/CourseDashboard.aspx") %>"'
       onkeydown="if(event.key==='Enter'||event.key===' '){event.preventDefault(); this.click();}">
    
    <div class="card-bg-image"></div>

    <div class="card-content-overlay">
      <div class="progress-section">
        <div class="progress-bar-modern">
          <div class="progress-fill-modern" style="width: 35%"></div>
        </div>
        <span class="progress-percent-modern">35%</span>
      </div>

      <div class="course-info-modern">
        <span class="course-badge-modern">COURSE</span>
        <h3 class="course-name-modern">World Geography</h3>
        <p class="next-lesson-modern">Next exercise: Continents and Oceans</p>
      </div>

      <div class="course-actions-modern">
        <a class="btn-continue-modern"
           href="<%= ResolveUrl("~/Base/CourseDashboard.aspx") %>"
           onclick="event.stopPropagation();">Continue Learning</a>

        <a class="link-view-modern"
           href="<%= ResolveUrl("~/Base/CourseDashboard.aspx") %>"
           onclick="event.stopPropagation();">View course</a>
      </div>
    </div>
  </div>
</section>

        <!-- Course Selector Dropdown -->
        <section id="course-selector" class="course-selector-section">
          <div class="course-selector">
            <div class="course-selector-header" onclick="toggleCourseSelector()">
              <h2 class="course-selector-title">My Courses</h2>
              <button type="button" class="course-selector-toggle" id="courseToggle">▼</button>
            </div>
            <div class="courses-dropdown" id="coursesDropdown">
              <asp:Panel ID="pnlCoursesDropdownEmpty" runat="server" Visible="false" CssClass="empty-state">
                <p>You haven't enrolled in any courses yet.</p>
              </asp:Panel>
              <div class="courses-grid">
                <asp:Repeater ID="rptCoursesDropdown" runat="server">
                  <ItemTemplate>
                    <div class="continue-card-new"
                         role="link"
                         tabindex="0"
                         data-course-id="<%# Eval("CourseId") %>"
                         onclick="window.location.href='<%= ResolveUrl("~/Base/CourseDashboard.aspx") %>?courseId=' + this.getAttribute('data-course-id');"
                         onkeydown="if(event.key==='Enter'||event.key===' '){event.preventDefault(); this.click();}">
                      
                      <div class="card-bg-image" <%# Eval("CourseImgUrl") != null && !string.IsNullOrEmpty(Eval("CourseImgUrl").ToString()) ? "style=\"background-image: url('" + Eval("CourseImgUrl").ToString().Replace("'", "\\'") + "');\"" : "" %>></div>

                      <div class="card-content-overlay">
                        <div class="progress-section">
                          <div class="progress-bar-modern">
                            <div class="progress-fill-modern" style="width: <%# Eval("ProgressPercent", "{0:0}") %>%"></div>
                          </div>
                          <span class="progress-percent-modern"><%# Eval("ProgressPercent", "{0:0}%") %></span>
                        </div>

                        <div class="course-info-modern">
                          <span class="course-badge-modern">COURSE</span>
                          <h3 class="course-name-modern"><%# Eval("CourseTitle") %></h3>
                          <p class="next-lesson-modern">Last accessed: <%# Eval("LastAccessedAt", "{0:yyyy-MM-dd HH:mm}") ?? "Never" %></p>
                        </div>

                        <div class="course-actions-modern">
                          <a class="btn-continue-modern"
                             href="<%= ResolveUrl("~/Base/CourseDashboard.aspx") %>?courseId=<%# Eval("CourseId") %>"
                             onclick="event.stopPropagation();">Continue Learning</a>

                          <a class="link-view-modern"
                             href="<%= ResolveUrl("~/Base/CourseDashboard.aspx") %>?courseId=<%# Eval("CourseId") %>"
                             onclick="event.stopPropagation();">View course</a>
                        </div>
                      </div>
                    </div>
                  </ItemTemplate>
                </asp:Repeater>
              </div>
            </div>
          </div>
        </section>

        <!-- Progress Overview Section -->
        <section class="progress-overview">
          <h2 class="section-heading">Progress Overview</h2>
            <div class="progress-stat-card">
              <div class="progress-stat-header">
                <span class="progress-stat-label">Course Completion</span>
                <span class="progress-stat-value">2/5</span>
              </div>
              <div class="course-completion-list">
                <div class="completion-item">
                  <span class="completion-name">World Geography</span>
                  <div class="completion-bar">
                    <div class="completion-fill" style="width: 35%"></div>
                  </div>
                  <span class="completion-percent">35%</span>
                </div>
                <div class="completion-item">
                  <span class="completion-name">Climate & Weather</span>
                  <div class="completion-bar">
                    <div class="completion-fill" style="width: 60%"></div>
                  </div>
                  <span class="completion-percent">60%</span>
                </div>
                <div class="completion-item">
                  <span class="completion-name">Geology</span>
                  <div class="completion-bar">
                    <div class="completion-fill" style="width: 15%"></div>
                  </div>
                  <span class="completion-percent">15%</span>
                </div>
              </div>
            </div>

        </section>

        <!-- Recent Activity Section -->
        <section class="recent-activity">
          <h2 class="section-heading">Recent Activity</h2>
          <div class="activity-list">
            <div class="activity-item">
              <div class="activity-icon completed">✓</div>
              <div class="activity-content">
                <h4 class="activity-title">Completed: Oceans and Seas Quiz</h4>
                <p class="activity-meta">World Geography • 15 XP earned • 2 hours ago</p>
              </div>
              <div class="activity-badge">
                <span class="score-badge success">95%</span>
              </div>
            </div>

            <div class="activity-item">
              <div class="activity-icon unlocked">🏆</div>
              <div class="activity-content">
                <h4 class="activity-title">Achievement Unlocked: Fast Learner</h4>
                <p class="activity-meta">Completed 3 lessons in one day • 3 hours ago</p>
              </div>
            </div>

            <div class="activity-item">
              <div class="activity-icon completed">✓</div>
              <div class="activity-content">
                <h4 class="activity-title">Completed: Mountain Ranges Lesson</h4>
                <p class="activity-meta">Geology & Landforms • 10 XP earned • Yesterday</p>
              </div>
            </div>

            <div class="activity-item">
              <div class="activity-icon time">⏱️</div>
              <div class="activity-content">
                <h4 class="activity-title">Study Session</h4>
                <p class="activity-meta">45 minutes • Climate Zones • 2 days ago</p>
              </div>
            </div>
          </div>
        </section>
      </div>

      <!-- Right Sidebar -->
      <aside class="dashboard-sidebar">
        <!-- Profile Card -->
        <div class="profile-card">
          <div class="profile-avatar">
            <div class="avatar-placeholder">👤</div>
          </div>
          <div class="profile-info">
            <h3 class="profile-name"><%= StudentName %></h3>
            <p class="profile-level">Level 1</p>
          </div>
          <div class="profile-stats">
            <div class="stat-item">
              <span class="stat-icon">⭐</span>
              <div class="stat-details">
                <span class="stat-value">55</span>
                <span class="stat-label">Total XP</span>
              </div>
            </div>
            <div class="stat-item">
              <span class="stat-icon">🥉</span>
              <div class="stat-details">
                <span class="stat-value">Bronze</span>
                <span class="stat-label">Rank</span>
              </div>
            </div>
          </div>
          <button class="btn-view-profile" onclick="window.location.href='<%= ResolveUrl("~/Student/Profile.aspx") %>'">View profile</button>
          <asp:LinkButton ID="btnSidebarLogout" runat="server" OnClick="Logout" CssClass="btn-logout-sidebar" style="margin-top: 0.75rem;">Logout</asp:LinkButton>
        </div>
      </aside>
    </div>
  </main>

<script>
    function toggleCourseSelector() {
        const dropdown = document.getElementById('coursesDropdown');
        const toggle = document.getElementById('courseToggle');
        const open = dropdown.classList.toggle('open');
        toggle.classList.toggle('open', open);
        toggle.setAttribute('aria-expanded', open ? 'true' : 'false');
    }
</script>
</asp:Content>

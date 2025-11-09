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
        <!-- Quick Actions Section -->
        <section class="welcome-section">
          <h2 class="section-heading">Quick Actions</h2>
          <div class="actions-grid">
            <a href="#course-selector" class="action-card" onclick="event.preventDefault(); toggleCourseSelector(); return false;">
              <span class="action-card-icon">🎓</span>
              <div class="action-card-content">
                <h3 class="action-card-title">Enrolled Classes</h3>
              </div>
              <span class="action-card-badge"><asp:Label ID="lblQuickEnrolled" runat="server" Text="0" /></span>
            </a>
            <a href="<%= ResolveUrl("~/Student/Flashcards.aspx") %>" class="action-card">
              <span class="action-card-icon">🃏</span>
              <div class="action-card-content">
                <h3 class="action-card-title">Saved Flashcards</h3>
              </div>
              <span class="action-card-badge"><asp:Label ID="lblQuickFlashcards" runat="server" Text="0" /></span>
            </a>
            <a href="<%= ResolveUrl("~/Student/Notes.aspx") %>" class="action-card">
              <span class="action-card-icon">📝</span>
              <div class="action-card-content">
                <h3 class="action-card-title">My Notes</h3>
              </div>
              <span class="action-card-badge">8</span>
            </a>
            <a href="<%= ResolveUrl("~/Student/Certificates.aspx") %>" class="action-card">
              <span class="action-card-icon">🎓</span>
              <div class="action-card-content">
                <h3 class="action-card-title">Certificates</h3>
              </div>
              <span class="action-card-badge">2</span>
            </a>
          </div>
        </section>

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
          <div class="progress-cards">
            <div class="progress-stat-card">
              <div class="progress-stat-header">
                <span class="progress-stat-label">Learning Time (This Week)</span>
                <span class="progress-stat-value">3.5 hrs</span>
              </div>
              <div class="mini-bar-chart">
                <div class="bar-item" style="height: 40%"><span class="bar-label">M</span></div>
                <div class="bar-item" style="height: 65%"><span class="bar-label">T</span></div>
                <div class="bar-item" style="height: 30%"><span class="bar-label">W</span></div>
                <div class="bar-item" style="height: 80%"><span class="bar-label">T</span></div>
                <div class="bar-item" style="height: 45%"><span class="bar-label">F</span></div>
                <div class="bar-item" style="height: 20%"><span class="bar-label">S</span></div>
                <div class="bar-item active" style="height: 55%"><span class="bar-label">S</span></div>
              </div>
            </div>

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
          </div>

          <!-- Weekly Goal Tracker -->
          <div class="weekly-goal-card">
            <div class="goal-header">
              <h3 class="goal-title">🎯 Weekly Goal</h3>
              <span class="goal-progress">3/5 days completed</span>
            </div>
            <div class="goal-bar-container">
              <div class="goal-bar-fill" style="width: 60%"></div>
            </div>
            <p class="goal-message">Keep it up! Just 2 more days to reach your goal! 🚀</p>
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

        <!-- Explore More Section -->
        <section class="explore-section">
          <h2 class="section-heading">Explore more</h2>
          <div class="explore-grid">
            <a href="<%= ResolveUrl("~/Student/Challenges.aspx") %>" class="explore-card" style="text-decoration: none;">
              <div class="explore-icon">🏆</div>
              <div class="explore-content">
                <h3 class="explore-title">Challenge Packs</h3>
                <p class="explore-desc">Practice what you learned with bite-sized geography challenges.</p>
              </div>
            </a>

            <a href="<%= ResolveUrl("~/Student/Projects.aspx") %>" class="explore-card" style="text-decoration: none;">
              <div class="explore-icon">🚀</div>
              <div class="explore-content">
                <h3 class="explore-title">Project Tutorials</h3>
                <p class="explore-desc">Explore fun, step-by-step projects from beginner to advanced.</p>
              </div>
            </a>

            <a href="<%= ResolveUrl("~/Student/30DaysChallenge.aspx") %>" class="explore-card" style="text-decoration: none;">
              <div class="explore-icon">🥚</div>
              <div class="explore-content">
                <h3 class="explore-title">#30DaysOfLearning</h3>
                <p class="explore-desc">Commit to 30 days of learning and building–while raising a virtual pet!</p>
              </div>
            </a>

            <a href="<%= ResolveUrl("~/Student/PracticeTests.aspx") %>" class="explore-card" style="text-decoration: none;">
              <div class="explore-icon">💻</div>
              <div class="explore-content">
                <h3 class="explore-title">Practice Tests</h3>
                <p class="explore-desc">Test your knowledge with interactive quizzes.</p>
              </div>
            </a>
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
            <div class="stat-item">
              <span class="stat-icon">🎖️</span>
              <div class="stat-details">
                <span class="stat-value">1</span>
                <span class="stat-label">Badges</span>
              </div>
            </div>
            <div class="stat-item">
              <span class="stat-icon">🔥</span>
              <div class="stat-details">
                <span class="stat-value">1</span>
                <span class="stat-label">Day streak</span>
              </div>
            </div>
          </div>
          <button class="btn-view-profile" onclick="window.location.href='<%= ResolveUrl("~/Student/Profile.aspx") %>'">View profile</button>
          <asp:LinkButton ID="btnSidebarLogout" runat="server" OnClick="Logout" CssClass="btn-logout-sidebar" style="margin-top: 0.75rem;">Logout</asp:LinkButton>
        </div>

        <!-- Study Streak Calendar -->
        <div class="streak-calendar-card">
          <h3 class="card-title">Study Streak</h3>
          <div class="streak-info">
            <div class="streak-count">
              <span class="streak-flame">🔥</span>
              <span class="streak-number">7</span>
              <span class="streak-label">day streak!</span>
            </div>
            <p class="streak-message">Keep going! You're on fire! 🎉</p>
          </div>
          <div class="calendar-grid">
            <div class="calendar-day completed" title="Completed">M</div>
            <div class="calendar-day completed" title="Completed">T</div>
            <div class="calendar-day completed" title="Completed">W</div>
            <div class="calendar-day completed" title="Completed">T</div>
            <div class="calendar-day completed" title="Completed">F</div>
            <div class="calendar-day completed" title="Completed">S</div>
            <div class="calendar-day today" title="Today">S</div>
          </div>
          <div class="streak-milestones">
            <div class="milestone reached">
              <span class="milestone-icon">✓</span>
              <span class="milestone-text">3-day streak</span>
            </div>
            <div class="milestone reached">
              <span class="milestone-icon">✓</span>
              <span class="milestone-text">7-day streak</span>
            </div>
            <div class="milestone pending">
              <span class="milestone-icon">○</span>
              <span class="milestone-text">14-day streak</span>
            </div>
          </div>
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

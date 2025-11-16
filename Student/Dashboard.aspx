<%@ Page Language="C#" Title="My Dashboard - Geography Pages" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="WAPP_Assignment.Student.Dashboard" MasterPageFile="~/Site.Master" %>

<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
  <link href="<%= ResolveUrl("~/Content/waplanding.css") %>" rel="stylesheet" />
  <link href="<%= ResolveUrl("~/Content/dashboard.css") %>" rel="stylesheet" />
<style>
    .score-badge.fail {
    background: rgba(255, 204, 102, 0.2); /* amber/yellow */
    color: #ffcc66;
}
</style>
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
<%-- Edit Profile Modal START --%>
<asp:Panel ID="EditProfileModal" runat="server" Visible="false">
<!-- Click outside to close (server-side backdrop) -->
<asp:LinkButton ID="lnkBackdrop1" runat="server" CssClass="backdrop"
    OnClick="hide_edit_profile" CausesValidation="false" />

<div id="loginModalDiv" class="pages-modal" role="dialog" aria-modal="true" aria-labelledby="loginTitle">
  <div class="sheet" id="dashboardSheet">
        <div class="modal-header" id="modal-header">
          <h3 class="modal-title" id="modal-title">Edit Profile</h3>
        </div>

        <!-- Profile Picture Section -->
        <div class="field">
          <label class="label">Profile Picture</label>
          <asp:Panel ID="EditProfileImagePanel" runat="server" Visible="true" CssClass="profile-avatar"></asp:Panel>
          <asp:FileUpload ID="pfp_upload" runat="server"></asp:FileUpload>
        </div>

        <!-- Full Name -->
        <div class="field">
          <label class="label">Full Name</label>
          <asp:TextBox ID="editFullName" runat="server" CssClass="input" MaxLength="100" />
        </div>

        <asp:Label runat="server" ID="edit_profile_error_message"></asp:Label>

        <div class="actions">
          <!-- Cancel close -->
          <asp:LinkButton ID="lnkCancelEdit" runat="server" CssClass="btn cancel"
              OnClick="hide_edit_profile" CausesValidation="false">Cancel</asp:LinkButton>

          <!-- Save -->
          <asp:Button ID="btnLogin" runat="server" CssClass="btn primary" Text="Save"
              OnClick="editProfile" ValidationGroup="Login" />
        </div>
    </div>
</div>
</asp:Panel>
<%-- Edit Profile Modal END --%>

  <main class="dashboard-main">
    <div class="dashboard-container">
      <!-- Left Content Area -->
      <div class="dashboard-content">
       <section class="jump-back">
  <h2 class="section-heading">Jump back in</h2>

  <div class="continue-card-new" tabindex="0">
    
    <div class="card-bg-image"></div>

    <div class="card-content-overlay">
      <div class="progress-section">
        <div class="progress-bar-modern">
          <asp:Panel ID="progress_fill_modern" CssClass="progress-fill-modern" runat="server"></asp:Panel>
        </div>
          <asp:Label ID="progress_percent_modern" CssClass="progress-percent-modern" runat="server"></asp:Label>
      </div>

      <div class="course-info-modern">
        <span class="course-badge-modern">COURSE</span>
          <asp:Label ID="course_name_modern" CssClass="course-name-modern" runat="server"></asp:Label>
        <asp:Label ID="next_lesson_modern" CssClass="next-lesson-modern" runat="server"></asp:Label>
      </div>

      <div class="course-actions-modern">
          <asp:LinkButton ID="btn_continue_modern" CssClass="btn-continue-modern" OnClientClick="event.stopPropagation()" runat="server" OnClick="ContinueCourse" Text="Continue Learning"></asp:LinkButton>
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
                         onclick="window.location.href='<%= ResolveUrl("~/Student/ViewCourse.aspx") %>?courseId=' + this.getAttribute('data-course-id');"
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
                             href="<%= ResolveUrl("~/Student/ViewCourse.aspx") %>?courseId=<%# Eval("CourseId") %>"
                             onclick="event.stopPropagation();">View Course</a>
                        </div>
                      </div>
                    </div>
                  </ItemTemplate>
                </asp:Repeater>
              </div>
            </div>
          </div>
        </section>

        <!-- Recent Activity Section -->
        <section class="recent-activity">
          <h2 class="section-heading">Recent Activity</h2>
        <asp:Panel ID="activityList" runat="server" visble="true"></asp:Panel>
        </section>
      </div>

      <!-- Right Sidebar -->
      <aside class="dashboard-sidebar">
        <!-- Profile Card -->
        <div class="profile-card">
            <asp:Panel ID="pfp_section" CssClass="profile-avatar" runat="server"></asp:Panel>
          <div class="profile-info">
            <asp:Label ID="UsernameLabel" runat="server" CssClass="profile-name"></asp:Label>
            <br>
            <asp:Label ID="FullNameLabel" runat="server" CssClass="profile-level"></asp:Label>
          </div>
          <div class="profile-stats">
            <div class="stat-item">
              <span class="stat-icon">⭐</span>
              <div class="stat-details">
                <asp:Label ID="XPLabel" runat="server" CssClass="stat-value"></asp:Label>
                <span class="stat-label">Total XP</span>
              </div>
            </div>
            <div class="stat-item">
                <asp:Label ID="RankIcon" CssClass="stat-icon" runat="server"></asp:Label>
              <div class="stat-details">
                <asp:Label ID="RankLabel" CssClass="stat-value" runat="server"></asp:Label>
                <span class="stat-label">Rank</span>
              </div>
            </div>
          </div>
            <asp:LinkButton ID="view_results_button" runat="server" OnClick="redirectToViewResults" CssClass="btn-view-profile">View Results</asp:LinkButton>
            <asp:LinkButton ID="edit_profile_button" CssClass="btn-view-profile" OnClick="show_edit_profile" runat="server" style="margin-top: 0.75rem;">Edit Profile</asp:LinkButton>
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

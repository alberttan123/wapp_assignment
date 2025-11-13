<%@ Page Title="Lecturer • Courses" Language="C#"
    MasterPageFile="~/Lecturer/Lecturer.Master"
    AutoEventWireup="true"
    CodeBehind="LecturerCourses.aspx.cs"
    Inherits="WAPP_Assignment.Lecturer.LecturerCourses" %>

<asp:Content ID="HeadBlock" ContentPlaceHolderID="HeadLecturer" runat="server">
  <link rel="stylesheet" href="<%= ResolveUrl("~/Content/LecturerPages.css") %>" />
  <style>
    .lc-headerbar{
      display:flex; align-items:center; justify-content:space-between;
      gap:1rem; margin-bottom:1rem;
    }
    .lc-title{ margin:0; font-size:1.5rem; font-weight:700; color:var(--brand); }
    .lc-actions{ display:flex; align-items:center; gap:.5rem; }
    .lc-filters{ display:grid; grid-template-columns:1fr; gap:1rem; margin:1rem 0; }
    /* make the whole card clickable while keeping Delete clickable */
    .lc-card{ position:relative; cursor:pointer; }
    .lc-card .lc-hit{
      position:absolute; inset:0; z-index:1; /* sits above card body */
    }
    .lc-card .lc-card-body, .lc-card .lc-banner, .lc-card .lc-card-body *{
      position:relative; z-index:2; /* content above the hit-zone so it’s selectable */
    }
    /* keep the delete button above the overlay and stop click bubbling via JS */
    .lc-card .btn{ position:relative; z-index:3; }
  </style>
  <script>
    // prevent card navigation when clicking delete
    function stopCardNav(e){ e.stopPropagation(); }
    // navigate card to its url
    function goTo(url){ window.location.href = url; }
  </script>
</asp:Content>

<asp:Content ID="MainBlock" ContentPlaceHolderID="LecturerMain" runat="server">
  <div class="lc-headerbar">
    <h2 class="lc-title">Courses</h2>
    <div class="lc-actions">
      <a href="<%= ResolveUrl("~/Lecturer/LecturerExamBuilder.aspx") %>" class="btn primary">
        Build an Assessment
      </a>
    </div>
  </div>

  <div class="lc-filters">
    <div class="field">
      <label>Search (Course Title)</label>
      <asp:TextBox ID="txtSearch" runat="server" CssClass="input" AutoPostBack="true"
                   OnTextChanged="TxtSearch_TextChanged" />
    </div>
  </div>

  <asp:Label ID="lblInfo" runat="server" CssClass="muted" Visible="false" />

  <asp:Repeater ID="rptCourses" runat="server" OnItemCommand="RptCourses_ItemCommand">
    <HeaderTemplate><div class="lc-grid"></HeaderTemplate>
    <ItemTemplate>
      <div class="lc-card" onclick="goTo('<%# ResolveUrl("~/Lecturer/LecturerCourseDetails.aspx?courseId=" + Eval("CourseId")) %>')">
        <!-- hit target overlay; we’ll ignore clicks on the Delete button via stopPropagation -->
        <span class="lc-hit" aria-hidden="true"></span>

        <div class="lc-banner">&lt;Banner&gt;</div>
        <div class="lc-card-body">
          <h3><%# Eval("CourseTitle") %></h3>
          <p class="lc-date">Created: <%# Eval("CourseCreatedAt","{0:yyyy-MM-dd}") %></p>
          <p>Total Lessons (from Courses): <%# Eval("TotalLessons") %></p>
          <p>Chapters: <%# Eval("ChapterCount") %></p>
          <p>Quizzes (via ChapterContents): <%# Eval("QuizCount") %></p>
          <div style="display:flex; gap:.5rem; justify-content:flex-end; margin-top:.5rem;">
            <asp:LinkButton ID="btnDelete" runat="server"
                            CssClass="btn"
                            CommandName="delete"
                            CommandArgument='<%# Eval("CourseId") %>'
                            OnClientClick="stopCardNav(event); return confirm('Delete this course? This will remove its enrollments, bookmarks, chapters and their contents.');">
              Delete
            </asp:LinkButton>
          </div>
        </div>
      </div>
    </ItemTemplate>
    <FooterTemplate></div></FooterTemplate>
  </asp:Repeater>
</asp:Content>

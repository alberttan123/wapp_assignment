<%@ Page Title="Lecturer • Course Details" Language="C#"
    MasterPageFile="~/Lecturer/Lecturer.Master"
    AutoEventWireup="true"
    CodeBehind="LecturerCourseDetails.aspx.cs"
    Inherits="WAPP_Assignment.Lecturer.LecturerCourseDetails" %>

<asp:Content ID="HeadBlock" ContentPlaceHolderID="HeadLecturer" runat="server">
  <link rel="stylesheet" href="<%= ResolveUrl("~/Content/LecturerPages.css") %>" />
  <style>
    .cd-header{
      display:flex; align-items:center; justify-content:space-between;
      gap:1rem; margin-bottom:1rem;
    }
    .cd-title{ margin:0; font-size:1.5rem; font-weight:700; color:var(--brand); }
    .cd-meta{ color:var(--muted); margin-bottom:1rem; }
    .cd-section{ background:var(--panel-2); border:1px solid var(--line); border-radius:12px; padding:1rem; margin-bottom:1rem; }
    .cd-chapter{ margin-bottom:1rem; }
    .cd-ch-title{ font-weight:700; margin:0 0 .5rem 0; }
    .cd-contents{ display:flex; flex-direction:column; gap:.5rem; }
    .cd-item{ padding:.5rem; background:var(--panel); border:1px solid var(--line); border-radius:10px; display:flex; justify-content:space-between; align-items:center; }
    .cd-item .left{ display:flex; gap:.5rem; align-items:center; }
    .badge{ font-size:.75rem; padding:.1rem .4rem; border:1px solid var(--line); border-radius:999px; color:var(--muted); }
  </style>
</asp:Content>

<asp:Content ID="MainBlock" ContentPlaceHolderID="LecturerMain" runat="server">
  <div class="cd-header">
    <h2 class="cd-title"><asp:Literal ID="litCourseTitle" runat="server" /></h2>
    <div class="cd-actions">
      <a href="<%= ResolveUrl("~/Lecturer/LecturerCourses.aspx") %>" class="btn">Back to Courses</a>
    </div>
  </div>

  <div class="cd-meta">
    <asp:Literal ID="litCourseMeta" runat="server" />
  </div>

  <div class="cd-section">
    <h3 style="margin:0 0 .5rem 0;">Description</h3>
    <div class="muted"><asp:Literal ID="litCourseDesc" runat="server" /></div>
  </div>

  <asp:Repeater ID="rptChapters" runat="server" OnItemDataBound="RptChapters_ItemDataBound">
    <ItemTemplate>
      <div class="cd-section cd-chapter">
        <h4 class="cd-ch-title">Chapter <%# Eval("ChapterOrder") %>: <%# Eval("ChapterTitle") %></h4>
        <asp:Repeater ID="rptContents" runat="server">
          <HeaderTemplate><div class="cd-contents"></HeaderTemplate>
          <ItemTemplate>
            <div class="cd-item">
              <div class="left">
                <span class="badge"><%# Eval("ContentType") %></span>
                <span><%# Eval("ContentTitle") %></span>
              </div>
              <asp:Literal ID="litRightMeta" runat="server" />
            </div>
          </ItemTemplate>
          <FooterTemplate></div></FooterTemplate>
        </asp:Repeater>
      </div>
    </ItemTemplate>
  </asp:Repeater>

  <asp:Label ID="lblInfo" runat="server" CssClass="muted" Visible="false" />
</asp:Content>

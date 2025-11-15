<%@ Page Title="Lecturer • Course Details" Language="C#"
    MasterPageFile="~/Lecturer/Lecturer.Master"
    AutoEventWireup="true"
    CodeBehind="LecturerCourseDetails.aspx.cs"
    Inherits="WAPP_Assignment.Lecturer.LecturerCourseDetails" %>

<asp:Content ID="HeadBlock" ContentPlaceHolderID="HeadLecturer" runat="server">
  <link rel="stylesheet" href="<%= ResolveUrl("~/Content/LecturerPages.css") %>" />
  <style>
    @import url('https://fonts.googleapis.com/css2?family=Press+Start+2P&display=swap');
    
    .cd-header {
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 1.5rem;
      margin-bottom: 2rem;
      flex-wrap: wrap;
    }

    .cd-actions {
      display: flex;
      gap: 1rem;
      align-items: center;
      flex-wrap: wrap;
    }

    .cd-title {
      margin: 0;
      font-size: 1.2rem;
      font-weight: 400;
      color: #ffd24a;
      font-family: 'Press Start 2P', monospace;
      text-transform: uppercase;
      letter-spacing: 0.05em;
      text-shadow: 3px 3px 0 rgba(0, 0, 0, 0.5);
      line-height: 1.5;
    }

    .cd-actions .btn {
      padding: 0.9rem 1.5rem;
      font-weight: 900;
      font-family: 'Press Start 2P', monospace;
      font-size: 0.65rem;
      cursor: pointer;
      transition: all 0.2s ease;
      text-transform: uppercase;
      letter-spacing: 0.08em;
      border-radius: 0;
      border: 2px solid #23304a;
      background: rgba(15, 20, 34, 0.8);
      color: #e8eefc;
      text-decoration: none;
      box-shadow: 3px 3px 0 rgba(27, 37, 58, 0.8);
      display: inline-block;
      white-space: nowrap;
    }

    .cd-actions .btn:hover {
      background: rgba(15, 20, 34, 0.95);
      border-color: #ffd24a;
      color: #ffd24a;
      transform: translate(2px, 2px);
      box-shadow: 1px 1px 0 rgba(27, 37, 58, 0.8);
    }

    .cd-actions .btn:active {
      transform: translate(3px, 3px);
      box-shadow: 0 0 0 rgba(27, 37, 58, 0.8);
    }

    .cd-meta {
      color: #9fb0d1;
      margin-bottom: 1.5rem;
      font-family: 'Press Start 2P', monospace;
      font-size: 0.65rem;
      text-transform: uppercase;
      letter-spacing: 0.03em;
    }

    .cd-section {
      background: #121a2a;
      border: 2px solid #23304a;
      border-radius: 0;
      padding: 1.5rem;
      margin-bottom: 1.5rem;
      box-shadow: 0 8px 0 rgba(27, 37, 58, 0.8), 0 12px 24px rgba(0, 0, 0, 0.3);
    }

    .cd-section h3 {
      margin: 0 0 1rem 0;
      font-size: 0.8rem;
      font-weight: 400;
      color: #ffd24a;
      font-family: 'Press Start 2P', monospace;
      text-transform: uppercase;
      letter-spacing: 0.03em;
    }

    .cd-section .muted {
      color: #9fb0d1;
      font-family: Poppins, system-ui, Segoe UI, Arial, sans-serif;
      font-size: 0.95rem;
      line-height: 1.6;
    }

    .cd-chapter {
      margin-bottom: 1.5rem;
    }

    .cd-chapter:last-child {
      margin-bottom: 0;
    }

    .cd-ch-title {
      font-weight: 400;
      margin: 0 0 1rem 0;
      font-size: 0.75rem;
      color: #e8eefc;
      font-family: 'Press Start 2P', monospace;
      text-transform: uppercase;
      letter-spacing: 0.03em;
      line-height: 1.5;
    }

    .cd-contents {
      display: flex;
      flex-direction: column;
      gap: 0.75rem;
    }

    .cd-item {
      padding: 1rem 1.25rem;
      background: rgba(15, 20, 34, 0.8);
      border: 2px solid #23304a;
      border-radius: 0;
      display: flex;
      justify-content: space-between;
      align-items: center;
      transition: all 0.2s ease;
      box-shadow: inset 0 3px 0 rgba(0, 0, 0, 0.3);
    }

    .cd-item:hover {
      border-color: #ffd24a;
      background: rgba(15, 20, 34, 0.95);
      box-shadow: inset 0 3px 0 rgba(0, 0, 0, 0.3), 0 0 20px rgba(255, 210, 74, 0.2);
    }

    .cd-item .left {
      display: flex;
      gap: 1rem;
      align-items: center;
      flex: 1;
    }

    .cd-item .left span:not(.badge) {
      color: #e8eefc;
      font-family: Poppins, system-ui, Segoe UI, Arial, sans-serif;
      font-size: 0.95rem;
      font-weight: 600;
    }

    .badge {
      font-size: 0.6rem;
      padding: 0.4rem 0.75rem;
      border: 2px solid #23304a;
      border-radius: 0;
      color: #9fb0d1;
      text-transform: uppercase;
      font-family: 'Press Start 2P', monospace;
      letter-spacing: 0.03em;
      background: rgba(15, 20, 34, 0.6);
      box-shadow: inset 0 2px 0 rgba(0, 0, 0, 0.3);
      white-space: nowrap;
    }

    .cd-item .right {
      color: #9fb0d1;
      font-family: 'Press Start 2P', monospace;
      font-size: 0.6rem;
      text-transform: uppercase;
      letter-spacing: 0.03em;
    }

    @media (max-width: 768px) {
      .cd-header {
        flex-direction: column;
        align-items: flex-start;
      }

      .cd-actions {
        width: 100%;
        flex-direction: column;
      }

      .cd-actions .btn {
        width: 100%;
        text-align: center;
      }

      .cd-item {
        flex-direction: column;
        align-items: flex-start;
        gap: 0.75rem;
      }

      .cd-item .left {
        width: 100%;
        flex-direction: column;
        align-items: flex-start;
        gap: 0.5rem;
      }
    }
  </style>
</asp:Content>

<asp:Content ID="MainBlock" ContentPlaceHolderID="LecturerMain" runat="server">
  <div class="cd-header">
    <h2 class="cd-title">
      <asp:Literal ID="litCourseTitle" runat="server" />
    </h2>
    <div class="cd-actions">
      <a href="<%= ResolveUrl("~/Lecturer/LecturerCourses.aspx") %>" class="btn">
        Back to Courses
      </a>
      <asp:HyperLink ID="lnkEditCourse" runat="server" CssClass="btn">
        Edit this Course
      </asp:HyperLink>
    </div>
  </div>

  <div class="cd-meta">
    <asp:Literal ID="litCourseMeta" runat="server" />
  </div>

  <div class="cd-section">
    <h3 style="margin:0 0 .5rem 0;">Description</h3>
    <div class="muted">
      <asp:Literal ID="litCourseDesc" runat="server" />
    </div>
  </div>

  <asp:Repeater ID="rptChapters" runat="server" OnItemDataBound="RptChapters_ItemDataBound">
    <ItemTemplate>
      <div class="cd-section cd-chapter">
        <h4 class="cd-ch-title">
          Chapter <%# Eval("ChapterOrder") %>: <%# Eval("ChapterTitle") %>
        </h4>

        <asp:Repeater ID="rptContents" runat="server"
                      OnItemDataBound="RptContents_ItemDataBound">
          <HeaderTemplate>
            <div class="cd-contents">
          </HeaderTemplate>
          <ItemTemplate>
            <div class="cd-item">
              <div class="left">
                <span class="badge"><%# Eval("ContentType") %></span>
                <span><%# Eval("ContentTitle") %></span>
              </div>
              <asp:Literal ID="litRightMeta" runat="server" />
            </div>
          </ItemTemplate>
          <FooterTemplate>
            </div>
          </FooterTemplate>
        </asp:Repeater>
      </div>
    </ItemTemplate>
  </asp:Repeater>

  <asp:Label ID="lblInfo" runat="server" CssClass="muted" Visible="false" />
</asp:Content>

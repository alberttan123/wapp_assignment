<%@ Page Title="Lecturer • Course Builder" Language="C#"
    MasterPageFile="~/Lecturer/Lecturer.Master"
    AutoEventWireup="true"
    CodeBehind="LecturerCourseBuilder.aspx.cs"
    Inherits="WAPP_Assignment.Lecturer.LecturerCourseBuilder" %>

<asp:Content ID="HeadBlock" ContentPlaceHolderID="HeadLecturer" runat="server">
  <link rel="stylesheet" href="<%= ResolveUrl("~/Content/LecturerPages.css") %>" />
  <style>
    .cb-shell{
      max-width: 1000px;
      margin: 0 auto;
      display: flex;
      flex-direction: column;
      gap: 1rem;
    }
    .cb-top{
      display: flex;
      justify-content: space-between;
      align-items: center;
    }
    .cb-title{
      font-size: 1.5rem;
      font-weight: 600;
      color: var(--text);
    }
    .cb-card{
      background: var(--panel-2);
      border: 1px solid var(--line);
      border-radius: 12px;
      padding: 1rem;
    }
    .cb-card-header{
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 0.75rem;
    }
    .cb-card-title{
      font-size: 1rem;
      font-weight: 600;
      color: var(--text);
    }
    .field{
      display: flex;
      flex-direction: column;
      gap: 0.25rem;
      margin-bottom: 0.75rem;
    }
    .field label{
      font-size: 0.9rem;
      color: var(--muted);
    }
    .cb-actions-row{
      display: flex;
      justify-content: flex-end;
      gap: 0.5rem;
      margin-top: 0.5rem;
    }
    .hint{
      font-size: 0.85rem;
      color: var(--muted);
    }
    .cb-course-img-preview{
      margin-top: 0.5rem;
      max-width: 100%;
      border-radius: 8px;
      border: 1px solid var(--line);
    }
  </style>
</asp:Content>

<asp:Content ID="MainBlock" ContentPlaceHolderID="LecturerMain" runat="server">
  <div class="cb-shell">
    <div class="cb-top">
      <div class="cb-title">Course Builder</div>
      <a href="<%= ResolveUrl("~/Lecturer/LecturerCourses.aspx") %>" class="btn">Back to Courses</a>
    </div>

    <asp:Label ID="lblStatus" runat="server" CssClass="muted" Visible="false" />

    <div class="cb-card">
      <div class="cb-card-header">
        <div class="cb-card-title">Course details</div>
        <asp:Button ID="btnNewCourse" runat="server" CssClass="btn" Text="New Course"
                    OnClick="BtnNewCourse_Click" CausesValidation="false" />
      </div>

      <div class="field">
        <label>Select existing course</label>
        <asp:DropDownList ID="ddlCourses" runat="server" CssClass="select"
                          AutoPostBack="true" OnSelectedIndexChanged="DdlCourses_SelectedIndexChanged" />
      </div>

      <asp:HiddenField ID="hfCourseId" runat="server" />
      <asp:HiddenField ID="hfCurrentCourseImgUrl" runat="server" />

      <div class="field">
        <label>Course title</label>
        <asp:TextBox ID="txtCourseTitle" runat="server" CssClass="input" />
      </div>

      <div class="field">
        <label>Course description</label>
        <asp:TextBox ID="txtCourseDescription" runat="server" CssClass="input"
                     TextMode="MultiLine" Rows="4" />
      </div>

      <div class="field">
        <label>Course image (optional)</label>
        <asp:FileUpload ID="fuCourseImg" runat="server" />
        <asp:CheckBox ID="chkRemoveImg" runat="server" Text="Remove current image" />
        <span class="hint">
          Upload a thumbnail/banner for this course. If you tick "Remove current image",
          the course will fall back to the default banner.
        </span>
        <asp:Image ID="imgPreview" runat="server" Visible="false" CssClass="cb-course-img-preview" />
      </div>

      <div class="cb-actions-row">
        <asp:Button ID="btnDeleteCourse" runat="server" CssClass="btn" Text="Delete"
                    OnClick="BtnDeleteCourse_Click"
                    OnClientClick="return confirm('Delete this course and all its chapters? This cannot be undone.');"
                    CausesValidation="false" />
        <asp:Button ID="btnSaveCourse" runat="server" CssClass="btn primary" Text="Save Course"
                    OnClick="BtnSaveCourse_Click" />
      </div>
    </div>
  </div>
</asp:Content>

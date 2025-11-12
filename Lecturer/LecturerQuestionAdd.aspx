<%@ Page Title="Lecturer • Add Question" Language="C#"
    MasterPageFile="~/Lecturer/Lecturer.Master"
    AutoEventWireup="true"
    CodeBehind="LecturerQuestionAdd.aspx.cs"
    Inherits="WAPP_Assignment.Lecturer.LecturerQuestionAdd" %>

<asp:Content ID="HeadBlock" ContentPlaceHolderID="HeadLecturer" runat="server">
  <link rel="stylesheet" href="<%= ResolveUrl("~/Content/LecturerPages.css") %>" />
  <style>
    .qa-wrap{ max-width:900px; margin:0 auto; background:var(--panel-2); border:1px solid var(--line);
              border-radius:12px; padding:1rem; }
    .field{ display:flex; flex-direction:column; gap:.25rem; margin-bottom:.75rem; }
    .grid2{ display:grid; grid-template-columns:1fr 1fr; gap:.5rem; }
    .hint{ color:var(--muted); font-size:.875rem; }
  </style>
</asp:Content>

<asp:Content ID="MainBlock" ContentPlaceHolderID="LecturerMain" runat="server">
  <div class="qa-wrap">
    <h2 class="page-title">Add Question</h2>

    <asp:Label ID="lblMsg" runat="server" CssClass="muted" Visible="false" />

    <div class="field">
      <label>Question Text</label>
      <asp:TextBox ID="txtQ" runat="server" CssClass="input" TextMode="MultiLine" Rows="3" />
    </div>

    <div class="field">
      <label>Question Image (optional)</label>
      <asp:FileUpload ID="fuImg" runat="server" />
      <div class="hint">PNG/JPG/GIF — will be saved under <code>/Uploads/Questions/</code>.</div>
    </div>

    <div class="grid2">
      <div class="field"><label>Option 1</label><asp:TextBox ID="txtO1" runat="server" CssClass="input" /></div>
      <div class="field"><label>Option 2</label><asp:TextBox ID="txtO2" runat="server" CssClass="input" /></div>
      <div class="field"><label>Option 3 (optional)</label><asp:TextBox ID="txtO3" runat="server" CssClass="input" /></div>
      <div class="field"><label>Option 4 (optional)</label><asp:TextBox ID="txtO4" runat="server" CssClass="input" /></div>
    </div>

    <div class="field">
      <label>Correct Answer (1–4)</label>
      <asp:DropDownList ID="ddlAns" runat="server" CssClass="select">
        <asp:ListItem Text="1" Value="1" /><asp:ListItem Text="2" Value="2" />
        <asp:ListItem Text="3" Value="3" /><asp:ListItem Text="4" Value="4" />
      </asp:DropDownList>
    </div>

    <div style="display:flex; gap:.5rem; justify-content:flex-end;">
      <asp:Button ID="btnSave" runat="server" CssClass="btn primary" Text="Save Question" OnClick="BtnSave_Click" />
      <a href="<%= ResolveUrl("~/Lecturer/LecturerQuestionViewer.aspx") %>" class="btn">View / Edit Questions</a>
    </div>
  </div>
</asp:Content>

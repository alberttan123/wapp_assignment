<%@ Page Title="Lecturer • Assessments" Language="C#"
    MasterPageFile="~/Lecturer/Lecturer.Master"
    AutoEventWireup="true"
    CodeBehind="LecturerAssessments.aspx.cs"
    Inherits="WAPP_Assignment.Lecturer.LecturerAssessments" %>

<asp:Content ID="HeadBlock" ContentPlaceHolderID="HeadLecturer" runat="server">
  <link rel="stylesheet" href="<%= ResolveUrl("~/Content/LecturerPages.css") %>" />
  <style>
    /* Scoped tweaks for this page only */
    .asmt-header{
      display:flex; align-items:center; justify-content:space-between;
      gap:1rem; margin-bottom:1rem;
    }
    .asmt-title{ margin:0; font-size:1.5rem; font-weight:700; color:var(--brand); }
    .asmt-actions{ display:flex; align-items:center; gap:.5rem; }
    .asmt-grid .card h3{ margin:0 0 .25rem; font-size:1.125rem; color:var(--text); }
    .asmt-grid .card .meta{ color:var(--muted); font-size:.9rem; }
    .asmt-filters{ display:grid; grid-template-columns: 1fr; gap:1rem; margin:1rem 0; }
  </style>
</asp:Content>

<asp:Content ID="MainBlock" ContentPlaceHolderID="LecturerMain" runat="server">
  <div class="asmt-header">
    <h2 class="asmt-title">Assessments</h2>
    <div class="asmt-actions">
      <a href="<%= ResolveUrl("~/Lecturer/LecturerExamBuilder.aspx") %>" class="btn primary">
        Build an Assessment
      </a>
    </div>
  </div>

  <div class="asmt-filters">
    <div class="field">
      <label>Search (Title)</label>
      <asp:TextBox ID="txtSearch" runat="server" CssClass="input" AutoPostBack="true"
                   OnTextChanged="TxtSearch_TextChanged" />
    </div>
  </div>

  <asp:Label ID="lblInfo" runat="server" CssClass="muted" Visible="false" />

  <asp:Repeater ID="rptAssessments" runat="server" OnItemCommand="RptAssessments_ItemCommand">
    <HeaderTemplate><div class="grid asmt-grid" style="grid-template-columns:repeat(2,minmax(0,1fr));"></HeaderTemplate>
    <ItemTemplate>
      <div class="card">
        <div class="meta">Assessment #<%# Eval("QuizId") %></div>
        <h3><%# Eval("QuizTitle") %></h3>
        <div class="meta">Questions: <%# Eval("QuestionCount") %></div>
        <div class="meta">Type: <%# Eval("QuizType") %></div>
        <div class="actions">
          <asp:LinkButton ID="btnDelete" runat="server"
                          CssClass="btn"
                          CommandName="delete"
                          CommandArgument='<%# Eval("QuizId") %>'
                          OnClientClick="return confirm('Delete this assessment? This will remove its question links.');">
            Delete
          </asp:LinkButton>
        </div>
      </div>
    </ItemTemplate>
    <FooterTemplate></div></FooterTemplate>
  </asp:Repeater>
</asp:Content>

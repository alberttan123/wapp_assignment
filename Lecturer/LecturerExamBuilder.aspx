<%@ Page Title="Lecturer • Exam Builder" Language="C#"
    MasterPageFile="~/Lecturer/Lecturer.Master"
    AutoEventWireup="true"
    CodeBehind="LecturerExamBuilder.aspx.cs"
    Inherits="WAPP_Assignment.Lecturer.LecturerExamBuilder" %>

<asp:Content ID="HeadBlock" ContentPlaceHolderID="HeadLecturer" runat="server">
  <!-- Ensure lecturer CSS is loaded (ok to keep even if bundled) -->
  <link rel="stylesheet" href="<%= ResolveUrl("~/Content/LecturerPages.css") %>" />
  <style>
    /* Scoped to the Exam Builder only */

    /* 1 quiz per row */
    .eb-onecol .grid { grid-template-columns: 1fr; }

    /* inline questions */
    .eb-q-list { display:flex; flex-direction:column; gap:.5rem; margin-top:.75rem; }
    .eb-q-item {
      padding:.5rem;
      border:1px solid var(--line);
      border-radius:10px;
      background:var(--panel);
      color:var(--text);
      display:flex;
      align-items:center;
      justify-content:space-between;
      gap:.75rem;
    }
    .eb-q-text { flex:1; }
    .eb-toggle { margin-right:.5rem; }

    /* Filters: search left, quiz filter on the right */
    .eb-filters { grid-template-columns: 1fr auto; }
    .eb-filters .field.right { justify-self: end; }

    .eb-header {
      display:flex; align-items:center; justify-content:center;
      margin-bottom:1rem;
    }
    .eb-title { margin:0; text-align:center; }
  </style>
</asp:Content>

<asp:Content ID="MainBlock" ContentPlaceHolderID="LecturerMain" runat="server">

  <div class="eb-header">
    <h2 class="eb-title">Assessment Builder</h2>
  </div>

    <!-- top-right action -->
    <div class="eb-top-actions">
      <a href="<%= ResolveUrl("~/Lecturer/LecturerAssessments.aspx") %>" class="btn primary">
        Show Assessments
      </a>
    </div>

  <div class="eb-filters">
    <div class="field">
      <label>Search (Quiz Title)</label>
      <asp:TextBox ID="txtSearch" runat="server" CssClass="input" AutoPostBack="true" OnTextChanged="TxtSearch_TextChanged" />
    </div>

    <div class="field right">
      <label>Filter Quiz</label>
      <asp:DropDownList ID="ddlQuiz" runat="server" CssClass="select" AutoPostBack="true" OnSelectedIndexChanged="DdlQuiz_SelectedIndexChanged" />
    </div>
  </div>

  <!-- one quiz per row -->
  <div class="eb-onecol">
    <asp:Repeater ID="rptTopics" runat="server"
                  OnItemCommand="RptTopics_ItemCommand"
                  OnItemDataBound="RptTopics_ItemDataBound">
      <HeaderTemplate><div class="grid"></HeaderTemplate>
      <ItemTemplate>
        <div class="card">
          <div class="meta">Quiz #<%# Eval("QuizId") %></div>
          <h3 style="margin:0;font-size:1.125rem;"><%# Eval("QuizTitle") %></h3>
          <div class="meta">Questions: <%# Eval("QuestionCount") %></div>
          <div class="actions">
            <asp:LinkButton ID="btnToggle" runat="server"
                            CssClass="btn eb-toggle"
                            CommandName="toggle"
                            CommandArgument='<%# Eval("QuizId") %>'>
              Show Questions
            </asp:LinkButton>
            <asp:LinkButton ID="btnAddTopic" runat="server"
                            CommandName="addall"
                            CommandArgument='<%# Eval("QuizId") %>'
                            CssClass="icon-btn">＋ Add All</asp:LinkButton>
          </div>

          <!-- inline questions (collapsed by default; controlled in code-behind) -->
          <asp:Panel ID="pnlQuestions" runat="server" Visible="false">
            <asp:Repeater ID="rptQuestions" runat="server" OnItemCommand="RptQuestions_ItemCommand">
              <HeaderTemplate><div class="eb-q-list"></HeaderTemplate>
              <ItemTemplate>
                <div class="eb-q-item">
                  <div class="eb-q-text"><%# Eval("Question") %></div>
                  <asp:LinkButton ID="btnAddOne" runat="server"
                                  CssClass="icon-btn"
                                  CommandName="addone"
                                  CommandArgument='<%# Eval("QuestionId") %>'>
                    Add
                  </asp:LinkButton>
                </div>
              </ItemTemplate>
              <FooterTemplate></div></FooterTemplate>
            </asp:Repeater>
          </asp:Panel>
        </div>
      </ItemTemplate>
      <FooterTemplate></div></FooterTemplate>
    </asp:Repeater>
  </div>

  <div class="cart">
    <div class="cart-title">Exam cart</div>
    <asp:Repeater ID="rptCart" runat="server" OnItemCommand="RptCart_ItemCommand">
      <HeaderTemplate><div class="cart-list"></HeaderTemplate>
      <ItemTemplate>
        <div class="cart-item">
          <div class="q"><%# Eval("Question") %></div>
          <asp:LinkButton ID="btnRemove" runat="server" CommandName="remove" CommandArgument='<%# Eval("QuestionId") %>' CssClass="icon-btn">Remove</asp:LinkButton>
        </div>
      </ItemTemplate>
      <FooterTemplate></div></FooterTemplate>
    </asp:Repeater>

    <div class="form-row">
      <asp:TextBox ID="txtExamTitle" runat="server" CssClass="input" placeholder="Exam title (saved as a new Quiz)" />
      <asp:TextBox ID="txtDuration" runat="server" CssClass="input" placeholder="Duration (minutes; UI only)" />
      <asp:TextBox ID="txtTotal" runat="server" CssClass="input" ReadOnly="true" placeholder="Total Questions" />
    </div>
    <asp:Label ID="lblError" runat="server" CssClass="error" Visible="false"></asp:Label>
    <div style="display:flex;gap:0.5rem;justify-content:flex-end;">
      <asp:Button ID="btnSaveExam" runat="server" CssClass="btn primary" Text="Save Assessment" OnClick="BtnSaveExam_Click" />
    </div>
  </div>
</asp:Content>

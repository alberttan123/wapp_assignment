<%@ Page Title="Lecturer • Exam Builder" Language="C#"
    MasterPageFile="~/Lecturer/Lecturer.Master"
    AutoEventWireup="true"
    CodeBehind="LecturerExamBuilder.aspx.cs"
    Inherits="WAPP_Assignment.Lecturer.LecturerExamBuilder" %>

<asp:Content ID="HeadBlock" ContentPlaceHolderID="HeadLecturer" runat="server">
    <!-- page-level head if needed -->
</asp:Content>

<asp:Content ID="MainBlock" ContentPlaceHolderID="LecturerMain" runat="server">
  <!-- Header -->
  <div class="eb-header">
    <h2 class="eb-title">Assessment Builder</h2>
    <div class="eb-actions">
      <a href="<%= ResolveUrl("~/Lecturer/LecturerAssessments.aspx") %>" class="btn primary">
        Show Assessments
      </a>
    </div>
  </div>

  <!-- Filters -->
  <div class="eb-filters">
    <div class="field">
      <label>Search (quiz title or question)</label>
      <asp:TextBox ID="txtSearch" runat="server" CssClass="input"
                   AutoPostBack="true"
                   OnTextChanged="TxtSearch_TextChanged" />
    </div>
    <div class="field" style="margin-left:auto;">
      <label>Exercise filter</label>
      <asp:DropDownList ID="ddlQuiz" runat="server" CssClass="select"
                        AutoPostBack="true"
                        OnSelectedIndexChanged="DdlQuiz_SelectedIndexChanged" />
    </div>
  </div>

  <!-- Exam cart dropdown (between filters and quizzes) -->
  <div class="eb-cart-wrapper">
    <asp:LinkButton ID="btnCartToggle" runat="server"
                    CssClass="btn"
                    OnClick="BtnCartToggle_Click"
                    CausesValidation="false">
      <!-- text set in code-behind -->
    </asp:LinkButton>

    <asp:Panel ID="pnlCart" runat="server" CssClass="cart" Visible="false">
      <div class="cart-title">Exam cart</div>
      <asp:Repeater ID="rptCart" runat="server" OnItemCommand="RptCart_ItemCommand">
        <HeaderTemplate>
          <div class="cart-list">
        </HeaderTemplate>
        <ItemTemplate>
          <div class="cart-item">
            <div class="q"><%# Eval("Question") %></div>
            <asp:LinkButton ID="btnRemove" runat="server"
                            CommandName="remove"
                            CommandArgument='<%# Eval("QuestionId") %>'
                            CssClass="icon-btn">
              Remove
            </asp:LinkButton>
          </div>
        </ItemTemplate>
        <FooterTemplate>
          </div>
        </FooterTemplate>
      </asp:Repeater>

      <div class="form-row">
        <asp:TextBox ID="txtExamTitle" runat="server" CssClass="input"
                     placeholder="Assessment title" />
        <asp:TextBox ID="txtDuration" runat="server" CssClass="input"
                     placeholder="Duration (minutes; optional)" />
        <asp:TextBox ID="txtTotal" runat="server" CssClass="input"
                     ReadOnly="true"
                     placeholder="Total Questions" />
      </div>
      <asp:Label ID="lblError" runat="server" CssClass="error" Visible="false"></asp:Label>
      <div style="display:flex;gap:0.5rem;justify-content:flex-end;">
        <asp:Button ID="btnSaveExam" runat="server" CssClass="btn primary"
                    Text="Save Assessment" OnClick="BtnSaveExam_Click" />
      </div>
    </asp:Panel>
  </div>

  <!-- Quizzes list (vertical; clicking card also toggles questions) -->
  <asp:Repeater ID="rptTopics" runat="server"
                OnItemCommand="RptTopics_ItemCommand"
                OnItemDataBound="RptTopics_ItemDataBound">
    <ItemTemplate>
      <div class="eb-topic-block">
        <!-- card: clicking anywhere on this block triggers toggle -->
        <div class="eb-topic-card"
             onclick="document.getElementById('<%# ((System.Web.UI.WebControls.LinkButton)Container.FindControl("btnToggle")).ClientID %>').click();">
          <div class="meta">Quiz #<%# Eval("QuizId") %></div>
          <h3 class="eb-topic-title"><%# Eval("QuizTitle") %></h3>
          <div class="meta">
            Questions: <%# Eval("QuestionCount") %>
          </div>
        </div>

        <div class="eb-topic-actions">
          <!-- Keep explicit Show/Hide button -->
          <asp:LinkButton ID="btnToggle" runat="server"
                          CssClass="btn"
                          CommandName="toggle"
                          CommandArgument='<%# Eval("QuizId") %>'>
            Show Questions
          </asp:LinkButton>

          <!-- Add all questions from this quiz -->
          <asp:LinkButton ID="btnAddAll" runat="server"
                          CssClass="btn"
                          CommandName="addall"
                          CommandArgument='<%# Eval("QuizId") %>'>
            Add All Questions
          </asp:LinkButton>
        </div>

        <!-- Inline questions for this quiz -->
        <asp:Panel ID="pnlQuestions" runat="server" CssClass="eb-questions" Visible="false">
          <asp:Repeater ID="rptQuestions" runat="server"
                        OnItemCommand="RptQuestions_ItemCommand">
            <ItemTemplate>
              <div class="eb-question-row">
                <span class="eb-question-text"><%# Eval("Question") %></span>
                <asp:LinkButton ID="btnAddOne" runat="server"
                                CssClass="icon-btn"
                                CommandName="addone"
                                CommandArgument='<%# Eval("QuestionId") %>'>
                  Add
                </asp:LinkButton>
              </div>
            </ItemTemplate>
          </asp:Repeater>
        </asp:Panel>
      </div>
    </ItemTemplate>
  </asp:Repeater>
</asp:Content>

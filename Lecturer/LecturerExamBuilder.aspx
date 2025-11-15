<%@ Page Title="Lecturer • Exam Builder" Language="C#"
    MasterPageFile="~/Lecturer/Lecturer.Master"
    AutoEventWireup="true"
    CodeBehind="LecturerExamBuilder.aspx.cs"
    Inherits="WAPP_Assignment.Lecturer.LecturerExamBuilder" %>

<asp:Content ID="HeadBlock" ContentPlaceHolderID="HeadLecturer" runat="server">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Press+Start+2P&display=swap');
        
        .eb-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
            gap: 1.5rem;
            flex-wrap: wrap;
        }

        .eb-title {
            margin: 0;
            font-size: 1.2rem;
            font-weight: 400;
            color: #ffd24a;
            font-family: 'Press Start 2P', monospace;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            text-shadow: 3px 3px 0 rgba(0, 0, 0, 0.5);
        }

        .eb-actions .btn {
            padding: 0.9rem 2rem;
            font-weight: 900;
            font-family: 'Press Start 2P', monospace;
            font-size: 0.7rem;
            cursor: pointer;
            transition: all 0.2s ease;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            border-radius: 0;
            border: 2px solid #ffd24a;
            background: #ffd24a;
            color: #0b0f1a;
            text-decoration: none;
            box-shadow: 4px 4px 0 #b89200;
            display: inline-block;
            white-space: nowrap;
        }

        .eb-actions .btn:hover {
            background: #ffdc6a;
            transform: translate(2px, 2px);
            box-shadow: 2px 2px 0 #b89200;
        }

        .eb-actions .btn:active {
            transform: translate(4px, 4px);
            box-shadow: 0 0 0 #b89200;
        }

        .eb-filters {
            display: flex;
            align-items: flex-end;
            gap: 1.5rem;
            margin-bottom: 1.5rem;
            flex-wrap: wrap;
        }

        .eb-filters .field {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }

        .eb-filters .field label {
            font-size: 0.65rem;
            color: #9fb0d1;
            font-family: 'Press Start 2P', monospace;
            text-transform: uppercase;
            letter-spacing: 0.03em;
        }

        .eb-filters .field .input,
        .eb-filters .field input[type="text"] {
            padding: 1rem 1.25rem;
            background: rgba(15, 20, 34, 0.8);
            border: 2px solid #23304a;
            border-radius: 0;
            color: #e8eefc;
            font-family: Poppins, system-ui, Segoe UI, Arial, sans-serif;
            font-size: 1rem;
            font-weight: 600;
            transition: all 0.2s ease;
            box-shadow: inset 0 3px 0 rgba(0, 0, 0, 0.3), 0 2px 0 rgba(27, 37, 58, 0.5);
            box-sizing: border-box;
            width: 100%;
            min-width: 250px;
        }

        .eb-filters .field .input:focus,
        .eb-filters .field input[type="text"]:focus {
            outline: none;
            background: rgba(15, 20, 34, 0.95);
            border-color: #ffd24a;
            box-shadow: inset 0 3px 0 rgba(0, 0, 0, 0.3), 0 0 25px rgba(255, 210, 74, 0.25);
        }

        .eb-filters .field .select,
        .eb-filters .field select {
            padding: 1rem 1.25rem;
            background: rgba(15, 20, 34, 0.8);
            border: 2px solid #23304a;
            border-radius: 0;
            color: #e8eefc;
            font-family: Poppins, system-ui, Segoe UI, Arial, sans-serif;
            font-size: 1rem;
            font-weight: 600;
            transition: all 0.2s ease;
            box-shadow: inset 0 3px 0 rgba(0, 0, 0, 0.3), 0 2px 0 rgba(27, 37, 58, 0.5);
            box-sizing: border-box;
            width: 100%;
            min-width: 200px;
            cursor: pointer;
        }

        .eb-filters .field .select:focus,
        .eb-filters .field select:focus {
            outline: none;
            background: rgba(15, 20, 34, 0.95);
            border-color: #ffd24a;
            box-shadow: inset 0 3px 0 rgba(0, 0, 0, 0.3), 0 0 25px rgba(255, 210, 74, 0.25);
        }

        .eb-cart-wrapper {
            margin-bottom: 1.5rem;
        }

        .eb-cart-wrapper .btn {
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
        }

        .eb-cart-wrapper .btn:hover {
            background: rgba(15, 20, 34, 0.95);
            border-color: #ffd24a;
            color: #ffd24a;
            transform: translate(2px, 2px);
            box-shadow: 1px 1px 0 rgba(27, 37, 58, 0.8);
        }

        .cart {
            margin-top: 1rem;
            background: #121a2a;
            border: 2px solid #23304a;
            border-radius: 0;
            padding: 1.5rem;
            box-shadow: 0 8px 0 rgba(27, 37, 58, 0.8), 0 12px 24px rgba(0, 0, 0, 0.3);
        }

        .cart-title {
            font-size: 0.8rem;
            font-weight: 400;
            color: #ffd24a;
            margin-bottom: 1rem;
            font-family: 'Press Start 2P', monospace;
            text-transform: uppercase;
            letter-spacing: 0.03em;
        }

        .cart-list {
            display: flex;
            flex-direction: column;
            gap: 0.75rem;
            margin-bottom: 1rem;
        }

        .cart-item {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 1rem;
            padding: 0.75rem 1rem;
            border-radius: 0;
            background: rgba(15, 20, 34, 0.8);
            border: 2px solid #23304a;
            box-shadow: inset 0 3px 0 rgba(0, 0, 0, 0.3);
        }

        .cart-item .q {
            font-size: 0.9rem;
            color: #e8eefc;
            flex: 1;
            font-family: Poppins, system-ui, Segoe UI, Arial, sans-serif;
        }

        .cart-item .icon-btn {
            padding: 0.5rem 1rem;
            font-weight: 900;
            font-family: 'Press Start 2P', monospace;
            font-size: 0.6rem;
            cursor: pointer;
            transition: all 0.2s ease;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            border-radius: 0;
            border: 2px solid #ff6b6b;
            background: rgba(255, 107, 107, 0.2);
            color: #ff6b6b;
            text-decoration: none;
            box-shadow: 3px 3px 0 rgba(217, 0, 95, 0.5);
            white-space: nowrap;
        }

        .cart-item .icon-btn:hover {
            background: #ff6b6b;
            color: #ffffff;
            transform: translate(2px, 2px);
            box-shadow: 1px 1px 0 rgba(217, 0, 95, 0.5);
        }

        .cart .form-row {
            display: flex;
            gap: 1rem;
            margin-top: 1rem;
            flex-wrap: wrap;
        }

        .cart .form-row .input,
        .cart .form-row input[type="text"] {
            flex: 1;
            min-width: 200px;
            padding: 1rem 1.25rem;
            background: rgba(15, 20, 34, 0.8);
            border: 2px solid #23304a;
            border-radius: 0;
            color: #e8eefc;
            font-family: Poppins, system-ui, Segoe UI, Arial, sans-serif;
            font-size: 1rem;
            font-weight: 600;
            transition: all 0.2s ease;
            box-shadow: inset 0 3px 0 rgba(0, 0, 0, 0.3), 0 2px 0 rgba(27, 37, 58, 0.5);
            box-sizing: border-box;
        }

        .cart .form-row .input:focus,
        .cart .form-row input[type="text"]:focus {
            outline: none;
            background: rgba(15, 20, 34, 0.95);
            border-color: #ffd24a;
            box-shadow: inset 0 3px 0 rgba(0, 0, 0, 0.3), 0 0 25px rgba(255, 210, 74, 0.25);
        }

        .cart .form-row .input::placeholder,
        .cart .form-row input[type="text"]::placeholder {
            color: rgba(159, 176, 209, 0.5);
            font-weight: 600;
            opacity: 1;
        }

        .cart .error {
            display: block;
            margin: 0.75rem 0 0.5rem;
            color: #ff6b6b;
            font-size: 0.9rem;
            font-family: Poppins, system-ui, Segoe UI, Arial, sans-serif;
        }

        .cart .btn.primary {
            padding: 0.9rem 2rem;
            font-weight: 900;
            font-family: 'Press Start 2P', monospace;
            font-size: 0.7rem;
            cursor: pointer;
            transition: all 0.2s ease;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            border-radius: 0;
            border: 2px solid #ffd24a;
            background: #ffd24a;
            color: #0b0f1a;
            text-decoration: none;
            box-shadow: 4px 4px 0 #b89200;
            display: inline-block;
        }

        .cart .btn.primary:hover {
            background: #ffdc6a;
            transform: translate(2px, 2px);
            box-shadow: 2px 2px 0 #b89200;
        }

        .cart .btn.primary:active {
            transform: translate(4px, 4px);
            box-shadow: 0 0 0 #b89200;
        }

        .eb-topic-block {
            margin-bottom: 1.5rem;
            border-radius: 0;
            border: 2px solid #23304a;
            background: #121a2a;
            overflow: hidden;
            transition: all 0.2s ease;
            box-shadow: 0 8px 0 rgba(27, 37, 58, 0.8), 0 12px 24px rgba(0, 0, 0, 0.3);
        }

        .eb-topic-block:hover {
            border-color: #ffd24a;
            box-shadow: 0 12px 0 rgba(27, 37, 58, 0.8), 0 16px 32px rgba(0, 0, 0, 0.4), 0 0 40px rgba(255, 210, 74, 0.3);
        }

        .eb-topic-card {
            padding: 1.5rem;
            cursor: pointer;
        }

        .eb-topic-card .meta {
            font-size: 0.65rem;
            color: #9fb0d1;
            margin-bottom: 0.5rem;
            font-family: 'Press Start 2P', monospace;
            text-transform: uppercase;
            letter-spacing: 0.03em;
        }

        .eb-topic-title {
            margin: 0.5rem 0;
            font-size: 1rem;
            font-weight: 400;
            color: #e8eefc;
            font-family: 'Press Start 2P', monospace;
            text-transform: uppercase;
            letter-spacing: 0.03em;
            line-height: 1.5;
        }

        .eb-topic-actions {
            display: flex;
            gap: 1rem;
            padding: 1rem 1.5rem;
            border-top: 2px solid #1b253a;
            background: rgba(15, 20, 34, 0.5);
        }

        .eb-topic-actions .btn {
            padding: 0.75rem 1.5rem;
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
        }

        .eb-topic-actions .btn:hover {
            background: rgba(15, 20, 34, 0.95);
            border-color: #ffd24a;
            color: #ffd24a;
            transform: translate(2px, 2px);
            box-shadow: 1px 1px 0 rgba(27, 37, 58, 0.8);
        }

        .eb-topic-actions .btn:active {
            transform: translate(3px, 3px);
            box-shadow: 0 0 0 rgba(27, 37, 58, 0.8);
        }

        .eb-questions {
            border-top: 2px solid #1b253a;
            padding: 1rem 1.5rem;
            background: rgba(15, 20, 34, 0.3);
        }

        .eb-question-row {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 1rem;
            padding: 0.75rem 1rem;
            border-radius: 0;
            margin-bottom: 0.75rem;
            background: rgba(15, 20, 34, 0.8);
            border: 2px solid #23304a;
            box-shadow: inset 0 3px 0 rgba(0, 0, 0, 0.3);
        }

        .eb-question-row:last-child {
            margin-bottom: 0;
        }

        .eb-question-text {
            font-size: 0.9rem;
            color: #e8eefc;
            flex: 1;
            font-family: Poppins, system-ui, Segoe UI, Arial, sans-serif;
        }

        .eb-question-row .icon-btn {
            padding: 0.5rem 1rem;
            font-weight: 900;
            font-family: 'Press Start 2P', monospace;
            font-size: 0.6rem;
            cursor: pointer;
            transition: all 0.2s ease;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            border-radius: 0;
            border: 2px solid #ffd24a;
            background: rgba(255, 210, 74, 0.2);
            color: #ffd24a;
            text-decoration: none;
            box-shadow: 3px 3px 0 rgba(184, 146, 0, 0.5);
            white-space: nowrap;
        }

        .eb-question-row .icon-btn:hover {
            background: #ffd24a;
            color: #0b0f1a;
            transform: translate(2px, 2px);
            box-shadow: 1px 1px 0 rgba(184, 146, 0, 0.5);
        }

        .eb-question-row .icon-btn:active {
            transform: translate(3px, 3px);
            box-shadow: 0 0 0 rgba(184, 146, 0, 0.5);
        }

        @media (max-width: 768px) {
            .eb-filters {
                flex-direction: column;
                align-items: stretch;
            }

            .eb-filters .field {
                width: 100%;
            }

            .eb-filters .field .input,
            .eb-filters .field input[type="text"],
            .eb-filters .field .select,
            .eb-filters .field select {
                width: 100%;
            }

            .eb-topic-actions {
                flex-wrap: wrap;
                justify-content: flex-start;
            }

            .cart .form-row {
                flex-direction: column;
            }

            .cart .form-row .input,
            .cart .form-row input[type="text"] {
                width: 100%;
            }
        }
    </style>
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

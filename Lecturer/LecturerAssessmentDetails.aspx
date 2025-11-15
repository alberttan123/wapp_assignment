<%@ Page Title="Lecturer • Assessment Details" Language="C#"
    MasterPageFile="~/Lecturer/Lecturer.Master"
    AutoEventWireup="true"
    CodeBehind="LecturerAssessmentDetails.aspx.cs"
    Inherits="WAPP_Assignment.Lecturer.LecturerAssessmentDetails" %>

<asp:Content ID="HeadBlock" ContentPlaceHolderID="HeadLecturer" runat="server">
  <link rel="stylesheet" href="<%= ResolveUrl("~/Content/LecturerPages.css") %>" />
  <style>
    @import url('https://fonts.googleapis.com/css2?family=Press+Start+2P&display=swap');
    
    .ad-shell {
        width: 100%;
        margin: 0;
        padding: 2rem;
        background: #121a2a;
        min-height: 100vh;
    }

    .ad-header {
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 1.5rem;
        margin-bottom: 2rem;
        flex-wrap: wrap;
    }

    .ad-title {
        margin: 0;
        font-family: 'Press Start 2P', monospace;
        font-size: 1.2rem;
        font-weight: 700;
        color: #ffd24a;
        text-transform: uppercase;
        letter-spacing: 0.05em;
        text-shadow: 3px 3px 0 rgba(0, 0, 0, 0.5);
    }

    .ad-meta {
        font-size: 0.85rem;
        color: #9fb0d1;
        margin-bottom: 1.5rem;
        font-family: 'Press Start 2P', monospace;
        font-size: 0.6rem;
        text-transform: uppercase;
        letter-spacing: 0.03em;
    }

    .ad-actions {
        display: flex;
        gap: 0.75rem;
        flex-wrap: wrap;
    }

    .ad-actions .btn {
        font-family: 'Press Start 2P', monospace;
        font-size: 0.6rem;
        padding: 0.75rem 1.25rem;
        background: #ffd24a;
        color: #0f1422;
        border: 2px solid #23304a;
        border-radius: 0;
        text-transform: uppercase;
        letter-spacing: 0.05em;
        text-decoration: none;
        font-weight: 700;
        box-shadow: 0 4px 0 rgba(27, 37, 58, 0.8), 0 6px 12px rgba(0, 0, 0, 0.3);
        transition: all 0.2s ease;
        cursor: pointer;
        display: inline-block;
        white-space: nowrap;
    }

    .ad-actions .btn:hover {
        background: #ffffff;
        transform: translateY(-2px);
        box-shadow: 0 6px 0 rgba(27, 37, 58, 0.8), 0 8px 16px rgba(0, 0, 0, 0.4);
    }

    .ad-actions .btn:active {
        transform: translateY(0);
        box-shadow: 0 2px 0 rgba(27, 37, 58, 0.8), 0 4px 8px rgba(0, 0, 0, 0.3);
    }

    .ad-layout {
        display: grid;
        grid-template-columns: 1fr 22rem;
        gap: 1.5rem;
    }

    @media (max-width: 56.25rem) {
        .ad-layout {
            grid-template-columns: minmax(0, 1fr);
        }
    }

    .ad-section {
        background: #121a2a;
        border: 2px solid #23304a;
        border-radius: 0;
        padding: 1.5rem;
        box-shadow: 0 8px 0 rgba(27, 37, 58, 0.8), 0 12px 24px rgba(0, 0, 0, 0.3);
        transition: all 0.2s ease;
    }

    .ad-section:hover {
        border-color: #ffd24a;
        transform: translateY(-2px);
        box-shadow: 0 10px 0 rgba(27, 37, 58, 0.8), 0 14px 28px rgba(0, 0, 0, 0.4), 0 0 30px rgba(255, 210, 74, 0.2);
    }

    .ad-section h3,
    .ad-section .sec-h {
        margin: 0 0 1rem 0;
        font-family: 'Press Start 2P', monospace;
        font-size: 0.7rem;
        font-weight: 700;
        color: #ffd24a;
        text-transform: uppercase;
        letter-spacing: 0.05em;
        text-shadow: 2px 2px 0 rgba(0, 0, 0, 0.5);
    }

    .ad-qlist {
        display: flex;
        flex-direction: column;
        gap: 1rem;
    }

    .ad-q {
        padding: 1.25rem;
        background: rgba(27, 37, 58, 0.6);
        border: 2px solid #23304a;
        border-radius: 0;
        display: flex;
        gap: 1rem;
        justify-content: space-between;
        align-items: flex-start;
        box-shadow: 0 4px 0 rgba(27, 37, 58, 0.8);
        transition: all 0.2s ease;
    }

    .ad-q:hover {
        background: rgba(35, 48, 74, 0.8);
        border-color: #ffd24a;
        transform: translateY(-2px);
        box-shadow: 0 6px 0 rgba(27, 37, 58, 0.8);
    }

    .ad-q h4 {
        margin: 0 0 0.75rem 0;
        font-family: 'Press Start 2P', monospace;
        font-size: 0.7rem;
        color: #e8eefc;
        text-transform: uppercase;
        letter-spacing: 0.03em;
        line-height: 1.5;
        font-weight: 400;
    }

    .ad-opt {
        margin-left: 1rem;
        margin-bottom: 0.5rem;
        font-size: 0.65rem;
        color: #9fb0d1;
        font-family: 'Press Start 2P', monospace;
        text-transform: uppercase;
        letter-spacing: 0.03em;
    }

    .badge {
        font-size: 0.65rem;
        padding: 0.3rem 0.6rem;
        border: 1px solid #23304a;
        border-radius: 0;
        background: rgba(255, 210, 74, 0.2);
        color: #ffd24a;
        font-family: 'Press Start 2P', monospace;
        text-transform: uppercase;
        letter-spacing: 0.03em;
        display: inline-block;
    }

    .ad-q .btn {
        font-family: 'Press Start 2P', monospace;
        font-size: 0.55rem;
        padding: 0.5rem 0.75rem;
        background: rgba(255, 107, 107, 0.2);
        color: #ff6b6b;
        border: 2px solid #ff6b6b;
        border-radius: 0;
        text-transform: uppercase;
        letter-spacing: 0.05em;
        text-decoration: none;
        font-weight: 700;
        box-shadow: 3px 3px 0 rgba(217, 0, 95, 0.5);
        transition: all 0.2s ease;
        cursor: pointer;
        white-space: nowrap;
    }

    .ad-q .btn:hover {
        background: #ff6b6b;
        color: #ffffff;
        transform: translate(2px, 2px);
        box-shadow: 1px 1px 0 rgba(217, 0, 95, 0.5);
    }

    .ad-q .btn:active {
        transform: translate(3px, 3px);
        box-shadow: 0 0 0 rgba(217, 0, 95, 0.5);
    }

    .ad-side .field {
        display: flex;
        flex-direction: column;
        gap: 0.5rem;
        margin-bottom: 1rem;
    }

    .ad-side .field label {
        font-family: 'Press Start 2P', monospace;
        font-size: 0.5rem;
        color: #9fb0d1;
        text-transform: uppercase;
        letter-spacing: 0.05em;
    }

    .ad-side .field .select,
    .ad-side .field select {
        padding: 0.75rem 1rem;
        background: rgba(15, 20, 34, 0.8);
        border: 2px solid #23304a;
        border-radius: 0;
        color: #e8eefc;
        font-family: Poppins, system-ui, Segoe UI, Arial, sans-serif;
        font-size: 0.95rem;
        font-weight: 600;
        box-shadow: inset 0 3px 0 rgba(0, 0, 0, 0.3), 0 2px 0 rgba(27, 37, 58, 0.5);
        transition: all 0.2s ease;
    }

    .ad-side .field .select:focus,
    .ad-side .field select:focus {
        outline: none;
        background: rgba(15, 20, 34, 0.95);
        border-color: #ffd24a;
        box-shadow: inset 0 3px 0 rgba(0, 0, 0, 0.3), 0 0 25px rgba(255, 210, 74, 0.25);
    }

    .ad-side .q-list {
        display: flex;
        flex-direction: column;
        gap: 0.75rem;
        max-height: 18rem;
        overflow: auto;
    }

    .ad-side .q-item {
        padding: 0.75rem;
        background: rgba(27, 37, 58, 0.6);
        border: 2px solid #23304a;
        border-radius: 0;
        display: flex;
        justify-content: space-between;
        align-items: center;
        gap: 0.75rem;
        box-shadow: 0 4px 0 rgba(27, 37, 58, 0.8);
        transition: all 0.2s ease;
    }

    .ad-side .q-item:hover {
        background: rgba(35, 48, 74, 0.8);
        border-color: #ffd24a;
        transform: translateY(-2px);
        box-shadow: 0 6px 0 rgba(27, 37, 58, 0.8);
    }

    .ad-side .q-item > div {
        flex: 1;
        font-size: 0.65rem;
        color: #e8eefc;
        font-family: 'Press Start 2P', monospace;
        text-transform: uppercase;
        letter-spacing: 0.03em;
        line-height: 1.5;
    }

    .ad-side .q-item .btn {
        font-family: 'Press Start 2P', monospace;
        font-size: 0.5rem;
        padding: 0.5rem 0.75rem;
        background: rgba(255, 210, 74, 0.2);
        color: #ffd24a;
        border: 2px solid #ffd24a;
        border-radius: 0;
        text-transform: uppercase;
        letter-spacing: 0.05em;
        text-decoration: none;
        font-weight: 700;
        box-shadow: 3px 3px 0 rgba(184, 146, 0, 0.5);
        transition: all 0.2s ease;
        cursor: pointer;
        white-space: nowrap;
    }

    .ad-side .q-item .btn:hover {
        background: #ffd24a;
        color: #0f1422;
        transform: translate(2px, 2px);
        box-shadow: 1px 1px 0 rgba(184, 146, 0, 0.5);
    }

    .ad-side .q-item .btn:active {
        transform: translate(3px, 3px);
        box-shadow: 0 0 0 rgba(184, 146, 0, 0.5);
    }

    .ad-title-edit {
        display: flex;
        gap: 0.75rem;
        align-items: center;
        flex-wrap: wrap;
    }

    .ad-title-edit .input {
        flex: 1;
        min-width: 20rem;
        padding: 1rem 1.25rem;
        background: rgba(15, 20, 34, 0.8);
        border: 2px solid #23304a;
        border-radius: 0;
        color: #e8eefc;
        font-family: Poppins, system-ui, Segoe UI, Arial, sans-serif;
        font-size: 1rem;
        font-weight: 600;
        box-shadow: inset 0 3px 0 rgba(0, 0, 0, 0.3), 0 2px 0 rgba(27, 37, 58, 0.5);
        transition: all 0.2s ease;
        box-sizing: border-box;
    }

    .ad-title-edit .input:focus {
        outline: none;
        background: rgba(15, 20, 34, 0.95);
        border-color: #ffd24a;
        box-shadow: inset 0 3px 0 rgba(0, 0, 0, 0.3), 0 0 25px rgba(255, 210, 74, 0.25);
    }

    .ad-title-edit .btn.primary {
        font-family: 'Press Start 2P', monospace;
        font-size: 0.6rem;
        padding: 0.75rem 1.25rem;
        background: #ffd24a;
        color: #0f1422;
        border: 2px solid #23304a;
        border-radius: 0;
        text-transform: uppercase;
        letter-spacing: 0.05em;
        font-weight: 700;
        box-shadow: 0 4px 0 rgba(27, 37, 58, 0.8), 0 6px 12px rgba(0, 0, 0, 0.3);
        transition: all 0.2s ease;
        cursor: pointer;
    }

    .ad-title-edit .btn.primary:hover {
        background: #ffffff;
        transform: translateY(-2px);
        box-shadow: 0 6px 0 rgba(27, 37, 58, 0.8), 0 8px 16px rgba(0, 0, 0, 0.4);
    }

    .ad-title-edit .btn.primary:active {
        transform: translateY(0);
        box-shadow: 0 2px 0 rgba(27, 37, 58, 0.8), 0 4px 8px rgba(0, 0, 0, 0.3);
    }

    .muted {
        font-size: 0.85rem;
        color: #9fb0d1;
        font-family: 'Press Start 2P', monospace;
        font-size: 0.6rem;
        text-transform: uppercase;
        letter-spacing: 0.03em;
    }

    .ad-side .ad-actions {
        margin-bottom: 0.75rem;
    }

    .ad-side .ad-actions .btn {
        font-family: 'Press Start 2P', monospace;
        font-size: 0.6rem;
        padding: 0.75rem 1.25rem;
        background: #ffd24a;
        color: #0f1422;
        border: 2px solid #23304a;
        border-radius: 0;
        text-transform: uppercase;
        letter-spacing: 0.05em;
        font-weight: 700;
        box-shadow: 0 4px 0 rgba(27, 37, 58, 0.8), 0 6px 12px rgba(0, 0, 0, 0.3);
        transition: all 0.2s ease;
        cursor: pointer;
    }

    .ad-side .ad-actions .btn:hover {
        background: #ffffff;
        transform: translateY(-2px);
        box-shadow: 0 6px 0 rgba(27, 37, 58, 0.8), 0 8px 16px rgba(0, 0, 0, 0.4);
    }

    .ad-side .ad-actions .btn:active {
        transform: translateY(0);
        box-shadow: 0 2px 0 rgba(27, 37, 58, 0.8), 0 4px 8px rgba(0, 0, 0, 0.3);
    }
  </style>
</asp:Content>

<asp:Content ID="MainBlock" ContentPlaceHolderID="LecturerMain" runat="server">
  <div class="ad-shell">
    <div class="ad-header">
      <h2 class="ad-title"><asp:Literal ID="litTitle" runat="server" /></h2>
      <div class="ad-actions">
        <a href="<%= ResolveUrl("~/Lecturer/LecturerAssessments.aspx") %>" class="btn">Back to Assessments</a>
      </div>
    </div>

  <div class="ad-meta">
    <asp:Literal ID="litMeta" runat="server" />
  </div>

  <!-- Title edit row -->
  <div class="ad-section" style="margin-bottom:1rem;">
    <div class="ad-title-edit">
      <asp:TextBox ID="txtTitle" runat="server" CssClass="input" />
      <asp:Button ID="btnSaveTitle" runat="server" CssClass="btn primary" Text="Save Title" OnClick="BtnSaveTitle_Click" />
      <asp:Label ID="lblMsg" runat="server" CssClass="muted" Visible="false"></asp:Label>
    </div>
  </div>

  <div class="ad-layout">
    <!-- LEFT: Questions in this assessment -->
    <div>
      <div class="ad-section">
        <h3 style="margin:0 0 .5rem 0;">Questions in this assessment</h3>
        <asp:Repeater ID="rptQuestions" runat="server" OnItemCommand="RptQuestions_ItemCommand">
          <HeaderTemplate><div class="ad-qlist"></HeaderTemplate>
          <ItemTemplate>
            <div class="ad-q">
              <div>
                <h4>Q<%# Container.ItemIndex + 1 %>. <%# Eval("Question") %></h4>
                <div class="ad-opt">1) <%# Eval("Option1") %></div>
                <div class="ad-opt">2) <%# Eval("Option2") %></div>
                <asp:PlaceHolder runat="server" Visible='<%# Eval("Option3") != DBNull.Value %>'>
                  <div class="ad-opt">3) <%# Eval("Option3") %></div>
                </asp:PlaceHolder>
                <asp:PlaceHolder runat="server" Visible='<%# Eval("Option4") != DBNull.Value %>'>
                  <div class="ad-opt">4) <%# Eval("Option4") %></div>
                </asp:PlaceHolder>
                <div class="ad-opt"><span class="badge">Answer</span> <%# Eval("CorrectAnswer") %></div>
              </div>
              <asp:LinkButton ID="btnRemove" runat="server" CssClass="btn" CommandName="remove" CommandArgument='<%# Eval("QuestionId") %>'>
                Remove
              </asp:LinkButton>
            </div>
          </ItemTemplate>
          <FooterTemplate></div></FooterTemplate>
        </asp:Repeater>
      </div>
    </div>

    <!-- RIGHT: Add from exercises -->
    <div class="ad-side">
      <div class="ad-section">
        <h3 class="sec-h">Add Questions (from Exercises)</h3>

        <div class="field">
          <label>Choose Exercise</label>
          <asp:DropDownList ID="ddlExercise" runat="server" CssClass="select" AutoPostBack="true" OnSelectedIndexChanged="DdlExercise_SelectedIndexChanged" />
        </div>

        <div class="ad-actions" style="justify-content:flex-end; margin-bottom:.5rem;">
          <asp:Button ID="btnAddAllFromExercise" runat="server" CssClass="btn" Text="Add All from Exercise" OnClick="BtnAddAllFromExercise_Click" />
        </div>

        <asp:Repeater ID="rptExerciseQuestions" runat="server" OnItemCommand="RptExerciseQuestions_ItemCommand">
          <HeaderTemplate><div class="q-list"></HeaderTemplate>
          <ItemTemplate>
            <div class="q-item">
              <div style="flex:1;"><%# Eval("Question") %></div>
              <asp:LinkButton ID="btnAddOne" runat="server" CssClass="btn" CommandName="addone" CommandArgument='<%# Eval("QuestionId") %>'>Add</asp:LinkButton>
            </div>
          </ItemTemplate>
          <FooterTemplate></div></FooterTemplate>
        </asp:Repeater>
      </div>
    </div>
  </div>

    <asp:Label ID="lblInfo" runat="server" CssClass="muted" Visible="false" />
  </div>
</asp:Content>

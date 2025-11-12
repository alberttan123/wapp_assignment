<%@ Page Title="Lecturer • Assessment Details" Language="C#"
    MasterPageFile="~/Lecturer/Lecturer.Master"
    AutoEventWireup="true"
    CodeBehind="LecturerAssessmentDetails.aspx.cs"
    Inherits="WAPP_Assignment.Lecturer.LecturerAssessmentDetails" %>

<asp:Content ID="HeadBlock" ContentPlaceHolderID="HeadLecturer" runat="server">
  <link rel="stylesheet" href="<%= ResolveUrl("~/Content/LecturerPages.css") %>" />
  <style>
    .ad-header{ display:flex; align-items:center; justify-content:space-between; gap:1rem; margin-bottom:1rem; }
    .ad-title{ margin:0; font-size:1.5rem; font-weight:700; color:var(--brand); }

    .ad-meta{ color:var(--muted); margin-bottom:1rem; }
    .ad-layout{ display:grid; grid-template-columns: 1fr 22rem; gap:1rem; }

    .ad-section{ background:var(--panel-2); border:1px solid var(--line); border-radius:12px; padding:1rem; }
    .ad-qlist{ display:flex; flex-direction:column; gap:.5rem; }
    .ad-q{ padding:.75rem; background:var(--panel); border:1px solid var(--line); border-radius:10px; display:flex; gap:.75rem; justify-content:space-between; align-items:flex-start; }
    .ad-q h4{ margin:.1rem 0 .25rem 0; font-size:1rem; color:var(--text); }
    .ad-opt{ margin-left:1rem; color:var(--muted); }
    .badge{ font-size:.75rem; padding:.1rem .4rem; border:1px solid var(--line); border-radius:999px; color:var(--muted); }

    .ad-side .field{ display:flex; flex-direction:column; gap:.25rem; margin-bottom:.75rem; }
    .ad-side .q-list{ display:flex; flex-direction:column; gap:.5rem; max-height:18rem; overflow:auto; }
    .ad-side .q-item{ padding:.5rem; background:var(--panel); border:1px solid var(--line); border-radius:10px; display:flex; justify-content:space-between; gap:.5rem; }
    .ad-side .sec-h{ margin:0 0 .5rem 0; font-size:1rem; color:var(--text); }
    .ad-actions{ display:flex; gap:.5rem; }

    .ad-title-edit{ display:flex; gap:.5rem; align-items:center; }
    .ad-title-edit .input{ min-width:20rem; }
  </style>
</asp:Content>

<asp:Content ID="MainBlock" ContentPlaceHolderID="LecturerMain" runat="server">
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
</asp:Content>

<%@ Page Title="Lecturer • Add Question" Language="C#"
    MasterPageFile="~/Lecturer/Lecturer.Master"
    AutoEventWireup="true"
    CodeBehind="LecturerQuestionAdd.aspx.cs"
    Inherits="WAPP_Assignment.Lecturer.LecturerQuestionAdd" %>

<asp:Content ID="HeadBlock" ContentPlaceHolderID="HeadLecturer" runat="server">
  <link rel="stylesheet" href="<%= ResolveUrl("~/Content/LecturerPages.css") %>" />
  <style>
    @import url('https://fonts.googleapis.com/css2?family=Press+Start+2P&display=swap');
    
    .qadd-shell {
      max-width: 960px;
      margin: 0 auto;
    }

    .qadd-top {
      display: flex;
      justify-content: flex-end;
      margin-bottom: 1.5rem;
    }

    .qadd-top .btn {
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

    .qadd-top .btn:hover {
      background: rgba(15, 20, 34, 0.95);
      border-color: #ffd24a;
      color: #ffd24a;
      transform: translate(2px, 2px);
      box-shadow: 1px 1px 0 rgba(27, 37, 58, 0.8);
    }

    .qadd-top .btn:active {
      transform: translate(3px, 3px);
      box-shadow: 0 0 0 rgba(27, 37, 58, 0.8);
    }

    .qadd-stage {
      background: #121a2a;
      border: 2px solid #23304a;
      border-radius: 0;
      padding: 2rem;
      box-shadow: 0 8px 0 rgba(27, 37, 58, 0.8), 0 12px 24px rgba(0, 0, 0, 0.3);
    }

    .qadd-inner {
      background: rgba(15, 20, 34, 0.6);
      border: 2px solid #23304a;
      border-radius: 0;
      padding: 1.5rem;
      text-align: center;
      box-shadow: inset 0 3px 0 rgba(0, 0, 0, 0.3);
    }

    .qadd-img {
      margin-bottom: 1rem;
    }

    .qadd-img input[type="file"] {
      margin: 0.5rem auto;
      padding: 0.75rem;
      background: rgba(15, 20, 34, 0.8);
      border: 2px solid #23304a;
      border-radius: 0;
      color: #e8eefc;
      font-family: Poppins, system-ui, Segoe UI, Arial, sans-serif;
      font-size: 0.9rem;
      cursor: pointer;
    }

    .qadd-qbox {
      margin-top: 1rem;
    }

    .qadd-qbox .input,
    .qadd-qbox textarea {
      width: 100%;
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
      resize: vertical;
    }

    .qadd-qbox .input:focus,
    .qadd-qbox textarea:focus {
      outline: none;
      background: rgba(15, 20, 34, 0.95);
      border-color: #ffd24a;
      box-shadow: inset 0 3px 0 rgba(0, 0, 0, 0.3), 0 0 25px rgba(255, 210, 74, 0.25);
    }

    .qadd-options {
      display: grid;
      grid-template-columns: repeat(4, minmax(0, 1fr));
      gap: 1rem;
      margin-top: 1.5rem;
    }

    .opt-card {
      cursor: pointer;
      background: rgba(15, 20, 34, 0.8);
      border: 2px solid #23304a;
      border-radius: 0;
      padding: 1rem;
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 0.75rem;
      transition: all 0.2s ease;
      box-shadow: inset 0 3px 0 rgba(0, 0, 0, 0.3);
    }

    .opt-card:hover {
      border-color: #ffd24a;
      background: rgba(15, 20, 34, 0.95);
      box-shadow: inset 0 3px 0 rgba(0, 0, 0, 0.3), 0 0 20px rgba(255, 210, 74, 0.2);
    }

    .opt-label {
      font-size: 0.65rem;
      color: #9fb0d1;
      font-family: 'Press Start 2P', monospace;
      text-transform: uppercase;
      letter-spacing: 0.03em;
    }

    .opt-card .input,
    .opt-card input[type="text"] {
      text-align: center;
      width: 100%;
      padding: 0.75rem 0.5rem;
      background: rgba(15, 20, 34, 0.6);
      border: 2px solid #23304a;
      border-radius: 0;
      color: #e8eefc;
      font-family: Poppins, system-ui, Segoe UI, Arial, sans-serif;
      font-size: 0.9rem;
      font-weight: 600;
      transition: all 0.2s ease;
      box-shadow: inset 0 2px 0 rgba(0, 0, 0, 0.3);
      box-sizing: border-box;
    }

    .opt-card .input:focus,
    .opt-card input[type="text"]:focus {
      outline: none;
      background: rgba(15, 20, 34, 0.8);
      border-color: #ffd24a;
      box-shadow: inset 0 2px 0 rgba(0, 0, 0, 0.3), 0 0 15px rgba(255, 210, 74, 0.2);
    }

    .opt-radio {
      font-size: 0.6rem;
      color: #9fb0d1;
      font-family: 'Press Start 2P', monospace;
      text-transform: uppercase;
      letter-spacing: 0.03em;
    }

    .opt-card.is-correct {
      border-color: #ffd24a;
      background: rgba(255, 210, 74, 0.15);
      box-shadow: inset 0 3px 0 rgba(0, 0, 0, 0.3), 0 0 30px rgba(255, 210, 74, 0.4);
    }

    .opt-card.is-correct .opt-radio {
      color: #ffd24a;
      font-weight: 400;
    }

    .opt-card.is-correct:hover {
      background: rgba(255, 210, 74, 0.2);
      box-shadow: inset 0 3px 0 rgba(0, 0, 0, 0.3), 0 0 40px rgba(255, 210, 74, 0.5);
    }

    .qadd-footer {
      display: flex;
      justify-content: flex-end;
      margin-top: 1.5rem;
    }

    .qadd-footer .btn.primary {
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

    .qadd-footer .btn.primary:hover {
      background: #ffdc6a;
      transform: translate(2px, 2px);
      box-shadow: 2px 2px 0 #b89200;
    }

    .qadd-footer .btn.primary:active {
      transform: translate(4px, 4px);
      box-shadow: 0 0 0 #b89200;
    }

    .hint {
      color: #9fb0d1;
      font-size: 0.65rem;
      font-family: 'Press Start 2P', monospace;
      text-transform: uppercase;
      letter-spacing: 0.03em;
      margin-bottom: 0.5rem;
    }

    @media (max-width: 960px) {
      .qadd-options {
        grid-template-columns: repeat(2, minmax(0, 1fr));
      }
    }

    @media (max-width: 640px) {
      .qadd-options {
        grid-template-columns: 1fr;
      }

      .qadd-stage {
        padding: 1.5rem;
      }
    }
  </style>
</asp:Content>

<asp:Content ID="MainBlock" ContentPlaceHolderID="LecturerMain" runat="server">
  <div class="qadd-shell">
    <div class="qadd-top">
      <a href="<%= ResolveUrl("~/Lecturer/LecturerQuestionViewer.aspx") %>" class="btn">View Questions</a>
    </div>

    <asp:Label ID="lblMsg" runat="server" CssClass="muted" Visible="false" />

    <div class="qadd-stage">
      <div class="qadd-inner">
        <div class="qadd-img">
          <div class="hint">Question image (optional)</div>
          <asp:FileUpload ID="fuImg" runat="server" />
        </div>

        <div class="qadd-qbox">
          <div class="hint" style="margin-bottom:0.25rem;">Question text</div>
          <asp:TextBox ID="txtQ" runat="server" CssClass="input" TextMode="MultiLine" Rows="3" />
        </div>
      </div>

      <div class="qadd-options">
        <div class="opt-card" onclick="qaddSelect(1);">
          <span class="opt-label">Option 1</span>
          <asp:TextBox ID="txtO1" runat="server" CssClass="input" />
          <span class="opt-radio">Click to mark correct</span>
        </div>

        <div class="opt-card" onclick="qaddSelect(2);">
          <span class="opt-label">Option 2</span>
          <asp:TextBox ID="txtO2" runat="server" CssClass="input" />
          <span class="opt-radio">Click to mark correct</span>
        </div>

        <div class="opt-card" onclick="qaddSelect(3);">
          <span class="opt-label">Option 3 (optional)</span>
          <asp:TextBox ID="txtO3" runat="server" CssClass="input" />
          <span class="opt-radio">Click to mark correct</span>
        </div>

        <div class="opt-card" onclick="qaddSelect(4);">
          <span class="opt-label">Option 4 (optional)</span>
          <asp:TextBox ID="txtO4" runat="server" CssClass="input" />
          <span class="opt-radio">Click to mark correct</span>
        </div>
      </div>
    </div>

    <div class="qadd-footer">
      <asp:HiddenField ID="hfCorrectAnswer" runat="server" />
      <asp:Button ID="btnSave" runat="server" CssClass="btn primary" Text="Add Question" OnClick="BtnSave_Click" />
    </div>
  </div>

  <script type="text/javascript">
    function qaddSelect(idx) {
      var hidden = document.getElementById('<%= hfCorrectAnswer.ClientID %>');
      if (!hidden) return;
      hidden.value = idx;

      var cards = document.querySelectorAll('.qadd-options .opt-card');
      for (var i = 0; i < cards.length; i++) {
        if (i === idx - 1) {
          cards[i].classList.add('is-correct');
        } else {
          cards[i].classList.remove('is-correct');
        }
      }
    }

    (function () {
      var hidden = document.getElementById('<%= hfCorrectAnswer.ClientID %>');
          if (!hidden) return;
          if (!hidden.value) hidden.value = "1";
          var idx = parseInt(hidden.value || "1", 10);
          if (!idx || idx < 1 || idx > 4) idx = 1;
          qaddSelect(idx);
      })();
  </script>
</asp:Content>

<%@ Page Title="Lecturer • Add Question" Language="C#"
    MasterPageFile="~/Lecturer/Lecturer.Master"
    AutoEventWireup="true"
    CodeBehind="LecturerQuestionAdd.aspx.cs"
    Inherits="WAPP_Assignment.Lecturer.LecturerQuestionAdd" %>

<asp:Content ID="HeadBlock" ContentPlaceHolderID="HeadLecturer" runat="server">
  <link rel="stylesheet" href="<%= ResolveUrl("~/Content/LecturerPages.css") %>" />
  <style>
    .qadd-shell{
      max-width: 960px;
      margin: 0 auto;
    }

    .qadd-top{
      display: flex;
      justify-content: flex-end;
      margin-bottom: 0.75rem;
    }

    .qadd-stage{
      background: var(--panel-2);
      border: 1px solid var(--line);
      border-radius: 12px;
      padding: 1.5rem 3.5rem;
    }

    .qadd-inner{
      background: var(--panel);
      border: 1px solid var(--line);
      border-radius: 10px;
      padding: 1rem 1.5rem;
      text-align: center;
    }

    .qadd-img{
      margin-bottom: 0.5rem;
    }

    .qadd-img input[type="file"]{
      margin: 0.25rem auto;
    }

    .qadd-qbox{
      margin-top: 0.5rem;
    }

    .qadd-qbox .input{
      width: 100%;
    }

    .qadd-options{
      display: grid;
      grid-template-columns: repeat(4, minmax(0, 1fr));
      gap: 1rem;
      margin-top: 1.25rem;
    }

    .opt-card{
      cursor: pointer;
      background: var(--panel-2);
      border: 1px solid var(--line);
      border-radius: 12px;
      padding: 0.5rem;
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 0.35rem;
      transition: background 0.15s ease, border-color 0.15s ease, box-shadow 0.15s ease;
    }

    .opt-label{
      font-size: 0.9rem;
      color: var(--muted);
    }

    .opt-card .input{
      text-align: center;
    }

    .opt-radio{
      font-size: 0.8rem;
      color: var(--muted);
    }

    .opt-card.is-correct{
      border-color: var(--brand);
      box-shadow: 0 0 0 1px var(--brand);
      background: rgba(255,210,74,0.08);
    }

    .opt-card.is-correct .opt-radio{
      color: var(--brand);
      font-weight: 600;
    }

    .qadd-footer{
      display: flex;
      justify-content: flex-end;
      margin-top: 1rem;
    }

    .hint{
      color: var(--muted);
      font-size: 0.875rem;
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

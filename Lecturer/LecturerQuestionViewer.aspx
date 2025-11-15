<%@ Page Title="Lecturer • View Questions" Language="C#"
    MasterPageFile="~/Lecturer/Lecturer.Master"
    AutoEventWireup="true"
    CodeBehind="LecturerQuestionViewer.aspx.cs"
    Inherits="WAPP_Assignment.Lecturer.LecturerQuestionViewer" %>

<asp:Content ID="HeadBlock" ContentPlaceHolderID="HeadLecturer" runat="server">
  <link rel="stylesheet" href="<%= ResolveUrl("~/Content/LecturerPages.css") %>" />
  <style>
    .qv-shell{ max-width:1000px; margin:0 auto; }
    .qv-topbar{
      display:flex;
      align-items:center;
      justify-content:space-between;
      margin-bottom:.75rem;
    }
    .qv-left-actions{ display:flex; gap:.5rem; align-items:center; }

    /* --- toggle container --- */
    .qv-toggle{
      display:flex;
      align-items:center;
      gap:.5rem;
      font-size:.9rem;
      color:var(--muted);
    }
    .qv-toggle-label{
      white-space:nowrap;
    }
    .qv-toggle-switch{
      position:relative;
      display:inline-flex;
      align-items:center;
    }

    /* WebForms: CssClass is applied to a SPAN wrapper around the real <input> */
    .qv-toggle-input{
      position:absolute;
      inset:0;
      display:inline-block;
      cursor:pointer;
    }
    .qv-toggle-input input{
      width:100%;
      height:100%;
      opacity:0;
      cursor:pointer;
    }

    .qv-toggle-track{
      position:relative;
      width:3.5rem;
      height:1.7rem;
      border-radius:999px;
      background:var(--panel-2);
      border:1px solid var(--line);
      display:flex;
      align-items:center;
      justify-content:space-between;
      padding:0 0.35rem;
      box-sizing:border-box;
      cursor:pointer;
    }
    .qv-toggle-thumb{
      position:absolute;
      top:2px;
      left:2px;
      width:1.5rem;
      height:1.3rem;
      border-radius:999px;
      background:var(--brand);
      transition:transform .18s ease;
    }
    .qv-toggle-icon{
      position:relative;
      z-index:1;
      font-size:0.8rem;
    }
    .qv-toggle-icon-list{
      color:var(--text);
    }
    .qv-toggle-icon-card{
      color:var(--muted);
    }

    /*
      IMPORTANT:
      .qv-toggle-input is the <span> wrapper.
      We use :has(input:checked) so the wrapper reacts when the inner <input> is checked.
    */
    .qv-toggle-input:has(input:checked) ~ .qv-toggle-track .qv-toggle-thumb{
      transform:translateX(1.5rem);
    }
    .qv-toggle-input:has(input:checked) ~ .qv-toggle-track .qv-toggle-icon-list{
      color:var(--muted);
    }
    .qv-toggle-input:has(input:checked) ~ .qv-toggle-track .qv-toggle-icon-card{
      color:var(--text);
    }

    /* List mode */
    .qv-list-panel{
      background:var(--panel-2);
      border:1px solid var(--line);
      border-radius:12px;
      padding:1rem;
    }
    .qv-list-row{
      display:flex;
      flex-direction:column;
      gap:.75rem;
    }
    .qv-list-card{
      width:100%;
      background:var(--panel);
      border:1px solid var(--line);
      border-radius:10px;
      padding:.75rem;
      display:flex;
      flex-direction:column;
      justify-content:space-between;
      cursor:pointer;
      transition:border-color .15s ease, box-shadow .15s ease, background .15s ease;
      text-align:left;
    }
    .qv-list-card:hover{
      border-color:var(--brand);
      box-shadow:0 0 0 1px var(--brand);
      background:rgba(255,210,74,.06);
    }
    .qv-list-text{
      font-size:.9rem;
      color:var(--text);
      margin-bottom:.5rem;
      max-height:4.3rem;
      overflow:hidden;
    }
    .qv-list-meta{
      font-size:.8rem;
      color:var(--muted);
      display:flex;
      justify-content:space-between;
    }

    /* Expanded mode */
    .qv-stage{
      position:relative;
      background:var(--panel-2);
      border:1px solid var(--line);
      border-radius:12px;
      padding:1.25rem 3.25rem;
      margin-bottom:.75rem;
    }
    .qv-counter{ color:var(--muted); font-size:.9rem; }
    .qv-inner{
      background:var(--panel);
      border:1px solid var(--line);
      border-radius:10px;
      padding:1rem 1.5rem;
      text-align:center;
    }
    .qv-img img{
      max-width:100%;
      height:auto;
      border-radius:8px;
      border:1px solid var(--line);
      margin:.25rem 0 .5rem;
    }
    .qv-text{
      font-weight:700;
      margin-bottom:.5rem;
    }
    .qv-opts{
      display:grid;
      grid-template-columns:repeat(4,minmax(0,1fr));
      gap:.75rem;
      margin-top:.5rem;
    }
    .qv-opt{
      background:var(--panel-2);
      border:1px solid var(--line);
      border-radius:10px;
      padding:.6rem;
      color:var(--muted);
    }
    .qv-opt.is-correct{
      border-color:var(--brand);
      background:rgba(255,210,74,.08);
      color:var(--text);
      font-weight:600;
    }

    .qv-arrow{
      position:absolute;
      top:0;
      bottom:0;
      width:3rem;
      display:flex;
      align-items:center;
      justify-content:center;
    }
    .qv-arrow.left{ left:.25rem; }
    .qv-arrow.right{ right:.25rem; }
    .qv-arrow .btn{
      min-width:2.5rem;
      height:2.5rem;
      border-radius:999px;
      padding:0;
    }

    /* Edit dropdown */
    .qv-edit-toggle{
      display:flex;
      justify-content:flex-end;
      margin-bottom:.25rem;
    }
    .qv-edit-panel{
      background:var(--bg-2);
      border:1px dashed var(--line);
      border-radius:10px;
      padding:1rem;
      margin-top:.25rem;
    }
    .field{ display:flex; flex-direction:column; gap:.25rem; margin-bottom:.5rem; }
    .grid2{ display:grid; grid-template-columns:1fr 1fr; gap:.5rem; }
    .hint{ color:var(--muted); font-size:.875rem; }

    .edit-opt-row{
      display:grid;
      grid-template-columns:repeat(4,minmax(0,1fr));
      gap:1rem;
      margin-top:.75rem;
    }
    .edit-opt-card{
      cursor:pointer;
      background:var(--panel-2);
      border:1px solid var(--line);
      border-radius:12px;
      padding:.5rem;
      display:flex;
      flex-direction:column;
      align-items:center;
      gap:.35rem;
      transition:background .15s ease, border-color .15s ease, box-shadow .15s ease;
    }
    .edit-opt-card .input{ text-align:center; }
    .edit-opt-label{ font-size:.9rem; color:var(--muted); }
    .edit-opt-radio{ font-size:.8rem; color:var(--muted); }
    .edit-opt-card.is-correct{
      border-color:var(--brand);
      box-shadow:0 0 0 1px var(--brand);
      background:rgba(255,210,74,.08);
    }
    .edit-opt-card.is-correct .edit-opt-radio{
      color:var(--brand);
      font-weight:600;
    }
  </style>
</asp:Content>

<asp:Content ID="MainBlock" ContentPlaceHolderID="LecturerMain" runat="server">
  <div class="qv-shell">
    <div class="qv-topbar">
      <div class="qv-left-actions">
        <a href="<%= ResolveUrl("~/Lecturer/LecturerQuestionAdd.aspx") %>" class="btn">Add Question</a>
      </div>

      <!-- fancy slider toggle for expanded view -->
      <div class="qv-toggle">
        <span class="qv-toggle-label">View mode</span>
        <label class="qv-toggle-switch">
          <!-- WebForms wraps this in a span.qv-toggle-input; that’s what we target in CSS -->
          <asp:CheckBox ID="chkExpanded" runat="server"
                        CssClass="qv-toggle-input"
                        AutoPostBack="true"
                        OnCheckedChanged="ChkExpanded_CheckedChanged" />
          <span class="qv-toggle-track">
            <span class="qv-toggle-icon qv-toggle-icon-list">&#9776;</span>
            <span class="qv-toggle-icon qv-toggle-icon-card">&#9638;</span>
            <span class="qv-toggle-thumb"></span>
          </span>
        </label>
      </div>
    </div>

    <asp:Label ID="lblMsg" runat="server" CssClass="muted" Visible="false" />

    <!-- MODE 1: VERTICAL LIST -->
    <asp:Panel ID="pnlList" runat="server" CssClass="qv-list-panel">
      <div class="hint" style="margin-bottom:.5rem;">
        Click a question card to open it in expanded view.
      </div>
      <asp:Repeater ID="rptList" runat="server" OnItemCommand="RptList_ItemCommand">
        <HeaderTemplate><div class="qv-list-row"></HeaderTemplate>
        <ItemTemplate>
          <asp:LinkButton ID="lnkCard" runat="server" CommandName="view"
                          CommandArgument='<%# Eval("QuestionId") %>' CssClass="qv-list-card">
            <div class="qv-list-text">
              <%# Eval("Question") %>
            </div>
            <div class="qv-list-meta">
              <span>ID #<%# Eval("QuestionId") %></span>
              <span>Ans: <%# Eval("CorrectAnswer") %></span>
            </div>
          </asp:LinkButton>
        </ItemTemplate>
        <FooterTemplate></div></FooterTemplate>
      </asp:Repeater>
    </asp:Panel>

    <!-- MODE 2: EXPANDED VIEW -->
    <asp:Panel ID="pnlExpanded" runat="server" Visible="false">
      <div class="qv-stage">
        <div class="qv-arrow left">
          <asp:LinkButton ID="btnPrev" runat="server" CssClass="btn" OnClick="BtnPrev_Click" CausesValidation="false">←</asp:LinkButton>
        </div>

        <div class="qv-arrow right">
          <asp:LinkButton ID="btnNext" runat="server" CssClass="btn" OnClick="BtnNext_Click" CausesValidation="false">→</asp:LinkButton>
        </div>

        <div class="qv-inner">
          <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:.25rem;">
            <div class="hint">Question #<asp:Literal ID="litId" runat="server" /></div>
            <div class="qv-counter"><asp:Literal ID="litCounter" runat="server" /></div>
          </div>

          <div class="qv-img">
            <asp:Image ID="imgQ" runat="server" Visible="false" />
          </div>

          <div class="qv-text">
            <asp:Literal ID="litQ" runat="server" />
          </div>

          <div class="qv-opts">
            <div id="viewOpt1" runat="server" class="qv-opt">
              1) <asp:Literal ID="litO1" runat="server" />
            </div>
            <div id="viewOpt2" runat="server" class="qv-opt">
              2) <asp:Literal ID="litO2" runat="server" />
            </div>
            <div id="viewOpt3" runat="server" class="qv-opt">
              3) <asp:Literal ID="litO3" runat="server" />
            </div>
            <div id="viewOpt4" runat="server" class="qv-opt">
              4) <asp:Literal ID="litO4" runat="server" />
            </div>
          </div>
        </div>
      </div>

      <!-- Edit dropdown -->
      <div class="qv-edit-toggle">
        <asp:Button ID="btnToggleEdit" runat="server" CssClass="btn" Text="Edit this question"
                    OnClick="BtnToggleEdit_Click" CausesValidation="false" />
      </div>

      <asp:Panel ID="pnlEdit" runat="server" CssClass="qv-edit-panel" Visible="false">
        <asp:HiddenField ID="hfQuestionId" runat="server" />
        <asp:HiddenField ID="hfEditCorrectAnswer" runat="server" />

        <div class="field">
          <label>Question text</label>
          <asp:TextBox ID="txtQ" runat="server" CssClass="input" TextMode="MultiLine" Rows="3" />
        </div>

        <div class="field">
          <label>Replace image (optional)</label>
          <asp:FileUpload ID="fuImg" runat="server" />
          <div class="hint">Leave empty to keep the current image. Tick to remove:</div>
          <asp:CheckBox ID="chkRemove" runat="server" Text="Remove current image" />
        </div>

        <div class="edit-opt-row">
          <div class="edit-opt-card" onclick="qeditSelect(1);">
            <span class="edit-opt-label">Option 1</span>
            <asp:TextBox ID="txtO1" runat="server" CssClass="input" />
            <span class="edit-opt-radio">Click to mark correct</span>
          </div>
          <div class="edit-opt-card" onclick="qeditSelect(2);">
            <span class="edit-opt-label">Option 2</span>
            <asp:TextBox ID="txtO2" runat="server" CssClass="input" />
            <span class="edit-opt-radio">Click to mark correct</span>
          </div>
          <div class="edit-opt-card" onclick="qeditSelect(3);">
            <span class="edit-opt-label">Option 3 (optional)</span>
            <asp:TextBox ID="txtO3" runat="server" CssClass="input" />
            <span class="edit-opt-radio">Click to mark correct</span>
          </div>
          <div class="edit-opt-card" onclick="qeditSelect(4);">
            <span class="edit-opt-label">Option 4 (optional)</span>
            <asp:TextBox ID="txtO4" runat="server" CssClass="input" />
            <span class="edit-opt-radio">Click to mark correct</span>
          </div>
        </div>

        <div class="field" style="margin-top:.75rem;">
          <span class="hint">Correct answer is the highlighted option.</span>
        </div>

        <div style="display:flex; gap:.5rem; justify-content:flex-end;">
          <asp:Button ID="btnUpdate" runat="server" CssClass="btn primary" Text="Save changes"
                      OnClick="BtnUpdate_Click" />
          <asp:Button ID="btnDelete" runat="server" CssClass="btn" Text="Delete question"
                      OnClick="BtnDelete_Click"
                      OnClientClick="return confirm('Delete this question? It must not be linked to any quiz.');" />
        </div>
      </asp:Panel>
    </asp:Panel>
  </div>

  <script type="text/javascript">
    function qeditSelect(idx) {
      var hidden = document.getElementById('<%= hfEditCorrectAnswer.ClientID %>');
      if (!hidden) return;
      hidden.value = idx;

      var cards = document.querySelectorAll('.edit-opt-row .edit-opt-card');
      for (var i = 0; i < cards.length; i++) {
        if (i === idx - 1) {
          cards[i].classList.add('is-correct');
        } else {
          cards[i].classList.remove('is-correct');
        }
      }
    }

    (function () {
      var hidden = document.getElementById('<%= hfEditCorrectAnswer.ClientID %>');
          if (!hidden || !hidden.value) return;
          var idx = parseInt(hidden.value || "1", 10);
          if (!idx || idx < 1 || idx > 4) idx = 1;
          qeditSelect(idx);
      })();
  </script>
</asp:Content>

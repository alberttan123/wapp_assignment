<%@ Page Title="Lecturer • View Questions" Language="C#"
    MasterPageFile="~/Lecturer/Lecturer.Master"
    AutoEventWireup="true"
    CodeBehind="LecturerQuestionViewer.aspx.cs"
    Inherits="WAPP_Assignment.Lecturer.LecturerQuestionViewer" %>

<asp:Content ID="HeadBlock" ContentPlaceHolderID="HeadLecturer" runat="server">
  <link rel="stylesheet" href="<%= ResolveUrl("~/Content/LecturerPages.css") %>" />
  <style>
    @import url('https://fonts.googleapis.com/css2?family=Press+Start+2P&display=swap');
    
    .qv-shell{ 
      max-width:1000px; 
      margin:0 auto; 
      padding: 2rem;
      background: #121a2a;
    }
    
    .qv-topbar{
      display:flex;
      align-items:center;
      justify-content:space-between;
      margin-bottom:2rem;
      padding-bottom:1.5rem;
      border-bottom: 2px solid #23304a;
      flex-wrap: wrap;
      gap: 1rem;
    }
    
    .qv-left-actions{ 
      display:flex; 
      gap:.5rem; 
      align-items:center; 
    }
    
    .qv-left-actions .btn {
      padding: 0.9rem 2rem;
      font-weight: 900;
      font-family: 'Press Start 2P', monospace;
      font-size: 0.7rem;
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
    
    .qv-left-actions .btn:hover {
      background: rgba(15, 20, 34, 0.95);
      border-color: #ffd24a;
      color: #ffd24a;
      transform: translate(2px, 2px);
      box-shadow: 1px 1px 0 rgba(27, 37, 58, 0.8);
    }

    /* --- toggle container --- */
    .qv-toggle{
      display:flex;
      align-items:center;
      gap:.75rem;
      font-size:.9rem;
      color:#9fb0d1;
      font-family: 'Press Start 2P', monospace;
      font-size: 0.6rem;
      text-transform: uppercase;
      letter-spacing: 0.03em;
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
      border-radius: 0;
      background:rgba(15, 20, 34, 0.8);
      border:2px solid #23304a;
      display:flex;
      align-items:center;
      justify-content:space-between;
      padding:0 0.35rem;
      box-sizing:border-box;
      cursor:pointer;
      box-shadow: inset 0 3px 0 rgba(0, 0, 0, 0.3);
    }
    .qv-toggle-thumb{
      position:absolute;
      top:2px;
      left:2px;
      width:1.5rem;
      height:1.3rem;
      border-radius: 0;
      background:#ffd24a;
      transition:transform .18s ease;
      box-shadow: 2px 2px 0 rgba(0, 0, 0, 0.3);
    }
    .qv-toggle-icon{
      position:relative;
      z-index:1;
      font-size:0.8rem;
    }
    .qv-toggle-icon-list{
      color:#e8eefc;
    }
    .qv-toggle-icon-card{
      color:#9fb0d1;
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
      color:#9fb0d1;
    }
    .qv-toggle-input:has(input:checked) ~ .qv-toggle-track .qv-toggle-icon-card{
      color:#e8eefc;
    }

    /* List mode */
    .qv-list-panel{
      background:#121a2a;
      border:2px solid #23304a;
      border-radius: 0;
      padding:1.5rem;
      box-shadow: 0 8px 0 rgba(27, 37, 58, 0.8), 0 12px 24px rgba(0, 0, 0, 0.3);
    }
    .qv-list-row{
      display:flex;
      flex-direction:column;
      gap:1rem;
    }
    .qv-list-card{
      width:100%;
      background:rgba(15, 20, 34, 0.6);
      border:2px solid #23304a;
      border-radius: 0;
      padding:1.25rem;
      display:flex;
      flex-direction:column;
      justify-content:space-between;
      cursor:pointer;
      transition:all 0.2s ease;
      text-align:left;
      text-decoration: none;
      color: inherit;
      box-shadow: inset 0 3px 0 rgba(0, 0, 0, 0.3);
    }
    .qv-list-card:hover{
      border-color:#ffd24a;
      box-shadow: inset 0 3px 0 rgba(0, 0, 0, 0.3), 0 0 20px rgba(255, 210, 74, 0.2);
      background:rgba(15, 20, 34, 0.8);
      transform: translateX(4px);
    }
    .qv-list-text{
      font-size:0.7rem;
      color:#e8eefc;
      margin-bottom:.75rem;
      max-height:4.3rem;
      overflow:hidden;
      font-family: 'Press Start 2P', monospace;
      text-transform: uppercase;
      letter-spacing: 0.03em;
      line-height: 1.5;
    }
    .qv-list-meta{
      font-size:0.6rem;
      color:#9fb0d1;
      display:flex;
      justify-content:space-between;
      font-family: 'Press Start 2P', monospace;
      text-transform: uppercase;
      letter-spacing: 0.03em;
    }

    /* Expanded mode */
    .qv-stage{
      position:relative;
      background:#121a2a;
      border:2px solid #23304a;
      border-radius: 0;
      padding:2rem 4rem;
      margin-bottom:1.5rem;
      box-shadow: 0 8px 0 rgba(27, 37, 58, 0.8), 0 12px 24px rgba(0, 0, 0, 0.3);
    }
    .qv-counter{ 
      color:#9fb0d1; 
      font-size:0.7rem;
      font-family: 'Press Start 2P', monospace;
      text-transform: uppercase;
      letter-spacing: 0.03em;
    }
    .qv-inner{
      background:rgba(15, 20, 34, 0.6);
      border:2px solid #23304a;
      border-radius: 0;
      padding:2rem 1.5rem;
      text-align:center;
      box-shadow: inset 0 3px 0 rgba(0, 0, 0, 0.3);
    }
    .qv-img img{
      max-width:100%;
      height:auto;
      border-radius: 0;
      border:2px solid #23304a;
      margin:.5rem 0 1rem;
      image-rendering: pixelated;
      image-rendering: -moz-crisp-edges;
      image-rendering: crisp-edges;
    }
    .qv-text{
      font-weight:700;
      margin-bottom:1rem;
      color:#e8eefc;
      font-family: 'Press Start 2P', monospace;
      font-size: 0.7rem;
      text-transform: uppercase;
      letter-spacing: 0.03em;
      line-height: 1.6;
    }
    .qv-opts{
      display:grid;
      grid-template-columns:repeat(4,minmax(0,1fr));
      gap:1rem;
      margin-top:1rem;
    }
    .qv-opt{
      background:rgba(15, 20, 34, 0.8);
      border:2px solid #23304a;
      border-radius: 0;
      padding:1rem;
      color:#9fb0d1;
      font-family: 'Press Start 2P', monospace;
      font-size: 0.6rem;
      text-transform: uppercase;
      letter-spacing: 0.03em;
      box-shadow: inset 0 3px 0 rgba(0, 0, 0, 0.3);
      transition: all 0.2s ease;
    }
    .qv-opt.is-correct{
      border-color:#ffd24a;
      background:rgba(255,210,74,.15);
      color:#ffd24a;
      font-weight:600;
      box-shadow: inset 0 3px 0 rgba(0, 0, 0, 0.3), 0 0 20px rgba(255, 210, 74, 0.3);
    }

    .qv-arrow{
      position:absolute;
      top:0;
      bottom:0;
      width:3.5rem;
      display:flex;
      align-items:center;
      justify-content:center;
    }
    .qv-arrow.left{ left:0.5rem; }
    .qv-arrow.right{ right:0.5rem; }
    .qv-arrow .btn{
      min-width:3rem;
      height:3rem;
      border-radius: 0;
      padding:0;
      font-family: 'Press Start 2P', monospace;
      font-size: 1rem;
      border: 2px solid #23304a;
      background: rgba(15, 20, 34, 0.8);
      color: #e8eefc;
      box-shadow: 3px 3px 0 rgba(27, 37, 58, 0.8);
      transition: all 0.2s ease;
    }
    .qv-arrow .btn:hover {
      border-color: #ffd24a;
      color: #ffd24a;
      transform: translate(2px, 2px);
      box-shadow: 1px 1px 0 rgba(27, 37, 58, 0.8);
    }

    /* Edit dropdown */
    .qv-edit-toggle{
      display:flex;
      justify-content:flex-end;
      margin-bottom:1rem;
    }
    .qv-edit-toggle .btn {
      padding: 0.9rem 2rem;
      font-weight: 900;
      font-family: 'Press Start 2P', monospace;
      font-size: 0.7rem;
      cursor: pointer;
      transition: all 0.2s ease;
      text-transform: uppercase;
      letter-spacing: 0.08em;
      border-radius: 0;
      border: 2px solid #23304a;
      background: rgba(15, 20, 34, 0.8);
      color: #e8eefc;
      box-shadow: 3px 3px 0 rgba(27, 37, 58, 0.8);
    }
    .qv-edit-toggle .btn:hover {
      background: rgba(15, 20, 34, 0.95);
      border-color: #ffd24a;
      color: #ffd24a;
      transform: translate(2px, 2px);
      box-shadow: 1px 1px 0 rgba(27, 37, 58, 0.8);
    }
    .qv-edit-panel{
      background:#121a2a;
      border:2px dashed #23304a;
      border-radius: 0;
      padding:2rem;
      margin-top:1rem;
      box-shadow: 0 8px 0 rgba(27, 37, 58, 0.8), 0 12px 24px rgba(0, 0, 0, 0.3);
    }
    .field{ 
      display:flex; 
      flex-direction:column; 
      gap:.5rem; 
      margin-bottom:1.5rem; 
    }
    .field label {
      font-size: 0.7rem;
      color: #e8eefc;
      font-family: 'Press Start 2P', monospace;
      text-transform: uppercase;
      letter-spacing: 0.05em;
      font-weight: 400;
    }
    .field .input,
    .field input[type="text"],
    .field textarea {
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
      width: 100%;
      box-sizing: border-box;
    }
    .field .input:focus,
    .field input[type="text"]:focus,
    .field textarea:focus {
      outline: none;
      background: rgba(15, 20, 34, 0.95);
      border-color: #ffd24a;
      box-shadow: inset 0 3px 0 rgba(0, 0, 0, 0.3), 0 0 25px rgba(255, 210, 74, 0.25);
    }
    .field input[type="checkbox"] {
      width: 18px;
      height: 18px;
      cursor: pointer;
      accent-color: #ffd24a;
    }
    .field label[for] {
      display: flex;
      align-items: center;
      gap: 0.5rem;
      cursor: pointer;
    }
    .grid2{ display:grid; grid-template-columns:1fr 1fr; gap:.5rem; }
    .hint{ 
      color:#9fb0d1; 
      font-size:0.65rem;
      font-family: 'Press Start 2P', monospace;
      text-transform: uppercase;
      letter-spacing: 0.03em;
    }

    .edit-opt-row{
      display:grid;
      grid-template-columns:repeat(4,minmax(0,1fr));
      gap:1rem;
      margin-top:1.5rem;
    }
    .edit-opt-card{
      cursor:pointer;
      background:rgba(15, 20, 34, 0.6);
      border:2px solid #23304a;
      border-radius: 0;
      padding:1rem;
      display:flex;
      flex-direction:column;
      align-items:center;
      gap:.5rem;
      transition:all 0.2s ease;
      box-shadow: inset 0 3px 0 rgba(0, 0, 0, 0.3);
    }
    .edit-opt-card .input{ 
      text-align:center;
      padding: 0.75rem;
      background: rgba(15, 20, 34, 0.8);
      border: 2px solid #23304a;
      border-radius: 0;
      color: #e8eefc;
      font-family: Poppins, system-ui, Segoe UI, Arial, sans-serif;
      font-size: 0.9rem;
      font-weight: 600;
      box-shadow: inset 0 3px 0 rgba(0, 0, 0, 0.3);
      width: 100%;
      box-sizing: border-box;
    }
    .edit-opt-card .input:focus {
      outline: none;
      border-color: #ffd24a;
      box-shadow: inset 0 3px 0 rgba(0, 0, 0, 0.3), 0 0 15px rgba(255, 210, 74, 0.2);
    }
    .edit-opt-label{ 
      font-size:0.65rem; 
      color:#9fb0d1;
      font-family: 'Press Start 2P', monospace;
      text-transform: uppercase;
      letter-spacing: 0.03em;
    }
    .edit-opt-radio{ 
      font-size:0.6rem; 
      color:#9fb0d1;
      font-family: 'Press Start 2P', monospace;
      text-transform: uppercase;
      letter-spacing: 0.03em;
    }
    .edit-opt-card.is-correct{
      border-color:#ffd24a;
      box-shadow: inset 0 3px 0 rgba(0, 0, 0, 0.3), 0 0 20px rgba(255, 210, 74, 0.3);
      background:rgba(255,210,74,.15);
    }
    .edit-opt-card.is-correct .edit-opt-radio{
      color:#ffd24a;
      font-weight:600;
    }
    .qv-edit-panel .btn {
      padding: 0.9rem 2rem;
      font-weight: 900;
      font-family: 'Press Start 2P', monospace;
      font-size: 0.7rem;
      cursor: pointer;
      transition: all 0.2s ease;
      text-transform: uppercase;
      letter-spacing: 0.08em;
      border-radius: 0;
      border: 2px solid #23304a;
      background: rgba(15, 20, 34, 0.8);
      color: #e8eefc;
      box-shadow: 3px 3px 0 rgba(27, 37, 58, 0.8);
    }
    .qv-edit-panel .btn:hover {
      background: rgba(15, 20, 34, 0.95);
      border-color: #ffd24a;
      color: #ffd24a;
      transform: translate(2px, 2px);
      box-shadow: 1px 1px 0 rgba(27, 37, 58, 0.8);
    }
    .qv-edit-panel .btn.primary {
      background: #ffd24a;
      color: #0b0f1a;
      border-color: #ffd24a;
      box-shadow: 4px 4px 0 #b89200;
    }
    .qv-edit-panel .btn.primary:hover {
      background: #ffdc6a;
      transform: translate(2px, 2px);
      box-shadow: 2px 2px 0 #b89200;
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
      <div class="hint" style="margin-bottom:1rem;">
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
          <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:1rem;">
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

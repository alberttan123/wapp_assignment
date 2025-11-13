<%@ Page Title="Lecturer • View Question" Language="C#"
    MasterPageFile="~/Lecturer/Lecturer.Master"
    AutoEventWireup="true"
    CodeBehind="LecturerQuestionViewer.aspx.cs"
    Inherits="WAPP_Assignment.Lecturer.LecturerQuestionViewer" %>

<asp:Content ID="HeadBlock" ContentPlaceHolderID="HeadLecturer" runat="server">
  <link rel="stylesheet" href="<%= ResolveUrl("~/Content/LecturerPages.css") %>" />
  <style>
    .qv-shell{ max-width:1000px; margin:0 auto; }
    .qv-topbar{ display:flex; align-items:center; justify-content:space-between; margin-bottom:.75rem; }
    .qv-counter{ color:var(--muted); }
    .qv-stage{ position:relative; background:var(--panel-2); border:1px solid var(--line);
               border-radius:12px; padding:1rem; min-height:360px; display:flex; align-items:center; justify-content:center; }
    .qv-inner{ width:100%; max-width:780px; background:var(--panel); border:1px solid var(--line);
               border-radius:10px; padding:1rem; text-align:center; }
    .qv-img img{ max-width:100%; height:auto; border-radius:8px; border:1px solid var(--line); margin:.25rem 0 .5rem; }
    .qv-text{ font-weight:700; margin-bottom:.5rem; }
    .qv-opts{ display:grid; grid-template-columns:repeat(4,minmax(0,1fr)); gap:.75rem; margin-top:.5rem; }
    .qv-opt{ background:var(--panel-2); border:1px solid var(--line); border-radius:10px; padding:.6rem; color:var(--muted); }

    .qv-arrow{ position:absolute; top:0; bottom:0; width:3rem; display:flex; align-items:center; justify-content:center; }
    .qv-arrow.left{ left:.25rem; } .qv-arrow.right{ right:.25rem; }
    .qv-arrow .btn{ min-width:2.5rem; height:2.5rem; border-radius:999px; }

    .qv-edit{ margin-top:1rem; background:var(--bg-2); border:1px dashed var(--line); border-radius:10px; padding:1rem; }
    .grid2{ display:grid; grid-template-columns:1fr 1fr; gap:.5rem; }
    .field{ display:flex; flex-direction:column; gap:.25rem; margin-bottom:.5rem; }
    .hint{ color:var(--muted); font-size:.875rem; }
  </style>
</asp:Content>

<asp:Content ID="MainBlock" ContentPlaceHolderID="LecturerMain" runat="server">
  <div class="qv-shell">

    <div class="qv-topbar">
      <div style="display:flex; gap:.5rem;">
        <a class="btn" href="<%= ResolveUrl("~/Lecturer/LecturerQuestionAdd.aspx") %>">Add New</a>
        <a class="btn" href="<%= ResolveUrl("~/Lecturer/LecturerQuestions.aspx") %>">Back to Questions List</a>
      </div>
      <div class="qv-counter"><asp:Literal ID="litCounter" runat="server" /></div>
    </div>

    <div class="qv-stage">
      <div class="qv-arrow left">
        <asp:LinkButton ID="btnPrev" runat="server" CssClass="btn" OnClick="BtnPrev_Click" CausesValidation="false">←</asp:LinkButton>
      </div>

      <div class="qv-inner">
        <div class="qv-img">
          <asp:Image ID="imgQ" runat="server" Visible="false" />
        </div>
        <div class="qv-text"><asp:Literal ID="litQ" runat="server" /></div>

        <div class="qv-opts">
          <div class="qv-opt">1) <asp:Literal ID="litO1" runat="server" /></div>
          <div class="qv-opt">2) <asp:Literal ID="litO2" runat="server" /></div>
          <div class="qv-opt">3) <asp:Literal ID="litO3" runat="server" /></div>
          <div class="qv-opt">4) <asp:Literal ID="litO4" runat="server" /></div>
        </div>
        <div class="hint" style="margin-top:.5rem;">Correct Answer: <asp:Literal ID="litAns" runat="server" /></div>
      </div>

      <div class="qv-arrow right">
        <asp:LinkButton ID="btnNext" runat="server" CssClass="btn" OnClick="BtnNext_Click" CausesValidation="false">→</asp:LinkButton>
      </div>
    </div>

    <!-- Edit panel for the current question -->
    <div class="qv-edit">
      <asp:Label ID="lblMsg" runat="server" CssClass="muted" Visible="false" />
      <asp:HiddenField ID="hidQuestionId" runat="server" />

      <div class="field">
        <label>Question Text</label>
        <asp:TextBox ID="txtQ" runat="server" CssClass="input" TextMode="MultiLine" Rows="3" />
      </div>

      <div class="field">
        <label>Replace Image (optional)</label>
        <asp:FileUpload ID="fuImg" runat="server" />
        <div class="hint">Leave empty to keep current. Tick to remove:</div>
        <asp:CheckBox ID="chkRemove" runat="server" Text="Remove current image" />
      </div>

      <div class="grid2">
        <div class="field"><label>Option 1</label><asp:TextBox ID="txtO1" runat="server" CssClass="input" /></div>
        <div class="field"><label>Option 2</label><asp:TextBox ID="txtO2" runat="server" CssClass="input" /></div>
        <div class="field"><label>Option 3 (optional)</label><asp:TextBox ID="txtO3" runat="server" CssClass="input" /></div>
        <div class="field"><label>Option 4 (optional)</label><asp:TextBox ID="txtO4" runat="server" CssClass="input" /></div>
      </div>

      <div class="field">
        <label>Correct Answer (1–4)</label>
        <asp:DropDownList ID="ddlAns" runat="server" CssClass="select">
          <asp:ListItem Text="1" Value="1" /><asp:ListItem Text="2" Value="2" />
          <asp:ListItem Text="3" Value="3" /><asp:ListItem Text="4" Value="4" />
        </asp:DropDownList>
      </div>

      <div style="display:flex; gap:.5rem; justify-content:flex-end;">
        <asp:Button ID="btnUpdate" runat="server" CssClass="btn primary" Text="Update" OnClick="BtnUpdate_Click" />
        <asp:Button ID="btnDelete" runat="server" CssClass="btn" Text="Delete" OnClick="BtnDelete_Click"
                    OnClientClick="return confirm('Delete this question? It must not be linked to any quiz.');" />
      </div>
    </div>

  </div>
</asp:Content>

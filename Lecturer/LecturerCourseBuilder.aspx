<%@ Page Title="Lecturer • Course Builder" Language="C#"
    MasterPageFile="~/Lecturer/Lecturer.Master"
    AutoEventWireup="true"
    CodeBehind="LecturerCourseBuilder.aspx.cs"
    Inherits="WAPP_Assignment.Lecturer.LecturerCourseBuilder" %>

<asp:Content ID="HeadBlock" ContentPlaceHolderID="HeadLecturer" runat="server">
  <link rel="stylesheet" href="<%= ResolveUrl("~/Content/LecturerPages.css") %>" />
  <style>
    @import url('https://fonts.googleapis.com/css2?family=Press+Start+2P&display=swap');
    
    .cb-shell {
      max-width: 900px;
      margin: 0 auto;
      padding: 2rem;
      background: #121a2a;
      min-height: 100vh;
    }

    .cb-back-button {
      display: inline-flex;
      align-items: center;
      gap: 0.5rem;
      color: #ffd24a;
      text-decoration: none;
      font-size: 1.1rem;
      font-weight: 700;
      margin-bottom: 2rem;
      transition: all 0.2s ease;
      font-family: 'Press Start 2P', monospace;
      font-size: 0.7rem;
      text-transform: uppercase;
      letter-spacing: 0.05em;
    }

    .cb-back-button:hover {
      color: #ffffff;
      transform: translateX(-3px);
    }

    .cb-title {
      font-size: 2rem;
      font-weight: 900;
      color: #ffd24a;
      margin-bottom: 2rem;
      font-family: 'Press Start 2P', monospace;
      font-size: 1.2rem;
      text-shadow: 3px 3px 0 rgba(0, 0, 0, 0.5);
      letter-spacing: 0.05em;
    }

    .cb-form-section {
      background: #121a2a;
      border: 2px solid #23304a;
      border-radius: 16px;
      padding: 2.5rem;
      margin-bottom: 2rem;
      box-shadow: 0 8px 0 rgba(27, 37, 58, 0.8), 0 12px 24px rgba(0, 0, 0, 0.3);
      position: relative;
    }

    .cb-form-section * {
      box-sizing: border-box;
    }

    .cb-form-section::before {
      content: '📚';
      position: absolute;
      font-size: 8rem;
      opacity: 0.03;
      right: -1rem;
      top: 50%;
      transform: translateY(-50%) rotate(-15deg);
      pointer-events: none;
      z-index: 0;
    }

    .cb-form-section > * {
      position: relative;
      z-index: 2;
    }

    .cb-field {
      display: flex;
      flex-direction: column;
      gap: 0.75rem;
      margin-bottom: 2rem;
      width: 100%;
      margin-left: 0;
      margin-right: 0;
    }

    .cb-field > *:not(label):not(.cb-hint) {
      width: 100% !important;
      max-width: 100% !important;
    }

    .cb-field:last-child {
      margin-bottom: 0;
    }

    .cb-field label {
      font-size: 0.95rem;
      font-weight: 700;
      color: #e8eefc;
      text-transform: uppercase;
      letter-spacing: 0.06em;
      display: flex;
      align-items: center;
      gap: 0.5rem;
      text-shadow: 1px 1px 0 rgba(0, 0, 0, 0.3);
    }

    .cb-field label.required::after {
      content: '*';
      color: #ff6b6b;
      margin-left: 0.25rem;
    }

    .cb-field input[type="text"],
    .cb-field textarea,
    .cb-field select,
    .cb-select-wrapper select {
      padding: 1rem 1.25rem !important;
      background: rgba(15, 20, 34, 0.8) !important;
      border: 2px solid #23304a !important;
      border-radius: 10px !important;
      color: #e8eefc !important;
      font-family: Poppins, system-ui, Segoe UI, Arial, sans-serif !important;
      font-size: 1rem !important;
      font-weight: 600 !important;
      transition: all 0.2s ease;
      box-shadow: inset 0 3px 0 rgba(0, 0, 0, 0.3), 0 2px 0 rgba(27, 37, 58, 0.5) !important;
      width: 100% !important;
      box-sizing: border-box !important;
      margin: 0 !important;
      display: block !important;
    }

    .cb-field input[type="text"]:focus,
    .cb-field textarea:focus,
    .cb-field select:focus {
      outline: none;
      background: rgba(15, 20, 34, 0.95);
      border-color: #ffd24a;
      box-shadow: inset 0 3px 0 rgba(0, 0, 0, 0.3), 0 0 25px rgba(255, 210, 74, 0.25);
      transform: translateY(-1px);
    }

    .cb-field input[type="text"]::placeholder,
    .cb-field textarea::placeholder {
      color: rgba(159, 176, 209, 0.5);
      font-weight: 600;
      opacity: 1;
    }

    .cb-field textarea {
      min-height: 150px;
      resize: vertical;
      line-height: 1.7;
    }

    .cb-hint {
      font-size: 0.85rem;
      color: #9fb0d1;
      font-weight: 500;
      margin-top: 0.25rem;
    }

    /* Rich Text Editor Toolbar */
    .cb-rich-editor-wrapper {
      display: flex;
      flex-direction: column;
      gap: 0.5rem;
    }

    .cb-toolbar {
      display: flex;
      gap: 0.5rem;
      padding: 0.75rem;
      background: rgba(15, 20, 34, 0.6);
      border: 2px solid #23304a;
      border-radius: 10px;
      flex-wrap: wrap;
    }

    .cb-toolbar button {
      background: rgba(27, 37, 58, 0.8);
      border: 1px solid #23304a;
      color: #e8eefc;
      padding: 0.5rem 0.75rem;
      border-radius: 6px;
      cursor: pointer;
      font-weight: 700;
      font-size: 0.9rem;
      transition: all 0.2s ease;
      font-family: Poppins, system-ui, Segoe UI, Arial, sans-serif;
    }

    .cb-toolbar button:hover {
      background: #23304a;
      border-color: #ffd24a;
      color: #ffd24a;
      transform: translateY(-1px);
    }

    .cb-toolbar button.active {
      background: #ffd24a;
      color: #0b0f1a;
      border-color: #ffd24a;
    }

    /* File Upload Areas */
    .cb-upload-section {
      margin-top: 2rem;
    }

    .cb-upload-area {
      border: 2px dashed #9fb0d1;
      border-radius: 0;
      padding: 4rem 2rem;
      text-align: center;
      background: rgba(15, 20, 34, 0.2);
      transition: all 0.3s ease;
      cursor: pointer;
      position: relative;
      margin-top: 1rem;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      gap: 1rem;
      min-height: 200px;
    }

    .cb-upload-area:hover {
      border-color: #ffd24a;
      background: rgba(15, 20, 34, 0.4);
    }

    .cb-upload-area.dragover {
      border-color: #ffd24a;
      background: rgba(255, 210, 74, 0.1);
      transform: scale(1.02);
    }

    .cb-upload-icon {
      width: 120px;
      height: 90px;
      margin: 0 auto 1.5rem;
      display: block;
      position: relative;
    }

    .cb-upload-icon svg {
      width: 100%;
      height: 100%;
      display: block;
      image-rendering: pixelated;
      image-rendering: -moz-crisp-edges;
      image-rendering: crisp-edges;
    }

    .cb-upload-text {
      color: #94a3b8;
      font-size: 0.7rem;
      font-weight: 400;
      margin-bottom: 1rem;
      font-family: 'Press Start 2P', monospace;
      text-transform: uppercase;
      letter-spacing: 0.05em;
      line-height: 1.5;
    }

    .cb-upload-button {
      background: #1e293b;
      color: #475569;
      border: 2px solid #94a3b8;
      padding: 1rem 2.5rem;
      font-weight: 400;
      font-family: 'Press Start 2P', monospace;
      font-size: 0.6rem;
      cursor: pointer;
      transition: all 0.2s ease;
      text-transform: uppercase;
      letter-spacing: 0.08em;
      box-shadow: 4px 4px 0 rgba(148, 163, 184, 0.4);
      border-radius: 0;
      display: inline-block;
      position: relative;
      image-rendering: pixelated;
      image-rendering: -moz-crisp-edges;
      image-rendering: crisp-edges;
    }

    .cb-upload-button:hover {
      background: #1e293b;
      color: #64748b;
      border-color: #94a3b8;
      transform: translate(2px, 2px);
      box-shadow: 2px 2px 0 rgba(148, 163, 184, 0.4);
    }

    .cb-upload-button:active {
      transform: translate(4px, 4px);
      box-shadow: 0 0 0 rgba(148, 163, 184, 0.4);
    }

    .cb-file-input-hidden {
      display: none;
    }

    .cb-preview-image {
      margin-top: 1rem;
      max-width: 100%;
      border-radius: 8px;
      border: 2px solid #23304a;
      box-shadow: 0 4px 0 rgba(27, 37, 58, 0.5);
    }

    .cb-checkbox-wrapper {
      display: flex;
      align-items: center;
      gap: 0.5rem;
      margin-top: 0.75rem;
    }

    .cb-checkbox-wrapper input[type="checkbox"] {
      width: 18px;
      height: 18px;
      cursor: pointer;
    }

    .cb-checkbox-wrapper label {
      font-size: 0.9rem;
      font-weight: 600;
      color: #e8eefc;
      text-transform: none;
      cursor: pointer;
    }

    /* Actions Row */
    .cb-actions-row {
      display: flex;
      justify-content: flex-end;
      gap: 1rem;
      margin-top: 2rem;
      padding-top: 2rem;
      border-top: 2px solid #1b253a;
    }

    .cb-btn {
      padding: 0.9rem 2rem;
      font-weight: 900;
      font-size: 0.95rem;
      font-family: 'Press Start 2P', monospace;
      font-size: 0.7rem;
      cursor: pointer;
      transition: all 0.2s ease;
      text-transform: uppercase;
      letter-spacing: 0.08em;
      border-radius: 10px;
      border: none;
    }

    .cb-btn.delete {
      background: #ff6b6b;
      color: #ffffff;
      box-shadow: 0 4px 0 #d9005f;
    }

    .cb-btn.delete:hover {
      background: #ff8787;
      transform: translateY(2px);
      box-shadow: 0 2px 0 #d9005f;
    }

    .cb-btn.primary {
      background: #ffd24a;
      color: #0b0f1a;
      box-shadow: 0 4px 0 #b89200;
    }

    .cb-btn.primary:hover {
      background: #ffdc6a;
      transform: translateY(2px);
      box-shadow: 0 2px 0 #b89200;
    }

    .cb-btn.primary:active {
      transform: translateY(4px);
      box-shadow: 0 1px 0 #b89200;
    }

    .cb-status {
      padding: 1rem;
      background: rgba(255, 107, 107, 0.2);
      border: 2px solid #ff6b6b;
      color: #ff6b6b;
      border-radius: 10px;
      font-weight: 700;
      margin-bottom: 1rem;
      text-transform: uppercase;
      letter-spacing: 0.05em;
    }

    .cb-select-wrapper {
      position: relative;
      width: 100%;
      margin: 0;
      padding: 0;
    }

    .cb-select-wrapper select,
    .cb-field select {
      appearance: none;
      -webkit-appearance: none;
      -moz-appearance: none;
      background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%23ffd24a' d='M6 9L1 4h10z'/%3E%3C/svg%3E");
      background-repeat: no-repeat;
      background-position: right 1rem center;
      padding-right: 3rem;
      width: 100%;
      box-sizing: border-box;
      margin: 0;
    }

    /* Tags Input */
    .cb-tags-input {
      display: flex;
      flex-wrap: wrap;
      gap: 0.5rem;
      padding: 1rem 1.25rem !important;
      background: rgba(15, 20, 34, 0.8) !important;
      border: 2px solid #23304a !important;
      border-radius: 10px !important;
      min-height: 60px;
      width: 100% !important;
      max-width: 100% !important;
      box-sizing: border-box !important;
      margin: 0 !important;
      align-items: flex-start;
    }

    .cb-tag {
      background: #ffd24a;
      color: #0b0f1a;
      padding: 0.4rem 0.75rem;
      border-radius: 6px;
      font-size: 0.85rem;
      font-weight: 700;
      display: inline-flex;
      align-items: center;
      gap: 0.5rem;
    }

    .cb-tag-remove {
      cursor: pointer;
      font-weight: 900;
    }

    .cb-tags-input input {
      border: none;
      background: transparent;
      color: #e8eefc;
      font-size: 1rem;
      flex: 1;
      min-width: 200px;
      outline: none;
      padding: 0;
    }

    @media (max-width: 768px) {
      .cb-shell {
        padding: 1rem;
      }

      .cb-form-section {
        padding: 1.5rem;
      }

      .cb-actions-row {
        flex-direction: column;
      }

      .cb-btn {
        width: 100%;
      }
    }
  </style>
  <script>
    // File upload drag and drop
    function setupDragDrop(uploadAreaId, fileInputId) {
      const uploadArea = document.getElementById(uploadAreaId);
      const fileInput = document.getElementById(fileInputId);

      if (!uploadArea || !fileInput) return;

      ['dragenter', 'dragover', 'dragleave', 'drop'].forEach(eventName => {
        uploadArea.addEventListener(eventName, preventDefaults, false);
      });

      function preventDefaults(e) {
        e.preventDefault();
        e.stopPropagation();
      }

      ['dragenter', 'dragover'].forEach(eventName => {
        uploadArea.addEventListener(eventName, () => {
          uploadArea.classList.add('dragover');
        }, false);
      });

      ['dragleave', 'drop'].forEach(eventName => {
        uploadArea.addEventListener(eventName, () => {
          uploadArea.classList.remove('dragover');
        }, false);
      });

      uploadArea.addEventListener('drop', (e) => {
        const dt = e.dataTransfer;
        const files = dt.files;
        fileInput.files = files;
        if (files.length > 0) {
          const fileName = files[0].name;
          uploadArea.querySelector('.cb-upload-text').textContent = 'File selected: ' + fileName;
        }
      }, false);

      uploadArea.addEventListener('click', (e) => {
        if (e.target.classList.contains('cb-upload-button')) {
          return; // Let the button's onclick handle it
        }
        fileInput.click();
      });

      fileInput.addEventListener('change', (e) => {
        if (e.target.files.length > 0) {
          const fileName = e.target.files[0].name;
          uploadArea.querySelector('.cb-upload-text').textContent = 'File selected: ' + fileName;
        }
      });
    }

    // Tags functionality
    function addTag(inputId, containerId) {
      const input = document.getElementById(inputId);
      const container = document.getElementById(containerId);
      const tagText = input.value.trim();

      if (tagText && !container.querySelector(`[data-tag="${tagText}"]`)) {
        const tag = document.createElement('span');
        tag.className = 'cb-tag';
        tag.setAttribute('data-tag', tagText);
        tag.innerHTML = tagText + '<span class="cb-tag-remove" onclick="removeTag(this)">×</span>';
        container.insertBefore(tag, input);
        input.value = '';
      }
    }

    function removeTag(element) {
      element.parentElement.remove();
    }

    window.onload = function() {
      setupDragDrop('coverUploadArea', '<%= fuCourseImg.ClientID %>');
    };
  </script>
</asp:Content>

<asp:Content ID="MainBlock" ContentPlaceHolderID="LecturerMain" runat="server">
  <div class="cb-shell">
    <a href="<%= ResolveUrl("~/Lecturer/LecturerCourses.aspx") %>" class="cb-back-button">
      <span>&lt;</span> Back to Courses
    </a>

    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem;">
      <div class="cb-title" style="margin: 0;">Course Builder</div>
      <asp:Button ID="btnNewCourse" runat="server" CssClass="cb-btn primary" Text="New Course"
                  OnClick="BtnNewCourse_Click" CausesValidation="false" />
    </div>

    <asp:Label ID="lblStatus" runat="server" CssClass="cb-status" Visible="false" />

    <div class="cb-form-section">
      <div class="cb-field">
        <label>Select existing course</label>
        <div class="cb-select-wrapper">
          <asp:DropDownList ID="ddlCourses" runat="server"
                            AutoPostBack="true" OnSelectedIndexChanged="DdlCourses_SelectedIndexChanged" />
        </div>
      </div>

      <asp:HiddenField ID="hfCourseId" runat="server" />
      <asp:HiddenField ID="hfCurrentCourseImgUrl" runat="server" />

      <div class="cb-field">
        <label class="required">Course Title</label>
        <asp:TextBox ID="txtCourseTitle" runat="server" placeholder="Project Name" />
      </div>

      <div class="cb-field">
        <label class="required">Course Description</label>
        <asp:TextBox ID="txtCourseDescription" runat="server" 
                     TextMode="MultiLine" Rows="6" 
                     placeholder="Summary about your wonderful project!" />
      </div>

      <div class="cb-field">
        <label>Tags</label>
        <div class="cb-tags-input" id="tagsContainer">
          <input type="text" id="tagInput" placeholder="Type and press Enter to add tag" 
                 onkeypress="if(event.key==='Enter') { event.preventDefault(); addTag('tagInput', 'tagsContainer'); }" />
        </div>
      </div>

      <div class="cb-upload-section">
        <div class="cb-field">
          <label class="required">Cover Image</label>
          <span class="cb-hint">Add a thumbnail image for your course. This will appear when your course is displayed in the Course Showcase page and other areas of the site.</span>
          <div class="cb-upload-area" id="coverUploadArea">
            <div class="cb-upload-icon">
              <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 32 32" fill="none" style="image-rendering: pixelated; image-rendering: -moz-crisp-edges; image-rendering: crisp-edges;">
                <path fill-rule="evenodd" clip-rule="evenodd" d="M13.3333 5.33301H21.3333V7.99967H13.3333V5.33301ZM10.6667 10.6663V7.99967H13.3333V10.6663H10.6667ZM5.33333 13.333V10.6663H10.6667V13.333H5.33333ZM2.66667 15.9997V13.333H5.33333V15.9997H2.66667ZM2.66667 23.9997H0L0 15.9997H2.66667V23.9997ZM2.66667 23.9997H12V26.6663H2.66667V23.9997ZM24 10.6663H21.3333V7.99967H24V10.6663ZM29.3333 15.9997H26.6667H24V13.333V10.6663H26.6667V13.333H29.3333V15.9997ZM29.3333 23.9997V15.9997H32V23.9997H29.3333ZM29.3333 23.9997V26.6663H20V23.9997H29.3333ZM14.6667 11.9997H17.3333V14.6663H20V17.333L22.6667 17.333V19.9997H17.3333V26.6663H14.6667V19.9997H9.33333V17.333L12 17.333V14.6663H14.6667V11.9997Z" fill="#94A3B8"></path>
              </svg>
            </div>
            <div class="cb-upload-text">Drag and Drop or</div>
            <button type="button" class="cb-upload-button" onclick="document.getElementById('<%= fuCourseImg.ClientID %>').click(); return false;">Upload Media</button>
            <asp:FileUpload ID="fuCourseImg" runat="server" CssClass="cb-file-input-hidden" />
          </div>
          <div class="cb-checkbox-wrapper">
            <asp:CheckBox ID="chkRemoveImg" runat="server" />
            <label for="<%= chkRemoveImg.ClientID %>">Remove current image</label>
          </div>
          <asp:Image ID="imgPreview" runat="server" Visible="false" CssClass="cb-preview-image" />
        </div>
      </div>

      <div class="cb-actions-row">
        <asp:Button ID="btnDeleteCourse" runat="server" CssClass="cb-btn delete" Text="Delete"
                    OnClick="BtnDeleteCourse_Click"
                    OnClientClick="return confirm('Delete this course and all its chapters? This cannot be undone.');"
                    CausesValidation="false" />
        <asp:Button ID="btnSaveCourse" runat="server" CssClass="cb-btn primary" Text="Save Course"
                    OnClick="BtnSaveCourse_Click" />
      </div>
    </div>
  </div>
</asp:Content>

<%@ Page Title="Lecturer • Course Editor" Language="C#"
    MasterPageFile="~/Lecturer/Lecturer.Master"
    AutoEventWireup="true"
    CodeBehind="LecturerCourseEditor.aspx.cs"
    Inherits="WAPP_Assignment.Lecturer.LecturerCourseEditor" %>

<asp:Content ID="HeadBlock" ContentPlaceHolderID="HeadLecturer" runat="server">
    <link rel="stylesheet" href="<%= ResolveUrl("~/Content/LecturerPages.css") %>" />
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Press+Start+2P&display=swap');
        
        .ce-shell {
            max-width: 1000px;
            margin: 0 auto;
            display: flex;
            flex-direction: column;
            gap: 1.5rem;
        }

        .ce-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 1.5rem;
            margin-bottom: 1rem;
            flex-wrap: wrap;
        }

        .ce-title {
            margin: 0 0 0.5rem 0;
            font-size: 1.2rem;
            font-weight: 400;
            color: #ffd24a;
            font-family: 'Press Start 2P', monospace;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            text-shadow: 3px 3px 0 rgba(0, 0, 0, 0.5);
        }

        .ce-subtitle {
            font-size: 0.65rem;
            color: #9fb0d1;
            font-family: 'Press Start 2P', monospace;
            text-transform: uppercase;
            letter-spacing: 0.03em;
        }

        .ce-actions {
            display: flex;
            gap: 1rem;
            align-items: center;
            flex-wrap: wrap;
        }

        .ce-actions .btn {
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

        .ce-actions .btn:hover {
            background: rgba(15, 20, 34, 0.95);
            border-color: #ffd24a;
            color: #ffd24a;
            transform: translate(2px, 2px);
            box-shadow: 1px 1px 0 rgba(27, 37, 58, 0.8);
        }

        .ce-actions .btn:active {
            transform: translate(3px, 3px);
            box-shadow: 0 0 0 rgba(27, 37, 58, 0.8);
        }

        .ce-card {
            background: #121a2a;
            border: 2px solid #23304a;
            border-radius: 0;
            padding: 1.5rem;
            box-shadow: 0 8px 0 rgba(27, 37, 58, 0.8), 0 12px 24px rgba(0, 0, 0, 0.3);
        }

        .ce-card-header {
            margin-bottom: 1.5rem;
        }

        .ce-card-title {
            font-size: 0.8rem;
            font-weight: 400;
            color: #ffd24a;
            margin-bottom: 0.5rem;
            font-family: 'Press Start 2P', monospace;
            text-transform: uppercase;
            letter-spacing: 0.03em;
        }

        .ce-card-meta {
            font-size: 0.65rem;
            color: #9fb0d1;
            font-family: 'Press Start 2P', monospace;
            text-transform: uppercase;
            letter-spacing: 0.03em;
            line-height: 1.5;
        }

        .ce-chapter-row {
            display: grid;
            grid-template-columns: auto minmax(0, 1fr) auto;
            gap: 1rem;
            align-items: flex-start;
            background: rgba(15, 20, 34, 0.8);
            border: 2px solid #23304a;
            border-radius: 0;
            padding: 1.25rem;
            margin-bottom: 1rem;
            box-shadow: inset 0 3px 0 rgba(0, 0, 0, 0.3);
        }

        .ce-chapter-order {
            font-size: 0.7rem;
            color: #9fb0d1;
            padding: 0.5rem 0.75rem;
            font-family: 'Press Start 2P', monospace;
            text-transform: uppercase;
            letter-spacing: 0.03em;
            background: rgba(15, 20, 34, 0.6);
            border: 2px solid #23304a;
            box-shadow: inset 0 2px 0 rgba(0, 0, 0, 0.3);
            white-space: nowrap;
        }

        .ce-chapter-main {
            display: flex;
            flex-direction: column;
            gap: 1rem;
        }

        .field {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }

        .field label {
            font-size: 0.65rem;
            color: #9fb0d1;
            font-family: 'Press Start 2P', monospace;
            text-transform: uppercase;
            letter-spacing: 0.03em;
        }

        .field .input,
        .field input[type="text"] {
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
        }

        .field .input:focus,
        .field input[type="text"]:focus {
            outline: none;
            background: rgba(15, 20, 34, 0.95);
            border-color: #ffd24a;
            box-shadow: inset 0 3px 0 rgba(0, 0, 0, 0.3), 0 0 25px rgba(255, 210, 74, 0.25);
        }

        .field .input::placeholder,
        .field input[type="text"]::placeholder {
            color: rgba(159, 176, 209, 0.5);
            font-weight: 600;
            opacity: 1;
        }

        .field .select,
        .field select {
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
            cursor: pointer;
        }

        .field .select:focus,
        .field select:focus {
            outline: none;
            background: rgba(15, 20, 34, 0.95);
            border-color: #ffd24a;
            box-shadow: inset 0 3px 0 rgba(0, 0, 0, 0.3), 0 0 25px rgba(255, 210, 74, 0.25);
        }

        .field input[type="file"] {
            padding: 0.75rem;
            background: rgba(15, 20, 34, 0.8);
            border: 2px solid #23304a;
            border-radius: 0;
            color: #e8eefc;
            font-family: Poppins, system-ui, Segoe UI, Arial, sans-serif;
            font-size: 0.9rem;
            cursor: pointer;
        }

        .hint {
            font-size: 0.65rem;
            color: #9fb0d1;
            font-family: 'Press Start 2P', monospace;
            text-transform: uppercase;
            letter-spacing: 0.03em;
            margin-top: 0.25rem;
        }

        .ce-contents {
            display: flex;
            flex-direction: column;
            gap: 0.75rem;
            margin-top: 0.5rem;
        }

        .ce-content-row {
            display: grid;
            grid-template-columns: auto minmax(0, 1fr) auto auto;
            gap: 0.75rem;
            align-items: center;
            background: rgba(15, 20, 34, 0.6);
            border: 2px solid #23304a;
            border-radius: 0;
            padding: 0.75rem 1rem;
            box-shadow: inset 0 2px 0 rgba(0, 0, 0, 0.3);
        }

        .ce-content-title {
            width: 100%;
        }

        .ce-content-meta {
            font-size: 0.6rem;
            color: #9fb0d1;
            text-align: right;
            padding: 0 0.5rem;
            font-family: 'Press Start 2P', monospace;
            text-transform: uppercase;
            letter-spacing: 0.03em;
            white-space: nowrap;
        }

        .ce-content-actions {
            display: flex;
            gap: 0.5rem;
        }

        .badge {
            font-size: 0.6rem;
            padding: 0.4rem 0.75rem;
            border: 2px solid #23304a;
            border-radius: 0;
            color: #9fb0d1;
            text-transform: uppercase;
            font-family: 'Press Start 2P', monospace;
            letter-spacing: 0.03em;
            background: rgba(15, 20, 34, 0.6);
            box-shadow: inset 0 2px 0 rgba(0, 0, 0, 0.3);
            white-space: nowrap;
        }

        .ce-content-actions .btn {
            padding: 0.5rem 1rem;
            font-weight: 900;
            font-family: 'Press Start 2P', monospace;
            font-size: 0.6rem;
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
            white-space: nowrap;
        }

        .ce-content-actions .btn:hover {
            background: rgba(15, 20, 34, 0.95);
            border-color: #ffd24a;
            color: #ffd24a;
            transform: translate(2px, 2px);
            box-shadow: 1px 1px 0 rgba(27, 37, 58, 0.8);
        }

        .ce-content-actions .btn:active {
            transform: translate(3px, 3px);
            box-shadow: 0 0 0 rgba(27, 37, 58, 0.8);
        }

        .ce-add-content {
            margin-top: 0.75rem;
            padding: 1rem;
            border-radius: 0;
            border: 2px dashed #23304a;
            background: rgba(15, 20, 34, 0.4);
            display: flex;
            flex-wrap: wrap;
            gap: 1rem;
            align-items: flex-end;
        }

        .ce-chapter-actions {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }

        .ce-chapter-actions .btn {
            padding: 0.75rem 1rem;
            font-weight: 900;
            font-family: 'Press Start 2P', monospace;
            font-size: 0.6rem;
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
            text-align: center;
            min-width: 3rem;
        }

        .ce-chapter-actions .btn:hover {
            background: rgba(15, 20, 34, 0.95);
            border-color: #ffd24a;
            color: #ffd24a;
            transform: translate(2px, 2px);
            box-shadow: 1px 1px 0 rgba(27, 37, 58, 0.8);
        }

        .ce-chapter-actions .btn:active {
            transform: translate(3px, 3px);
            box-shadow: 0 0 0 rgba(27, 37, 58, 0.8);
        }

        .ce-add-content .btn {
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

        .ce-add-content .btn:hover {
            background: rgba(15, 20, 34, 0.95);
            border-color: #ffd24a;
            color: #ffd24a;
            transform: translate(2px, 2px);
            box-shadow: 1px 1px 0 rgba(27, 37, 58, 0.8);
        }

        .ce-add-content .btn.primary {
            border: 2px solid #ffd24a;
            background: #ffd24a;
            color: #0b0f1a;
            box-shadow: 4px 4px 0 #b89200;
        }

        .ce-add-content .btn.primary:hover {
            background: #ffdc6a;
            transform: translate(2px, 2px);
            box-shadow: 2px 2px 0 #b89200;
        }

        .ce-add-content .btn.primary:active {
            transform: translate(4px, 4px);
            box-shadow: 0 0 0 #b89200;
        }

        .ce-add-row {
            display: flex;
            gap: 1rem;
            align-items: flex-end;
            margin-top: 1.5rem;
            padding-top: 1.5rem;
            border-top: 2px solid #1b253a;
        }

        .ce-add-row .field {
            flex: 1;
        }

        .ce-add-row .btn.primary {
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

        .ce-add-row .btn.primary:hover {
            background: #ffdc6a;
            transform: translate(2px, 2px);
            box-shadow: 2px 2px 0 #b89200;
        }

        .ce-add-row .btn.primary:active {
            transform: translate(4px, 4px);
            box-shadow: 0 0 0 #b89200;
        }

        @media (max-width: 800px) {
            .ce-chapter-row {
                grid-template-columns: minmax(0, 1fr);
            }

            .ce-chapter-actions {
                flex-direction: row;
                justify-content: flex-end;
            }

            .ce-content-row {
                grid-template-columns: auto minmax(0, 1fr);
            }

            .ce-content-meta {
                grid-column: 1 / -1;
                text-align: left;
            }

            .ce-content-actions {
                grid-column: 1 / -1;
                justify-content: flex-end;
            }

            .ce-add-content {
                flex-direction: column;
                align-items: stretch;
            }

            .ce-add-row {
                flex-direction: column;
                align-items: stretch;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="MainBlock" ContentPlaceHolderID="LecturerMain" runat="server">
    <div class="ce-shell">
        <div class="ce-header">
            <div>
                <h2 class="ce-title">Course Editor</h2>
                <div class="ce-subtitle">
                    Editing: <asp:Literal ID="litCourseTitle" runat="server" />
                </div>
            </div>
            <div class="ce-actions">
                <asp:HyperLink ID="lnkBackDetails" runat="server" CssClass="btn">
                    Back to Course Details
                </asp:HyperLink>
                <a href="<%= ResolveUrl("~/Lecturer/LecturerCourses.aspx") %>" class="btn">
                    Back to Courses
                </a>
            </div>
        </div>

        <asp:Label ID="lblInfo" runat="server" CssClass="muted" Visible="false" />

        <asp:Panel ID="pnlEditor" runat="server">
            <div class="ce-card">
                <div class="ce-card-header">
                    <div class="ce-card-title">Chapters &amp; Contents</div>
                    <div class="ce-card-meta">
                        Manage chapter titles, order, and per-chapter contents (files, exercises, assessments).
                    </div>
                </div>

                <asp:HiddenField ID="hfCourseId" runat="server" />

                <asp:Repeater ID="rptChapters" runat="server"
                              OnItemCommand="RptChapters_ItemCommand"
                              OnItemDataBound="RptChapters_ItemDataBound">
                    <ItemTemplate>
                        <div class="ce-chapter-row">
                            <div class="ce-chapter-order">
                                #<%# Eval("ChapterOrder") %>
                            </div>

                            <div class="ce-chapter-main">
                                <asp:HiddenField ID="hfChapterId" runat="server"
                                                 Value='<%# Eval("ChapterId") %>' />

                                <div class="field">
                                    <label>Chapter title</label>
                                    <asp:TextBox ID="txtChapterTitle" runat="server" CssClass="input"
                                                 Text='<%# Eval("ChapterTitle") %>' />
                                </div>

                                <div class="ce-contents">
                                    <!-- Existing contents in this chapter -->
                                    <asp:Repeater ID="rptContents" runat="server"
                                                  OnItemCommand="RptContents_ItemCommand">
                                        <ItemTemplate>
                                            <div class="ce-content-row">
                                                <asp:HiddenField ID="hfContentId" runat="server"
                                                                 Value='<%# Eval("ContentId") %>' />
                                                <asp:HiddenField ID="hfContentType" runat="server"
                                                                 Value='<%# Eval("ContentType") %>' />

                                                <span class="badge">
                                                    <%# Eval("ContentType") %>
                                                </span>

                                                <asp:TextBox ID="txtContentTitle" runat="server"
                                                             CssClass="input ce-content-title"
                                                             Text='<%# Eval("ContentTitle") %>' />

                                                <span class="ce-content-meta">
                                                    <%# Eval("RightMeta") %>
                                                </span>

                                                <div class="ce-content-actions">
                                                    <asp:LinkButton ID="btnSaveContent" runat="server"
                                                                    CssClass="btn"
                                                                    Text="Save"
                                                                    CommandName="saveContent"
                                                                    CommandArgument='<%# Eval("ContentId") %>' />
                                                    <asp:LinkButton ID="btnDeleteContent" runat="server"
                                                                    CssClass="btn"
                                                                    Text="✕"
                                                                    CommandName="deleteContent"
                                                                    CommandArgument='<%# Eval("ContentId") %>'
                                                                    OnClientClick="return confirm('Remove this content from chapter?');"
                                                                    CausesValidation="false" />
                                                </div>
                                            </div>
                                        </ItemTemplate>
                                    </asp:Repeater>

                                    <!-- Add new content to this chapter -->
                                    <div class="ce-add-content">
                                        <!-- File upload -->
                                        <div class="field" style="min-width:12rem;">
                                            <label>Add file</label>
                                            <asp:TextBox ID="txtNewContentTitle" runat="server"
                                                         CssClass="input"
                                                         placeholder="File title (e.g. Lecture slides)" />
                                        </div>
                                        <div class="field">
                                            <asp:FileUpload ID="fuNewFile" runat="server" />
                                            <span class="hint">
                                                Supported: PPT, DOC, XLS, PDF, etc.
                                            </span>
                                        </div>
                                        <asp:LinkButton ID="btnAddFile" runat="server"
                                                        CssClass="btn primary"
                                                        CommandName="addFile"
                                                        CommandArgument='<%# Eval("ChapterId") %>'>
                                            Add File
                                        </asp:LinkButton>

                                        <!-- Import exercise -->
                                        <div class="field">
                                            <label>Add exercise</label>
                                            <asp:DropDownList ID="ddlExercises" runat="server"
                                                              CssClass="select" />
                                        </div>
                                        <asp:LinkButton ID="btnAddExercise" runat="server"
                                                        CssClass="btn"
                                                        CommandName="addExercise"
                                                        CommandArgument='<%# Eval("ChapterId") %>'>
                                            Add Exercise
                                        </asp:LinkButton>

                                        <!-- Import assessment -->
                                        <div class="field">
                                            <label>Add assessment</label>
                                            <asp:DropDownList ID="ddlAssessments" runat="server"
                                                              CssClass="select" />
                                        </div>
                                        <asp:LinkButton ID="btnAddAssessment" runat="server"
                                                        CssClass="btn"
                                                        CommandName="addAssessment"
                                                        CommandArgument='<%# Eval("ChapterId") %>'>
                                            Add Assessment
                                        </asp:LinkButton>
                                    </div>
                                </div>
                            </div>

                            <div class="ce-chapter-actions">
                                <asp:LinkButton ID="btnUp" runat="server" CssClass="btn"
                                                Text="↑" CommandName="up"
                                                CommandArgument='<%# Eval("ChapterId") %>'
                                                CausesValidation="false" />
                                <asp:LinkButton ID="btnDown" runat="server" CssClass="btn"
                                                Text="↓" CommandName="down"
                                                CommandArgument='<%# Eval("ChapterId") %>'
                                                CausesValidation="false" />
                                <asp:LinkButton ID="btnSaveChapter" runat="server" CssClass="btn"
                                                Text="Save"
                                                CommandName="save"
                                                CommandArgument='<%# Eval("ChapterId") %>' />
                                <asp:LinkButton ID="btnDeleteChapter" runat="server" CssClass="btn"
                                                Text="✕"
                                                CommandName="delete"
                                                CommandArgument='<%# Eval("ChapterId") %>'
                                                OnClientClick="return confirm('Delete this chapter?');"
                                                CausesValidation="false" />
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>

                <div class="ce-add-row">
                    <div class="field">
                        <label>New chapter title</label>
                        <asp:TextBox ID="txtNewChapterTitle" runat="server"
                                     CssClass="input" placeholder="Chapter title" />
                    </div>
                    <asp:Button ID="btnAddChapter" runat="server"
                                CssClass="btn primary"
                                Text="Add Chapter"
                                OnClick="BtnAddChapter_Click" />
                </div>
            </div>
        </asp:Panel>
    </div>
</asp:Content>

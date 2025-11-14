<%@ Page Title="Lecturer • Course Editor" Language="C#"
    MasterPageFile="~/Lecturer/Lecturer.Master"
    AutoEventWireup="true"
    CodeBehind="LecturerCourseEditor.aspx.cs"
    Inherits="WAPP_Assignment.Lecturer.LecturerCourseEditor" %>

<asp:Content ID="HeadBlock" ContentPlaceHolderID="HeadLecturer" runat="server">
    <link rel="stylesheet" href="<%= ResolveUrl("~/Content/LecturerPages.css") %>" />
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

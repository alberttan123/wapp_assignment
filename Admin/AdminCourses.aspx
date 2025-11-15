<%@ Page Title="Admin • Courses"
    Language="C#"
    MasterPageFile="~/Admin/Admin.Master"
    AutoEventWireup="true"
    CodeBehind="AdminCourses.aspx.cs"
    Inherits="WAPP_Assignment.Admin.AdminCourses" %>

<asp:Content ID="HeadBlock" ContentPlaceHolderID="HeadAdmin" runat="server">
    <style>
        .ac-shell {
            max-width: 1000px;
            margin: 0 auto;
            padding: 0.5rem 0 1rem;
        }

        .ac-topbar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 0.75rem;
            margin-bottom: 0.5rem;
        }

        .ac-title-block {
            display: flex;
            flex-direction: column;
            gap: 0.15rem;
        }

        .ac-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--brand);
        }

        .ac-subtitle {
            font-size: 0.8rem;
            color: var(--muted);
        }

        .ac-actions {
            display: flex;
            flex-wrap: wrap;
            gap: 0.5rem;
            align-items: center;
            justify-content: flex-end;
        }

        .ac-search-group {
            display: flex;
            align-items: center;
            gap: 0.25rem;
        }

        .ac-search-group .input {
            max-width: 220px;
        }

        .ac-filter-group {
            display: flex;
            align-items: center;
            gap: 0.25rem;
        }

        .ac-filter-label {
            font-size: 0.78rem;
            color: var(--muted);
        }

        .ac-global-msg {
            font-size: 0.8rem;
            margin-bottom: 0.5rem;
        }

        .ac-global-msg span {
            display: inline-block;
            padding: 0.35rem 0.6rem;
            border-radius: 999px;
            border: 1px solid var(--line);
            background: var(--panel-2);
            color: var(--text);
        }

        .ac-list {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }

        .ac-card {
            background: var(--panel);
            border-radius: 10px;
            border: 1px solid var(--line);
            padding: 0.75rem 0.75rem;
        }

        .ac-card-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 0.75rem;
            margin-bottom: 0.5rem;
        }

        .ac-card-title-block {
            display: flex;
            flex-direction: column;
            gap: 0.2rem;
        }

        .ac-course-title {
            font-size: 1rem;
            font-weight: 600;
            color: var(--text);
        }

        .ac-course-lecturer {
            font-size: 0.8rem;
            color: var(--muted);
        }

        .ac-badges {
            display: flex;
            flex-direction: column;
            align-items: flex-end;
            gap: 0.25rem;
        }

        .ac-badge {
            font-size: 0.75rem;
            padding: 0.15rem 0.45rem;
            border-radius: 999px;
            border: 1px solid var(--line);
            background: var(--panel-2);
            color: var(--muted);
            white-space: nowrap;
        }

        .ac-card-body {
            font-size: 0.85rem;
            color: var(--text);
            margin-bottom: 0.5rem;
        }

        .ac-card-footer {
            display: flex;
            justify-content: flex-end;
            align-items: center;
        }

        .ac-card-footer .btn {
            font-size: 0.8rem;
        }

        /* Danger button override: red button, readable text */
        .btn.danger {
            background: #ff5c5c;
            border-color: #ff5c5c;
            color: #000;
        }

        .btn.danger:hover {
            filter: brightness(1.1);
        }

        .ac-empty {
            font-size: 0.85rem;
            color: var(--muted);
            padding: 0.5rem 0.25rem;
        }
    </style>
</asp:Content>

<asp:Content ID="MainBlock" ContentPlaceHolderID="AdminMain" runat="server">
    <div class="ac-shell">
        <div class="ac-topbar">
            <div class="ac-title-block">
                <div class="ac-title">Courses</div>
                <div class="ac-subtitle">
                    <asp:Literal ID="litCourseCount" runat="server" />
                </div>
            </div>

            <div class="ac-actions">
                <div class="ac-search-group">
                    <asp:TextBox ID="txtSearch"
                        runat="server"
                        CssClass="input"
                        placeholder="Search courses..."
                        AutoPostBack="true"
                        OnTextChanged="txtSearch_TextChanged" />
                    <asp:LinkButton ID="btnSearch"
                        runat="server"
                        CssClass="btn"
                        OnClick="btnSearch_Click">
                        Search
                    </asp:LinkButton>
                    <asp:LinkButton ID="btnClearSearch"
                        runat="server"
                        CssClass="btn"
                        OnClick="btnClearSearch_Click">
                        Clear
                    </asp:LinkButton>
                </div>

                <div class="ac-filter-group">
                    <span class="ac-filter-label">Lecturer:</span>
                    <asp:DropDownList ID="ddlLecturerFilter"
                        runat="server"
                        CssClass="select"
                        AutoPostBack="true"
                        OnSelectedIndexChanged="ddlLecturerFilter_SelectedIndexChanged">
                    </asp:DropDownList>
                </div>
            </div>
        </div>

        <div class="ac-global-msg">
            <span>
                <asp:Literal ID="litGlobalMessage" runat="server" />
            </span>
        </div>

        <asp:Repeater ID="rptCourses" runat="server"
            OnItemCommand="rptCourses_ItemCommand">
            <ItemTemplate>
                <div class="ac-card">
                    <div class="ac-card-header">
                        <div class="ac-card-title-block">
                            <div class="ac-course-title">
                                <%# Eval("CourseTitle") %>
                            </div>
                            <div class="ac-course-lecturer">
                                Lecturer:
                                <%# Eval("LecturerNameDisplay") %>
                            </div>
                        </div>
                        <div class="ac-badges">
                            <span class="ac-badge">
                                Lessons:
                                <%# Eval("TotalLessons") %>
                            </span>
                            <span class="ac-badge">
                                Created:
                                <%# Eval("CourseCreatedAt", "{0:yyyy-MM-dd}") %>
                            </span>
                        </div>
                    </div>

                    <div class="ac-card-body">
                        <%# Eval("CourseDescriptionDisplay") %>
                    </div>

                    <div class="ac-card-footer">
                        <asp:LinkButton ID="btnDeleteCourse"
                            runat="server"
                            CssClass="btn danger"
                            CommandName="delete"
                            CommandArgument='<%# Eval("CourseId") %>'>
                            Delete course
                        </asp:LinkButton>
                    </div>
                </div>
            </ItemTemplate>
            <FooterTemplate>
                <asp:PlaceHolder ID="phEmpty" runat="server"></asp:PlaceHolder>
            </FooterTemplate>
        </asp:Repeater>

        <asp:Literal ID="litEmptyState" runat="server" />
    </div>
</asp:Content>

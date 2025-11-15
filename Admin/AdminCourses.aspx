<%@ Page Title="Admin • Courses"
    Language="C#"
    MasterPageFile="~/Admin/Admin.Master"
    AutoEventWireup="true"
    CodeBehind="AdminCourses.aspx.cs"
    Inherits="WAPP_Assignment.Admin.AdminCourses" %>

<asp:Content ID="HeadBlock" ContentPlaceHolderID="HeadAdmin" runat="server">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Press+Start+2P&display=swap');
        
        .ac-shell {
            max-width: 1000px;
            margin: 0 auto;
            padding: 2rem;
            background: #121a2a;
            min-height: 100vh;
        }

        .ac-topbar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 1.5rem;
            margin-bottom: 2rem;
            flex-wrap: wrap;
        }

        .ac-title-block {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }

        .ac-title {
            font-family: 'Press Start 2P', monospace;
            font-size: 1.2rem;
            font-weight: 700;
            color: #ffd24a;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            text-shadow: 3px 3px 0 rgba(0, 0, 0, 0.5);
            margin: 0;
        }

        .ac-subtitle {
            font-size: 0.8rem;
            color: #9fb0d1;
            font-family: 'Press Start 2P', monospace;
            font-size: 0.5rem;
            text-transform: uppercase;
            letter-spacing: 0.03em;
        }

        .ac-actions {
            display: flex;
            flex-wrap: wrap;
            gap: 0.75rem;
            align-items: center;
            justify-content: flex-end;
        }

        .ac-search-group {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            flex-wrap: wrap;
        }

        .ac-search-group .input {
            flex: 1;
            min-width: 220px;
            max-width: 300px;
            padding: 0.75rem 1rem;
            background: rgba(15, 20, 34, 0.8);
            border: 2px solid #23304a;
            border-radius: 0;
            color: #e8eefc;
            font-family: Poppins, system-ui, Segoe UI, Arial, sans-serif;
            font-size: 0.95rem;
            font-weight: 600;
            box-shadow: inset 0 3px 0 rgba(0, 0, 0, 0.3), 0 2px 0 rgba(27, 37, 58, 0.5);
            transition: all 0.2s ease;
            box-sizing: border-box;
        }

        .ac-search-group .input:focus {
            outline: none;
            background: rgba(15, 20, 34, 0.95);
            border-color: #ffd24a;
            box-shadow: inset 0 3px 0 rgba(0, 0, 0, 0.3), 0 0 25px rgba(255, 210, 74, 0.25);
        }

        .ac-search-group .btn {
            font-family: 'Press Start 2P', monospace;
            font-size: 0.6rem;
            padding: 0.75rem 1.25rem;
            background: rgba(27, 37, 58, 0.8);
            color: #e8eefc;
            border: 2px solid #23304a;
            border-radius: 0;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            text-decoration: none;
            font-weight: 700;
            box-shadow: 0 3px 0 rgba(27, 37, 58, 0.8);
            transition: all 0.2s ease;
            cursor: pointer;
            display: inline-block;
            white-space: nowrap;
        }

        .ac-search-group .btn:hover {
            background: rgba(35, 48, 74, 0.9);
            transform: translateY(-1px);
            box-shadow: 0 4px 0 rgba(27, 37, 58, 0.8);
            text-decoration: none;
        }

        .ac-search-group .btn:active {
            transform: translateY(0);
            box-shadow: 0 2px 0 rgba(27, 37, 58, 0.8);
        }

        .ac-filter-group {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            flex-wrap: wrap;
        }

        .ac-filter-label {
            font-size: 0.78rem;
            color: #9fb0d1;
            font-family: 'Press Start 2P', monospace;
            font-size: 0.5rem;
            text-transform: uppercase;
            letter-spacing: 0.03em;
        }

        .ac-filter-group .select,
        .ac-filter-group select {
            padding: 0.75rem 1rem;
            background: rgba(15, 20, 34, 0.8);
            border: 2px solid #23304a;
            border-radius: 0;
            color: #e8eefc;
            font-family: Poppins, system-ui, Segoe UI, Arial, sans-serif;
            font-size: 0.95rem;
            font-weight: 600;
            box-shadow: inset 0 3px 0 rgba(0, 0, 0, 0.3), 0 2px 0 rgba(27, 37, 58, 0.5);
            transition: all 0.2s ease;
            cursor: pointer;
        }

        .ac-filter-group .select:focus,
        .ac-filter-group select:focus {
            outline: none;
            background: rgba(15, 20, 34, 0.95);
            border-color: #ffd24a;
            box-shadow: inset 0 3px 0 rgba(0, 0, 0, 0.3), 0 0 25px rgba(255, 210, 74, 0.25);
        }

        .ac-global-msg {
            font-size: 0.8rem;
            margin-bottom: 1rem;
        }

        .ac-global-msg span {
            display: inline-block;
            padding: 0.5rem 0.75rem;
            border-radius: 0;
            border: 2px solid #23304a;
            background: rgba(27, 37, 58, 0.6);
            color: #e8eefc;
            font-family: 'Press Start 2P', monospace;
            font-size: 0.55rem;
            text-transform: uppercase;
            letter-spacing: 0.03em;
            box-shadow: 0 4px 0 rgba(27, 37, 58, 0.8);
        }

        .ac-list {
            display: flex;
            flex-direction: column;
            gap: 1rem;
        }

        .ac-card {
            background: #121a2a;
            border-radius: 0;
            border: 2px solid #23304a;
            padding: 1.5rem;
            box-shadow: 0 8px 0 rgba(27, 37, 58, 0.8), 0 12px 24px rgba(0, 0, 0, 0.3);
            transition: all 0.2s ease;
        }

        .ac-card:hover {
            border-color: #ffd24a;
            transform: translateY(-2px);
            box-shadow: 0 10px 0 rgba(27, 37, 58, 0.8), 0 14px 28px rgba(0, 0, 0, 0.4), 0 0 30px rgba(255, 210, 74, 0.2);
        }

        .ac-card-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 1rem;
            margin-bottom: 1rem;
            flex-wrap: wrap;
        }

        .ac-card-title-block {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
            flex: 1;
            min-width: 200px;
        }

        .ac-course-title {
            font-size: 1rem;
            font-weight: 600;
            color: #e8eefc;
            font-family: 'Press Start 2P', monospace;
            font-size: 0.7rem;
            text-transform: uppercase;
            letter-spacing: 0.03em;
            line-height: 1.5;
        }

        .ac-course-lecturer {
            font-size: 0.8rem;
            color: #9fb0d1;
            font-family: 'Press Start 2P', monospace;
            font-size: 0.55rem;
            text-transform: uppercase;
            letter-spacing: 0.03em;
        }

        .ac-badges {
            display: flex;
            flex-direction: column;
            align-items: flex-end;
            gap: 0.5rem;
            flex-shrink: 0;
        }

        .ac-badge {
            font-size: 0.75rem;
            padding: 0.3rem 0.6rem;
            border-radius: 0;
            border: 1px solid #23304a;
            background: rgba(27, 37, 58, 0.6);
            color: #9fb0d1;
            white-space: nowrap;
            font-family: 'Press Start 2P', monospace;
            font-size: 0.55rem;
            text-transform: uppercase;
            letter-spacing: 0.03em;
            box-shadow: 0 2px 0 rgba(27, 37, 58, 0.5);
        }

        .ac-card-body {
            font-size: 0.85rem;
            color: #e8eefc;
            margin-bottom: 1rem;
            padding: 1rem;
            background: rgba(27, 37, 58, 0.4);
            border: 1px solid #1b253a;
            font-family: Poppins, system-ui, Segoe UI, Arial, sans-serif;
            line-height: 1.6;
        }

        .ac-card-footer {
            display: flex;
            justify-content: flex-end;
            align-items: center;
            padding-top: 1rem;
            border-top: 2px solid #1b253a;
        }

        .ac-card-footer .btn {
            font-family: 'Press Start 2P', monospace;
            font-size: 0.6rem;
            padding: 0.75rem 1.25rem;
            border-radius: 0;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            text-decoration: none;
            font-weight: 700;
            transition: all 0.2s ease;
            cursor: pointer;
            display: inline-block;
            white-space: nowrap;
        }

        /* Danger button override: red button, readable text */
        .btn.danger,
        .ac-card-footer .btn.danger {
            background: rgba(255, 107, 107, 0.2);
            border: 2px solid #ff6b6b;
            color: #ff6b6b;
            box-shadow: 3px 3px 0 rgba(217, 0, 95, 0.5);
        }

        .btn.danger:hover,
        .ac-card-footer .btn.danger:hover {
            background: #ff6b6b;
            color: #ffffff;
            transform: translate(2px, 2px);
            box-shadow: 1px 1px 0 rgba(217, 0, 95, 0.5);
            text-decoration: none;
        }

        .btn.danger:active,
        .ac-card-footer .btn.danger:active {
            transform: translate(3px, 3px);
            box-shadow: 0 0 0 rgba(217, 0, 95, 0.5);
        }

        .ac-empty {
            font-size: 0.85rem;
            color: #9fb0d1;
            padding: 2rem 1rem;
            text-align: center;
            font-family: 'Press Start 2P', monospace;
            font-size: 0.6rem;
            text-transform: uppercase;
            letter-spacing: 0.03em;
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

<%@ Page Title="Admin • Dashboard"
    Language="C#"
    MasterPageFile="~/Admin/Admin.Master"
    AutoEventWireup="true"
    CodeBehind="AdminDashboard.aspx.cs"
    Inherits="WAPP_Assignment.Admin.AdminDashboard" %>

<asp:Content ID="HeadBlock" ContentPlaceHolderID="HeadAdmin" runat="server">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Press+Start+2P&display=swap');
        
        * {
            box-sizing: border-box;
        }
        
        body {
            overflow-x: hidden;
        }
        
        .ad-shell {
            width: 100%;
            max-width: 100%;
            margin: 0 auto;
            padding: 2rem;
            background: #121a2a;
            min-height: 100vh;
            overflow-x: hidden;
            box-sizing: border-box;
        }

        .ad-header {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            gap: 1.5rem;
            margin-bottom: 2rem;
            flex-wrap: wrap;
        }

        .ad-title-block {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }

        .ad-title {
            font-family: 'Press Start 2P', monospace;
            font-size: 1.2rem;
            font-weight: 700;
            color: #ffd24a;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            text-shadow: 3px 3px 0 rgba(0, 0, 0, 0.5);
            margin: 0;
        }

        .ad-subtitle {
            font-size: 0.85rem;
            color: #9fb0d1;
            font-weight: 500;
            font-family: 'Press Start 2P', monospace;
            font-size: 0.6rem;
            text-transform: uppercase;
            letter-spacing: 0.03em;
        }

        .ad-header-right {
            display: flex;
            align-items: center;
        }

        .ad-profile-card {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 0.75rem 1rem;
            border-radius: 0;
            border: 2px solid #23304a;
            background: #121a2a;
            box-shadow: 0 4px 0 rgba(27, 37, 58, 0.8), 0 6px 12px rgba(0, 0, 0, 0.3);
            transition: all 0.2s ease;
        }

        .ad-profile-card:hover {
            border-color: #ffd24a;
            transform: translateY(-2px);
            box-shadow: 0 6px 0 rgba(27, 37, 58, 0.8), 0 8px 16px rgba(0, 0, 0, 0.4);
        }

        .ad-profile-main {
            display: flex;
            flex-direction: column;
            gap: 0.25rem;
        }

        .ad-profile-name {
            font-size: 0.9rem;
            font-weight: 600;
            color: #e8eefc;
        }

        .ad-profile-meta {
            font-size: 0.75rem;
            color: #9fb0d1;
        }

        .ad-profile-role-pill {
            display: inline-block;
            margin-right: 0.3rem;
            padding: 0.2rem 0.5rem;
            border-radius: 0;
            border: 1px solid #23304a;
            background: rgba(27, 37, 58, 0.6);
            font-size: 0.7rem;
            color: #9fb0d1;
            font-family: 'Press Start 2P', monospace;
            font-size: 0.55rem;
            text-transform: uppercase;
            letter-spacing: 0.03em;
        }

        .ad-profile-actions .btn {
            font-family: 'Press Start 2P', monospace;
            font-size: 0.55rem;
            padding: 0.5rem 0.75rem;
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
        }

        .ad-profile-actions .btn:hover {
            background: rgba(35, 48, 74, 0.9);
            transform: translateY(-1px);
            box-shadow: 0 4px 0 rgba(27, 37, 58, 0.8);
        }

        @media (max-width: 37.5rem) {
            .ad-header {
                flex-direction: column;
                align-items: flex-start;
            }

            .ad-header-right {
                width: 100%;
                justify-content: flex-start;
            }

            .ad-profile-card {
                width: 100%;
            }
        }

        .ad-grid {
            display: grid;
            grid-template-columns: minmax(0, 2fr) minmax(0, 1.5fr);
            gap: 1.5rem;
            margin-bottom: 1.5rem;
            width: 100%;
            max-width: 100%;
        }

        @media (max-width: 56.25rem) {
            .ad-grid {
                grid-template-columns: minmax(0, 1fr);
            }
        }

        .ad-row {
            display: grid;
            grid-template-columns: minmax(0, 1.6fr) minmax(0, 1.4fr);
            gap: 1.5rem;
            width: 100%;
            max-width: 100%;
        }

        @media (max-width: 56.25rem) {
            .ad-row {
                grid-template-columns: minmax(0, 1fr);
            }
        }

        .ad-card {
            background: #121a2a;
            border-radius: 0;
            border: 2px solid #23304a;
            padding: 1.5rem;
            box-shadow: 0 8px 0 rgba(27, 37, 58, 0.8), 0 12px 24px rgba(0, 0, 0, 0.3);
            transition: all 0.2s ease;
            position: relative;
            width: 100%;
            max-width: 100%;
            overflow-x: hidden;
            box-sizing: border-box;
        }

        .ad-card:hover {
            border-color: #ffd24a;
            transform: translateY(-2px);
            box-shadow: 0 10px 0 rgba(27, 37, 58, 0.8), 0 14px 28px rgba(0, 0, 0, 0.4), 0 0 30px rgba(255, 210, 74, 0.2);
        }

        .ad-card--accent-reset {
            background: linear-gradient(135deg, rgba(15, 20, 34, 0.9) 0%, rgba(18, 26, 42, 0.9) 60%, rgba(30, 41, 59, 0.9) 100%);
        }

        .ad-card--accent-login {
            background: linear-gradient(135deg, rgba(15, 20, 34, 0.9) 0%, rgba(18, 26, 42, 0.9) 60%, rgba(30, 41, 59, 0.9) 100%);
        }

        .ad-card--accent-signup {
            background: linear-gradient(135deg, rgba(15, 20, 34, 0.9) 0%, rgba(18, 26, 42, 0.9) 60%, rgba(30, 41, 59, 0.9) 100%);
        }

        .ad-card--accent-snapshot {
            background: linear-gradient(135deg, rgba(15, 20, 34, 0.9) 0%, rgba(18, 26, 42, 0.9) 60%, rgba(30, 41, 59, 0.9) 100%);
        }

        .ad-card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 1rem;
        }

        .ad-card-title-block {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }

        .ad-card-title {
            font-family: 'Press Start 2P', monospace;
            font-size: 0.7rem;
            font-weight: 700;
            color: #ffd24a;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            text-shadow: 2px 2px 0 rgba(0, 0, 0, 0.5);
        }

        .ad-card-subtitle {
            font-size: 0.75rem;
            color: #9fb0d1;
            font-family: 'Press Start 2P', monospace;
            font-size: 0.5rem;
            text-transform: uppercase;
            letter-spacing: 0.03em;
            line-height: 1.5;
        }

        .ad-pill {
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
        }

        /* Password reset list */
        .ad-pr-list {
            display: flex;
            flex-direction: column;
            gap: 0.75rem;
        }

        .ad-pr-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 1rem;
            padding: 1rem;
            border-radius: 0;
            border: 2px solid #23304a;
            background: rgba(27, 37, 58, 0.6);
            box-shadow: 0 4px 0 rgba(27, 37, 58, 0.8);
            transition: all 0.2s ease;
        }

        .ad-pr-row:hover {
            background: rgba(35, 48, 74, 0.8);
            border-color: #ffd24a;
            transform: translateY(-2px);
            box-shadow: 0 6px 0 rgba(27, 37, 58, 0.8);
        }

        .ad-pr-main {
            display: flex;
            flex-direction: column;
            gap: 0.25rem;
            flex: 1;
        }

        .ad-pr-user {
            color: #e8eefc;
            font-weight: 600;
            font-size: 0.9rem;
        }

        .ad-pr-meta {
            font-size: 0.75rem;
            color: #9fb0d1;
            font-family: 'Press Start 2P', monospace;
            font-size: 0.55rem;
            text-transform: uppercase;
            letter-spacing: 0.03em;
        }

        .ad-pr-role {
            font-size: 0.7rem;
            padding: 0.3rem 0.6rem;
            border-radius: 0;
            border: 1px solid #23304a;
            color: #9fb0d1;
            background: rgba(15, 20, 34, 0.8);
            font-family: 'Press Start 2P', monospace;
            font-size: 0.55rem;
            text-transform: uppercase;
            letter-spacing: 0.03em;
        }

        .ad-pr-empty {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            text-align: center;
            gap: 0.75rem;
            padding: 2rem 1rem;
        }

        .ad-ghost {
            font-size: 3rem;
            line-height: 1;
        }

        .ad-ghost-caption {
            font-size: 0.85rem;
            color: #9fb0d1;
            white-space: pre-line;
            font-family: 'Press Start 2P', monospace;
            font-size: 0.6rem;
            text-transform: uppercase;
            letter-spacing: 0.03em;
        }

        /* Login pie chart */
        .ad-login-body {
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .ad-pie-wrap {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 0.25rem;
        }

        .ad-pie {
            --ad-pie-admin: #ffd24a;     /* Admin segment */
            --ad-pie-educator: #6bc2ff;  /* Educator segment */
            --ad-pie-student: #b48bff;   /* Student segment */

            width: 5rem;   /* 80px */
            height: 5rem;
            border-radius: 50%;
            background: rgba(27, 37, 58, 0.6);
            display: flex;
            align-items: center;
            justify-content: center;
            border: 2px solid #23304a;
            box-shadow: 0 4px 0 rgba(27, 37, 58, 0.8);
        }

        .ad-pie-inner {
            width: 3.375rem;
            height: 3.375rem;
            border-radius: 50%;
            background: #121a2a;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.75rem;
            color: #ffd24a;
            border: 2px solid #23304a;
            font-family: 'Press Start 2P', monospace;
            font-size: 0.5rem;
            text-transform: uppercase;
            letter-spacing: 0.03em;
        }

        .ad-login-legend {
            flex: 1;
            font-size: 0.8rem;
            color: #e8eefc;
        }

        .ad-login-legend-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 0.5rem;
        }

        .ad-login-label-wrap {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .ad-login-label {
            color: #9fb0d1;
            font-family: 'Press Start 2P', monospace;
            font-size: 0.5rem;
            text-transform: uppercase;
            letter-spacing: 0.03em;
        }

        .ad-login-badge {
            font-size: 0.75rem;
            font-family: 'Press Start 2P', monospace;
            font-size: 0.5rem;
            text-transform: uppercase;
            letter-spacing: 0.03em;
        }

        .ad-login-badge-ok {
            color: #32c95a;
        }

        .ad-login-badge-miss {
            color: #ff5c5c;
        }

        .ad-dot {
            width: 0.75rem;
            height: 0.75rem;
            border-radius: 0;
            box-shadow: 0 2px 0 rgba(27, 37, 58, 0.8);
            border: 1px solid #23304a;
        }

        .ad-dot--admin {
            background: #ffd24a;
        }

        .ad-dot--educator {
            background: #6bc2ff;
        }

        .ad-dot--student {
            background: #b48bff;
        }

        .ad-dot--notoday {
            background: rgba(27, 37, 58, 0.6);
        }

        /* Signups bar chart */
        .ad-signup-body {
            display: flex;
            align-items: flex-end;
            gap: 1rem;
        }

        .ad-bar-wrap {
            flex: 1;
            display: flex;
            align-items: flex-end;
            justify-content: space-between;
            gap: 0.75rem;
            min-height: 5rem;
        }

        .ad-bar-col {
            flex: 1;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 0.5rem;
        }

        .ad-bar {
            width: 100%;
            max-width: 3rem;
            border-radius: 0;
            background: rgba(27, 37, 58, 0.6);
            border: 2px solid #23304a;
            display: block;
            box-shadow: 0 4px 0 rgba(27, 37, 58, 0.8);
            transition: all 0.2s ease;
        }

        .ad-bar:hover {
            border-color: #ffd24a;
            transform: translateY(-2px);
            box-shadow: 0 6px 0 rgba(27, 37, 58, 0.8);
        }

        .ad-bar-label {
            font-size: 0.75rem;
            color: #9fb0d1;
            font-family: 'Press Start 2P', monospace;
            font-size: 0.5rem;
            text-transform: uppercase;
            letter-spacing: 0.03em;
        }

        .ad-bar-count {
            font-size: 0.75rem;
            color: #e8eefc;
            font-family: 'Press Start 2P', monospace;
            font-size: 0.55rem;
            text-transform: uppercase;
            letter-spacing: 0.03em;
        }

        .ad-signup-note {
            font-size: 0.78rem;
            color: #9fb0d1;
            font-family: 'Press Start 2P', monospace;
            font-size: 0.5rem;
            text-transform: uppercase;
            letter-spacing: 0.03em;
            line-height: 1.5;
        }

        /* Snapshot card */
        .ad-snapshot-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 0.75rem;
            font-size: 0.85rem;
            width: 100%;
            max-width: 100%;
        }

        @media (max-width: 56.25rem) {
            .ad-snapshot-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 37.5rem) {
            .ad-snapshot-grid {
                grid-template-columns: minmax(0, 1fr);
            }
        }

        .ad-snapshot-item {
            padding: 1rem;
            border-radius: 0;
            border: 2px solid #23304a;
            background: rgba(27, 37, 58, 0.6);
            box-shadow: 0 4px 0 rgba(27, 37, 58, 0.8);
            transition: all 0.2s ease;
        }

        .ad-snapshot-item:hover {
            background: rgba(35, 48, 74, 0.8);
            border-color: #ffd24a;
            transform: translateY(-2px);
            box-shadow: 0 6px 0 rgba(27, 37, 58, 0.8);
        }

        /* Unified background for all snapshot items - subtle variations only */
        .ad-snapshot-item--primary {
            background: rgba(27, 37, 58, 0.6);
        }

        .ad-snapshot-item--admin {
            background: rgba(27, 37, 58, 0.6);
        }

        .ad-snapshot-item--edu {
            background: rgba(27, 37, 58, 0.6);
        }

        .ad-snapshot-item--stu {
            background: rgba(27, 37, 58, 0.6);
        }

        .ad-snapshot-item--course {
            background: rgba(27, 37, 58, 0.6);
        }

        .ad-snapshot-item--quiz {
            background: rgba(27, 37, 58, 0.6);
        }

        .ad-snapshot-item--post {
            background: rgba(27, 37, 58, 0.6);
        }

        .ad-snapshot-item--comment {
            background: rgba(27, 37, 58, 0.6);
        }

        .ad-snapshot-label {
            font-size: 0.78rem;
            color: #9fb0d1;
            margin-bottom: 0.5rem;
            font-family: 'Press Start 2P', monospace;
            font-size: 0.5rem;
            text-transform: uppercase;
            letter-spacing: 0.03em;
        }

        .ad-snapshot-value {
            font-size: 0.95rem;
            color: #ffd24a;
            font-weight: 700;
            font-family: 'Press Start 2P', monospace;
            font-size: 0.7rem;
            text-transform: uppercase;
            letter-spacing: 0.03em;
            text-shadow: 2px 2px 0 rgba(0, 0, 0, 0.5);
        }

        .ad-login-label {
            font-family: 'Press Start 2P', monospace;
            font-size: 0.5rem;
            text-transform: uppercase;
            letter-spacing: 0.03em;
        }
    </style>
</asp:Content>

<asp:Content ID="MainBlock" ContentPlaceHolderID="AdminMain" runat="server">
    <div class="ad-shell">
        <div class="ad-header">
            <div class="ad-title-block">
                <div class="ad-title">Admin Dashboard</div>
                <div class="ad-subtitle">
                    <asp:Literal ID="litDashboardSubtitle" runat="server" />
                </div>
            </div>

            <div class="ad-header-right">
                <div class="ad-profile-card">
                    <div class="ad-profile-main">
                        <div class="ad-profile-name">
                            <asp:Literal ID="litProfileName" runat="server" />
                        </div>
                        <div class="ad-profile-meta">
                            <span class="ad-profile-role-pill">
                                <asp:Literal ID="litProfileRole" runat="server" />
                            </span>
                            <asp:Literal ID="litProfileEmail" runat="server" />
                        </div>
                    </div>
                    <div class="ad-profile-actions">
                        <asp:LinkButton ID="btnLogout" runat="server"
                            CssClass="btn"
                            OnClick="btnLogout_Click">
                            Logout
                        </asp:LinkButton>
                    </div>
                </div>
            </div>
        </div>

        <!-- Top layout: Password reset + Login today -->
        <div class="ad-grid">
            <!-- Password reset requests -->
            <div class="ad-card ad-card--accent-reset">
                <div class="ad-card-header">
                    <div class="ad-card-title-block">
                        <div class="ad-card-title">Password reset requests</div>
                        <div class="ad-card-subtitle">
                            Users flagged with temporary / admin-generated passwords.
                        </div>
                    </div>
                    <span class="ad-pill">
                        <asp:Literal ID="litResetCount" runat="server" />
                    </span>
                </div>

                <asp:Panel ID="pnlPasswordResetList" runat="server">
                    <div class="ad-pr-list">
                        <asp:Repeater ID="rptPasswordResets" runat="server">
                            <ItemTemplate>
                                <div class="ad-pr-row">
                                    <div class="ad-pr-main">
                                        <div class="ad-pr-user">
                                            <%# Eval("DisplayName") %>
                                        </div>
                                        <div class="ad-pr-meta">
                                            <%# Eval("Username") %> • <%# Eval("UserType") %>
                                        </div>
                                    </div>
                                    <div>
                                        <span class="ad-pr-role">
                                            <%# Eval("UserType") %>
                                        </span>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                </asp:Panel>

                <asp:Panel ID="pnlPasswordResetEmpty" runat="server" Visible="false">
                    <div class="ad-pr-empty">
                        <div class="ad-ghost">👻</div>
                        <div class="ad-ghost-caption">
                            No password reset requests
                        </div>
                    </div>
                </asp:Panel>
            </div>

            <!-- Users logged in today -->
            <div class="ad-card ad-card--accent-login">
                <div class="ad-card-header">
                    <div class="ad-card-title-block">
                        <div class="ad-card-title">Users logged in today</div>
                        <div class="ad-card-subtitle">
                            Split by role, with overall login ratio (Malaysian time).
                        </div>
                    </div>
                    <span class="ad-pill">
                        <asp:Literal ID="litLoginSummary" runat="server" />
                    </span>
                </div>

                <div class="ad-login-body">
                    <div class="ad-pie-wrap">
                        <div id="divLoginPie" runat="server" class="ad-pie">
                            <div class="ad-pie-inner">
                                <asp:Literal ID="litLoginPercent" runat="server" />
                            </div>
                        </div>
                        <div class="ad-login-label">
                            <asp:Literal ID="litLoginPieCaption" runat="server" />
                        </div>
                    </div>

                    <div class="ad-login-legend">
                        <div class="ad-login-legend-row">
                            <div class="ad-login-label-wrap">
                                <span class="ad-dot ad-dot--admin"></span>
                                <span class="ad-login-label">Admins</span>
                            </div>
                            <span class="ad-login-badge ad-login-badge-ok">
                                <asp:Literal ID="litLoginAdmin" runat="server" />
                            </span>
                        </div>
                        <div class="ad-login-legend-row">
                            <div class="ad-login-label-wrap">
                                <span class="ad-dot ad-dot--educator"></span>
                                <span class="ad-login-label">Educators</span>
                            </div>
                            <span class="ad-login-badge ad-login-badge-ok">
                                <asp:Literal ID="litLoginEducator" runat="server" />
                            </span>
                        </div>
                        <div class="ad-login-legend-row">
                            <div class="ad-login-label-wrap">
                                <span class="ad-dot ad-dot--student"></span>
                                <span class="ad-login-label">Students</span>
                            </div>
                            <span class="ad-login-badge ad-login-badge-ok">
                                <asp:Literal ID="litLoginStudent" runat="server" />
                            </span>
                        </div>
                        <div class="ad-login-legend-row">
                            <div class="ad-login-label-wrap">
                                <span class="ad-dot ad-dot--notoday"></span>
                                <span class="ad-login-label">Not logged in today</span>
                            </div>
                            <span class="ad-login-badge ad-login-badge-miss">
                                <asp:Literal ID="litLoginNotToday" runat="server" />
                            </span>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bottom layout: Signups today + Snapshot -->
        <div class="ad-row">
            <!-- Signups today -->
            <div class="ad-card ad-card--accent-signup">
                <div class="ad-card-header">
                    <div class="ad-card-title-block">
                        <div class="ad-card-title">Users signed up today</div>
                        <div class="ad-card-subtitle">
                            New accounts created in the last 24 hours (Malaysian time).
                        </div>
                    </div>
                    <span class="ad-pill">
                        <asp:Literal ID="litSignupSummary" runat="server" />
                    </span>
                </div>

                <div class="ad-signup-body">
                    <div class="ad-bar-wrap">
                        <div class="ad-bar-col">
                            <div id="barSignupAdmin" runat="server" class="ad-bar"></div>
                            <span class="ad-bar-label">Admin</span>
                            <span class="ad-bar-count">
                                <asp:Literal ID="litSignupAdmin" runat="server" />
                            </span>
                        </div>
                        <div class="ad-bar-col">
                            <div id="barSignupEducator" runat="server" class="ad-bar"></div>
                            <span class="ad-bar-label">Educator</span>
                            <span class="ad-bar-count">
                                <asp:Literal ID="litSignupEducator" runat="server" />
                            </span>
                        </div>
                        <div class="ad-bar-col">
                            <div id="barSignupStudent" runat="server" class="ad-bar"></div>
                            <span class="ad-bar-label">Student</span>
                            <span class="ad-bar-count">
                                <asp:Literal ID="litSignupStudent" runat="server" />
                            </span>
                        </div>
                    </div>
                    <div class="ad-signup-note">
                        <asp:Literal ID="litSignupNote" runat="server" />
                    </div>
                </div>
            </div>

            <!-- Snapshot metrics -->
            <div class="ad-card ad-card--accent-snapshot">
                <div class="ad-card-header">
                    <div class="ad-card-title-block">
                        <div class="ad-card-title">Snapshot</div>
                        <div class="ad-card-subtitle">
                            Overall overview of users, courses, and quizzes.
                        </div>
                    </div>
                </div>

                <div class="ad-snapshot-grid">
                    <div class="ad-snapshot-item ad-snapshot-item--primary">
                        <div class="ad-snapshot-label">Total users</div>
                        <div class="ad-snapshot-value">
                            <asp:Literal ID="litTotalUsers" runat="server" />
                        </div>
                    </div>
                    <div class="ad-snapshot-item ad-snapshot-item--admin">
                        <div class="ad-snapshot-label">Admins</div>
                        <div class="ad-snapshot-value">
                            <asp:Literal ID="litTotalAdmins" runat="server" />
                        </div>
                    </div>
                    <div class="ad-snapshot-item ad-snapshot-item--edu">
                        <div class="ad-snapshot-label">Educators</div>
                        <div class="ad-snapshot-value">
                            <asp:Literal ID="litTotalEducators" runat="server" />
                        </div>
                    </div>
                    <div class="ad-snapshot-item ad-snapshot-item--stu">
                        <div class="ad-snapshot-label">Students</div>
                        <div class="ad-snapshot-value">
                            <asp:Literal ID="litTotalStudents" runat="server" />
                        </div>
                    </div>
                    <div class="ad-snapshot-item ad-snapshot-item--course">
                        <div class="ad-snapshot-label">Courses</div>
                        <div class="ad-snapshot-value">
                            <asp:Literal ID="litTotalCourses" runat="server" />
                        </div>
                    </div>
                    <div class="ad-snapshot-item ad-snapshot-item--quiz">
                        <div class="ad-snapshot-label">Quizzes</div>
                        <div class="ad-snapshot-value">
                            <asp:Literal ID="litTotalQuizzes" runat="server" />
                        </div>
                    </div>
                    <div class="ad-snapshot-item ad-snapshot-item--post">
                        <div class="ad-snapshot-label">Forum posts</div>
                        <div class="ad-snapshot-value">
                            <asp:Literal ID="litForumPosts" runat="server" />
                        </div>
                    </div>
                    <div class="ad-snapshot-item ad-snapshot-item--comment">
                        <div class="ad-snapshot-label">Forum comments</div>
                        <div class="ad-snapshot-value">
                            <asp:Literal ID="litForumComments" runat="server" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

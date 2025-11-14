<%@ Page Title="Admin • User Management"
    Language="C#"
    MasterPageFile="~/Admin/Admin.Master"
    AutoEventWireup="true"
    CodeBehind="AdminUserManage.aspx.cs"
    Inherits="WAPP_Assignment.Admin.AdminUserManage" %>

<asp:Content ID="HeadBlock" ContentPlaceHolderID="HeadAdmin" runat="server">
    <style>
        /* Shell aligned with lecturer patterns (qv-shell etc.) */
        .aum-shell {
            max-width: 1000px;
            margin: 0 auto;
            padding: 0.5rem 0 1rem; /* reduced top padding */
        }

        .aum-topbar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 0.75rem;
            margin-bottom: 0.75rem;
        }

        .aum-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--brand); /* same yellow accent as lecturer pages */
        }

        .aum-actions {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .aum-sort-label {
            font-size: 0.78rem;
            color: var(--muted);
            margin-top: 0.15rem;
        }

        .aum-list {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }

        .aum-card {
            background: var(--panel);
            border-radius: 10px;
            border: 1px solid var(--line);
            padding: 0.75rem 0.75rem;
        }

        .aum-card-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 0.5rem;
            cursor: pointer;
        }

        .aum-card-main {
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .aum-avatar {
            width: 36px;
            height: 36px;
            border-radius: 999px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            font-size: 0.9rem;
            background: var(--panel-2);
            border: 1px solid var(--line);
            color: var(--brand);
            flex-shrink: 0;
        }

        .aum-text-block {
            display: flex;
            flex-direction: column;
            gap: 0.15rem;
        }

        .aum-name {
            font-size: 0.95rem;
            font-weight: 600;
            color: var(--text);
        }

        .aum-meta {
            font-size: 0.8rem;
            color: var(--muted);
        }

        .aum-tag {
            font-size: 0.72rem;
            padding: 0.15rem 0.45rem;
            border-radius: 999px;
            border: 1px solid var(--line);
            background: var(--panel-2);
            color: var(--muted);
            text-transform: uppercase;
            letter-spacing: 0.05em;
            white-space: nowrap;
        }

        .aum-chevron {
            margin-left: 0.5rem;
            font-size: 0.85rem;
            color: var(--muted);
            flex-shrink: 0;
        }

        .aum-card-body {
            margin-top: 0.5rem;
            padding-top: 0.5rem;
            border-top: 1px dashed var(--line);
            font-size: 0.85rem;
            color: var(--text);
        }

        .aum-details-grid {
            display: grid;
            grid-template-columns: minmax(0, 1fr) minmax(0, 1fr);
            gap: 0.5rem 1rem;
        }

        @media (max-width: 720px) {
            .aum-details-grid {
                grid-template-columns: minmax(0, 1fr);
            }
        }

        .aum-details-label {
            font-size: 0.78rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: var(--muted);
            margin-bottom: 0.15rem;
        }

        .aum-details-value {
            font-size: 0.85rem;
            color: var(--text);
            word-break: break-word;
        }

        /* Password reset status styles */
        .aum-reset-badge {
            font-size: 0.75rem;
        }

        .aum-reset-ok {
            color: #32c95a; /* green text */
            font-weight: 500;
        }

        .aum-reset-warn {
            color: #ff5c5c; /* red text */
            font-weight: 500;
        }

        /* Old pill styles kept in case reused elsewhere */
        .aum-pill-ok {
            display: inline-flex;
            align-items: center;
            padding: 0.1rem 0.45rem;
            border-radius: 999px;
            border: 1px solid var(--line);
            background: var(--panel-2);
            font-size: 0.78rem;
            color: var(--muted);
        }

        .aum-pill-warn {
            display: inline-flex;
            align-items: center;
            padding: 0.1rem 0.45rem;
            border-radius: 999px;
            border: 1px solid var(--brand);
            background: rgba(255, 120, 120, 0.05);
            font-size: 0.78rem;
            color: var(--brand);
        }
    </style>
</asp:Content>

<asp:Content ID="MainBlock" ContentPlaceHolderID="AdminMain" runat="server">
    <div class="aum-shell">
        <div class="aum-topbar">
            <div>
                <div class="aum-title">User Management</div>
                <div class="aum-sort-label">
                    Current view:
                    <asp:Literal ID="litSortMode" runat="server" />
                </div>
            </div>

            <div class="aum-actions">
                <asp:DropDownList ID="ddlSortMode"
                    runat="server"
                    CssClass="select"
                    AutoPostBack="true"
                    OnSelectedIndexChanged="ddlSortMode_SelectedIndexChanged">
                    <asp:ListItem Text="Newest first" Value="newest" />
                    <asp:ListItem Text="Oldest first" Value="oldest" />
                    <asp:ListItem Text="Admins only" Value="role_Admin" />
                    <asp:ListItem Text="Educators only" Value="role_Educator" />
                    <asp:ListItem Text="Students only" Value="role_Student" />
                    <asp:ListItem Text="Password reset required" Value="reset_required" />
                </asp:DropDownList>

                <asp:LinkButton ID="btnNewUser"
                    runat="server"
                    CssClass="btn primary">
                    + New User
                </asp:LinkButton>
            </div>
        </div>

        <asp:Repeater ID="rptUsers" runat="server"
            OnItemCommand="rptUsers_ItemCommand"
            OnItemDataBound="rptUsers_ItemDataBound">
            <ItemTemplate>
                <div class="aum-card">
                    <asp:LinkButton ID="btnToggleUser"
                        runat="server"
                        CssClass="aum-card-header"
                        CommandName="toggle"
                        CommandArgument='<%# Eval("UserId") %>'>
                        <div class="aum-card-main">
                            <div class="aum-avatar">
                                <%# Eval("AvatarInitials") %>
                            </div>
                            <div class="aum-text-block">
                                <div class="aum-name">
                                    <%# Eval("DisplayName") %>
                                </div>
                                <div class="aum-meta">
                                    <%# Eval("Username") %>
                                </div>
                            </div>
                        </div>
                        <div style="display:flex;align-items:center;gap:0.5rem;">
                            <span class="aum-tag">
                                <%# Eval("UserType") %>
                            </span>
                            <span class="aum-reset-badge">
                                <asp:Literal ID="litPasswordResetHeader" runat="server" />
                            </span>
                            <span class="aum-chevron">
                                <asp:Literal ID="litChevron" runat="server" />
                            </span>
                        </div>
                    </asp:LinkButton>

                    <asp:Panel ID="pnlDetails" runat="server" CssClass="aum-card-body" Visible="false">
                        <div class="aum-details-grid">
                            <div>
                                <div class="aum-details-label">Full name</div>
                                <div class="aum-details-value">
                                    <%# Eval("FullNameDisplay") %>
                                </div>
                            </div>
                            <div>
                                <div class="aum-details-label">Username</div>
                                <div class="aum-details-value">
                                    <%# Eval("Username") %>
                                </div>
                            </div>
                            <div>
                                <div class="aum-details-label">Email</div>
                                <div class="aum-details-value">
                                    <%# Eval("Email") %>
                                </div>
                            </div>
                            <div>
                                <div class="aum-details-label">Role</div>
                                <div class="aum-details-value">
                                    <%# Eval("UserType") %>
                                </div>
                            </div>
                            <div>
                                <div class="aum-details-label">Password reset</div>
                                <div class="aum-details-value">
                                    <asp:Literal ID="litPasswordReset" runat="server" />
                                </div>
                            </div>
                        </div>
                    </asp:Panel>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>
</asp:Content>

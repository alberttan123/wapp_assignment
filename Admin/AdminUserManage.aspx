<%@ Page Title="Admin • User Management"
    Language="C#"
    MasterPageFile="~/Admin/Admin.Master"
    AutoEventWireup="true"
    CodeBehind="AdminUserManage.aspx.cs"
    Inherits="WAPP_Assignment.Admin.AdminUserManage" %>

<asp:Content ID="HeadBlock" ContentPlaceHolderID="HeadAdmin" runat="server">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Press+Start+2P&display=swap');
        
        /* Shell aligned with lecturer patterns */
        .aum-shell {
            max-width: 1000px;
            margin: 0 auto;
            padding: 2rem;
            background: #121a2a;
            min-height: 100vh;
        }

        .aum-topbar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 1.5rem;
            margin-bottom: 2rem;
            flex-wrap: wrap;
        }

        .aum-title {
            font-family: 'Press Start 2P', monospace;
            font-size: 1.2rem;
            font-weight: 700;
            color: #ffd24a;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            text-shadow: 3px 3px 0 rgba(0, 0, 0, 0.5);
            margin: 0;
        }

        .aum-actions {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            flex-wrap: wrap;
        }

        .aum-sort-label {
            font-size: 0.75rem;
            color: #9fb0d1;
            margin-top: 0.5rem;
            font-family: 'Press Start 2P', monospace;
            font-size: 0.5rem;
            text-transform: uppercase;
            letter-spacing: 0.03em;
        }

        .aum-actions .select,
        .aum-actions select {
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

        .aum-actions .select:focus,
        .aum-actions select:focus {
            outline: none;
            background: rgba(15, 20, 34, 0.95);
            border-color: #ffd24a;
            box-shadow: inset 0 3px 0 rgba(0, 0, 0, 0.3), 0 0 25px rgba(255, 210, 74, 0.25);
        }

        .aum-actions .btn.primary {
            font-family: 'Press Start 2P', monospace;
            font-size: 0.6rem;
            padding: 0.75rem 1.25rem;
            background: #ffd24a;
            color: #0f1422;
            border: 2px solid #23304a;
            border-radius: 0;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            text-decoration: none;
            font-weight: 700;
            box-shadow: 0 4px 0 rgba(27, 37, 58, 0.8), 0 6px 12px rgba(0, 0, 0, 0.3);
            transition: all 0.2s ease;
            cursor: pointer;
            display: inline-block;
            white-space: nowrap;
        }

        .aum-actions .btn.primary:hover {
            background: #ffffff;
            transform: translateY(-2px);
            box-shadow: 0 6px 0 rgba(27, 37, 58, 0.8), 0 8px 16px rgba(0, 0, 0, 0.4);
            text-decoration: none;
        }

        .aum-actions .btn.primary:active {
            transform: translateY(0);
            box-shadow: 0 2px 0 rgba(27, 37, 58, 0.8), 0 4px 8px rgba(0, 0, 0, 0.3);
        }

        .aum-global-msg {
            font-size: 0.8rem;
            margin-bottom: 1rem;
        }

        .aum-global-msg span {
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

        .aum-list {
            display: flex;
            flex-direction: column;
            gap: 1rem;
        }

        .aum-card {
            background: #121a2a;
            border-radius: 0;
            border: 2px solid #23304a;
            padding: 1.5rem;
            box-shadow: 0 8px 0 rgba(27, 37, 58, 0.8), 0 12px 24px rgba(0, 0, 0, 0.3);
            transition: all 0.2s ease;
        }

        .aum-card:hover {
            border-color: #ffd24a;
            transform: translateY(-2px);
            box-shadow: 0 10px 0 rgba(27, 37, 58, 0.8), 0 14px 28px rgba(0, 0, 0, 0.4), 0 0 30px rgba(255, 210, 74, 0.2);
        }

        .aum-card-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 1rem;
            cursor: pointer;
            text-decoration: none;
            color: inherit;
        }

        .aum-card-header:hover {
            text-decoration: none;
            color: inherit;
        }

        .aum-card-main {
            display: flex;
            align-items: center;
            gap: 1rem;
            flex: 1;
        }

        .aum-avatar {
            width: 48px;
            height: 48px;
            border-radius: 0;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 0.9rem;
            background: rgba(27, 37, 58, 0.6);
            border: 2px solid #23304a;
            color: #ffd24a;
            flex-shrink: 0;
            font-family: 'Press Start 2P', monospace;
            font-size: 0.6rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            box-shadow: 0 4px 0 rgba(27, 37, 58, 0.8);
        }

        .aum-text-block {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
            flex: 1;
        }

        .aum-name {
            font-size: 1rem;
            font-weight: 600;
            color: #e8eefc;
            font-family: 'Press Start 2P', monospace;
            font-size: 0.7rem;
            text-transform: uppercase;
            letter-spacing: 0.03em;
            line-height: 1.5;
        }

        .aum-meta {
            font-size: 0.8rem;
            color: #9fb0d1;
            font-family: 'Press Start 2P', monospace;
            font-size: 0.55rem;
            text-transform: uppercase;
            letter-spacing: 0.03em;
        }

        .aum-tag {
            font-size: 0.7rem;
            padding: 0.3rem 0.6rem;
            border-radius: 0;
            border: 1px solid #23304a;
            background: rgba(27, 37, 58, 0.6);
            color: #9fb0d1;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            white-space: nowrap;
            font-family: 'Press Start 2P', monospace;
            font-size: 0.55rem;
            box-shadow: 0 2px 0 rgba(27, 37, 58, 0.5);
        }

        .aum-chevron {
            margin-left: 0.5rem;
            font-size: 0.85rem;
            color: #9fb0d1;
            flex-shrink: 0;
            transition: transform 0.2s ease;
        }

        .aum-card-header:hover .aum-chevron {
            transform: rotate(90deg);
        }

        .aum-card-body {
            margin-top: 1rem;
            padding-top: 1rem;
            border-top: 2px solid #1b253a;
            font-size: 0.85rem;
            color: #e8eefc;
        }

        .aum-details-grid {
            display: grid;
            grid-template-columns: minmax(0, 1fr) minmax(0, 1fr);
            gap: 1rem 1.5rem;
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
            color: #9fb0d1;
            margin-bottom: 0.5rem;
            font-family: 'Press Start 2P', monospace;
            font-size: 0.5rem;
            letter-spacing: 0.03em;
        }

        .aum-details-value {
            font-size: 0.85rem;
            color: #e8eefc;
            word-break: break-word;
            font-family: 'Press Start 2P', monospace;
            font-size: 0.55rem;
            text-transform: uppercase;
            letter-spacing: 0.03em;
            line-height: 1.5;
        }

        .aum-reset-row {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            flex-wrap: wrap;
        }

        /* Password reset status styles */
        .aum-reset-badge {
            font-size: 0.75rem;
            font-family: 'Press Start 2P', monospace;
            font-size: 0.55rem;
            text-transform: uppercase;
            letter-spacing: 0.03em;
        }

        .aum-reset-ok {
            color: #32c95a;
            font-weight: 700;
        }

        .aum-reset-warn {
            color: #ff5c5c;
            font-weight: 700;
        }

        .aum-reset-tools {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            flex-wrap: wrap;
            margin-top: 0.5rem;
        }

        .aum-reset-tools .input {
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

        .aum-reset-tools .input:focus {
            outline: none;
            background: rgba(15, 20, 34, 0.95);
            border-color: #ffd24a;
            box-shadow: inset 0 3px 0 rgba(0, 0, 0, 0.3), 0 0 25px rgba(255, 210, 74, 0.25);
        }

        .aum-reset-tools .btn {
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

        .aum-reset-tools .btn:hover {
            background: rgba(35, 48, 74, 0.9);
            transform: translateY(-1px);
            box-shadow: 0 4px 0 rgba(27, 37, 58, 0.8);
            text-decoration: none;
        }

        /* Details footer (bottom) */
        .aum-details-footer {
            margin-top: 1.5rem;
            display: flex;
            justify-content: flex-end;
            padding-top: 1rem;
            border-top: 2px solid #1b253a;
        }

        .aum-details-footer .btn {
            font-family: 'Press Start 2P', monospace;
            font-size: 0.6rem;
            padding: 0.75rem 1.25rem;
            background: rgba(255, 107, 107, 0.2);
            color: #ff6b6b;
            border: 2px solid #ff6b6b;
            border-radius: 0;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            text-decoration: none;
            font-weight: 700;
            box-shadow: 3px 3px 0 rgba(217, 0, 95, 0.5);
            transition: all 0.2s ease;
            cursor: pointer;
            display: inline-block;
            white-space: nowrap;
        }

        /* Danger button override: red button, readable text */
        .btn.danger,
        .aum-details-footer .btn.danger {
            background: rgba(255, 107, 107, 0.2);
            border-color: #ff6b6b;
            color: #ff6b6b;
            box-shadow: 3px 3px 0 rgba(217, 0, 95, 0.5);
        }

        .btn.danger:hover,
        .aum-details-footer .btn.danger:hover {
            background: #ff6b6b;
            color: #ffffff;
            transform: translate(2px, 2px);
            box-shadow: 1px 1px 0 rgba(217, 0, 95, 0.5);
            text-decoration: none;
        }

        .btn.danger:active,
        .aum-details-footer .btn.danger:active {
            transform: translate(3px, 3px);
            box-shadow: 0 0 0 rgba(217, 0, 95, 0.5);
        }

        /* Old pill styles kept in case reused elsewhere */
        .aum-pill-ok {
            display: inline-flex;
            align-items: center;
            padding: 0.3rem 0.6rem;
            border-radius: 0;
            border: 1px solid #23304a;
            background: rgba(27, 37, 58, 0.6);
            font-size: 0.78rem;
            color: #9fb0d1;
            font-family: 'Press Start 2P', monospace;
            font-size: 0.55rem;
            text-transform: uppercase;
            letter-spacing: 0.03em;
        }

        .aum-pill-warn {
            display: inline-flex;
            align-items: center;
            padding: 0.3rem 0.6rem;
            border-radius: 0;
            border: 1px solid #ffd24a;
            background: rgba(255, 210, 74, 0.2);
            font-size: 0.78rem;
            color: #ffd24a;
            font-family: 'Press Start 2P', monospace;
            font-size: 0.55rem;
            text-transform: uppercase;
            letter-spacing: 0.03em;
        }

        .aum-card-body .btn {
            font-family: 'Press Start 2P', monospace;
            font-size: 0.6rem;
            padding: 0.75rem 1.25rem;
            background: #ffd24a;
            color: #0f1422;
            border: 2px solid #23304a;
            border-radius: 0;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            text-decoration: none;
            font-weight: 700;
            box-shadow: 0 4px 0 rgba(27, 37, 58, 0.8), 0 6px 12px rgba(0, 0, 0, 0.3);
            transition: all 0.2s ease;
            cursor: pointer;
            display: inline-block;
            white-space: nowrap;
        }

        .aum-card-body .btn:hover {
            background: #ffffff;
            transform: translateY(-2px);
            box-shadow: 0 6px 0 rgba(27, 37, 58, 0.8), 0 8px 16px rgba(0, 0, 0, 0.4);
            text-decoration: none;
        }

        .aum-card-body .btn:active {
            transform: translateY(0);
            box-shadow: 0 2px 0 rgba(27, 37, 58, 0.8), 0 4px 8px rgba(0, 0, 0, 0.3);
        }
    </style>

    <script type="text/javascript">
        function copyGeneratedPassword(btn) {
            if (!btn) return false;

            var username = btn.getAttribute('data-username') || '';
            var fieldId = btn.getAttribute('data-passwordfieldid');
            if (!fieldId) return false;

            var tb = document.getElementById(fieldId);
            if (!tb) return false;

            var password = tb.value || '';
            if (!password) return false;

            var payload = "Username: " + username + "\nPassword: " + password;

            if (navigator.clipboard && navigator.clipboard.writeText) {
                navigator.clipboard.writeText(payload);
                return false;
            }

            var temp = document.createElement("textarea");
            temp.style.position = "fixed";
            temp.style.opacity = "0";
            temp.value = payload;
            document.body.appendChild(temp);
            temp.focus();
            temp.select();
            try {
                document.execCommand('copy');
            } catch (e) {
                // ignore
            }
            document.body.removeChild(temp);
            return false;
        }
    </script>
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
                    CssClass="btn primary"
                    PostBackUrl="~/Admin/AdminCreateUser.aspx">
                    + New User
                </asp:LinkButton>
            </div>
        </div>

        <div class="aum-global-msg">
            <span>
                <asp:Literal ID="litGlobalMessage" runat="server" />
            </span>
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
                                <div class="aum-details-value aum-reset-row">
                                    <asp:Literal ID="litPasswordReset" runat="server" />
                                    <asp:LinkButton ID="btnGeneratePassword"
                                        runat="server"
                                        CssClass="btn"
                                        CommandName="regen_pw"
                                        CommandArgument='<%# Eval("UserId") %>'>
                                        Generate new password
                                    </asp:LinkButton>
                                    <asp:Panel ID="pnlGeneratedPassword" runat="server" CssClass="aum-reset-tools" Visible="false">
                                        <asp:TextBox ID="txtGeneratedPassword"
                                            runat="server"
                                            CssClass="input"
                                            ReadOnly="true" />
                                        <asp:LinkButton ID="btnCopyGeneratedPassword"
                                            runat="server"
                                            CssClass="btn"
                                            OnClientClick="return copyGeneratedPassword(this);">
                                            Copy
                                        </asp:LinkButton>
                                    </asp:Panel>
                                    <asp:HiddenField ID="hfUsername" runat="server" Value='<%# Eval("Username") %>' />
                                </div>
                            </div>
                        </div>

                        <div class="aum-details-footer">
                            <asp:LinkButton ID="btnDeleteUser"
                                runat="server"
                                CssClass="btn danger"
                                CommandName="delete"
                                CommandArgument='<%# Eval("UserId") %>'>
                                Delete user
                            </asp:LinkButton>
                        </div>
                    </asp:Panel>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>
</asp:Content>

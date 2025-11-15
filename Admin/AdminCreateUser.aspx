<%@ Page Title="Admin • Create User"
    Language="C#"
    MasterPageFile="~/Admin/Admin.Master"
    AutoEventWireup="true"
    CodeBehind="AdminCreateUser.aspx.cs"
    Inherits="WAPP_Assignment.Admin.AdminCreateUser" %>

<asp:Content ID="HeadBlock" ContentPlaceHolderID="HeadAdmin" runat="server">
    <style>
        .acu-shell {
            max-width: 720px;
            margin: 0 auto;
            padding: 0.5rem 0 1rem;
        }

        .acu-header {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            gap: 0.75rem;
            margin-bottom: 0.75rem;
        }

        .acu-header-main {
            display: flex;
            flex-direction: column;
            gap: 0.15rem;
        }

        .acu-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--brand);
        }

        .acu-subtitle {
            font-size: 0.85rem;
            color: var(--muted);
        }

        .acu-header-actions {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .acu-card {
            background: var(--panel);
            border-radius: 10px;
            border: 1px solid var(--line);
            padding: 0.75rem 0.75rem 0.9rem;
        }

        .acu-grid {
            display: grid;
            grid-template-columns: minmax(0, 1fr);
            gap: 0.75rem;
        }

        .acu-field {
            display: flex;
            flex-direction: column;
            gap: 0.25rem;
        }

        .acu-label {
            font-size: 0.8rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: var(--muted);
        }

        .acu-hint {
            font-size: 0.75rem;
            color: var(--muted);
        }

        .acu-role-group {
            display: flex;
            gap: 1rem;
            align-items: center;
            flex-wrap: wrap;
        }

        .acu-role-option {
            display: inline-flex;
            align-items: center;
            gap: 0.35rem;
            font-size: 0.85rem;
            color: var(--text);
        }

        .acu-actions {
            display: flex;
            justify-content: flex-end;
            margin-top: 0.75rem;
        }

        .acu-error {
            font-size: 0.75rem;
            color: #ff5c5c;
        }

        .acu-error-block {
            margin-top: 0.5rem;
        }

        .acu-result {
            margin-top: 0.75rem;
            background: var(--panel-2);
            border-radius: 10px;
            border: 1px solid var(--line);
            padding: 0.75rem;
        }

        .acu-result-title {
            font-size: 0.9rem;
            font-weight: 600;
            color: var(--text);
            margin-bottom: 0.35rem;
        }

        .acu-result-row {
            display: flex;
            flex-wrap: wrap;
            align-items: center;
            gap: 0.5rem;
            margin-top: 0.35rem;
        }

        .acu-result-label {
            font-size: 0.8rem;
            color: var(--muted);
        }

        .acu-result-password {
            flex: 1;
            min-width: 180px;
        }
    </style>

    <script type="text/javascript">
        function copyTempPassword() {
            var userTb = document.getElementById('<%= txtUsername.ClientID %>');
            var passTb = document.getElementById('<%= txtTempPassword.ClientID %>');

            if (!userTb || !passTb) return false;

            var username = userTb.value || "";
            var password = passTb.value || "";

            if (!username && !password) return false;

            var payload = "Username: " + username + "\nPassword: " + password;

            // Modern clipboard API
            if (navigator.clipboard && navigator.clipboard.writeText) {
                navigator.clipboard.writeText(payload);
                return false;
            }

            // Fallback: temporary textarea
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
    <div class="acu-shell">
        <div class="acu-header">
            <div class="acu-header-main">
                <div class="acu-title">Create User</div>
                <div class="acu-subtitle">
                    Create new <strong>Admin</strong> or <strong>Educator</strong> accounts. Students register themselves.
                </div>
            </div>
            <div class="acu-header-actions">
                <asp:LinkButton ID="btnBackManageUsers"
                    runat="server"
                    CssClass="btn"
                    PostBackUrl="~/Admin/AdminUserManage.aspx">
                    Back to Manage Users
                </asp:LinkButton>
            </div>
        </div>

        <div class="acu-card">
            <div class="acu-grid">
                <div class="acu-field">
                    <div class="acu-label">Full name</div>
                    <asp:TextBox ID="txtFullName" runat="server" CssClass="input" />
                    <span class="acu-error">
                        <asp:Literal ID="litErrorFullName" runat="server" />
                    </span>
                </div>

                <div class="acu-field">
                    <div class="acu-label">Username</div>
                    <asp:TextBox ID="txtUsername" runat="server" CssClass="input" />
                    <span class="acu-error">
                        <asp:Literal ID="litErrorUsername" runat="server" />
                    </span>
                </div>

                <div class="acu-field">
                    <div class="acu-label">Email</div>
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="input" />
                    <span class="acu-error">
                        <asp:Literal ID="litErrorEmail" runat="server" />
                    </span>
                </div>

                <div class="acu-field">
                    <div class="acu-label">Role</div>
                    <div class="acu-role-group">
                        <span class="acu-role-option">
                            <asp:RadioButton ID="rbEducator" runat="server" GroupName="Role" Text="Educator" Checked="true" />
                        </span>
                        <span class="acu-role-option">
                            <asp:RadioButton ID="rbAdmin" runat="server" GroupName="Role" Text="Admin" />
                        </span>
                    </div>
                    <div class="acu-hint">
                        Students should sign up through the public registration form.
                    </div>
                    <span class="acu-error">
                        <asp:Literal ID="litErrorRole" runat="server" />
                    </span>
                </div>
            </div>

            <div class="acu-actions">
                <asp:LinkButton ID="btnCreateUser"
                    runat="server"
                    CssClass="btn primary"
                    OnClick="btnCreateUser_Click">
                    Create User
                </asp:LinkButton>
            </div>

            <div class="acu-error-block">
                <span class="acu-error">
                    <asp:Literal ID="litErrorGeneral" runat="server" />
                </span>
            </div>

            <asp:Panel ID="pnlResult" runat="server" CssClass="acu-result" Visible="false">
                <div class="acu-result-title">User created successfully</div>
                <div class="acu-result-label">
                    A temporary password has been generated. Share it securely with the user and ask them to change it on first login.
                </div>

                <div class="acu-result-row">
                    <span class="acu-result-label">Temporary password:</span>
                    <span class="acu-result-password">
                        <asp:TextBox ID="txtTempPassword"
                            runat="server"
                            CssClass="input"
                            ReadOnly="true" />
                    </span>
                    <asp:LinkButton ID="btnCopyPassword"
                        runat="server"
                        CssClass="btn"
                        OnClientClick="return copyTempPassword();">
                        Copy
                    </asp:LinkButton>
                </div>
            </asp:Panel>
        </div>
    </div>
</asp:Content>

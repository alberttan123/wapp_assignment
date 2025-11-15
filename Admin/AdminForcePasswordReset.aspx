<%@ Page Title="Admin • Set New Password"
    Language="C#"
    MasterPageFile="~/Admin/Admin.Master"
    AutoEventWireup="true"
    CodeBehind="AdminForcePasswordReset.aspx.cs"
    Inherits="WAPP_Assignment.Admin.AdminForcePasswordReset" %>

<asp:Content ID="HeadBlock" ContentPlaceHolderID="HeadAdmin" runat="server">
    <style>
        .afr-overlay {
            position: fixed;
            inset: 0;
            background: rgba(0, 0, 0, 0.55);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 1000;
        }

        .afr-modal {
            background: var(--panel);
            border-radius: 12px;
            border: 1px solid var(--line);
            max-width: 420px;
            width: 100%;
            padding: 1rem;
            box-shadow: 0 18px 40px rgba(0, 0, 0, 0.6);
        }

        .afr-header {
            margin-bottom: 0.75rem;
        }

        .afr-title {
            font-size: 1.1rem;
            font-weight: 700;
            color: var(--brand);
        }

        .afr-subtitle {
            font-size: 0.85rem;
            color: var(--muted);
            margin-top: 0.25rem;
        }

        .afr-field {
            display: flex;
            flex-direction: column;
            gap: 0.25rem;
            margin-top: 0.6rem;
        }

        .afr-label {
            font-size: 0.8rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: var(--muted);
        }

        .afr-error {
            font-size: 0.75rem;
            color: #ff5c5c;
        }

        .afr-actions {
            display: flex;
            justify-content: flex-end;
            margin-top: 0.9rem;
        }

        .afr-username {
            font-weight: 600;
            color: var(--text);
        }
    </style>
</asp:Content>

<asp:Content ID="MainBlock" ContentPlaceHolderID="AdminMain" runat="server">
    <div class="afr-overlay">
        <div class="afr-modal">
            <div class="afr-header">
                <div class="afr-title">Set a new password</div>
                <div class="afr-subtitle">
                    For security reasons, you must set a new password before continuing.
                    <br />
                    Logged in as <span class="afr-username">
                        <asp:Literal ID="litUsername" runat="server" />
                    </span>.
                </div>
            </div>

            <div class="afr-field">
                <div class="afr-label">New password</div>
                <asp:TextBox ID="txtNewPassword" runat="server" CssClass="input" TextMode="Password" />
                <span class="afr-error">
                    <asp:Literal ID="litErrorPassword" runat="server" />
                </span>
            </div>

            <div class="afr-field">
                <div class="afr-label">Confirm password</div>
                <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="input" TextMode="Password" />
                <span class="afr-error">
                    <asp:Literal ID="litErrorConfirm" runat="server" />
                </span>
            </div>

            <div class="afr-field">
                <span class="afr-error">
                    <asp:Literal ID="litErrorGeneral" runat="server" />
                </span>
            </div>

            <div class="afr-actions">
                <asp:LinkButton ID="btnChangePassword"
                    runat="server"
                    CssClass="btn primary"
                    OnClick="btnChangePassword_Click">
                    Update password
                </asp:LinkButton>
            </div>
        </div>
    </div>
</asp:Content>

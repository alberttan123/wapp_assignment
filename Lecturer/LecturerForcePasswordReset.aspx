<%@ Page Title="Lecturer • Set New Password"
    Language="C#"
    MasterPageFile="~/Lecturer/Lecturer.Master"
    AutoEventWireup="true"
    CodeBehind="LecturerForcePasswordReset.aspx.cs"
    Inherits="WAPP_Assignment.Lecturer.LecturerForcePasswordReset" %>

<asp:Content ID="HeadBlock" ContentPlaceHolderID="HeadLecturer" runat="server">
    <style>
        .lfr-overlay {
            position: fixed;
            inset: 0;
            background: rgba(0, 0, 0, 0.55);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 1000;
        }

        .lfr-modal {
            background: var(--panel);
            border-radius: 12px;
            border: 1px solid var(--line);
            max-width: 420px;
            width: 100%;
            padding: 1rem;
            box-shadow: 0 18px 40px rgba(0, 0, 0, 0.6);
        }

        .lfr-header {
            margin-bottom: 0.75rem;
        }

        .lfr-title {
            font-size: 1.1rem;
            font-weight: 700;
            color: var(--brand);
        }

        .lfr-subtitle {
            font-size: 0.85rem;
            color: var(--muted);
            margin-top: 0.25rem;
        }

        .lfr-field {
            display: flex;
            flex-direction: column;
            gap: 0.25rem;
            margin-top: 0.6rem;
        }

        .lfr-label {
            font-size: 0.8rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: var(--muted);
        }

        .lfr-error {
            font-size: 0.75rem;
            color: #ff5c5c;
        }

        .lfr-actions {
            display: flex;
            justify-content: flex-end;
            margin-top: 0.9rem;
        }

        .lfr-username {
            font-weight: 600;
            color: var(--text);
        }
    </style>
</asp:Content>

<asp:Content ID="MainBlock" ContentPlaceHolderID="LecturerMain" runat="server">
    <div class="lfr-overlay">
        <div class="lfr-modal">
            <div class="lfr-header">
                <div class="lfr-title">Set a new password</div>
                <div class="lfr-subtitle">
                    For security reasons, you must set a new password before continuing.
                    <br />
                    Logged in as <span class="lfr-username">
                        <asp:Literal ID="litUsername" runat="server" />
                    </span>.
                </div>
            </div>

            <div class="lfr-field">
                <div class="lfr-label">New password</div>
                <asp:TextBox ID="txtNewPassword" runat="server" CssClass="input" TextMode="Password" />
                <span class="lfr-error">
                    <asp:Literal ID="litErrorPassword" runat="server" />
                </span>
            </div>

            <div class="lfr-field">
                <div class="lfr-label">Confirm password</div>
                <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="input" TextMode="Password" />
                <span class="lfr-error">
                    <asp:Literal ID="litErrorConfirm" runat="server" />
                </span>
            </div>

            <div class="lfr-field">
                <span class="lfr-error">
                    <asp:Literal ID="litErrorGeneral" runat="server" />
                </span>
            </div>

            <div class="lfr-actions">
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

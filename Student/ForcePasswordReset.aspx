<%@ Page Title="Reset Password"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="ForcePasswordReset.aspx.cs"
    Inherits="WAPP_Assignment.Student.ForcePasswordReset" %>

<asp:Content ID="HeadCSS" ContentPlaceHolderID="HeadContent" runat="server">
     <link href="<%= ResolveUrl("~/Content/waplanding.css") %>" rel="stylesheet" />
    <style>
        .spr-overlay {
            position: fixed;
            inset: 0;
            background: rgba(0,0,0,0.55);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 1500;
        }

        .spr-modal {
            background: var(--panel);
            border-radius: 12px;
            border: 1px solid var(--line);
            max-width: 420px;
            width: 100%;
            padding: 1rem;
            box-shadow: 0 18px 40px rgba(0,0,0,0.6);
        }

        .spr-title {
            font-size: 1.2rem;
            font-weight: 700;
            color: var(--brand);
            margin-bottom: 0.4rem;
        }

        .spr-subtitle {
            font-size: 0.85rem;
            color: var(--muted);
            line-height: 1.4;
        }

        .spr-field {
            margin-top: 0.8rem;
            display: flex;
            flex-direction: column;
            gap: 0.3rem;
        }

        .spr-label {
            font-size: 0.8rem;
            color: var(--muted);
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .spr-error {
            font-size: 0.75rem;
            color: #ff4a4a;
        }

        .spr-actions {
            display: flex;
            justify-content: flex-end;
            margin-top: 1rem;
        }
    </style>
</asp:Content>

<asp:Content ID="MainBlock" ContentPlaceHolderID="MainContent" runat="server">

    <div class="spr-overlay">
        <div class="spr-modal">

            <div class="spr-title">Set a new password</div>

            <div class="spr-subtitle">
                For your security, you must set a new password before continuing.
                <br />
                Logged in as <strong><asp:Literal ID="litUsername" runat="server" /></strong>
            </div>

            <!-- password -->
            <div class="spr-field">
                <span class="spr-label">New Password</span>
                <asp:TextBox ID="txtNewPassword" runat="server"
                    CssClass="input" TextMode="Password" />
                <span class="spr-error"><asp:Literal ID="litErrorPassword" runat="server" /></span>
            </div>

            <!-- confirm -->
            <div class="spr-field">
                <span class="spr-label">Confirm Password</span>
                <asp:TextBox ID="txtConfirmPassword" runat="server"
                    CssClass="input" TextMode="Password" />
                <span class="spr-error"><asp:Literal ID="litErrorConfirm" runat="server" /></span>
            </div>

            <!-- general -->
            <span class="spr-error"><asp:Literal ID="litErrorGeneral" runat="server" /></span>

            <div class="spr-actions">
                <asp:LinkButton ID="btnChangePassword"
                    runat="server"
                    CssClass="btn primary"
                    OnClick="btnChangePassword_Click">
                    Update Password
                </asp:LinkButton>
            </div>
        </div>
    </div>

</asp:Content>

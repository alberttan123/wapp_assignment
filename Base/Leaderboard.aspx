<%@ Page Title="Leaderboard"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeFile="Leaderboard.aspx.cs"
    Inherits="Base_Leaderboard" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="<%= ResolveUrl("~/Content/waplanding.css") %>" rel="stylesheet" />
    <style>
        .leaderboard-container {
            max-width: 800px;
            margin: 40px auto;
            background: #121212;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 25px rgba(0,0,0,0.35);
        }

        .leaderboard-title {
            font-size: 32px;
            font-weight: bold;
            margin-bottom: 20px;
            text-align: center;
            color: #fff;
        }

        .leaderboard-row {
            display: grid;
            grid-template-columns: 60px 1fr 1fr 80px;
            padding: 12px 10px;
            align-items: center;
            border-bottom: 1px solid #333;
            color: #f1f1f1;
        }

        .leaderboard-row.header {
            font-weight: bold;
            text-transform: uppercase;
            color: #aaa;
            border-bottom: 2px solid #444;
        }

        .leaderboard-rank {
            font-size: 20px;
            font-weight: bold;
            text-align: center;
        }

        .leaderboard-username {
            font-weight: bold;
        }

        .leaderboard-fullname {
            color: #ccc;
        }

        .leaderboard-xp {
            text-align: right;
            font-weight: bold;
            color: #4CAF50;
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="leaderboard-container">
        <div class="leaderboard-title">🏆 Leaderboard</div>

        <!-- Header row -->
        <div class="leaderboard-row header">
            <div>Rank</div>
            <div>Username</div>
            <div>Full Name</div>
            <div>XP</div>
        </div>

        <asp:Repeater ID="rptLeaderboard" runat="server">
            <ItemTemplate>
                <div class="leaderboard-row">
                    <div class="leaderboard-rank">
                        <%# GetMedal(Container.ItemIndex + 1) %>
                    </div>
                    <div class="leaderboard-username">
                        <%# Eval("Username") %>
                    </div>
                    <div class="leaderboard-fullname">
                        <%# Eval("FullName") %>
                    </div>
                    <div class="leaderboard-xp">
                        <%# Eval("XP") %>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>
</asp:Content>

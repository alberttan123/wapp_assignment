<%@ Page Title="My Results"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="AllResults.aspx.cs"
    Inherits="WAPP_Assignment.Student.AllResults" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="<%= ResolveUrl("~/Content/waplanding.css") %>" rel="stylesheet" />
    <link href="<%= ResolveUrl("~/Content/Results.css") %>" rel="stylesheet" />
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="results-header">
        <div class="results-header-content">
            <h1 class="results-page-title">My Quiz History</h1>
            <p class="results-page-subtitle">
                Review your past exercises and assessments – and how much XP you’ve earned.
            </p>
        </div>
    </div>

    <div class="results-content">
        <asp:Panel ID="pnlNoResults" runat="server" Visible="false" CssClass="results-empty">
            No results to show yet. Try completing a quiz or assessment first!
        </asp:Panel>

        <asp:Panel ID="pnlResults" runat="server" Visible="false" CssClass="results-table-wrapper">
            <asp:Repeater ID="rptResults" runat="server">
                <HeaderTemplate>
                    <table class="results-table">
                        <thead>
                            <tr>
                                <th>Date</th>
                                <th>Quiz Name</th>
                                <th>Score</th>
                                <th>Percentage</th>
                                <th>XP Earned</th>
                                <th>View Details</th>
                            </tr>
                        </thead>
                        <tbody>
                </HeaderTemplate>
                <ItemTemplate>
                    <tr>
                        <td>
                            <%# Eval("AttemptDate", "{0:yyyy-MM-dd HH:mm}") %>
                        </td>
                        <td>
                            <span class="results-quiz-name"><%# Eval("QuizTitle") %></span>
                            <span class='results-quiz-type-badge <%# Eval("QuizTypeCss") %>'>
                                <%# Eval("QuizTypeLabel") %>
                            </span>
                        </td>
                        <td>
                            <%# Eval("ScoreLabel") %>
                        </td>
                        <td>
                            <%# Eval("ScorePercentLabel") %>
                        </td>
                        <td class="results-xp-badge">
                            <%# Eval("XpLabel") %>
                        </td>
                        <td>
                            <a class="result-view-link"
                               href='<%# Eval("QuizTryId", ResolveUrl("~/Student/ViewResult.aspx?QuizTryId={0}")) %>'>
                                View
                            </a>
                        </td>
                    </tr>
                </ItemTemplate>
                <FooterTemplate>
                        </tbody>
                    </table>
                </FooterTemplate>
            </asp:Repeater>
        </asp:Panel>
    </div>

</asp:Content>

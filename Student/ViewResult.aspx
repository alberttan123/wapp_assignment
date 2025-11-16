<%@ Page Title="Result Details"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    Async="true"
    CodeBehind="ViewResult.aspx.cs"
    Inherits="WAPP_Assignment.Student.ViewResult" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="<%= ResolveUrl("~/Content/waplanding.css") %>" rel="stylesheet" />
    <link href="<%= ResolveUrl("~/Content/Results.css") %>" rel="stylesheet" />
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="results-header">
        <div class="results-header-content">
            <h1 class="results-page-title">Result Details</h1>
            <p class="results-page-subtitle">
                Review each question, your answer, and the correct answer.
            </p>
        </div>
    </div>

    <div class="result-detail-wrap">

        <!-- Meta card -->
        <asp:Panel ID="pnlMeta" runat="server" CssClass="result-meta-card">
            <h2 class="result-meta-title">
                <asp:Label ID="lblQuizTitle" runat="server" />
            </h2>
            <p class="result-meta-subtitle">
                <asp:Label ID="lblQuizSubtitle" runat="server" />
            </p>

            <div class="result-meta-grid">
                <div>
                    <div class="result-meta-label">Attempted On</div>
                    <div class="result-meta-value">
                        <asp:Label ID="lblAttemptDate" runat="server" />
                    </div>
                </div>

                <div>
                    <div class="result-meta-label">Quiz Type</div>
                    <div class="result-meta-value">
                        <asp:Label ID="lblQuizType" runat="server" />
                        <span id="spanQuizTypeChip" runat="server" class="result-meta-chip">
                            <asp:Label ID="lblQuizTypeChip" runat="server" />
                        </span>
                    </div>
                </div>

                <div>
                    <div class="result-meta-label">Score</div>
                    <div class="result-meta-value">
                        <asp:Label ID="lblScoreSummary" runat="server" />
                    </div>
                </div>

                <div>
                    <div class="result-meta-label">XP Earned</div>
                    <div class="result-meta-value">
                        <asp:Label ID="lblXpEarned" runat="server" />
                    </div>
                </div>
            </div>
        </asp:Panel>

        <!-- Questions list -->
        <div class="result-questions-list">
            <asp:Repeater ID="rptQuestionDetails" runat="server" OnItemDataBound="rptQuestionDetails_ItemDataBound">
                <ItemTemplate>
                    <asp:Panel ID="pnlQuestionCard" runat="server" CssClass="result-question-card">
                        <div class="rq-header">
                            <span class="rq-number">
                                Q<%# Eval("Index") %>
                            </span>
                            <span class="rq-tag">
                                <%# (bool)Eval("IsCorrect") ? "Correct" : "Incorrect" %>
                            </span>
                        </div>

                        <p class="rq-text"><%# Eval("QuestionText") %></p>

                        <asp:Panel ID="pnlImage" runat="server" CssClass="rq-image" Visible="false">
                            <asp:Image ID="imgQuestion" runat="server" />
                        </asp:Panel>

                        <div class="rq-answers">
                            <div>
                                <strong>Your answer:</strong>
                                <%# Eval("UserAnswerText") %>
                            </div>
                            <div>
                                <strong>Correct answer:</strong>
                                <%# Eval("CorrectAnswerText") %>
                            </div>
                        </div>
                    </asp:Panel>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <!-- AI summary (on demand) -->
        <asp:Panel ID="pnlAiSummary" runat="server" CssClass="ai-summary-card">
            <div class="ai-summary-header">
                <span class="ai-summary-title">AI Explanation (optional)</span>
                <asp:Button ID="btnGenerateAi" runat="server"
                            CssClass="ai-summary-btn"
                            Text="Generate"
                            OnClick="btnGenerateAi_Click" />
            </div>

            <asp:Label ID="lblAiSummary" runat="server" CssClass="ai-summary-text"
                       Text="Click &quot;Generate&quot; to get a short summary of your performance." />
        </asp:Panel>

    </div>

</asp:Content>

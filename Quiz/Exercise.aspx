<%@ Page Title="Exercise"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="Exercise.aspx.cs"
    Inherits="WAPP_Assignment.Quiz.Exercise"
    Async="true" %>

<asp:Content ID="HeadContent" runat="server" ContentPlaceHolderID="HeadContent">
  <link href="<%= ResolveUrl("~/Content/waplanding.css") %>" rel="stylesheet" />
  <link href="<%= ResolveUrl("~/Content/Exercise.css") %>" rel="stylesheet" />
</asp:Content>

<asp:Content ID="MainContent" runat="server" ContentPlaceHolderID="MainContent">
    <asp:Label ID="dbgLabel" runat="server"></asp:Label>
    <!-- No-quiz panel -->
    <asp:Panel ID="pnlNoQuiz" runat="server" Visible="false" CssClass="quiz-noquiz-panel">
        <h2>No quizzes found for this course</h2>
        <p>This course doesn’t have any linked quizzes yet.</p>
        <asp:Button ID="btnNoQuizBack" runat="server"
            Text="Back to Courses"
            CssClass="btn"
            OnClick="btnNoQuizBack_Click" />
    </asp:Panel>

    <!-- Flashcard quiz panel -->
    <asp:Panel ID="pnlQuiz" runat="server" Visible="false" CssClass="quiz-flashcard-panel">
        <div class="flashcard-container">

            <asp:Label ID="lblProgress" runat="server" CssClass="flashcard-progress" />

            <asp:Label ID="lblQuestionText" runat="server" CssClass="flashcard-question" />

            <asp:Image ID="imgQuestion" runat="server"
                CssClass="flashcard-image"
                Visible="false" />

            <div class="flashcard-options">
                <asp:Button ID="btnOption1" runat="server"
                    CssClass="flashcard-option"
                    OnClick="Option_Click"
                    CommandArgument="1" />
                <asp:Button ID="btnOption2" runat="server"
                    CssClass="flashcard-option"
                    OnClick="Option_Click"
                    CommandArgument="2" />
                <asp:Button ID="btnOption3" runat="server"
                    CssClass="flashcard-option"
                    OnClick="Option_Click"
                    CommandArgument="3" />
                <asp:Button ID="btnOption4" runat="server"
                    CssClass="flashcard-option"
                    OnClick="Option_Click"
                    CommandArgument="4" />
            </div>

            <asp:Label ID="lblFeedback" runat="server" CssClass="flashcard-feedback" />

            <asp:Button ID="btnNext" runat="server"
                Text="Next question"
                CssClass="btn flashcard-next"
                OnClick="btnNext_Click"
                Visible="false" />
        </div>
    </asp:Panel>

    <!-- Loading panel -->
    <asp:Panel ID="pnlLoading" runat="server" Visible="false" CssClass="quiz-loading-panel">
        <div class="loading-content">
            <div class="loading-spinner"></div>
            <h3 class="loading-title">Calculating your score...</h3>
            <p class="loading-subtitle">Generating AI explanation, please wait ⚙️</p>
        </div>
    </asp:Panel>

    <!-- Result / review panel -->
    <asp:Panel ID="pnlResult" runat="server" Visible="false" CssClass="quiz-result-panel">
        <h2>Exercise complete!</h2>
        <p>
            <asp:Label ID="lblScore" runat="server" />
        </p>

        <div style="margin-bottom:20px;">
            <asp:Button ID="btnTryAgain" runat="server"
                Text="Try Again"
                CssClass="btn"
                OnClick="btnTryAgain_Click" />

            <asp:Button ID="btnBackToCourses" runat="server"
                Text="Back to Courses"
                CssClass="btn secondary-btn"
                OnClick="btnBackToCourses_Click" />
        </div>

        <asp:Repeater ID="rptResults" runat="server">
            <ItemTemplate>
                <div class="result-line">
                    <p><strong>Q:</strong> <%# Eval("QuestionText") %></p>
                    <p><strong>Your answer:</strong> <%# Eval("UserAnswerText") %></p>
                    <p><strong>Correct answer:</strong> <%# Eval("CorrectAnswerText") %></p>
                    <hr />
                </div>
            </ItemTemplate>
        </asp:Repeater>

        <div style="margin-top:20px;">
            <h3>AI Explanation</h3>
            <p>
                <asp:Label ID="lblAiExplanation" CssClass="aiExplanation" runat="server" Text="Generating explanation..." />
            </p>
        </div>
    </asp:Panel>

</asp:Content>
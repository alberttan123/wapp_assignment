<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Assessment.aspx.cs"
    Inherits="WAPP_Assignment.Quiz.Assessment" Async="true" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Assessment</title>
    <meta charset="utf-8" />
    <style>
        body {
            font-family: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
            background: #f3f4f6;
            margin: 0;
            padding: 0;
        }

        .assessment-wrapper {
            max-width: 900px;
            margin: 40px auto;
            padding: 0 16px;
        }

        .assessment-card {
            background: #ffffff;
            border-radius: 16px;
            padding: 24px 24px 28px;
            box-shadow: 0 6px 18px rgba(0, 0, 0, 0.08);
            border: 1px solid #e5e7eb;
        }

        .assessment-header {
            margin-bottom: 16px;
        }

        .assessment-header h1 {
            margin: 0 0 6px;
            font-size: 22px;
        }

        .assessment-header p {
            margin: 0;
            color: #6b7280;
            font-size: 14px;
        }

        .assessment-progress {
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: #9ca3af;
            margin-bottom: 8px;
        }

        .assessment-question {
            font-size: 18px;
            font-weight: 600;
            margin: 14px 0 10px;
            color: #111827;
        }

        .assessment-image {
            margin: 10px 0;
            max-width: 100%;
            border-radius: 12px;
            border: 1px solid #e5e7eb;
        }

        .options-block {
            margin-top: 10px;
        }

        .options-block .aspNetDisabled {
            opacity: 0.9;
        }

        .nav-buttons {
            display: flex;
            justify-content: space-between;
            margin-top: 22px;
            gap: 8px;
        }

        .btn {
            border-radius: 999px;
            padding: 10px 18px;
            border: none;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
        }

        .btn-primary {
            background: #2563eb;
            color: #ffffff;
        }

        .btn-primary:hover {
            background: #1d4ed8;
        }

        .btn-secondary {
            background: #e5e7eb;
            color: #111827;
        }

        .btn-secondary:hover {
            background: #d1d5db;
        }

        .btn:disabled {
            opacity: 0.6;
            cursor: default;
        }

        /* Result view */

        .result-summary {
            margin-bottom: 24px;
        }

        .result-summary h2 {
            margin: 0 0 6px;
            font-size: 22px;
        }

        .result-summary p {
            margin: 0;
            color: #4b5563;
        }

        .result-cards {
            display: flex;
            flex-direction: column;
            gap: 14px;
            margin-top: 20px;
        }

        .result-card {
            border-radius: 12px;
            border: 1px solid #e5e7eb;
            padding: 14px 16px;
            background: #f9fafb;
        }

        .result-card.correct {
            border-color: #22c55e;
            background: #ecfdf5;
        }

        .result-card.incorrect {
            border-color: #f97373;
            background: #fef2f2;
        }

        .result-question {
            font-weight: 600;
            margin-bottom: 6px;
        }

        .result-line {
            font-size: 14px;
            margin: 2px 0;
        }

        .result-line span.label {
            font-weight: 600;
        }

        .ai-explanation {
            margin-top: 24px;
            padding-top: 16px;
            border-top: 1px solid #e5e7eb;
        }

        .ai-explanation h3 {
            margin: 0 0 8px;
            font-size: 18px;
        }

        .ai-explanation p {
            margin: 0;
            color: #4b5563;
            font-size: 14px;
            white-space: pre-wrap;
        }

        .top-actions {
            margin-top: 18px;
            display: flex;
            gap: 8px;
        }

        @media (max-width: 640px) {
            .assessment-card {
                padding: 18px 16px 20px;
            }

            .assessment-question {
                font-size: 16px;
            }

            .nav-buttons {
                flex-direction: column;
                align-items: stretch;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="assessment-wrapper">

            <!-- In-progress assessment panel -->
            <asp:Panel ID="pnlAssessment" runat="server" Visible="false" CssClass="assessment-card">
                <div class="assessment-header">
                    <div class="assessment-progress">
                        <asp:Label ID="lblProgress" runat="server" />
                    </div>
                    <h1>
                        <asp:Label ID="lblQuizTitle" runat="server" Text="Assessment" />
                    </h1>
                    <p>This is an assessment. Your answers will be saved.</p>
                </div>

                <asp:Image ID="imgQuestion" runat="server" CssClass="assessment-image" Visible="false" />

                <div class="assessment-question">
                    <asp:Label ID="lblQuestionText" runat="server" />
                </div>

                <div class="options-block">
                    <asp:RadioButtonList ID="rblOptions" runat="server" RepeatDirection="Vertical" />
                </div>

                <div class="nav-buttons">
                    <asp:Button ID="btnPrevious" runat="server"
                        Text="Previous"
                        CssClass="btn btn-secondary"
                        OnClick="btnPrevious_Click" />

                    <asp:Button ID="btnNext" runat="server"
                        Text="Next"
                        CssClass="btn btn-primary"
                        OnClick="btnNext_Click" />
                </div>
            </asp:Panel>

            <!-- Result panel -->
            <asp:Panel ID="pnlResult" runat="server" Visible="false" CssClass="assessment-card">
                <div class="result-summary">
                    <h2>Assessment Results</h2>
                    <p>
                        <asp:Label ID="lblScore" runat="server" />
                    </p>

                    <div class="top-actions">
                        <asp:Button ID="btnRetake" runat="server"
                            Text="Retake Assessment"
                            CssClass="btn btn-primary"
                            OnClick="btnRetake_Click" />

                        <asp:Button ID="btnBackToDashboard" runat="server"
                            Text="Back to Courses"
                            CssClass="btn btn-secondary"
                            OnClick="btnBackToDashboard_Click" />
                    </div>
                </div>

                <asp:Repeater ID="rptResults" runat="server">
                    <ItemTemplate>
                        <div class='result-card <%# (bool)Eval("IsCorrect") ? "correct" : "incorrect" %>'>
                            <div class="result-question">
                                <%# Eval("QuestionText") %>
                            </div>
                            <div class="result-line">
                                <span class="label">Your answer:</span>
                                <%# Eval("UserAnswerText") %>
                            </div>
                            <div class="result-line">
                                <span class="label">Correct answer:</span>
                                <%# Eval("CorrectAnswerText") %>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>

                <div class="ai-explanation">
                    <h3>AI Explanation</h3>
                    <p>
                        <asp:Label ID="lblAiExplanation" runat="server" Text="Generating explanation..." />
                    </p>
                </div>
            </asp:Panel>

        </div>
    </form>
</body>
</html>

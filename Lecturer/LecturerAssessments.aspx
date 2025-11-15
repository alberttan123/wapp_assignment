<%@ Page Title="Lecturer • Assessments" Language="C#"
    MasterPageFile="~/Lecturer/Lecturer.Master"
    AutoEventWireup="true"
    CodeBehind="LecturerAssessments.aspx.cs"
    Inherits="WAPP_Assignment.Lecturer.LecturerAssessments" %>

<asp:Content ID="HeadBlock" ContentPlaceHolderID="HeadLecturer" runat="server">
    <link rel="stylesheet" href="<%= ResolveUrl("~/Content/LecturerPages.css") %>" />
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Press+Start+2P&display=swap');
        
        .lc-header {
            font-size: 1.8rem;
            font-weight: 900;
            color: #ffd24a;
            margin-bottom: 2rem;
            font-family: 'Press Start 2P', monospace;
            font-size: 1.2rem;
            text-shadow: 3px 3px 0 rgba(0, 0, 0, 0.5);
            letter-spacing: 0.05em;
            text-transform: uppercase;
        }

        .lc-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
            gap: 1.5rem;
            flex-wrap: wrap;
        }

        .lc-search {
            flex: 1;
            min-width: 250px;
        }

        .lc-search .input,
        .lc-search input[type="text"] {
            width: 100%;
            padding: 1rem 1.25rem;
            background: rgba(15, 20, 34, 0.8);
            border: 2px solid #23304a;
            border-radius: 0;
            color: #e8eefc;
            font-family: Poppins, system-ui, Segoe UI, Arial, sans-serif;
            font-size: 1rem;
            font-weight: 600;
            transition: all 0.2s ease;
            box-shadow: inset 0 3px 0 rgba(0, 0, 0, 0.3), 0 2px 0 rgba(27, 37, 58, 0.5);
            box-sizing: border-box;
        }

        .lc-search .input:focus,
        .lc-search input[type="text"]:focus {
            outline: none;
            background: rgba(15, 20, 34, 0.95);
            border-color: #ffd24a;
            box-shadow: inset 0 3px 0 rgba(0, 0, 0, 0.3), 0 0 25px rgba(255, 210, 74, 0.25);
        }

        .lc-search .input::placeholder,
        .lc-search input[type="text"]::placeholder {
            color: rgba(159, 176, 209, 0.5);
            font-weight: 600;
            opacity: 1;
        }

        .lc-actions .btn {
            padding: 0.9rem 2rem;
            font-weight: 900;
            font-family: 'Press Start 2P', monospace;
            font-size: 0.7rem;
            cursor: pointer;
            transition: all 0.2s ease;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            border-radius: 0;
            border: 2px solid #ffd24a;
            background: #ffd24a;
            color: #0b0f1a;
            text-decoration: none;
            box-shadow: 4px 4px 0 #b89200;
            display: inline-block;
            white-space: nowrap;
        }

        .lc-actions .btn:hover {
            background: #ffdc6a;
            transform: translate(2px, 2px);
            box-shadow: 2px 2px 0 #b89200;
        }

        .lc-actions .btn:active {
            transform: translate(4px, 4px);
            box-shadow: 0 0 0 #b89200;
        }

        .lc-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 1.5rem;
        }

        .lc-card {
            background: #121a2a;
            border: 2px solid #23304a;
            border-radius: 0;
            display: flex;
            flex-direction: column;
            overflow: hidden;
            transition: all 0.2s ease;
            box-shadow: 0 8px 0 rgba(27, 37, 58, 0.8), 0 12px 24px rgba(0, 0, 0, 0.3);
        }

        .lc-card:hover {
            border-color: #ffd24a;
            transform: translateY(-4px);
            box-shadow: 0 12px 0 rgba(27, 37, 58, 0.8), 0 16px 32px rgba(0, 0, 0, 0.4), 0 0 40px rgba(255, 210, 74, 0.3);
        }

        .lc-card-link {
            display: block;
            text-decoration: none;
            color: inherit;
            flex: 1;
        }

        .lc-card-body {
            padding: 1.5rem;
            display: flex;
            flex-direction: column;
            gap: 0.75rem;
            flex: 1;
        }

        .lc-card-body h3 {
            margin: 0;
            font-size: 1rem;
            color: #e8eefc;
            font-family: 'Press Start 2P', monospace;
            font-size: 0.7rem;
            text-transform: uppercase;
            letter-spacing: 0.03em;
            line-height: 1.5;
            font-weight: 400;
        }

        .lc-meta {
            font-size: 0.65rem;
            color: #9fb0d1;
            margin: 0;
            font-family: 'Press Start 2P', monospace;
            text-transform: uppercase;
            letter-spacing: 0.03em;
        }

        .lc-card-footer {
            padding: 1rem 1.5rem 1.5rem;
            display: flex;
            justify-content: flex-end;
            border-top: 2px solid #1b253a;
        }

        .lc-card-footer .btn {
            padding: 0.75rem 1.5rem;
            font-weight: 900;
            font-family: 'Press Start 2P', monospace;
            font-size: 0.65rem;
            cursor: pointer;
            transition: all 0.2s ease;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            border-radius: 0;
            border: 2px solid #ff6b6b;
            background: rgba(255, 107, 107, 0.2);
            color: #ff6b6b;
            text-decoration: none;
            box-shadow: 3px 3px 0 rgba(217, 0, 95, 0.5);
            display: inline-block;
        }

        .lc-card-footer .btn:hover {
            background: #ff6b6b;
            color: #ffffff;
            transform: translate(2px, 2px);
            box-shadow: 1px 1px 0 rgba(217, 0, 95, 0.5);
        }

        .lc-card-footer .btn:active {
            transform: translate(3px, 3px);
            box-shadow: 0 0 0 rgba(217, 0, 95, 0.5);
        }

        .lc-card-footer .btn.small {
            padding: 0.75rem 1.5rem;
            font-size: 0.65rem;
        }

        @media (max-width: 960px) {
            .lc-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 640px) {
            .lc-grid {
                grid-template-columns: 1fr;
            }

            .lc-bar {
                flex-direction: column;
                align-items: stretch;
            }

            .lc-search {
                width: 100%;
            }

            .lc-actions .btn {
                width: 100%;
                text-align: center;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="MainBlock" ContentPlaceHolderID="LecturerMain" runat="server">

    <!-- Page header (same pattern as LecturerCourses) -->
    <div class="lc-header">Assessments</div>

    <div class="lc-bar">
        <div class="lc-search">
            <asp:TextBox ID="txtSearch" runat="server"
                         CssClass="input"
                         Placeholder="Search assessments"
                         AutoPostBack="true"
                         OnTextChanged="TxtSearch_TextChanged" />
        </div>

        <div class="lc-actions">
            <a href="<%= ResolveUrl("~/Lecturer/LecturerExamBuilder.aspx") %>"
               class="btn primary">
                Build an Assessment
            </a>
        </div>
    </div>

    <asp:Label ID="lblInfo" runat="server" CssClass="muted" Visible="false" />

    <!-- Card grid: reuse lc-grid / lc-card so it matches Courses page -->
    <div class="lc-grid">
        <asp:Repeater ID="rptAssessments" runat="server"
                      OnItemCommand="RptAssessments_ItemCommand">

            <ItemTemplate>
                <div class="lc-card">
                    <!-- Entire card clickable, like courses -->
                    <asp:HyperLink ID="lnkAssessment" runat="server"
                                   CssClass="lc-card-link"
                                   NavigateUrl='<%# "~/Lecturer/LecturerAssessmentDetails.aspx?quizId=" + Eval("QuizId") %>'>
                        <!-- No banner; just title + question count -->
                        <div class="lc-card-body">
                            <h3><%# Eval("QuizTitle") %></h3>
                            <div class="lc-meta">
                                Questions: <%# Eval("QuestionCount") %>
                            </div>
                        </div>
                    </asp:HyperLink>

                    <div class="lc-card-footer">
                        <asp:LinkButton ID="btnDelete" runat="server"
                                        CssClass="btn small"
                                        CommandName="delete"
                                        CommandArgument='<%# Eval("QuizId") %>'
                                        CausesValidation="false"
                                        OnClientClick="return confirm('Delete this assessment? This will not delete the underlying questions.');">
                            Delete
                        </asp:LinkButton>
                    </div>
                </div>
            </ItemTemplate>

        </asp:Repeater>
    </div>

</asp:Content>

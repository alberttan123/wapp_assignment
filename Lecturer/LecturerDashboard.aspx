<%@ Page Title="Lecturer • Dashboard" Language="C#"
    MasterPageFile="~/Lecturer/Lecturer.Master"
    AutoEventWireup="true"
    CodeBehind="LecturerDashboard.aspx.cs"
    Inherits="WAPP_Assignment.Lecturer.LecturerDashboard" %>

<asp:Content ID="HeadBlock" ContentPlaceHolderID="HeadLecturer" runat="server">
    <link rel="stylesheet" href="<%= ResolveUrl("~/Content/LecturerPages.css") %>" />
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Press+Start+2P&display=swap');
        
        .ld-shell {
            max-width: 1400px;
            margin: 0 auto;
            padding: 2rem;
            background: #121a2a;
        }

        .ld-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2.5rem;
            padding-bottom: 1.5rem;
            border-bottom: 2px solid #23304a;
        }

        .ld-title {
            font-size: 1.8rem;
            font-weight: 900;
            color: #ffd24a;
            margin: 0;
            font-family: 'Press Start 2P', monospace;
            font-size: 1.2rem;
            text-shadow: 3px 3px 0 rgba(0, 0, 0, 0.5);
            letter-spacing: 0.05em;
            text-transform: uppercase;
        }

        .ld-actions {
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
        }

        .ld-actions .btn {
            padding: 0.9rem 2rem;
            font-weight: 900;
            font-family: 'Press Start 2P', monospace;
            font-size: 0.7rem;
            cursor: pointer;
            transition: all 0.2s ease;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            border-radius: 0;
            border: 2px solid #23304a;
            background: rgba(15, 20, 34, 0.8);
            color: #e8eefc;
            text-decoration: none;
            box-shadow: 3px 3px 0 rgba(27, 37, 58, 0.8);
            display: inline-block;
        }

        .ld-actions .btn:hover {
            background: rgba(15, 20, 34, 0.95);
            border-color: #ffd24a;
            color: #ffd24a;
            transform: translate(2px, 2px);
            box-shadow: 1px 1px 0 rgba(27, 37, 58, 0.8);
        }

        .ld-actions .btn.primary {
            background: #ffd24a;
            color: #0b0f1a;
            border-color: #ffd24a;
            box-shadow: 4px 4px 0 #b89200;
        }

        .ld-actions .btn.primary:hover {
            background: #ffdc6a;
            transform: translate(2px, 2px);
            box-shadow: 2px 2px 0 #b89200;
        }

        .ld-stats {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 1.5rem;
            margin-bottom: 2.5rem;
        }

        .ld-stat-card {
            background: #121a2a;
            border: 2px solid #23304a;
            border-radius: 0;
            padding: 2rem 1.5rem;
            display: flex;
            flex-direction: column;
            gap: 1rem;
            position: relative;
            box-shadow: 0 8px 0 rgba(27, 37, 58, 0.8), 0 12px 24px rgba(0, 0, 0, 0.3);
            transition: all 0.2s ease;
        }

        .ld-stat-card:hover {
            border-color: #ffd24a;
            transform: translateY(-2px);
            box-shadow: 0 10px 0 rgba(27, 37, 58, 0.8), 0 16px 32px rgba(0, 0, 0, 0.4), 0 0 40px rgba(255, 210, 74, 0.2);
        }

        .ld-stat-label {
            font-size: 0.75rem;
            color: #9fb0d1;
            font-weight: 600;
            font-family: 'Press Start 2P', monospace;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .ld-stat-value {
            font-size: 2.5rem;
            font-weight: 900;
            color: #ffd24a;
            font-family: 'Press Start 2P', monospace;
            text-shadow: 3px 3px 0 rgba(0, 0, 0, 0.5);
            line-height: 1.2;
        }

        .ld-mid-row {
            display: grid;
            grid-template-columns: 2fr 1.4fr;
            gap: 1.5rem;
            margin-bottom: 2.5rem;
        }

        .ld-panel {
            background: #121a2a;
            border: 2px solid #23304a;
            border-radius: 0;
            padding: 2rem;
            box-shadow: 0 8px 0 rgba(27, 37, 58, 0.8), 0 12px 24px rgba(0, 0, 0, 0.3);
            position: relative;
            transition: all 0.2s ease;
        }

        .ld-panel:hover {
            border-color: #ffd24a;
            box-shadow: 0 8px 0 rgba(27, 37, 58, 0.8), 0 16px 32px rgba(0, 0, 0, 0.4), 0 0 40px rgba(255, 210, 74, 0.2);
        }

        .ld-panel-header {
            margin-bottom: 1.5rem;
            padding-bottom: 1rem;
            border-bottom: 2px solid #1b253a;
        }

        .ld-panel-title {
            margin: 0;
            font-size: 1rem;
            font-weight: 600;
            color: #e8eefc;
            font-family: 'Press Start 2P', monospace;
            font-size: 0.7rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .ld-metrics {
            display: flex;
            flex-wrap: wrap;
            gap: 1rem;
        }

        .ld-metric {
            flex: 1 1 9rem;
            background: rgba(15, 20, 34, 0.6);
            border-radius: 0;
            border: 2px solid #23304a;
            padding: 1.25rem 1rem;
            box-shadow: inset 0 3px 0 rgba(0, 0, 0, 0.3);
        }

        .ld-metric-label {
            font-size: 0.65rem;
            color: #9fb0d1;
            font-family: 'Press Start 2P', monospace;
            text-transform: uppercase;
            letter-spacing: 0.03em;
            margin-bottom: 0.75rem;
        }

        .ld-metric-value {
            font-size: 1.8rem;
            font-weight: 600;
            color: #ffd24a;
            font-family: 'Press Start 2P', monospace;
            text-shadow: 2px 2px 0 rgba(0, 0, 0, 0.5);
            line-height: 1.2;
        }

        .ld-top-course {
            padding: 1rem 0;
        }

        .ld-top-course-title {
            font-size: 1rem;
            font-weight: 600;
            margin-bottom: 0.75rem;
            color: #e8eefc;
            font-family: 'Press Start 2P', monospace;
            font-size: 0.7rem;
            text-transform: uppercase;
            letter-spacing: 0.03em;
            line-height: 1.5;
        }

        .ld-top-course-meta {
            font-size: 0.65rem;
            color: #9fb0d1;
            font-family: 'Press Start 2P', monospace;
            text-transform: uppercase;
            letter-spacing: 0.03em;
        }

        .ld-two-col {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 1.5rem;
        }

        .ld-list {
            display: flex;
            flex-direction: column;
            gap: 0.75rem;
        }

        .ld-list-item {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 1rem;
            padding: 1.25rem 1rem;
            border-radius: 0;
            background: rgba(15, 20, 34, 0.6);
            border: 2px solid #23304a;
            text-decoration: none;
            color: inherit;
            transition: all 0.2s ease;
            box-shadow: inset 0 3px 0 rgba(0, 0, 0, 0.3);
        }

        .ld-list-item:hover {
            border-color: #ffd24a;
            background: rgba(15, 20, 34, 0.8);
            transform: translateX(4px);
            box-shadow: inset 0 3px 0 rgba(0, 0, 0, 0.3), 0 0 20px rgba(255, 210, 74, 0.2);
        }

        .ld-list-main {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
            flex: 1;
        }

        .ld-list-title {
            font-size: 0.9rem;
            font-weight: 600;
            color: #e8eefc;
            font-family: 'Press Start 2P', monospace;
            font-size: 0.65rem;
            text-transform: uppercase;
            letter-spacing: 0.03em;
            line-height: 1.4;
        }

        .ld-list-meta {
            font-size: 0.6rem;
            color: #9fb0d1;
            font-family: 'Press Start 2P', monospace;
            text-transform: uppercase;
            letter-spacing: 0.03em;
        }

        .ld-list-extra {
            font-size: 0.6rem;
            color: #9fb0d1;
            white-space: nowrap;
            font-family: 'Press Start 2P', monospace;
            text-transform: uppercase;
            letter-spacing: 0.03em;
        }

        @media (max-width: 1024px) {
            .ld-stats {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }

            .ld-mid-row {
                grid-template-columns: 1fr;
            }

            .ld-two-col {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 640px) {
            .ld-stats {
                grid-template-columns: 1fr;
            }

            .ld-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 1rem;
            }

            .ld-actions {
                width: 100%;
            }

            .ld-actions .btn {
                flex: 1;
                text-align: center;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="MainBlock" ContentPlaceHolderID="LecturerMain" runat="server">

    <div class="ld-shell">
        <!-- Header row -->
        <div class="ld-header">
            <h2 class="ld-title">Dashboard</h2>
            <div class="ld-actions">
                <a href="<%= ResolveUrl("~/Lecturer/LecturerCourses.aspx") %>" class="btn">
                    View Courses
                </a>
                <a href="<%= ResolveUrl("~/Lecturer/LecturerAssessments.aspx") %>" class="btn">
                    View Assessment
                </a>
                <a href="<%= ResolveUrl("~/Lecturer/LecturerExamBuilder.aspx") %>" class="btn primary">
                    Build Assessment
                </a>
            </div>
        </div>

        <!-- Stat tiles -->
        <div class="ld-stats">
            <div class="ld-stat-card">
                <div class="ld-stat-label">My Courses</div>
                <div class="ld-stat-value">
                    <asp:Literal ID="litCoursesCount" runat="server" />
                </div>
            </div>

            <div class="ld-stat-card">
                <div class="ld-stat-label">Assessments</div>
                <div class="ld-stat-value">
                    <asp:Literal ID="litAssessmentsCount" runat="server" />
                </div>
            </div>

            <div class="ld-stat-card">
                <div class="ld-stat-label">Exercises</div>
                <div class="ld-stat-value">
                    <asp:Literal ID="litExercisesCount" runat="server" />
                </div>
            </div>

            <div class="ld-stat-card">
                <div class="ld-stat-label">Questions</div>
                <div class="ld-stat-value">
                    <asp:Literal ID="litQuestionsCount" runat="server" />
                </div>
            </div>
        </div>

        <!-- Mid row: engagement + top course (fills more vertical space) -->
        <div class="ld-mid-row">
            <div class="ld-panel ld-panel--metrics">
                <div class="ld-panel-header">
                    <h3 class="ld-panel-title">Students & engagement</h3>
                </div>
                <div class="ld-metrics">
                    <div class="ld-metric">
                        <div class="ld-metric-label">Unique students</div>
                        <div class="ld-metric-value">
                            <asp:Literal ID="litStudentsCount" runat="server" />
                        </div>
                    </div>
                    <div class="ld-metric">
                        <div class="ld-metric-label">Total enrollments across my courses</div>
                        <div class="ld-metric-value">
                            <asp:Literal ID="litEnrollmentsCount" runat="server" />
                        </div>
                    </div>
                    <div class="ld-metric">
                        <div class="ld-metric-label">Average progress</div>
                        <div class="ld-metric-value">
                            <asp:Literal ID="litAvgProgress" runat="server" />
                        </div>
                    </div>
                </div>
            </div>

            <div class="ld-panel ld-panel--metrics">
                <div class="ld-panel-header">
                    <h3 class="ld-panel-title">Top course</h3>
                </div>
                <div class="ld-top-course">
                    <div class="ld-top-course-title">
                        <asp:Literal ID="litTopCourseTitle" runat="server" />
                    </div>
                    <div class="ld-top-course-meta">
                        Enrollments:
                        <asp:Literal ID="litTopCourseEnrollments" runat="server" />
                    </div>
                </div>
            </div>
        </div>

        <!-- Two-column lists -->
        <div class="ld-two-col">
            <!-- Recent courses -->
            <div class="ld-panel">
                <div class="ld-panel-header">
                    <h3 class="ld-panel-title">Recent Courses</h3>
                </div>

                <asp:Label ID="lblCoursesEmpty" runat="server"
                           CssClass="muted" Visible="false" />

                <asp:Repeater ID="rptRecentCourses" runat="server">
                    <HeaderTemplate>
                        <div class="ld-list">
                    </HeaderTemplate>

                    <ItemTemplate>
                        <a class="ld-list-item"
                           href='<%# ResolveUrl("~/Lecturer/LecturerCourseDetails.aspx?courseId=" + Eval("CourseId")) %>'>
                            <div class="ld-list-main">
                                <div class="ld-list-title"><%# Eval("CourseTitle") %></div>
                                <div class="ld-list-meta">
                                    Lessons: <%# Eval("TotalLessons") %>
                                </div>
                            </div>
                            <div class="ld-list-extra">
                                <%# string.Format("{0:dd MMM yyyy}", Eval("CourseCreatedAt")) %>
                            </div>
                        </a>
                    </ItemTemplate>

                    <FooterTemplate>
                        </div>
                    </FooterTemplate>
                </asp:Repeater>
            </div>

            <!-- Recent assessments -->
            <div class="ld-panel">
                <div class="ld-panel-header">
                    <h3 class="ld-panel-title">Recent Assessments</h3>
                </div>

                <asp:Label ID="lblAssessmentsEmpty" runat="server"
                           CssClass="muted" Visible="false" />

                <asp:Repeater ID="rptRecentAssessments" runat="server">
                    <HeaderTemplate>
                        <div class="ld-list">
                    </HeaderTemplate>

                    <ItemTemplate>
                        <a class="ld-list-item"
                           href='<%# ResolveUrl("~/Lecturer/LecturerAssessmentDetails.aspx?quizId=" + Eval("QuizId")) %>'>
                            <div class="ld-list-main">
                                <div class="ld-list-title"><%# Eval("QuizTitle") %></div>
                                <div class="ld-list-meta">
                                    Questions: <%# Eval("QuestionCount") %>
                                </div>
                            </div>
                            <div class="ld-list-extra">
                                ID: <%# Eval("QuizId") %>
                            </div>
                        </a>
                    </ItemTemplate>

                    <FooterTemplate>
                        </div>
                    </FooterTemplate>
                </asp:Repeater>
            </div>
        </div>
    </div>

</asp:Content>

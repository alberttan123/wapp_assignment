<%@ Page Title="Lecturer • Dashboard"
    Language="C#"
    MasterPageFile="~/Lecturer/Lecturer.Master"
    AutoEventWireup="true"
    CodeBehind="LecturerDashboard.aspx.cs"
    Inherits="WAPP_Assignment.Lecturer.LecturerDashboard" %>

<asp:Content ID="HeadBlock" ContentPlaceHolderID="HeadLecturer" runat="server">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Press+Start+2P&display=swap');
        
        .ld-shell {
            width: 100%;
            margin: 0;
            padding: 2rem;
            background: #121a2a;
            min-height: 100vh;
        }

        .ld-header {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            gap: 0.75rem;
            margin-bottom: 2rem;
        }

        .ld-title-block {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }

        .ld-title {
            font-family: 'Press Start 2P', monospace;
            font-size: 1.2rem;
            font-weight: 700;
            color: #ffd24a;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            text-shadow: 3px 3px 0 rgba(0, 0, 0, 0.5);
            margin: 0;
        }

        .ld-subtitle {
            font-size: 0.85rem;
            color: #9fb0d1;
            font-weight: 500;
        }

        .ld-header-right {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .ld-actions {
            display: flex;
            gap: 0.75rem;
        }

        .ld-actions .btn {
            font-family: 'Press Start 2P', monospace;
            font-size: 0.6rem;
            padding: 0.75rem 1.25rem;
            background: #ffd24a;
            color: #0f1422;
            border: 2px solid #23304a;
            border-radius: 10px;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            text-decoration: none;
            font-weight: 700;
            box-shadow: 0 4px 0 rgba(27, 37, 58, 0.8), 0 6px 12px rgba(0, 0, 0, 0.3);
            transition: all 0.2s ease;
            cursor: pointer;
            display: inline-block;
        }

        .ld-actions .btn:hover {
            background: #ffffff;
            transform: translateY(-2px);
            box-shadow: 0 6px 0 rgba(27, 37, 58, 0.8), 0 8px 16px rgba(0, 0, 0, 0.4);
        }

        .ld-actions .btn:active {
            transform: translateY(0);
            box-shadow: 0 2px 0 rgba(27, 37, 58, 0.8), 0 4px 8px rgba(0, 0, 0, 0.3);
        }

        .ld-profile-card {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 0.75rem 1rem;
            border-radius: 0;
            border: 2px solid #23304a;
            background: #121a2a;
            box-shadow: 0 4px 0 rgba(27, 37, 58, 0.8), 0 6px 12px rgba(0, 0, 0, 0.3);
            transition: all 0.2s ease;
        }

        .ld-profile-card:hover {
            border-color: #ffd24a;
            transform: translateY(-2px);
            box-shadow: 0 6px 0 rgba(27, 37, 58, 0.8), 0 8px 16px rgba(0, 0, 0, 0.4);
        }

        .ld-profile-main {
            display: flex;
            flex-direction: column;
            gap: 0.25rem;
        }

        .ld-profile-name {
            font-size: 0.9rem;
            font-weight: 600;
            color: #e8eefc;
        }

        .ld-profile-meta {
            font-size: 0.75rem;
            color: #9fb0d1;
        }

        .ld-profile-role-pill {
            display: inline-block;
            margin-right: 0.3rem;
            padding: 0.2rem 0.5rem;
            border-radius: 6px;
            border: 1px solid #23304a;
            background: rgba(27, 37, 58, 0.6);
            font-size: 0.7rem;
            color: #9fb0d1;
        }

        .ld-profile-actions .btn {
            font-family: 'Press Start 2P', monospace;
            font-size: 0.55rem;
            padding: 0.5rem 0.75rem;
            background: rgba(27, 37, 58, 0.8);
            color: #e8eefc;
            border: 2px solid #23304a;
            border-radius: 8px;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            text-decoration: none;
            font-weight: 700;
            box-shadow: 0 3px 0 rgba(27, 37, 58, 0.8);
            transition: all 0.2s ease;
            cursor: pointer;
        }

        .ld-profile-actions .btn:hover {
            background: rgba(35, 48, 74, 0.9);
            transform: translateY(-1px);
            box-shadow: 0 4px 0 rgba(27, 37, 58, 0.8);
        }

        @media (max-width: 37.5rem) {
            .ld-header {
                flex-direction: column;
                align-items: flex-start;
            }

            .ld-header-right {
                width: 100%;
                justify-content: flex-start;
            }

            .ld-profile-card {
                width: 100%;
            }
        }

        .ld-top-grid {
            display: grid;
            grid-template-columns: minmax(0, 1.4fr) minmax(0, 1.6fr);
            gap: 1.5rem;
            margin-bottom: 1.5rem;
        }

        @media (max-width: 56.25rem) {
            .ld-top-grid {
                grid-template-columns: minmax(0, 1fr);
            }
        }

        .ld-stats {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 0.75rem;
        }

        @media (max-width: 48rem) {
            .ld-stats {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 30rem) {
            .ld-stats {
                grid-template-columns: minmax(0, 1fr);
            }
        }

        .ld-card {
            background: #121a2a;
            border-radius: 0;
            border: 2px solid #23304a;
            padding: 1.5rem;
            box-shadow: 0 8px 0 rgba(27, 37, 58, 0.8), 0 12px 24px rgba(0, 0, 0, 0.3);
            position: relative;
            transition: all 0.2s ease;
        }

        .ld-card--accent-main {
            background: linear-gradient(135deg, rgba(15, 20, 34, 0.9) 0%, rgba(18, 26, 42, 0.9) 60%, rgba(30, 41, 59, 0.9) 100%);
        }

        .ld-panel {
            background: #121a2a;
            border-radius: 0;
            border: 2px solid #23304a;
            padding: 1.5rem;
            box-shadow: 0 8px 0 rgba(27, 37, 58, 0.8), 0 12px 24px rgba(0, 0, 0, 0.3);
            transition: all 0.2s ease;
        }

        .ld-panel:hover {
            border-color: #ffd24a;
            transform: translateY(-2px);
            box-shadow: 0 10px 0 rgba(27, 37, 58, 0.8), 0 14px 28px rgba(0, 0, 0, 0.4), 0 0 30px rgba(255, 210, 74, 0.2);
        }

        .ld-panel-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 1rem;
        }

        .ld-panel-title {
            font-family: 'Press Start 2P', monospace;
            font-size: 0.7rem;
            font-weight: 700;
            color: #ffd24a;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            text-shadow: 2px 2px 0 rgba(0, 0, 0, 0.5);
        }

        .ld-stat-card {
            background: rgba(27, 37, 58, 0.6);
            border: 2px solid #23304a;
            border-radius: 0;
            padding: 1rem;
            text-align: center;
            box-shadow: inset 0 3px 0 rgba(0, 0, 0, 0.3), 0 4px 0 rgba(27, 37, 58, 0.8);
            transition: all 0.2s ease;
        }

        .ld-stat-card:hover {
            border-color: #ffd24a;
            transform: translateY(-2px);
            box-shadow: inset 0 3px 0 rgba(0, 0, 0, 0.3), 0 6px 0 rgba(27, 37, 58, 0.8);
        }

        .ld-stat-label {
            font-family: 'Press Start 2P', monospace;
            font-size: 0.5rem;
            color: #9fb0d1;
            margin-bottom: 0.5rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .ld-stat-value {
            font-family: 'Press Start 2P', monospace;
            font-size: 0.9rem;
            font-weight: 700;
            color: #ffd24a;
            text-shadow: 2px 2px 0 rgba(0, 0, 0, 0.5);
        }

        .ld-metrics {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 1rem;
        }

        @media (max-width: 40rem) {
            .ld-metrics {
                grid-template-columns: minmax(0, 1fr);
            }
        }

        .ld-metric {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }

        .ld-metric-label {
            font-family: 'Press Start 2P', monospace;
            font-size: 0.5rem;
            color: #9fb0d1;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .ld-metric-value {
            font-family: 'Press Start 2P', monospace;
            font-size: 0.8rem;
            color: #e8eefc;
            font-weight: 700;
            text-shadow: 2px 2px 0 rgba(0, 0, 0, 0.5);
        }

        .ld-top-course {
            margin-top: 1rem;
            padding-top: 1rem;
            border-top: 2px solid #23304a;
        }

        .ld-top-course-title {
            font-size: 0.85rem;
            color: #e8eefc;
            font-weight: 600;
            margin-bottom: 0.25rem;
        }

        .ld-top-course-meta {
            font-size: 0.75rem;
            color: #9fb0d1;
        }

        .ld-bottom-grid {
            display: grid;
            grid-template-columns: minmax(0, 1.4fr) minmax(0, 1.4fr);
            gap: 1.5rem;
        }

        @media (max-width: 56.25rem) {
            .ld-bottom-grid {
                grid-template-columns: minmax(0, 1fr);
            }
        }

        .ld-two-col {
            display: grid;
            grid-template-columns: minmax(0, 1.4fr) minmax(0, 1.4fr);
            gap: 1.5rem;
        }

        @media (max-width: 56.25rem) {
            .ld-two-col {
                grid-template-columns: minmax(0, 1fr);
            }
        }

        .ld-list {
            display: flex;
            flex-direction: column;
            gap: 0.75rem;
        }

        .ld-list-item {
            padding: 1rem;
            border-radius: 0;
            border: 2px solid #23304a;
            background: rgba(27, 37, 58, 0.6);
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 1rem;
            box-shadow: 0 4px 0 rgba(27, 37, 58, 0.8);
            transition: all 0.2s ease;
        }

        .ld-list-item:hover {
            background: rgba(35, 48, 74, 0.8);
            border-color: #ffd24a;
            transform: translateY(-2px);
            box-shadow: 0 6px 0 rgba(27, 37, 58, 0.8);
        }

        .ld-list-main {
            display: flex;
            flex-direction: column;
            gap: 0.25rem;
            flex: 1;
        }

        .ld-list-title {
            font-size: 0.9rem;
            color: #e8eefc;
            font-weight: 600;
        }

        .ld-list-meta {
            font-size: 0.75rem;
            color: #9fb0d1;
        }

        .ld-list-extra {
            font-size: 0.7rem;
            padding: 0.3rem 0.6rem;
            border-radius: 0;
            border: 1px solid #23304a;
            background: rgba(15, 20, 34, 0.8);
            color: #9fb0d1;
            white-space: nowrap;
        }

        .ld-empty-label {
            font-size: 0.85rem;
            color: #9fb0d1;
            text-align: center;
            padding: 2rem;
        }

        /* ---------- Your content pie chart ---------- */

        .ld-content-body {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        @media (max-width: 48rem) {
            .ld-content-body {
                flex-direction: column;
                align-items: flex-start;
            }
        }

        .ld-pie-wrap {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 0.25rem;
        }

        .ld-pie {
            --ld-pie-courses: #ffd24a;
            --ld-pie-assessments: #6bc2ff;
            --ld-pie-exercises: #ff9f6b;
            --ld-pie-questions: #b48bff;

            width: 5rem;
            height: 5rem;
            border-radius: 50%;
            background: rgba(27, 37, 58, 0.6);
            border: 2px solid #23304a;
            box-shadow: 0 4px 0 rgba(27, 37, 58, 0.8);
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .ld-pie-inner {
            width: 3.375rem;
            height: 3.375rem;
            border-radius: 50%;
            background: #121a2a;
            display: flex;
            align-items: center;
            justify-content: center;
            border: 2px solid #23304a;
            font-family: 'Press Start 2P', monospace;
            font-size: 0.55rem;
            text-transform: uppercase;
            letter-spacing: 0.03em;
            color: #ffd24a;
            text-align: center;
        }

        .ld-content-label {
            font-size: 0.7rem;
            color: #9fb0d1;
            text-align: center;
        }

        .ld-content-legend {
            flex: 1;
            font-size: 0.8rem;
            color: #e8eefc;
        }

        .ld-content-legend-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 0.5rem;
        }

        .ld-content-label-wrap {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .ld-dot {
            width: 0.75rem;
            height: 0.75rem;
            border-radius: 0;
            box-shadow: 0 2px 0 rgba(27, 37, 58, 0.8);
            border: 1px solid #23304a;
        }

        .ld-dot--courses {
            background: #ffd24a;
        }

        .ld-dot--assessments {
            background: #6bc2ff;
        }

        .ld-dot--exercises {
            background: #ff9f6b;
        }

        .ld-dot--questions {
            background: #b48bff;
        }

        .ld-content-badge {
            font-family: 'Press Start 2P', monospace;
            font-size: 0.55rem;
            padding: 0.3rem 0.6rem;
            border-radius: 0;
            border: 1px solid #23304a;
            background: rgba(15, 20, 34, 0.9);
            color: #e8eefc;
            box-shadow: 0 2px 0 rgba(27, 37, 58, 0.8);
        }
    </style>
</asp:Content>

<asp:Content ID="MainBlock" ContentPlaceHolderID="LecturerMain" runat="server">
    <div class="ld-shell">
        <!-- Header with profile card -->
        <div class="ld-header">
            <div class="ld-title-block">
                <div class="ld-title">Lecturer Dashboard</div>
                <div class="ld-subtitle">
                    <asp:Literal ID="litDashboardSubtitle" runat="server" />
                </div>
            </div>

            <div class="ld-header-right">
                <div class="ld-actions">
                    <a href="<%= ResolveUrl("~/Lecturer/LecturerAssessments.aspx") %>" class="btn">View Assessment</a>
                </div>
                <div class="ld-profile-card">
                    <div class="ld-profile-main">
                        <div class="ld-profile-name">
                            <asp:Literal ID="litProfileName" runat="server" />
                        </div>
                        <div class="ld-profile-meta">
                            <span class="ld-profile-role-pill">
                                <asp:Literal ID="litProfileRole" runat="server" />
                            </span>
                            <asp:Literal ID="litProfileEmail" runat="server" />
                        </div>
                    </div>
                    <div class="ld-profile-actions">
                        <asp:LinkButton ID="btnLogout" runat="server"
                            CssClass="btn"
                            OnClick="btnLogout_Click">
                            Logout
                        </asp:LinkButton>
                    </div>
                </div>
            </div>
        </div>

        <!-- Top section: content pie + engagement -->
        <div class="ld-top-grid">
            <!-- Your content (now with pie chart) -->
            <div class="ld-panel">
                <div class="ld-panel-header">
                    <div class="ld-panel-title">Your content</div>
                </div>

                <div class="ld-content-body">
                    <div class="ld-pie-wrap">
                        <div id="divContentPie" runat="server" class="ld-pie">
                            <div class="ld-pie-inner">
                                <asp:Literal ID="litContentPercent" runat="server" />
                            </div>
                        </div>
                        <div class="ld-content-label">
                            <asp:Literal ID="litContentPieCaption" runat="server" />
                        </div>
                    </div>

                    <div class="ld-content-legend">
                        <div class="ld-content-legend-row">
                            <div class="ld-content-label-wrap">
                                <span class="ld-dot ld-dot--courses"></span>
                                <span class="ld-content-label">Courses</span>
                            </div>
                            <span class="ld-content-badge">
                                <asp:Literal ID="litCoursesCount" runat="server" />
                            </span>
                        </div>

                        <div class="ld-content-legend-row">
                            <div class="ld-content-label-wrap">
                                <span class="ld-dot ld-dot--assessments"></span>
                                <span class="ld-content-label">Assessments</span>
                            </div>
                            <span class="ld-content-badge">
                                <asp:Literal ID="litAssessmentsCount" runat="server" />
                            </span>
                        </div>

                        <div class="ld-content-legend-row">
                            <div class="ld-content-label-wrap">
                                <span class="ld-dot ld-dot--exercises"></span>
                                <span class="ld-content-label">Exercises</span>
                            </div>
                            <span class="ld-content-badge">
                                <asp:Literal ID="litExercisesCount" runat="server" />
                            </span>
                        </div>

                        <div class="ld-content-legend-row">
                            <div class="ld-content-label-wrap">
                                <span class="ld-dot ld-dot--questions"></span>
                                <span class="ld-content-label">Questions</span>
                            </div>
                            <span class="ld-content-badge">
                                <asp:Literal ID="litQuestionsCount" runat="server" />
                            </span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Engagement -->
            <div class="ld-panel ld-card--accent-main" style="background: linear-gradient(135deg, rgba(15, 20, 34, 0.9) 0%, rgba(18, 26, 42, 0.9) 60%, rgba(30, 41, 59, 0.9) 100%);">
                <div class="ld-panel-header">
                    <div class="ld-panel-title">Student engagement</div>
                </div>
                <div class="ld-metrics">
                    <div class="ld-metric">
                        <div class="ld-metric-label">Unique students</div>
                        <div class="ld-metric-value">
                            <asp:Literal ID="litStudentsCount" runat="server" />
                        </div>
                    </div>

                    <div class="ld-metric">
                        <div class="ld-metric-label">Total enrollments</div>
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

                    <div class="ld-metric">
                        <div class="ld-metric-label">Top course</div>
                        <div class="ld-top-course">
                            <div class="ld-top-course-title">
                                <asp:Literal ID="litTopCourseTitle" runat="server" />
                            </div>
                            <div class="ld-top-course-meta">
                                <asp:Literal ID="litTopCourseEnrollments" runat="server" /> enrollments
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bottom section: recent courses + assessments -->
        <div class="ld-bottom-grid">
            <!-- Recent courses -->
            <div class="ld-panel">
                <div class="ld-panel-header">
                    <div class="ld-panel-title">Recent courses</div>
                </div>

                <asp:Label ID="lblCoursesEmpty" runat="server" CssClass="ld-empty-label" Visible="false" />

                <div class="ld-list">
                    <asp:Repeater ID="rptRecentCourses" runat="server">
                        <ItemTemplate>
                            <div class="ld-list-item">
                                <div class="ld-list-main">
                                    <div class="ld-list-title"><%# Eval("CourseTitle") %></div>
                                    <div class="ld-list-meta">
                                        Lessons: <%# Eval("TotalLessons") %> •
                                        Created: <%# ((DateTime)Eval("CourseCreatedAt")).ToString("dd MMM yyyy") %>
                                    </div>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </div>

            <!-- Recent assessments -->
            <div class="ld-panel">
                <div class="ld-panel-header">
                    <div class="ld-panel-title">Recent assessments</div>
                </div>

                <asp:Label ID="lblAssessmentsEmpty" runat="server" CssClass="ld-empty-label" Visible="false" />

                <div class="ld-list">
                    <asp:Repeater ID="rptRecentAssessments" runat="server">
                        <ItemTemplate>
                            <div class="ld-list-item">
                                <div class="ld-list-main">
                                    <div class="ld-list-title"><%# Eval("QuizTitle") %></div>
                                    <div class="ld-list-meta">
                                        <%# Eval("QuestionCount") %> questions
                                    </div>
                                </div>
                                <span class="ld-list-extra">
                                    Assessment
                                </span>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

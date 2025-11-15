<%@ Page Title="Lecturer • Dashboard"
    Language="C#"
    MasterPageFile="~/Lecturer/Lecturer.Master"
    AutoEventWireup="true"
    CodeBehind="LecturerDashboard.aspx.cs"
    Inherits="WAPP_Assignment.Lecturer.LecturerDashboard" %>

<asp:Content ID="HeadBlock" ContentPlaceHolderID="HeadLecturer" runat="server">
    <style>
        .ld-shell {
            width: 100%;
            margin: 0;
            padding: 0.5rem 0 1.25rem;
        }

        .ld-header {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            gap: 0.75rem;
            margin-bottom: 0.75rem;
        }

        .ld-title-block {
            display: flex;
            flex-direction: column;
            gap: 0.2rem;
        }

        .ld-title {
            font-size: 1.6rem;
            font-weight: 700;
            color: var(--brand);
            text-shadow: 0 0 0.0625rem #000;
        }

        .ld-subtitle {
            font-size: 0.82rem;
            color: var(--muted);
        }

        .ld-header-right {
            display: flex;
            align-items: center;
        }

        .ld-profile-card {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 0.4rem 0.75rem;
            border-radius: 999px;
            border: 0.0625rem solid var(--line);
            background: var(--panel-2);
            box-shadow:
                0 0 0 0.0625rem #00000040,
                0 0.1875rem 0 0 #00000060;
        }

        .ld-profile-main {
            display: flex;
            flex-direction: column;
            gap: 0.1rem;
        }

        .ld-profile-name {
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--text);
        }

        .ld-profile-meta {
            font-size: 0.75rem;
            color: var(--muted);
        }

        .ld-profile-role-pill {
            display: inline-block;
            margin-right: 0.3rem;
            padding: 0.05rem 0.45rem;
            border-radius: 999px;
            border: 0.0625rem solid var(--line);
            background: var(--panel);
            font-size: 0.7rem;
            color: var(--muted);
        }

        .ld-profile-actions .btn {
            font-size: 0.75rem;
            padding: 0.25rem 0.7rem;
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
                border-radius: 0.5rem;
            }
        }

        .ld-top-grid {
            display: grid;
            grid-template-columns: minmax(0, 1.4fr) minmax(0, 1.6fr);
            gap: 0.75rem;
            margin-bottom: 0.75rem;
        }

        @media (max-width: 56.25rem) {
            .ld-top-grid {
                grid-template-columns: minmax(0, 1fr);
            }
        }

        .ld-stats-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 0.5rem;
        }

        @media (max-width: 48rem) {
            .ld-stats-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        .ld-card {
            background: var(--panel);
            border-radius: 0.625rem;
            border: 0.0625rem solid var(--line);
            padding: 0.75rem 0.75rem;
            box-shadow:
                0 0 0 0.0625rem #00000040,
                0 0.25rem 0 0 #00000050;
        }

        .ld-card--accent-main {
            background: linear-gradient(135deg, var(--panel) 0%, var(--panel-2) 60%, #24272e 100%);
        }

        .ld-card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 0.4rem;
            margin-bottom: 0.4rem;
        }

        .ld-card-title {
            font-size: 0.9rem;
            font-weight: 600;
            color: var(--text);
        }

        .ld-card-subtitle {
            font-size: 0.8rem;
            color: var(--muted);
        }

        .ld-stat-label {
            font-size: 0.78rem;
            color: var(--muted);
            margin-bottom: 0.15rem;
        }

        .ld-stat-value {
            font-size: 1.15rem;
            font-weight: 600;
            color: var(--text);
        }

        .ld-engagement-body {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 0.5rem;
        }

        @media (max-width: 40rem) {
            .ld-engagement-body {
                grid-template-columns: minmax(0, 1fr);
            }
        }

        .ld-eng-item-label {
            font-size: 0.78rem;
            color: var(--muted);
        }

        .ld-eng-item-value {
            font-size: 0.95rem;
            color: var(--text);
            font-weight: 500;
        }

        .ld-eng-topcourse-title {
            font-size: 0.8rem;
            color: var(--text);
            font-weight: 500;
        }

        .ld-eng-topcourse-meta {
            font-size: 0.78rem;
            color: var(--muted);
        }

        .ld-bottom-grid {
            display: grid;
            grid-template-columns: minmax(0, 1.4fr) minmax(0, 1.4fr);
            gap: 0.75rem;
        }

        @media (max-width: 56.25rem) {
            .ld-bottom-grid {
                grid-template-columns: minmax(0, 1fr);
            }
        }

        .ld-list-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 0.4rem;
            margin-bottom: 0.4rem;
        }

        .ld-list {
            display: flex;
            flex-direction: column;
            gap: 0.3rem;
        }

        .ld-list-item {
            padding: 0.4rem 0.5rem;
            border-radius: 0.5rem;
            border: 0.0625rem solid var(--line);
            background: var(--panel-2);
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 0.4rem;
        }

        .ld-list-main {
            display: flex;
            flex-direction: column;
            gap: 0.1rem;
        }

        .ld-list-title {
            font-size: 0.85rem;
            color: var(--text);
            font-weight: 500;
        }

        .ld-list-meta {
            font-size: 0.78rem;
            color: var(--muted);
        }

        .ld-list-pill {
            font-size: 0.78rem;
            padding: 0.1rem 0.45rem;
            border-radius: 999px;
            border: 0.0625rem solid var(--line);
            background: var(--panel);
            color: var(--muted);
            white-space: nowrap;
        }

        .ld-empty-label {
            font-size: 0.8rem;
            color: var(--muted);
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

        <!-- Top section: stats + engagement -->
        <div class="ld-top-grid">
            <!-- Quick stats -->
            <div class="ld-card">
                <div class="ld-card-header">
                    <div class="ld-card-title">Your content</div>
                </div>
                <div class="ld-stats-grid">
                    <div>
                        <div class="ld-stat-label">Courses</div>
                        <div class="ld-stat-value">
                            <asp:Literal ID="litCoursesCount" runat="server" />
                        </div>
                    </div>
                    <div>
                        <div class="ld-stat-label">Assessments</div>
                        <div class="ld-stat-value">
                            <asp:Literal ID="litAssessmentsCount" runat="server" />
                        </div>
                    </div>
                    <div>
                        <div class="ld-stat-label">Exercises</div>
                        <div class="ld-stat-value">
                            <asp:Literal ID="litExercisesCount" runat="server" />
                        </div>
                    </div>
                    <div>
                        <div class="ld-stat-label">Questions</div>
                        <div class="ld-stat-value">
                            <asp:Literal ID="litQuestionsCount" runat="server" />
                        </div>
                    </div>
                </div>
            </div>

            <!-- Engagement -->
            <div class="ld-card ld-card--accent-main">
                <div class="ld-card-header">
                    <div class="ld-card-title">Student engagement</div>
                </div>
                <div class="ld-engagement-body">
                    <div>
                        <div class="ld-eng-item-label">Unique students</div>
                        <div class="ld-eng-item-value">
                            <asp:Literal ID="litStudentsCount" runat="server" />
                        </div>

                        <div class="ld-eng-item-label" style="margin-top:0.35rem;">Total enrollments</div>
                        <div class="ld-eng-item-value">
                            <asp:Literal ID="litEnrollmentsCount" runat="server" />
                        </div>
                    </div>

                    <div>
                        <div class="ld-eng-item-label">Average progress</div>
                        <div class="ld-eng-item-value">
                            <asp:Literal ID="litAvgProgress" runat="server" />
                        </div>

                        <div class="ld-eng-item-label" style="margin-top:0.35rem;">Top course</div>
                        <div class="ld-eng-topcourse-title">
                            <asp:Literal ID="litTopCourseTitle" runat="server" />
                        </div>
                        <div class="ld-eng-topcourse-meta">
                            <asp:Literal ID="litTopCourseEnrollments" runat="server" /> enrollments
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bottom section: recent courses + assessments -->
        <div class="ld-bottom-grid">
            <!-- Recent courses -->
            <div class="ld-card">
                <div class="ld-list-header">
                    <div class="ld-card-title">Recent courses</div>
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
            <div class="ld-card">
                <div class="ld-list-header">
                    <div class="ld-card-title">Recent assessments</div>
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
                                <span class="ld-list-pill">
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

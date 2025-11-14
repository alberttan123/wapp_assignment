<%@ Page Title="Lecturer • Dashboard" Language="C#"
    MasterPageFile="~/Lecturer/Lecturer.Master"
    AutoEventWireup="true"
    CodeBehind="LecturerDashboard.aspx.cs"
    Inherits="WAPP_Assignment.Lecturer.LecturerDashboard" %>

<asp:Content ID="HeadBlock" ContentPlaceHolderID="HeadLecturer" runat="server">
    <!-- Uses shared LecturerPages.css via Lecturer.Master -->
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
                <a href="<%= ResolveUrl("~/Lecturer/LecturerCourseBuilder.aspx") %>" class="btn">
                    New Course
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

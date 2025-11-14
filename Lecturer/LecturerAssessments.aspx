<%@ Page Title="Lecturer • Assessments" Language="C#"
    MasterPageFile="~/Lecturer/Lecturer.Master"
    AutoEventWireup="true"
    CodeBehind="LecturerAssessments.aspx.cs"
    Inherits="WAPP_Assignment.Lecturer.LecturerAssessments" %>

<asp:Content ID="HeadBlock" ContentPlaceHolderID="HeadLecturer" runat="server">
    <!-- Uses shared LecturerPages.css from Lecturer.Master -->
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

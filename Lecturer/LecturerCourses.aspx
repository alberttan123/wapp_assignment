<%@ Page Title="Lecturer • Courses" Language="C#"
    MasterPageFile="~/Lecturer/Lecturer.Master"
    AutoEventWireup="true"
    CodeBehind="LecturerCourses.aspx.cs"
    Inherits="WAPP_Assignment.Lecturer.LecturerCourses" %>

<asp:Content ID="HeadBlock" ContentPlaceHolderID="HeadLecturer" runat="server">
    <!-- page-level head if needed -->
</asp:Content>

<asp:Content ID="MainBlock" ContentPlaceHolderID="LecturerMain" runat="server">
    <div class="lc-header">Courses</div>

    <div class="lc-bar">
        <div class="lc-search">
            <asp:TextBox ID="txtSearch" runat="server" CssClass="input"
                         Placeholder="Search by course title"
                         AutoPostBack="true"
                         OnTextChanged="TxtSearch_TextChanged" />
        </div>
        <a href="<%= ResolveUrl("~/Lecturer/LecturerCourseBuilder.aspx") %>" class="btn">
            Build a Course
        </a>
    </div>

    <asp:Label ID="lblInfo" runat="server" CssClass="muted" Visible="false" />

    <asp:Repeater ID="rptCourses" runat="server" OnItemCommand="RptCourses_ItemCommand">
        <HeaderTemplate>
            <div class="lc-grid">
        </HeaderTemplate>
        <ItemTemplate>
            <div class="lc-card">
                <asp:HyperLink ID="lnkCourse" runat="server"
                               CssClass="lc-card-link"
                               NavigateUrl='<%# "~/Lecturer/LecturerCourseDetails.aspx?courseId=" + Eval("CourseId") %>'>
                    <div class="lc-banner">
                        <asp:Image ID="imgBanner" runat="server"
                                   ImageUrl='<%# GetBannerUrl(Eval("CourseImgUrl")) %>'
                                   AlternateText="" />
                    </div>
                    <div class="lc-card-body">
                        <h3><%# Eval("CourseTitle") %></h3>
                        <p class="lc-meta">
                            Chapters: <%# Eval("ChapterCount") %> &bull;
                            Quizzes: <%# Eval("QuizCount") %>
                        </p>
                        <p class="lc-date">
                            Created: <%# string.Format("{0:dd MMM yyyy}", Eval("CourseCreatedAt")) %>
                        </p>
                    </div>
                </asp:HyperLink>
                <div class="lc-card-footer">
                    <asp:LinkButton ID="btnDelete" runat="server"
                                    CssClass="btn"
                                    CommandName="delete"
                                    CommandArgument='<%# Eval("CourseId") %>'
                                    OnClientClick="return confirm('Delete this course and all its chapters?');"
                                    CausesValidation="false">
                        Delete
                    </asp:LinkButton>
                </div>
            </div>
        </ItemTemplate>
        <FooterTemplate>
            </div>
        </FooterTemplate>
    </asp:Repeater>
</asp:Content>

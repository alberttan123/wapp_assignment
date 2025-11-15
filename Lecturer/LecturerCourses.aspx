<%@ Page Title="Lecturer • Courses" Language="C#"
    MasterPageFile="~/Lecturer/Lecturer.Master"
    AutoEventWireup="true"
    CodeBehind="LecturerCourses.aspx.cs"
    Inherits="WAPP_Assignment.Lecturer.LecturerCourses" %>

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

        .lc-bar .btn {
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
            white-space: nowrap;
        }

        .lc-bar .btn:hover {
            background: rgba(15, 20, 34, 0.95);
            border-color: #ffd24a;
            color: #ffd24a;
            transform: translate(2px, 2px);
            box-shadow: 1px 1px 0 rgba(27, 37, 58, 0.8);
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

        .lc-banner {
            height: 12rem;
            background: #000;
            overflow: hidden;
            position: relative;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0;
            padding: 0;
        }

        .lc-banner img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            object-position: center;
            display: block;
            margin: 0;
            padding: 0;
            image-rendering: pixelated;
            image-rendering: -moz-crisp-edges;
            image-rendering: crisp-edges;
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

        .lc-date {
            font-size: 0.6rem;
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

            .lc-bar .btn {
                width: 100%;
                text-align: center;
            }
        }
    </style>
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

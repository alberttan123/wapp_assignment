<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ViewCourse.aspx.cs" Inherits="WAPP_Assignment.Student.ViewCourse" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="<%= ResolveUrl("~/Content/waplanding.css") %>" rel="stylesheet" />
    <link href="<%= ResolveUrl("~/Content/ViewCourse.css") %>" rel="stylesheet" />
    <style>
    .course-container, .course-header, .course-description-container, .course-content-container, .content-card{
	    border: 3px solid yellow;
        margin: 1rem;
    }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="course-container">

        <div class="course-header">
            <div class="course-title"><asp:Label ID="courseTitle" runat="server"></asp:Label></div>
            <div class="course-info"><asp:Label ID="courseInfo" runat="server"></asp:Label></div>
        </div>

        <div class="course-description-container">
            <div class="course-description-title">
                <span>Description</span>
            </div>
            <div class="course-description-content">
                <asp:Label ID="courseDescription" runat="server"></asp:Label>
            </div>
        </div>

        <asp:Panel ID="course_content_container" CssClass="course-content-container" runat="server" Visible="true">
        </asp:Panel>

    </div>
</asp:Content>

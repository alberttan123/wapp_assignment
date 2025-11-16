<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master"
    AutoEventWireup="true" CodeBehind="ViewCourse.aspx.cs"
    Inherits="WAPP_Assignment.Student.ViewCourse" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="<%= ResolveUrl("~/Content/waplanding.css") %>" rel="stylesheet" />
    <link href="<%= ResolveUrl("~/Content/ViewCourse.css") %>" rel="stylesheet" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div class="course-header-retro">
        <div class="course-header-content">
            <h1 class="course-title-retro">
                <asp:Label ID="courseTitle" runat="server" CssClass="courseTitle"></asp:Label>
            </h1>
            <p class="course-info-retro">
                <asp:Label ID="courseInfo" runat="server"></asp:Label>
            </p>
        </div>

        <div class="course-desc-retro">
            <span class="course-desc-title">📘 Description</span>
            <div class="course-desc-text">
                <asp:Label ID="courseDescription" runat="server"></asp:Label>
            </div>
        </div>
    </div>

    <asp:Panel ID="course_content_container" CssClass="course-content-retro" runat="server" Visible="true"></asp:Panel>
</asp:Content>
<%@ Page Title="Lecturer • Courses" Language="C#"
    MasterPageFile="~/Lecturer/Lecturer.Master"
    AutoEventWireup="true"
    CodeBehind="LecturerCourses.aspx.cs"
    Inherits="WAPP_Assignment.Lecturer.LecturerCourses" %>

<asp:Content ID="HeadBlock" ContentPlaceHolderID="HeadLecturer" runat="server">
    <%-- page-level <head> items if needed --%>
</asp:Content>

<asp:Content ID="MainBlock" ContentPlaceHolderID="LecturerMain" runat="server">
    <div class="lc-header">Courses</div>

    <div class="lc-controls">
        <div class="lc-view">
            <button type="button" class="lc-icon" title="Grid view">▦</button>
            <button type="button" class="lc-icon" title="List view">≣</button>
        </div>

        <div class="lc-actions">
            <a href="#" class="lc-add">Add Courses</a>
            <label class="lc-sort">
                <select>
                    <option selected>Sort</option>
                    <option>Newest</option>
                    <option>Oldest</option>
                    <option>A → Z</option>
                    <option>Z → A</option>
                </select>
            </label>
        </div>
    </div>
     
    <div class="lc-search">   
        <input type="text" placeholder="SEARCH" />
    </div>

    <div class="lc-grid">
        <div class="lc-card">
            <div class="lc-banner">&lt;Banner&gt;</div>
            <div class="lc-card-body">
                <h3>Course A</h3>
                <p class="lc-date">28 Dec 2025</p>
                <p>Total Chapters: 10</p>
                <p>Total Questions: 8</p>
            </div>
        </div>

        <div class="lc-card">
            <div class="lc-banner">&lt;Banner&gt;</div>
            <div class="lc-card-body">
                <h3>Course B</h3>
                <p class="lc-date">29 Dec 2025</p>
                <p>Total Chapters: 11</p>
                <p>Total Questions: 6</p>
            </div>
        </div>

        <div class="lc-card">
            <div class="lc-banner">&lt;Banner&gt;</div>
            <div class="lc-card-body">
                <h3>Course C</h3>
                <p class="lc-date">31 Dec 2025</p>
                <p>Total Chapters: 8</p>
                <p>Total Questions: 7</p>
            </div>
        </div>
    </div>
</asp:Content>

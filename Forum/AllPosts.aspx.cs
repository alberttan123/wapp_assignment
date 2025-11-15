using Microsoft.Ajax.Utilities;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Configuration;
using System.Data.Entity;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using static WAPP_Assignment.DataAccess;

namespace WAPP_Assignment.Forum
{
    public partial class AllPosts : System.Web.UI.Page
    {
        protected List<string[]> postData = new List<string[]>();
        
        protected void Page_PreInit(object sender, EventArgs e)
        {
            // Switch master page based on user type
            var (isAuthenticated, userId, userType) = AuthCookieHelper.ReadAuthCookie();
            
            // Trim userType to handle any whitespace issues
            string trimmedUserType = userType?.Trim();
            
            if (isAuthenticated && !string.IsNullOrEmpty(trimmedUserType))
            {
                if (string.Equals(trimmedUserType, "Admin", StringComparison.OrdinalIgnoreCase))
                {
                    // Switch to Admin.Master for admins (no navbar, has admin sidebar)
                    this.MasterPageFile = "~/Admin/Admin.Master";
                    return;
                }
                else if (string.Equals(trimmedUserType, "Educator", StringComparison.OrdinalIgnoreCase))
                {
                    // Switch to Lecturer.Master for educators/lecturers (no navbar, has lecturer sidebar)
                    this.MasterPageFile = "~/Lecturer/Lecturer.Master";
                    return;
                }
            }
            // Otherwise use default Site.Master (for students and non-authenticated users)
        }
        
        protected void Page_Init(object sender, EventArgs e)
        {
            // Check if user is a lecturer/educator or admin - set visibility early
            var (isAuthenticated, userId, userType) = AuthCookieHelper.ReadAuthCookie();
            string trimmedUserType = userType?.Trim();
            bool isLecturer = isAuthenticated && 
                             !string.IsNullOrEmpty(trimmedUserType) && 
                             string.Equals(trimmedUserType, "Educator", StringComparison.OrdinalIgnoreCase);
            bool isAdmin = isAuthenticated && 
                          !string.IsNullOrEmpty(trimmedUserType) && 
                          string.Equals(trimmedUserType, "Admin", StringComparison.OrdinalIgnoreCase);

            // Check which master page is being used
            bool usingAdminMaster = this.Master != null && this.Master.GetType().Name.Contains("Admin");
            bool usingLecturerMaster = this.Master != null && this.Master.GetType().Name.Contains("Lecturer");

            if ((isLecturer || isAdmin) || usingAdminMaster || usingLecturerMaster)
            {
                // Hide forum header for lecturers and admins (or when using admin/lecturer master)
                if (pnlForumHeader != null)
                {
                    pnlForumHeader.Visible = false;
                }
                // Show back button for lecturers and admins
                if (pnlLecturerBack != null)
                {
                    pnlLecturerBack.Visible = true;
                }
                
                // Update back button link based on user type
                if (isAdmin || usingAdminMaster)
                {
                    // Update the link to point to admin dashboard
                    if (lnkBackToDashboard != null)
                    {
                        lnkBackToDashboard.NavigateUrl = ResolveUrl("~/Admin/AdminDashboard.aspx");
                    }
                }
                else if (isLecturer || usingLecturerMaster)
                {
                    // Ensure link points to lecturer dashboard for lecturers
                    if (lnkBackToDashboard != null)
                    {
                        lnkBackToDashboard.NavigateUrl = ResolveUrl("~/Lecturer/LecturerDashboard.aspx");
                    }
                }
            }
            else
            {
                // Show forum header for non-lecturers/non-admins (using Site.Master)
                if (pnlForumHeader != null)
                {
                    pnlForumHeader.Visible = true;
                }
                // Hide back button for non-lecturers/non-admins
                if (pnlLecturerBack != null)
                {
                    pnlLecturerBack.Visible = false;
                }
            }
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            // Ensure visibility is set correctly before rendering (safety check)
            var (isAuthenticated, userId, userType) = AuthCookieHelper.ReadAuthCookie();
            string trimmedUserType = userType?.Trim();
            bool isLecturer = isAuthenticated && 
                             !string.IsNullOrEmpty(trimmedUserType) && 
                             string.Equals(trimmedUserType, "Educator", StringComparison.OrdinalIgnoreCase);
            bool isAdmin = isAuthenticated && 
                          !string.IsNullOrEmpty(trimmedUserType) && 
                          string.Equals(trimmedUserType, "Admin", StringComparison.OrdinalIgnoreCase);

            bool usingAdminMaster = this.Master != null && this.Master.GetType().Name.Contains("Admin");
            bool usingLecturerMaster = this.Master != null && this.Master.GetType().Name.Contains("Lecturer");

            if ((isLecturer || isAdmin) || usingAdminMaster || usingLecturerMaster)
            {
                // Force hide forum header
                if (pnlForumHeader != null)
                {
                    pnlForumHeader.Visible = false;
                }
                // Force show back button
                if (pnlLecturerBack != null)
                {
                    pnlLecturerBack.Visible = true;
                }
            }
            else
            {
                // Force show forum header
                if (pnlForumHeader != null)
                {
                    pnlForumHeader.Visible = true;
                }
                // Force hide back button
                if (pnlLecturerBack != null)
                {
                    pnlLecturerBack.Visible = false;
                }
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // Always render posts in Page_Load (before event handlers fire)
            // This ensures dynamically created controls exist when their event handlers are called
            if (!IsPostBack)
            {
                postData = Sort("latest first", fetchAllPosts()); //fetch data and sort it to be latest first
                renderPosts(postData);
            }
            else
            {
                // On postback, reload data and render so controls exist for event handlers
                // Event handlers (like deletePost) will re-render if needed after their action
                postData = Sort("latest first", fetchAllPosts());
                renderPosts(postData);
            }
        }

        protected void handleSearchAndSort(object sender, EventArgs e) 
        {
            List<string[]> filtered = postData;

            string searchQuery = searchBox.Text.Trim().ToLower();
            List<string[]> filteredSearch = Search(searchQuery, filtered);

            string sortMethod = sortDropdown.SelectedValue;
            List<string[]> sortedResults = Sort(sortMethod, filteredSearch);

            forum_content.Controls.Clear();
            renderPosts(sortedResults);
        }

        protected List<string[]> Search(string query, List<string[]> filtered) 
        {
            if (string.IsNullOrEmpty(query))
            {
                //if empty, return original data
                return filtered;
            }

            filtered = filtered.Where(p => p[0].ToLower().Contains(query) || p[1].ToLower().Contains(query)).ToList();
            // filters for username and title

            for (int i = 0; i < filtered.Count; i++)
                filtered[i][3] = (i + 1).ToString();
            //renumbers postCount

            return filtered;
        }

        protected List<string[]> Sort(string sortMethod, List<string[]> filtered) 
        {
            IEnumerable<string[]> sorted = filtered;

            switch (sortMethod) 
            {
                case "a-to-z":
                    sorted = filtered
                        .OrderBy(p => p[1], StringComparer.OrdinalIgnoreCase);
                    break;

                case "z-to-a":
                    sorted = filtered
                        .OrderByDescending(p => p[1], StringComparer.OrdinalIgnoreCase);
                    break;

                case "latest first":     
                    // newest -> oldest
                    sorted = filtered
                        .OrderByDescending(p => DateTime.Parse(p[2]));
                    break;

                case "latest last":     
                    // oldest -> newest
                    sorted = filtered
                        .OrderBy(p => DateTime.Parse(p[2]));
                    break;
                case "my own posts":
                    var (isAuthenticated, userId, userType) = AuthCookieHelper.ReadAuthCookie();
                    if (!isAuthenticated || string.IsNullOrEmpty(userId))
                    {
                        // Redirect to login if not authenticated
                        Response.Redirect("~/Default.aspx", true);
                    }

                    sorted = filtered
                        .Where(p => p[5].ToLower().Contains(userId));
                    break;
                default:
                    //if something messes up, we return original data
                    return filtered;
            }

            // renumbers postCount
            int count = 1;
            var finalList = sorted.ToList();
            foreach (var item in finalList)
            {
                item[3] = count.ToString();
                count++;
            }

            return finalList;
        }

        protected List<string[]> fetchAllPosts()  //fetches data then formats it to expected format List of array which contains string data
        {
            using (var conn = DataAccess.GetOpenConnection())
            using (var cmd = new SqlCommand("SELECT Username, PostTitle, PostCreatedAt, PostId, dbo.ForumPost.UserId, dbo.Users.UserType FROM dbo.ForumPost JOIN dbo.Users ON dbo.Users.UserId = dbo.ForumPost.UserId", conn))
            using (var reader = cmd.ExecuteReader())
            {
                List<string[]> postData = new List<string[]>();
                int postCount = 1;
                while (reader.Read())
                {
                    string username = reader.GetString(0);
                    string postTitle = reader.GetString(1);
                    string postCreatedAt = reader.GetDateTime(2).ToString();
                    string postStringCount = postCount.ToString();
                    string postId = reader.GetInt32(3).ToString();
                    string createdByUserId = reader.GetInt32(4).ToString();
                    string createdByUserType = reader.GetString(5).ToString();

                    string[] data = { username, postTitle, postCreatedAt, postStringCount, postId, createdByUserId, createdByUserType };
                    postData.Add(data);

                    postCount++;
                }
                return postData;
            }
        }

        protected void renderPosts(List<string[]> postData) //renders all posts using buildPost
        {
            // Clear existing controls before re-rendering (important for postback)
            forum_content.Controls.Clear();
            
            int count = 0;
            while (count < postData.Count) 
            {
                string[] singlePostData = postData[count];
                string username = singlePostData[0];
                string postTitle = singlePostData[1];
                string postCreatedAt = singlePostData[2];
                int postCount = int.Parse(singlePostData[3]);
                int postId = int.Parse(singlePostData[4]);
                int createdByUserId = int.Parse(singlePostData[5]);
                string createdByUserType = singlePostData[6];

                Panel card = buildPost(username, postTitle, postCreatedAt, postCount, postId, createdByUserId, createdByUserType);
                forum_content.CssClass = "forum-content justify-none";
                forum_content.Controls.Add(card);

                count++;
            }

            if (count == 0) 
            {
                Label errorMessage = new Label();
                errorMessage.Text = "No posts were found.";
                errorMessage.CssClass = "error-message";

                forum_content.CssClass = "forum-content justify-center";
                forum_content.Controls.Add(errorMessage);
            }
        }

        protected Panel buildPost(string username, string postTitle, string postCreatedAt, int postCount, int postId, int createdByUserId, string createdByUserType) //formats post into expected html/asp format
        {
            Panel card = new Panel();
            card.CssClass = "post";
            card.ID = $@"post-{postCount}";

            Panel postHeader = new Panel();
            postHeader.CssClass = "post-header";

            Label labelUsername = new Label();
            labelUsername.Text = username;
            labelUsername.CssClass = "post-username";

            Label labelUserType = new Label();
            labelUserType.Text = createdByUserType;
            labelUserType.CssClass = "post-usertype";

            postHeader.Controls.Add(labelUsername);
            postHeader.Controls.Add(labelUserType);

            Label labelTitle = new Label();
            labelTitle.Text = postTitle;
            labelTitle.CssClass = "post-title";

            
            Label labelCreatedAt = new Label();
            labelCreatedAt.Text = postCreatedAt;
            labelCreatedAt.CssClass = "post-createdAt";

            card.Controls.Add(postHeader);
            card.Controls.Add(labelTitle);
            card.Controls.Add(labelCreatedAt);

            var (isAuthenticated, userId, userType) = AuthCookieHelper.ReadAuthCookie();
            string trimmedUserType = userType?.Trim();
            bool isAdmin = isAuthenticated && 
                          !string.IsNullOrEmpty(trimmedUserType) && 
                          string.Equals(trimmedUserType, "Admin", StringComparison.OrdinalIgnoreCase);
            bool isPostOwner = !userId.IsNullOrWhiteSpace() && createdByUserId == int.Parse(userId);

            // Create anchor tag for post navigation
            HtmlAnchor anchorTag = new HtmlAnchor();
            anchorTag.HRef = $@"/Forum/ViewPost?postId={postId}";
            anchorTag.Attributes.Add("class", "post-link");

            // Wrap card in anchor
            anchorTag.Controls.Add(card);

            Panel fullContainer = new Panel();
            fullContainer.CssClass = "post-container";
            fullContainer.Controls.Add(anchorTag);

            // Show delete button if user is the post creator OR if user is an Admin
            // Add delete button OUTSIDE the anchor tag so it doesn't interfere with postback
            if (isPostOwner || isAdmin)
            {
                //make delete button and error message panel if user is logged in and is the post creator OR is an admin
                Panel postActions = new Panel();
                postActions.CssClass = "post-actions";

                Button deleteButton = new Button();
                deleteButton.ID = $"deleteBtn_{postId}";
                deleteButton.CommandArgument = postId.ToString();
                deleteButton.Text = "Delete Post";
                deleteButton.CssClass = "delete-button-post";
                deleteButton.Command += deletePost;
                deleteButton.UseSubmitBehavior = true;
                deleteButton.CausesValidation = false;
                postActions.Controls.Add(deleteButton);

                Label errorMessage = new Label();
                errorMessage.ID = $@"post_{postId}_error_message";
                errorMessage.Visible = true;
                errorMessage.Text = "";
                errorMessage.CssClass = "post-delete-error";
                postActions.Controls.Add(errorMessage);

                // Add delete button panel OUTSIDE the anchor tag
                fullContainer.Controls.Add(postActions);
            }

            return fullContainer;
        }
        protected void deletePost(object sender, CommandEventArgs e)
        {
            // Hide any previous messages
            if (pnlDeleteMessage != null)
            {
                pnlDeleteMessage.Visible = false;
                lblDeleteMessage.Text = "";
            }

            string Id = e.CommandArgument.ToString();
            
            // Debug: check if method is being called
            System.Diagnostics.Debug.WriteLine($"deletePost called with ID: {Id}");

            var (isAuthenticated, userId, userType) = AuthCookieHelper.ReadAuthCookie();
            if (!isAuthenticated || string.IsNullOrEmpty(userId))
            {
                // Redirect to login if not authenticated
                Response.Redirect("~/Default.aspx", true);
                return;
            }

            string trimmedUserType = userType?.Trim();
            bool isAdmin = !string.IsNullOrEmpty(trimmedUserType) && 
                          string.Equals(trimmedUserType, "Admin", StringComparison.OrdinalIgnoreCase);

            using (var conn = DataAccess.GetOpenConnection())
            {
                // First, check if the post exists and get the creator's userId
                SqlCommand checkCmd = new SqlCommand("SELECT UserId FROM dbo.ForumPost WHERE PostId=@PostId", conn);
                checkCmd.Parameters.AddWithValue("@PostId", Id);
                
                int postOwnerId = 0;
                try
                {
                    object result = checkCmd.ExecuteScalar();
                    if (result != null)
                    {
                        postOwnerId = Convert.ToInt32(result);
                    }
                    else
                    {
                        // Post doesn't exist
                        ShowDeleteMessage("Post not found.", "error");
                        return;
                    }
                }
                catch (Exception ex)
                {
                    ShowDeleteMessage("Unable to verify post ownership. " + ex.Message, "error");
                    return;
                }

                // Check if user is the post owner OR is an admin
                bool isPostOwner = postOwnerId == int.Parse(userId);
                if (!isPostOwner && !isAdmin)
                {
                    // User is not the post owner and is not an admin - unauthorized
                    ShowDeleteMessage("You are not authorized to delete this post.", "error");
                    return;
                }

                // User is authorized - proceed with deletion
                SqlCommand cmd = new SqlCommand("DELETE FROM dbo.ForumPost WHERE PostId=@PostId", conn);
                cmd.Parameters.AddWithValue("@PostId", Id);
                try
                {
                    int rowsAffected = cmd.ExecuteNonQuery();
                    if (rowsAffected > 0)
                    {
                        // Success - reload data and re-render posts
                        postData = Sort("latest first", fetchAllPosts());
                        forum_content.Controls.Clear();
                        renderPosts(postData);
                        ShowDeleteMessage("Post deleted successfully.", "success");
                    }
                    else
                    {
                        // Post was not deleted (might have been already deleted)
                        ShowDeleteMessage("Post could not be deleted. It may have been already removed.", "error");
                    }
                }
                catch (Exception ex)
                {
                    ShowDeleteMessage("Unable to delete the post. " + ex.Message, "error");
                }
            }
        }

        private void ShowDeleteMessage(string message, string type)
        {
            if (pnlDeleteMessage != null && lblDeleteMessage != null)
            {
                pnlDeleteMessage.Visible = true;
                lblDeleteMessage.Text = message;
                lblDeleteMessage.CssClass = "delete-message " + type;
            }
        }

        protected void showAddPostModal(object sender, EventArgs e) 
        {
            addPostModal.Visible = true;
            // Hide the top bar (Back to Dashboard and Add Post buttons) when modal is open
            if (pnlLecturerBack != null)
            {
                pnlLecturerBack.Visible = false;
            }
            if (pnlForumHeader != null)
            {
                pnlForumHeader.Visible = false;
            }
        }

        protected void hideAddPostModal(object sender, EventArgs e)
        {
            addPostModal.Visible = false;
            // Show the top bar again when modal is closed
            var (isAuthenticated, userId, userType) = AuthCookieHelper.ReadAuthCookie();
            string trimmedUserType = userType?.Trim();
            bool isLecturer = isAuthenticated && 
                             !string.IsNullOrEmpty(trimmedUserType) && 
                             string.Equals(trimmedUserType, "Educator", StringComparison.OrdinalIgnoreCase);
            bool isAdmin = isAuthenticated && 
                          !string.IsNullOrEmpty(trimmedUserType) && 
                          string.Equals(trimmedUserType, "Admin", StringComparison.OrdinalIgnoreCase);

            bool usingAdminMaster = this.Master != null && this.Master.GetType().Name.Contains("Admin");
            bool usingLecturerMaster = this.Master != null && this.Master.GetType().Name.Contains("Lecturer");

            if ((isLecturer || isAdmin) || usingAdminMaster || usingLecturerMaster)
            {
                // Show back button for lecturers/admins
                if (pnlLecturerBack != null)
                {
                    pnlLecturerBack.Visible = true;
                }
            }
            else
            {
                // Show forum header for non-lecturers/non-admins
                if (pnlForumHeader != null)
                {
                    pnlForumHeader.Visible = true;
                }
            }
        }

        protected void addPost(object sender, EventArgs e) 
        {
            addPostError.Visible = false;
            addPostError.Text = "";

            var (isAuthenticated, userId, userType) = AuthCookieHelper.ReadAuthCookie();
            if (!isAuthenticated || string.IsNullOrEmpty(userId))
            {
                // Redirect to login if not authenticated
                Response.Redirect("~/Default.aspx", true);
                return;
            }

            string title = postTitle.Text;
            string message = postMessage.Text;

            using (var conn = DataAccess.GetOpenConnection())
            {
                SqlCommand cmd = new SqlCommand("INSERT INTO dbo.ForumPost (UserId, PostTitle, PostMessage) VALUES (@userId, @postTitle, @postMessage)", conn);
                cmd.Parameters.AddWithValue("@userId", userId);
                cmd.Parameters.AddWithValue("@postTitle", title);
                cmd.Parameters.AddWithValue("@postMessage", message);
                try
                {
                    int rowsAffected = cmd.ExecuteNonQuery();
                    if (rowsAffected > 0)
                    {
                        Response.Redirect(ResolveUrl("~/Forum/AllPosts.aspx"), true);
                    }
                }
                catch (Exception ex)
                {
                    addPostError.Visible = true;
                    addPostError.Text = ex.Message;
                }
            }
        }   
    }
}
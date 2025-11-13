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
        protected void Page_Load(object sender, EventArgs e)
        {
            postData = Sort("latest first", fetchAllPosts()); //fetch data and sort it to be latest first
            renderPosts(postData);
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

            Label labelUsername = new Label();
            labelUsername.Text = username;
            labelUsername.CssClass = "post-username";

            Label labelUserType = new Label();
            labelUserType.Text = createdByUserType;
            labelUserType.CssClass = "post-usertype-pill";


            Label labelTitle = new Label();
            labelTitle.Text = postTitle;
            labelTitle.CssClass = "post-title";

            
            Label labelCreatedAt = new Label();
            labelCreatedAt.Text = postCreatedAt;
            labelCreatedAt.CssClass = "post-createdAt";

            card.Controls.Add(labelUsername);
            card.Controls.Add(labelUserType);
            card.Controls.Add(labelTitle);
            card.Controls.Add(labelCreatedAt);

            HtmlAnchor anchorTag = new HtmlAnchor();
            anchorTag.HRef = $@"/Forum/ViewPost?postId={postId}";
            anchorTag.Attributes.Add("class", "post-link");

            anchorTag.Controls.Add(card);

            Panel fullContainer = new Panel();
            fullContainer.CssClass = "post-container";
            fullContainer.Controls.Add(anchorTag);

            var (isAuthenticated, userId, userType) = AuthCookieHelper.ReadAuthCookie();

            if (!userId.IsNullOrWhiteSpace()) //check if userId exists, if not do not run this: will bring error when trying to access null
            {
                if (createdByUserId == int.Parse(userId))
                {
                    //make delete button and error message panel if user is logged in and is the post creator
                    Panel errorContainer = new Panel();

                    Button deleteButton = new Button();
                    deleteButton.CommandArgument = postId.ToString();
                    deleteButton.Text = "Delete Post";
                    deleteButton.CssClass = "delete-button";
                    deleteButton.Command += deletePost;
                    errorContainer.Controls.Add(deleteButton);

                    Label errorMessage = new Label();
                    errorMessage.ID = $@"post_{postId}_error_message";
                    errorMessage.Visible = true;
                    errorMessage.Text = "";
                    errorContainer.Controls.Add(errorMessage);

                    fullContainer.Controls.Add(errorContainer);
                }
            }

            return fullContainer;
        }
        protected void deletePost(object sender, CommandEventArgs e)
        {
            Button btn = (Button)sender;
            Panel errorContainer = (Panel)btn.Parent;

            string Id = e.CommandArgument.ToString();
            string labelId = $@"post_{Id}_error_message";

            Label postError = (Label)errorContainer.FindControl(labelId);
            //note: postError with the FindControl doesn't seem to work rn, ignoring as won't face errors with normal usage, not sure abt edge cases tho
            if (postError != null)
            {
                postError.Visible = false;
                postError.Text = "";
            }

            var (isAuthenticated, userId, userType) = AuthCookieHelper.ReadAuthCookie();
            if (!isAuthenticated || string.IsNullOrEmpty(userId))
            {
                // Redirect to login if not authenticated
                Response.Redirect("~/Default.aspx", true);
                return;
            }

            using (var conn = DataAccess.GetOpenConnection())
            {
                SqlCommand cmd = new SqlCommand("DELETE FROM dbo.ForumPost WHERE PostId=@PostId", conn);
                cmd.Parameters.AddWithValue("@PostId", Id);
                try
                {
                    int rowsAffected = cmd.ExecuteNonQuery();
                    if (rowsAffected > 0)
                    {
                        Response.Redirect("AllPosts.aspx");
                    }
                }
                catch (Exception ex)
                {
                    if(postError != null)
                    {
                        postError.Text = "Unable to delete your post.\n" + ex.Message;
                    }
                }
            }
        }

        protected void showAddPostModal(object sender, EventArgs e) 
        {
            addPostModal.Visible = true;
        }

        protected void hideAddPostModal(object sender, EventArgs e)
        {
            addPostModal.Visible = false;
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
                        Response.Redirect("AllPosts.aspx");
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
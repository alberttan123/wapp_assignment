using Microsoft.Ajax.Utilities;
using System;
using System.Collections.Generic;
using System.ComponentModel.Design;
using System.Data.SqlClient;
using System.Linq;
using System.Runtime.InteropServices;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace WAPP_Assignment.Forum
{
    public partial class ViewPost : System.Web.UI.Page
    {
        protected int postId = 0;
        protected string[] data = new string[6];
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["postId"].IsNullOrWhiteSpace()) 
            {
                showPostNotFound();
                return;
            }

            postId = int.Parse(Request.QueryString["postId"]);
            data = fetchPostData();
            renderPost(data);
        }
        protected void renderPost(string[] postData)
        {
            string username = postData[0];
            string title = postData[1];
            string message = postData[2];
            string createdAt = postData[3];
            string createdByUserId = postData[4];
            string createdByUserType = postData[5];

            if (username.IsNullOrWhiteSpace() || title.IsNullOrWhiteSpace() || message.IsNullOrWhiteSpace() || createdAt.IsNullOrWhiteSpace() || createdByUserId.IsNullOrWhiteSpace() || createdByUserType.IsNullOrWhiteSpace())
            {
                //show error if any data is missing
                showPostNotFound();
                return;
            }

            //else fill in data
            postUsername.Text = username;
            postCreatedByUserType.Text = createdByUserType;
            postTitle.Text = title;
            postMessage.Text = message;
            postCreatedAt.Text = createdAt;

            var (isAuthenticated, userId, userType) = AuthCookieHelper.ReadAuthCookie();

            if (!userId.IsNullOrWhiteSpace()) //check if userId exists, if not do not run this: will bring error when trying to access null
            {
                if (int.Parse(createdByUserId) == int.Parse(userId))
                {
                    // add delete button if the post was made by the currently signed in user
                    Button deleteButton = new Button();
                    deleteButton.CommandArgument = postId.ToString();
                    deleteButton.Command += deletePost;
                    deleteButton.Text = "Delete This Post";
                    deleteButton.CssClass = "delete-post-button";
                    deletePostButton.Visible = true;
                    deletePostButton.Controls.Add(deleteButton);
                }
            }

            List<string[]> commentData = fetchComments();
            renderComments(commentData);
        }

        protected void renderComments(List<string[]> commentData) 
        {
            int count = 0;
            while (count < commentData.Count)
            {
                string[] singleCommentData = commentData[count];
                string commentId = singleCommentData[0];
                string username = singleCommentData[1];
                string comment = singleCommentData[2];
                string createdAt = singleCommentData[3];
                int createdByUserId = int.Parse(singleCommentData[4]);
                string createdByUserType = singleCommentData[5];

                Panel commentCard = buildComment(commentId, username, comment, createdAt, createdByUserId, createdByUserType);
                commentSection.CssClass = "commentSection justify-none";
                commentSection.Controls.Add(commentCard);

                count++;
            }

            if (count == 0) //if no comments
            {
                Label message = new Label();
                message.Text = "No comments made on this post. Be the first one!";

                commentSection.CssClass = "commentSection justify-center";
                commentSection.Controls.Add(message);
            }
        }

        protected Panel buildComment(string commentId, string username, string comment, string createdAt, int createdByUserId, string createdByUserType) 
        {
            Panel commentCard = new Panel();
            commentCard.CssClass = "comment";

            Label usernameLabel = new Label();
            usernameLabel.Text = username;
            Label createdByUserTypeLabel = new Label();
            createdByUserTypeLabel.Text = createdByUserType;
            Label commentLabel = new Label();
            commentLabel.Text = comment;
            Label createdAtLabel = new Label();
            createdAtLabel.Text = createdAt;

            commentCard.Controls.Add(usernameLabel);
            commentCard.Controls.Add(createdByUserTypeLabel);
            commentCard.Controls.Add(commentLabel);
            commentCard.Controls.Add(createdAtLabel);

            var (isAuthenticated, userId, userType) = AuthCookieHelper.ReadAuthCookie();

            if (!userId.IsNullOrWhiteSpace()) //check if userId exists, if not do not run this: will bring error when trying to access null
            {
                if (createdByUserId == int.Parse(userId))
                {
                    // add delete button if the comment was made by the currently signed in user
                    Button deleteButton = new Button();
                    deleteButton.CommandArgument = commentId;
                    deleteButton.Command += delete;
                    deleteButton.Text = "Delete";
                    deleteButton.CssClass = "delete-button";
                    commentCard.Controls.Add(deleteButton);
                }
            }

            return commentCard;
        }

        protected string[] fetchPostData() 
        {
            var conn = DataAccess.GetOpenConnection();
            var cmd = new SqlCommand("SELECT Username, PostTitle, PostMessage, PostCreatedAt, dbo.ForumPost.UserId, dbo.Users.UserType FROM dbo.ForumPost JOIN dbo.Users ON dbo.Users.UserId = dbo.ForumPost.UserId WHERE dbo.ForumPost.PostId = @postId", conn);
            cmd.Parameters.AddWithValue("@postId", postId);
            using (var reader = cmd.ExecuteReader())
            {
                string[] postData = new string[6];
                while (reader.Read())
                {
                    postData[0] = reader.GetString(0); //username
                    postData[1] = reader.GetString(1); //postTitle
                    postData[2] = reader.GetString(2); //postMessage
                    postData[3] = reader.GetDateTime(3).ToString(); //postCreatedAt
                    postData[4] = reader.GetInt32(4).ToString(); // createdByUserId
                    postData[5] = reader.GetString(5); //createdByUserType
                }

                if (postData.Count() == 0) //if SQL returns nothing
                {
                    return postData; //returns unchanged (empty) array
                    //post not found handling done in renderPost()
                }

                return postData;
            }
        }

        protected List<string[]> fetchComments() 
        {
            using (var conn = DataAccess.GetOpenConnection())
            {
                var cmd = new SqlCommand("SELECT CommentId, Username, CommentMessage, CommentCreatedAt, dbo.ForumComment.UserId, dbo.Users.UserType FROM dbo.ForumComment JOIN dbo.Users ON dbo.Users.UserId = dbo.ForumComment.UserId WHERE dbo.ForumComment.PostId = @postId ORDER BY CommentCreatedAt DESC", conn);
                cmd.Parameters.AddWithValue("@postId", postId);
                using (var reader = cmd.ExecuteReader())
                {
                    List<string[]> commentData = new List<string[]>();
                    while (reader.Read())
                    {
                        string commentId = reader.GetInt32(0).ToString();
                        string commentUsername = reader.GetString(1);
                        string comment = reader.GetString(2);
                        string commentCreatedAt = reader.GetDateTime(3).ToString();
                        string commentUserId = reader.GetInt32(4).ToString();
                        string commentCreatedByUserType = reader.GetString(5);

                        string[] data = { commentId, commentUsername, comment, commentCreatedAt, commentUserId, commentCreatedByUserType };
                        commentData.Add(data);
                    }
                    return commentData;
                }
            }
        }

        protected void makeNewComment(object sender, EventArgs e) 
        {
            commentError.Visible = false;
            commentError.Text = "";

            var (isAuthenticated, userId, userType) = AuthCookieHelper.ReadAuthCookie();
            if (!isAuthenticated || string.IsNullOrEmpty(userId))
            {
                // Redirect to login if not authenticated
                Response.Redirect("~/Default.aspx", true);
                return;
            }

            string comment = addComment.Text.Trim();

            using (var conn = DataAccess.GetOpenConnection()) 
            {
                SqlCommand cmd = new SqlCommand("INSERT INTO dbo.ForumComment (PostId, UserId, CommentMessage) VALUES (@PostId, @UserId, @comment)", conn);
                cmd.Parameters.AddWithValue("@PostId", postId);
                cmd.Parameters.AddWithValue("@UserId", userId);
                cmd.Parameters.AddWithValue("@comment", comment);
                try
                {
                    int rowsAffected = cmd.ExecuteNonQuery();
                    if (rowsAffected > 0)
                    {
                        Response.Redirect($@"ViewPost.aspx?postId={postId}");
                    }
                }
                catch (Exception ex)
                {
                    commentError.Visible = true;
                    commentError.Text = "Unable to add your comment.\n" + ex.Message;
                }
            }
        }

        protected void delete(object sender, CommandEventArgs e) 
        {
            string commentId = e.CommandArgument.ToString();
            commentError.Visible = false;
            commentError.Text = "";

            var (isAuthenticated, userId, userType) = AuthCookieHelper.ReadAuthCookie();
            if (!isAuthenticated || string.IsNullOrEmpty(userId))
            {
                // Redirect to login if not authenticated
                Response.Redirect("~/Default.aspx", true);
                return;
            }

            using (var conn = DataAccess.GetOpenConnection())
            {
                SqlCommand cmd = new SqlCommand("DELETE FROM dbo.ForumComment WHERE CommentId=@CommentId", conn);
                cmd.Parameters.AddWithValue("@CommentId", commentId);
                try
                {
                    int rowsAffected = cmd.ExecuteNonQuery();
                    if (rowsAffected > 0)
                    {
                        Response.Redirect($@"ViewPost.aspx?postId={postId}");
                    }
                }
                catch (Exception ex)
                {
                    commentError.Visible = true;
                    commentError.Text = "Unable to delete your comment.\n" + ex.Message;
                }
            }
        }

        protected void deletePost(object sender, CommandEventArgs e)
        {
            string Id = e.CommandArgument.ToString();
            postError.Visible = false;
            postError.Text = "";

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
                    postError.Visible = true;
                    postError.Text = "Unable to delete your post.\n" + ex.Message;
                }
            }
        }

        protected void showPostNotFound() 
        {
            container.Controls.Clear();
            Label errorMessage = new Label();
            errorMessage.Text = "Post not found.";
            errorMessage.CssClass = "postNotFound";
            container.Controls.Add(errorMessage);
        }

        protected void backToAllPosts(Object sender, EventArgs e) 
        {
            Response.Redirect("AllPosts.aspx");
        }
    }
}
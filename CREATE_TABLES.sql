------------------------------------------------------------
-- CREATE_TABLES.sql
-- MSSQL Server schema for .NET WebForms project
------------------------------------------------------------
-- Drop tables in correct dependency order (safe for re-run)
------------------------------------------------------------

IF OBJECT_ID('dbo.ForumComment', 'U') IS NOT NULL DROP TABLE dbo.ForumComment;
IF OBJECT_ID('dbo.ForumPost', 'U') IS NOT NULL DROP TABLE dbo.ForumPost;
IF OBJECT_ID('dbo.QuestionBank', 'U') IS NOT NULL DROP TABLE dbo.QuestionBank;
IF OBJECT_ID('dbo.Questions', 'U') IS NOT NULL DROP TABLE dbo.Questions;
IF OBJECT_ID('dbo.Quiz', 'U') IS NOT NULL DROP TABLE dbo.Quiz;
IF OBJECT_ID('dbo.ChapterContents', 'U') IS NOT NULL DROP TABLE dbo.ChapterContents;
IF OBJECT_ID('dbo.Chapters', 'U') IS NOT NULL DROP TABLE dbo.Chapters;
IF OBJECT_ID('dbo.Files', 'U') IS NOT NULL DROP TABLE dbo.Files;
IF OBJECT_ID('dbo.StaticPages', 'U') IS NOT NULL DROP TABLE dbo.StaticPages;
IF OBJECT_ID('dbo.Bookmarks', 'U') IS NOT NULL DROP TABLE dbo.Bookmarks;
IF OBJECT_ID('dbo.Enrollments', 'U') IS NOT NULL DROP TABLE dbo.Enrollments;
IF OBJECT_ID('dbo.Courses', 'U') IS NOT NULL DROP TABLE dbo.Courses;
IF OBJECT_ID('dbo.Users', 'U') IS NOT NULL DROP TABLE dbo.Users;


------------------------------------------------------------
-- USERS
------------------------------------------------------------

CREATE TABLE dbo.Users (
    UserId          INT IDENTITY(1,1) PRIMARY KEY,
    Username        NVARCHAR(50) NOT NULL UNIQUE,
    Email           NVARCHAR(256) NOT NULL UNIQUE,
    UserType        NVARCHAR(20) NOT NULL
        CONSTRAINT CK_Users_UserType CHECK (UserType IN ('Admin','Educator','Student')),
    FullName        NVARCHAR(256) NULL,
    PasswordHash    NVARCHAR(256) NOT NULL,
    CreatedAt       DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    IsPasswordReset BIT DEFAULT 0 NOT NULL,
    LastLogin       DATETIME2(7) NULL,
    XP              INT NOT NULL DEFAULT 0
);


------------------------------------------------------------
-- COURSES
------------------------------------------------------------

CREATE TABLE dbo.Courses (
    CourseId        INT IDENTITY(1,1) PRIMARY KEY,
    CourseTitle     NVARCHAR(150) NOT NULL,
    CourseDescription NVARCHAR(1000) NULL,
    TotalLessons    INT NOT NULL DEFAULT 0,
    CourseImgUrl    NVARCHAR(400) NULL,
    LecturerId      INT NOT NULL,
    CourseCreatedAt DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),

    CONSTRAINT FK_Courses_Lecturer
        FOREIGN KEY (LecturerId) REFERENCES dbo.Users(UserId)
);


------------------------------------------------------------
-- ENROLLMENTS (Unique user-course)
------------------------------------------------------------

CREATE TABLE dbo.Enrollments (
    EnrollmentId     INT IDENTITY(1,1) PRIMARY KEY,
    UserId           INT NOT NULL,
    CourseId         INT NOT NULL,
    ProgressPercent  DECIMAL(5,2) NOT NULL DEFAULT 0,
    StartedAt        DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
    LastAccessedAt   DATETIME2(7) NULL,
    CompletedAt      DATETIME2(7) NULL,

    CONSTRAINT FK_Enrollments_User 
        FOREIGN KEY (UserId) REFERENCES dbo.Users(UserId),

    CONSTRAINT FK_Enrollments_Course 
        FOREIGN KEY (CourseId) REFERENCES dbo.Courses(CourseId),

    -- Prevent duplicate enrollments
    CONSTRAINT UQ_Enrollments_User_Course UNIQUE (UserId, CourseId)
);


------------------------------------------------------------
-- BOOKMARKS
------------------------------------------------------------

CREATE TABLE dbo.Bookmarks (
    BookmarkId          INT IDENTITY(1,1) PRIMARY KEY,
    UserId              INT NOT NULL,
    CourseId            INT NOT NULL,
    BookmarkCreatedAt   DATETIME2(7) DEFAULT SYSUTCDATETIME(),

    CONSTRAINT FK_Bookmarks_User 
        FOREIGN KEY (UserId) REFERENCES dbo.Users(UserId),

    CONSTRAINT FK_Bookmarks_Course 
        FOREIGN KEY (CourseId) REFERENCES dbo.Courses(CourseId)
);


------------------------------------------------------------
-- CHAPTERS
------------------------------------------------------------

CREATE TABLE dbo.Chapters (
    ChapterId     INT IDENTITY(1,1) PRIMARY KEY,
    CourseId      INT NOT NULL,
    ChapterOrder  INT NOT NULL,
    ChapterTitle  NVARCHAR(256) NOT NULL,

    CONSTRAINT FK_Chapters_Course
        FOREIGN KEY (CourseId) REFERENCES dbo.Courses(CourseId)
);


------------------------------------------------------------
-- CHAPTER CONTENTS (Polymorphic: Quiz/File/StaticPage)
------------------------------------------------------------

CREATE TABLE dbo.ChapterContents (
    ContentId     INT IDENTITY(1,1) PRIMARY KEY,
    ChapterId     INT NOT NULL,
    ContentType   NVARCHAR(20) NOT NULL DEFAULT 'Quiz',   -- Quiz | File | Page
    ContentTitle  NVARCHAR(256) NOT NULL,
    LinkId        INT NOT NULL,  -- Polymorphic target

    CONSTRAINT FK_ChapterContents_Chapter
        FOREIGN KEY (ChapterId) REFERENCES dbo.Chapters(ChapterId)
    -- Polymorphic: NO FK on LinkId (enforced in backend)
);


------------------------------------------------------------
-- QUIZ
------------------------------------------------------------

CREATE TABLE dbo.Quiz (
    QuizId     INT IDENTITY(1,1) PRIMARY KEY,
    QuizTitle  NVARCHAR(256) NOT NULL,
    QuizType   NVARCHAR(20) NOT NULL DEFAULT 'exercise',
    CreatedBy INT NOT NULL,
        CONSTRAINT CK_Quiz_QuizType 
            CHECK (QuizType IN ('exercise','assessment')),
        CONSTRAINT Fk_Quiz_CreatedBy
            FOREIGN KEY (CreatedBy) REFERENCES dbo.Users(UserId)
);


------------------------------------------------------------
-- QUESTIONS
------------------------------------------------------------

CREATE TABLE dbo.Questions (
    QuestionId    INT IDENTITY(1,1) PRIMARY KEY,
    Question      NVARCHAR(256) NOT NULL,
    Option1       NVARCHAR(256) NOT NULL,
    Option2       NVARCHAR(256) NOT NULL,
    Option3       NVARCHAR(256) NULL,
    Option4       NVARCHAR(256) NULL,
    CorrectAnswer INT NOT NULL,
    ImageUrl NVARCHAR(256) NULL
);


------------------------------------------------------------
-- QUESTION BANK (Composite PK)
------------------------------------------------------------

CREATE TABLE dbo.QuestionBank (
    QuizId      INT NOT NULL,
    QuestionId  INT NOT NULL,

    CONSTRAINT PK_QuestionBank PRIMARY KEY (QuizId, QuestionId),

    CONSTRAINT FK_QuestionBank_Quiz
        FOREIGN KEY (QuizId) REFERENCES dbo.Quiz(QuizId),

    CONSTRAINT FK_QuestionBank_Question
        FOREIGN KEY (QuestionId) REFERENCES dbo.Questions(QuestionId)
);


------------------------------------------------------------
-- FILES
------------------------------------------------------------

CREATE TABLE dbo.Files (
    FileId     INT IDENTITY(1,1) PRIMARY KEY,
    FilePath   NVARCHAR(256) NOT NULL,
    FileName   NVARCHAR(256) NOT NULL
);


------------------------------------------------------------
-- STATIC PAGES
------------------------------------------------------------

CREATE TABLE dbo.StaticPages (
    PageId       INT IDENTITY(1,1) PRIMARY KEY,
    PageTitle    NVARCHAR(100) NOT NULL,
    PageContent  NVARCHAR(MAX) NOT NULL
);


------------------------------------------------------------
-- FORUM POST
------------------------------------------------------------

CREATE TABLE dbo.ForumPost (
    PostId         INT IDENTITY(1,1) PRIMARY KEY,
    UserId         INT NOT NULL,
    PostTitle      NVARCHAR(256) NOT NULL,
    PostMessage    NVARCHAR(500) NOT NULL,
    PostCreatedAt  DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),

    CONSTRAINT FK_ForumPost_User
        FOREIGN KEY (UserId) REFERENCES dbo.Users(UserId)
);


------------------------------------------------------------
-- FORUM COMMENT (cascade on post delete)
------------------------------------------------------------

CREATE TABLE dbo.ForumComment (
    CommentId        INT IDENTITY(1,1) PRIMARY KEY,
    PostId           INT NOT NULL,
    UserId           INT NOT NULL,
    CommentMessage   NVARCHAR(500) NOT NULL,
    CommentCreatedAt DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),

    CONSTRAINT FK_ForumComment_Post
        FOREIGN KEY (PostId) REFERENCES dbo.ForumPost(PostId)
            ON DELETE CASCADE,

    CONSTRAINT FK_ForumComment_User
        FOREIGN KEY (UserId) REFERENCES dbo.Users(UserId)
);

------------------------------------------------------------
-- Score
------------------------------------------------------------

CREATE TABLE dbo.Score (
    ScoreId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    QuizId INT NOT NULL,
    UserId INT NOT NULL,
    Score INT NOT NULL,

    -- Foreign Keys
    CONSTRAINT FK_Score_Quiz 
        FOREIGN KEY (QuizId) REFERENCES dbo.Quiz(QuizId),

    CONSTRAINT FK_Score_User 
        FOREIGN KEY (UserId) REFERENCES dbo.Users(UserId)
);

------------------------------------------------------------
-- UserAnswer
------------------------------------------------------------

CREATE TABLE dbo.UserAnswer (
    UserAnswerId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    QuestionId INT NOT NULL,
    SelectedOption INT NOT NULL,

    CONSTRAINT FK_UserAnswer_Question 
        FOREIGN KEY (QuestionId) REFERENCES dbo.Questions(QuestionId)
);

------------------------------------------------------------
-- QuizTry
------------------------------------------------------------

CREATE TABLE dbo.QuizTry (
    UniqueId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    QuizTry INT NOT NULL,      -- try count
    QuizId INT NOT NULL,
    UserId INT NOT NULL,
    UserAnswerId INT NOT NULL,

    CONSTRAINT FK_QuizTry_User 
        FOREIGN KEY (UserId) REFERENCES dbo.Users(UserId),

    CONSTRAINT FK_QuizTry_Quiz 
        FOREIGN KEY (QuizId) REFERENCES dbo.Quiz(QuizId),

    CONSTRAINT FK_QuizTry_UserAnswer 
        FOREIGN KEY (UserAnswerId) REFERENCES dbo.UserAnswer(UserAnswerId)
);


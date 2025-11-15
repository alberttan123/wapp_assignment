------------------------------------------------------------
-- CREATE_TABLES.sql
-- MSSQL Server schema for .NET WebForms project
------------------------------------------------------------
-- DROP TABLES IN CORRECT FK ORDER
------------------------------------------------------------

-- Drop lowest-level children first
IF OBJECT_ID('dbo.QuizTry', 'U') IS NOT NULL DROP TABLE dbo.QuizTry;
IF OBJECT_ID('dbo.UserAnswer', 'U') IS NOT NULL DROP TABLE dbo.UserAnswer;
IF OBJECT_ID('dbo.Score', 'U') IS NOT NULL DROP TABLE dbo.Score;

-- Forum
IF OBJECT_ID('dbo.ForumComment', 'U') IS NOT NULL DROP TABLE dbo.ForumComment;
IF OBJECT_ID('dbo.ForumPost', 'U') IS NOT NULL DROP TABLE dbo.ForumPost;

-- Question-related (must drop in RIGHT order)
IF OBJECT_ID('dbo.QuestionBank', 'U') IS NOT NULL DROP TABLE dbo.QuestionBank;
IF OBJECT_ID('dbo.Questions', 'U') IS NOT NULL DROP TABLE dbo.Questions;
IF OBJECT_ID('dbo.Quiz', 'U') IS NOT NULL DROP TABLE dbo.Quiz;

-- Chapter content system
IF OBJECT_ID('dbo.ChapterContents', 'U') IS NOT NULL DROP TABLE dbo.ChapterContents;
IF OBJECT_ID('dbo.Chapters', 'U') IS NOT NULL DROP TABLE dbo.Chapters;

-- Bookmarks + enrollment must go before Users/Courses
IF OBJECT_ID('dbo.Bookmarks', 'U') IS NOT NULL DROP TABLE dbo.Bookmarks;
IF OBJECT_ID('dbo.Enrollments', 'U') IS NOT NULL DROP TABLE dbo.Enrollments;

-- Other standalone tables
IF OBJECT_ID('dbo.StaticPages', 'U') IS NOT NULL DROP TABLE dbo.StaticPages;

-- Courses references Users
IF OBJECT_ID('dbo.Courses', 'U') IS NOT NULL DROP TABLE dbo.Courses;

-- Users references Files
IF OBJECT_ID('dbo.Users', 'U') IS NOT NULL DROP TABLE dbo.Users;

-- Finally drop Files (parent)
IF OBJECT_ID('dbo.Files', 'U') IS NOT NULL DROP TABLE dbo.Files;

------------------------------------------------------------
-- FILES
------------------------------------------------------------

CREATE TABLE dbo.Files (
    FileId     INT IDENTITY(1,1) PRIMARY KEY,
    FilePath   NVARCHAR(256) NOT NULL,
    FileName   NVARCHAR(256) NOT NULL
);

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
    XP              INT NOT NULL DEFAULT 0,
    ProfilePictureFilePath NVARCHAR(256) NULL,
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



------------------------------------------------------------
-- SEED_DATA.sql (Updated for new schema)
-- Geography learning platform seed data
------------------------------------------------------------

------------------------------------------------------------
-- FILES
------------------------------------------------------------
INSERT INTO dbo.Files (FilePath, FileName)
VALUES
('/pfps/defaultprofilepicture.jpg', 'defaultprofilepicture.jpg'),
('/files/geo/intro_worksheet.pdf', 'Intro_worksheet.pdf'),
('/files/geo/rock_cycle_diagram.png', 'Rock_Cycle_Diagram.png');

------------------------------------------------------------
-- USERS
------------------------------------------------------------
INSERT INTO dbo.Users (Username, Email, UserType, FullName, PasswordHash)
VALUES
('admin1', 'admin@geo.edu', 'Admin', 'System Administrator', '8OTC92xYkW7CWPJGhRvqCR0U1CR6L8PhhpRGGxgW4Ts='),
('geo_teacher', 'teacher@geo.edu', 'Educator', 'Dr. Emily Carter', '8OTC92xYkW7CWPJGhRvqCR0U1CR6L8PhhpRGGxgW4Ts='),
('student_amy', 'amy@geo.edu', 'Student', 'Amy Tan', '8OTC92xYkW7CWPJGhRvqCR0U1CR6L8PhhpRGGxgW4Ts='),
('student_john', 'john@geo.edu', 'Student', 'John Lim', '8OTC92xYkW7CWPJGhRvqCR0U1CR6L8PhhpRGGxgW4Ts='),
('attain938', 'attain938@gmail.com', 'Student', 'Albert Tan', '8OTC92xYkW7CWPJGhRvqCR0U1CR6L8PhhpRGGxgW4Ts='),
('asdf', 'asdf@gmail.com', 'Student', 'asdf', '8OTC92xYkW7CWPJGhRvqCR0U1CR6L8PhhpRGGxgW4Ts=');

------------------------------------------------------------
-- COURSES
-- LecturerId = 2 (geo_teacher)
------------------------------------------------------------
INSERT INTO dbo.Courses (CourseTitle, CourseDescription, TotalLessons, CourseImgUrl, LecturerId)
VALUES
('Introduction to Geography',
 'Learn the basics of physical and human geography.',
 8, '~/Media/geography-banner.jpg', 2),

('Rocks & Minerals 101',
 'Explore igneous, sedimentary, and metamorphic rocks.',
 6, '~/Media/rock-banner.jpg', 2);

------------------------------------------------------------
-- ENROLLMENTS
------------------------------------------------------------
INSERT INTO dbo.Enrollments (UserId, CourseId, ProgressPercent)
VALUES
(3, 1, 25.0),
(4, 1, 10.0),
(3, 2, 0.0),
(4, 2, 0.0);

------------------------------------------------------------
-- BOOKMARKS
------------------------------------------------------------
INSERT INTO dbo.Bookmarks (UserId, CourseId)
VALUES
(3, 1),
(3, 2),
(4, 1);

------------------------------------------------------------
-- CHAPTERS
------------------------------------------------------------
-- Course 1: Intro Geography
INSERT INTO dbo.Chapters (CourseId, ChapterOrder, ChapterTitle)
VALUES
(1, 1, 'What is Geography?'),
(1, 2, 'Physical Geography'),
(1, 3, 'Human Geography');

-- Course 2: Rocks 101
INSERT INTO dbo.Chapters (CourseId, ChapterOrder, ChapterTitle)
VALUES
(2, 1, 'Understanding Rocks'),
(2, 2, 'Igneous Rocks'),
(2, 3, 'Sedimentary Rocks');

------------------------------------------------------------
-- STATIC PAGES
------------------------------------------------------------
INSERT INTO dbo.StaticPages (PageTitle, PageContent)
VALUES
('Introduction Overview', 'This page introduces the concept of geography.'),
('Earth Structure Summary', 'This page discusses Earth layers and plate tectonics.'),
('Rock Cycle Basics', 'This page explains the rock cycle in simple terms.');

------------------------------------------------------------
-- QUIZ
------------------------------------------------------------
INSERT INTO dbo.Quiz (QuizTitle, QuizType, CreatedBy)
VALUES
('Intro to Geography Quiz', 'exercise', 2),
('Rocks Identification Test', 'assessment', 2);

------------------------------------------------------------
-- CHAPTER CONTENTS
------------------------------------------------------------
-- Intro Geography (Chapters 1–3)
INSERT INTO dbo.ChapterContents (ChapterId, ContentType, ContentTitle, LinkId)
VALUES
(1, 'Page', 'Intro Reading Page', 1),
(1, 'Quiz', 'Intro Quiz', 1),
(2, 'File', 'Earth Structure Diagram', 2),
(2, 'Page', 'Physical Geo Summary', 2),
(3, 'Page', 'Human Geo Overview', 1);

-- Rocks 101 (Chapters 4–6)
INSERT INTO dbo.ChapterContents (ChapterId, ContentType, ContentTitle, LinkId)
VALUES
(4, 'Page', 'Rock Basics Page', 3),
(4, 'Quiz', 'Rock Cycle Quiz', 2),
(5, 'File', 'Igneous Diagram', 2),
(6, 'Page', 'Sedimentary Summary', 3);

------------------------------------------------------------
-- QUESTIONS
------------------------------------------------------------
INSERT INTO dbo.Questions (Question, Option1, Option2, Option3, Option4, CorrectAnswer)
VALUES
-- Quiz 1
('What does geography study?', 'Earth and its features', 'Human societies', 'Only landforms', 'Only maps', 1),
('Which is a branch of geography?', 'Marine biology', 'Physical geography', 'Chemistry', 'Botany', 2),
('Which theme focuses on where things are?', 'Region', 'Place', 'Location', 'Movement', 3),

-- Quiz 2
('Which rock is formed from cooled magma?', 'Igneous', 'Sedimentary', 'Metamorphic', 'None', 1),
('Which process forms sedimentary rocks?', 'Cooling', 'Compaction', 'Melting', 'Crystallization', 2),
('Metamorphic rocks are formed by?', 'Pressure & Heat', 'Erosion', 'Freezing', 'Sedimentation', 1);

------------------------------------------------------------
-- QUESTION BANK
------------------------------------------------------------
INSERT INTO dbo.QuestionBank (QuizId, QuestionId)
VALUES
(1, 1), (1, 2), (1, 3),
(2, 4), (2, 5), (2, 6);

------------------------------------------------------------
-- FORUM POSTS
------------------------------------------------------------
INSERT INTO dbo.ForumPost (UserId, PostTitle, PostMessage)
VALUES
(3, 'Struggling with map reading', 'Can someone explain latitude and longitude again?'),
(4, 'Rock cycle question', 'Is metamorphic always formed from heat AND pressure?'),
(3, 'Is Dwayne the Rock Johnson a Rock?', 'Can someone please explain?');

------------------------------------------------------------
-- FORUM COMMENTS
------------------------------------------------------------
INSERT INTO dbo.ForumComment (PostId, UserId, CommentMessage)
VALUES
(1, 2, 'Sure! Latitude is horizontal, longitude is vertical.'),
(1, 3, 'Thanks, that actually helps a lot!'),
(2, 2, 'Not always, but generally yes for metamorphic rocks.');

------------------------------------------------------------
-- USER ANSWERS (Sample attempt data)
------------------------------------------------------------
INSERT INTO dbo.UserAnswer (QuestionId, SelectedOption)
VALUES
(1, 1), -- Q1 correct
(2, 2), -- Q2 correct
(3, 3), -- Q3 correct
(4, 1), -- Q4 correct
(5, 2), -- Q5 correct
(6, 1); -- Q6 correct

-- IDs assumed to be 1–6

------------------------------------------------------------
-- QUIZ TRY RECORDS
------------------------------------------------------------
INSERT INTO dbo.QuizTry (QuizTry, QuizId, UserId, UserAnswerId)
VALUES
(1, 1, 3, 1),
(1, 1, 4, 2),
(1, 2, 3, 4),
(1, 2, 4, 5);

------------------------------------------------------------
-- SCORE
------------------------------------------------------------
INSERT INTO dbo.Score (QuizId, UserId, Score)
VALUES
(1, 3, 3), -- Amy got 3/3
(1, 4, 2), -- John got 2/3
(2, 3, 3), -- Amy got 3/3
(2, 4, 1); -- John got 1/3

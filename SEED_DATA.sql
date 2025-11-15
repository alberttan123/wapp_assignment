------------------------------------------------------------
-- SEED_DATA.sql (Updated for new schema)
-- Geography learning platform seed data
------------------------------------------------------------

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
 8,
 '~/Media/geography-banner.jpg',
 2),

('Rocks & Minerals 101',
 'Explore igneous, sedimentary, and metamorphic rocks.',
 6,
 '~/Media/rock-banner.jpg',
 2);


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
-- FILES
------------------------------------------------------------
INSERT INTO dbo.Files (FilePath, FileName)
VALUES
('/files/geo/intro_worksheet.pdf', 'Intro_worksheet.pdf'),
('/files/geo/rock_cycle_diagram.png', 'Rock_Cycle_Diagram.png');

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
-- Idempotent: add CreatedBy to Quiz if missing, and relate to Users
IF COL_LENGTH('dbo.Quiz', 'CreatedBy') IS NULL
BEGIN
  ALTER TABLE dbo.Quiz ADD CreatedBy INT NULL;
  ALTER TABLE dbo.Quiz WITH CHECK
    ADD CONSTRAINT FK_Quiz_Users_CreatedBy
    FOREIGN KEY (CreatedBy) REFERENCES dbo.Users(UserId);
END
GO

-- Optional backfill: mark all existing 'assessment' rows as created by geo_teacher (UserId=2)
UPDATE q
SET q.CreatedBy = 2
FROM dbo.Quiz q
WHERE q.QuizType = 'assessment' AND q.CreatedBy IS NULL;
GO

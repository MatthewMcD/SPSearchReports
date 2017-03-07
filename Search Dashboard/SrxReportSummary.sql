USE [AbleBlue_Auditing]
GO

/****** Object:  Table [dbo].[SrxReportSummary]    Script Date: 3/7/2017 9:18:16 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SrxReportSummary](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[BatchTimeStamp] [datetime] NULL,
	[RunId] [nvarchar](20) NULL,
	[FarmId] [nvarchar](40) NULL,
	[Source] [nvarchar](max) NULL,
	[Name] [nvarchar](100) NULL,
	[Level] [nvarchar](100) NULL,
	[Result] [nvarchar](10) NULL,
	[Timestamp] [datetime] NULL,
	[Headline] [nvarchar](max) NULL,
	[Category] [nvarchar](100) NULL,
	[Data] [nvarchar](max) NULL,
	[Alert] [nvarchar](max) NULL,
	[Details] [nvarchar](max) NULL,
	[ControlFile] [nvarchar](max) NULL,
	[Dashboard] [nvarchar](max) NULL,
 CONSTRAINT [PK_SrxSummaryReport] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)

GO



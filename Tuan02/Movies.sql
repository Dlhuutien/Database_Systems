USE [master]
GO
/****** Object:  Database [Movies]    Script Date: 21/09/2022 8:34:41 CH ******/
CREATE DATABASE [Movies]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Movies_data', FILENAME = N'C:\Movies\Movies_data.mdf' , SIZE = 25600KB , MAXSIZE = 40960KB , FILEGROWTH = 1024KB ),
( NAME = N'Movies_data2', FILENAME = N'C:\Movies\Movies_data2.fdf' , SIZE = 10240KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Movies_log', FILENAME = N'C:\Movies\Movies_data.fdf' , SIZE = 6144KB , MAXSIZE = 8192KB , FILEGROWTH = 1024KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [Movies] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Movies].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Movies] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Movies] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Movies] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Movies] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Movies] SET ARITHABORT OFF 
GO
ALTER DATABASE [Movies] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Movies] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Movies] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Movies] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Movies] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Movies] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Movies] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Movies] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Movies] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Movies] SET  ENABLE_BROKER 
GO
ALTER DATABASE [Movies] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Movies] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Movies] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Movies] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Movies] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Movies] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Movies] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Movies] SET RECOVERY FULL 
GO
ALTER DATABASE [Movies] SET  MULTI_USER 
GO
ALTER DATABASE [Movies] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Movies] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Movies] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Movies] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Movies] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Movies] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'Movies', N'ON'
GO
ALTER DATABASE [Movies] SET QUERY_STORE = OFF
GO
USE [Movies]
GO
/****** Object:  UserDefinedDataType [dbo].[Category_num]    Script Date: 21/09/2022 8:34:42 CH ******/
CREATE TYPE [dbo].[Category_num] FROM [int] NOT NULL
GO
/****** Object:  UserDefinedDataType [dbo].[Cust_num]    Script Date: 21/09/2022 8:34:42 CH ******/
CREATE TYPE [dbo].[Cust_num] FROM [int] NOT NULL
GO
/****** Object:  UserDefinedDataType [dbo].[Invoice_num]    Script Date: 21/09/2022 8:34:42 CH ******/
CREATE TYPE [dbo].[Invoice_num] FROM [int] NOT NULL
GO
/****** Object:  UserDefinedDataType [dbo].[Movie_num]    Script Date: 21/09/2022 8:34:42 CH ******/
CREATE TYPE [dbo].[Movie_num] FROM [int] NOT NULL
GO
/****** Object:  Table [dbo].[Category]    Script Date: 21/09/2022 8:34:42 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Category](
	[Category_num] [dbo].[Category_num] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](20) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Category_num] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Customer]    Script Date: 21/09/2022 8:34:42 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customer](
	[Cust_num] [dbo].[Cust_num] IDENTITY(300,1) NOT NULL,
	[Lname] [varchar](20) NOT NULL,
	[Fname] [varchar](20) NOT NULL,
	[Address1] [varchar](30) NOT NULL,
	[Address2] [varchar](20) NULL,
	[City] [varchar](20) NULL,
	[State] [char](2) NULL,
	[Zip] [char](10) NULL,
	[Phone] [varchar](10) NOT NULL,
	[Join_date] [smalldatetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Cust_num] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Movie]    Script Date: 21/09/2022 8:34:42 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Movie](
	[Movie_num] [dbo].[Movie_num] NOT NULL,
	[Title] [dbo].[Cust_num] NOT NULL,
	[Category_Num] [dbo].[Category_num] NOT NULL,
	[Date_purch] [smalldatetime] NULL,
	[Rental_price] [int] NULL,
	[Rating] [char](5) NULL,
PRIMARY KEY CLUSTERED 
(
	[Movie_num] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Rental]    Script Date: 21/09/2022 8:34:42 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Rental](
	[Invoice_num] [dbo].[Invoice_num] NOT NULL,
	[Cust_num] [dbo].[Cust_num] NOT NULL,
	[Rental_date] [smalldatetime] NOT NULL,
	[Due_date] [smalldatetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Invoice_num] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Rental_Detail]    Script Date: 21/09/2022 8:34:42 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Rental_Detail](
	[Invoice_num] [dbo].[Invoice_num] NOT NULL,
	[Line_num] [int] NOT NULL,
	[Movie_num] [dbo].[Movie_num] NOT NULL,
	[Rental_price] [smallmoney] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Customer] ADD  CONSTRAINT [DK_customer_join_date]  DEFAULT (getdate()) FOR [Join_date]
GO
ALTER TABLE [dbo].[Movie] ADD  CONSTRAINT [DK_movie_date_purch]  DEFAULT (getdate()) FOR [Date_purch]
GO
ALTER TABLE [dbo].[Rental] ADD  CONSTRAINT [DK_rental_rental_date]  DEFAULT (getdate()) FOR [Rental_date]
GO
ALTER TABLE [dbo].[Rental] ADD  CONSTRAINT [DK_rental_due_date]  DEFAULT (getdate()+(2)) FOR [Due_date]
GO
ALTER TABLE [dbo].[Movie]  WITH CHECK ADD  CONSTRAINT [FK_movie] FOREIGN KEY([Category_Num])
REFERENCES [dbo].[Category] ([Category_num])
GO
ALTER TABLE [dbo].[Movie] CHECK CONSTRAINT [FK_movie]
GO
ALTER TABLE [dbo].[Rental]  WITH CHECK ADD  CONSTRAINT [FK_rental] FOREIGN KEY([Cust_num])
REFERENCES [dbo].[Customer] ([Cust_num])
GO
ALTER TABLE [dbo].[Rental] CHECK CONSTRAINT [FK_rental]
GO
ALTER TABLE [dbo].[Rental_Detail]  WITH CHECK ADD  CONSTRAINT [FK_datail_movie] FOREIGN KEY([Movie_num])
REFERENCES [dbo].[Movie] ([Movie_num])
GO
ALTER TABLE [dbo].[Rental_Detail] CHECK CONSTRAINT [FK_datail_movie]
GO
ALTER TABLE [dbo].[Rental_Detail]  WITH CHECK ADD  CONSTRAINT [FK_detail_invoice] FOREIGN KEY([Invoice_num])
REFERENCES [dbo].[Rental] ([Invoice_num])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Rental_Detail] CHECK CONSTRAINT [FK_detail_invoice]
GO
ALTER TABLE [dbo].[Movie]  WITH CHECK ADD  CONSTRAINT [CK_movie] CHECK  (([Rating]='NR' OR [Rating]='NC17' OR [Rating]='R' OR [Rating]='PG' OR [Rating]='G'))
GO
ALTER TABLE [dbo].[Movie] CHECK CONSTRAINT [CK_movie]
GO
ALTER TABLE [dbo].[Rental]  WITH CHECK ADD  CONSTRAINT [CK_Due_date] CHECK  (([Due_date]>=[Rental_date]))
GO
ALTER TABLE [dbo].[Rental] CHECK CONSTRAINT [CK_Due_date]
GO
USE [master]
GO
ALTER DATABASE [Movies] SET  READ_WRITE 
GO

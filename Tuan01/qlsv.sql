USE [QLSV]
GO
/****** Object:  Table [dbo].[KETQUA]    Script Date: 06/09/2022 3:12:53 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[KETQUA](
	[MaSV] [nchar](5) NOT NULL,
	[MaMH] [char](5) NOT NULL,
	[Diem] [real] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LOP]    Script Date: 06/09/2022 3:12:53 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LOP](
	[MaLop] [char](5) NOT NULL,
	[TenLop] [nvarchar](20) NOT NULL,
	[SiSoDuKien] [int] NOT NULL,
	[NgayKhaiGiang] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MONHOC]    Script Date: 06/09/2022 3:12:53 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MONHOC](
	[MaMH] [char](5) NOT NULL,
	[TenMH] [nvarchar](30) NOT NULL,
	[SoTC] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SINHVIEN]    Script Date: 06/09/2022 3:12:53 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SINHVIEN](
	[MaSV] [char](5) NOT NULL,
	[TenHo] [nvarchar](40) NOT NULL,
	[NgaySinh] [datetime] NULL,
	[MaLop] [char](5) NOT NULL
) ON [PRIMARY]
GO

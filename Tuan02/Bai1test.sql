-- Tuan 2, Bai 1
-- Tao CSDL QLBH
create database qlbh
on primary
(	name = QLBH_data,
	filename = 'C:\BTSQL\QLBH_data.mdf',
	size = 10 MB, maxsize = 20 MB, filegrowth = 20%),
filegroup QLBHgroup1
(	name = QLBH_data1,
	filename = 'C:\BTSQL\QLBH_data1.ndf',
	size = 10 MB, maxsize = 20 MB, filegrowth = 10 MB)
log on
(	name = QLBH_log,
	filename = 'C:\BTSQL\QLBH_log.ldf',
	size = 5 MB, maxsize = 10 MB, filegrowth = 5 MB)
go

sp_helpdb qlbh
go

use qlbh
go

-- Tao bang
create table NhomSanPham(
	MaNhom int primary key not null,
	TenNhom varchar(15)
)
go

create table NhaCungCap(
	MaNCC int not null primary key,
	TenNCC nvarchar(40) not null,
	DiaChi nvarchar(60),
	Phone nvarchar(24),
	SoFax nvarchar(24),
	DCmail nvarchar(50)
)
go

create table SanPham (
	MaSP int not null primary key,
	TenSP nvarchar(40) not null,
	MaNCC int references NhaCungCap(MaNCC),
	-- hoac: MaNCC int foreign key references NhaCungCap(MaNCC),
	MoTa nvarchar(50),
	MaNhom int references NhomSanPham(MaNhom),
	DonViTinh nvarchar(20),
	GiaGoc Money check (GiaGoc > 0),
	SLTon int check (SLTon >=0)
)
go

/* Hoac
create table SanPham(
	MaSP int not null,
	TenSP nvarchar(40) not null,
	MaNCC int,
	MoTa nvarchar(50),
	MaNhom int,
	DonViTinh nvarchar(20),
	GiaGoc Money,
	SLTon int,
	constraint PK_SanPham primary key (MaSP),
	constraint FK_MaNCC foreign key (MaNCC) references NhaCungCap(MaNCC),
	constraint FK_MaNhom foreign key (MaNhom) references NhomSanPham(MaNhom),
	constraint PK_GiaGoc check (GiaGoc > 0),
	constraint PK_SLTon check (SLTon >=0)
)
go
*/

create table KhachHang(
	MaKH char(5) primary key,
	TenKH nvarchar(40) not null,
	LoaiKH nvarchar(3) check (LoaiKH in ('VIP','TV','VL')),
	DiaChi nvarchar(60),
	Phone nvarchar(24),
	DCMail nvarchar(50),
	DiemTL int check (DiemTL >= 0)
)
go



create table HoaDon(
	MaHD int primary key,
	NgayLapHD DateTime check (NgayLapHD >= getdate()) default getdate(),
	NgayGiao DateTime,
	Noichuyen nvarchar(60) not null,
	MaKH char(5) references KhachHang(MaKH)
)
go

create table CT_HoaDon(
	MaHD int not null references HoaDon(MaHD),
	MaSP int not null references SanPham(MaSP),
	SoLuong smallint check (SoLuong > 0),
	DonGia Money,
	ChietKhau Money check (ChietKhau >= 0),
	constraint PK_CT_HoaDon primary key (MaHD, MaSP)
)
go

/*
-- Cach 2:
create table CT_HoaDon(
	MaHD int not null,
	MaSP int not null,
	SoLuong smallint,
	DonGia Money,
	ChietKhau Money,
	constraint PK_CT_HoaDon primary key (MaHD, MaSP),
	constraint FK_CT_HoaDon_MaHD foreign key (MaHD) references HoaDon(MaHD),
	constraint FK_CT_HoaDon_MaSP foreign key (MaSP) references SanPham(MaSP),
	constraint CK_CT_HoaDon_SoLuong check (SoLuong > 0),
	constraint CK_CT_HoaDon_ChietKhau check (ChietKhau >= 0)
)
go

-- Cach 3:
create table CT_HoaDon(
	MaHD int not null,
	MaSP int not null,
	SoLuong smallint,
	DonGia Money,
	ChietKhau Money
)

alter table CT_HoaDon
add constraint PK_CT_HoaDon primary key (MaHD, MaSP),
	constraint FK_CT_HoaDon_MaHD foreign key (MaHD) references HoaDon(MaHD),
	constraint FK_CT_HoaDon_MaSP foreign key (MaSP) references SanPham(MaSP),
	constraint CK_CT_HoaDon_SoLuong check (SoLuong > 0),
	constraint CK_CT_HoaDon_ChietKhau check (ChietKhau >= 0)
go

*/

-- Kiem tra bang
sp_help CT_HoaDon
go

-- Kiem tra rang buoc
sp_helpconstraint HoaDon
go

-- Them cot
alter table HoaDon
add LoaiHD char(1) check (LoaiHD in ('N', 'X', 'C', 'T')) default 'N'
go

-- Them rang buoc
alter table HoaDon
add constraint CK_NgayGiao check (NgayGiao >= NgayLapHD)
go


-- Bài tập 1
-- Tạo CSDL QLBH
create database QLBH
on primary
(	name = QLBH_data,
	filename = 'C:\SQL\QLBH_data.mdf',
	size = 10 MB, maxsize = 20 MB, filegrowth = 20%),
filegroup QLBHgroup1
(	name = QLBH_data1,
	filename = 'C:\SQL\QLBH_data1.ndf',
	size = 10 MB, maxsize = 20 MB, filegrowth = 10 MB)
log on
(	name = QLBH_log,
	filename = 'C:\SQL\QLBH_log.ldf',
	size = 5 MB, maxsize = 10 MB, filegrowth = 5 MB)

use QLBH

-- Tao bang
create table NhomSanPham(
	MaNhom int primary key not null,
	TenNhom varchar(15)
)

create table NhaCungCap(
	MaNCC int primary key not null,
	TenNCC nvarchar(40) not null,
	DiaChi nvarchar(60),
	Phone nvarchar(24),
	SoFax nvarchar(24),
	DCmail nvarchar(50)
)

create table SanPham (
	MaSP int primary key not null,
	TenSP nvarchar(40) not null,
	MaNCC int references NhaCungCap(MaNCC),
	MoTa nvarchar(50),
	MaNhom int references NhomSanPham(MaNhom),
	DonViTinh nvarchar(20),
	GiaGoc Money check (GiaGoc > 0),
	SLTon int check (SLTon >=0)
)

create table KhachHang(
	MaKH char(5) primary key,
	TenKH nvarchar(40) not null,
	LoaiKH nvarchar(3) check (LoaiKH in ('VIP','TV','VL')),
	DiaChi nvarchar(60),
	Phone nvarchar(24),
	DCMail nvarchar(50),
	DiemTL int check (DiemTL >= 0)
)

create table HoaDon(
	MaHD int primary key,
	NgayLapHD DateTime check (NgayLapHD >= getdate()) default getdate(),
	NgayGiao DateTime,
	Noichuyen nvarchar(60) not null,
	MaKH char(5) references KhachHang(MaKH)
)

create table CT_HoaDon(
	MaHD int references HoaDon(MaHD) not null,
	MaSP int references SanPham(MaSP) not null,
	SoLuong smallint check (SoLuong > 0),
	DonGia Money,
	ChietKhau Money check (ChietKhau >= 0),
	constraint PK_CT_HoaDon primary key (MaHD, MaSP)
)


-- Thêm cột LoaiHD
alter table HoaDon
add LoaiHD char(1) check (LoaiHD in ('N', 'X', 'C', 'T')) default 'N'


-- Thêm ràng buộc
alter table HoaDon
add constraint CK_NgayGiao check (NgayGiao >= NgayLapHD)



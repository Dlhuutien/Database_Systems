-- Tạo CSDL QLBH
create database QLBH
on primary
(	name = QLBH_data,
	filename = 'T:\SQL\QLBH_data.mdf',
	size = 10 MB, maxsize = 20 MB, filegrowth = 20%),
filegroup QLBHgroup1
(	name = QLBH_data1,
	filename = 'T:\SQL\QLBH_data1.ndf',
	size = 10 MB, maxsize = 20 MB, filegrowth = 10 MB)
log on
(	name = QLBH_log,
	filename = 'T:\SQL\QLBH_log.ldf',
	size = 5 MB, maxsize = 10 MB, filegrowth = 5 MB)

use QLBH

-- Tao bang
create table NhomSanPham(
	MaNhom int primary key not null,
	TenNhom varchar(20)
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


--1.insert
insert into NhomSanPham values (1, N'DienTu')
insert into NhomSanPham values (2, N'Gia Dung')
insert into NhomSanPham values (3, N'Dung Cu GDinh')
insert into NhomSanPham values (4, N'Cac Mat Hang Khac')

insert into NhaCungCap values (1, N'Cong ty TNHH Nam Phuong', N'1 Le Loi Phuong 4 Go Vap', 083843456, 323434, N'NamPhuong@yahoo.com')
insert into NhaCungCap values (2, N'Cong ty Lan Ngoc', N'12 Co Ba Quat Quan 1 TP.HCM', 086234567, 83434355, N'LanNgoc@gmail.com')

insert into SanPham values(1, N'May Tinh', 1, N'May soni Ram 2GB', 1, N'Cai', 7000.0000, 100)
insert into SanPham values(2, N'Ban Phim', 1, N'Ban phim 101 phim', 1, N'Cai', 1000.0000, 50)
insert into SanPham values(3, N'Chuot', 1, N'Chuot khong day', 1, N'Cai', 800.0000, 150)
insert into SanPham values(4, N'CPU', 1, N'CPU', 1, N'Cai', 3000.0000, 200)
insert into SanPham values(5, N'USB', 1, N'8GB', 1, N'Cai', 500.0000, 100)
insert into SanPham(MaSP,TenSP,MaNCC,MaNhom,DonViTinh,GiaGoc,SLTon) values(6, N'Lo Vi Song', 2, 3, N'Cai', 1000000.0000, 20)

insert into KhachHang(MaKH,TenKH,LoaiKH,DiaChi) values (N'KH1', N'Nguyen Thu Hang', N'VL', N'12 Nguyen Du')
insert into KhachHang(MaKH,TenKH,LoaiKH,DiaChi,DCMail,DiemTL) values (N'KH2', N'Le Minh', N'TV', N'34 Dien Bien Phu', N'LeMinh@yahoo.com',100)
insert into KhachHang(MaKH,TenKH,LoaiKH,DiaChi,DCMail) values (N'KH3', N'Nguyen Minh Trung', N'VIP', N'3 Le Loi Quan Go VVap', N'Trung@gmail.com')

insert into HoaDon(	MaHD,NgayLapHD ,NgayGiao,Noichuyen,MaKH) values (1, '2023-9-30', '2023-10-5', N'Cua Hang ABC 3 Ly Chinh Thang Quan 3', N'KH1')
insert into HoaDon(	MaHD,NgayLapHD ,NgayGiao,Noichuyen,MaKH) values (2, '2023-7-29', '2023-8-10', N'23 Le Loi Quan Go Vap', N'KH2')
insert into HoaDon(	MaHD,NgayLapHD ,NgayGiao,Noichuyen,MaKH) values (3, '2023-10-1', '2023-10-1', N'2 Nguyen Du Quan Go Vap', N'KH3')

insert into CT_HoaDon(MaHD, MaSP, SoLuong, DonGia) values ( 1, 1, 5, 8000.0000)
insert into CT_HoaDon(MaHD, MaSP, SoLuong, DonGia) values ( 1, 2, 4, 1200.0000)
insert into CT_HoaDon(MaHD, MaSP, SoLuong, DonGia) values ( 1, 3, 15, 1000.0000)
insert into CT_HoaDon(MaHD, MaSP, SoLuong, DonGia) values ( 2, 2, 9, 1200.0000)
insert into CT_HoaDon(MaHD, MaSP, SoLuong, DonGia) values ( 2, 4, 5, 8000.0000)
insert into CT_HoaDon(MaHD, MaSP, SoLuong, DonGia) values ( 3, 2, 20, 3500.0000)
insert into CT_HoaDon(MaHD, MaSP, SoLuong, DonGia) values ( 3, 3, 15, 1000.0000)

--2.update
--a
update SanPham set GiaGoc = 1000.0000+1000.0000*5/100 where MaSP = 2
--b
update SanPham set SLton = 100 where MaSP = 6
--c 
update SanPham set MoTa = N'V.04' where MaSP = 6
--d
--Cách 1
update HoaDon set MaKH = NULL where MaKH = N'KH3'
update KhachHang set MaKH = N'VI003' where MaKH = N'KH3'
--Cách 2
ALTER TABLE HOADON DROP CONSTRAINT FK__HoaDon__MaKH__31EC6D26 
ALTER TABLE HOADON ADD CONSTRAINT FK__HoaDon__MaKH__31EC6D26 
FOREIGN KEY (MaKH) REFERENCES KHACHHANG(MAKH) ON UPDATE CASCADE ON DELETE CASCADE
UPDATE	KHACHHANG SET MaKH = 'VI003' WHERE MaKH = 'KH3'

--e
update HoaDon set MaKH = NULL where MaKH = N'KH1'
update KhachHang set MaKH = N'VL001' where MaKH = N'KH1'

update HoaDon set MaKH = NULL where MaKH = N'KH2'
update KhachHang set MaKH = N'T002' where MaKH = N'KH2'

--3.delete
--a
delete from NhomSanPham where MaNhom = 4
--b
delete from CT_HoaDon where MaHD = 1
delete from CT_HoaDon where MaSP = 3
--c
delete from HoaDon where MaKH = 1
--d
delete from HoaDon where MaKH = 2
/*BÀI TẬP 1: INSERT dữ liệu*/
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


/*1. Dùng lệnh Insert…Select…
a. Insert dữ liệu vào bảng KhachHang trong QLBH với dữ liệu nguồn là
bảng Customers trong NorthWind.*/
insert into KhachHang(MaKH, TenKH)
select CustomerID, CompanyName
from Northwind.dbo.Customers
select *from KhachHang

/*b. Insert dữ liệu vào bảng Sanpham trong QLBH. Dữ liệu nguồn là các
sản phẩm có SupplierID từ 4 đến 29 trong bảng
Northwind.dbo.Products*/
insert into SanPham(MaSP,TenSP)
select SupplierID, CompanyName
from Northwind.dbo.Suppliers
where SupplierID>=4 and SupplierID<=29

select *from SanPham

/*c. Insert dữ liệu vào bảng HoaDon trong QLBH. Dữ liệu nguồn là các
hoá đơn có OrderID nằm trong khoảng 10248 đến 10350 trong
NorthWind.dbo.[Orders]*/
insert into HoaDon(MaHD,MaKH,NgayGiao,Noichuyen)
select OrderID,CustomerID, ShippedDate,ShipName
from Northwind.dbo.Orders
where OrderID>=10248 and OrderID<10350

select *from HoaDon

/*d. Insert dữ liệu vào bảng CT_HoaDon trong QLBH. Dữ liệu nguồn là
các chi tiết hoá đơn có OderID nằm trong khoảng 10248 đến 10350
trong NorthWind.dbo.[Order Detail]*/
insert into CT_HoaDon(MaHD,MaSP,SoLuong)
select OrderID, ProductID, Quantity
from Northwind.dbo.[Order Details]
where OrderID>=10248 and OrderID<10350

select *from CT_HoaDon/*BÀI TẬP 2: LỆNH UPDATE
1. Cập nhật chiết khấu 0.1 cho các mặt hàng trong các hóa đơn xuất bán
vào ngày ‘1/1/1997’*/
update Northwind.dbo.[Order Details]
set Discount = Discount * 1.1
where OrderID in (select OrderID from Northwind.dbo.Orders
					where OrderDate = '1997-1-1')

select *from Northwind.dbo.[Order Details]

/*2. Cập nhật đơn giá bán 17.5 cho mặt hàng có mã 11 trong các hóa đơn
xuất bán vào tháng 2 năm 1997*/
update Northwind.dbo.[Order Details]
set UnitPrice=17.5
where OrderID in (select OrderID from Northwind.dbo.Orders 
					where OrderID=11 and (month(OrderDate)=2 and Year(OrderDate)=1997))

select *from Northwind.dbo.[Order Details]

/*3. Cập nhật giá bán các sản phẩm trong bảng [Order Details] bằng với đơn
giá mua trong bảng [Products] của các sản phẩm được cung cấp từ nhà
cung cấp có mã là 4 hay 7 và xuất bán trong tháng 4 năm 1997*/
update Northwind.dbo.[Order Details]
set UnitPrice = p.UnitPrice
from Northwind.dbo.[Order Details] od join Northwind.dbo.Products p on od.ProductID=p.ProductID
join Northwind.dbo.Orders o on od.OrderID=o.OrderID
where (CategoryID = 4 or CategoryID=7) and (month(OrderDate)=4 and Year(OrderDate)=1997)

select *from Northwind.dbo.[Order Details]

/*4. Cập nhật tăng phí vận chuyển (Freight) lên 20% cho những hóa đơn có
tổng trị giá hóa đơn >= 10000 và xuất bán trong tháng 1/1997*/
update Northwind.dbo.Orders
set Freight = 0.2
where OrderID in (select OrderID
				  from Northwind.dbo.[Order Details]
				  where month(ShippedDate)=1 and Year(ShippedDate)=1997
				  group by OrderID
				  having sum(Quantity*UnitPrice)>=10000)

select *from Northwind.dbo.Orders

/*5. Thêm 1 cột vào bảng Customers lưu thông tin về loại thành viên :
Member97 varchar(3) . Cập nhật cột Member97 là ‘VIP’ cho những
khách hàng có tổng trị giá các đơn hàng trong năm 1997 từ 50000 trở
lên.*/
alter table Customers add Member97 varchar(3)
 
update Northwind.dbo.Customers 
set Member97 = 'VIP'
where CustomerID in (select CustomerID 
					 from Northwind.dbo.Orders o join Northwind.dbo.[Order Details] od
					 on o.OrderID=od.OrderID
					 where year(OrderDate)=1997
					 group by CustomerID
					 having sum(Quantity*UnitPrice)>50000)

select *from Northwind.dbo.Customers

/*BÀI TẬP 3: LỆNH DELETE
1. Xóa các dòng trong [Order Details] có ProductID 24, là “chi tiết của
hóa đơn” xuất bán cho khách hàng có mã ‘SANTG’*/
delete from Northwind.dbo.[Order Details]
from Northwind.dbo.[Order Details] od join Northwind.dbo.Orders o on od.OrderID=o.OrderID
where ProductID =24 and CustomerID like 'SANTG'

/*2. Xóa các dòng trong [Order Details] có ProductID 35, là “chi tiết của
hóa đơn” xuất bán trong năm 1998 cho khách hàng có mã ‘SANTG’*/
delete from Northwind.dbo.[Order Details]
from Northwind.dbo.[Order Details] od join Northwind.dbo.Orders o on od.OrderID=o.OrderID
where ProductID =35 and CustomerID like 'SANTG' and YEAR(OrderDate)=1998 

/*3. Thực hiện xóa tất cả các dòng trong [Order Details] là “chi tiết của
các hóa đơn” bán cho khách hàng có mã ‘SANTG’*/
delete from Northwind.dbo.[Order Details]
from Northwind.dbo.[Order Details] od join Northwind.dbo.Orders o on od.OrderID=o.OrderID
where CustomerID like 'SANTG'

select *from Northwind.dbo.[Order Details]
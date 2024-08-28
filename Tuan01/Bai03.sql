--21090071_ Đặng Lê Hữu Tiến

CREATE DATABASE QLSV
CREATE TABLE LOP(
	MaLop char(5) Not Null,
	TenLop NVarchar(20) Not Null,
	SiSoDuKien Int,
	NgayKhaiGiang DateTime)
CREATE TABLE SINHVIEN(
	Masv char(5) Not Null,
	TenHo NVarchar(20) Not Null,
	NgaySinh DateTime,
	MaLop char(5))
CREATE TABLE MONHOC(
	MaMH char(5) Not Null,
	Tenmh NVarchar(30),
	SoTC int)
CREATE TABLE KETQUA(
	MaSV char(5) Not Null,
	MaMH char(5),
	Diem real)

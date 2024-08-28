CREATE TABLE Congviec1
(
Macv int primary key,
Tencv varchar(30))

CREATE TABLE NhanVien1
(
MaNV int primary key,
Hoten varchar(30),
Macongviec int REFERENCES Congviec1(Macv)
)

CREATE TABLE Congviec2
(
Macv int primary key,
Tencv varchar(30))

CREATE TABLE NhanVien2
(
MaNV int primary key,
Hoten varchar(30),
Macongviec int REFERENCES Congviec2(Macv)
ON DELETE Cascade
ON UPDATE Cascade
)

CREATE TABLE Congviec3
(
Macv int primary key,
Tencv varchar(30))

CREATE TABLE NhanVien3
(
MaNV int primary key,
Hoten varchar(30),
Macongviec int
)

ALTER TABLE NhanVien3
ADD CONSTRAINT Macv_FK Foreign key (Macongviec) REFERENCES Congviec3(Macv)
ON DELETE Set NULL
ON UPDATE Cascade

sp_helpConstraint NhanVien3

ALTER TABLE Nhanvien3 DROP CONSTRAINT PK__NhanVien__2725D70A59CD2F44
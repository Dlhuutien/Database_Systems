--Bài tập 2:
--1. Dùng T-SQL tạo csdl Movies
CREATE DATABASE Movies
ON PRIMARY
(
NAME = Movies_data,
FILENAME = 'C:\Movies\Movies_data.mdf',
SIZE = 25MB,
MAXSIZE = 40MB,
FILEGROWTH = 1MB
)
LOG ON 
(
NAME = Movies_log,
FILENAME = 'C:\Movies\Movies_data.fdf',
SIZE = 6MB,
MAXSIZE = 8MB,
FILEGROWTH = 1MB)

--2. Tạo 1 Data file thứ 2
ALTER DATABASE Movies
ADD FILE (
	NAME = Movies_data2,
	FILENAME = 'C:\Movies\Movies_data2.fdf',
	SIZE = 10MB,
	MAXSIZE = 40MB,
	FILEGROWTH = 1MB
)
ALTER DATABASE Movies
MODIFY FILE( NAME = 'Movies_data2', SIZE = 15)

--5. Thực hiện định nghĩa các user-defined datatype
exec sp_addtype Movie_num,'Int','not null'
exec sp_addtype Category_num,'Int','not null'
exec sp_addtype Cust_num,'Int','not null'
exec  sp_addtype Invoice_num,'Int','not null'

--6. Thực hiện tạo các bảng vào CSDL Movies
use Movies
CREATE TABLE Customer
(
	Cust_num cust_num IDENTITY(300,1) not null,
	Lname varchar(20) NOT NULL,
	Fname varchar(20) NOT NULL,
	Address1 varchar(30) NOT NULL,
	Address2 varchar(20),
	City varchar(20),
	State char(2),
	Zip char(10),
	Phone varchar(10) NOT NULL,
	Join_date Smalldatetime NOT NULL
)

CREATE TABLE Category
(
	Category_num category_num identity(1,1) NOT NULL,
	Description varchar(20) NOT NULL
)

CREATE TABLE Movie
(
	Movie_num Movie_num NOT NULL,
	Title Cust_num NOT NULL,
	Category_Num category_num NOT NULL,
	Date_purch Smalldatetime,
	Rental_price int,
	Rating char(5)
)

CREATE TABLE Rental
(
	Invoice_num Invoice_num NOT NULL,
	Cust_num Cust_num NOT NULL,
	Rental_date Smalldatetime NOT NULL,
	Due_date Smalldatetime NOT NULL,
)

CREATE TABLE Rental_Detail
(
	Invoice_num Invoice_num NOT NULL,
	Line_num int NOT NULL,
	Movie_num Movie_num NOT NULL,
	Rental_price Smallmoney NOT NULL
)
--9. Thêm khoá chính
ALTER TABLE Movie
	ADD PRIMARY KEY(Movie_num)
ALTER TABLE Customer
	ADD PRIMARY KEY(Cust_num)
ALTER TABLE Category
	ADD PRIMARY KEY(Category_num)
ALTER TABLE Rental
	ADD PRIMARY KEY(Invoice_num)

sp_helpconstraint Movie
sp_helpconstraint Customer
sp_helpconstraint Category
sp_helpconstraint Rental

--10. Định nghĩa các khóa ngoại
ALTER TABLE Movie WITH CHECK
	ADD CONSTRAINT FK_movie FOREIGN KEY (Category_num) REFERENCES Category(Category_num)
ALTER TABLE Rental WITH CHECK
	ADD CONSTRAINT FK_rental FOREIGN KEY (Cust_num) REFERENCES Customer(Cust_num)
ALTER TABLE Rental_detail WITH CHECK
	ADD CONSTRAINT FK_detail_invoice FOREIGN KEY (Invoice_num) REFERENCES Rental(Invoice_num)
	ON DELETE CASCADE
ALTER TABLE Rental_detail WITH CHECK
	ADD CONSTRAINT FK_datail_movie FOREIGN KEY (Movie_num) REFERENCES Movie(Movie_num)

sp_helpconstraint Movie
sp_helpconstraint Customer
sp_helpconstraint Category
sp_helpconstraint Rental

--12. Định nghĩa giá trị mặc định
ALTER TABLE Movie 
	ADD CONSTRAINT DK_movie_date_purch DEFAULT getdate() FOR Date_purch
ALTER TABLE Customer
	ADD CONSTRAINT DK_customer_join_date DEFAULT getdate() FOR join_date
ALTER TABLE Rental
	ADD CONSTRAINT DK_rental_rental_date DEFAULT getdate() FOR Rental_date
ALTER TABLE Rental
	ADD CONSTRAINT DK_rental_due_date DEFAULT getdate()+2 FOR Due_date

--13. Định nghĩa các ràng buộc
ALTER TABLE Movie
	ADD CONSTRAINT CK_movie CHECK (Rating in('G', 'PG', 'R', 'NC17', 'NR'))

ALTER TABLE Rental
	ADD CONSTRAINT CK_Due_date CHECK (Due_date>= Rental_date)




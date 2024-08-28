--Họ tên: Đặng Lê Hữu Tiến
--MSSV: 21090071
--BÀI TẬP THỰC HÀNH TUẦN 10

use Northwind
go
--1. Tạo view vw_Products_Info hiển thị danh sách các sản phẩm từ bảng Products và bảng Categories. 
--Thông tin bao gồm CategoryName, Description, ProductName, QuantityPerUnit, UnitPrice, UnitsInStock
--Thực hiện truy vấn dữ liệu từ View
create view vw_Products_Info as
select CategoryName, Description, ProductName, QuantityPerUnit, UnitPrice, UnitsInStock
from [Categories] c join [Products] p on c.CategoryID = p.CategoryID
go

select * from vw_Products_Info
go

--2. Tạo view vw_CustomerTotals hiển thị tổng tiền các hóa đơn của mỗi khách hàng theo tháng và theo năm.
--Thông tin gồm CustomerID, YEAR(OrderDate) AS Year, MONTH(OrderDate) AS Month, SUM(UnitPrice*Quantity)
create view vw_CustomerTotals as
select c.CustomerID, year(OrderDate) as OrderYear, month(OrderDate) as OrderMonth, sum(UnitPrice*Quantity) as SumOfQuantity
from [Customers] c join [Orders] o on c.CustomerID = o.CustomerID
				   join [Order Details] od on o.OrderID = od.OrderID
group by c.CustomerID, year (OrderDate), month(OrderDate)
go

select * from vw_CustomerTotals
go

--3. Tạo view hiển thị tổng số lượng sản phẩm bán được của mỗi nhân viên theo từng năm
--Thông tin gồm EmployeeID, OrderYear, SumOfQuantity
--Yêu cầu : người dùng không xem được cú pháp lệnh tạo view ?
--Xem lại cú pháp lệnh tạo view ? Thực hiện truy vấn dữ liệu từ View ?
create view vw_EmployeeTotals as
select e.EmployeeID, year(OrderDate) as OrderYear, sum(UnitPrice*Quantity) as SumOfQuantity
from [Employees] e join [Orders] o on e.EmployeeID = o.EmployeeID
				   join [Order Details] od on o.OrderID = od.OrderID
group by e.EmployeeID, year(OrderDate)
go

select * from vw_EmployeeTotals
go

--4. Tạo view ListCustomer_view chứa danh sách các khách hàng có trên 5 hóa đơn đặt hàng từ năm 1997 đến 1998
--Thông tin gồm mã khách hàng (CustomerID) , họ tên (CompanyName), Số hóa đơn (CountOfOrders)
--Thực hiện truy vấn dữ liệu từ View
create view ListCustomer_view as
select c.CustomerID, CompanyName as HoTen, count(OrderID) as CountOfOrders
from [Customers] c join [Orders] o on c.CustomerID = o.CustomerID
where year(OrderDate) in (1997, 1998)
group by c.CustomerID, CompanyName
go

select * from ListCustomer_view
go

--5. Tạo view ListProduct_view chứa danh sách
--những sản phẩm thuộc nhóm hàng ‘Beverages’ và ‘Seafood’ có tổng số lượng bán trong mỗi năm trên 30 sản phẩm
--Thông tin gồm CategoryName, ProductName, Year, SumOfQuantity
--Thực hiện truy vấn dữ liệu từ View
create view ListProduct_view as
select CategoryName, ProductName, year(OrderDate) as Year, sum(Quantity) as SumOfQuantity
from [Categories] c join [Products] p on c.CategoryID = p.CategoryID
					join [Order Details] od on p.ProductID = od.ProductID
					join [Orders] o on o.OrderID = od.OrderID
where CategoryName in ('Beverages', 'Seafood')
group by CategoryName, ProductName, year(OrderDate)
having sum(Quantity) > 30
go

select * from ListProduct_view
go

--6. Tạo view vw_OrderSummary với từ khóa WITH ENCRYPTION gồm OrderYear (năm của ngày lập hóa đơn), OrderMonth (tháng của ngày lập hóa đơn), OrderTotal (tổng tiền sum(UnitPrice*Quantity)) ?
--Thực hiện truy vấn dữ liệu từ View
--Viết lệnh để thấy công dụng của từ khóa trên
create view vw_OrderSummary with encryption as
select OrderYear = year(OrderDate), OrderMonth = month(OrderDate), OrderTotal = sum(UnitPrice*Quantity)
from [Orders] o join [Order Details] od on o.OrderID = od.OrderID
group by year(OrderDate), month(OrderDate)
go

select * from vw_OrderSummary
go

sp_helptext vw_OrderSummary
go

--7. Tạo view vwProducts với từ khóa WITH SCHEMABINDING gồm ProductID, ProductName, Discount ?
--Thực hiện truy vấn dữ liệu từ View
--Thực hiện xóa cột Discount trong bảng Products. Có xóa được không? Vì sao?
create view vwProducts with schemabinding as
select p.ProductID, ProductName, Discount
from [Products] p join [Order Details] od on p.ProductID = od.ProductID
group by p.ProductID, ProductName, Discount
go

select * from vwProducts
go

--8. Tạo view vw_Customer với với từ khóa WITH CHECK OPTION chỉ chứa các khách hàng ở thành phố London và Madrid
--Thông tin gồm: CustomerID, CompanyName, City
create view vw_Customer as
select customerid, companyname, city
from Customers 
where City in ('London','Madrid')
with check option
go

select * from vw_Customer
go

drop view vw_Customer
go

--a. Chèn thêm một khách hàng mới không ở thành phố London và Madrid thông qua view vừa tạo
--Có chèn được không? Giải thích ?
insert vw_Customer values ('KATE','Katherine','California')
go

select * from vw_Customer
go

select * from customers where city = 'london'
go

--Không thể một khách hàng mới không ở thành phố London và Madrid thông qua view vừa tạo được
--Bởi vì không thỏa điều kiện ràng buộc của with check option

--b. Chèn thêm một khách hàng mới ở thành phố London và một khách hàng mới ở thành phố Madrid
--Dùng câu lệnh select trên bảng Customers để xem kết quả ?
insert vw_Customer values ('ANNE','Anne','London')
insert vw_Customer values ('JACK','Jack','Madrid')

select * from vw_Customer
go

--10. Lần lượt tạo các view sau, đặt tên tùy ý, sau đó thực hiện truy vấn dữ liệu từ view
	--Danh sách các sản phẩm có chữ ‘Boxes’ trong DonViTinh
	--Danh sách các sản phẩm có đơn giá < 10
	--Các sản phẩm có đơn giá gốc lớn hơn hay bằng đơn giá gốc trung bình
	--Danh sách các khách hàng ứng với các hóa đơn được lập. Thông tin gồm CustomerID, CompanyName, OrderID, Orderdate
--Có thể INSERT, UPDATE, DELETE dữ liệu thông qua view nào trong các view trên ? Hãy Insert/Update/Delete thử dữ liệu tùy ý

--Danh sách các sản phẩm có chữ ‘Boxes’ trong DonViTinh
create view vw_QuantityPerUnit as
select ProductID, ProductName, QuantityPerUnit
from [Products]
where QuantityPerUnit like '%box%'
go

--Danh sách các sản phẩm có đơn giá < 10
create view vw_UnitPrice_10 as
select ProductID, ProductName, UnitPrice
from [Products]
where UnitPrice < 10
go

--Các sản phẩm có đơn giá gốc lớn hơn hay bằng đơn giá gốc trung bình.
create view vw_AVGUnitPrice as
select ProductID, ProductName, UnitPrice
from Products
where UnitPrice > (select AVG(UnitPrice) from Products)
go


--Đặng Lê Hữu Tiến

/*1. Hiển thị thông tin về hóa đơn có mã ‘10248’, bao gồm: OrderID, 
OrderDate, CustomerID, EmployeeID, ProductID, Quantity, Unitprice,
Discount.*/
select o.OrderID, CustomerID, EmployeeID, ProductID, Quantity, UnitPrice, Discount
from Orders o INNER JOIN [Order Details] d ON o.OrderID = d.OrderID
where o.OrderID like '10248'

/*2. Liệt kê các khách hàng có lập hóa đơn trong tháng 7/1997 và 9/1997.
Thông tin gồm CustomerID, CompanyName, Address, OrderID,
Orderdate. Được sắp xếp theo CustomerID, cùng CustomerID thì sắp xếp
theo OrderDate giảm dần.*/
select c.CustomerID, CompanyName, Address, OrderID, OrderDate
from Orders o join Customers c on o.CustomerID=c.CustomerID
where month(OrderDate)=7 and year(OrderDate)=1997 or month(OrderDate)=9 and year(OrderDate)=1997
order by c.CustomerID, OrderDate desc

/*3. Liệt kê danh sách các mặt hàng xuất bán vào ngày 19/7/1996. Thông tin
gồm : ProductID, ProductName, OrderID, OrderDate, Quantity.*/
select p.ProductID, ProductName, od.OrderID, OrderDate, Quantity
from Products p join [Order Details] od on p.ProductID=od.ProductID
				join Orders o on o.OrderID=od.OrderID
where day(OrderDate)=19 and month(OrderDate)=7 and year(OrderDate)=1996

/*4. Liệt kê danh sách các mặt hàng từ nhà cung cấp (supplier) có mã 1,3,6 và
đã xuất bán trong quý 2 năm 1997. Thông tin gồm : ProductID,
ProductName, SupplierID, OrderID, Quantity. Được sắp xếp theo mã nhà cung cấp (SupplierID), 
cùng mã nhà cung cấp thì sắp xếp theo ProductID.*/
select p.ProductID, ProductName, s.SupplierID, od.OrderID, Quantity, ShippedDate
from Products p join Suppliers s on p.SupplierID=s.SupplierID
				join [Order Details] od on od.ProductID=p.ProductID
				join Orders o on o.OrderID=od.OrderID
where (year(ShippedDate)=1997 and MONTH(ShippedDate)>=4 and MONTH(ShippedDate)<=6)
	and (s.SupplierID like '1' or s.SupplierID like '3' or s.SupplierID like '6')
order by SupplierID, ProductID desc

--5. Liệt kê danh sách các mặt hàng có đơn giá bán bằng đơn giá mua.
select OrderID, SUM(Quantity*od.UnitPrice) as 'Total', p.UnitPrice, Quantity
from [Order Details] od join Products p on od.ProductID=p.ProductID
group by OrderID, p.UnitPrice, Quantity
having SUM(Quantity*od.UnitPrice) = p.UnitPrice
/*
select OrderID, od.UnitPrice, p.UnitPrice, Quantity
from [Order Details] od join Products p on od.ProductID=p.ProductID
where od.UnitPrice = p.UnitPrice
group by OrderID, od.UnitPrice, p.UnitPrice, Quantity
*/

/*6. Danh sách các mặt hàng bán trong ngày thứ 7 và chủ nhật của tháng 12
năm 1996, thông tin gồm ProductID, ProductName, OrderID, OrderDate,
CustomerID, Unitprice, Quantity, ToTal= Quantity*UnitPrice. Được sắp
xếp theo ProductID, cùng ProductID thì sắp xếp theo Quantity giảm dần.*/
select p.ProductID, ProductName, od.OrderID, OrderDate, CustomerID, od.UnitPrice, Quantity, sum(Quantity*od.UnitPrice) as Total
from Products p join [Order Details] od on p.ProductID=od.ProductID
				join Orders o on o.OrderID=od.OrderID
where (DATEPART(WEEKDAY, OrderDate) = 2 or DATEPART(WEEKDAY, OrderDate) = 3) and YEAR(OrderDate)=1996
		--mặt hàng bán trong ngày thứ 2 và thứ 3
group by p.ProductID, ProductName, od.OrderID, OrderDate, CustomerID, od.UnitPrice, Quantity
order by ProductID, Quantity desc

/*7. Liệt kê danh sách các nhân viên đã lập hóa đơn trong tháng 7 của năm
1996. Thông tin gồm : EmployeeID, EmployeeName, OrderID,
Orderdate.*/
select o.EmployeeID, FirstName + ' ' + LastName as EmployeeName, OrderID, OrderDate
from Orders o join Employees e on o.EmployeeID=e.EmployeeID
where month(OrderDate)=7 and year(OrderDate)=1996

/*8. Liệt kê danh sách các hóa đơn do nhân viên có Lastname là ‘Fuller’ lập.
Thông tin gồm : OrderID, Orderdate, ProductID, Quantity, Unitprice.*/
select od.OrderID, OrderDate, ProductID, Quantity, UnitPrice
from [Order Details] od join Orders o on od.OrderID=o.OrderID
						join Employees e on e.EmployeeID=o.EmployeeID
where LastName like 'Fuller'

/*9. Liệt kê chi tiết bán hàng của mỗi nhân viên theo từng hóa đơn trong năm
1996. Thông tin gồm: EmployeeID, EmployName, OrderID, Orderdate,
ProductID, quantity, unitprice, ToTalLine=quantity*unitprice.*/
select o.EmployeeID, FirstName + ' ' + LastName as EmployeeName, o.OrderID, OrderDate, ProductID, 
Quantity, UnitPrice, sum(Quantity*od.UnitPrice) as TotalLine
from [Order Details] od join Orders o on od.OrderID=o.OrderID
						join Employees e on e.EmployeeID=o.EmployeeID
where year(OrderDate)=1996
group by o.EmployeeID, FirstName, LastName, o.OrderID, OrderDate, ProductID, Quantity, UnitPrice

--10.Danh sách các đơn hàng sẽ được giao trong các thứ 7 của tháng 12 năm 1996.
select p.ProductID, ProductName, od.OrderID, ShippedDate
from Products p join [Order Details] od on p.ProductID=od.ProductID
				join Orders o on o.OrderID=od.OrderID
where DATEPART(WEEKDAY, ShippedDate)=2 and month(ShippedDate)=12 and year(ShippedDate)=1996
--Giao trong thứ 2

--11.Liệt kê danh sách các nhân viên chưa lập hóa đơn (dùng LEFT JOIN/RIGHT JOIN).
select *from Orders o left join Employees e on o.EmployeeID=e.EmployeeID
--where ShippedDate is null

--12.Liệt kê danh sách các sản phẩm chưa bán được (dùng LEFT JOIN/RIGHT JOIN).
select *from Orders o left join [Order Details] od on o.OrderID=od.OrderID

--13.Liệt kê danh sách các khách hàng chưa mua hàng lần nào (dùng LEFT JOIN/RIGHT JOIN).
select *from Orders o left join Customers c on o.CustomerID=c.CustomerID

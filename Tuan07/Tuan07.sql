--Đặng Lê Hữu Tiến

/*1. Liệt kê danh sách các orders ứng với tổng tiền của từng hóa đơn. Thông
tin bao gồm OrderID, OrderDate, Total. Trong đó Total là Sum của
Quantity * Unitprice, kết nhóm theo OrderID.*/
select od.OrderID, OrderDate, sum(Quantity*UnitPrice) as total
from [Order Details] od join Orders o on od.OrderID=o.OrderID
group by od.OrderID, OrderDate

/*2. Liệt kê danh sách các orders mà địa chỉ nhận hàng ở thành phố ‘Madrid’
(Shipcity). Thông tin bao gồm OrderID, OrderDate, Total. Trong đó
Total là tổng trị giá hóa đơn, kết nhóm theo OrderID.*/
select od.OrderID, OrderDate,ShipCity, sum(Quantity*UnitPrice) as total
from [Order Details] od join Orders o on od.OrderID=o.OrderID
where ShipCity like 'Madrid'
group by od.OrderID, OrderDate,ShipCity

/*3. Sử dụng 2 table [Orders] và [Order Details], hãy viết các truy vấn thống
kê tổng trị giá các hóa đơn được xuất bán theo :
- Tháng …
- Năm …
- CustomerID …
- EmployeeID …
- ProductID …*/
select month(OrderDate) as month ,YEAR(OrderDate) as year, CustomerID, EmployeeID, ProductID, OrderDate
from [Order Details] od join Orders o on od.OrderID=o.OrderID

/*4. Cho biết mỗi Employee đã lập bao nhiêu hóa đơn. Thông tin gồm
EmployeeID, EmployeeName, CountOfOrder. Trong đó CountOfOrder là tổng số hóa đơn của từng employee. 
EmployeeName được ghép từ LastName và FirstName.*/
select e.EmployeeID, FirstName+' '+LastName as EmployeeName, COUNT(od.OrderID) as CountOfOrder
from Employees e join Orders o on e.EmployeeID=o.EmployeeID
				join [Order Details] od on od.OrderID=o.OrderID
group by e.EmployeeID, FirstName, LastName

/*5. Cho biết mỗi Employee đã lập được bao nhiêu hóa đơn, ứng với tổng
tiền các hóa đơn tương ứng. Thông tin gồm EmployeeID,
EmployeeName, CountOfOrder , Total.*/
select FirstName+' '+LastName as EmployeeName, COUNT(od.OrderID) as CountOfOrder, sum(Quantity*UnitPrice) as Total
from Employees e join Orders o on e.EmployeeID=o.EmployeeID
				join [Order Details] od on od.OrderID=o.OrderID
group by FirstName, LastName

/*6. Liệt kê bảng lương của mỗi Employee theo từng tháng trong năm 1996
gồm EmployeeID, EmployName, Month_Salary, Salary =
sum(quantity*unitprice)*10%. Được sắp xếp theo Month_Salary, cùmg
Month_Salary thì sắp xếp theo Salary giảm dần.*/
select o.OrderID, FirstName+' '+LastName as EmployeeName, MONTH(OrderDate) as Month_Salary, sum(Quantity*UnitPrice)*0.1 as Salary
from Employees e join Orders o on e.EmployeeID=o.EmployeeID
				join [Order Details] od on od.OrderID=o.OrderID
group by o.OrderID, FirstName, LastName, OrderDate
order by Month_Salary, Salary desc

/*7. Tính tổng số hóa đơn và tổng tiền các hóa đơn của mỗi nhân viên đã bán
trong tháng 3/1997, có tổng tiền >4000. Thông tin gồm EmployeeID,
LastName, FirstName, CountofOrder, Total.*/
select e.EmployeeID, LastName, FirstName, count(o.OrderID) as CountofOrder, sum(Quantity*UnitPrice) as Total
from Employees e join Orders o on e.EmployeeID=o.EmployeeID
				join [Order Details] od on od.OrderID=o.OrderID
where month(OrderDate)=3 and year(OrderDate)=1997
group by e.EmployeeID, LastName, FirstName
having sum(Quantity*UnitPrice)>4000
/*8. Liệt kê danh sách các customer ứng với tổng số hoá đơn, tổng tiền các
hoá đơn, mà các hóa đơn được lập từ 31/12/1996 đến 1/1/1998 và tổng
tiền các hóa đơn >20000. Thông tin được sắp xếp theo CustomerID,
cùng mã thì sắp xếp theo tổng tiền giảm dần.*/
select o.OrderID, FirstName+' '+LastName as EmployeeName, count(o.OrderID) as CountofOrder,
sum(Quantity*UnitPrice) as Total, OrderDate, CustomerID
from Employees e join Orders o on e.EmployeeID=o.EmployeeID
				join [Order Details] od on od.OrderID=o.OrderID
where YEAR(OrderDate)>1996 and YEAR(OrderDate)<1998
group by o.OrderID, FirstName, LastName, OrderDate, OrderDate, CustomerID
having sum(Quantity*UnitPrice)>2000
order by CustomerID, Total desc

/*9. Liệt kê danh sách các customer ứng với tổng tiền của các hóa đơn ở từng
tháng. Thông tin bao gồm CustomerID, CompanyName, Month_Year,
Total. Trong đó Month_year là tháng và năm lập hóa đơn, Total là tổng
của Unitprice* Quantity.*/
select c.CustomerID, CompanyName, DATENAME(m,OrderDate)+ '-' + cast(DATEPART(yyyy,OrderDate) as varchar) as Month_year, sum(Quantity*UnitPrice) as Total
from [Order Details] od join Orders o on od.OrderID=o.OrderID
						join Customers c on c.CustomerID=o.CustomerID
group by c.CustomerID, CompanyName, OrderDate 

/*10.Liệt kê danh sách các nhóm hàng (category) có tổng số lượng tồn
(UnitsInStock) lớn hơn 300, đơn giá trung bình nhỏ hơn 25. Thông tin
bao gồm CategoryID, CategoryName, Total_UnitsInStock,
Average_Unitprice.*/
select c.CategoryID, CategoryName,Sum(UnitsInStock) as Total_UnitsInStock, AVG(p.UnitPrice) as TB_UnitPrice
from Categories c join Products p on c.CategoryID=p.CategoryID
				join [Order Details] od on od.ProductID=p.ProductID
group by c.CategoryID, CategoryName
having Sum(UnitsInStock) >300 and AVG(p.UnitPrice) <25

/*11.Liệt kê danh sách các nhóm hàng (category) có tổng số mặt hàng
(product) nhỏ hớn 10. Thông tin kết quả bao gồm CategoryID,
CategoryName, CountOfProducts. Được sắp xếp theo CategoryName,
cùng CategoryName thì sắp theo CountOfProducts giảm dần.*/
select c.CategoryID, CategoryName, count(p.ProductID) as CountOfProducts
from Categories c join Products p on c.CategoryID=p.CategoryID
group by c.CategoryID, CategoryName
having count(p.ProductID) < 10
order by CategoryName, CountOfProducts desc

/*12.Liệt kê danh sách các Product bán trong quý 1 năm 1998 có tổng số
lượng bán ra >20, thông tin gồm [ProductID], [ProductName],
SumofQuatity*/
select od.ProductID, ProductName, sum(Quantity) as 'SumofQuantity', OrderDate
from [Order Details] od join Products p on od.ProductID=p.ProductID
						join Orders o on o.OrderID=od.OrderID
where year(OrderDate)=1998 and MONTH(OrderDate)>=1 and MONTH(OrderDate)<=3
group by od.ProductID, ProductName, OrderDate
having sum(Quantity) >20

--13.Cho biết Employee nào bán được nhiều tiền nhất trong tháng 7 năm 1997
select top 1 e.EmployeeID, FirstName+' '+LastName as EmployeeName, sum(Quantity*UnitPrice) as Total, OrderDate
from Employees e join Orders o on e.EmployeeID=o.EmployeeID
				join [Order Details] od on od.OrderID=o.OrderID
where month(OrderDate)=7 and year(OrderDate)=1997
group by e.EmployeeID, FirstName, LastName, OrderDate
order by Total desc

--14.Liệt kê danh sách 3 Customer có nhiều đơn hàng nhất của năm 1996.
select top 3 FirstName+' '+LastName as EmployeeName, COUNT(od.OrderID) as CountOfOrder
from Employees e join Orders o on e.EmployeeID=o.EmployeeID
				join [Order Details] od on od.OrderID=o.OrderID
group by FirstName, LastName
order by CountOfOrder desc

--15.Liệt kê danh sách các Products có tổng số lượng lập hóa đơn lớn nhất.
--Thông tin gồm ProductID, ProductName, CountOfOrders
select top 1 od.ProductID,ProductName, count(od.OrderID) as CountofOrder
from [Order Details] od join Products p on od.ProductID=p.ProductID
group by od.ProductID,ProductName
order by CountOfOrder desc
--Đặng Lê Hữu Tiến

/*1. Liệt kê các product có đơn giá bán lớn hơn đơn giá bán trung bình của
các product. Thông tin gồm ProductID, ProductName, Unitprice .*/
select p.ProductID, ProductName, od.Unitprice
from [Order Details] od join Products p on od.ProductID=p.ProductID
where od.UnitPrice > (select avg(UnitPrice) from Products)
order by od.Unitprice

/*2. Liệt kê các product có đơn giá bán lớn hơn đơn giá bán trung bình của
các product có ProductName bắt đầu là ‘N’*/
select p.ProductID, ProductName, od.Unitprice
from [Order Details] od join Products p on od.ProductID=p.ProductID
where od.UnitPrice > (select avg(UnitPrice) from Products ) and ProductName like 'N%'

/*3. Danh sách các products có đơn giá mua lớn hơn đơn giá mua nhỏ nhất
của tất cả các products*/
select distinct p.ProductID, ProductName, p.Unitprice
from [Order Details] od join Products p on od.ProductID=p.ProductID
where p.UnitPrice > (select min(UnitPrice) from Products)

/*4. Cho biết những product có đơn vị tính có chữ ‘box’ và có số lượng bán
lớn hơn số lượng trung bình bán ra.*/
select p.ProductID, ProductName, QuantityPerUnit, sum(od.Quantity)
from [Order Details] od join Products p on od.ProductID=p.ProductID
where QuantityPerUnit like '%box%'
group by p.ProductID, ProductName, QuantityPerUnit
having sum(Quantity) > (select sum(Quantity)/count(distinct ProductID) from [Order Details])

/*5. Cho biết những sản phẩm có tên bắt đầu bằng chữ N và đơn giá bán >
đơn giá bán của (tất cả) những sản phẩm khác*/
select p.ProductID, ProductName, od.Unitprice
from [Order Details] od join Products p on od.ProductID=p.ProductID
where ProductName like 'N%' and od.UnitPrice >all (select UnitPrice from [Order Details])

/*5. Cho biết những sản phẩm có tên bắt đầu bằng ‘T’ và có đơn giá bán lớn
hơn đơn giá bán của (tất cả) những sản phẩm có tên bắt đầu bằng chữ ‘V’.*/
select od.ProductID, ProductName, od.UnitPrice
from [Order Details] od join Products p on od.ProductID=p.ProductID
where ProductName like 'T%' and od.UnitPrice >all (select UnitPrice from [Order Details] where ProductName like 'V%')

/*6. Cho biết những sản phẩm thuộc nhóm hàng có mã 4 (categoryID) và có
tổng số lượng bán lớn hơn (tất cả) tổng số lượng của những sản phẩm
không thuộc nhóm hàng mã 4
Lưu ý : Có nhiều phương án thực hiện các truy vấn sau. Hãy đưa ra
phương án sử dụng subquery.*/
select p.ProductID, ProductName, CategoryID, od.UnitPrice, sum(Quantity)
from [Order Details] od join Products p on od.ProductID=p.ProductID
where CategoryID like '4' 
group by p.ProductID, ProductName, CategoryID, od.UnitPrice
having sum(Quantity) >all (select sum(Quantity) where CategoryID not like '4')

/*7. Danh sách các products đã có khách hàng mua hàng (tức là ProductID có
trong [Order Details]). Thông tin bao gồm ProductID, ProductName,
Unitprice*/
select  ProductID, ProductName, Unitprice
from Products p
where exists (select *from [Order Details] od where od.ProductID=p.ProductID)

--8. Danh sách các hóa đơn của những khách hàng ở thành phố LonDon và Madrid.
select *
from Orders o 
where exists (select *from Customers c where o.CustomerID=c.CustomerID and 
(city like 'LonDon' or city like 'Madrid'))

/*9. Liệt kê các sản phẩm có trên 20 đơn hàng trong quí 3 năm 1997, thông
tin gồm ProductID, ProductName.*/
select p.ProductID, ProductName, COUNT(od.OrderID) as count
from [Order Details] od join Products p on od.ProductID=p.ProductID
					join Orders o on o.OrderID=od.OrderID
where exists (select OrderDate from Orders o where YEAR(OrderDate)=1997 and Datepart(Q, OrderDate)=3)
group by p.ProductID, ProductName
having COUNT(od.OrderID)>20

--10.Liệt kê danh sách các sản phẩm chưa bán được trong tháng 6 năm 1996
select *
from [Order Details] od
where not exists (select ProductID from Orders o where od.OrderID=o.OrderID and 
(MONTH(OrderDate)=6 and year(OrderDate)=1996))

--11.Liệt kê danh sách các Employes không lập hóa đơn vào ngày hôm nay
select *from Employees e
where not exists (select EmployeeID from Orders o where e.EmployeeID=o.EmployeeID 
and OrderDate=GETDATE())

--12.Liệt kê danh sách các Customers chưa mua hàng trong năm 1997
select *
from Customers c
where not exists (select CustomerID from Orders o where c.CustomerID=o.CustomerID and year(OrderDate)=1997)

/*13.Tìm tất cả các Customers mua các sản phẩm có tên bắt đầu bằng chữ T
trong tháng 7 năm 1997*/
/* c.customerid, ProductName 
from Customers c join Orders as o on c.CustomerID=o.CustomerID
join [Order Details] od on od.OrderID=o.OrderID 
join Products p on p.ProductID=od.ProductID 
where productname like 'T%' and month(orderdate)=7 and YEAR(OrderDate)=1997
*/

/*14.Liệt kê danh sách các khách hàng mua các hóa đơn mà các hóa đơn này
chỉ mua những sản phẩm có mã >=3*/
/*select*
from Customers c
where exists (select OrderID from Orders o where c.CustomerID=o.CustomerID and o.OrderID >=3)  
*/

/*15.Tìm các Customer chưa từng lập hóa đơn (viết bằng ba cách: dùng NOT
EXISTS, dùng LEFT JOIN, dùng NOT IN )*/
--Not exists
select *
from Customers c
where not exists (select OrderID from Orders o where c.CustomerID=o.CustomerID)
--left join
select *
from Customers c left join Orders o on c.CustomerID=o.CustomerID
where o.CustomerID is Null
-- not in
select *
from Customers
where CustomerID not in (select CustomerID from Orders)

/*16.Cho biết sản phẩm nào có đơn giá bán cao nhất trong số những sản phẩm
có đơn vị tính có chứa chữ ‘box’ .*/
select ProductID, max(UnitPrice)
from [Order Details] od
group by ProductID, UnitPrice
having UnitPrice > (select max(UnitPrice) from Products p where QuantityPerUnit like '%box%')

--17. Danh sách các Products có tổng số lượng (Quantity) bán được lớn nhất.
select p.ProductID, ProductName, Quantity
from Products p join [Order Details] od on p.ProductID=od.ProductID
where Quantity >= all(select Quantity from [Order Details])

/*18.Bạn hãy mô tả kết quả của các câu truy vấn sau ?
Select ProductID, ProductName, UnitPrice 
From [Products]
Where Unitprice>ALL (Select Unitprice from [Products] where
ProductName like 'N%')
-> Liệt kê những sản phẩm có đơn giá mua > đơn giá mua của
(tất cả) những sản phẩm khác có tên bắt đầu bằng chữ N

Select ProductId, ProductName, UnitPrice 
from [Products]
Where Unitprice>ANY (Select Unitprice from [Products] where ProductName like 'N%') 
-> Liệt kê những sản phẩm có đơn giá mua > đơn giá mua của
(ít nhất là 1) những sản phẩm khác có tên bắt đầu bằng chữ N 

Select ProductId, ProductName, UnitPrice from [Products]
Where Unitprice=ANY (Select Unitprice from [Products] where
ProductName like 'N%')
-> Liệt kê những sản phẩm có đơn giá mua = đơn giá mua của
(ít nhất là 1) những sản phẩm khác có tên bắt đầu bằng chữ N

Select ProductId, ProductName, UnitPrice 
from [Products]
Where ProductName like 'N%' and
Unitprice>=ALL (Select Unitprice from [Products] where
ProductName like 'N%')
-> Liệt kê những sản phẩm có tên bắt đầu bằng chữ N và đơn giá mua > đơn giá mua của
(tất cả) những sản phẩm khác có tên bắt đầu bằng chữ N
*/

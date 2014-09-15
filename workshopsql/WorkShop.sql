-- Q 1-a
select * from shippers

-- Q 1-b
select * from shippers order by companyname

-- Q 2-a
select firstname, lastname, title, birthdate, city from employees 

-- Q 2-b
select title from employees

-- Q 3
select * from orders where orderdate='1997-05-19'

-- Q 4
select * from customers where city in ('London','Madrid')

-- Q 5
select CustomerID, ContactName from customers where country='UK' order by contactname

-- Q 6
select orderid, orderdate from orders where customerid='Hanar'

-- Q 7
select titleofcourtesy+' '+firstname+' '+lastname from employees order by lastname

-- Q 8
select orderid, orderdate from orders where customerid in (select customerid from customers where companyname='Maison Dewey')

-- Q 9
select * from products where productname like '%Lager%'

-- Q 10
select customerid, contactname from customers where customerid not in(select customerid from orders)

-- Q 11-a
select * from Products where categoryid in
(select categoryid from categories where categoryname in ('Beverages', 'Condiments')) order by productname

-- Q 11-b
select * from products p left join
categories c on p.categoryid=c.categoryid where categoryname in ('Beverages', 'Condiments') order by productname

-- Q 12-a
select count(*) from employees

-- Q 12-b
select count(*) from employees where country='USA'

-- Q 13
select cus.companyname, count(ord.customerid) as nooforders from orders ord 
left join 
customers cus on ord.customerid=cus.customerid group by cus.CompanyName

-- Q 14-a
select cus.CompanyName as CompanyName, count(ord.customerid) as nooforders from customers cus
join
orders ord on cus.customerid=ord.customerid  group by cus.CompanyName having count(ord.customerid)>10 order by count(ord.customerid) desc

-- Q 14-b
select count(ord.orderid) as nooforders,cus.CompanyName from orders ord left join
customers cus on ord.customerid=cus.customerid where cus.customerid='BONAP' group by cus.CompanyName

-- Q 14-c
select count(cus.customerid) as nooforders, cus.companyname from orders ord left join 
customers cus on ord.customerid=cus.customerid group by cus.CompanyName 
having count(cus.customerid)>(select count(cus.customerid) from orders ord left join
customers cus on ord.customerid=cus.customerid where cus.customerid='BONAP' group by cus.companyname) 
order by count(cus.customerid) desc

-- Q 15
select * from [order details] od left join
orders o on od.orderid=o.orderid left join
shippers sh on sh.shipperid=o.shipvia left join
customers cus on cus.customerid=o.customerid
where cus.contacttitle='Sales Representative' and sh.companyname='United Package'

-- Q 16 
select emp.lastname, mgr.lastname from employees emp, employees mgr where emp.employeeid=mgr.reportsto

/*select emp.TitleOfCourtesy+' '+emp.firstname+' '+emp.LastName,mgr.TitleOfCourtesy+' '+mgr.firstname+' '+mgr.LastName from employees emp left outer join
employees mgr on emp.employeeid=mgr.reportsto*/

-- Q 17
select top 5* from products p left outer join
[order details] od on p.productid=od.productid 
order by od.discount desc

-- Q 18
select * from customers where city not in
(select city from suppliers)

-- Q 19
select city from customers
union
select city from suppliers

-- Q 20-a
select companyname, contactname, address, phone from customers where contactname is not null
union
select companyname, contactname, address, phone from suppliers

-- Q 20-b
select companyname, address, phone from customers where contactname is not null
union
select companyname, address, phone from suppliers
union
select companyname, null as address, phone from shippers

-- Q 21
select od.orderid, sum(od.unitprice*od.quantity) as Amount from [order details] od
group by od.orderid having sum(od.unitprice*od.quantity)>10000

-- Q 22
select od.orderid, o.customerid, sum(od.unitprice*od.quantity) as Amount from [order details] od inner join
orders o on od.orderid=o.orderid
group by od.orderid, o.customerid having sum(od.unitprice*od.quantity)>10000

-- Q 23
select od.orderid, cus.customerid, cus.companyname, sum(od.unitprice*od.quantity) as Amount from [order details] od inner join
orders o on od.orderid=o.orderid inner join
customers cus on cus.customerid=o.customerid
group by od.orderid, cus.customerid, cus.companyname having sum(od.unitprice*od.quantity)>10000

-- Q 24
select o.customerid,sum(od.unitprice*od.quantity) as Amount from orders o join
[order details] od on o.orderid=od.orderid
group by o.customerid

-- Q 25
select sum(od.unitprice*od.quantity)/count(distinct(o.customerid)),count(distinct(o.customerid)) from orders o join
[order details] od on o.orderid=od.orderid

/*select o.customerid, count(o.customerid) as NoofCustomer, sum(od.unitprice*od.quantity) as TotalAmount, 
sum(od.unitprice*od.quantity)/count(o.customerid) as AverageAmount from orders o join
[order details] od on o.orderid=od.orderid
group by o.customerid*/

-- Q 26
select cus.customerid, cus.companyname from orders o join
[order details] od on o.orderid=od.orderid join
customers cus on cus.customerid=o.customerid
group by cus.customerid, cus.companyname 
having sum(od.unitprice*od.quantity)>
(select sum(od.unitprice*od.quantity)/count(distinct(o.customerid)) from orders o join
[order details] od on o.orderid=od.orderid)

-- Q 27
select cus.customerid, sum(od.unitprice*od.quantity) from orders o, customers cus, [order details] od
where o.customerid=cus.customerid and o.orderid=od.orderid and year(o.orderdate)='1997'
group by cus.customerid
/* Thống kê trong năm 2013, ở mỗi khu vực bán được tổng cộng bao nhiêu hóa đơn, trong đó hóa đơn
onl chiếm bao nhiêu phần trăm, và hóa đơn offline chiếm bao nhiêu phần trăm.
*/
Select TerritoryID
	  ,COUNT(*) Total_Orders
	  ,FORMAT(SUM(CASE WHEN OnlineOrderFlag = 1 THEN 1 ELSE 0 END) *1.0 / COUNT(*),'p') Perc_Online
	  ,FORMAT(SUM(CASE WHEN OnlineorderFlag = 0 THEN 1 ELSE 0 END)*1.0 / COUNT(*),'p') Perc_Offline
From Sales.SalesOrderHeader
Where YEAR(OrderDate) = 2013 
Group By TerritoryID
Order By TerritoryID


/* Thống kê trong năm 2013, có bao nhiêu khách hàng mua 3 hóa đơn trở nên 
*/
Select CustomerID
	  ,COUNT(*) cnt
	  Into #C1
From Sales.SalesOrderHeader
Where YEAR(OrderDate) = 2013 
Group By CustomerID
Having COUNT(*) >3 
/* Những khách hàng mua cuối cùng đến thời điểm hiện tại vẫn nằm trong diện theo dõi  */
Select CustomerID Ma_KH
	  ,MAX(Orderdate) Ngay_mua_gan_nhat
	  ,DATEDIFF(Month, MAX(Orderdate), '2014-02-12') So_thang
	  into #C2
From Sales.SalesOrderHeader
Where YEAR(OrderDate) = 2013
Group By CustomerID

Select * From #C2
Where So_thang <7
/* Những khách hàng mua 3 hóa đơn trở nên và vẫn còn nằm trong diện theo dõi */
Select * from #C1 a 
Inner Join #C2 b On a.CustomerID = b.Ma_KH


/* Hãy tìm doanh thu thực tế mà nhân viên bán được trong một quý, so sánh với chỉ tiêu ban đầu rồi tính tỉ lệ. 
*/
Select BusinessEntityID Ma_NV
	  ,Convert(varchar,QuotaDate,101) Ngay
	  ,SalesQuota Chi_Tieu
	  ,SUM (Subtotal) doanh_thu_thuc_te
	  ,FORMAT(SUM (Subtotal)*1.0/SalesQuota,'p') ti_le
From sales.SalesPersonQuotaHistory History
Left join Sales.SalesOrderHeader Header On History.BusinessEntityID = Header.SalesPersonID
Where Header.OrderDate > History.QuotaDate And Header.OrderDate < DATEADD(MONTH,3, History.QuotaDate) and YEAR(OrderDate) =2013 and YEAR(QuotaDate) =2013
Group By BusinessEntityID, QuotaDate, SalesQuota
Order By QuotaDate 



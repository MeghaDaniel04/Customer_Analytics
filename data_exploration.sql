use EcommerceCustomerAnalytics;

--- get column names and its data type --
SELECT 
    c.name AS ColumnName,         
    t.name AS DataType            
FROM sys.columns c
JOIN sys.types t ON c.user_type_id = t.user_type_id
WHERE c.object_id = OBJECT_ID('RetailCombined');

-- check for missing invoice_id --
select Invoice , StockCode , Customer_ID 
from dbo.RetailCombined
where Invoice is null;

-- check for missing customer_id --
select count(*) as missing_customerId
from dbo.RetailCombined where Customer_ID is null;

-- check for negative & zero quantity --
select count(*) as negative_quantity
from dbo.RetailCombined where Quantity <= 0;


-- check for exact duplicate rows --
select Invoice , StockCode , Description ,Quantity,InvoieDate,Price,Customer_ID,Country,
COUNT(*) as ExactDupeCount
from dbo.RetailCombined
group by Invoice , StockCode , Description ,Quantity,InvoieDate,Price,Customer_ID,Country
having count(*) > 1;

-- deduplicate and produce the final cleaned table --
with Deduped as
(
select * , ROW_NUMBER() over (partition by Invoice , StockCode , Description ,Quantity,InvoieDate,Price,Customer_ID,Country
                               order by (select null)
                               ) as RowNum
from dbo.RetailCombined
)

select Invoice , StockCode , Description ,Quantity,InvoieDate,Price,Customer_ID,Country
into dbo.RetailCleaned
from Deduped
where RowNum = 1;

select count(*) from dbo.RetailCombined
select count(*) from dbo.RetailCleaned

select * from dbo.RetailCleaned

SELECT *,
       COUNT(*) OVER() AS invalid_count
FROM dbo.RetailCleaned
WHERE Price <= 0;
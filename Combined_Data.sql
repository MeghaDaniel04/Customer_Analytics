create database EcommerceCustomerAnalytics;

use EcommerceCustomerAnalytics;

-- check row count after import --
select count(*) as total_rows1 from [year 2009 - 2010];
select count(*) as total_rows2 from [year 2010 - 2011];


--- combine both years and convert types safely --
select Invoice , StockCode , Description, Quantity , Customer_ID, Country , '2009 - 2010' as SourceSheet ,
coalesce(TRY_CONVERT(datetime2, InvoiceDate, 120),TRY_CONVERT(datetime2, InvoiceDate, 105)) as InvoieDate,
try_convert(decimal(10,2),Price) as Price
into dbo.RetailCombined
from dbo.[year 2009 - 2010]

union all

select Invoice , StockCode , Description, Quantity , Customer_ID, Country , '2010 - 2011' as SourceSheet ,
coalesce(TRY_CONVERT(datetime2, InvoiceDate, 120),TRY_CONVERT(datetime2, InvoiceDate, 105)) as InvoieDate,
try_convert(decimal(10,2),Price) as Price
from dbo.[year 2010 - 2011]


select count(*) as total_rows from RetailCombined;
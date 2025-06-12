-- =============================================
-- OLAP QUERIES - Analytical Insights
-- Database: giftcards_dwh
-- =============================================

-- 1. Sales performance by year and month
SELECT 
    d."Year",
    d."Month",
    COUNT(*) as SalesCount,
    SUM(fs."Amount") AS TotalSales,
    AVG(fs."Amount") AS AverageSale,
    ROUND(SUM(fs."Amount") / NULLIF(LAG(SUM(fs."Amount")) OVER (ORDER BY d."Year", d."Month"), 0), 2) AS GrowthRate
FROM "FactCardSales" fs
JOIN "DimDate" d ON fs."DateSK" = d."DateSK"
GROUP BY d."Year", d."Month"
ORDER BY d."Year", d."Month";

-- 2. Merchant category performance analysis
SELECT 
    c."CategoryName",
    COUNT(*) as UsageCount,
    SUM(ABS(fu."Amount")) AS TotalUsage,
    AVG(ABS(fu."Amount")) AS AverageUsage,
    COUNT(DISTINCT fu."UserSK") AS UniqueUsers,
    COUNT(DISTINCT fu."CardSK") AS UniqueCards
FROM "FactCardUsage" fu
JOIN "DimMerchant" m ON fu."MerchantSK" = m."MerchantSK"
JOIN "DimMerchantCategory" c ON m."CategoryID" = c."CategoryID"
GROUP BY c."CategoryID", c."CategoryName"
ORDER BY TotalUsage DESC;

-- 3. Top users by usage behavior with customer segmentation
SELECT 
    u."UserID",
    COUNT(*) as TransactionCount,
    SUM(ABS(fu."Amount")) AS TotalUsage,
    AVG(ABS(fu."Amount")) AS AverageTransaction,
    COUNT(DISTINCT fu."CardSK") AS CardsUsed,
    COUNT(DISTINCT fu."MerchantSK") AS MerchantsVisited,
    CASE 
        WHEN SUM(ABS(fu."Amount")) > 1000 THEN 'High Value'
        WHEN SUM(ABS(fu."Amount")) > 500 THEN 'Medium Value'
        ELSE 'Low Value'
    END as CustomerSegment
FROM "FactCardUsage" fu
JOIN "DimUser" u ON fu."UserSK" = u."UserSK"
WHERE u."IsCurrent" = TRUE
GROUP BY u."UserID"
ORDER BY TotalUsage DESC
LIMIT 20;
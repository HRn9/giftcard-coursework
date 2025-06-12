-- =============================================
-- OLTP QUERIES - Operational Insights
-- Database: giftcards_oltp
-- =============================================

-- 1. Top 10 spenders with total amount spent
SELECT 
    u."FirstName", 
    u."LastName", 
    u."Email",
    COUNT(DISTINCT g."CardID") as CardsOwned,
    SUM(ABS(t."Amount")) AS TotalSpent,
    COUNT(t."TransactionID") as TransactionCount
FROM "Users" u
JOIN "GiftCards" g ON u."UserID" = g."PurchasedByUserID"
JOIN "Transactions" t ON g."CardID" = t."CardID"
WHERE t."TransactionTypeID" = 2 AND u."IsActive" = TRUE
GROUP BY u."UserID", u."FirstName", u."LastName", u."Email"
ORDER BY TotalSpent DESC
LIMIT 10;

-- 2. Active cards with remaining balance analysis
SELECT 
    g."CardNumber",
    gt."TypeName" as CardType,
    g."InitialAmount",
    (g."InitialAmount" + COALESCE(SUM(t."Amount"), 0)) as CurrentBalance,
    g."ActivationDate",
    g."ExpiryDate",
    CASE 
        WHEN (g."InitialAmount" + COALESCE(SUM(t."Amount"), 0)) > 0 THEN 'Has Balance'
        ELSE 'Empty'
    END as Status
FROM "GiftCards" g
LEFT JOIN "Transactions" t ON g."CardID" = t."CardID"
JOIN "GiftCardTypes" gt ON g."CardTypeID" = gt."CardTypeID"
WHERE g."IsActive" = TRUE AND g."IsBlocked" = FALSE
GROUP BY g."CardID", g."CardNumber", gt."TypeName", g."InitialAmount", g."ActivationDate", g."ExpiryDate"
HAVING (g."InitialAmount" + COALESCE(SUM(t."Amount"), 0)) > 0
ORDER BY CurrentBalance DESC;

-- 3. Merchant category usage analysis
SELECT 
    mc."CategoryName",
    COUNT(*) AS TransactionCount,
    SUM(ABS(t."Amount")) AS TotalVolume,
    AVG(ABS(t."Amount")) AS AverageTransaction,
    COUNT(DISTINCT t."CardID") AS UniqueCardsUsed,
    COUNT(DISTINCT m."MerchantID") AS MerchantCount
FROM "Transactions" t
JOIN "Merchants" m ON t."MerchantID" = m."MerchantID"
JOIN "MerchantCategories" mc ON m."CategoryID" = mc."CategoryID"
WHERE t."TransactionTypeID" = 2
GROUP BY mc."CategoryID", mc."CategoryName"
ORDER BY TotalVolume DESC;
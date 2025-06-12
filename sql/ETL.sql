-- =============================================================
-- ETL.sql - Extract, Transform, Load from OLTP to OLAP schema
-- 🔒 NOTE: All dblink connections use password=1.
-- If your PostgreSQL password is different, replace it in each dblink call below.
-- =============================================================

-- Enable dblink extension if not already enabled
CREATE EXTENSION IF NOT EXISTS dblink;

-- ============================
-- DimDate (based on activation and transaction dates)
-- ============================
INSERT INTO "DimDate" ("DateSK", "FullDate", "Year", "Month", "Day")
SELECT DISTINCT
    EXTRACT(YEAR FROM d)::INT * 10000 +
    EXTRACT(MONTH FROM d)::INT * 100 +
    EXTRACT(DAY FROM d)::INT AS "DateSK",
    d,
    EXTRACT(YEAR FROM d)::INT,
    EXTRACT(MONTH FROM d)::INT,
    EXTRACT(DAY FROM d)::INT
FROM (
    SELECT "ActivationDate" AS d FROM dblink('dbname=giftcards_oltp user=postgres password=1',
        'SELECT "ActivationDate" FROM "GiftCards"')
        AS t("ActivationDate" date)
    UNION
    SELECT "TransactionDate" AS d FROM dblink('dbname=giftcards_oltp user=postgres password=1',
        'SELECT "TransactionDate" FROM "Transactions"')
        AS t("TransactionDate" date)
) AS all_dates
WHERE d IS NOT NULL
AND NOT EXISTS (
    SELECT 1 FROM "DimDate" dd 
    WHERE dd."DateSK" = EXTRACT(YEAR FROM d)::INT * 10000 +
    EXTRACT(MONTH FROM d)::INT * 100 +
    EXTRACT(DAY FROM d)::INT
);

-- ============================
-- DimUser
-- ============================
INSERT INTO "DimUser" ("UserID", "FirstName", "IsCurrent", "EffectiveFrom", "EffectiveTo")
SELECT * FROM dblink('dbname=giftcards_oltp user=postgres password=1',
    'SELECT "UserID", "FirstName", TRUE, CURRENT_DATE, ''9999-12-31'' FROM "Users"')
    AS t("UserID" int, "FirstName" varchar, "IsCurrent" boolean, "EffectiveFrom" date, "EffectiveTo" date)
WHERE NOT EXISTS (
    SELECT 1 FROM "DimUser" du WHERE du."UserID" = t."UserID" AND du."IsCurrent" = TRUE
);

-- ============================
-- DimGiftCard
-- ============================
INSERT INTO "DimGiftCard" ("CardID", "CardNumber", "CardTypeID", "IsCurrent", "EffectiveFrom", "EffectiveTo")
SELECT * FROM dblink('dbname=giftcards_oltp user=postgres password=1',
    'SELECT "CardID", "CardNumber", "CardTypeID", TRUE, CURRENT_DATE, ''9999-12-31'' FROM "GiftCards"')
    AS t("CardID" int, "CardNumber" varchar, "CardTypeID" int, "IsCurrent" boolean, "EffectiveFrom" date, "EffectiveTo" date)
WHERE NOT EXISTS (
    SELECT 1 FROM "DimGiftCard" dg WHERE dg."CardID" = t."CardID" AND dg."IsCurrent" = TRUE
);

-- ============================
-- DimMerchantCategory
-- ============================
INSERT INTO "DimMerchantCategory" ("CategoryID", "CategoryName")
SELECT * FROM dblink('dbname=giftcards_oltp user=postgres password=1',
    'SELECT DISTINCT "CategoryID", "CategoryName" FROM "MerchantCategories"')
    AS t("CategoryID" int, "CategoryName" varchar)
WHERE NOT EXISTS (
    SELECT 1 FROM "DimMerchantCategory" dmc WHERE dmc."CategoryID" = t."CategoryID"
);

-- ============================
-- DimMerchant
-- ============================
INSERT INTO "DimMerchant" ("MerchantID", "MerchantName", "CategoryID")
SELECT * FROM dblink('dbname=giftcards_oltp user=postgres password=1',
    'SELECT "MerchantID", "MerchantName", "CategoryID" FROM "Merchants"')
    AS t("MerchantID" int, "MerchantName" varchar, "CategoryID" int)
WHERE NOT EXISTS (
    SELECT 1 FROM "DimMerchant" dm WHERE dm."MerchantID" = t."MerchantID"
);

-- ============================
-- DimPromotion
-- ============================
INSERT INTO "DimPromotion" ("PromotionID", "Title", "BonusPercent")
SELECT * FROM dblink('dbname=giftcards_oltp user=postgres password=1',
    'SELECT "PromotionID", "Title", "BonusPercent" FROM "Promotions"')
    AS t("PromotionID" int, "Title" varchar, "BonusPercent" int)
WHERE NOT EXISTS (
    SELECT 1 FROM "DimPromotion" dp WHERE dp."PromotionID" = t."PromotionID"
);

-- ============================
-- FactCardSales
-- ============================
INSERT INTO "FactCardSales" ("UserSK", "CardSK", "DateSK", "Amount")
SELECT
    du."UserSK",
    dg."CardSK",
    EXTRACT(YEAR FROM g."ActivationDate")::INT * 10000 +
    EXTRACT(MONTH FROM g."ActivationDate")::INT * 100 +
    EXTRACT(DAY FROM g."ActivationDate")::INT,
    g."InitialAmount"
FROM dblink('dbname=giftcards_oltp user=postgres password=1',
    'SELECT "CardID", "ActivationDate", "InitialAmount", "PurchasedByUserID" FROM "GiftCards"')
    AS g("CardID" int, "ActivationDate" date, "InitialAmount" numeric, "PurchasedByUserID" int)
JOIN "DimUser" du ON du."UserID" = g."PurchasedByUserID" AND du."IsCurrent" = TRUE
JOIN "DimGiftCard" dg ON dg."CardID" = g."CardID" AND dg."IsCurrent" = TRUE
WHERE NOT EXISTS (
    SELECT 1 FROM "FactCardSales" fcs WHERE fcs."UserSK" = du."UserSK" AND fcs."CardSK" = dg."CardSK"
);

-- ============================
-- FactCardUsage
-- ============================
INSERT INTO "FactCardUsage" ("UserSK", "CardSK", "MerchantSK", "DateSK", "Amount")
SELECT
    du."UserSK",
    dg."CardSK",
    dm."MerchantSK",
    EXTRACT(YEAR FROM t."TransactionDate")::INT * 10000 +
    EXTRACT(MONTH FROM t."TransactionDate")::INT * 100 +
    EXTRACT(DAY FROM t."TransactionDate")::INT,
    t."Amount"
FROM dblink('dbname=giftcards_oltp user=postgres password=1',
    'SELECT "TransactionID", "CardID", "MerchantID", "TransactionDate", "Amount" FROM "Transactions"')
    AS t("TransactionID" int, "CardID" int, "MerchantID" int, "TransactionDate" date, "Amount" numeric)
JOIN dblink('dbname=giftcards_oltp user=postgres password=1',
    'SELECT "CardID", "PurchasedByUserID" FROM "GiftCards"')
    AS g("CardID" int, "PurchasedByUserID" int) ON g."CardID" = t."CardID"
JOIN "DimUser" du ON du."UserID" = g."PurchasedByUserID" AND du."IsCurrent" = TRUE
JOIN "DimGiftCard" dg ON dg."CardID" = g."CardID" AND dg."IsCurrent" = TRUE
JOIN "DimMerchant" dm ON dm."MerchantID" = t."MerchantID"
WHERE NOT EXISTS (
    SELECT 1 FROM "FactCardUsage" fcu WHERE fcu."UserSK" = du."UserSK" AND fcu."CardSK" = dg."CardSK" AND fcu."MerchantSK" = dm."MerchantSK" AND fcu."DateSK" = EXTRACT(YEAR FROM t."TransactionDate")::INT * 10000 + EXTRACT(MONTH FROM t."TransactionDate")::INT * 100 + EXTRACT(DAY FROM t."TransactionDate")::INT
);

-- ============================
-- BridgeUserPromotion (mock logic)
-- ============================
INSERT INTO "BridgeUserPromotion" ("UserSK", "PromotionSK")
SELECT du."UserSK", dp."PromotionSK"
FROM "DimUser" du
JOIN "DimPromotion" dp ON du."UserSK" % 2 = dp."PromotionSK" % 2
WHERE NOT EXISTS (
    SELECT 1 FROM "BridgeUserPromotion" bup
    WHERE bup."UserSK" = du."UserSK" AND bup."PromotionSK" = dp."PromotionSK"
);
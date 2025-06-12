-- OLAP Star Schema: Create dimension and fact tables
-- Run in giftcards_oltp (single-db mode)

CREATE TABLE IF NOT EXISTS "DimUser" (
    "UserSK" SERIAL PRIMARY KEY,
    "UserID" INT,
    "FirstName" VARCHAR(50),
    "IsCurrent" BOOLEAN,
    "EffectiveFrom" DATE,
    "EffectiveTo" DATE
);

CREATE TABLE IF NOT EXISTS "DimGiftCard" (
    "CardSK" SERIAL PRIMARY KEY,
    "CardID" INT,
    "CardNumber" VARCHAR(30),
    "CardTypeID" INT,
    "IsCurrent" BOOLEAN,
    "EffectiveFrom" DATE,
    "EffectiveTo" DATE
);

CREATE TABLE IF NOT EXISTS "DimMerchant" (
    "MerchantSK" SERIAL PRIMARY KEY,
    "MerchantID" INT,
    "MerchantName" VARCHAR(150),
    "CategoryID" INT
);

CREATE TABLE IF NOT EXISTS "DimMerchantCategory" (
    "CategorySK" SERIAL PRIMARY KEY,
    "CategoryID" INT,
    "CategoryName" VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS "DimDate" (
    "DateSK" INT PRIMARY KEY,
    "FullDate" DATE,
    "Year" INT,
    "Month" INT,
    "Day" INT
);

CREATE TABLE IF NOT EXISTS "DimPromotion" (
    "PromotionSK" SERIAL PRIMARY KEY,
    "PromotionID" INT,
    "Title" VARCHAR(150),
    "BonusPercent" INT
);

CREATE TABLE IF NOT EXISTS "FactCardSales" (
    "SaleSK" SERIAL PRIMARY KEY,
    "UserSK" INT REFERENCES "DimUser"("UserSK"),
    "CardSK" INT REFERENCES "DimGiftCard"("CardSK"),
    "DateSK" INT REFERENCES "DimDate"("DateSK"),
    "Amount" NUMERIC(10,2)
);

CREATE TABLE IF NOT EXISTS "FactCardUsage" (
    "UsageSK" SERIAL PRIMARY KEY,
    "UserSK" INT REFERENCES "DimUser"("UserSK"),
    "CardSK" INT REFERENCES "DimGiftCard"("CardSK"),
    "MerchantSK" INT REFERENCES "DimMerchant"("MerchantSK"),
    "DateSK" INT REFERENCES "DimDate"("DateSK"),
    "Amount" NUMERIC(10,2)
);

CREATE TABLE IF NOT EXISTS "BridgeUserPromotion" (
    "UserSK" INT REFERENCES "DimUser"("UserSK"),
    "PromotionSK" INT REFERENCES "DimPromotion"("PromotionSK"),
    PRIMARY KEY ("UserSK", "PromotionSK")
);
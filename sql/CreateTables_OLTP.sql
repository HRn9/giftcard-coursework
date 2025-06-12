CREATE TABLE "Users" (
    "UserID" SERIAL PRIMARY KEY,
    "FirstName" VARCHAR(50),
    "LastName" VARCHAR(50),
    "Email" VARCHAR(100),
    "Phone" VARCHAR(20),
    "IsActive" BOOLEAN
);

CREATE TABLE "GiftCardTypes" (
    "CardTypeID" SERIAL PRIMARY KEY,
    "TypeName" VARCHAR(50)
);

CREATE TABLE "GiftCards" (
    "CardID" SERIAL PRIMARY KEY,
    "CardNumber" VARCHAR(20),
    "CardTypeID" INT REFERENCES "GiftCardTypes"("CardTypeID"),
    "InitialAmount" NUMERIC(10,2),
    "ActivationDate" DATE,
    "ExpiryDate" DATE,
    "PurchasedByUserID" INT REFERENCES "Users"("UserID"),
    "IsActive" BOOLEAN,
    "IsBlocked" BOOLEAN
);

CREATE TABLE "TransactionTypes" (
    "TransactionTypeID" SERIAL PRIMARY KEY,
    "TypeName" VARCHAR(50)
);

CREATE TABLE "MerchantCategories" (
    "CategoryID" SERIAL PRIMARY KEY,
    "CategoryName" VARCHAR(50)
);

CREATE TABLE "Merchants" (
    "MerchantID" SERIAL PRIMARY KEY,
    "MerchantName" VARCHAR(100),
    "CategoryID" INT REFERENCES "MerchantCategories"("CategoryID")
);

CREATE TABLE "Transactions" (
    "TransactionID" SERIAL PRIMARY KEY,
    "CardID" INT REFERENCES "GiftCards"("CardID"),
    "MerchantID" INT REFERENCES "Merchants"("MerchantID"),
    "TransactionTypeID" INT REFERENCES "TransactionTypes"("TransactionTypeID"),
    "TransactionDate" DATE,
    "Amount" NUMERIC(10,2)
);

CREATE TABLE "Promotions" (
    "PromotionID" SERIAL PRIMARY KEY,
    "Title" VARCHAR(100),
    "StartDate" DATE,
    "EndDate" DATE,
    "BonusPercent" INT
);

# 🎁 Gift Card Analytics System - Course Work

## 📋 Project Overview

Complete data analytics solution for gift card system with OLTP database, OLAP data warehouse, ETL processes, SQL queries, and Power BI visualizations.

## 👨‍💻 Author Information
- **Author:** Mark Romanov
- **Group:** 23-HO-6

## 🔗 Repository Information
- **Repository:** https://github.com/HRn9/giftcard-coursework.git

## 🏗️ Project Structure

```
GiftCardCourseWork/
├── data/                              # Source CSV files (8 files)
│   ├── Users.csv                      # User data (102 records)
│   ├── GiftCards.csv                  # Gift card data (182 records)
│   ├── GiftCardTypes.csv              # Card types (7 records)
│   ├── Transactions.csv               # Transaction records (302 records)
│   ├── TransactionTypes.csv           # Transaction types (4 records)
│   ├── Merchants.csv                  # Merchant data (22 records)
│   ├── MerchantCategories.csv         # Merchant categories (7 records)
│   └── Promotions.csv                 # Promotion data (14 records)
│
├── sql/                               # SQL scripts
│   ├── CreateTables_OLTP.sql          # OLTP schema (8 tables)
│   ├── CreateTables_OLAP.sql          # OLAP schema (9 tables)
│   ├── LoadData.psql                  # Data loading script
│   ├── ETL.sql                        # ETL process
│   ├── Queries_oltp.sql               # 3 OLTP queries
│   └── Queries_olap.sql               # 3 OLAP queries
│
├── scripts/                           # Automation scripts
│   └── csv_to_excel.py                # Data export script
│
├── documentation/                     # Documentation
│   ├── screenshots/                   # Screenshots
│   │   ├── all_tables.png             # Database structure
│   │   ├── sql_queries_oltp_results.png # OLTP query results
│   │   ├── sql_queries_olap_results.png # OLAP query results
│   │   └── powerbi_dashboard.png      # Power BI dashboard
│   ├── diagrams/                      # Database diagrams
│   │   ├── oltp.png                   # OLTP schema diagram
│   │   └── olap.png                   # OLAP schema diagram
│   └── reports/                       # Generated reports
│       ├── final_giftcards_db_report.docx # Final report
│       └── powerbi/                   # Power BI files
│           ├── report.pbix            # Power BI report
│           └── GiftCard_Analytics_Export.xlsx # Data source
│
└── README.md                          # This file
```

## 🎯 Course Work Requirements

### ✅ Completed Components

#### 1. OLTP Database (giftcards_oltp)
- **8 tables** in 3NF normalization
- **Tables:** Users, GiftCards, GiftCardTypes, Transactions, TransactionTypes, Merchants, MerchantCategories, Promotions
- **Schema:** `sql/CreateTables_OLTP.sql`
- **Data:** 8 CSV files with real data

#### 2. OLAP Data Warehouse (giftcards_dwh)  
- **9 tables** in star schema
- **2 Fact tables:** FactCardSales, FactCardUsage
- **6 Dimension tables:** DimUser, DimGiftCard, DimMerchant, DimMerchantCategory, DimDate, DimPromotion
- **1 Bridge table:** BridgeUserPromotion
- **SCD Type 2:** Implemented in DimUser and DimGiftCard
- **Schema:** `sql/CreateTables_OLAP.sql`

#### 3. ETL Process
- **Data loading:** `sql/LoadData.psql`
- **Script:** `sql/ETL.sql`
- **Export script:** `scripts/csv_to_excel.py`

#### 4. SQL Queries
- **3 OLTP queries:** `sql/Queries_oltp.sql`
- **3 OLAP queries:** `sql/Queries_olap.sql`

#### 5. Power BI Report
- **File:** `documentation/reports/powerbi/report.pbix`
- **Data source:** `documentation/reports/powerbi/GiftCard_Analytics_Export.xlsx`
- **1 title:** "🎁 Gift Card Analytics Dashboard"
- **2 slicers:** Year, Merchant Category
- **6 visualizations:**
  - 3 KPI cards (Total Sales, Total Usage, Active Cards)
  - 1 Clustered Column Chart (Sales vs Usage by Month)
  - 1 Pie Chart (Usage by Category)
  - 1 Table (Top Spenders)

## 🚀 Quick Setup

### Prerequisites
- PostgreSQL 12+
- Python 3.8+ with pandas, psycopg2, openpyxl
- Power BI Desktop/Web

### Installation
```bash
# 1. Create databases
createdb giftcards_oltp
createdb giftcards_dwh

# 2. Run SQL scripts
psql -d giftcards_oltp -f sql/CreateTables_OLTP.sql
psql -d giftcards_dwh -f sql/CreateTables_OLAP.sql
psql -d giftcards_oltp -f sql/LoadData.psql
psql -d giftcards_dwh -f sql/ETL.sql

# 3. Export data for Power BI
python3 scripts/csv_to_excel.py

# 4. Open Power BI report
# Open documentation/reports/powerbi/report.pbix
```

## 📊 Key Features

### Database Design
- **OLTP:** Normalized for transaction processing (8 tables)
- **OLAP:** Denormalized for analytical queries (9 tables)
- **SCD Type 2:** Historical tracking in dimensions
- **Bridge table:** Many-to-many relationships
- **Star schema:** Optimized for analytical queries

### Power BI Dashboard
- **Interactive filtering** with slicers
- **Cross-filtering** between visualizations
- **KPI metrics** for business insights
- **Professional design** with modern UI

### Data Quality
- **Referential integrity** maintained
- **Data validation** in ETL
- **Historical tracking** capabilities
- **Real data** from 8 CSV files

## 📈 Business Insights

### KPI Metrics
- **Total Sales:** Revenue from gift card sales
- **Total Usage:** Amount spent using gift cards  
- **Active Cards:** Number of active gift cards

### Analytical Insights
- **Sales vs Usage trends** by month
- **Category performance** analysis
- **Top spender identification**
- **Seasonal patterns** in usage

## 📝 Documentation Requirements

### Required Screenshots ✅
1. **Power BI Dashboard** - Complete dashboard view
2. **SQL Query Results** - OLTP and OLAP query outputs
3. **Database Schemas** - OLTP and OLAP structures

### Technical Documentation ✅
- **Implementation details** for each component
- **Database schema** descriptions
- **ETL process** documentation
- **Query analysis** and results

## ✅ TZ Compliance

### Minimum Requirements Met
- ✅ OLTP database with 8+ tables in 3NF
- ✅ OLAP data warehouse with 2+ fact tables
- ✅ SCD Type 2 implementation
- ✅ Bridge table implementation
- ✅ ETL process for data migration
- ✅ 3+ OLTP queries
- ✅ 3+ OLAP queries
- ✅ Power BI report with 2+ slicers
- ✅ 3+ visual components
- ✅ Complete documentation with screenshots

---

**Course Work Project** | **Gift Card Analytics System** | **June 2025**
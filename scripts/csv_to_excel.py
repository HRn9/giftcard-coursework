import pandas as pd
import psycopg2

# Параметры подключения
oltp_conn = {
    'dbname': 'giftcards_oltp',
    'user': 'postgres',
    'password': '1',  # при необходимости поменяй
    'host': 'localhost',
    'port': 5432
}

olap_conn = {
    'dbname': 'giftcards_dwh',
    'user': 'postgres',
    'password': '1',
    'host': 'localhost',
    'port': 5432
}

# Таблицы OLTP и OLAP, которые нужно экспортировать
oltp_tables = [
    'Users', 'GiftCards', 'GiftCardTypes',
    'Transactions', 'TransactionTypes',
    'Merchants', 'MerchantCategories', 'Promotions'
]
olap_tables = [
    'DimUser', 'DimGiftCard', 'DimMerchant',
    'DimMerchantCategory', 'DimDate', 'DimPromotion',
    'FactCardSales', 'FactCardUsage', 'BridgeUserPromotion'
]

# Начало создания Excel
with pd.ExcelWriter("GiftCard_Analytics_Export.xlsx", engine='openpyxl') as writer:
    # Экспорт OLTP
    with psycopg2.connect(**oltp_conn) as conn:
        for tbl in oltp_tables:
            df = pd.read_sql(f'SELECT * FROM "{tbl}"', conn)
            df.to_excel(writer, sheet_name=f'OLTP_{tbl}', index=False)
    # Экспорт OLAP
    with psycopg2.connect(**olap_conn) as conn:
        for tbl in olap_tables:
            df = pd.read_sql(f'SELECT * FROM "{tbl}"', conn)
            df.to_excel(writer, sheet_name=f'OLAP_{tbl}', index=False)

print("✅ Успешно экспортировано: GiftCard_Analytics_Export.xlsx")
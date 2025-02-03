CREATE TABLE IF NOT EXISTS `Rakamin.Final_Table` AS
SELECT
    FT.transaction_id, 
    FT.date, 
    FT.branch_id, 
    KC.branch_name, 
    KC.kota, 
    KC.provinsi, 
    KC.rating AS rating_cabang, 
    FT.customer_name, 
    FT.product_id, 
    P.product_name, 
    FT.price AS actual_price, 
    FT.discount_percentage,

    -- Menentukan persentase gross laba
    CASE
        WHEN FT.price <= 50000 THEN 0.10
        WHEN FT.price > 50000 AND FT.price <= 100000 THEN 0.15
        WHEN FT.price > 100000 AND FT.price <= 300000 THEN 0.20
        WHEN FT.price > 300000 AND FT.price <= 500000 THEN 0.25
        ELSE 0.30
    END AS persentase_gross_laba,

    -- Menghitung Nett Sales
    FT.price - (FT.price * FT.discount_percentage) AS nett_sales,

    -- Menghitung Nett ProFTt
    ((FT.price - (FT.price * FT.discount_percentage)) * 
        CASE 
            WHEN FT.price <= 50000 THEN 0.10 
            WHEN FT.price > 50000 AND FT.price <= 100000 THEN 0.15 
            WHEN FT.price > 100000 AND FT.price <= 300000 THEN 0.20 
            WHEN FT.price > 300000 AND FT.price <= 500000 THEN 0.25 
            ELSE 0.30 
        END
    ) AS nett_profit,

    FT.rating AS rating_transaksi

FROM `Rakamin.Final_Transaction` AS FT

JOIN `Rakamin.Kantor_Cabang` AS KC
ON FT.branch_id = KC.branch_id

JOIN `Rakamin.Product` AS P
ON FT.product_id = P.product_id;

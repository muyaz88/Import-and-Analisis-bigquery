-- Membuat tabel baru untuk analisa
CREATE OR REPLACE TABLE `modular-bot-455205-d3.challenge.analisa` AS
SELECT 
    ft.transaction_id,
    ft.date AS date,  -- Ubah sesuai nama kolom yang benar
    kc.branch_id,
    kc.branch_name,
    kc.kota,
    kc.provinsi
FROM `modular-bot-455205-d3.challenge.final_transacrion` ft
JOIN `modular-bot-455205-d3.challenge.kantor_cabang` kc
ON ft.branch_id = kc.branch_id;

-- Membuat tabel baru untuk analisa
CREATE OR REPLACE TABLE `modular-bot-455205-d3.challenge.analisa` AS
SELECT 
    ft.transaction_id,
    ft.date AS date,  
    kc.branch_id,
    kc.branch_name,
    kc.kota,
    kc.provinsi,
    kc.rating,  -- Penilaian cabang
    ft.customer_name,
    ft.product_id,
    p.product_name,
    ft.price AS actual_price,
    ft.discount_percentage,
    
    -- Menentukan Persentase Gross Laba berdasarkan harga obat
    CASE 
        WHEN ft.price <= 50000 THEN 0.10
        WHEN ft.price > 50000 AND ft.price <= 100000 THEN 0.15
        WHEN ft.price > 100000 AND ft.price <= 300000 THEN 0.20
        WHEN ft.price > 300000 AND ft.price <= 500000 THEN 0.25
        ELSE 0.30
    END AS persentase_gross_laba,

    -- Menghitung harga setelah diskon
    ft.price * (1 - ft.discount_percentage / 100) AS nett_sales,

    -- Menghitung keuntungan yang diperoleh
    (ft.price * (1 - ft.discount_percentage / 100)) * 
    CASE 
        WHEN ft.price <= 50000 THEN 0.10
        WHEN ft.price > 50000 AND ft.price <= 100000 THEN 0.15
        WHEN ft.price > 100000 AND ft.price <= 300000 THEN 0.20
        WHEN ft.price > 300000 AND ft.price <= 500000 THEN 0.25
        ELSE 0.30
    END AS nett_profit,

    ft.rating AS rating_transaksi -- Rating transaksi dari pelanggan
FROM `modular-bot-455205-d3.challenge.final_transacrion` ft
JOIN `modular-bot-455205-d3.challenge.kantor_cabang` kc
ON ft.branch_id = kc.branch_id
JOIN `modular-bot-455205-d3.challenge.product` p
ON ft.product_id = p.product_id;

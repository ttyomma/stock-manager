--
-- PostgreSQL database dump
--

\restrict MsOAyEy1eRkD4cN5tSvbkd3TikRMDzXlA8Qd1C0PVekb8bq8XbIsGDcyuDWDanz

-- Dumped from database version 18.1
-- Dumped by pg_dump version 18.1

-- Started on 2026-09-26 15:38:13

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 7 (class 2615 OID 24786)
-- Name: trade; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA trade;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 236 (class 1259 OID 24798)
-- Name: product; Type: TABLE; Schema: trade; Owner: -
--

CREATE TABLE trade.product (
    product_id integer NOT NULL,
    supplier_id integer,
    product_name character varying(150) NOT NULL,
    category character varying(50) NOT NULL,
    purchase_price numeric(10,2) NOT NULL,
    sale_price numeric(10,2) NOT NULL,
    stock_quantity integer DEFAULT 0 NOT NULL,
    CONSTRAINT product_stock_quantity_check CHECK ((stock_quantity >= 0))
);


--
-- TOC entry 235 (class 1259 OID 24797)
-- Name: product_product_id_seq; Type: SEQUENCE; Schema: trade; Owner: -
--

CREATE SEQUENCE trade.product_product_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5082 (class 0 OID 0)
-- Dependencies: 235
-- Name: product_product_id_seq; Type: SEQUENCE OWNED BY; Schema: trade; Owner: -
--

ALTER SEQUENCE trade.product_product_id_seq OWNED BY trade.product.product_id;


--
-- TOC entry 238 (class 1259 OID 24818)
-- Name: sale; Type: TABLE; Schema: trade; Owner: -
--

CREATE TABLE trade.sale (
    sale_id integer NOT NULL,
    customer_name character varying(100) DEFAULT 'Роздрібний покупець'::character varying,
    sale_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    total_amount numeric(12,2) DEFAULT 0.00
);


--
-- TOC entry 240 (class 1259 OID 24829)
-- Name: sale_item; Type: TABLE; Schema: trade; Owner: -
--

CREATE TABLE trade.sale_item (
    sale_item_id integer NOT NULL,
    sale_id integer,
    product_id integer,
    quantity integer NOT NULL,
    unit_price numeric(10,2) NOT NULL,
    CONSTRAINT sale_item_quantity_check CHECK ((quantity > 0))
);


--
-- TOC entry 239 (class 1259 OID 24828)
-- Name: sale_item_sale_item_id_seq; Type: SEQUENCE; Schema: trade; Owner: -
--

CREATE SEQUENCE trade.sale_item_sale_item_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5083 (class 0 OID 0)
-- Dependencies: 239
-- Name: sale_item_sale_item_id_seq; Type: SEQUENCE OWNED BY; Schema: trade; Owner: -
--

ALTER SEQUENCE trade.sale_item_sale_item_id_seq OWNED BY trade.sale_item.sale_item_id;


--
-- TOC entry 237 (class 1259 OID 24817)
-- Name: sale_sale_id_seq; Type: SEQUENCE; Schema: trade; Owner: -
--

CREATE SEQUENCE trade.sale_sale_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5084 (class 0 OID 0)
-- Dependencies: 237
-- Name: sale_sale_id_seq; Type: SEQUENCE OWNED BY; Schema: trade; Owner: -
--

ALTER SEQUENCE trade.sale_sale_id_seq OWNED BY trade.sale.sale_id;


--
-- TOC entry 234 (class 1259 OID 24788)
-- Name: supplier; Type: TABLE; Schema: trade; Owner: -
--

CREATE TABLE trade.supplier (
    supplier_id integer NOT NULL,
    company_name character varying(100) NOT NULL,
    phone character varying(20) NOT NULL,
    contact_person character varying(100)
);


--
-- TOC entry 233 (class 1259 OID 24787)
-- Name: supplier_supplier_id_seq; Type: SEQUENCE; Schema: trade; Owner: -
--

CREATE SEQUENCE trade.supplier_supplier_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5085 (class 0 OID 0)
-- Dependencies: 233
-- Name: supplier_supplier_id_seq; Type: SEQUENCE OWNED BY; Schema: trade; Owner: -
--

ALTER SEQUENCE trade.supplier_supplier_id_seq OWNED BY trade.supplier.supplier_id;


--
-- TOC entry 4902 (class 2604 OID 24801)
-- Name: product product_id; Type: DEFAULT; Schema: trade; Owner: -
--

ALTER TABLE ONLY trade.product ALTER COLUMN product_id SET DEFAULT nextval('trade.product_product_id_seq'::regclass);


--
-- TOC entry 4904 (class 2604 OID 24821)
-- Name: sale sale_id; Type: DEFAULT; Schema: trade; Owner: -
--

ALTER TABLE ONLY trade.sale ALTER COLUMN sale_id SET DEFAULT nextval('trade.sale_sale_id_seq'::regclass);


--
-- TOC entry 4908 (class 2604 OID 24832)
-- Name: sale_item sale_item_id; Type: DEFAULT; Schema: trade; Owner: -
--

ALTER TABLE ONLY trade.sale_item ALTER COLUMN sale_item_id SET DEFAULT nextval('trade.sale_item_sale_item_id_seq'::regclass);


--
-- TOC entry 4901 (class 2604 OID 24791)
-- Name: supplier supplier_id; Type: DEFAULT; Schema: trade; Owner: -
--

ALTER TABLE ONLY trade.supplier ALTER COLUMN supplier_id SET DEFAULT nextval('trade.supplier_supplier_id_seq'::regclass);


--
-- TOC entry 5072 (class 0 OID 24798)
-- Dependencies: 236
-- Data for Name: product; Type: TABLE DATA; Schema: trade; Owner: -
--

INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (2, 1, 'Ноутбук Apple MacBook Pro 14" M3 Pro 18/512GB Space Black', 'Ноутбуки', 78000.00, 89999.00, 5);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (3, 3, 'Ноутбук Lenovo IdeaPad 3 15IAU7 Arctic Grey', 'Ноутбуки', 15200.00, 17999.00, 24);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (4, 3, 'Ноутбук Lenovo Legion Pro 5 16IRX8 Onyx Grey', 'Ноутбуки', 56000.00, 64999.00, 8);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (5, 3, 'Ноутбук ASUS ROG Strix G16 G614JV Eclipse Gray', 'Ноутбуки', 52000.00, 59999.00, 7);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (6, 3, 'Ноутбук ASUS Zenbook 14 OLED UX3405MA Ponder Blue', 'Ноутбуки', 44000.00, 51499.00, 10);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (7, 2, 'Ноутбук HP Pavilion 15-eg3014ua Natural Silver', 'Ноутбуки', 22500.00, 26999.00, 18);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (8, 2, 'Ноутбук Acer Nitro 5 AN515-58 Obsidian Black', 'Ноутбуки', 33000.00, 38499.00, 14);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (9, 2, 'Ноутбук Acer Swift Go 14 SFG14-71 Pure Silver', 'Ноутбуки', 28000.00, 32999.00, 9);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (10, 1, 'Ноутбук Dell Vostro 3520 Carbon Black', 'Ноутбуки', 17000.00, 20499.00, 15);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (11, 8, 'Смартфон Apple iPhone 15 128GB Black', 'Смартфони', 30500.00, 34999.00, 30);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (12, 8, 'Смартфон Apple iPhone 15 Pro Max 256GB Natural Titanium', 'Смартфони', 51000.00, 57999.00, 15);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (13, 8, 'Смартфон Apple iPhone 13 128GB Midnight', 'Смартфони', 21500.00, 24999.00, 22);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (14, 6, 'Смартфон Samsung Galaxy S24 Ultra 12/256GB Titanium Gray', 'Смартфони', 46000.00, 52999.00, 12);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (15, 6, 'Смартфон Samsung Galaxy A55 5G 8/128GB Awesome Navy', 'Смартфони', 14200.00, 16999.00, 45);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (16, 6, 'Смартфон Samsung Galaxy A25 5G 6/128GB Blue Black', 'Смартфони', 8100.00, 9999.00, 35);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (17, 7, 'Смартфон Xiaomi 14 12/512GB Black', 'Смартфони', 31000.00, 36999.00, 11);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (18, 7, 'Смартфон Redmi Note 13 Pro+ 5G 12/512GB Midnight Black', 'Смартфони', 15500.00, 18499.00, 28);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (19, 7, 'Смартфон Redmi 13C 8/256GB Midnight Black', 'Смартфони', 4600.00, 5799.00, 50);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (20, 6, 'Смартфон Motorola Edge 40 Neo 12/256GB Black Beauty', 'Смартфони', 11500.00, 13999.00, 16);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (21, 8, 'Планшет Apple iPad 10.9" 2022 Wi-Fi 64GB Silver', 'Планшети', 15800.00, 18499.00, 20);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (22, 8, 'Планшет Apple iPad Air 11" M2 Wi-Fi 128GB Space Gray', 'Планшети', 26000.00, 29999.00, 8);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (23, 6, 'Планшет Samsung Galaxy Tab S9 FE Wi-Fi 6/128GB Gray', 'Планшети', 16500.00, 19999.00, 14);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (24, 7, 'Планшет Xiaomi Pad 6 8/256GB Gravity Gray', 'Планшети', 12300.00, 14999.00, 19);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (25, 3, 'Монітор 23.8" ASUS VA24EHF Black (100Hz IPS)', 'Монітори', 3400.00, 4199.00, 35);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (26, 3, 'Монітор 27" ASUS TUF Gaming VG27AQ3A (QHD 180Hz)', 'Монітори', 8700.00, 10499.00, 12);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (27, 2, 'Монітор 27" Dell S2722QC 4K UHD USB-C', 'Монітори', 13500.00, 15999.00, 9);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (28, 2, 'Монітор 24" Dell P2422H Professional', 'Монітори', 5600.00, 6899.00, 25);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (29, 2, 'Монітор 34" Samsung Odyssey G5 LC34G55T Curved', 'Монітори', 12800.00, 15299.00, 6);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (30, 2, 'Монітор 27" LG UltraGear 27GP850P-B Nano IPS', 'Монітори', 11200.00, 13499.00, 15);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (31, 9, 'Процесор AMD Ryzen 5 7600 3.8-5.1GHz 32MB AM5 Box', 'Процесори', 6800.00, 7999.00, 20);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (32, 9, 'Процесор AMD Ryzen 7 7800X3D 4.2-5.0GHz 96MB AM5 Box', 'Процесори', 14500.00, 16999.00, 14);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (33, 9, 'Процесор AMD Ryzen 5 5600 3.5-4.4GHz 32MB AM4 Box', 'Процесори', 3900.00, 4699.00, 40);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (34, 9, 'Процесор Intel Core i5-13400F 2.5-4.6GHz LGA1700 Box', 'Процесори', 6900.00, 8199.00, 18);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (35, 9, 'Процесор Intel Core i7-14700K 3.4-5.6GHz LGA1700 Box', 'Процесори', 16000.00, 18799.00, 8);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (36, 9, 'Процесор Intel Core i3-12100F 3.3-4.3GHz LGA1700 Box', 'Процесори', 2900.00, 3599.00, 25);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (37, 9, 'Відеокарта Gigabyte GeForce RTX 4060 WINDFORCE OC 8GB', 'Відеокарти', 12400.00, 14499.00, 16);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (38, 9, 'Відеокарта ASUS TUF Gaming GeForce RTX 4070 SUPER OC 12GB', 'Відеокарти', 27500.00, 31999.00, 7);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (39, 4, 'Відеокарта MSI GeForce RTX 4080 SUPER 16G GAMING X SLIM', 'Відеокарти', 43000.00, 49999.00, 4);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (40, 5, 'Відеокарта Palit GeForce RTX 3060 Dual 12GB', 'Відеокарти', 10500.00, 12299.00, 22);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (41, 5, 'Відеокарта Sapphire Radeon RX 7800 XT PULSE 16GB', 'Відеокарти', 20500.00, 23999.00, 6);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (42, 4, 'Відеокарта ASUS Radeon RX 7600 Dual OC 8GB', 'Відеокарти', 10100.00, 11899.00, 10);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (43, 10, 'SSD-накопичувач Kingston KC3000 1TB M.2 NVMe', 'Накопичувачі', 3200.00, 3899.00, 45);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (44, 10, 'SSD-накопичувач Samsung 990 PRO 2TB M.2 NVMe', 'Накопичувачі', 6500.00, 7899.00, 18);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (45, 10, 'SSD-накопичувач Kingston NV2 1TB M.2 NVMe', 'Накопичувачі', 1950.00, 2399.00, 60);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (46, 10, 'SSD-диск Crucial BX500 500GB 2.5" SATA III', 'Накопичувачі', 1150.00, 1499.00, 35);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (47, 4, 'Жорсткий диск WD Blue 2TB 7200rpm 256MB 3.5"', 'Накопичувачі', 2100.00, 2599.00, 20);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (48, 4, 'Жорсткий диск Seagate BarraCuda 4TB 5400rpm 3.5"', 'Накопичувачі', 3300.00, 3999.00, 12);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (49, 10, 'Оперативна пам''ять Kingston FURY DDR5 32GB (2x16GB) 6000MHz', 'Оперативна пам''ять', 4400.00, 5299.00, 25);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (50, 10, 'Оперативна пам''ять Corsair DDR5 32GB (2x16GB) 6000MHz', 'Оперативна пам''ять', 4100.00, 4999.00, 18);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (51, 10, 'Оперативна пам''ять Kingston FURY DDR4 16GB (2x8GB) 3200MHz', 'Оперативна пам''ять', 1350.00, 1699.00, 55);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (52, 10, 'Оперативна пам''ять G.Skill DDR5 64GB (2x32GB) 6400MHz', 'Оперативна пам''ять', 7800.00, 9399.00, 8);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (53, 5, 'Оперативна пам''ять SO-DIMM Crucial DDR4 16GB 3200MHz', 'Оперативна пам''ять', 1200.00, 1549.00, 30);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (54, 11, 'Материнська плата MSI B650 GAMING PLUS WIFI AM5', 'Комплектуючі для ПК', 5900.00, 6999.00, 14);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (55, 11, 'Материнська плата ASUS PRIME B760-PLUS LGA1700', 'Комплектуючі для ПК', 4800.00, 5699.00, 16);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (56, 11, 'Материнська плата Gigabyte B550M AORUS ELITE AM4', 'Комплектуючі для ПК', 3400.00, 4099.00, 22);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (57, 11, 'Блок живлення be quiet! Pure Power 12 M 750W Gold', 'Комплектуючі для ПК', 4300.00, 5199.00, 15);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (58, 11, 'Блок живлення Deepcool PK650D 650W Bronze', 'Комплектуючі для ПК', 1850.00, 2299.00, 28);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (59, 11, 'Корпус Deepcool CC560 V2 Black б/БЖ', 'Комплектуючі для ПК', 1900.00, 2399.00, 12);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (60, 14, 'Миша Logitech G Pro X Superlight 2 Wireless Black', 'Периферія', 4900.00, 5899.00, 15);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (61, 14, 'Миша Logitech G102 Lightsync Black USB', 'Периферія', 850.00, 1199.00, 75);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (62, 14, 'Миша Razer DeathAdder V3 Pro Wireless Black', 'Периферія', 4800.00, 5799.00, 10);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (63, 14, 'Миша Logitech MX Master 3S Graphite Bluetooth', 'Периферія', 3600.00, 4499.00, 20);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (64, 14, 'Миша бездротова Logitech M185 Swift Grey', 'Периферія', 420.00, 599.00, 80);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (65, 14, 'Клавіатура Keychron K2 Pro QMK/VIA Wireless Red Sw', 'Периферія', 3700.00, 4599.00, 12);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (66, 14, 'Клавіатура SteelSeries Apex Pro TKL OmniPoint', 'Периферія', 7200.00, 8699.00, 6);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (67, 14, 'Клавіатура HyperX Alloy Origins Core RGB Aqua Sw', 'Периферія', 3100.00, 3899.00, 18);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (68, 14, 'Клавіатура Logitech MX Keys S Graphite Bluetooth', 'Периферія', 4100.00, 4999.00, 16);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (69, 14, 'Клавіатура дротова A4Tech KV-300H USB Dark Grey', 'Периферія', 800.00, 1099.00, 40);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (70, 12, 'Килимок для миші SteelSeries QcK Heavy Large', 'Периферія', 700.00, 999.00, 50);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (71, 12, 'Килимок для миші Razer Gigantus V2 XXL', 'Периферія', 1100.00, 1499.00, 30);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (72, 12, 'Геймпад Sony DualSense Wireless Midnight Black', 'Геймінг', 2350.00, 2899.00, 25);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (73, 12, 'Геймпад Microsoft Xbox Wireless Controller Black', 'Геймінг', 2150.00, 2699.00, 30);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (74, 8, 'Навушники Apple AirPods Pro 2 USB-C', 'Аудіотехніка', 7900.00, 9499.00, 35);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (75, 8, 'Навушники Apple AirPods 3 Lightning', 'Аудіотехніка', 5600.00, 6799.00, 24);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (76, 13, 'Навушники Sony WH-1000XM5 Black', 'Аудіотехніка', 11500.00, 13999.00, 10);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (77, 13, 'Навушники Marshall Major IV Bluetooth Black', 'Аудіотехніка', 3900.00, 4899.00, 28);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (78, 13, 'Портативна акустика JBL Flip 6 Squad', 'Аудіотехніка', 3600.00, 4499.00, 30);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (79, 13, 'Портативна акустика JBL Charge 5 Black', 'Аудіотехніка', 5300.00, 6499.00, 18);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (80, 12, 'Геймерська гарнітура HyperX Cloud II Red USB', 'Аудіотехніка', 2500.00, 3199.00, 40);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (81, 12, 'Геймерська гарнітура Logitech G435 Lightspeed Black', 'Аудіотехніка', 2100.00, 2699.00, 32);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (82, 7, 'TWS навушники Xiaomi Redmi Buds 5 Pro Black', 'Аудіотехніка', 1950.00, 2599.00, 45);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (83, 13, 'Акустична система 2.0 Edifier R1280DBs Brown', 'Аудіотехніка', 3700.00, 4699.00, 14);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (84, 15, 'Маршрутизатор Wi-Fi 6 TP-Link Archer AX55 Gigabit', 'Мережеве обладнання', 2400.00, 2999.00, 35);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (85, 15, 'Маршрутизатор Wi-Fi 6 ASUS RT-AX58U V2', 'Мережеве обладнання', 3600.00, 4499.00, 16);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (86, 15, 'Маршрутизатор MikroTik hEX S (RB760iGS)', 'Мережеве обладнання', 2300.00, 2799.00, 20);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (87, 15, 'Комутатор 8-портовий TP-Link TL-SG108 Gigabit', 'Мережеве обладнання', 750.00, 999.00, 50);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (88, 16, 'Точка доступу Wi-Fi Ubiquiti UniFi U6 Pro PoE', 'Мережеве обладнання', 5500.00, 6599.00, 10);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (89, 16, 'Мережевий адаптер Wi-Fi TP-Link Archer T3U Plus USB', 'Мережеве обладнання', 520.00, 699.00, 40);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (90, 15, 'Маршрутизатор Keenetic Hero 4G+ (KN-2311)', 'Мережеве обладнання', 4500.00, 5499.00, 8);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (91, 17, 'Кабель Baseus Cafule Type-C to Type-C 100W 2m Black', 'Кабелі та перехідники', 220.00, 399.00, 120);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (93, 17, 'Кабель HDMI 2.1 8K Ultra High Speed Vention 2m', 'Кабелі та перехідники', 280.00, 499.00, 85);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (94, 17, 'Хаб USB-C 6-in-1 Baseus Metal Gleam Series Grey', 'Аксесуари', 950.00, 1499.00, 35);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (95, 18, 'Підставка для ноутбука алюмінієва Ugreen Foldable', 'Аксесуари', 650.00, 999.00, 40);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (96, 18, 'Чохол Apple Silicone Case with MagSafe iPhone 15 Black', 'Аксесуари', 1400.00, 2199.00, 25);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (97, 19, 'Павербанк Baseus Blade HD 100W 20000mAh Black', 'Павербанки', 2200.00, 2999.00, 45);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (98, 19, 'Павербанк Xiaomi 22.5W Power Bank 10000mAh Black', 'Павербанки', 600.00, 899.00, 90);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (99, 20, 'Портативна зарядна станція EcoFlow RIVER 2 Pro 768Wh', 'Зарядні станції', 21000.00, 25999.00, 12);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (100, 20, 'Джерело безперебійного живлення APC BV650I-GR 650VA', 'ДБЖ', 2600.00, 3299.00, 18);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (101, 8, 'Смарт-годинник Apple Watch Series 9 GPS 45mm Midnight', 'Смарт-годинники', 16500.00, 19499.00, 15);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (102, 8, 'Смарт-годинник Apple Watch Ultra 2 GPS + Cellular 49mm Titanium', 'Смарт-годинники', 33000.00, 37999.00, 6);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (103, 8, 'Смарт-годинник Apple Watch SE 2 GPS 40mm Starlight', 'Смарт-годинники', 9800.00, 11499.00, 20);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (104, 6, 'Смарт-годинник Samsung Galaxy Watch6 44mm Graphite', 'Смарт-годинники', 9500.00, 11999.00, 18);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (105, 6, 'Смарт-годинник Samsung Galaxy Watch6 Classic 47mm Black', 'Смарт-годинники', 13200.00, 15999.00, 10);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (106, 7, 'Фітнес-браслет Xiaomi Smart Band 8 Graphite Black', 'Смарт-годинники', 1200.00, 1599.00, 60);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (107, 7, 'Смарт-годинник Xiaomi Watch 2 Pro LTE Black', 'Смарт-годинники', 8200.00, 9999.00, 12);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (108, 12, 'Смарт-годинник Garmin Fenix 7 Pro Solar Slate Gray', 'Смарт-годинники', 29000.00, 34999.00, 5);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (109, 12, 'Смарт-годинник Garmin Forerunner 265 Music Black', 'Смарт-годинники', 16800.00, 19999.00, 8);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (110, 7, 'Фітнес-браслет Xiaomi Smart Band 8 Active Pink', 'Смарт-годинники', 750.00, 999.00, 45);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (111, 6, 'Телевізор 55" Samsung 4K UHD Smart TV UE55CU7100UXUA', 'Телевізори', 16500.00, 19999.00, 12);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (112, 6, 'Телевізор 65" Samsung OLED 4K QE65S90CAUXUA', 'Телевізори', 58000.00, 67999.00, 4);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (113, 2, 'Телевізор 43" LG 4K Smart TV 43UR78006LK', 'Телевізори', 12300.00, 14799.00, 18);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (114, 2, 'Телевізор 55" LG OLED55C34LA evo 4K Smart TV', 'Телевізори', 47000.00, 54999.00, 5);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (115, 7, 'Телевізор 43" Xiaomi TV A Pro 43 UHD 4K Smart TV', 'Телевізори', 10500.00, 12999.00, 22);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (116, 7, 'Телевізор 32" Xiaomi TV A2 HD Android TV', 'Телевізори', 5900.00, 7499.00, 25);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (117, 8, 'Медіаплеєр Apple TV 4K 128GB Wi-Fi + Ethernet (3rd Gen)', 'Мультимедіа', 6400.00, 7599.00, 16);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (118, 7, 'ТВ-приставка Xiaomi Mi TV Box S 2nd Gen 4K', 'Мультимедіа', 1750.00, 2299.00, 40);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (119, 11, 'Кулер для процесора Deepcool AK400 Zero Dark Plus', 'Системи охолодження', 1350.00, 1749.00, 30);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (120, 11, 'Кулер для процесора be quiet! Dark Rock Pro 4', 'Системи охолодження', 3400.00, 4199.00, 12);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (121, 11, 'Кулер для процесора Deepcool AG620 ARGB Black', 'Системи охолодження', 2100.00, 2699.00, 20);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (122, 11, 'Система рідинного охолодження Deepcool LS720 ARGB 360mm', 'Системи охолодження', 4600.00, 5699.00, 8);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (123, 11, 'Система рідинного охолодження ARCTIC Liquid Freezer III 360', 'Системи охолодження', 4200.00, 5199.00, 14);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (124, 11, 'Вентилятор для корпусу be quiet! Pure Wings 2 120mm PWM', 'Системи охолодження', 360.00, 499.00, 60);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (125, 11, 'Вентилятор для корпусу Arctic P12 PWM PST 120mm Black', 'Системи охолодження', 250.00, 369.00, 85);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (126, 11, 'Термопаста Arctic MX-4 4g зі шпателем', 'Системи охолодження', 180.00, 289.00, 120);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (127, 1, 'Ноутбук Apple MacBook Pro 16" M3 Max 36/1TB Space Black', 'Ноутбуки', 145000.00, 164999.00, 3);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (128, 1, 'Ноутбук Dell XPS 13 9315 Sky i5/16/512GB', 'Ноутбуки', 42000.00, 48999.00, 6);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (129, 3, 'Ноутбук Lenovo Yoga Slim 6 14IAP8 Cloud Grey', 'Ноутбуки', 29000.00, 34499.00, 11);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (130, 3, 'Ноутбук ASUS TUF Gaming A15 FA507NV Mecha Gray (RTX 4060)', 'Ноутбуки', 41000.00, 47999.00, 9);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (131, 3, 'Ноутбук Lenovo ThinkPad E16 Gen 1 Graphite Black', 'Ноутбуки', 32000.00, 37999.00, 10);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (132, 2, 'Ноутбук HP Victus 16-r0012ua Mica Silver (RTX 4050)', 'Ноутбуки', 34500.00, 39999.00, 12);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (133, 2, 'Ноутбук Acer Aspire 5 A515-58M Steel Gray', 'Ноутбуки', 19000.00, 22999.00, 16);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (134, 3, 'Ноутбук ASUS Vivobook 15 X1504VA Quiet Blue', 'Ноутбуки', 18500.00, 21999.00, 20);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (135, 2, 'Ноутбук HP 250 G9 Asteroid Silver', 'Ноутбуки', 14000.00, 16999.00, 22);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (136, 3, 'Ноутбук ASUS ROG Zephyrus G16 Eclipse Gray (RTX 4070)', 'Ноутбуки', 76000.00, 87999.00, 4);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (137, 8, 'Смартфон Apple iPhone 15 Pro 128GB Black Titanium', 'Смартфони', 42000.00, 47999.00, 14);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (138, 8, 'Смартфон Apple iPhone 14 128GB Midnight', 'Смартфони', 24500.00, 27999.00, 18);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (139, 6, 'Смартфон Samsung Galaxy S24+ 12/256GB Onyx Black', 'Смартфони', 36000.00, 41999.00, 10);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (140, 6, 'Смартфон Samsung Galaxy Z Flip5 8/256GB Graphite', 'Смартфони', 31000.00, 36999.00, 7);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (141, 6, 'Смартфон Google Pixel 8 8/128GB Obsidian', 'Смартфони', 22500.00, 26499.00, 12);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (142, 6, 'Смартфон Google Pixel 7a 8/128GB Charcoal', 'Смартфони', 15200.00, 17999.00, 15);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (143, 7, 'Смартфон Poco X6 Pro 5G 12/512GB Black', 'Смартфони', 13500.00, 15999.00, 25);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (144, 7, 'Смартфон Poco F6 12/512GB Titanium', 'Смартфони', 17000.00, 19999.00, 16);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (145, 6, 'Смартфон OnePlus 12 16/512GB Silky Black', 'Смартфони', 33000.00, 38499.00, 8);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (146, 6, 'Смартфон Motorola Moto G84 5G 12/256GB Midnight Blue', 'Смартфони', 7900.00, 9499.00, 28);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (147, 9, 'Відеокарта ASUS TUF Gaming GeForce RTX 4070 Ti SUPER 16GB', 'Відеокарти', 36000.00, 41999.00, 6);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (148, 9, 'Відеокарта Gigabyte Radeon RX 7900 GRE GAMING OC 16GB', 'Відеокарти', 24500.00, 28499.00, 7);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (149, 5, 'Відеокарта PowerColor Radeon RX 6600 Fighter 8GB', 'Відеокарти', 8400.00, 9999.00, 18);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (150, 9, 'Процесор Intel Core i9-14900K 3.2-6.0GHz LGA1700 Box', 'Процесори', 23000.00, 26999.00, 5);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (151, 9, 'Процесор AMD Ryzen 9 7900X 4.7-5.6GHz AM5 Box', 'Процесори', 15800.00, 18499.00, 8);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (152, 9, 'Процесор AMD Ryzen 5 5500 3.6-4.2GHz AM4 Box', 'Процесори', 3100.00, 3799.00, 45);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (153, 11, 'Материнська плата ASUS ROG STRIX B650-A GAMING WIFI AM5', 'Комплектуючі для ПК', 9300.00, 10999.00, 8);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (154, 11, 'Материнська плата ASRock B660M Pro RS LGA1700', 'Комплектуючі для ПК', 3700.00, 4499.00, 15);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (155, 11, 'Корпус NZXT H5 Flow Black б/БЖ', 'Комплектуючі для ПК', 3800.00, 4699.00, 10);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (156, 11, 'Блок живлення Corsair RM850x 850W 80 Plus Gold ATX', 'Комплектуючі для ПК', 5600.00, 6799.00, 12);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (157, 14, 'Веб-камера Logitech C920 HD Pro USB Full HD', 'Периферія', 2600.00, 3299.00, 24);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (158, 14, 'Веб-камера Logitech Brio 4K Ultra HD Pro', 'Периферія', 6500.00, 7899.00, 10);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (159, 12, 'Мікрофон HyperX QuadCast S RGB USB Black', 'Периферія', 5200.00, 6399.00, 15);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (160, 12, 'Мікрофон Fifine AmpliGame A8 RGB Black USB', 'Периферія', 1700.00, 2299.00, 35);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (161, 12, 'Мікрофон Fifine K669B Black USB', 'Периферія', 1100.00, 1499.00, 40);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (162, 12, 'Карта захоплення відео Elgato Cam Link 4K USB', 'Стримінг', 4300.00, 5299.00, 8);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (163, 12, 'Контролер для стрімів Elgato Stream Deck MK.2 Black', 'Стримінг', 5900.00, 7199.00, 7);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (164, 18, 'Кронштейн для двох моніторів OfficePro MA902G Grey', 'Аксесуари', 1800.00, 2499.00, 16);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (165, 7, 'Робот-пилосос Xiaomi Robot Vacuum S10 White', 'Розумний дім', 7800.00, 9499.00, 14);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (166, 7, 'Робот-пилосос Roborock Q7 Max White', 'Розумний дім', 14500.00, 17999.00, 8);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (167, 7, 'Очищувач повітря Xiaomi Smart Air Purifier 4 Compact', 'Розумний дім', 3100.00, 3999.00, 20);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (168, 7, 'Зволожувач повітря Xiaomi Smart Humidifier 2', 'Розумний дім', 1600.00, 2199.00, 25);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (169, 7, 'Електрочайник Xiaomi Smart Kettle Pro White', 'Розумний дім', 1500.00, 1999.00, 30);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (170, 15, 'Розумна розетка Wi-Fi TP-Link Tapo P110 з моніторингом', 'Розумний дім', 450.00, 649.00, 90);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (171, 15, 'Розумна лампа Wi-Fi TP-Link Tapo L530E E27 Multicolor', 'Розумний дім', 320.00, 499.00, 110);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (172, 15, 'Wi-Fi камера відеоспостереження TP-Link Tapo C200 поворотна', 'Системи безпеки', 1050.00, 1399.00, 45);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (173, 7, 'IP-камера відеоспостереження Xiaomi Smart Camera C300 2K', 'Системи безпеки', 1200.00, 1599.00, 38);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (174, 7, 'Розумний термогігрометр Xiaomi Temperature Monitor Clock', 'Розумний дім', 650.00, 899.00, 50);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (175, 20, 'Портативна зарядна станція EcoFlow DELTA 2 1024Wh', 'Зарядні станції', 34000.00, 39999.00, 8);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (176, 20, 'Портативна зарядна станція BLUETTI EB3A 268Wh 600W', 'Зарядні станції', 9800.00, 11999.00, 16);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (177, 20, 'Портативна зарядна станція BLUETTI AC180P 1440Wh 1800W', 'Зарядні станції', 38000.00, 44999.00, 5);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (178, 20, 'Сонячна панель EcoFlow 160W Solar Panel', 'Зарядні станції', 11500.00, 13999.00, 6);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (179, 20, 'Джерело безперебійного живлення APC Easy-UPS SMV 1000VA', 'ДБЖ', 8900.00, 10999.00, 7);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (180, 20, 'ДБЖ для роутера Mini UPS Marsriva KP3 10000mAh', 'ДБЖ', 950.00, 1399.00, 55);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (181, 20, 'Акумулятор LiFePO4 Ultimatron 12.8V 100Ah Smart BMS', 'Акумулятори', 15500.00, 18999.00, 10);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (182, 20, 'Інвертор напруги Volt Polska Sinus Pro 800E 12/230V', 'Інвертори', 4100.00, 5199.00, 12);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (183, 19, 'Павербанк Romoss Sense 8+ 30000mAh 18W White', 'Павербанки', 1100.00, 1599.00, 40);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (184, 19, 'Павербанк Anker 737 Power Bank 24000mAh 140W', 'Павербанки', 4300.00, 5299.00, 14);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (185, 15, 'Mesh-система Wi-Fi 6 TP-Link Deco X50 (2-Pack) AX3000', 'Мережеве обладнання', 4800.00, 5999.00, 15);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (186, 15, 'Mesh-система Wi-Fi 6 ASUS ZenWiFi XD5 (2-Pack) White', 'Мережеве обладнання', 5700.00, 6999.00, 9);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (187, 4, 'Мережеве сховище NAS Synology DiskStation DS224+ (2-Bay)', 'Накопичувачі', 13500.00, 15999.00, 6);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (188, 4, 'Жорсткий диск для NAS WD Red Plus 4TB 5400rpm 3.5"', 'Накопичувачі', 4300.00, 5199.00, 14);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (189, 10, 'Зовнішній SSD Samsung T7 Shield 1TB USB 3.2 Black', 'Накопичувачі', 3800.00, 4699.00, 22);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (190, 10, 'Флеш-диск Kingston DataTraveler Exodia M 128GB USB 3.2', 'Накопичувачі', 310.00, 459.00, 140);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (191, 19, 'Зарядний пристрій GaN Baseus GaN5 Pro 65W Black', 'Зарядні пристрої', 850.00, 1299.00, 55);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (192, 19, 'Зарядний пристрій Apple 20W USB-C Power Adapter White', 'Зарядні пристрої', 820.00, 1099.00, 70);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (193, 19, 'Зарядний пристрій Ugreen Nexode GaN 100W 4-Port Black', 'Зарядні пристрої', 1950.00, 2699.00, 25);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (194, 19, 'Бездротовий зарядний пристрій Apple MagSafe Charger 1m', 'Зарядні пристрої', 1600.00, 2199.00, 30);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (195, 18, 'Рюкзак для ноутбука 15.6" Lenovo ThinkPad Basic Backpack', 'Аксесуари', 700.00, 999.00, 45);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (196, 18, 'Рюкзак для ноутбука 15.6" Xiaomi Commuter Dark Blue', 'Аксесуари', 850.00, 1249.00, 35);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (197, 18, 'Сумка для ноутбука 15.6" RivaCase 8231 Black', 'Аксесуари', 550.00, 799.00, 50);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (198, 17, 'Кабель DisplayPort 1.4 8K Vention 2m Black', 'Кабелі та перехідники', 290.00, 479.00, 60);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (199, 17, 'Патч-корд литий UTP Cat 6 Vention RJ45 3m Black', 'Кабелі та перехідники', 80.00, 159.00, 110);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (200, 18, 'Захисне скло Spigen Glas.tR EZ Fit для iPhone 15 (2-Pack)', 'Аксесуари', 650.00, 999.00, 40);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (1, 1, 'Ноутбук Apple MacBook Air 13" M2 8/256GB Midnight', 'Ноутбуки', 41000.00, 49499.00, 17);
INSERT INTO trade.product (product_id, supplier_id, product_name, category, purchase_price, sale_price, stock_quantity) VALUES (92, 17, 'Кабель Baseus Halo USB to Lightning 2.4A 1m Black', 'Кабелі та перехідники', 140.00, 269.00, 144);


--
-- TOC entry 5074 (class 0 OID 24818)
-- Dependencies: 238
-- Data for Name: sale; Type: TABLE DATA; Schema: trade; Owner: -
--

INSERT INTO trade.sale (sale_id, customer_name, sale_date, total_amount) VALUES (1, 'Олександр Коваленко', '2026-09-16 09:15:22', 38197.00);
INSERT INTO trade.sale (sale_id, customer_name, sale_date, total_amount) VALUES (2, 'Марина Ткачук', '2026-09-16 11:40:05', 1597.00);
INSERT INTO trade.sale (sale_id, customer_name, sale_date, total_amount) VALUES (3, 'Дмитро Мельник', '2026-09-16 14:22:18', 20197.00);
INSERT INTO trade.sale (sale_id, customer_name, sale_date, total_amount) VALUES (4, 'ТОВ "Сіті Медіа Про"', '2026-09-16 16:50:30', 7633.00);
INSERT INTO trade.sale (sale_id, customer_name, sale_date, total_amount) VALUES (5, 'Ігор Бондаренко', '2026-09-17 10:05:44', 24196.00);
INSERT INTO trade.sale (sale_id, customer_name, sale_date, total_amount) VALUES (6, 'Олена Шевченко', '2026-09-17 12:35:10', 12797.00);
INSERT INTO trade.sale (sale_id, customer_name, sale_date, total_amount) VALUES (7, 'Сергій Кравченко', '2026-09-17 15:18:50', 53998.00);
INSERT INTO trade.sale (sale_id, customer_name, sale_date, total_amount) VALUES (8, 'Наталія Сидоренко', '2026-09-17 18:40:12', 11498.00);
INSERT INTO trade.sale (sale_id, customer_name, sale_date, total_amount) VALUES (9, 'Андрій Мороз', '2026-09-18 09:30:15', 37198.00);
INSERT INTO trade.sale (sale_id, customer_name, sale_date, total_amount) VALUES (10, 'Юлія Лисенко', '2026-09-18 11:15:00', 2498.00);
INSERT INTO trade.sale (sale_id, customer_name, sale_date, total_amount) VALUES (11, 'Володимир Василенко', '2026-09-18 13:45:29', 52997.00);
INSERT INTO trade.sale (sale_id, customer_name, sale_date, total_amount) VALUES (12, 'ФОП Захарченко П.М.', '2026-09-18 16:20:40', 4197.00);
INSERT INTO trade.sale (sale_id, customer_name, sale_date, total_amount) VALUES (13, 'Віталій Григорчук', '2026-09-19 10:50:11', 21996.00);
INSERT INTO trade.sale (sale_id, customer_name, sale_date, total_amount) VALUES (14, 'Тетяна Павленко', '2026-09-19 12:10:55', 21098.00);
INSERT INTO trade.sale (sale_id, customer_name, sale_date, total_amount) VALUES (15, 'Максим Романчук', '2026-09-19 14:40:02', 77498.00);
INSERT INTO trade.sale (sale_id, customer_name, sale_date, total_amount) VALUES (16, 'Анна Кузьменко', '2026-09-19 17:05:30', 4499.00);
INSERT INTO trade.sale (sale_id, customer_name, sale_date, total_amount) VALUES (17, 'Роман Даниленко', '2026-09-20 11:25:40', 20498.00);
INSERT INTO trade.sale (sale_id, customer_name, sale_date, total_amount) VALUES (18, 'Артем Поліщук', '2026-09-20 13:55:18', 5798.00);
INSERT INTO trade.sale (sale_id, customer_name, sale_date, total_amount) VALUES (19, 'Богдан Савчук', '2026-09-20 15:30:22', 7297.00);
INSERT INTO trade.sale (sale_id, customer_name, sale_date, total_amount) VALUES (20, 'Євген Пономаренко', '2026-09-20 18:15:45', 4697.00);


--
-- TOC entry 5076 (class 0 OID 24829)
-- Dependencies: 240
-- Data for Name: sale_item; Type: TABLE DATA; Schema: trade; Owner: -
--

INSERT INTO trade.sale_item (sale_item_id, sale_id, product_id, quantity, unit_price) VALUES (1, 1, 11, 1, 34999.00);
INSERT INTO trade.sale_item (sale_item_id, sale_id, product_id, quantity, unit_price) VALUES (2, 1, 96, 1, 2199.00);
INSERT INTO trade.sale_item (sale_item_id, sale_id, product_id, quantity, unit_price) VALUES (3, 1, 200, 1, 999.00);
INSERT INTO trade.sale_item (sale_item_id, sale_id, product_id, quantity, unit_price) VALUES (4, 2, 64, 2, 599.00);
INSERT INTO trade.sale_item (sale_item_id, sale_id, product_id, quantity, unit_price) VALUES (5, 2, 91, 1, 399.00);
INSERT INTO trade.sale_item (sale_item_id, sale_id, product_id, quantity, unit_price) VALUES (6, 3, 3, 1, 17999.00);
INSERT INTO trade.sale_item (sale_item_id, sale_id, product_id, quantity, unit_price) VALUES (7, 3, 195, 1, 999.00);
INSERT INTO trade.sale_item (sale_item_id, sale_id, product_id, quantity, unit_price) VALUES (8, 3, 61, 1, 1199.00);
INSERT INTO trade.sale_item (sale_item_id, sale_id, product_id, quantity, unit_price) VALUES (9, 4, 84, 2, 2999.00);
INSERT INTO trade.sale_item (sale_item_id, sale_id, product_id, quantity, unit_price) VALUES (10, 4, 87, 1, 999.00);
INSERT INTO trade.sale_item (sale_item_id, sale_id, product_id, quantity, unit_price) VALUES (11, 4, 199, 4, 159.00);
INSERT INTO trade.sale_item (sale_item_id, sale_id, product_id, quantity, unit_price) VALUES (12, 5, 31, 1, 7999.00);
INSERT INTO trade.sale_item (sale_item_id, sale_id, product_id, quantity, unit_price) VALUES (13, 5, 54, 1, 6999.00);
INSERT INTO trade.sale_item (sale_item_id, sale_id, product_id, quantity, unit_price) VALUES (14, 5, 49, 1, 5299.00);
INSERT INTO trade.sale_item (sale_item_id, sale_id, product_id, quantity, unit_price) VALUES (15, 5, 43, 1, 3899.00);
INSERT INTO trade.sale_item (sale_item_id, sale_id, product_id, quantity, unit_price) VALUES (16, 6, 74, 1, 9499.00);
INSERT INTO trade.sale_item (sale_item_id, sale_id, product_id, quantity, unit_price) VALUES (17, 6, 194, 1, 2199.00);
INSERT INTO trade.sale_item (sale_item_id, sale_id, product_id, quantity, unit_price) VALUES (18, 6, 192, 1, 1099.00);
INSERT INTO trade.sale_item (sale_item_id, sale_id, product_id, quantity, unit_price) VALUES (19, 7, 175, 1, 39999.00);
INSERT INTO trade.sale_item (sale_item_id, sale_id, product_id, quantity, unit_price) VALUES (20, 7, 178, 1, 13999.00);
INSERT INTO trade.sale_item (sale_item_id, sale_id, product_id, quantity, unit_price) VALUES (21, 8, 165, 1, 9499.00);
INSERT INTO trade.sale_item (sale_item_id, sale_id, product_id, quantity, unit_price) VALUES (22, 8, 169, 1, 1999.00);
INSERT INTO trade.sale_item (sale_item_id, sale_id, product_id, quantity, unit_price) VALUES (23, 9, 38, 1, 31999.00);
INSERT INTO trade.sale_item (sale_item_id, sale_id, product_id, quantity, unit_price) VALUES (24, 9, 57, 1, 5199.00);
INSERT INTO trade.sale_item (sale_item_id, sale_id, product_id, quantity, unit_price) VALUES (25, 10, 106, 1, 1599.00);
INSERT INTO trade.sale_item (sale_item_id, sale_id, product_id, quantity, unit_price) VALUES (26, 10, 98, 1, 899.00);
INSERT INTO trade.sale_item (sale_item_id, sale_id, product_id, quantity, unit_price) VALUES (27, 11, 1, 1, 46999.00);
INSERT INTO trade.sale_item (sale_item_id, sale_id, product_id, quantity, unit_price) VALUES (28, 11, 94, 1, 1499.00);
INSERT INTO trade.sale_item (sale_item_id, sale_id, product_id, quantity, unit_price) VALUES (29, 11, 63, 1, 4499.00);
INSERT INTO trade.sale_item (sale_item_id, sale_id, product_id, quantity, unit_price) VALUES (30, 12, 180, 3, 1399.00);
INSERT INTO trade.sale_item (sale_item_id, sale_id, product_id, quantity, unit_price) VALUES (31, 13, 26, 1, 10499.00);
INSERT INTO trade.sale_item (sale_item_id, sale_id, product_id, quantity, unit_price) VALUES (32, 13, 65, 1, 4599.00);
INSERT INTO trade.sale_item (sale_item_id, sale_id, product_id, quantity, unit_price) VALUES (33, 13, 60, 1, 5899.00);
INSERT INTO trade.sale_item (sale_item_id, sale_id, product_id, quantity, unit_price) VALUES (34, 13, 70, 1, 999.00);
INSERT INTO trade.sale_item (sale_item_id, sale_id, product_id, quantity, unit_price) VALUES (35, 14, 18, 1, 18499.00);
INSERT INTO trade.sale_item (sale_item_id, sale_id, product_id, quantity, unit_price) VALUES (36, 14, 82, 1, 2599.00);
INSERT INTO trade.sale_item (sale_item_id, sale_id, product_id, quantity, unit_price) VALUES (37, 15, 12, 1, 57999.00);
INSERT INTO trade.sale_item (sale_item_id, sale_id, product_id, quantity, unit_price) VALUES (38, 15, 101, 1, 19499.00);
INSERT INTO trade.sale_item (sale_item_id, sale_id, product_id, quantity, unit_price) VALUES (39, 16, 78, 1, 4499.00);
INSERT INTO trade.sale_item (sale_item_id, sale_id, product_id, quantity, unit_price) VALUES (40, 17, 111, 1, 19999.00);
INSERT INTO trade.sale_item (sale_item_id, sale_id, product_id, quantity, unit_price) VALUES (41, 17, 93, 1, 499.00);
INSERT INTO trade.sale_item (sale_item_id, sale_id, product_id, quantity, unit_price) VALUES (42, 18, 72, 2, 2899.00);
INSERT INTO trade.sale_item (sale_item_id, sale_id, product_id, quantity, unit_price) VALUES (43, 19, 185, 1, 5999.00);
INSERT INTO trade.sale_item (sale_item_id, sale_id, product_id, quantity, unit_price) VALUES (44, 19, 170, 2, 649.00);
INSERT INTO trade.sale_item (sale_item_id, sale_id, product_id, quantity, unit_price) VALUES (45, 20, 97, 1, 2999.00);
INSERT INTO trade.sale_item (sale_item_id, sale_id, product_id, quantity, unit_price) VALUES (46, 20, 191, 1, 1299.00);
INSERT INTO trade.sale_item (sale_item_id, sale_id, product_id, quantity, unit_price) VALUES (47, 20, 91, 1, 399.00);


--
-- TOC entry 5070 (class 0 OID 24788)
-- Dependencies: 234
-- Data for Name: supplier; Type: TABLE DATA; Schema: trade; Owner: -
--

INSERT INTO trade.supplier (supplier_id, company_name, phone, contact_person) VALUES (1, 'ТОВ "АСБІС-Україна"', '+380444554411', 'Олександр Мельник');
INSERT INTO trade.supplier (supplier_id, company_name, phone, contact_person) VALUES (2, 'ТОВ "ЕРС Трейдінг"', '+380442303485', 'Марина Коваленко');
INSERT INTO trade.supplier (supplier_id, company_name, phone, contact_person) VALUES (3, 'ТОВ "МТІ Дистрибуція"', '+380444584444', 'Сергій Ткаченко');
INSERT INTO trade.supplier (supplier_id, company_name, phone, contact_person) VALUES (4, 'ТОВ "ЕЛКО Україна"', '+380444619670', 'Дмитро Шевчук');
INSERT INTO trade.supplier (supplier_id, company_name, phone, contact_person) VALUES (5, 'DC Link Group', '+380577285220', 'Андрій Бондаренко');
INSERT INTO trade.supplier (supplier_id, company_name, phone, contact_person) VALUES (6, 'ТОВ "Смарт Девайс Трейд"', '+380671122334', 'Олена Кравченко');
INSERT INTO trade.supplier (supplier_id, company_name, phone, contact_person) VALUES (7, 'ТОВ "Мі-Юкрейн Офішиал"', '+380509876543', 'Богдан Лисенко');
INSERT INTO trade.supplier (supplier_id, company_name, phone, contact_person) VALUES (8, 'ТОВ "АйТек Дистрибьюшн"', '+380632233445', 'Ярослав Савченко');
INSERT INTO trade.supplier (supplier_id, company_name, phone, contact_person) VALUES (9, 'ТОВ "КомпТрейд Плюс"', '+380443900011', 'Віталій Гриценко');
INSERT INTO trade.supplier (supplier_id, company_name, phone, contact_person) VALUES (10, 'ТОВ "Силікон Сервіс"', '+380674455667', 'Ігор Васильєв');
INSERT INTO trade.supplier (supplier_id, company_name, phone, contact_person) VALUES (11, 'ТОВ "Хардвер Солюшнс"', '+380503344556', 'Тарас Мороз');
INSERT INTO trade.supplier (supplier_id, company_name, phone, contact_person) VALUES (12, 'ТОВ "ГеймЗон Дистрибуція"', '+380937766554', 'Артем Павленко');
INSERT INTO trade.supplier (supplier_id, company_name, phone, contact_person) VALUES (13, 'ТОВ "Акустик Про"', '+380445021133', 'Максим Данилюк');
INSERT INTO trade.supplier (supplier_id, company_name, phone, contact_person) VALUES (14, 'ТОВ "КіберГір Україна"', '+380678899001', 'Владислав Романюк');
INSERT INTO trade.supplier (supplier_id, company_name, phone, contact_person) VALUES (15, 'ТОВ "Нетворк Трейд"', '+380442998877', 'Євгеній Сидоренко');
INSERT INTO trade.supplier (supplier_id, company_name, phone, contact_person) VALUES (16, 'ТОВ "ВайФай Експерт"', '+380501144778', NULL);
INSERT INTO trade.supplier (supplier_id, company_name, phone, contact_person) VALUES (17, 'ФОП Ковальов В.О. (CableMaster)', '+380971239876', 'Вадим Ковальов');
INSERT INTO trade.supplier (supplier_id, company_name, phone, contact_person) VALUES (18, 'ТОВ "Аксесуар Сервіс"', '+380634455889', 'Наталія Поліщук');
INSERT INTO trade.supplier (supplier_id, company_name, phone, contact_person) VALUES (19, 'ФОП Гнатюк І.С. (PowerHub)', '+380685552211', 'Ірина Гнатюк');
INSERT INTO trade.supplier (supplier_id, company_name, phone, contact_person) VALUES (20, 'ТОВ "ЕнергоТех Трейд"', '+380443332211', NULL);


--
-- TOC entry 5086 (class 0 OID 0)
-- Dependencies: 235
-- Name: product_product_id_seq; Type: SEQUENCE SET; Schema: trade; Owner: -
--

SELECT pg_catalog.setval('trade.product_product_id_seq', 201, true);


--
-- TOC entry 5087 (class 0 OID 0)
-- Dependencies: 239
-- Name: sale_item_sale_item_id_seq; Type: SEQUENCE SET; Schema: trade; Owner: -
--

SELECT pg_catalog.setval('trade.sale_item_sale_item_id_seq', 47, true);


--
-- TOC entry 5088 (class 0 OID 0)
-- Dependencies: 237
-- Name: sale_sale_id_seq; Type: SEQUENCE SET; Schema: trade; Owner: -
--

SELECT pg_catalog.setval('trade.sale_sale_id_seq', 20, true);


--
-- TOC entry 5089 (class 0 OID 0)
-- Dependencies: 233
-- Name: supplier_supplier_id_seq; Type: SEQUENCE SET; Schema: trade; Owner: -
--

SELECT pg_catalog.setval('trade.supplier_supplier_id_seq', 20, true);


--
-- TOC entry 4914 (class 2606 OID 24811)
-- Name: product product_pkey; Type: CONSTRAINT; Schema: trade; Owner: -
--

ALTER TABLE ONLY trade.product
    ADD CONSTRAINT product_pkey PRIMARY KEY (product_id);


--
-- TOC entry 4918 (class 2606 OID 24838)
-- Name: sale_item sale_item_pkey; Type: CONSTRAINT; Schema: trade; Owner: -
--

ALTER TABLE ONLY trade.sale_item
    ADD CONSTRAINT sale_item_pkey PRIMARY KEY (sale_item_id);


--
-- TOC entry 4916 (class 2606 OID 24827)
-- Name: sale sale_pkey; Type: CONSTRAINT; Schema: trade; Owner: -
--

ALTER TABLE ONLY trade.sale
    ADD CONSTRAINT sale_pkey PRIMARY KEY (sale_id);


--
-- TOC entry 4912 (class 2606 OID 24796)
-- Name: supplier supplier_pkey; Type: CONSTRAINT; Schema: trade; Owner: -
--

ALTER TABLE ONLY trade.supplier
    ADD CONSTRAINT supplier_pkey PRIMARY KEY (supplier_id);


--
-- TOC entry 4919 (class 2606 OID 24812)
-- Name: product product_supplier_id_fkey; Type: FK CONSTRAINT; Schema: trade; Owner: -
--

ALTER TABLE ONLY trade.product
    ADD CONSTRAINT product_supplier_id_fkey FOREIGN KEY (supplier_id) REFERENCES trade.supplier(supplier_id) ON DELETE RESTRICT;


--
-- TOC entry 4920 (class 2606 OID 24844)
-- Name: sale_item sale_item_product_id_fkey; Type: FK CONSTRAINT; Schema: trade; Owner: -
--

ALTER TABLE ONLY trade.sale_item
    ADD CONSTRAINT sale_item_product_id_fkey FOREIGN KEY (product_id) REFERENCES trade.product(product_id) ON DELETE RESTRICT;


--
-- TOC entry 4921 (class 2606 OID 24839)
-- Name: sale_item sale_item_sale_id_fkey; Type: FK CONSTRAINT; Schema: trade; Owner: -
--

ALTER TABLE ONLY trade.sale_item
    ADD CONSTRAINT sale_item_sale_id_fkey FOREIGN KEY (sale_id) REFERENCES trade.sale(sale_id) ON DELETE CASCADE;


-- Completed on 2026-09-26 15:38:13

--
-- PostgreSQL database dump complete
--

\unrestrict MsOAyEy1eRkD4cN5tSvbkd3TikRMDzXlA8Qd1C0PVekb8bq8XbIsGDcyuDWDanz


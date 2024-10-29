-- =============================================================================
-- Script SQL Unifié pour la Création et la Transformation des Données de la Supply Chain
-- =============================================================================

-- Description : Ce script crée toutes les tables nécessaires et effectue les
-- transformations de données pour le projet d'analyse de la supply chain.
-- =============================================================================

-- 0. **Création de la Base de Données**

CREATE DATABASE supply_chain_db;


-- 1. **Création des Tables**

-- 1.1. Table Principale des Données de la Supply Chain
CREATE TABLE IF NOT EXISTS DataCoSupplyChainDataset (
    Type VARCHAR(50),
    Days_for_shipping_real INT,
    Days_for_shipment_scheduled INT,
    Benefit_per_order DECIMAL(10,2),
    Sales_per_customer DECIMAL(10,2),
    Delivery_Status VARCHAR(50),
    Late_delivery_risk BOOLEAN,
    Category_Id INT,
    Category_Name VARCHAR(100),
    Customer_City VARCHAR(100),
    Customer_Country VARCHAR(100),
    Customer_Email VARCHAR(100),
    Customer_Fname VARCHAR(50),
    Customer_Id INT,
    Customer_Lname VARCHAR(50),
    Customer_Password VARCHAR(100),
    Customer_Segment VARCHAR(50),
    Customer_State VARCHAR(100),
    Customer_Street VARCHAR(200),
    Customer_Zipcode VARCHAR(20),
    Department_Id INT,
    Department_Name VARCHAR(100),
    Latitude DECIMAL(9,6),
    Longitude DECIMAL(9,6),
    Market VARCHAR(50),
    Order_City VARCHAR(100),
    Order_Country VARCHAR(100),
    Order_Customer_Id INT,
    order_date TIMESTAMP,
    Order_Id INT PRIMARY KEY,
    Order_Item_Cardprod_Id INT,
    Order_Item_Discount DECIMAL(10,2),
    Order_Item_Discount_Rate DECIMAL(5,2),
    Order_Item_Id INT,
    Order_Item_Product_Price DECIMAL(10,2),
    Order_Item_Profit_Ratio DECIMAL(5,2),
    Order_Item_Quantity INT,
    Sales DECIMAL(10,2),
    Order_Item_Total DECIMAL(10,2),
    Order_Profit_Per_Order DECIMAL(10,2),
    Order_Region VARCHAR(100),
    Order_State VARCHAR(100),
    Order_Status VARCHAR(50),
    Order_Zipcode VARCHAR(20),
    Product_Card_Id INT,
    Product_Category_Id INT,
    Product_Description TEXT,
    Product_Image TEXT,
    Product_Name VARCHAR(200),
    Product_Price DECIMAL(10,2),
    Product_Status BOOLEAN,
    shipping_date TIMESTAMP,
    Shipping_Mode VARCHAR(50)
);

-- 1.2. Table des Logs d'Accès
CREATE TABLE IF NOT EXISTS tokenized_access_logs (
    Product VARCHAR(100),
    Category VARCHAR(100),
    Date DATE,
    Month VARCHAR(10),
    Hour INT,
    Department VARCHAR(100),
    ip INET,
    url TEXT
);

-- 1.3. Table Temporaire des Abréviations des Pays 
CREATE TEMP TABLE IF NOT EXISTS country_abbreviations (
    country_name VARCHAR(100) PRIMARY KEY,
    abbreviation VARCHAR(10) NOT NULL
);

-- 1.4. Table Temporaire pour l'Importation des Données
CREATE TEMP TABLE IF NOT EXISTS temp_import (
    Type VARCHAR(50),
    Days_for_shipping_real INT,
    Days_for_shipment_scheduled INT,
    Benefit_per_order DECIMAL(10,2),
    Sales_per_customer DECIMAL(10,2),
    Delivery_Status VARCHAR(50),
    Late_delivery_risk BOOLEAN,
    Category_Id INT,
    Category_Name VARCHAR(100),
    Customer_City VARCHAR(100),
    Customer_Country VARCHAR(100),
    Customer_Email VARCHAR(100),
    Customer_Fname VARCHAR(50),
    Customer_Id INT,
    Customer_Lname VARCHAR(50),
    Customer_Password VARCHAR(100),
    Customer_Segment VARCHAR(50),
    Customer_State VARCHAR(100),
    Customer_Street VARCHAR(200),
    Customer_Zipcode VARCHAR(20),
    Department_Id INT,
    Department_Name VARCHAR(100),
    Latitude DECIMAL(9,6),
    Longitude DECIMAL(9,6),
    Market VARCHAR(50),
    Order_City VARCHAR(100),
    Order_Country VARCHAR(100),
    Order_Customer_Id INT,
    order_date TIMESTAMP,
    Order_Id INT,
    Order_Item_Cardprod_Id INT,
    Order_Item_Discount DECIMAL(10,2),
    Order_Item_Discount_Rate DECIMAL(5,2),
    Order_Item_Id INT,
    Order_Item_Product_Price DECIMAL(10,2),
    Order_Item_Profit_Ratio DECIMAL(5,2),
    Order_Item_Quantity INT,
    Sales DECIMAL(10,2),
    Order_Item_Total DECIMAL(10,2),
    Order_Profit_Per_Order DECIMAL(10,2),
    Order_Region VARCHAR(100),
    Order_State VARCHAR(100),
    Order_Status VARCHAR(50),
    Order_Zipcode VARCHAR(20),
    Product_Card_Id INT,
    Product_Category_Id INT,
    Product_Description TEXT,
    Product_Image TEXT,
    Product_Name VARCHAR(200),
    Product_Price DECIMAL(10,2),
    Product_Status BOOLEAN,
    shipping_date TIMESTAMP,
    Shipping_Mode VARCHAR(50)
) ON COMMIT DROP;

-- 2. **Insertion des Données de Référence**
-- -----------------------------------------------------------------------------

INSERT INTO country_abbreviations (country_name, abbreviation) VALUES
('united states', 'USA'),
('canada', 'CAN'),
('france', 'FRA'),
('germany', 'DEU'),
('japan', 'JPN'),
-- Ajoutez d'autres pays selon vos besoins
;

-- 3. **Transformation des Données**
-- -----------------------------------------------------------------------------

-- 3.1. Nettoyage des Données Critiques
DELETE FROM DataCoSupplyChainDataset
WHERE Customer_Email IS NULL
   OR Product_Name IS NULL
   OR Sales IS NULL;

-- 3.2. Standardisation des Noms de Pays
UPDATE DataCoSupplyChainDataset d
SET Order_Country = c.abbreviation
FROM country_abbreviations c
WHERE TRIM(LOWER(d.Order_Country)) = TRIM(LOWER(c.country_name));

-- 3.3. Identification des Pays Non Standardisés
-- C'est possible de commenter ou décommenter cette section selon vos besoins
/*
SELECT DISTINCT d.Order_Country
FROM DataCoSupplyChainDataset d
LEFT JOIN country_abbreviations c
ON TRIM(LOWER(d.Order_Country)) = TRIM(LOWER(c.country_name))
WHERE c.country_name IS NULL;
*/




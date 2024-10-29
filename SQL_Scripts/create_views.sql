-- =============================================================================
-- Script SQL pour la Création des Vues de la Supply Chain
-- =============================================================================


-- 1. **Vue des Ventes Année à Ce Jour (YTD)**
-- -----------------------------------------------------------------------------
CREATE OR REPLACE VIEW Sales_YTD_View AS
SELECT
    *
FROM
    DataCoSupplyChainDataset
WHERE
    EXTRACT(YEAR FROM order_date) IN (2016, 2017);

-- 2. **Vue des Revenus YTD vs PRY + YTG**
-- -----------------------------------------------------------------------------
CREATE OR REPLACE VIEW revenu_ytd_pry AS
SELECT
    EXTRACT(YEAR FROM order_date) AS Annee,
    SUM(Sales) FILTER (WHERE EXTRACT(YEAR FROM order_date) = 2017) AS YTD_Revenu,
    SUM(Sales) FILTER (WHERE EXTRACT(YEAR FROM order_date) = 2016) AS PRY_Revenu
FROM
    Sales_YTD_View
GROUP BY
    EXTRACT(YEAR FROM order_date);

-- 3. **Vue des Détails par Catégorie**
-- -----------------------------------------------------------------------------
CREATE OR REPLACE VIEW dets AS
SELECT
    Category_Name AS Categorie,
    SUM(Order_Item_Quantity) AS Quantites_Achetees,
    SUM(Sales) AS Revenu_Total,
    ROUND(
        (SUM(Sales) FILTER (WHERE EXTRACT(YEAR FROM order_date) = 2017) 
         - SUM(Sales) FILTER (WHERE EXTRACT(YEAR FROM order_date) = 2016))
        / SUM(Sales) FILTER (WHERE EXTRACT(YEAR FROM order_date) = 2016) * 100, 
        2
    ) AS Delta_PRY
FROM
    Sales_YTD_View
GROUP BY
    Category_Name;

-- 4. **Vue des Ventes YTD par Année et Mois**
-- -----------------------------------------------------------------------------
CREATE OR REPLACE VIEW ytd_ventes_annee_mois_view AS
SELECT
    EXTRACT(YEAR FROM order_date) AS Annee,
    EXTRACT(MONTH FROM order_date) AS Mois,
    SUM(Sales) AS YTD_Ventes
FROM
    Sales_YTD_View
GROUP BY
    EXTRACT(YEAR FROM order_date),
    EXTRACT(MONTH FROM order_date);

-- 5. **Vue des Ventes YTD PRY et Différence en %**
-- -----------------------------------------------------------------------------
CREATE OR REPLACE VIEW ytd_ventes_pry AS
SELECT
    EXTRACT(YEAR FROM order_date) AS Annee,
    (
        SUM(Sales) FILTER (WHERE EXTRACT(YEAR FROM order_date) = 2017) 
        - SUM(Sales) FILTER (WHERE EXTRACT(YEAR FROM order_date) = 2016)
    ) / SUM(Sales) FILTER (WHERE EXTRACT(YEAR FROM order_date) = 2016) * 100 AS Delta_PRY
FROM
    Sales_YTD_View
GROUP BY
    EXTRACT(YEAR FROM order_date);

-- 6. **Vue des Quantités Vendues YTD PRY et Différence en %**
-- -----------------------------------------------------------------------------
CREATE OR REPLACE VIEW ytd_quantite_vendue_pry AS
SELECT
    EXTRACT(YEAR FROM order_date) AS Annee,
    (
        SUM(Order_Item_Quantity) FILTER (WHERE EXTRACT(YEAR FROM order_date) = 2017) 
        - SUM(Order_Item_Quantity) FILTER (WHERE EXTRACT(YEAR FROM order_date) = 2016)
    ) / SUM(Order_Item_Quantity) FILTER (WHERE EXTRACT(YEAR FROM order_date) = 2016) * 100 AS Delta_PRY_Quantite
FROM
    Sales_YTD_View
GROUP BY
    EXTRACT(YEAR FROM order_date);

-- 7. **Vue des Ventes YTD par Catégorie et Année**
-- -----------------------------------------------------------------------------
CREATE OR REPLACE VIEW ytd_ventes_par_categorie_annee_view AS
SELECT
    Category_Name AS Categorie,
    EXTRACT(YEAR FROM order_date) AS Annee,
    SUM(Sales) AS YTD_Ventes
FROM
    Sales_YTD_View
GROUP BY
    Category_Name,
    EXTRACT(YEAR FROM order_date);

-- 8. **Vue des Ventes YTD par Pays et Année**
-- -----------------------------------------------------------------------------
CREATE OR REPLACE VIEW ytd_ventes_par_pays_annee_view AS
SELECT
    Order_Country AS Pays,
    EXTRACT(YEAR FROM order_date) AS Annee,
    SUM(Sales) AS YTD_Ventes
FROM
    Sales_YTD_View
GROUP BY
    Order_Country,
    EXTRACT(YEAR FROM order_date);

-- 9. **Vue des Top 10 Produits par Fabricant**
-- -----------------------------------------------------------------------------
CREATE OR REPLACE VIEW top_10_produits_par_fabricant_view AS
SELECT
    Department_Name AS Fabricant,
    Product_Name AS Produit,
    SUM(Sales) AS Total_Ventes
FROM
    Sales_YTD_View
GROUP BY
    Department_Name,
    Product_Name
ORDER BY
    Total_Ventes DESC
LIMIT 10;

-- 10. **Vue des Top 10 Produits par Ventes**
-- -----------------------------------------------------------------------------
CREATE OR REPLACE VIEW top_10_produits_par_ventes_view AS
SELECT
    Product_Name AS Produit,
    SUM(Sales) AS Total_Ventes
FROM
    Sales_YTD_View
GROUP BY
    Product_Name
ORDER BY
    Total_Ventes DESC
LIMIT 10;

-- 11. **Vue de la Valeur Vie Client Moyenne**
-- -----------------------------------------------------------------------------
CREATE OR REPLACE VIEW valeur_vie_client_moyenne AS
SELECT
    Customer_Id,
    AVG(Sales) AS Valeur_Vie_Client_Moyenne
FROM
    Sales_YTD_View
GROUP BY
    Customer_Id;

-- 12. **Vue des Catégories Préférées des Clients**
-- -----------------------------------------------------------------------------
CREATE OR REPLACE VIEW categories_preferees_clients AS
SELECT
    Customer_Id,
    Category_Name AS Categorie_Preferee,
    COUNT(*) AS Nombre_Transactions
FROM
    Sales_YTD_View
GROUP BY
    Customer_Id,
    Category_Name
ORDER BY
    Nombre_Transactions DESC;

-- 13. **Vue du Revenu par Segment de Client**
-- -----------------------------------------------------------------------------
CREATE OR REPLACE VIEW public.revenu_par_segment_client AS
SELECT
    Customer_Segment AS Segment,
    SUM(Sales) AS Revenu_Total
FROM
    Sales_YTD_View
GROUP BY
    Customer_Segment;

-- 14. **Vue des Nouveaux vs Récurrents Clients**
-- -----------------------------------------------------------------------------
CREATE OR REPLACE VIEW nouveaux_vs_recurrent_clients AS
SELECT
    EXTRACT(MONTH FROM order_date) AS Mois,
    CASE
        WHEN MIN(order_date) OVER (PARTITION BY Customer_Id) = order_date THEN 'Nouveaux Clients'
        ELSE 'Clients Récurrents'
    END AS Type_Client,
    SUM(Sales) AS Revenu
FROM
    Sales_YTD_View
GROUP BY
    Mois,
    Type_Client;

-- 15. **Vue des Top 10 Clients par Revenu**
-- -----------------------------------------------------------------------------
CREATE OR REPLACE VIEW top_10_clients_par_revenu AS
SELECT
    Customer_Id,
    SUM(Sales) AS Revenu_Total
FROM
    Sales_YTD_View
GROUP BY
    Customer_Id
ORDER BY
    Revenu_Total DESC
LIMIT 10;

-- 16. **Vue de la Distribution Géographique des Clients**
-- -----------------------------------------------------------------------------
CREATE OR REPLACE VIEW distribution_geographique_clients AS
SELECT
    Customer_City AS Ville,
    SUM(Sales) AS Revenu_Total
FROM
    Sales_YTD_View
GROUP BY
    Customer_City;



# 📦 Analyse de la Supply Chain avec Power BI et SQL

## 📖 Aperçu du Projet
Ce projet présente une analyse complète des données de la supply chain de 2016 à 2017, en se concentrant sur la performance des ventes, les produits les plus vendus, et le comportement des clients. L'objectif est de découvrir des informations sur la répartition des revenus, les préférences des clients, et les tendances de ventes géographiques pour aider à la prise de décisions stratégiques.

## 🎯 Objectifs Clés
- Identifier les catégories de produits les plus performantes
- Analyser la fidélité des clients et identifier les segments les plus rentables
- Optimiser la visualisation des données pour fournir des insights utiles

## 🛠️ Technologies Utilisées
- SQL (PostgreSQL) pour l'extraction et la transformation des données
- Power BI pour la visualisation et les tableaux de bord interactifs

## 📊 Modélisation des Données & SQL

### 🔍 Création des Vues SQL
Plusieurs vues SQL ont été créées pour une analyse détaillée, transformant les données brutes en informations exploitables.

#### Exemple : Vue des Ventes par Catégorie
    CREATE OR REPLACE VIEW Sales_Per_Category_View AS
    SELECT
        Category_Name,
        SUM(Sales) AS Total_Sales,
        AVG(Sales) AS Average_Sales
    FROM
        DataCoSupplyChainDataset
    GROUP BY
        Category_Name;

Cette vue permet d'analyser les ventes totales et la moyenne des ventes par catégorie, offrant une vue d'ensemble sur les performances des différentes lignes de produits.

## 📂 Extraits de Code SQL Importants

### Vue pour les Ventes Année à Ce Jour (YTD)
    CREATE OR REPLACE VIEW Sales_YTD_View AS
    SELECT *
    FROM DataCoSupplyChainDataset
    WHERE EXTRACT(YEAR FROM order_date) IN (2016, 2017);

### Top 10 Clients par Revenu
    CREATE OR REPLACE VIEW Top_10_Clients_Par_Revenu AS
    SELECT
        CONCAT(Customer_Fname, ' ', Customer_Lname) AS Nom_Client,
        SUM(Sales) AS Revenu_Total
    FROM
        Sales_YTD_View
    GROUP BY
        Customer_Fname, Customer_Lname
    ORDER BY
        Revenu_Total DESC
    LIMIT 10;

## 📈 Tableau de Bord Power BI

### 🗂️ Description des Pages Power BI

#### Page 1 : Accueil
Cette page offre une vue d'ensemble simplifiée de la supply chain.

- **Graphique en Colonnes** : À gauche, un graphique compare les revenus entre 2016 et 2017, montrant clairement une augmentation de 4,2 M$ à 5,4 M$.
- **Graphique en Barres Horizontales** : À droite, un graphique affiche les revenus par catégorie de produits, trié pour montrer les meilleures catégories en termes de revenus. La catégorie "Fishing" est en tête avec 1,82 M$.

#### Page 2 : Aperçu des Revenus
- **Graphique Linéaire** : Présente les revenus mensuels pour 2016 et 2017, permettant de visualiser les variations saisonnières, comme des pics importants en octobre.

##### Tableau de Comparaison YTD (Year-To-Date) :
| Période  | Revenus (M$) |
|----------|--------------|
| YTD ACT  | 5,4          |
| YTD PRY  | 4,2          | 

Compare les revenus de l'année actuelle à ceux de l'année précédente pour mesurer la variation de -23 %.

- **Top 3 Catégories et Pays** : Deux graphiques en barres horizontales montrent les variations de ventes des principales catégories et pays. Par exemple, les catégories "Fishing", "Water Sports", et "Cleats" ont toutes enregistré des baisses notables.

- **Top 5 Produits et Fabricants** : Les visualisations indiquent les fabricants et les produits les plus rentables. "Fan Shop" a généré le plus de revenus (1,83 M$) et le produit "Field & Stream" a la plus forte augmentation des revenus à 134,7 %.

#### Page 3 : Détails par Catégorie
- **Jauge de Valeur Vie Client (CLV)** : Affiche une valeur moyenne du client à 535,82, aidant à comprendre la valeur totale qu'un client apporte durant sa relation avec l'entreprise.

- **Quantités Achetées par Catégorie** : Un graphique en barres montrant les quantités vendues dans différentes catégories, aidant à évaluer la popularité de chaque catégorie.

- **Clients Nouveaux vs Récurrents** :

| Type de Client      | Revenus (M$) |
|---------------------|--------------|
| Nouveaux Clients    | 4,5          |
| Clients Récurrents  | 5,1          |

Comprendre l'impact respectif sur les revenus.

- **Top 10 Clients par Revenu** :

| Rang  | Nom du Client   | Revenu Total (K$)     | Nombre de Commandes | Fréquence Mensuelle |
|-------|-----------------|-----------------------|---------------------|---------------------|
| 1     | Mary Smith      | 1,051.1               | 15                  | 1,25                |
| 2     | Robert Smith    | 34.2                  | 15                  | 1,25                |
| 3     | David Smith     | 30.0                  | 15                  | 1,25                |
| 4     | James Smith     | 29.4                  | 15                  | 1,25                |
| 5     | John Smith      | 27.9                  | 15                  | 1,25                |
| 6     | William Smith   | 20.8                  | 15                  | 1,25                |
| 7     | Andrew Smith    | 20.5                  | 15                  | 1,25                |
| 8     | Elizabeth Smith | 19.6                  | 15                  | 1,25                |
| 9     | Michael Smith   | 18.5                  | 15                  | 1,25                |
| 10    | Mary Jones      | 18.5                  | 15                  | 1,25                |

- **Carte Géographique des Revenus** : Montre la répartition des revenus par ville, identifiant les régions à plus fort potentiel.

### 🌟 Principales Visualisations

![Page Accueil](images/page_accueil.png)
*Cette capture d'écran montre la page d'accueil avec une vue d'ensemble simplifiée de la supply chain.*

![Page Aperçu des Revenus](images/page_apercu_revenus.png)
*Cette capture d'écran montre la page "Aperçu des Revenus" avec les graphiques détaillés des revenus mensuels et les comparaisons YTD.*

![Page Détails par Catégorie](images/page_details_categorie.png)
*Cette capture d'écran montre la page "Détails par Catégorie" avec des visualisations approfondies sur les catégories de produits et les clients.*

## 📌 Principaux Enseignements
- **Performance des Ventes** : Les ventes sont passées de 4,2 M$ en 2016 à 5,4 M$ en 2017, indiquant une croissance positive.
- **Comportement des Clients** : Les 10 meilleurs clients ont contribué de manière significative aux revenus totaux, mettant en avant l'importance de la fidélisation.
- **Informations sur les Produits** : Les catégories "Fishing" et "Water Sports" étaient parmi les plus performantes, avec des schémas de ventes saisonniers notables.
- **Analyse des Délais de Livraison** : 15 % des commandes ont été livrées en retard, impactant la satisfaction client.

## 🚀 Utilisation Pratique
- **Optimisation des Stocks** : S'assurer que les produits populaires sont toujours en stock.
- **Amélioration de la Satisfaction Client** : Réduire les retards de livraison en optimisant la logistique.
- **Campagnes Marketing Ciblées** : Développer des campagnes personnalisées basées sur les données produits et clients.
- **Décisions Stratégiques** : Aider les décideurs à prioriser les investissements dans les segments les plus rentables.

## ⚙️ Comment Exécuter le Projet

### Base de Données SQL
- Importez le script SQL depuis le dossier `SQL_Scripts/` dans votre environnement PostgreSQL.
- Assurez-vous que le fichier `DataCoSupplyChainDataset.csv` est placé dans le dossier `Data/` et est accessible pour l'importation.

### Rapport Power BI
- Ouvrez le fichier `SupplyChainAnalysis.pbix` dans le dossier `PowerBI_Report/` avec Power BI Desktop.
- Actualisez les sources de données si nécessaire.

## 📁 Fichiers Inclus
- **SQL_Scripts/**
  - `setup_and_transform.sql` : Script unifié pour créer et transformer les données.
  - `create_views.sql` : Script pour créer les vues.
- **PowerBI_Report/**
  - `SupplyChainAnalysis.pbix` : Fichier Power BI avec les visualisations interactives.
- **Images/**
  - `page_accueil.png` : Capture d'écran de la page d'accueil.
  - `page_apercu_revenus.png` : Capture d'écran de la page "Aperçu des Revenus".
  - `page_details_categorie.png` : Capture d'écran de la page "Détails par Catégorie".
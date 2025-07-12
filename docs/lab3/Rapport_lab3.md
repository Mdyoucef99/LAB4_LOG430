- Nom : Youcef mekki daouadji  LOG430-01 
- Code permanent : MEKY03039908
- URL github : mdyoucef99/LAB3_LOG430

# Rapport pour le LABO3 LOG430 :  

Voici la liste des principaux endpoints exposés par l'API du projet Lab 3.
---

## **Produits**

### GET /api/v1/products
- **Description :** Récupère la liste de tous les produits.
- **Réponse :** Tableau de produits.

### POST /api/v1/products
- **Description :** Ajoute un nouveau produit.
- **Body :**
  - `nom` (string) : nom du produit
  - `prix` (float) : prix du produit
- **Réponse :** Produit créé

### GET /api/v1/products/{id}
- **Description :** Récupère un produit par son identifiant.
- **Paramètre :**
  - `id` (path, integer) : identifiant du produit
- **Réponse :** Détail du produit


---

## **Stock**

### GET /api/v1/stock
- **Description :** Récupère le stock de tous les produits.
- **Réponse :** Tableau de stocks

### GET /api/v1/stock/{produitId}
- **Description :** Récupère le stock d'un produit spécifique.
- **Paramètre :**
  - `produitId` (path, integer)
- **Réponse :** Détail du stock

---

## **Ventes**

### GET /api/v1/sales
- **Description :** Liste toutes les ventes.
- **Réponse :** Tableau de ventes

---

## **Rapports**

### GET /api/v1/reports/sales
- **Description :** Génère un rapport de ventes consolidé.
- **Réponse :** Rapport de ventes (totaux, etc.)

---

## **Dashboard**

### GET /api/v1/dashboard
- **Description :** Vue d'ensemble du dashboard (statistiques globales).
- **Réponse :** Données agrégées (nombre de produits, ventes, stock total, etc.)

---

## Captures d'écran Postman

Voici les captures d'écran des tests Postman pour chaque endpoint :

### Endpoints Produits
![Tests des endpoints produits](docs/screenshots/products.png)

### Endpoints Stock
![Tests des endpoints stock](docs/screenshots/stock.png)

### Endpoints Ventes
![Tests des endpoints ventes](docs/screenshots/sales.png)

### Dashboard
![Tests du dashboard](docs/screenshots/dashboards.png)

---

*Pour plus de détails sur les schémas de données, voir le fichier swagger.yaml.*




package com.lab4.Rest;

import com.lab4.dao.SaleDao;
import com.lab4.dao.StoreDao;
import com.lab4.dao.ProduitDao;
import com.lab4.dao.StockDao;
import com.lab4.Model.SaleReport;
import org.springframework.web.bind.annotation.*;
import org.springframework.http.ResponseEntity;
import org.springframework.http.HttpStatus;
import java.sql.SQLException;
import java.util.List;

@RestController
@RequestMapping("/api/v1/reports")
public class ReportRestController {
    private final SaleDao saleDao;
    private final StoreDao storeDao;
    private final ProduitDao produitDao;
    private final StockDao stockDao;

    public ReportRestController() {
        try {
            String host = System.getenv().getOrDefault("DB_HOST", "localhost");
            String databaseUrl = "jdbc:postgresql://" + host + ":5432/magasin";
            String user = "magasin_user";
            String password = "magasinpswd";
            com.j256.ormlite.support.ConnectionSource cs = new com.j256.ormlite.jdbc.JdbcConnectionSource(databaseUrl, user, password);
            this.saleDao = new SaleDao(cs);
            this.storeDao = new StoreDao(cs);
            this.produitDao = new ProduitDao(cs);
            this.stockDao = new StockDao(cs);
        } catch (SQLException e) {
            throw new RuntimeException("Erreur d'initialisation de la connexion à la base", e);
        }
    }

    @GetMapping("/sales")
    public ResponseEntity<List<SaleReport>> getConsolidatedSalesReport() {
        try {
            List<SaleReport> report = saleDao.consolidatedReport(storeDao, produitDao);
            return ResponseEntity.ok(report);
        } catch (SQLException e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }
} 
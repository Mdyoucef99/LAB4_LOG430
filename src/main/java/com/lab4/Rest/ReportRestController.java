package com.lab4.Rest;

import com.lab4.dao.SaleDao;
import com.lab4.dao.StoreDao;
import com.lab4.dao.ProduitDao;
import com.lab4.dao.StockDao;
import com.lab4.Model.SaleReport;
import org.springframework.web.bind.annotation.*;
import org.springframework.http.ResponseEntity;
import org.springframework.http.HttpStatus;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import java.sql.SQLException;
import java.util.List;

@RestController
@RequestMapping("/api/v1/reports")
@Tag(name = "Rapports", description = "API pour la génération de rapports")
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
    @Operation(summary = "Rapport de ventes consolidé", description = "Génère un rapport consolidé des ventes par magasin et produit")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Rapport généré avec succès",
                    content = @Content(mediaType = "application/json", 
                    schema = @Schema(implementation = SaleReport.class))),
        @ApiResponse(responseCode = "500", description = "Erreur interne du serveur")
    })
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
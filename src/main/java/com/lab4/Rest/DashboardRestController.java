package com.lab4.Rest;

import com.lab4.Controller.DashboardController;
import com.lab4.dao.StoreDao;
import com.lab4.dao.ProduitDao;
import com.lab4.dao.StockDao;
import com.lab4.dao.SaleDao;
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
import java.util.Map;
import com.j256.ormlite.jdbc.JdbcConnectionSource;
import com.j256.ormlite.support.ConnectionSource;

@RestController
@RequestMapping("/api/v1/dashboard")
@Tag(name = "Dashboard", description = "API pour les données du tableau de bord")
public class DashboardRestController {
    private final DashboardController dashboardController;

    public DashboardRestController() {
        try {
            String host = System.getenv().getOrDefault("DB_HOST", "localhost");
            String databaseUrl = "jdbc:postgresql://" + host + ":5432/magasin";
            String user = "magasin_user";
            String password = "magasinpswd";
            ConnectionSource cs = new JdbcConnectionSource(databaseUrl, user, password);
            StoreDao storeDao = new StoreDao(cs);
            ProduitDao produitDao = new ProduitDao(cs);
            StockDao stockDao = new StockDao(cs);
            SaleDao saleDao = new SaleDao(cs);
            this.dashboardController = new DashboardController(storeDao, produitDao, stockDao, saleDao);
        } catch (SQLException e) {
            throw new RuntimeException("Erreur d'initialisation de la connexion à la base", e);
        }
    }

    @GetMapping
    @Operation(summary = "Récupérer les données du dashboard", description = "Retourne les statistiques consolidées du tableau de bord")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Données du dashboard récupérées avec succès",
                    content = @Content(mediaType = "application/json", 
                    schema = @Schema(description = "Map contenant les données du dashboard"))),
        @ApiResponse(responseCode = "500", description = "Erreur interne du serveur")
    })
    public ResponseEntity<Map<String, Object>> getDashboard() {
        try {
            Map<String, Object> dashboard = dashboardController.getDashboardData();
            return ResponseEntity.ok(dashboard);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }
} 
package com.lab4.Rest;

import com.lab4.Model.Produit;
import com.lab4.dao.ProduitDao;
import com.j256.ormlite.jdbc.JdbcConnectionSource;
import com.j256.ormlite.support.ConnectionSource;   
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.sql.SQLException;
import java.util.List;

@RestController
@RequestMapping("/api/v1/products")
public class ProduitRestController {
    private final ProduitDao produitDao;

    public ProduitRestController() {
        try {
            String host = System.getenv().getOrDefault("DB_HOST", "localhost");
            String databaseUrl = "jdbc:postgresql://" + host + ":5432/magasin";
            String user = "magasin_user";
            String password = "magasinpswd";
            ConnectionSource cs = new JdbcConnectionSource(databaseUrl, user, password);
            this.produitDao = new ProduitDao(cs);
        } catch (SQLException e) {
            throw new RuntimeException("Erreur d'initialisation de la connexion à la base", e);
        }
    }

    @GetMapping
    public ResponseEntity<List<Produit>> getAll() {
        try {
            return ResponseEntity.ok(produitDao.getInventaire());
        } catch (SQLException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

    @GetMapping("/{id}")
    public ResponseEntity<Produit> getById(@PathVariable("id") int id) {
        try {
            Produit p = produitDao.rechercherParId(id);
            if (p == null) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
            }
            return ResponseEntity.ok(p);
        } catch (SQLException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

    @PostMapping
    public ResponseEntity<Produit> create(@RequestBody Produit produit) {
        try {
            produitDao.ajouterProduit(produit);
            return ResponseEntity.status(HttpStatus.CREATED).body(produit);
        } catch (SQLException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<Produit> update(@PathVariable("id") int id, @RequestBody Produit produit) {
        try {
            Produit existing = produitDao.rechercherParId(id);
            if (existing == null) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
            }
            // Met à jour les champs
            existing.setNom(produit.getNom());
            existing.setCategorie(produit.getCategorie());
            existing.setPrix(produit.getPrix());
            existing.setQuantite(produit.getQuantite());
            produitDao.ajouterProduit(existing); // createIfNotExists fait update si existe
            return ResponseEntity.ok(existing);
        } catch (SQLException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable("id") int id) {
        try {
            Produit existing = produitDao.rechercherParId(id);
            if (existing == null) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
            }
            // Suppression via DAO (à ajouter si besoin)
            produitDao.getDao().deleteById(id);
            return ResponseEntity.noContent().build();
        } catch (SQLException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
} 
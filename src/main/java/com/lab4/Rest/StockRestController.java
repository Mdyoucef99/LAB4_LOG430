package com.lab4.Rest;

import com.lab4.dao.StockDao;
import com.lab4.dao.StoreDao;
import com.lab4.Model.Stock;
import com.lab4.Model.Store;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.*;
import org.springframework.http.ResponseEntity;
import org.springframework.http.HttpStatus;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Component;
import org.springframework.beans.factory.annotation.Autowired;

@RestController
@RequestMapping("/api/v1/stores")
public class StockRestController {
    private final StockDao stockDao;
    private final StoreDao storeDao;
    private static final Logger logger = LoggerFactory.getLogger(StockRestController.class);

    @Autowired
    public StockRestController(StockDao stockDao, StoreDao storeDao) {
        this.stockDao = stockDao;
        this.storeDao = storeDao;
    }

    @GetMapping("/{id}/stock")
    public ResponseEntity<List<Stock>> getStockByStore(@PathVariable("id") int id) {
        logger.info("Received request to get stock for store with id: {}", id);
        try {
            Store store = storeDao.findById(id);
            if (store == null) {
                logger.info("Store with id {} not found", id);
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
            }
            List<Stock> stocks = stockDao.listByStore(store);
            logger.info("Stock retrieved successfully for store with id: {}", id);
            return ResponseEntity.ok(stocks);
        } catch (SQLException e) {
            logger.error("Error retrieving stock for store with id: {}", id, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }
} 

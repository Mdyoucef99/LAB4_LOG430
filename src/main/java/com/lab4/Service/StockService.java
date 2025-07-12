package com.lab4.Service;

import java.sql.SQLException;

import com.lab4.dao.*;
import com.lab4.Model.Produit;
import com.lab4.Model.Store;

public class StockService {
    private final StockDao stockDao;
    public StockService(StockDao stockDao) {
        this.stockDao = stockDao;
    }
    public void reorder(Store central, Store store, Produit p, int quantity) throws SQLException {
        stockDao.updateQuantity(central, p, -quantity);
        stockDao.updateQuantity(store, p, quantity);
    }
    
}
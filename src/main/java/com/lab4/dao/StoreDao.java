package com.lab4.dao;


import java.sql.SQLException;
import java.util.List;
import com.j256.ormlite.dao.Dao;
import com.j256.ormlite.dao.DaoManager;
import com.j256.ormlite.support.ConnectionSource;
import org.springframework.stereotype.Component;
import org.springframework.beans.factory.annotation.Autowired;

import com.lab4.Model.Store;

@Component
public class StoreDao {
    private final Dao<Store,Integer> dao;

    @Autowired
    public StoreDao(com.j256.ormlite.support.ConnectionSource cs) throws SQLException {
        this.dao = DaoManager.createDao(cs, Store.class);
    }

      public Dao<Store,Integer> getDao() {
        return dao;
    }

    public List<Store> listAll() throws SQLException {
        return dao.queryForAll();
    }

    public Store findById(int id) throws SQLException {
        return dao.queryForId(id);
    }

    public void create(Store s) throws SQLException {
        dao.create(s);
    }

}
package com.lab4.Rest;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import com.j256.ormlite.jdbc.JdbcConnectionSource;
import com.j256.ormlite.support.ConnectionSource;
import java.sql.SQLException;

@Configuration
public class DatabaseConfig {
    @Bean
    public ConnectionSource connectionSource() throws SQLException {
        String host = System.getenv().getOrDefault("DB_HOST", "localhost");
        String databaseUrl = "jdbc:postgresql://" + host + ":5432/magasin";
        String user = "magasin_user";
        String password = "magasinpswd";
        return new JdbcConnectionSource(databaseUrl, user, password);
    }
} 
package com.lab4.Rest;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication(scanBasePackages = {"com.lab4.Rest", "com.lab4.dao", "com.lab4.Service", "com.lab4.Model", "com.lab4.Controller"})
public class ApiApplication {
    public static void main(String[] args) {
        SpringApplication.run(ApiApplication.class, args);
    }
} 
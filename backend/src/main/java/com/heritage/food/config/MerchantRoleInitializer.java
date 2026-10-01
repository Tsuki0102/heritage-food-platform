package com.heritage.food.config;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;

@Component
public class MerchantRoleInitializer {

    private final JdbcTemplate jdbcTemplate;

    public MerchantRoleInitializer(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    @PostConstruct
    public void ensureMerchantRole() {
        jdbcTemplate.update("""
                INSERT INTO tb_role (role_name, role_key, description, status, create_time, update_time)
                SELECT ?, ?, ?, 1, NOW(), NOW()
                FROM DUAL
                WHERE NOT EXISTS (
                    SELECT 1 FROM tb_role WHERE role_key = ?
                )
                """, "商家", "merchant", "平台入驻商家角色", "merchant");
    }
}

package com.heritage.food.config;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;

@Component
public class MerchantSchemaInitializer {

    private final JdbcTemplate jdbcTemplate;

    public MerchantSchemaInitializer(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    @PostConstruct
    public void ensureMerchantSchema() {
        jdbcTemplate.execute("""
                CREATE TABLE IF NOT EXISTS tb_merchant_profile (
                    id BIGINT NOT NULL AUTO_INCREMENT,
                    user_id BIGINT NOT NULL,
                    store_name VARCHAR(100) NOT NULL,
                    store_status VARCHAR(20) NOT NULL DEFAULT 'active',
                    commission_rate DECIMAL(10,2) NOT NULL DEFAULT 12.00,
                    heritage_certified TINYINT(1) NOT NULL DEFAULT 0,
                    settlement_amount DECIMAL(12,2) NOT NULL DEFAULT 0.00,
                    withdraw_pending DECIMAL(12,2) NOT NULL DEFAULT 0.00,
                    last_settlement_at DATETIME DEFAULT NULL,
                    contact_name VARCHAR(50) DEFAULT NULL,
                    contact_phone VARCHAR(30) DEFAULT NULL,
                    introduction TEXT DEFAULT NULL,
                    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
                    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                    PRIMARY KEY (id),
                    UNIQUE KEY uk_merchant_profile_user_id (user_id)
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
                """);

        jdbcTemplate.execute("""
                CREATE TABLE IF NOT EXISTS tb_merchant_product_submission (
                    id BIGINT NOT NULL AUTO_INCREMENT,
                    user_id BIGINT NOT NULL,
                    merchant_name VARCHAR(100) NOT NULL,
                    product_name VARCHAR(100) NOT NULL,
                    category VARCHAR(50) DEFAULT NULL,
                    price DECIMAL(12,2) NOT NULL DEFAULT 0.00,
                    heritage_tag VARCHAR(100) DEFAULT NULL,
                    description TEXT DEFAULT NULL,
                    submitted_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                    status VARCHAR(20) NOT NULL DEFAULT 'pending',
                    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
                    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                    PRIMARY KEY (id),
                    KEY idx_merchant_product_user_id (user_id)
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
                """);

        jdbcTemplate.execute("""
                CREATE TABLE IF NOT EXISTS tb_merchant_content_submission (
                    id BIGINT NOT NULL AUTO_INCREMENT,
                    user_id BIGINT NOT NULL,
                    merchant_name VARCHAR(100) NOT NULL,
                    title VARCHAR(150) NOT NULL,
                    content_type VARCHAR(50) DEFAULT NULL,
                    risk_point VARCHAR(150) DEFAULT NULL,
                    content TEXT DEFAULT NULL,
                    submitted_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                    status VARCHAR(20) NOT NULL DEFAULT 'pending',
                    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
                    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                    PRIMARY KEY (id),
                    KEY idx_merchant_content_user_id (user_id)
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
                """);

        jdbcTemplate.execute("""
                CREATE TABLE IF NOT EXISTS tb_merchant_settlement (
                    id BIGINT NOT NULL AUTO_INCREMENT,
                    user_id BIGINT NOT NULL,
                    merchant_name VARCHAR(100) NOT NULL,
                    period VARCHAR(100) NOT NULL,
                    order_count INT NOT NULL DEFAULT 0,
                    turnover DECIMAL(12,2) NOT NULL DEFAULT 0.00,
                    commission_amount DECIMAL(12,2) NOT NULL DEFAULT 0.00,
                    payable_amount DECIMAL(12,2) NOT NULL DEFAULT 0.00,
                    status VARCHAR(20) NOT NULL DEFAULT 'pending',
                    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
                    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                    PRIMARY KEY (id),
                    KEY idx_merchant_settlement_user_id (user_id)
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
                """);

        jdbcTemplate.execute("""
                CREATE TABLE IF NOT EXISTS tb_merchant_withdrawal (
                    id BIGINT NOT NULL AUTO_INCREMENT,
                    user_id BIGINT NOT NULL,
                    merchant_name VARCHAR(100) NOT NULL,
                    amount DECIMAL(12,2) NOT NULL DEFAULT 0.00,
                    account_name VARCHAR(100) NOT NULL,
                    account_no VARCHAR(100) NOT NULL,
                    submitted_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                    status VARCHAR(20) NOT NULL DEFAULT 'pending',
                    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
                    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                    PRIMARY KEY (id),
                    KEY idx_merchant_withdrawal_user_id (user_id)
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
                """);

        jdbcTemplate.execute("""
                CREATE TABLE IF NOT EXISTS tb_merchant_onboarding_application (
                    id BIGINT NOT NULL AUTO_INCREMENT,
                    user_id BIGINT DEFAULT NULL,
                    applicant_name VARCHAR(50) NOT NULL,
                    phone VARCHAR(30) NOT NULL,
                    store_name VARCHAR(100) NOT NULL,
                    category VARCHAR(100) DEFAULT NULL,
                    region VARCHAR(50) DEFAULT NULL,
                    submitted_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                    note VARCHAR(500) DEFAULT NULL,
                    attachment_urls TEXT DEFAULT NULL,
                    status VARCHAR(20) NOT NULL DEFAULT 'pending',
                    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
                    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                    PRIMARY KEY (id)
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
                """);

        jdbcTemplate.execute("""
                CREATE TABLE IF NOT EXISTS tb_merchant_qualification_application (
                    id BIGINT NOT NULL AUTO_INCREMENT,
                    user_id BIGINT DEFAULT NULL,
                    merchant_name VARCHAR(100) NOT NULL,
                    project_name VARCHAR(150) NOT NULL,
                    certificate_no VARCHAR(100) DEFAULT NULL,
                    issuer VARCHAR(150) DEFAULT NULL,
                    submitted_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                    note VARCHAR(500) DEFAULT NULL,
                    attachment_urls TEXT DEFAULT NULL,
                    status VARCHAR(20) NOT NULL DEFAULT 'pending',
                    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
                    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                    PRIMARY KEY (id)
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
                """);

        jdbcTemplate.execute("""
                CREATE TABLE IF NOT EXISTS tb_merchant_review_audit (
                    id BIGINT NOT NULL AUTO_INCREMENT,
                    user_id BIGINT DEFAULT NULL,
                    user_name VARCHAR(100) NOT NULL,
                    merchant_name VARCHAR(100) NOT NULL,
                    content VARCHAR(500) NOT NULL,
                    hit_words VARCHAR(255) DEFAULT NULL,
                    submitted_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                    status VARCHAR(20) NOT NULL DEFAULT 'pending',
                    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
                    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                    PRIMARY KEY (id)
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
                """);

        jdbcTemplate.execute("""
                CREATE TABLE IF NOT EXISTS tb_merchant_artisan (
                    id BIGINT NOT NULL AUTO_INCREMENT,
                    user_id BIGINT DEFAULT NULL,
                    merchant_name VARCHAR(100) NOT NULL,
                    artisan_name VARCHAR(100) NOT NULL,
                    heritage_skill VARCHAR(150) NOT NULL,
                    level VARCHAR(100) DEFAULT NULL,
                    verified TINYINT(1) NOT NULL DEFAULT 0,
                    status VARCHAR(20) NOT NULL DEFAULT 'active',
                    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
                    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                    PRIMARY KEY (id)
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
                """);

        jdbcTemplate.execute("""
                CREATE TABLE IF NOT EXISTS tb_merchant_sensitive_word (
                    id BIGINT NOT NULL AUTO_INCREMENT,
                    word VARCHAR(100) NOT NULL,
                    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
                    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                    PRIMARY KEY (id),
                    UNIQUE KEY uk_merchant_sensitive_word (word)
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
                """);

        ensureTextColumn("tb_merchant_onboarding_application", "attachment_urls");
        ensureTextColumn("tb_merchant_qualification_application", "attachment_urls");

        seedMerchantData();
    }

    private void seedMerchantData() {
        jdbcTemplate.update("""
                INSERT INTO tb_user_role (user_id, role_id, create_time)
                SELECT 3, r.id, NOW()
                FROM tb_role r
                WHERE r.role_key = 'merchant'
                  AND EXISTS (SELECT 1 FROM tb_user WHERE id = 3)
                  AND NOT EXISTS (
                      SELECT 1 FROM tb_user_role ur WHERE ur.user_id = 3 AND ur.role_id = r.id
                  )
                """);

        jdbcTemplate.update("""
                INSERT INTO tb_user_role (user_id, role_id, create_time)
                SELECT 5, r.id, NOW()
                FROM tb_role r
                WHERE r.role_key = 'merchant'
                  AND EXISTS (SELECT 1 FROM tb_user WHERE id = 5)
                  AND NOT EXISTS (
                      SELECT 1 FROM tb_user_role ur WHERE ur.user_id = 5 AND ur.role_id = r.id
                  )
                """);

        jdbcTemplate.update("""
                INSERT INTO tb_merchant_profile (
                    user_id, store_name, store_status, commission_rate, heritage_certified,
                    settlement_amount, withdraw_pending, last_settlement_at, contact_name, contact_phone, introduction
                )
                SELECT 3, '锦味非遗食坊', 'active', 12.00, 1, 28916.80, 2400.00, '2026-04-26 17:00:00', '王青山', '13800138003',
                       '聚焦川味非遗熟食与手工糖画的商家门店。'
                FROM DUAL
                WHERE EXISTS (SELECT 1 FROM tb_user WHERE id = 3)
                  AND NOT EXISTS (SELECT 1 FROM tb_merchant_profile WHERE user_id = 3)
                """);

        jdbcTemplate.update("""
                INSERT INTO tb_merchant_profile (
                    user_id, store_name, store_status, commission_rate, heritage_certified,
                    settlement_amount, withdraw_pending, last_settlement_at, contact_name, contact_phone, introduction
                )
                SELECT 5, '江南古味馆', 'limited', 10.00, 1, 0.00, 1500.00, '2026-04-25 11:30:00', '周南枫', '13800138005',
                       '展示江南传统酱卤技艺与非遗风味故事。'
                FROM DUAL
                WHERE EXISTS (SELECT 1 FROM tb_user WHERE id = 5)
                  AND NOT EXISTS (SELECT 1 FROM tb_merchant_profile WHERE user_id = 5)
                """);

        jdbcTemplate.update("""
                INSERT INTO tb_merchant_onboarding_application (user_id, applicant_name, phone, store_name, category, region, submitted_at, note, status)
                SELECT 6, '王青川', '13800138006', '锦味非遗食坊二店', '川味非遗熟食', '成都', '2026-04-28 10:20:00',
                       '已上传营业执照、食品经营许可证和门店照片。', 'pending'
                FROM DUAL
                WHERE NOT EXISTS (SELECT 1 FROM tb_merchant_onboarding_application WHERE phone = '13800138006')
                """);

        jdbcTemplate.update("""
                INSERT INTO tb_merchant_onboarding_application (user_id, applicant_name, phone, store_name, category, region, submitted_at, note, status)
                SELECT 7, '周南禾', '13800138007', '潮味匠心铺', '潮汕手工点心', '汕头', '2026-04-27 16:45:00',
                       '申请开通商家账号并同步入驻文化内容专区。', 'pending'
                FROM DUAL
                WHERE NOT EXISTS (SELECT 1 FROM tb_merchant_onboarding_application WHERE phone = '13800138007')
                """);

        jdbcTemplate.update("""
                INSERT INTO tb_merchant_qualification_application (user_id, merchant_name, project_name, certificate_no, issuer, submitted_at, note, status)
                SELECT 3, '锦味非遗食坊', '成都糖画制作技艺', 'FY-CD-2026-1008', '成都市非遗保护中心',
                       '2026-04-28 13:10:00', '需核验传承人身份证明与授权书。', 'pending'
                FROM DUAL
                WHERE NOT EXISTS (SELECT 1 FROM tb_merchant_qualification_application WHERE certificate_no = 'FY-CD-2026-1008')
                """);

        jdbcTemplate.update("""
                INSERT INTO tb_merchant_qualification_application (user_id, merchant_name, project_name, certificate_no, issuer, submitted_at, note, status)
                SELECT 5, '江南古味馆', '杭帮古法酱鸭制作', 'FY-HZ-2026-0831', '杭州市非遗协会',
                       '2026-04-26 09:40:00', '资料完整，待人工复审。', 'pending'
                FROM DUAL
                WHERE NOT EXISTS (SELECT 1 FROM tb_merchant_qualification_application WHERE certificate_no = 'FY-HZ-2026-0831')
                """);

        jdbcTemplate.update("""
                INSERT INTO tb_merchant_settlement (user_id, merchant_name, period, order_count, turnover, commission_amount, payable_amount, status, create_time, update_time)
                SELECT 3, '锦味非遗食坊', '2026-04-01 至 2026-04-15', 132, 32860.00, 3943.20, 28916.80, 'pending',
                       '2026-04-16 09:00:00', '2026-04-16 09:00:00'
                FROM DUAL
                WHERE NOT EXISTS (SELECT 1 FROM tb_merchant_settlement WHERE user_id = 3 AND period = '2026-04-01 至 2026-04-15')
                """);

        jdbcTemplate.update("""
                INSERT INTO tb_merchant_settlement (user_id, merchant_name, period, order_count, turnover, commission_amount, payable_amount, status, create_time, update_time)
                SELECT 5, '江南古味馆', '2026-04-01 至 2026-04-15', 79, 18320.00, 1832.00, 16488.00, 'paid',
                       '2026-04-16 09:00:00', '2026-04-25 11:30:00'
                FROM DUAL
                WHERE NOT EXISTS (SELECT 1 FROM tb_merchant_settlement WHERE user_id = 5 AND period = '2026-04-01 至 2026-04-15')
                """);

        jdbcTemplate.update("""
                INSERT INTO tb_merchant_withdrawal (user_id, merchant_name, amount, account_name, account_no, submitted_at, status, create_time, update_time)
                SELECT 3, '锦味非遗食坊', 2400.00, '王青山', '6222 **** **** 8891', '2026-04-28 15:12:00', 'pending',
                       '2026-04-28 15:12:00', '2026-04-28 15:12:00'
                FROM DUAL
                WHERE NOT EXISTS (
                    SELECT 1 FROM tb_merchant_withdrawal WHERE user_id = 3 AND account_name = '王青山' AND amount = 2400.00
                )
                """);

        jdbcTemplate.update("""
                INSERT INTO tb_merchant_withdrawal (user_id, merchant_name, amount, account_name, account_no, submitted_at, status, create_time, update_time)
                SELECT 5, '江南古味馆', 1500.00, '周南枫', '6217 **** **** 1032', '2026-04-27 09:08:00', 'pending',
                       '2026-04-27 09:08:00', '2026-04-27 09:08:00'
                FROM DUAL
                WHERE NOT EXISTS (
                    SELECT 1 FROM tb_merchant_withdrawal WHERE user_id = 5 AND account_name = '周南枫' AND amount = 1500.00
                )
                """);

        jdbcTemplate.update("""
                INSERT INTO tb_merchant_product_submission (user_id, merchant_name, product_name, category, price, heritage_tag, description, submitted_at, status)
                SELECT 3, '锦味非遗食坊', '手绘糖画礼盒', '非遗甜品', 88.00, '糖画技艺',
                       '采用传统糖画工艺制作节令伴手礼。', '2026-04-28 12:05:00', 'pending'
                FROM DUAL
                WHERE NOT EXISTS (SELECT 1 FROM tb_merchant_product_submission WHERE user_id = 3 AND product_name = '手绘糖画礼盒')
                """);

        jdbcTemplate.update("""
                INSERT INTO tb_merchant_product_submission (user_id, merchant_name, product_name, category, price, heritage_tag, description, submitted_at, status)
                SELECT 5, '江南古味馆', '古法酱鸭半只装', '熟食礼盒', 128.00, '杭帮古法',
                       '延续传统酱卤火候和风味控制。', '2026-04-27 18:20:00', 'approved'
                FROM DUAL
                WHERE NOT EXISTS (SELECT 1 FROM tb_merchant_product_submission WHERE user_id = 5 AND product_name = '古法酱鸭半只装')
                """);

        jdbcTemplate.update("""
                INSERT INTO tb_merchant_content_submission (user_id, merchant_name, title, content_type, risk_point, content, submitted_at, status)
                SELECT 3, '锦味非遗食坊', '糖画传承人的一天', '图文专题', '需核验匠人实名信息',
                       '记录糖画传承人从备料到创作成品的完整过程。', '2026-04-28 14:18:00', 'pending'
                FROM DUAL
                WHERE NOT EXISTS (SELECT 1 FROM tb_merchant_content_submission WHERE user_id = 3 AND title = '糖画传承人的一天')
                """);

        jdbcTemplate.update("""
                INSERT INTO tb_merchant_content_submission (user_id, merchant_name, title, content_type, risk_point, content, submitted_at, status)
                SELECT 5, '江南古味馆', '杭帮古法酱鸭历史故事', '短视频脚本', '存在夸大宣传表述',
                       '讲述古法酱鸭由来与门店匠人经验积累。', '2026-04-27 11:42:00', 'pending'
                FROM DUAL
                WHERE NOT EXISTS (SELECT 1 FROM tb_merchant_content_submission WHERE user_id = 5 AND title = '杭帮古法酱鸭历史故事')
                """);

        jdbcTemplate.update("""
                INSERT INTO tb_merchant_review_audit (user_id, user_name, merchant_name, content, hit_words, submitted_at, status)
                SELECT 3, '食客阿木', '锦味非遗食坊',
                       '味道不错，就是老板说自家绝对全国第一，有点夸张。',
                       '全国第一', '2026-04-28 18:30:00', 'pending'
                FROM DUAL
                WHERE NOT EXISTS (
                    SELECT 1 FROM tb_merchant_review_audit WHERE merchant_name = '锦味非遗食坊' AND user_name = '食客阿木'
                )
                """);

        jdbcTemplate.update("""
                INSERT INTO tb_merchant_review_audit (user_id, user_name, merchant_name, content, hit_words, submitted_at, status)
                SELECT 5, '江湖吃货', '江南古味馆',
                       '配送慢了一些，但产品还是很正宗。',
                       '正宗', '2026-04-27 20:16:00', 'pending'
                FROM DUAL
                WHERE NOT EXISTS (
                    SELECT 1 FROM tb_merchant_review_audit WHERE merchant_name = '江南古味馆' AND user_name = '江湖吃货'
                )
                """);

        jdbcTemplate.update("""
                INSERT INTO tb_merchant_artisan (user_id, merchant_name, artisan_name, heritage_skill, level, verified, status)
                SELECT 3, '锦味非遗食坊', '王青山', '糖画制作', '市级传承人', 1, 'active'
                FROM DUAL
                WHERE NOT EXISTS (SELECT 1 FROM tb_merchant_artisan WHERE user_id = 3 AND artisan_name = '王青山')
                """);

        jdbcTemplate.update("""
                INSERT INTO tb_merchant_artisan (user_id, merchant_name, artisan_name, heritage_skill, level, verified, status)
                SELECT 5, '江南古味馆', '周南枫', '古法酱鸭制作', '区级传承人', 1, 'active'
                FROM DUAL
                WHERE NOT EXISTS (SELECT 1 FROM tb_merchant_artisan WHERE user_id = 5 AND artisan_name = '周南枫')
                """);

        insertSensitiveWord("全国第一");
        insertSensitiveWord("包治百病");
        insertSensitiveWord("官方唯一");
        insertSensitiveWord("祖传秘方包过敏");
    }

    private void insertSensitiveWord(String word) {
        jdbcTemplate.update("""
                INSERT INTO tb_merchant_sensitive_word (word)
                SELECT ?
                FROM DUAL
                WHERE NOT EXISTS (
                    SELECT 1 FROM tb_merchant_sensitive_word WHERE word = ?
                )
                """, word, word);
    }

    private void ensureTextColumn(String tableName, String columnName) {
        Integer count = jdbcTemplate.queryForObject("""
                SELECT COUNT(*)
                FROM information_schema.columns
                WHERE table_schema = DATABASE()
                  AND table_name = ?
                  AND column_name = ?
                """, Integer.class, tableName, columnName);

        if (count == null || count == 0) {
            jdbcTemplate.execute("ALTER TABLE " + tableName + " ADD COLUMN " + columnName + " TEXT DEFAULT NULL");
        }
    }
}

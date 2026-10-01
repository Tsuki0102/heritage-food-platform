/*
 Navicat Premium Dump SQL

 Source Server         : 2026
 Source Server Type    : MySQL
 Source Server Version : 80039 (8.0.39)
 Source Host           : localhost:3306
 Source Schema         : feiyi_food_platform

 Target Server Type    : MySQL
 Target Server Version : 80039 (8.0.39)
 File Encoding         : 65001

 Date: 09/05/2026 11:51:52
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for tb_cart_item
-- ----------------------------
DROP TABLE IF EXISTS `tb_cart_item`;
CREATE TABLE `tb_cart_item`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '购物车项ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `product_id` int NOT NULL COMMENT '商品ID',
  `quantity` int NOT NULL DEFAULT 1 COMMENT '数量',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_user_product`(`user_id` ASC, `product_id` ASC) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_product_id`(`product_id` ASC) USING BTREE,
  CONSTRAINT `fk_cart_item_product` FOREIGN KEY (`product_id`) REFERENCES `tb_product` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_cart_item_user` FOREIGN KEY (`user_id`) REFERENCES `tb_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '购物车表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tb_cart_item
-- ----------------------------
INSERT INTO `tb_cart_item` VALUES (7, 3, 3, 3, '2026-04-25 18:10:29', '2026-04-25 18:10:29');
INSERT INTO `tb_cart_item` VALUES (8, 4, 4, 1, '2026-04-25 18:10:29', '2026-04-25 18:10:29');
INSERT INTO `tb_cart_item` VALUES (11, 8637, 3, 2, '2026-04-25 18:19:16', '2026-04-25 18:19:16');
INSERT INTO `tb_cart_item` VALUES (12, 8637, 2, 1, '2026-04-25 18:53:11', '2026-04-25 18:53:11');
INSERT INTO `tb_cart_item` VALUES (13, 8637, 1, 1, '2026-04-25 19:59:56', '2026-04-25 19:59:56');
INSERT INTO `tb_cart_item` VALUES (14, 8637, 5, 1, '2026-04-29 20:34:46', '2026-04-29 20:34:46');

-- ----------------------------
-- Table structure for tb_community_comment
-- ----------------------------
DROP TABLE IF EXISTS `tb_community_comment`;
CREATE TABLE `tb_community_comment`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `post_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_comment_post`(`post_id` ASC) USING BTREE,
  INDEX `fk_comment_user`(`user_id` ASC) USING BTREE,
  CONSTRAINT `fk_comment_post` FOREIGN KEY (`post_id`) REFERENCES `tb_community_post` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_comment_user` FOREIGN KEY (`user_id`) REFERENCES `tb_user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `tb_community_comment_ibfk_1` FOREIGN KEY (`post_id`) REFERENCES `tb_community_post` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `tb_community_comment_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `tb_user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 27 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tb_community_comment
-- ----------------------------
INSERT INTO `tb_community_comment` VALUES (19, 34, 7, '老广来认证！味道很地道', '2026-03-28 21:11:00');
INSERT INTO `tb_community_comment` VALUES (20, 34, 8, '早茶人太多了，建议早点去占座', '2026-03-28 21:12:00');
INSERT INTO `tb_community_comment` VALUES (21, 35, 9, '羊汤是灵魂！同意！熬8小时太费时间了', '2026-03-28 21:16:00');
INSERT INTO `tb_community_comment` VALUES (22, 35, 10, '暖乎乎一碗下肚，秋冬太舒服了', '2026-03-28 21:17:00');
INSERT INTO `tb_community_comment` VALUES (25, 37, 3, '洛阳旅行必吃！体验豫菜文化', '2026-03-28 21:26:00');
INSERT INTO `tb_community_comment` VALUES (26, 37, 4, '水席口味偏咸，适合重口爱好者', '2026-03-28 21:27:00');

-- ----------------------------
-- Table structure for tb_community_post
-- ----------------------------
DROP TABLE IF EXISTS `tb_community_post`;
CREATE TABLE `tb_community_post`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '帖子类型：food-美食帖，store-探店帖，other-其他帖',
  `media_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `like_count` int NOT NULL DEFAULT 0,
  `comment_count` int NOT NULL DEFAULT 0,
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_post_user`(`user_id` ASC) USING BTREE,
  CONSTRAINT `fk_post_user` FOREIGN KEY (`user_id`) REFERENCES `tb_user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `tb_community_post_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `tb_user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 76 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tb_community_post
-- ----------------------------
INSERT INTO `tb_community_post` VALUES (34, 3, '打卡广州酒家早茶，点心天花板', '早茶人满为患！红豆小笼包、三鲜小笼包鲜掉眉毛，现在买一送一活动太香了，老广认证地道！', '2', '/images/community/guangzhou-dimsum-community.jpg', 0, 0, '2026-03-28 21:10:00', '2026-03-28 21:10:00');
INSERT INTO `tb_community_post` VALUES (35, 4, '复刻河南烩面，羊汤才是灵魂', '用羊骨+香料熬8小时，汤色奶白，烩面筋道，配上鲜牛肉，暖乎乎一碗下肚，秋冬太治愈了！', '0', '/images/community/zhengzhou-huimian-community.jpg', 0, 0, '2026-03-28 21:15:00', '2026-03-28 21:15:00');
INSERT INTO `tb_community_post` VALUES (36, 5, '开封灌汤包，一口爆汁的技巧', '灌汤包要先咬小口吸汤汁，再吃皮和馅，面皮要薄而不破，虾仁馅鲜到掉眉毛！', '1', '/images/community/kaifeng-guantangbao-community.jpg', 0, 0, '2026-03-28 21:20:00', '2026-03-28 21:20:00');
INSERT INTO `tb_community_post` VALUES (37, 6, '洛阳水席楼，豫菜的独特魅力', '第一次吃水席，鸭卷凉菜精致，莲汤肉片清爽，口味偏咸适合重口，旅行打卡必来！', '2', '/images/community/luoyang-shuixi-community.jpg', 0, 0, '2026-03-28 21:25:00', '2026-03-28 21:25:00');
INSERT INTO `tb_community_post` VALUES (47, 6, '42', '42', '0', NULL, 0, 0, '2026-03-30 22:02:17', '2026-03-30 22:02:17');

-- ----------------------------
-- Table structure for tb_food
-- ----------------------------
DROP TABLE IF EXISTS `tb_food`;
CREATE TABLE `tb_food`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `region` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `taste` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `heritage_level` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `history` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `ingredients` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `process` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `cover_image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `average_score` decimal(2, 1) NOT NULL DEFAULT 0.0,
  `collection_count` int NOT NULL DEFAULT 0,
  `view_count` int NOT NULL DEFAULT 0,
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 44 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tb_food
-- ----------------------------
INSERT INTO `tb_food` VALUES (4, '北京烤鸭', '北京', '咸香', '国家级', '北京烤鸭历史悠久，起源于明朝，是北京的代表性美食。', '鸭子,调料', '经过宰杀、打气、烫皮、晾皮、烤制等多道工序。', 'beijing-duck.jpg', 5.0, 2, 289, '2026-03-26 18:19:19', '2026-03-27 18:13:48');
INSERT INTO `tb_food` VALUES (5, '上海小笼包', '上海', '鲜美', '市级', '上海小笼包起源于清朝光绪年间，是上海的传统名吃。', '面粉,猪肉,皮冻', '经过和面、制皮、包馅、蒸制等工序。', 'shanghai-xiaolongbao.jpg', 5.0, 1, 229, '2026-03-26 18:19:19', '2026-03-27 18:13:48');
INSERT INTO `tb_food` VALUES (6, '广州早茶', '广东', '清淡', '省级', '广州早茶历史悠久，是广东地区的传统饮食文化。', '面粉,虾,蟹', '经过和面、制皮、包馅、蒸制等工序。', 'guangzhou-dimsum.jpg', 5.0, 1, 175, '2026-03-26 18:19:19', '2026-03-27 18:13:48');
INSERT INTO `tb_food` VALUES (7, '开封灌汤包', '河南', '鲜美', '市级', '开封灌汤包起源于北宋时期，是开封的传统名吃。', '面粉,猪肉,皮冻', '经过和面、制皮、包馅、蒸制等工序。', 'kaifeng-guantangbao.jpg', 0.0, 0, 129, '2026-03-26 18:19:19', '2026-03-27 18:13:48');
INSERT INTO `tb_food` VALUES (8, '洛阳水席', '河南', '酸辣', '省级', '洛阳水席历史悠久，起源于唐朝，是洛阳的传统宴席。', '各种食材', '经过煮、炖、蒸等多道工序。', 'luoyang-shuixi.jpg', 0.0, 0, 155, '2026-03-26 18:19:19', '2026-03-27 18:13:48');
INSERT INTO `tb_food` VALUES (9, '郑州烩面', '河南', '鲜香', '市级', '郑州烩面是郑州的传统面食，以其浓郁的汤头和筋道的面条而闻名。', '面粉,羊肉,粉条', '经过和面、拉面、煮制等工序。', 'zhengzhou-huimian.jpg', 4.0, 1, 139, '2026-03-26 18:19:19', '2026-03-27 18:13:48');
INSERT INTO `tb_food` VALUES (10, '四川火锅', '四川', '麻辣', '国家级', '四川火锅起源于清朝，是川菜的代表之一。', '各种食材,火锅底料', '经过准备食材、调制底料、煮制等工序。', 'sichuan-hotpot.jpg', 4.0, 1, 224, '2026-03-26 18:19:19', '2026-03-27 18:13:48');
INSERT INTO `tb_food` VALUES (11, '西安肉夹馍', '陕西', '咸香', '市级', '西安肉夹馍起源于秦朝，是西安的传统名吃。', '面粉,猪肉,调料', '经过和面、烤制、夹馅等工序。', 'xian-roujiamo.jpg', 5.0, 1, 199, '2026-03-26 18:19:19', '2026-03-27 18:13:48');
INSERT INTO `tb_food` VALUES (12, '杭州西湖醋鱼', '浙江', '酸甜', '省级', '杭州西湖醋鱼起源于宋朝，是杭州的传统名菜。', '草鱼,醋,糖', '经过宰杀、烹饪、调味等工序。', 'hangzhou-fish.jpg', 4.0, 1, 173, '2026-03-26 18:19:19', '2026-03-27 18:13:48');
INSERT INTO `tb_food` VALUES (35, '东坡肉', '浙江', '咸甜', '省级', '东坡肉起源于北宋苏轼，以五花肉为原料，色泽红亮，肥而不腻，入口即化。', '五花肉、黄酒、酱油、冰糖', '1. 五花肉焯水 2. 砂锅慢炖 3. 收汁上色', 'braised-pork.jpg', 4.8, 0, 1, '2026-04-25 19:15:53', '2026-04-25 19:24:08');
INSERT INTO `tb_food` VALUES (36, '广式白切鸡', '广东', '清淡', '省级', '广式白切鸡是粤菜经典，以皮黄肉白、原汁原味著称，保留鸡肉的鲜嫩口感。', '三黄鸡、姜、葱、盐', '1. 浸鸡至熟 2. 过凉定型 3. 蘸料食用', 'white-cut-chicken.jpg', 4.7, 0, 0, '2026-04-25 19:15:53', '2026-04-25 19:24:08');
INSERT INTO `tb_food` VALUES (37, '重庆毛血旺', '重庆', '麻辣', '市级', '重庆毛血旺是江湖菜代表，麻辣鲜香、汁浓味足，食材丰富。', '鸭血、毛肚、黄喉、豆芽、午餐肉', '1. 底料炒香 2. 加汤煮沸 3. 依次煮食材', 'chongqing-maoxuewang.jpg', 4.6, 0, 2, '2026-04-25 19:15:53', '2026-04-25 19:24:08');
INSERT INTO `tb_food` VALUES (38, '广式烧卖', '广东', '鲜香', '省级', '广式早茶经典点心，皮薄馅大，鲜香多汁。', '猪肉、虾仁、面皮、香菇', '1. 制皮 2. 和馅 3. 包制 4. 蒸熟', 'shao-mai.jpg', 4.8, 0, 0, '2026-04-25 19:15:53', '2026-04-25 19:24:08');
INSERT INTO `tb_food` VALUES (39, '蟹黄灌汤包', '江苏', '鲜美', '市级', '蟹黄汤包汁多味鲜，皮薄如纸，是江南著名小吃。', '蟹黄、猪肉、皮冻、面粉', '1. 制皮 2. 包馅 3. 蒸制', 'crab-guantangbao.jpg', 4.7, 0, 0, '2026-04-25 19:15:53', '2026-04-25 19:24:08');
INSERT INTO `tb_food` VALUES (40, '红豆小笼包', '上海', '甜香', '市级', '甜口小笼包，红豆沙细腻香甜。', '红豆沙、面粉、糖', '1. 制皮 2. 包豆沙馅 3. 蒸制', 'redbean-xiaolongbao.jpg', 4.6, 0, 0, '2026-04-25 19:15:53', '2026-04-25 19:24:08');
INSERT INTO `tb_food` VALUES (41, '酸辣肚丝汤', '河南', '酸辣', '市级', '河南传统酸辣汤，肚丝鲜嫩，酸辣开胃。', '猪肚、醋、辣椒、胡椒粉、香菜', '1. 煮猪肚 2. 调汤 3. 勾芡出锅', 'suanla-dusi.jpg', 4.5, 0, 0, '2026-04-25 19:15:53', '2026-04-25 19:24:08');
INSERT INTO `tb_food` VALUES (42, '老鸭汤', '南京', '鲜香', '市级', '老鸭汤汤汁清澈，滋补养生，鲜香可口。', '老鸭、酸萝卜、姜片、红枣', '1. 焯水 2. 慢炖 2-3小时', 'duck-soup.jpg', 4.6, 0, 0, '2026-04-25 19:15:53', '2026-04-25 19:24:08');
INSERT INTO `tb_food` VALUES (43, '鸳鸯火锅', '四川', '双味', '国家级', '一边麻辣一边清汤，满足不同口味。', '牛油底料、清汤底料、各类食材', '1. 制双味锅底 2. 涮煮食材', 'yanyang-hotpot.jpg', 4.9, 0, 0, '2026-04-25 19:15:53', '2026-04-25 19:24:08');

-- ----------------------------
-- Table structure for tb_food_media
-- ----------------------------
DROP TABLE IF EXISTS `tb_food_media`;
CREATE TABLE `tb_food_media`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `food_id` bigint NOT NULL,
  `type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'image/video',
  `resource_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `sort` tinyint NOT NULL DEFAULT 1 COMMENT '排序，数字越小越靠前',
  `upload_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_media_food`(`food_id` ASC) USING BTREE,
  CONSTRAINT `fk_media_food` FOREIGN KEY (`food_id`) REFERENCES `tb_food` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `tb_food_media_ibfk_1` FOREIGN KEY (`food_id`) REFERENCES `tb_food` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 34 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tb_food_media
-- ----------------------------
INSERT INTO `tb_food_media` VALUES (7, 4, 'image', 'beijing-duck1.jpg', 1, '2026-03-27 18:13:11');
INSERT INTO `tb_food_media` VALUES (8, 4, 'image', 'beijing-duck2.jpg', 2, '2026-03-27 18:13:11');
INSERT INTO `tb_food_media` VALUES (9, 4, 'image', 'beijing-duck3.jpg', 3, '2026-03-27 18:13:11');
INSERT INTO `tb_food_media` VALUES (10, 5, 'image', 'shanghai-xiaolongbao1.jpg', 1, '2026-03-27 18:13:11');
INSERT INTO `tb_food_media` VALUES (11, 5, 'image', 'shanghai-xiaolongbao2.jpg', 2, '2026-03-27 18:13:11');
INSERT INTO `tb_food_media` VALUES (12, 5, 'image', 'shanghai-xiaolongbao3.jpg', 3, '2026-03-27 18:13:11');
INSERT INTO `tb_food_media` VALUES (13, 6, 'image', 'guangzhou-dimsum1.jpg', 1, '2026-03-27 18:13:11');
INSERT INTO `tb_food_media` VALUES (14, 6, 'image', 'guangzhou-dimsum2.jpg', 2, '2026-03-27 18:13:11');
INSERT INTO `tb_food_media` VALUES (15, 6, 'image', 'guangzhou-dimsum3.jpg', 3, '2026-03-27 18:13:11');
INSERT INTO `tb_food_media` VALUES (16, 7, 'image', 'kaifeng-guantangbao1.jpg', 1, '2026-03-27 18:13:11');
INSERT INTO `tb_food_media` VALUES (17, 7, 'image', 'kaifeng-guantangbao2.jpg', 2, '2026-03-27 18:13:11');
INSERT INTO `tb_food_media` VALUES (18, 7, 'image', 'kaifeng-guantangbao3.jpg', 3, '2026-03-27 18:13:11');
INSERT INTO `tb_food_media` VALUES (19, 8, 'image', 'luoyang-shuixi1.jpg', 1, '2026-03-27 18:13:11');
INSERT INTO `tb_food_media` VALUES (20, 8, 'image', 'luoyang-shuixi2.jpg', 2, '2026-03-27 18:13:11');
INSERT INTO `tb_food_media` VALUES (21, 8, 'image', 'luoyang-shuixi3.jpg', 3, '2026-03-27 18:13:11');
INSERT INTO `tb_food_media` VALUES (22, 9, 'image', 'zhengzhou-huimian1.jpg', 1, '2026-03-27 18:13:11');
INSERT INTO `tb_food_media` VALUES (23, 9, 'image', 'zhengzhou-huimian2.jpg', 2, '2026-03-27 18:13:11');
INSERT INTO `tb_food_media` VALUES (24, 9, 'image', 'zhengzhou-huimian3.jpg', 3, '2026-03-27 18:13:11');
INSERT INTO `tb_food_media` VALUES (25, 10, 'image', 'sichuan-hotpot1.jpg', 1, '2026-03-27 18:13:11');
INSERT INTO `tb_food_media` VALUES (26, 10, 'image', 'sichuan-hotpot2.jpg', 2, '2026-03-27 18:13:11');
INSERT INTO `tb_food_media` VALUES (27, 10, 'image', 'sichuan-hotpot3.jpg', 3, '2026-03-27 18:13:11');
INSERT INTO `tb_food_media` VALUES (28, 11, 'image', 'xian-roujiamo1.jpg', 1, '2026-03-27 18:13:11');
INSERT INTO `tb_food_media` VALUES (29, 11, 'image', 'xian-roujiamo2.jpg', 2, '2026-03-27 18:13:11');
INSERT INTO `tb_food_media` VALUES (30, 11, 'image', 'xian-roujiamo3.jpg', 3, '2026-03-27 18:13:11');
INSERT INTO `tb_food_media` VALUES (31, 12, 'image', 'hangzhou-fish1.jpg', 1, '2026-03-27 18:13:11');
INSERT INTO `tb_food_media` VALUES (32, 12, 'image', 'hangzhou-fish2.jpg', 2, '2026-03-27 18:13:11');
INSERT INTO `tb_food_media` VALUES (33, 12, 'image', 'hangzhou-fish3.jpg', 3, '2026-03-27 18:13:11');

-- ----------------------------
-- Table structure for tb_merchant_artisan
-- ----------------------------
DROP TABLE IF EXISTS `tb_merchant_artisan`;
CREATE TABLE `tb_merchant_artisan`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NULL DEFAULT NULL,
  `merchant_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `artisan_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `heritage_skill` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `level` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `verified` tinyint(1) NOT NULL DEFAULT 0,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'active',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tb_merchant_artisan
-- ----------------------------
INSERT INTO `tb_merchant_artisan` VALUES (1, 3, '锦味非遗食坊', '王青山', '糖画制作技艺', '市级传承人', 1, 'active', '2026-04-29 23:13:57', '2026-04-29 23:13:57');
INSERT INTO `tb_merchant_artisan` VALUES (2, 5, '江南古味馆', '周南枫', '古法酱鸭制作', '区级传承人', 1, 'active', '2026-04-29 23:13:57', '2026-04-29 23:13:57');

-- ----------------------------
-- Table structure for tb_merchant_content_submission
-- ----------------------------
DROP TABLE IF EXISTS `tb_merchant_content_submission`;
CREATE TABLE `tb_merchant_content_submission`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `merchant_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `title` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `content_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `risk_point` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `submitted_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'pending',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_merchant_content_user_id`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tb_merchant_content_submission
-- ----------------------------
INSERT INTO `tb_merchant_content_submission` VALUES (1, 3, '锦味非遗食坊', '糖画传承人的一天', '图文专题', '需核验匠人实名信息', '记录糖画传承人从备料到创作成品的完整过程，展现非遗技艺的魅力。', '2026-04-28 14:18:00', 'pending', '2026-04-29 23:13:57', '2026-04-29 23:13:57');
INSERT INTO `tb_merchant_content_submission` VALUES (2, 5, '江南古味馆', '杭帮古法酱鸭历史故事', '短视频脚本', '存在夸大宣传表述', '讲述古法酱鸭由来与门店匠人经验积累，传承地道江南味道。', '2026-04-27 11:42:00', 'pending', '2026-04-29 23:13:57', '2026-04-29 23:13:57');

-- ----------------------------
-- Table structure for tb_merchant_onboarding_application
-- ----------------------------
DROP TABLE IF EXISTS `tb_merchant_onboarding_application`;
CREATE TABLE `tb_merchant_onboarding_application`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NULL DEFAULT NULL,
  `applicant_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `phone` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `store_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `category` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `region` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `submitted_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `note` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `attachment_urls` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'pending',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tb_merchant_onboarding_application
-- ----------------------------
INSERT INTO `tb_merchant_onboarding_application` VALUES (1, 6, '王青川', '13800138006', '锦味非遗食坊二店', '川味非遗熟食', '成都', '2026-04-28 10:20:00', '已上传营业执照、食品经营许可证和门店照片，请管理员审核。', NULL, 'pending', '2026-04-29 23:13:57', '2026-04-29 23:13:57');
INSERT INTO `tb_merchant_onboarding_application` VALUES (2, 7, '周南禾', '13800138007', '潮味匠心铺', '潮汕手工糕点', '潮州', '2026-04-27 16:45:00', '申请开通商家账号并同步入驻文化内容专区。', NULL, 'pending', '2026-04-29 23:13:57', '2026-04-29 23:13:57');

-- ----------------------------
-- Table structure for tb_merchant_product_submission
-- ----------------------------
DROP TABLE IF EXISTS `tb_merchant_product_submission`;
CREATE TABLE `tb_merchant_product_submission`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `merchant_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `product_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `price` decimal(12, 2) NOT NULL DEFAULT 0.00,
  `heritage_tag` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `submitted_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'pending',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_merchant_product_user_id`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tb_merchant_product_submission
-- ----------------------------
INSERT INTO `tb_merchant_product_submission` VALUES (1, 3, '锦味非遗食坊', '手绘糖画礼盒', '非遗甜品', 88.00, '糖画技艺', '采用传统糖画工艺制作的节令伴手礼，手工绘制精美图案。', '2026-04-28 12:05:00', 'pending', '2026-04-29 23:13:57', '2026-04-29 23:13:57');
INSERT INTO `tb_merchant_product_submission` VALUES (2, 5, '江南古味馆', '古法酱鸭半只装', '熟食礼盒', 128.00, '杭帮古法', '沿用三百年传统酱卤火候和风味控制，正宗杭州味道。', '2026-04-27 18:20:00', 'approved', '2026-04-29 23:13:57', '2026-04-29 23:13:57');

-- ----------------------------
-- Table structure for tb_merchant_profile
-- ----------------------------
DROP TABLE IF EXISTS `tb_merchant_profile`;
CREATE TABLE `tb_merchant_profile`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `store_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `store_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'active',
  `commission_rate` decimal(10, 2) NOT NULL DEFAULT 12.00,
  `heritage_certified` tinyint(1) NOT NULL DEFAULT 0,
  `settlement_amount` decimal(12, 2) NOT NULL DEFAULT 0.00,
  `withdraw_pending` decimal(12, 2) NOT NULL DEFAULT 0.00,
  `last_settlement_at` datetime NULL DEFAULT NULL,
  `contact_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `contact_phone` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `introduction` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_merchant_profile_user_id`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tb_merchant_profile
-- ----------------------------
INSERT INTO `tb_merchant_profile` VALUES (1, 3, '锦味非遗食坊', 'active', 12.00, 1, 28916.80, 2400.00, '2026-04-26 17:00:00', '王青山', '13800138003', '聚焦川味非遗熟食与手工糖画的商家店铺，传承百年老味道。', '2026-04-29 23:13:57', '2026-05-09 00:41:46');
INSERT INTO `tb_merchant_profile` VALUES (2, 5, '江南古味馆', 'limited', 10.00, 1, 0.00, 1500.00, '2026-04-25 11:30:00', '周南枫', '13800138005', '展示江南传统酱卤技艺与非遗风味故事，品味正宗江南味道。', '2026-04-29 23:13:57', '2026-04-29 23:13:57');

-- ----------------------------
-- Table structure for tb_merchant_qualification_application
-- ----------------------------
DROP TABLE IF EXISTS `tb_merchant_qualification_application`;
CREATE TABLE `tb_merchant_qualification_application`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NULL DEFAULT NULL,
  `merchant_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `project_name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `certificate_no` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `issuer` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `submitted_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `note` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `attachment_urls` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'pending',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tb_merchant_qualification_application
-- ----------------------------
INSERT INTO `tb_merchant_qualification_application` VALUES (1, 3, '锦味非遗食坊', '成都糖画制作技艺', 'FY-CD-2026-1008', '成都市非遗保护中心', '2026-04-28 13:10:00', '需核验传承人身份证明与授权书。', NULL, 'pending', '2026-04-30 08:45:27', '2026-04-30 08:45:27');
INSERT INTO `tb_merchant_qualification_application` VALUES (2, 5, '江南古味馆', '杭帮古法酱鸭制作', 'FY-HZ-2026-0831', '杭州市非遗协会', '2026-04-26 09:40:00', '资料完整，待人工复审。', NULL, 'pending', '2026-04-30 08:45:27', '2026-04-30 08:45:27');

-- ----------------------------
-- Table structure for tb_merchant_review_audit
-- ----------------------------
DROP TABLE IF EXISTS `tb_merchant_review_audit`;
CREATE TABLE `tb_merchant_review_audit`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NULL DEFAULT NULL,
  `user_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `merchant_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `content` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `hit_words` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `submitted_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'pending',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tb_merchant_review_audit
-- ----------------------------
INSERT INTO `tb_merchant_review_audit` VALUES (1, 3, '食客阿木', '锦味非遗食坊', '味道不错，就是老板说自家绝对全国第一，有点夸张。', '全国第一', '2026-04-28 18:30:00', 'pending', '2026-04-30 08:45:28', '2026-04-30 08:45:28');
INSERT INTO `tb_merchant_review_audit` VALUES (2, 5, '江湖吃货', '江南古味馆', '配送慢了一些，但产品还是很正宗。', '正宗', '2026-04-27 20:16:00', 'pending', '2026-04-30 08:45:28', '2026-04-30 08:45:28');

-- ----------------------------
-- Table structure for tb_merchant_sensitive_word
-- ----------------------------
DROP TABLE IF EXISTS `tb_merchant_sensitive_word`;
CREATE TABLE `tb_merchant_sensitive_word`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `word` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_merchant_sensitive_word`(`word` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 23 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tb_merchant_sensitive_word
-- ----------------------------
INSERT INTO `tb_merchant_sensitive_word` VALUES (1, '全国第一', '2026-04-29 23:06:21', '2026-04-29 23:06:21');
INSERT INTO `tb_merchant_sensitive_word` VALUES (2, '包治百病', '2026-04-29 23:06:21', '2026-04-29 23:06:21');
INSERT INTO `tb_merchant_sensitive_word` VALUES (3, '官方唯一', '2026-04-29 23:06:21', '2026-04-29 23:06:21');
INSERT INTO `tb_merchant_sensitive_word` VALUES (4, '祖传秘方', '2026-04-29 23:06:21', '2026-04-29 23:06:21');
INSERT INTO `tb_merchant_sensitive_word` VALUES (22, '祖传秘方包过敏', '2026-04-30 08:45:28', '2026-04-30 08:45:28');

-- ----------------------------
-- Table structure for tb_merchant_settlement
-- ----------------------------
DROP TABLE IF EXISTS `tb_merchant_settlement`;
CREATE TABLE `tb_merchant_settlement`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `merchant_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `period` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `order_count` int NOT NULL DEFAULT 0,
  `turnover` decimal(12, 2) NOT NULL DEFAULT 0.00,
  `commission_amount` decimal(12, 2) NOT NULL DEFAULT 0.00,
  `payable_amount` decimal(12, 2) NOT NULL DEFAULT 0.00,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'pending',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_merchant_settlement_user_id`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tb_merchant_settlement
-- ----------------------------
INSERT INTO `tb_merchant_settlement` VALUES (1, 3, '锦味非遗食坊', '2026-04-01 至 2026-04-15', 132, 32860.00, 3943.20, 28916.80, 'pending', '2026-04-16 09:00:00', '2026-04-16 09:00:00');
INSERT INTO `tb_merchant_settlement` VALUES (2, 5, '江南古味馆', '2026-04-01 至 2026-04-15', 79, 18320.00, 1832.00, 16488.00, 'paid', '2026-04-16 09:00:00', '2026-04-25 11:30:00');

-- ----------------------------
-- Table structure for tb_merchant_withdrawal
-- ----------------------------
DROP TABLE IF EXISTS `tb_merchant_withdrawal`;
CREATE TABLE `tb_merchant_withdrawal`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `merchant_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `amount` decimal(12, 2) NOT NULL DEFAULT 0.00,
  `account_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `account_no` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `submitted_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'pending',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_merchant_withdrawal_user_id`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tb_merchant_withdrawal
-- ----------------------------
INSERT INTO `tb_merchant_withdrawal` VALUES (1, 3, '锦味非遗食坊', 2400.00, '王青山', '6222 **** **** 8891', '2026-04-28 15:12:00', 'pending', '2026-04-28 15:12:00', '2026-04-28 15:12:00');
INSERT INTO `tb_merchant_withdrawal` VALUES (2, 5, '江南古味馆', 1500.00, '周南枫', '6217 **** **** 1032', '2026-04-27 09:08:00', 'pending', '2026-04-27 09:08:00', '2026-04-27 09:08:00');

-- ----------------------------
-- Table structure for tb_order
-- ----------------------------
DROP TABLE IF EXISTS `tb_order`;
CREATE TABLE `tb_order`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '订单ID',
  `order_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '订单号',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `total_amount` decimal(10, 2) NOT NULL COMMENT '总金额',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '订单状态：0-待支付，1-已支付，2-已发货，3-已完成，4-已取消',
  `receiver_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '收货人姓名',
  `receiver_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '收货人电话',
  `receiver_address` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '收货人地址',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_order_no`(`order_no` ASC) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_created_at`(`created_at` ASC) USING BTREE,
  CONSTRAINT `fk_order_user` FOREIGN KEY (`user_id`) REFERENCES `tb_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '订单表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tb_order
-- ----------------------------
INSERT INTO `tb_order` VALUES (1, 'ORD20260425001', 8637, 176.00, 1, '张三', '13800138000', '北京市朝阳区朝阳路1号', '尽快送达', '2026-04-25 18:10:29', '2026-04-25 18:10:29');
INSERT INTO `tb_order` VALUES (2, 'ORD20260425002', 3, 144.00, 2, '李四', '13900139000', '上海市浦东新区浦东大道1号', '周末配送', '2026-04-25 18:10:29', '2026-04-25 18:10:29');
INSERT INTO `tb_order` VALUES (3, 'ORD20260425003', 4, 30.00, 0, '王五', '13700137000', '广州市天河区天河路1号', NULL, '2026-04-25 18:10:29', '2026-04-25 18:10:29');
INSERT INTO `tb_order` VALUES (5, 'ORD17771146172019462C966', 8637, 128.00, 0, '张三', '13800138000', '河南省郑州市金水区文化路1号', '', '2026-04-25 10:56:57', '2026-04-25 10:56:57');
INSERT INTO `tb_order` VALUES (6, 'ORD1777114737341C782E5F7', 8637, 128.00, 0, '张三', '13800138000', '河南省郑州市金水区文化路1号', '', '2026-04-25 10:58:57', '2026-04-25 10:58:57');
INSERT INTO `tb_order` VALUES (7, 'ORD1777114824604A476D59A', 8637, 128.00, 0, '张三', '13800138000', '河南省郑州市金水区文化路1号', '', '2026-04-25 11:00:25', '2026-04-25 11:00:25');
INSERT INTO `tb_order` VALUES (8, 'ORD1777114926244920DCB24', 8637, 128.00, 0, '张三', '13800138000', '河南省郑州市金水区文化路1号', '', '2026-04-25 11:02:06', '2026-04-25 11:02:06');
INSERT INTO `tb_order` VALUES (9, 'ORD1777115040141C559BE19', 8637, 128.00, 4, '张三', '13800138000', '河南省郑州市金水区文化路1号', '', '2026-04-25 11:04:00', '2026-04-25 11:04:14');
INSERT INTO `tb_order` VALUES (10, 'ORD1777115074955F47E97CD', 8637, 128.00, 0, '张三', '13800138000', '河南省郑州市金水区文化路1号', '', '2026-04-25 11:04:35', '2026-04-25 11:04:35');
INSERT INTO `tb_order` VALUES (11, 'ORD1777191497832103CB3BD', 8637, 216.00, 0, '张三', '13800138000', '河南省郑州市金水区文化路1号', '', '2026-04-26 08:18:18', '2026-04-26 08:18:18');
INSERT INTO `tb_order` VALUES (12, 'ORD1777192079289F6997DCD', 8637, 216.00, 0, '张三', '13800138000', '河南省郑州市金水区文化路1号', '', '2026-04-26 08:27:59', '2026-04-26 08:27:59');
INSERT INTO `tb_order` VALUES (13, 'ORD1777192111661A4A6D08A', 8637, 216.00, 0, '张三', '13800138000', '河南省郑州市金水区文化路1号', '', '2026-04-26 08:28:32', '2026-04-26 08:28:32');
INSERT INTO `tb_order` VALUES (14, 'ORD1778260643545DAA5E01E', 8637, 344.00, 0, '张三', '13800138000', '河南省郑州市金水区文化路1号', '', '2026-05-08 17:17:24', '2026-05-08 17:17:24');

-- ----------------------------
-- Table structure for tb_order_item
-- ----------------------------
DROP TABLE IF EXISTS `tb_order_item`;
CREATE TABLE `tb_order_item`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '订单商品ID',
  `order_id` int NOT NULL COMMENT '订单ID',
  `product_id` int NOT NULL COMMENT '商品ID',
  `product_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '商品名称',
  `cover_image` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '商品图片',
  `price` decimal(10, 2) NOT NULL COMMENT '商品价格',
  `quantity` int NOT NULL COMMENT '数量',
  `subtotal` decimal(10, 2) NOT NULL COMMENT '小计',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_order_id`(`order_id` ASC) USING BTREE,
  INDEX `idx_product_id`(`product_id` ASC) USING BTREE,
  CONSTRAINT `fk_order_item_order` FOREIGN KEY (`order_id`) REFERENCES `tb_order` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_order_item_product` FOREIGN KEY (`product_id`) REFERENCES `tb_product` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 29 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '订单商品表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tb_order_item
-- ----------------------------
INSERT INTO `tb_order_item` VALUES (1, 1, 1, '北京烤鸭', '/images/beijing-duck.jpg', 88.00, 2, 176.00, '2026-04-25 18:10:29');
INSERT INTO `tb_order_item` VALUES (2, 2, 3, '广州早茶', '/images/guangzhou-dimsum.jpg', 48.00, 3, 144.00, '2026-04-25 18:10:29');
INSERT INTO `tb_order_item` VALUES (3, 3, 4, '开封灌汤包', '/images/kaifeng-guantangbao.jpg', 30.00, 1, 30.00, '2026-04-25 18:10:29');
INSERT INTO `tb_order_item` VALUES (4, 5, 2, '上海小笼包', '/images/shanghai-xiaolongbao.jpg', 32.00, 1, 32.00, '2026-04-25 10:56:57');
INSERT INTO `tb_order_item` VALUES (5, 5, 3, '广州早茶', '/images/guangzhou-dimsum.jpg', 48.00, 2, 96.00, '2026-04-25 10:56:57');
INSERT INTO `tb_order_item` VALUES (6, 6, 2, '上海小笼包', '/images/shanghai-xiaolongbao.jpg', 32.00, 1, 32.00, '2026-04-25 10:58:57');
INSERT INTO `tb_order_item` VALUES (7, 6, 3, '广州早茶', '/images/guangzhou-dimsum.jpg', 48.00, 2, 96.00, '2026-04-25 10:58:57');
INSERT INTO `tb_order_item` VALUES (8, 7, 2, '上海小笼包', '/images/shanghai-xiaolongbao.jpg', 32.00, 1, 32.00, '2026-04-25 11:00:25');
INSERT INTO `tb_order_item` VALUES (9, 7, 3, '广州早茶', '/images/guangzhou-dimsum.jpg', 48.00, 2, 96.00, '2026-04-25 11:00:25');
INSERT INTO `tb_order_item` VALUES (10, 8, 2, '上海小笼包', '/images/shanghai-xiaolongbao.jpg', 32.00, 1, 32.00, '2026-04-25 11:02:06');
INSERT INTO `tb_order_item` VALUES (11, 8, 3, '广州早茶', '/images/guangzhou-dimsum.jpg', 48.00, 2, 96.00, '2026-04-25 11:02:06');
INSERT INTO `tb_order_item` VALUES (12, 9, 2, '上海小笼包', '/images/shanghai-xiaolongbao.jpg', 32.00, 1, 32.00, '2026-04-25 11:04:00');
INSERT INTO `tb_order_item` VALUES (13, 9, 3, '广州早茶', '/images/guangzhou-dimsum.jpg', 48.00, 2, 96.00, '2026-04-25 11:04:00');
INSERT INTO `tb_order_item` VALUES (14, 10, 2, '上海小笼包', '/images/shanghai-xiaolongbao.jpg', 32.00, 1, 32.00, '2026-04-25 11:04:35');
INSERT INTO `tb_order_item` VALUES (15, 10, 3, '广州早茶', '/images/guangzhou-dimsum.jpg', 48.00, 2, 96.00, '2026-04-25 11:04:35');
INSERT INTO `tb_order_item` VALUES (16, 11, 1, '北京烤鸭', '/images/beijing-duck.jpg', 88.00, 1, 88.00, '2026-04-26 08:18:18');
INSERT INTO `tb_order_item` VALUES (17, 11, 2, '上海小笼包', '/images/shanghai-xiaolongbao.jpg', 32.00, 1, 32.00, '2026-04-26 08:18:18');
INSERT INTO `tb_order_item` VALUES (18, 11, 3, '广州早茶', '/images/guangzhou-dimsum.jpg', 48.00, 2, 96.00, '2026-04-26 08:18:18');
INSERT INTO `tb_order_item` VALUES (19, 12, 1, '北京烤鸭', '/images/beijing-duck.jpg', 88.00, 1, 88.00, '2026-04-26 08:27:59');
INSERT INTO `tb_order_item` VALUES (20, 12, 2, '上海小笼包', '/images/shanghai-xiaolongbao.jpg', 32.00, 1, 32.00, '2026-04-26 08:27:59');
INSERT INTO `tb_order_item` VALUES (21, 12, 3, '广州早茶', '/images/guangzhou-dimsum.jpg', 48.00, 2, 96.00, '2026-04-26 08:27:59');
INSERT INTO `tb_order_item` VALUES (22, 13, 1, '北京烤鸭', '/images/beijing-duck.jpg', 88.00, 1, 88.00, '2026-04-26 08:28:32');
INSERT INTO `tb_order_item` VALUES (23, 13, 2, '上海小笼包', '/images/shanghai-xiaolongbao.jpg', 32.00, 1, 32.00, '2026-04-26 08:28:32');
INSERT INTO `tb_order_item` VALUES (24, 13, 3, '广州早茶', '/images/guangzhou-dimsum.jpg', 48.00, 2, 96.00, '2026-04-26 08:28:32');
INSERT INTO `tb_order_item` VALUES (25, 14, 1, '北京烤鸭', '/images/beijing-duck.jpg', 88.00, 1, 88.00, '2026-05-08 17:17:24');
INSERT INTO `tb_order_item` VALUES (26, 14, 2, '上海小笼包', '/images/shanghai-xiaolongbao.jpg', 32.00, 1, 32.00, '2026-05-08 17:17:24');
INSERT INTO `tb_order_item` VALUES (27, 14, 3, '广州早茶', '/images/guangzhou-dimsum.jpg', 48.00, 2, 96.00, '2026-05-08 17:17:24');
INSERT INTO `tb_order_item` VALUES (28, 14, 5, '洛阳水席', '/images/luoyang-shuixi.jpg', 128.00, 1, 128.00, '2026-05-08 17:17:24');

-- ----------------------------
-- Table structure for tb_payment
-- ----------------------------
DROP TABLE IF EXISTS `tb_payment`;
CREATE TABLE `tb_payment`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '支付记录ID',
  `order_id` int NOT NULL COMMENT '订单ID',
  `payment_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '支付流水号',
  `user_id` int NOT NULL COMMENT '用户ID',
  `payment_method` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '支付方式',
  `payment_status` tinyint NOT NULL DEFAULT 0 COMMENT '支付状态：0-待支付，1-支付成功，2-支付失败',
  `transaction_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '交易流水号',
  `amount` decimal(10, 2) NOT NULL COMMENT '支付金额',
  `paid_at` datetime NULL DEFAULT NULL COMMENT '支付时间',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_order_id`(`order_id` ASC) USING BTREE,
  INDEX `idx_payment_status`(`payment_status` ASC) USING BTREE,
  INDEX `idx_paid_at`(`paid_at` ASC) USING BTREE,
  CONSTRAINT `fk_payment_order` FOREIGN KEY (`order_id`) REFERENCES `tb_order` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 23 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '支付记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tb_payment
-- ----------------------------
INSERT INTO `tb_payment` VALUES (1, 1, '', 0, 'alipay', 1, 'ALI20260425001', 176.00, '2026-04-25 10:00:00', '2026-04-25 18:10:29', '2026-04-25 18:10:29');
INSERT INTO `tb_payment` VALUES (2, 2, '', 0, 'wechat', 1, 'WX20260425001', 144.00, '2026-04-25 11:00:00', '2026-04-25 18:10:29', '2026-04-25 18:10:29');
INSERT INTO `tb_payment` VALUES (3, 3, '', 0, 'alipay', 0, NULL, 30.00, NULL, '2026-04-25 18:10:29', '2026-04-25 18:10:29');
INSERT INTO `tb_payment` VALUES (4, 6, 'PAY1777114807014AF23BBFF', 8637, 'alipay', 0, NULL, 128.00, NULL, '2026-04-25 11:00:07', '2026-04-25 11:00:07');
INSERT INTO `tb_payment` VALUES (5, 7, 'PAY17771148257755217F56D', 8637, 'alipay', 0, NULL, 128.00, NULL, '2026-04-25 11:00:26', '2026-04-25 11:00:26');
INSERT INTO `tb_payment` VALUES (6, 8, 'PAY1777114928091D6FDF30C', 8637, 'wechat', 0, NULL, 128.00, NULL, '2026-04-25 11:02:08', '2026-04-25 11:02:08');
INSERT INTO `tb_payment` VALUES (11, 9, 'PAY1777115041517F3392E52', 8637, 'alipay', 0, NULL, 128.00, NULL, '2026-04-25 11:04:02', '2026-04-25 11:04:02');
INSERT INTO `tb_payment` VALUES (14, 10, 'PAY1777115076212C015EDE7', 8637, 'alipay', 0, NULL, 128.00, NULL, '2026-04-25 11:04:36', '2026-04-25 11:04:36');
INSERT INTO `tb_payment` VALUES (19, 11, 'PAY177719150046940306339', 8637, 'alipay', 0, NULL, 216.00, NULL, '2026-04-26 08:18:20', '2026-04-26 08:18:20');
INSERT INTO `tb_payment` VALUES (20, 12, 'PAY1777192085562616FB31C', 8637, 'alipay', 0, NULL, 216.00, NULL, '2026-04-26 08:28:06', '2026-04-26 08:28:06');
INSERT INTO `tb_payment` VALUES (21, 13, 'PAY1777192627944438DEC07', 8637, 'alipay', 0, NULL, 216.00, NULL, '2026-04-26 08:37:08', '2026-04-26 08:37:08');

-- ----------------------------
-- Table structure for tb_permission
-- ----------------------------
DROP TABLE IF EXISTS `tb_permission`;
CREATE TABLE `tb_permission`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '权限ID',
  `permission_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '权限名称',
  `permission_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '权限标识',
  `resource_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '资源类型：menu-菜单，button-按钮，api-接口',
  `resource_url` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '资源路径',
  `parent_id` bigint NULL DEFAULT 0 COMMENT '父权限ID',
  `description` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '权限描述',
  `status` tinyint NULL DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `permission_name`(`permission_name` ASC) USING BTREE,
  UNIQUE INDEX `permission_key`(`permission_key` ASC) USING BTREE,
  INDEX `idx_permission_name`(`permission_name` ASC) USING BTREE,
  INDEX `idx_permission_key`(`permission_key` ASC) USING BTREE,
  INDEX `idx_parent_id`(`parent_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '权限表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tb_permission
-- ----------------------------
INSERT INTO `tb_permission` VALUES (1, '系统管理', 'system', 'menu', '/admin', 0, '系统管理菜单', 1, '2026-04-14 17:20:22', '2026-04-14 17:20:22');
INSERT INTO `tb_permission` VALUES (2, '用户管理', 'system:user', 'menu', '/admin/users', 1, '用户管理菜单', 1, '2026-04-14 17:20:22', '2026-04-14 17:20:22');
INSERT INTO `tb_permission` VALUES (3, '查看用户', 'system:user:view', 'button', '', 2, '查看用户按钮', 1, '2026-04-14 17:20:22', '2026-04-14 17:20:22');
INSERT INTO `tb_permission` VALUES (4, '添加用户', 'system:user:add', 'button', '', 2, '添加用户按钮', 1, '2026-04-14 17:20:22', '2026-04-14 17:20:22');
INSERT INTO `tb_permission` VALUES (5, '编辑用户', 'system:user:edit', 'button', '', 2, '编辑用户按钮', 1, '2026-04-14 17:20:22', '2026-04-14 17:20:22');
INSERT INTO `tb_permission` VALUES (6, '删除用户', 'system:user:delete', 'button', '', 2, '删除用户按钮', 1, '2026-04-14 17:20:22', '2026-04-14 17:20:22');
INSERT INTO `tb_permission` VALUES (7, '角色管理', 'system:role', 'menu', '/admin/roles', 1, '角色管理菜单', 1, '2026-04-14 17:20:22', '2026-04-14 17:20:22');
INSERT INTO `tb_permission` VALUES (8, '查看角色', 'system:role:view', 'button', '', 7, '查看角色按钮', 1, '2026-04-14 17:20:22', '2026-04-14 17:20:22');
INSERT INTO `tb_permission` VALUES (9, '添加角色', 'system:role:add', 'button', '', 7, '添加角色按钮', 1, '2026-04-14 17:20:22', '2026-04-14 17:20:22');
INSERT INTO `tb_permission` VALUES (10, '编辑角色', 'system:role:edit', 'button', '', 7, '编辑角色按钮', 1, '2026-04-14 17:20:22', '2026-04-14 17:20:22');
INSERT INTO `tb_permission` VALUES (11, '删除角色', 'system:role:delete', 'button', '', 7, '删除角色按钮', 1, '2026-04-14 17:20:22', '2026-04-14 17:20:22');
INSERT INTO `tb_permission` VALUES (12, '权限管理', 'system:permission', 'menu', '/admin/permissions', 1, '权限管理菜单', 1, '2026-04-14 17:20:22', '2026-04-14 17:20:22');
INSERT INTO `tb_permission` VALUES (13, '查看权限', 'system:permission:view', 'button', '', 12, '查看权限按钮', 1, '2026-04-14 17:20:22', '2026-04-14 17:20:22');
INSERT INTO `tb_permission` VALUES (14, '添加权限', 'system:permission:add', 'button', '', 12, '添加权限按钮', 1, '2026-04-14 17:20:22', '2026-04-14 17:20:22');
INSERT INTO `tb_permission` VALUES (15, '编辑权限', 'system:permission:edit', 'button', '', 12, '编辑权限按钮', 1, '2026-04-14 17:20:22', '2026-04-14 17:20:22');
INSERT INTO `tb_permission` VALUES (16, '删除权限', 'system:permission:delete', 'button', '', 12, '删除权限按钮', 1, '2026-04-14 17:20:22', '2026-04-14 17:20:22');

-- ----------------------------
-- Table structure for tb_product
-- ----------------------------
DROP TABLE IF EXISTS `tb_product`;
CREATE TABLE `tb_product`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '商品ID',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '商品名称',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '商品描述',
  `price` decimal(10, 2) NOT NULL COMMENT '商品价格',
  `original_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '原价',
  `cover_image` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '封面图片',
  `images` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '商品图片，JSON格式',
  `category` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '商品分类',
  `stock` int NOT NULL DEFAULT 0 COMMENT '库存数量',
  `sales_count` int NOT NULL DEFAULT 0 COMMENT '销量',
  `rating` decimal(3, 1) NOT NULL DEFAULT 0.0 COMMENT '评分',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态：1-上架，0-下架',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_name`(`name` ASC) USING BTREE,
  INDEX `idx_category`(`category` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_price`(`price` ASC) USING BTREE,
  INDEX `idx_sales_count`(`sales_count` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '商品表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tb_product
-- ----------------------------
INSERT INTO `tb_product` VALUES (1, '北京烤鸭', '北京传统名菜，色泽红艳，肉质细嫩，肥而不腻', 88.00, 98.00, '/images/beijing-duck.jpg', NULL, '特色美食', 100, 0, 4.9, 1, '2026-04-25 17:32:27', '2026-04-25 17:46:17');
INSERT INTO `tb_product` VALUES (2, '上海小笼包', '上海经典小吃，外皮酥脆，内馅多汁，鲜香浓郁', 32.00, 38.00, '/images/shanghai-xiaolongbao.jpg', NULL, '特色美食', 150, 0, 4.8, 1, '2026-04-25 17:32:27', '2026-04-25 17:46:17');
INSERT INTO `tb_product` VALUES (3, '广州早茶', '广东特色美食，点心丰富，口味清淡，是广式早茶的代表', 48.00, 58.00, '/images/guangzhou-dimsum.jpg', NULL, '特色美食', 120, 0, 4.7, 1, '2026-04-25 17:32:27', '2026-04-25 17:46:17');
INSERT INTO `tb_product` VALUES (4, '开封灌汤包', '河南特色小吃，皮薄馅大，汤汁鲜美，开封传统名吃', 26.00, 30.00, '/images/kaifeng-guantangbao.jpg', NULL, '特色美食', 200, 0, 4.6, 1, '2026-04-25 17:32:27', '2026-04-25 17:46:17');
INSERT INTO `tb_product` VALUES (5, '洛阳水席', '河南传统宴席，菜品丰富，酸辣开胃，洛阳非遗美食', 128.00, 158.00, '/images/luoyang-shuixi.jpg', NULL, '特色美食', 80, 0, 4.9, 1, '2026-04-25 17:32:27', '2026-04-25 17:46:17');
INSERT INTO `tb_product` VALUES (6, '郑州烩面', '郑州传统面食，汤鲜面筋，羊肉汤底浓郁，河南名吃', 22.00, 26.00, '/images/zhengzhou-huimian.jpg', NULL, '特色美食', 250, 0, 4.5, 1, '2026-04-25 17:32:27', '2026-04-25 17:46:17');
INSERT INTO `tb_product` VALUES (7, '四川火锅', '四川非遗美食，麻辣鲜香，锅底醇厚，川渝特色', 168.00, 198.00, '/images/sichuan-hotpot.jpg', NULL, '特色美食', 60, 0, 4.9, 1, '2026-04-25 17:32:27', '2026-04-25 17:46:17');
INSERT INTO `tb_product` VALUES (8, '西安肉夹馍', '陕西传统小吃，外皮酥脆，肉馅饱满，秦地风味', 15.00, 18.00, '/images/xian-roujiamo.jpg', NULL, '特色美食', 300, 0, 4.7, 1, '2026-04-25 17:32:27', '2026-04-25 17:46:17');
INSERT INTO `tb_product` VALUES (9, '杭州西湖醋鱼', '杭州传统名菜，鱼肉鲜嫩，酸甜可口，江南风味', 68.00, 78.00, '/images/hangzhou-fish.jpg', NULL, '特色美食', 90, 0, 4.8, 1, '2026-04-25 17:32:27', '2026-04-25 17:46:17');

-- ----------------------------
-- Table structure for tb_role
-- ----------------------------
DROP TABLE IF EXISTS `tb_role`;
CREATE TABLE `tb_role`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色名称',
  `role_key` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色标识',
  `description` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '角色描述',
  `status` tinyint NULL DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `role_name`(`role_name` ASC) USING BTREE,
  UNIQUE INDEX `role_key`(`role_key` ASC) USING BTREE,
  INDEX `idx_role_name`(`role_name` ASC) USING BTREE,
  INDEX `idx_role_key`(`role_key` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '角色表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tb_role
-- ----------------------------
INSERT INTO `tb_role` VALUES (1, '超级管理员', 'super_admin', '拥有系统所有权限', 1, '2026-04-14 17:20:07', '2026-04-14 17:20:07');
INSERT INTO `tb_role` VALUES (2, '管理员', 'admin', '拥有系统管理权限', 1, '2026-04-14 17:20:07', '2026-04-14 17:20:07');
INSERT INTO `tb_role` VALUES (3, '普通用户', 'user', '普通用户权限', 1, '2026-04-14 17:20:07', '2026-04-14 17:20:07');
INSERT INTO `tb_role` VALUES (4, '商家', 'merchant', '平台入驻商家角色', 1, '2026-04-29 23:06:21', '2026-04-29 23:06:21');

-- ----------------------------
-- Table structure for tb_role_permission
-- ----------------------------
DROP TABLE IF EXISTS `tb_role_permission`;
CREATE TABLE `tb_role_permission`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '关联ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `permission_id` bigint NOT NULL COMMENT '权限ID',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_role_permission`(`role_id` ASC, `permission_id` ASC) USING BTREE,
  INDEX `idx_role_id`(`role_id` ASC) USING BTREE,
  INDEX `idx_permission_id`(`permission_id` ASC) USING BTREE,
  CONSTRAINT `tb_role_permission_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `tb_role` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `tb_role_permission_ibfk_2` FOREIGN KEY (`permission_id`) REFERENCES `tb_permission` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 42 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '角色权限关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tb_role_permission
-- ----------------------------
INSERT INTO `tb_role_permission` VALUES (1, 1, 1, '2026-04-14 17:20:36');
INSERT INTO `tb_role_permission` VALUES (2, 1, 2, '2026-04-14 17:20:36');
INSERT INTO `tb_role_permission` VALUES (3, 1, 7, '2026-04-14 17:20:36');
INSERT INTO `tb_role_permission` VALUES (4, 1, 12, '2026-04-14 17:20:36');
INSERT INTO `tb_role_permission` VALUES (5, 1, 3, '2026-04-14 17:20:36');
INSERT INTO `tb_role_permission` VALUES (6, 1, 4, '2026-04-14 17:20:36');
INSERT INTO `tb_role_permission` VALUES (7, 1, 5, '2026-04-14 17:20:36');
INSERT INTO `tb_role_permission` VALUES (8, 1, 6, '2026-04-14 17:20:36');
INSERT INTO `tb_role_permission` VALUES (9, 1, 8, '2026-04-14 17:20:36');
INSERT INTO `tb_role_permission` VALUES (10, 1, 9, '2026-04-14 17:20:36');
INSERT INTO `tb_role_permission` VALUES (11, 1, 10, '2026-04-14 17:20:36');
INSERT INTO `tb_role_permission` VALUES (12, 1, 11, '2026-04-14 17:20:36');
INSERT INTO `tb_role_permission` VALUES (13, 1, 13, '2026-04-14 17:20:36');
INSERT INTO `tb_role_permission` VALUES (14, 1, 14, '2026-04-14 17:20:36');
INSERT INTO `tb_role_permission` VALUES (15, 1, 15, '2026-04-14 17:20:36');
INSERT INTO `tb_role_permission` VALUES (16, 1, 16, '2026-04-14 17:20:36');
INSERT INTO `tb_role_permission` VALUES (32, 2, 1, '2026-04-14 17:20:36');
INSERT INTO `tb_role_permission` VALUES (33, 2, 2, '2026-04-14 17:20:36');
INSERT INTO `tb_role_permission` VALUES (34, 2, 4, '2026-04-14 17:20:36');
INSERT INTO `tb_role_permission` VALUES (35, 2, 6, '2026-04-14 17:20:36');
INSERT INTO `tb_role_permission` VALUES (36, 2, 5, '2026-04-14 17:20:36');
INSERT INTO `tb_role_permission` VALUES (37, 2, 3, '2026-04-14 17:20:36');
INSERT INTO `tb_role_permission` VALUES (39, 3, 1, '2026-04-14 17:20:36');
INSERT INTO `tb_role_permission` VALUES (40, 3, 2, '2026-04-14 17:20:36');
INSERT INTO `tb_role_permission` VALUES (41, 3, 3, '2026-04-14 17:20:36');

-- ----------------------------
-- Table structure for tb_settings
-- ----------------------------
DROP TABLE IF EXISTS `tb_settings`;
CREATE TABLE `tb_settings`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '配置键',
  `value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '配置值',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '配置描述',
  `status` int NULL DEFAULT 1 COMMENT '状态：1=启用，0=禁用',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `key`(`key` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 30 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '系统配置表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tb_settings
-- ----------------------------
INSERT INTO `tb_settings` VALUES (1, 'basic.siteName', 'heritage-food-frontend', '网站名称', 1, '2026-04-15 09:19:38', '2026-04-15 09:19:38');
INSERT INTO `tb_settings` VALUES (2, 'basic.siteDomain', 'http://localhost:3000', '网站域名', 1, '2026-04-15 09:19:38', '2026-04-15 09:19:38');
INSERT INTO `tb_settings` VALUES (3, 'basic.siteDescription', '美食传承与分享平台', '网站描述', 1, '2026-04-15 09:19:38', '2026-04-15 09:19:38');
INSERT INTO `tb_settings` VALUES (4, 'basic.siteKeywords', '美食,传承,文化,分享', '网站关键词', 1, '2026-04-15 09:19:38', '2026-04-15 09:19:38');
INSERT INTO `tb_settings` VALUES (5, 'basic.contactEmail', 'contact@example.com', '联系邮箱', 1, '2026-04-15 09:19:38', '2026-04-15 09:19:38');
INSERT INTO `tb_settings` VALUES (6, 'basic.contactPhone', '13800138000', '联系电话', 1, '2026-04-15 09:19:38', '2026-04-15 09:19:38');
INSERT INTO `tb_settings` VALUES (7, 'basic.icpNumber', '京ICP备12345678号', 'ICP备案号', 1, '2026-04-15 09:19:38', '2026-04-15 09:19:38');
INSERT INTO `tb_settings` VALUES (8, 'basic.copyright', '© 2026 heritage-food-frontend. All rights reserved.', '版权信息', 1, '2026-04-15 09:19:38', '2026-04-15 09:19:38');
INSERT INTO `tb_settings` VALUES (9, 'features.userRegistration', 'true', '用户注册功能', 1, '2026-04-15 09:19:38', '2026-04-15 09:19:38');
INSERT INTO `tb_settings` VALUES (10, 'features.userLogin', 'true', '用户登录功能', 1, '2026-04-15 09:19:38', '2026-04-15 09:19:38');
INSERT INTO `tb_settings` VALUES (11, 'features.communityPosting', 'true', '社区发帖功能', 1, '2026-04-15 09:19:38', '2026-04-15 09:19:38');
INSERT INTO `tb_settings` VALUES (12, 'features.commentFunction', 'true', '评论功能', 1, '2026-04-15 09:19:38', '2026-04-15 09:19:38');
INSERT INTO `tb_settings` VALUES (13, 'features.collectionFunction', 'true', '收藏功能', 1, '2026-04-15 09:19:38', '2026-04-15 09:19:38');
INSERT INTO `tb_settings` VALUES (14, 'features.searchFunction', 'true', '搜索功能', 1, '2026-04-15 09:19:38', '2026-04-15 09:19:38');
INSERT INTO `tb_settings` VALUES (15, 'features.mapFunction', 'true', '地图功能', 1, '2026-04-15 09:19:38', '2026-04-15 09:19:38');
INSERT INTO `tb_settings` VALUES (16, 'features.tasteTest', 'true', '品鉴功能', 1, '2026-04-15 09:19:38', '2026-04-15 09:19:38');
INSERT INTO `tb_settings` VALUES (17, 'security.apiKey', 'test-api-key', 'API密钥', 1, '2026-04-15 09:19:38', '2026-04-15 09:19:38');
INSERT INTO `tb_settings` VALUES (18, 'security.jwtSecret', 'test-jwt-secret', 'JWT密钥', 1, '2026-04-15 09:19:38', '2026-04-15 09:19:38');
INSERT INTO `tb_settings` VALUES (19, 'security.loginTimeout', '30', '登录超时时间（分钟）', 1, '2026-04-15 09:19:38', '2026-04-15 09:19:38');
INSERT INTO `tb_settings` VALUES (20, 'security.passwordComplexity', 'medium', '密码复杂度要求', 1, '2026-04-15 09:19:38', '2026-04-15 09:19:38');
INSERT INTO `tb_settings` VALUES (21, 'security.ipRestriction', 'false', 'IP限制', 1, '2026-04-15 09:19:38', '2026-04-15 09:19:38');
INSERT INTO `tb_settings` VALUES (22, 'security.captcha', 'true', '验证码功能', 1, '2026-04-15 09:19:38', '2026-04-15 09:19:38');
INSERT INTO `tb_settings` VALUES (23, 'storage.storageType', 'local', '存储类型', 1, '2026-04-15 09:19:38', '2026-04-15 09:19:38');
INSERT INTO `tb_settings` VALUES (24, 'storage.localPath', './uploads', '本地存储路径', 1, '2026-04-15 09:19:38', '2026-04-15 09:19:38');
INSERT INTO `tb_settings` VALUES (25, 'storage.cloudService', 'aliyun', '云存储服务', 1, '2026-04-15 09:19:38', '2026-04-15 09:19:38');
INSERT INTO `tb_settings` VALUES (26, 'storage.accessKey', '', '云存储访问密钥', 1, '2026-04-15 09:19:38', '2026-04-15 09:19:38');
INSERT INTO `tb_settings` VALUES (27, 'storage.secretKey', '', '云存储 secret 密钥', 1, '2026-04-15 09:19:38', '2026-04-15 09:19:38');
INSERT INTO `tb_settings` VALUES (28, 'storage.bucketName', '', '云存储桶名称', 1, '2026-04-15 09:19:38', '2026-04-15 09:19:38');
INSERT INTO `tb_settings` VALUES (29, 'storage.fileSizeLimit', '10', '文件大小限制（MB）', 1, '2026-04-15 09:19:38', '2026-04-15 09:19:38');

-- ----------------------------
-- Table structure for tb_store
-- ----------------------------
DROP TABLE IF EXISTS `tb_store`;
CREATE TABLE `tb_store`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `longitude` decimal(10, 6) NOT NULL,
  `latitude` decimal(10, 6) NOT NULL,
  `contact` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `opening_hours` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `introduction` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `score` decimal(2, 1) NOT NULL DEFAULT 0.0,
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 38 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tb_store
-- ----------------------------
INSERT INTO `tb_store` VALUES (1, '全聚德烤鸭店', '北京市东城区前门大街30号', 116.397400, 39.896400, '010-67011379', '10:00-22:00', '全聚德是中国历史悠久的烤鸭品牌，创立于1864年，以挂炉烤鸭为特色，是北京烤鸭的代表品牌之一。', 4.8, '2026-03-26 18:25:37', '2026-03-27 18:03:34');
INSERT INTO `tb_store` VALUES (2, '便宜坊烤鸭店', '北京市东城区前门大街50号', 116.398000, 39.895000, '010-67011333', '10:00-22:00', '便宜坊创立于明永乐十四年（1416年），是北京历史最悠久的烤鸭店之一，以焖炉烤鸭工艺著称。', 4.6, '2026-03-26 18:25:37', '2026-03-27 18:03:36');
INSERT INTO `tb_store` VALUES (3, '大董烤鸭店', '北京市东城区东四十条22号', 116.420000, 39.930000, '010-65822892', '10:00-22:00', '大董烤鸭店以其创新的烤鸭工艺和精致的菜品而闻名，是北京高端烤鸭的代表品牌。', 4.9, '2026-03-26 18:25:37', '2026-03-27 18:03:36');
INSERT INTO `tb_store` VALUES (4, '南翔馒头店', '上海市黄浦区豫园路85号', 121.492700, 31.230400, '021-63555034', '09:00-21:00', '南翔馒头店创建于清光绪二十六年（1900年），是上海著名的传统小吃店，以小笼包闻名。', 4.7, '2026-03-26 18:25:37', '2026-03-27 18:03:37');
INSERT INTO `tb_store` VALUES (5, '鼎泰丰', '上海市静安区南京西路100号', 121.458700, 31.223400, '021-62568282', '09:00-21:00', '鼎泰丰是台湾知名小笼包品牌，以其精致的小笼包和优质的服务受到广泛欢迎。', 4.8, '2026-03-26 18:25:37', '2026-03-27 18:03:38');
INSERT INTO `tb_store` VALUES (6, '陶陶居', '广州市越秀区第十甫路20号', 113.247900, 23.120000, '020-81396111', '08:00-22:00', '陶陶居创立于清光绪六年（1880年），是广州历史悠久的老字号酒家，以粤菜和广式点心闻名。', 4.9, '2026-03-26 18:25:37', '2026-03-27 18:03:39');
INSERT INTO `tb_store` VALUES (7, '广州酒家', '广州市荔湾区上下九步行街第十甫路2号', 113.258300, 23.120000, '020-81380388', '08:00-22:00', '广州酒家创立于1935年，是广州著名的老字号酒家，以正宗粤菜和广式早茶闻名。', 4.8, '2026-03-26 18:25:37', '2026-03-27 18:03:41');
INSERT INTO `tb_store` VALUES (8, '海底捞火锅', '成都市锦江区红星路三段1号', 104.066800, 30.657800, '028-86781111', '10:00-24:00', '海底捞火锅是中国著名的火锅连锁品牌，以其优质的服务和美味的火锅而闻名全国。', 4.8, '2026-03-26 18:25:37', '2026-03-27 18:03:46');
INSERT INTO `tb_store` VALUES (9, '小龙坎火锅', '成都市青羊区宽窄巷子10号', 104.069900, 30.674500, '028-86666666', '10:00-24:00', '小龙坎火锅是成都著名的火锅品牌，以其麻辣鲜香的味道和正宗的川味受到欢迎。', 4.7, '2026-03-26 18:25:37', '2026-03-27 18:03:47');
INSERT INTO `tb_store` VALUES (10, '合记烩面', '郑州市金水区人民路12号', 113.665400, 34.757900, '0371-66223344', '09:00-22:00', '合记烩面是郑州著名的传统面食店，创立于1953年，以其正宗的羊肉烩面而闻名。', 4.8, '2026-03-26 18:25:37', '2026-03-27 18:03:48');
INSERT INTO `tb_store` VALUES (11, '开封第一楼', '开封市鼓楼区中山路89号', 114.354500, 34.801600, '0371-25663191', '09:00-22:00', '开封第一楼创立于1922年，是河南著名的老字号酒家，以其灌汤包和传统豫菜闻名。', 4.7, '2026-03-26 18:25:37', '2026-03-27 18:03:49');
INSERT INTO `tb_store` VALUES (12, '洛阳水席楼', '洛阳市西工区中州中路100号', 112.453600, 34.615400, '0379-63931666', '10:00-22:00', '洛阳水席楼是河南著名的传统酒家，以洛阳水席为特色，传承千年饮食文化。', 4.9, '2026-03-26 18:25:37', '2026-03-28 20:09:15');
INSERT INTO `tb_store` VALUES (28, '狗不理包子铺', '天津市和平区山东路77号', 117.200000, 39.130000, '022-27305888', '08:00-21:00', '狗不理是天津著名的老字号包子铺，创立于1858年，以其独特的包子制作工艺闻名全国。', 4.7, '2026-04-29 17:51:44', '2026-04-29 17:51:44');
INSERT INTO `tb_store` VALUES (29, '知味观', '杭州市上城区延安路135号', 120.150000, 30.280000, '0571-87065871', '09:00-21:00', '知味观是杭州著名的老字号餐饮品牌，创立于1913年，以杭帮菜和特色点心著称。', 4.8, '2026-04-29 17:51:44', '2026-04-29 17:51:44');
INSERT INTO `tb_store` VALUES (30, '楼外楼', '杭州市西湖区孤山路30号', 120.130000, 30.230000, '0571-87969682', '10:00-21:00', '楼外楼创立于1848年，是杭州最具代表性的老字号酒家，以西湖醋鱼等传统杭帮菜闻名。', 4.9, '2026-04-29 17:51:44', '2026-04-29 17:51:44');
INSERT INTO `tb_store` VALUES (31, '松鹤楼', '苏州市姑苏区观前街141号', 120.620000, 31.320000, '0512-67281888', '11:00-21:00', '松鹤楼是苏州著名的老字号苏菜馆，创立于清乾隆年间，以正宗苏帮菜闻名海内外。', 4.8, '2026-04-29 17:51:44', '2026-04-29 17:51:44');
INSERT INTO `tb_store` VALUES (32, '杏花楼', '上海市黄浦区福州路343号', 121.490000, 31.230000, '021-63283288', '08:00-21:00', '杏花楼创立于1851年，是上海著名的粤菜老字号，以广式月饼和传统粤菜闻名。', 4.7, '2026-04-29 17:51:44', '2026-04-29 17:51:44');
INSERT INTO `tb_store` VALUES (33, '莲香楼', '广州市荔湾区上下九步行街', 113.250000, 23.120000, '020-81383388', '08:00-22:00', '莲香楼创立于1889年，是广州著名的老字号酒家，以莲蓉月饼和广式点心著称。', 4.8, '2026-04-29 17:51:44', '2026-04-29 17:51:44');
INSERT INTO `tb_store` VALUES (34, '四季美汤包', '武汉市江汉区中山大道858号', 114.280000, 30.590000, '027-82833388', '09:00-21:00', '四季美汤包是武汉著名的老字号小吃店，创立于1922年，以其鲜美的汤包闻名。', 4.7, '2026-04-29 17:51:44', '2026-04-29 17:51:44');
INSERT INTO `tb_store` VALUES (35, '老通城豆皮', '武汉市武昌区民主路127号', 114.310000, 30.540000, '027-88877788', '07:00-19:00', '老通城豆皮创立于1929年，是武汉著名的老字号，以三鲜豆皮为特色美食。', 4.8, '2026-04-29 17:51:44', '2026-04-29 17:51:44');
INSERT INTO `tb_store` VALUES (36, '马洪小炒泡馍', '西安市莲湖区回民街', 108.950000, 34.270000, '029-87251111', '09:00-22:00', '马洪小炒泡馍是西安著名的老字号泡馍店，以其独特的小炒泡馍风味深受喜爱。', 4.6, '2026-04-29 17:51:44', '2026-04-29 17:51:44');
INSERT INTO `tb_store` VALUES (37, '老孙家羊肉泡馍', '西安市碑林区东大街364号', 108.950000, 34.270000, '029-87214438', '08:00-21:00', '老孙家创立于1898年，是西安著名的老字号泡馍店，以传统羊肉泡馍闻名。', 4.7, '2026-04-29 17:51:44', '2026-04-29 17:51:44');

-- ----------------------------
-- Table structure for tb_store_activity
-- ----------------------------
DROP TABLE IF EXISTS `tb_store_activity`;
CREATE TABLE `tb_store_activity`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `store_id` bigint NOT NULL,
  `activity_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `activity_rule` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `start_time` datetime NOT NULL,
  `end_time` datetime NOT NULL,
  `status` int NULL DEFAULT 1 COMMENT '1:进行中, 0:已结束',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_store_activity_store`(`store_id` ASC) USING BTREE,
  CONSTRAINT `fk_store_activity_store` FOREIGN KEY (`store_id`) REFERENCES `tb_store` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `tb_store_activity_ibfk_1` FOREIGN KEY (`store_id`) REFERENCES `tb_store` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 106 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tb_store_activity
-- ----------------------------
INSERT INTO `tb_store_activity` VALUES (28, 1, '满减优惠', '到店消费满200减50，烤鸭专享', '2026-03-28 10:00:00', '2026-04-30 22:00:00', 1, '2026-03-28 20:38:20');
INSERT INTO `tb_store_activity` VALUES (29, 1, '套餐特惠', '「烤鸭+煲仔饭」双人套餐立减30元', '2026-03-28 10:00:00', '2026-04-30 22:00:00', 1, '2026-03-28 20:38:20');
INSERT INTO `tb_store_activity` VALUES (30, 1, '会员折扣', '会员到店享9折，生日当天赠小吃', '2026-03-28 10:00:00', '2026-12-31 22:00:00', 1, '2026-03-28 20:38:20');
INSERT INTO `tb_store_activity` VALUES (31, 2, '满减优惠', '消费满150减30，白切鸡、煎饼果子可参与', '2026-03-28 10:00:00', '2026-04-30 22:00:00', 1, '2026-03-28 20:38:20');
INSERT INTO `tb_store_activity` VALUES (32, 2, '午市特惠', '10:00-14:00到店，点烤鸭赠酸梅汤', '2026-03-28 10:00:00', '2026-04-30 14:00:00', 1, '2026-03-28 20:38:20');
INSERT INTO `tb_store_activity` VALUES (33, 3, '高端套餐', '「鸭肝+凤爪+烤鸭」三人套餐赠红酒', '2026-03-28 10:00:00', '2026-04-30 22:00:00', 1, '2026-03-28 20:38:20');
INSERT INTO `tb_store_activity` VALUES (34, 3, '会员专享', '充值1000送200，鸭附件全单8折', '2026-03-28 10:00:00', '2026-12-31 22:00:00', 1, '2026-03-28 20:38:20');
INSERT INTO `tb_store_activity` VALUES (35, 4, '点心套餐', '小笼包+鸭汤双人餐立减20', '2026-03-28 09:00:00', '2026-04-30 21:00:00', 1, '2026-03-28 20:38:20');
INSERT INTO `tb_store_activity` VALUES (36, 4, '早茶特惠', '09:00-11:00到店，点鸭卷赠小菜', '2026-03-28 09:00:00', '2026-04-30 11:00:00', 1, '2026-03-28 20:38:20');
INSERT INTO `tb_store_activity` VALUES (37, 4, '满减优惠', '消费满100减20，点心类通用', '2026-03-28 09:00:00', '2026-04-30 21:00:00', 1, '2026-03-28 20:38:20');
INSERT INTO `tb_store_activity` VALUES (38, 5, '灌汤包特惠', '买2笼蟹黄灌汤包送1笼牛肉灌汤包', '2026-03-28 09:00:00', '2026-04-30 21:00:00', 1, '2026-03-28 20:38:20');
INSERT INTO `tb_store_activity` VALUES (39, 5, '会员折扣', '会员到店享8.8折，生日赠点心', '2026-03-28 09:00:00', '2026-12-31 21:00:00', 1, '2026-03-28 20:38:20');
INSERT INTO `tb_store_activity` VALUES (40, 6, '茶市套餐', '烩面+莲汤肉片双人餐赠茶位', '2026-03-28 08:00:00', '2026-04-30 22:00:00', 1, '2026-03-28 20:38:20');
INSERT INTO `tb_store_activity` VALUES (41, 6, '午市折扣', '11:00-14:00到店，全单9折', '2026-03-28 11:00:00', '2026-04-30 14:00:00', 1, '2026-03-28 20:38:20');
INSERT INTO `tb_store_activity` VALUES (42, 7, '早茶特惠', '08:00-10:00到店，小笼包买一送一', '2026-03-28 08:00:00', '2026-04-30 10:00:00', 1, '2026-03-28 20:38:20');
INSERT INTO `tb_store_activity` VALUES (43, 7, '满减优惠', '消费满120减30，点心类通用', '2026-03-28 08:00:00', '2026-04-30 22:00:00', 1, '2026-03-28 20:38:20');
INSERT INTO `tb_store_activity` VALUES (44, 7, '套餐特惠', '「红豆+三鲜小笼包」家庭餐赠甜品', '2026-03-28 08:00:00', '2026-04-30 22:00:00', 1, '2026-03-28 20:38:20');
INSERT INTO `tb_store_activity` VALUES (45, 8, '菜品满减', '毛肚、脑花单点满100减20', '2026-03-28 10:00:00', '2026-04-30 23:59:59', 1, '2026-03-28 20:39:15');
INSERT INTO `tb_store_activity` VALUES (46, 8, '夜宵特惠', '22:00-次日06:00，全单8折', '2026-03-28 22:00:00', '2026-04-30 06:00:00', 1, '2026-03-28 20:39:15');
INSERT INTO `tb_store_activity` VALUES (47, 9, '川味套餐', '「一鸭三吃+酸辣肚丝」双人餐赠冰粉', '2026-03-28 10:00:00', '2026-04-30 23:59:59', 1, '2026-03-28 20:39:15');
INSERT INTO `tb_store_activity` VALUES (48, 9, '满减优惠', '消费满200减60，川味菜品通用', '2026-03-28 10:00:00', '2026-04-30 23:59:59', 1, '2026-03-28 20:39:15');
INSERT INTO `tb_store_activity` VALUES (49, 10, '烩面套餐', '滋补烩面+鲜牛肉单人餐赠卤蛋', '2026-03-28 09:00:00', '2026-04-30 21:00:00', 1, '2026-03-28 20:39:15');
INSERT INTO `tb_store_activity` VALUES (50, 10, '午市特惠', '11:00-14:00到店，烩面第二份半价', '2026-03-28 11:00:00', '2026-04-30 14:00:00', 1, '2026-03-28 20:39:15');
INSERT INTO `tb_store_activity` VALUES (51, 11, '灌汤包特惠', '虾仁小笼包买2笼送1笼', '2026-03-28 09:00:00', '2026-04-30 21:00:00', 1, '2026-03-28 20:39:15');
INSERT INTO `tb_store_activity` VALUES (52, 11, '满减优惠', '消费满80减20，灌汤包类通用', '2026-03-28 09:00:00', '2026-04-30 21:00:00', 1, '2026-03-28 20:39:15');
INSERT INTO `tb_store_activity` VALUES (53, 12, '豫菜套餐', '鸭卷+特色凉菜双人餐赠汤品', '2026-03-28 10:00:00', '2026-04-30 22:00:00', 1, '2026-03-28 20:39:15');
INSERT INTO `tb_store_activity` VALUES (54, 12, '晚市折扣', '17:00-20:00到店，全单9折', '2026-03-28 17:00:00', '2026-04-30 20:00:00', 1, '2026-03-28 20:39:15');
INSERT INTO `tb_store_activity` VALUES (55, 12, '会员专享', '充值500送100，豫菜全单8.5折', '2026-03-28 10:00:00', '2026-12-31 22:00:00', 1, '2026-03-28 20:39:15');
INSERT INTO `tb_store_activity` VALUES (86, 28, '满减优惠', '消费满100减20，包子类通用', '2026-05-01 08:00:00', '2026-05-31 21:00:00', 1, '2026-04-29 18:04:32');
INSERT INTO `tb_store_activity` VALUES (87, 29, '早茶特惠', '09:00-11:00到店，点心8折', '2026-05-01 09:00:00', '2026-05-31 11:00:00', 1, '2026-04-29 18:04:32');
INSERT INTO `tb_store_activity` VALUES (88, 30, '套餐特惠', '西湖醋鱼+龙井虾仁双人餐立减30', '2026-05-01 10:00:00', '2026-05-31 21:00:00', 1, '2026-04-29 18:04:32');
INSERT INTO `tb_store_activity` VALUES (89, 31, '午市折扣', '11:00-14:00到店，全单9折', '2026-05-01 11:00:00', '2026-05-31 14:00:00', 1, '2026-04-29 18:04:32');
INSERT INTO `tb_store_activity` VALUES (90, 32, '月饼特惠', '广式月饼买二送一', '2026-05-01 08:00:00', '2026-05-31 21:00:00', 1, '2026-04-29 18:04:32');
INSERT INTO `tb_store_activity` VALUES (91, 33, '满减优惠', '消费满80减15，点心类通用', '2026-05-01 08:00:00', '2026-05-31 22:00:00', 1, '2026-04-29 18:04:32');
INSERT INTO `tb_store_activity` VALUES (92, 34, '汤包套餐', '三鲜汤包+鸭汤单人餐赠小菜', '2026-05-01 09:00:00', '2026-05-31 21:00:00', 1, '2026-04-29 18:04:32');
INSERT INTO `tb_store_activity` VALUES (93, 35, '豆皮特惠', '豆皮第二份半价', '2026-05-01 07:00:00', '2026-05-31 19:00:00', 1, '2026-04-29 18:04:32');
INSERT INTO `tb_store_activity` VALUES (94, 36, '泡馍套餐', '小炒泡馍+酸梅汤套餐立减10', '2026-05-01 09:00:00', '2026-05-31 22:00:00', 1, '2026-04-29 18:04:32');
INSERT INTO `tb_store_activity` VALUES (95, 37, '会员专享', '会员到店享8.5折', '2026-05-01 08:00:00', '2026-12-31 21:00:00', 1, '2026-04-29 18:04:32');
INSERT INTO `tb_store_activity` VALUES (96, 28, '满减优惠', '消费满100减20，包子类通用', '2026-05-01 08:00:00', '2026-05-31 21:00:00', 1, '2026-04-29 18:04:34');
INSERT INTO `tb_store_activity` VALUES (97, 29, '早茶特惠', '09:00-11:00到店，点心8折', '2026-05-01 09:00:00', '2026-05-31 11:00:00', 1, '2026-04-29 18:04:34');
INSERT INTO `tb_store_activity` VALUES (98, 30, '套餐特惠', '西湖醋鱼+龙井虾仁双人餐立减30', '2026-05-01 10:00:00', '2026-05-31 21:00:00', 1, '2026-04-29 18:04:34');
INSERT INTO `tb_store_activity` VALUES (99, 31, '午市折扣', '11:00-14:00到店，全单9折', '2026-05-01 11:00:00', '2026-05-31 14:00:00', 1, '2026-04-29 18:04:34');
INSERT INTO `tb_store_activity` VALUES (100, 32, '月饼特惠', '广式月饼买二送一', '2026-05-01 08:00:00', '2026-05-31 21:00:00', 1, '2026-04-29 18:04:34');
INSERT INTO `tb_store_activity` VALUES (101, 33, '满减优惠', '消费满80减15，点心类通用', '2026-05-01 08:00:00', '2026-05-31 22:00:00', 1, '2026-04-29 18:04:34');
INSERT INTO `tb_store_activity` VALUES (102, 34, '汤包套餐', '三鲜汤包+鸭汤单人餐赠小菜', '2026-05-01 09:00:00', '2026-05-31 21:00:00', 1, '2026-04-29 18:04:34');
INSERT INTO `tb_store_activity` VALUES (103, 35, '豆皮特惠', '豆皮第二份半价', '2026-05-01 07:00:00', '2026-05-31 19:00:00', 1, '2026-04-29 18:04:34');
INSERT INTO `tb_store_activity` VALUES (104, 36, '泡馍套餐', '小炒泡馍+酸梅汤套餐立减10', '2026-05-01 09:00:00', '2026-05-31 22:00:00', 1, '2026-04-29 18:04:34');
INSERT INTO `tb_store_activity` VALUES (105, 37, '会员专享', '会员到店享8.5折', '2026-05-01 08:00:00', '2026-12-31 21:00:00', 1, '2026-04-29 18:04:34');

-- ----------------------------
-- Table structure for tb_store_rating
-- ----------------------------
DROP TABLE IF EXISTS `tb_store_rating`;
CREATE TABLE `tb_store_rating`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `store_id` bigint NOT NULL COMMENT '店铺ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `score` tinyint NOT NULL COMMENT '评分 1-5星',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '评价内容',
  `images` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '评价图片，逗号分隔',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '评价时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_store_id`(`store_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 65 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '店铺评价表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tb_store_rating
-- ----------------------------
INSERT INTO `tb_store_rating` VALUES (1, 1, 1, 5, '烤鸭皮脆肉嫩，卷饼吃太绝了，服务也很周到', '', '2026-03-28 20:00:00');
INSERT INTO `tb_store_rating` VALUES (2, 1, 2, 4, '经典京味，煲仔饭锅巴焦香，就是价格有点小贵', '', '2026-03-28 20:01:00');
INSERT INTO `tb_store_rating` VALUES (3, 1, 3, 5, '百年老店品质在线，家人聚餐很合适', '', '2026-03-28 20:02:00');
INSERT INTO `tb_store_rating` VALUES (4, 2, 4, 4, '白切鸡皮黄肉嫩，煎饼果子酱香浓郁，性价比高', '', '2026-03-28 20:03:00');
INSERT INTO `tb_store_rating` VALUES (5, 2, 5, 5, '老北京味儿地道，午市特惠很划算', '', '2026-03-28 20:04:00');
INSERT INTO `tb_store_rating` VALUES (6, 3, 6, 5, '高端体验拉满，鸭肝、凤爪都精致，适合商务宴请', '', '2026-03-28 20:05:00');
INSERT INTO `tb_store_rating` VALUES (7, 3, 7, 4, '环境优雅，就是分量偏少，适合浅尝', '', '2026-03-28 20:06:00');
INSERT INTO `tb_store_rating` VALUES (8, 3, 8, 5, '细节到位，服务员会帮忙片鸭，体验感很好', '', '2026-03-28 20:07:00');
INSERT INTO `tb_store_rating` VALUES (9, 4, 9, 5, '小笼包皮薄馅大，鸭汤鲜美，上海本帮味正', '', '2026-03-28 20:08:00');
INSERT INTO `tb_store_rating` VALUES (10, 4, 10, 4, '早茶特惠很良心，鸭卷紧实有嚼劲，推荐', '', '2026-03-28 20:09:00');
INSERT INTO `tb_store_rating` VALUES (11, 5, 1, 5, '灌汤包一口爆汁，蟹黄饱满，品质稳定', '', '2026-03-28 20:10:00');
INSERT INTO `tb_store_rating` VALUES (12, 5, 2, 4, '服务贴心，就是排队久，建议错峰来', '', '2026-03-28 20:11:00');
INSERT INTO `tb_store_rating` VALUES (13, 5, 3, 5, '台湾风味地道，小朋友也爱吃', '', '2026-03-28 20:12:00');
INSERT INTO `tb_store_rating` VALUES (14, 6, 4, 4, '广式茶餐厅氛围，烩面筋道，莲汤肉片清爽', '', '2026-03-28 20:13:00');
INSERT INTO `tb_store_rating` VALUES (15, 6, 5, 5, '茶位费划算，午市折扣给力，朋友小聚首选', '', '2026-03-28 20:14:00');
INSERT INTO `tb_store_rating` VALUES (16, 7, 6, 5, '早茶天花板！小笼包买一送一，红豆馅香甜不腻', '', '2026-03-28 20:15:00');
INSERT INTO `tb_store_rating` VALUES (17, 7, 7, 4, '三鲜小笼包鲜掉眉毛，就是人多要等座', '', '2026-03-28 20:16:00');
INSERT INTO `tb_store_rating` VALUES (18, 7, 8, 5, '老广记忆中的味道，家庭聚餐氛围好', '', '2026-03-28 20:17:00');
INSERT INTO `tb_store_rating` VALUES (19, 8, 9, 5, '毛肚、脑花必点！夜宵折扣太香了，服务还是那么好', '', '2026-03-28 20:18:00');
INSERT INTO `tb_store_rating` VALUES (20, 8, 10, 4, '川味够劲，就是太辣了，不能吃辣慎点', '', '2026-03-28 20:19:00');
INSERT INTO `tb_store_rating` VALUES (21, 9, 1, 5, '一鸭三吃太适合聚会！酸辣肚丝开胃，川味十足', '', '2026-03-28 20:20:00');
INSERT INTO `tb_store_rating` VALUES (22, 9, 2, 4, '满减优惠给力，就是环境有点吵', '', '2026-03-28 20:21:00');
INSERT INTO `tb_store_rating` VALUES (23, 10, 3, 5, '滋补烩面汤浓味厚，鲜牛肉扎实，河南老家味儿', '', '2026-03-28 20:22:00');
INSERT INTO `tb_store_rating` VALUES (24, 10, 4, 4, '午市第二份半价，性价比拉满，适合上班族', '', '2026-03-28 20:23:00');
INSERT INTO `tb_store_rating` VALUES (25, 10, 5, 5, '暖乎乎一碗下肚，秋冬吃超治愈', '', '2026-03-28 20:24:00');
INSERT INTO `tb_store_rating` VALUES (26, 11, 6, 5, '灌汤包咬开爆汁，虾仁小笼包鲜掉眉毛，开封必吃', '', '2026-03-28 20:25:00');
INSERT INTO `tb_store_rating` VALUES (27, 11, 7, 4, '鸭酥酥香化渣，配酒超棒，就是有点油', '', '2026-03-28 20:26:00');
INSERT INTO `tb_store_rating` VALUES (28, 12, 8, 5, '鸭卷凉菜很精致，豫菜套餐分量足，晚市折扣友好', '', '2026-03-28 20:27:00');
INSERT INTO `tb_store_rating` VALUES (29, 12, 9, 4, '水席特色鲜明，就是口味偏咸，适合重口', '', '2026-03-28 20:28:00');
INSERT INTO `tb_store_rating` VALUES (30, 12, 10, 5, '洛阳旅行必吃，体验地道豫菜文化', '', '2026-03-28 20:29:00');
INSERT INTO `tb_store_rating` VALUES (31, 1, 9, 4, '烤鸭经典，但煲仔饭有点油，整体不错', '', '2026-03-28 20:30:00');
INSERT INTO `tb_store_rating` VALUES (32, 2, 10, 5, '煎饼果子太香了，老北京味儿地道', '', '2026-03-28 20:31:00');
INSERT INTO `tb_store_rating` VALUES (33, 3, 1, 4, '高端精致，适合纪念日约会', '', '2026-03-28 20:32:00');
INSERT INTO `tb_store_rating` VALUES (34, 4, 2, 5, '小笼包+鸭汤，完美的上海早餐', '', '2026-03-28 20:33:00');
INSERT INTO `tb_store_rating` VALUES (35, 5, 3, 4, '灌汤包鲜，但价格偏贵', '', '2026-03-28 20:34:00');
INSERT INTO `tb_store_rating` VALUES (36, 6, 4, 5, '广式茶点地道，莲汤肉片清爽解腻', '', '2026-03-28 20:35:00');
INSERT INTO `tb_store_rating` VALUES (37, 7, 5, 4, '早茶人多，建议早点来占座', '', '2026-03-28 20:36:00');
INSERT INTO `tb_store_rating` VALUES (38, 8, 6, 5, '夜宵党福音，22点后折扣太香', '', '2026-03-28 20:37:00');
INSERT INTO `tb_store_rating` VALUES (39, 9, 7, 4, '川味够劲，冰粉解辣绝了', '', '2026-03-28 20:38:00');
INSERT INTO `tb_store_rating` VALUES (40, 10, 8, 5, '烩面筋道，暖乎乎一碗太舒服', '', '2026-03-28 20:39:00');
INSERT INTO `tb_store_rating` VALUES (41, 11, 9, 4, '灌汤包经典，鸭酥适合下酒', '', '2026-03-28 20:40:00');
INSERT INTO `tb_store_rating` VALUES (42, 12, 10, 5, '豫菜文化浓厚，旅行打卡必来', '', '2026-03-28 20:41:00');
INSERT INTO `tb_store_rating` VALUES (43, 28, 1, 5, '包子味道正宗，皮薄馅大，值得推荐！', '', '2026-04-29 18:04:32');
INSERT INTO `tb_store_rating` VALUES (44, 28, 2, 4, '环境不错，服务态度好，下次还来。', '', '2026-04-29 18:04:32');
INSERT INTO `tb_store_rating` VALUES (45, 29, 1, 5, '西湖醋鱼非常地道，酸甜适口！', '', '2026-04-29 18:04:32');
INSERT INTO `tb_store_rating` VALUES (46, 30, 1, 5, '百年老店，味道名不虚传！', '', '2026-04-29 18:04:32');
INSERT INTO `tb_store_rating` VALUES (47, 31, 1, 4, '松鼠鳜鱼造型精美，味道也好。', '', '2026-04-29 18:04:32');
INSERT INTO `tb_store_rating` VALUES (48, 32, 1, 5, '广式月饼太好吃了，每年都买！', '', '2026-04-29 18:04:32');
INSERT INTO `tb_store_rating` VALUES (49, 33, 1, 4, '鸡仔饼很有特色，值得一试。', '', '2026-04-29 18:04:32');
INSERT INTO `tb_store_rating` VALUES (50, 34, 1, 5, '汤包汤汁鲜美，强烈推荐！', '', '2026-04-29 18:04:32');
INSERT INTO `tb_store_rating` VALUES (51, 35, 1, 4, '豆皮外酥里嫩，很有武汉特色。', '', '2026-04-29 18:04:32');
INSERT INTO `tb_store_rating` VALUES (52, 36, 1, 5, '小炒泡馍太香了，酸辣可口！', '', '2026-04-29 18:04:32');
INSERT INTO `tb_store_rating` VALUES (53, 37, 1, 5, '羊肉泡馍汤鲜味浓，馍烂肉香！', '', '2026-04-29 18:04:32');
INSERT INTO `tb_store_rating` VALUES (54, 28, 1, 5, '包子味道正宗，皮薄馅大，值得推荐！', '', '2026-04-29 18:04:34');
INSERT INTO `tb_store_rating` VALUES (55, 28, 2, 4, '环境不错，服务态度好，下次还来。', '', '2026-04-29 18:04:34');
INSERT INTO `tb_store_rating` VALUES (56, 29, 1, 5, '西湖醋鱼非常地道，酸甜适口！', '', '2026-04-29 18:04:34');
INSERT INTO `tb_store_rating` VALUES (57, 30, 1, 5, '百年老店，味道名不虚传！', '', '2026-04-29 18:04:34');
INSERT INTO `tb_store_rating` VALUES (58, 31, 1, 4, '松鼠鳜鱼造型精美，味道也好。', '', '2026-04-29 18:04:34');
INSERT INTO `tb_store_rating` VALUES (59, 32, 1, 5, '广式月饼太好吃了，每年都买！', '', '2026-04-29 18:04:34');
INSERT INTO `tb_store_rating` VALUES (60, 33, 1, 4, '鸡仔饼很有特色，值得一试。', '', '2026-04-29 18:04:34');
INSERT INTO `tb_store_rating` VALUES (61, 34, 1, 5, '汤包汤汁鲜美，强烈推荐！', '', '2026-04-29 18:04:34');
INSERT INTO `tb_store_rating` VALUES (62, 35, 1, 4, '豆皮外酥里嫩，很有武汉特色。', '', '2026-04-29 18:04:34');
INSERT INTO `tb_store_rating` VALUES (63, 36, 1, 5, '小炒泡馍太香了，酸辣可口！', '', '2026-04-29 18:04:34');
INSERT INTO `tb_store_rating` VALUES (64, 37, 1, 5, '羊肉泡馍汤鲜味浓，馍烂肉香！', '', '2026-04-29 18:04:34');

-- ----------------------------
-- Table structure for tb_store_signature_food
-- ----------------------------
DROP TABLE IF EXISTS `tb_store_signature_food`;
CREATE TABLE `tb_store_signature_food`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `store_id` bigint NOT NULL COMMENT '店铺ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '美食名称',
  `image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '美食图片',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '描述',
  `price` decimal(10, 2) NULL DEFAULT NULL COMMENT '价格',
  `sort` int NULL DEFAULT 0 COMMENT '排序',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_store_id`(`store_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 145 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '店铺招牌美食' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tb_store_signature_food
-- ----------------------------
INSERT INTO `tb_store_signature_food` VALUES (1, 2, '广式烧鹅', 'guangzhou-dimsum.jpg', '皮脆肉嫩，肥而不腻，经典京味烧鹅，汁水丰盈', 128.00, 0, '2026-03-28 19:19:38');
INSERT INTO `tb_store_signature_food` VALUES (2, 1, '煲仔饭', 'clay-pot-rice.jpg', '腊味浓郁，锅气十足，米饭焦香，广东风味代表', 48.00, 0, '2026-03-28 19:19:38');
INSERT INTO `tb_store_signature_food` VALUES (3, 1, '煎饼果子', 'chinese-pancake.jpg', '外酥里嫩，酱香浓郁，传统北方街头小吃', 32.00, 0, '2026-03-28 19:19:38');
INSERT INTO `tb_store_signature_food` VALUES (4, 2, '白切鸡', 'white-cut-chicken.jpg', '皮黄肉白，肥嫩鲜美，原汁原味，京式烤鸡特色', 42.00, 0, '2026-03-28 19:19:38');
INSERT INTO `tb_store_signature_food` VALUES (5, 8, '毛肚', 'sichuan-hotpot.jpg', '脆嫩弹牙，麻辣鲜香，川味火锅必点内脏类食材', 58.00, 0, '2026-03-28 19:19:38');
INSERT INTO `tb_store_signature_food` VALUES (6, 9, '酸辣肚丝', 'suanla-dusi.jpg', '酸辣开胃，肚丝劲道，重口味爱好者首选', 36.00, 0, '2026-03-28 19:19:38');
INSERT INTO `tb_store_signature_food` VALUES (7, 3, '凤爪', 'chicken-feet.jpg', '筋道入味，椒香浓郁，卤香醇厚，下酒神菜', 68.00, 0, '2026-03-28 19:19:38');
INSERT INTO `tb_store_signature_food` VALUES (8, 3, '鸭肝', 'duck-liver.jpg', '粉嫩细腻，入口即化，富含油脂与卤香精华', 88.00, 0, '2026-03-28 19:19:38');
INSERT INTO `tb_store_signature_food` VALUES (9, 11, '鸭酥', 'duck-puff.jpg', '外酥里嫩，咸香适口，油炸经典，豫菜特色小吃', 98.00, 0, '2026-03-28 19:19:38');
INSERT INTO `tb_store_signature_food` VALUES (10, 12, '鸭卷', 'duck-roll.jpg', '卷制紧实，鸭香浓郁，口感丰富，豫菜凉菜优选', 52.00, 0, '2026-03-28 19:19:38');
INSERT INTO `tb_store_signature_food` VALUES (11, 4, '鸭汤', 'duck-soup.jpg', '汤色奶白，醇厚鲜美，温补养生，上海特色汤品', 68.00, 0, '2026-03-28 19:19:38');
INSERT INTO `tb_store_signature_food` VALUES (12, 9, '一鸭三吃', 'duck-three-ways.jpg', '一鸭多吃，吃法多样，皮脆肉嫩，满足不同口味', 138.00, 0, '2026-03-28 19:19:38');
INSERT INTO `tb_store_signature_food` VALUES (13, 5, '牛肉灌汤包', 'beef-guantangbao.jpg', '皮薄馅大，牛肉鲜香，汤汁浓郁，一口爆汁', 42.00, 0, '2026-03-28 19:19:38');
INSERT INTO `tb_store_signature_food` VALUES (14, 5, '蟹黄灌汤包', 'crab-guantangbao.jpg', '蟹黄饱满，蟹肉鲜甜，汤汁丰盈，鲜味极致', 58.00, 0, '2026-03-28 19:19:38');
INSERT INTO `tb_store_signature_food` VALUES (15, 10, '鲜牛肉', 'fresh-beef.jpg', '鲜嫩多汁，原汁原味，牛肉本味突出，豫菜硬菜', 46.00, 0, '2026-03-28 19:19:38');
INSERT INTO `tb_store_signature_food` VALUES (16, 6, '莲汤肉片', 'liantang-roupian.jpg', '汤鲜料足，肉片滑嫩，豫菜经典小炒，口感清爽', 32.00, 0, '2026-03-28 19:19:38');
INSERT INTO `tb_store_signature_food` VALUES (17, 6, '羊肉烩面', 'mutton-huimian.jpg', '面条筋道，羊肉鲜香，汤浓味厚，豫味面食代表', 38.00, 0, '2026-03-28 19:19:38');
INSERT INTO `tb_store_signature_food` VALUES (18, 11, '滋补烩面', 'nourishing-huimian.jpg', '滋补养生，汤汁浓郁，适合秋冬季节，暖胃暖心', 36.00, 0, '2026-03-28 19:19:38');
INSERT INTO `tb_store_signature_food` VALUES (19, 7, '红豆小笼包', 'redbean-xiaolongbao.jpg', '皮薄馅大，红豆香甜，甜而不腻，经典甜口包点', 28.00, 0, '2026-03-28 19:19:38');
INSERT INTO `tb_store_signature_food` VALUES (20, 7, '三鲜小笼包', 'sanxian-xiaolongbao.jpg', '鲜香味美，三鲜荟萃，一口爆汁，广式经典代表', 32.00, 0, '2026-03-28 19:19:38');
INSERT INTO `tb_store_signature_food` VALUES (21, 11, '虾仁小笼包', 'shrimp-xiaolongbao.jpg', '虾仁饱满，口感弹牙，鲜掉眉毛，豫式点心代表', 22.00, 0, '2026-03-28 19:19:38');
INSERT INTO `tb_store_signature_food` VALUES (22, 8, '脑花', 'brain.jpg', '嫩滑细腻，麻辣入味，火锅特色食材，口感绵密', 32.00, 0, '2026-03-28 19:19:38');
INSERT INTO `tb_store_signature_food` VALUES (23, 9, '重庆毛血旺', 'chongqing-maoxuewang.jpg', '麻辣鲜香，血嫩毛脆，川渝代表菜', 58.00, 0, '2026-03-28 20:26:50');
INSERT INTO `tb_store_signature_food` VALUES (24, 10, '河南炸酥肉', 'henan-zhasurou.jpg', '外酥里嫩，咸香适口，豫菜经典小吃', 26.00, 0, '2026-03-28 20:26:50');
INSERT INTO `tb_store_signature_food` VALUES (25, 13, '狗不理包子', NULL, '皮薄馅大，汁多味鲜，天津传统名点', 38.00, 0, '2026-04-29 17:51:44');
INSERT INTO `tb_store_signature_food` VALUES (26, 13, '蟹黄包', NULL, '蟹黄饱满，鲜香浓郁，时令美味', 68.00, 1, '2026-04-29 17:51:44');
INSERT INTO `tb_store_signature_food` VALUES (27, 14, '西湖醋鱼', NULL, '色泽红亮，酸甜适口，杭州名菜', 88.00, 0, '2026-04-29 17:51:44');
INSERT INTO `tb_store_signature_food` VALUES (28, 14, '龙井虾仁', NULL, '茶香清新，虾仁鲜嫩', 98.00, 1, '2026-04-29 17:51:44');
INSERT INTO `tb_store_signature_food` VALUES (29, 15, '西湖醋鱼', NULL, '活鱼现杀，酸甜适口', 128.00, 0, '2026-04-29 17:51:44');
INSERT INTO `tb_store_signature_food` VALUES (30, 15, '叫化鸡', NULL, '荷叶包裹，泥封烤制，香气四溢', 138.00, 1, '2026-04-29 17:51:44');
INSERT INTO `tb_store_signature_food` VALUES (31, 16, '松鼠鳜鱼', NULL, '外酥里嫩，酸甜适口，苏菜代表', 168.00, 0, '2026-04-29 17:51:44');
INSERT INTO `tb_store_signature_food` VALUES (32, 16, '响油鳝糊', NULL, '油亮鲜香，胡椒味浓', 78.00, 1, '2026-04-29 17:51:44');
INSERT INTO `tb_store_signature_food` VALUES (33, 17, '广式月饼', NULL, '皮薄馅足，莲蓉细腻', 28.00, 0, '2026-04-29 17:51:44');
INSERT INTO `tb_store_signature_food` VALUES (34, 17, '叉烧包', NULL, '叉烧馅料饱满，鲜香可口', 32.00, 1, '2026-04-29 17:51:44');
INSERT INTO `tb_store_signature_food` VALUES (35, 18, '鸡仔饼', NULL, '咸甜适中，口感酥脆', 32.00, 0, '2026-04-29 17:51:44');
INSERT INTO `tb_store_signature_food` VALUES (36, 18, '莲蓉包', NULL, '莲蓉细腻，甜而不腻', 28.00, 1, '2026-04-29 17:51:44');
INSERT INTO `tb_store_signature_food` VALUES (37, 19, '三鲜汤包', NULL, '皮薄馅嫩，汤汁鲜美', 48.00, 0, '2026-04-29 17:51:44');
INSERT INTO `tb_store_signature_food` VALUES (38, 19, '蟹黄汤包', NULL, '蟹黄浓郁，鲜香可口', 68.00, 1, '2026-04-29 17:51:44');
INSERT INTO `tb_store_signature_food` VALUES (39, 20, '三鲜豆皮', NULL, '外酥内软，馅料丰富', 28.00, 0, '2026-04-29 17:51:44');
INSERT INTO `tb_store_signature_food` VALUES (40, 20, '牛肉豆皮', NULL, '牛肉香浓，口感丰富', 32.00, 1, '2026-04-29 17:51:44');
INSERT INTO `tb_store_signature_food` VALUES (41, 21, '小炒泡馍', NULL, '馍粒筋道，酸辣鲜香', 36.00, 0, '2026-04-29 17:51:44');
INSERT INTO `tb_store_signature_food` VALUES (42, 21, '优质羊肉泡馍', NULL, '羊肉酥烂，汤鲜味浓', 48.00, 1, '2026-04-29 17:51:44');
INSERT INTO `tb_store_signature_food` VALUES (43, 22, '羊肉泡馍', NULL, '汤鲜味浓，馍烂肉香', 42.00, 0, '2026-04-29 17:51:44');
INSERT INTO `tb_store_signature_food` VALUES (44, 22, '牛肉泡馍', NULL, '牛肉酥烂，味道醇厚', 38.00, 1, '2026-04-29 17:51:44');
INSERT INTO `tb_store_signature_food` VALUES (45, 23, '狗不理包子', NULL, '皮薄馅大，汁多味鲜，天津传统名点', 38.00, 0, '2026-04-29 17:58:20');
INSERT INTO `tb_store_signature_food` VALUES (46, 23, '蟹黄包', NULL, '蟹黄饱满，鲜香浓郁', 68.00, 1, '2026-04-29 17:58:20');
INSERT INTO `tb_store_signature_food` VALUES (47, 24, '西湖醋鱼', NULL, '色泽红亮，酸甜适口', 88.00, 0, '2026-04-29 17:58:20');
INSERT INTO `tb_store_signature_food` VALUES (48, 24, '龙井虾仁', NULL, '茶香清新，虾仁鲜嫩', 98.00, 1, '2026-04-29 17:58:20');
INSERT INTO `tb_store_signature_food` VALUES (49, 25, '西湖醋鱼', NULL, '活鱼现杀，酸甜适口', 128.00, 0, '2026-04-29 17:58:20');
INSERT INTO `tb_store_signature_food` VALUES (50, 25, '叫化鸡', NULL, '荷叶包裹，泥封烤制', 138.00, 1, '2026-04-29 17:58:20');
INSERT INTO `tb_store_signature_food` VALUES (51, 26, '松鼠鳜鱼', NULL, '外酥里嫩，酸甜适口', 168.00, 0, '2026-04-29 17:58:20');
INSERT INTO `tb_store_signature_food` VALUES (52, 26, '响油鳝糊', NULL, '油亮鲜香，胡椒味浓', 78.00, 1, '2026-04-29 17:58:20');
INSERT INTO `tb_store_signature_food` VALUES (53, 27, '广式月饼', NULL, '皮薄馅足，莲蓉细腻', 28.00, 0, '2026-04-29 17:58:20');
INSERT INTO `tb_store_signature_food` VALUES (54, 27, '叉烧包', NULL, '叉烧馅料饱满', 32.00, 1, '2026-04-29 17:58:20');
INSERT INTO `tb_store_signature_food` VALUES (55, 28, '鸡仔饼', NULL, '咸甜适中，口感酥脆', 32.00, 0, '2026-04-29 17:58:20');
INSERT INTO `tb_store_signature_food` VALUES (56, 28, '莲蓉包', NULL, '莲蓉细腻，甜而不腻', 28.00, 1, '2026-04-29 17:58:20');
INSERT INTO `tb_store_signature_food` VALUES (57, 29, '三鲜汤包', NULL, '皮薄馅嫩，汤汁鲜美', 48.00, 0, '2026-04-29 17:58:20');
INSERT INTO `tb_store_signature_food` VALUES (58, 29, '蟹黄汤包', NULL, '蟹黄浓郁，鲜香可口', 68.00, 1, '2026-04-29 17:58:20');
INSERT INTO `tb_store_signature_food` VALUES (59, 30, '三鲜豆皮', NULL, '外酥内软，馅料丰富', 28.00, 0, '2026-04-29 17:58:20');
INSERT INTO `tb_store_signature_food` VALUES (60, 30, '牛肉豆皮', NULL, '牛肉香浓，口感丰富', 32.00, 1, '2026-04-29 17:58:20');
INSERT INTO `tb_store_signature_food` VALUES (61, 31, '小炒泡馍', NULL, '馍粒筋道，酸辣鲜香', 36.00, 0, '2026-04-29 17:58:20');
INSERT INTO `tb_store_signature_food` VALUES (62, 31, '优质羊肉泡馍', NULL, '羊肉酥烂，汤鲜味浓', 48.00, 1, '2026-04-29 17:58:20');
INSERT INTO `tb_store_signature_food` VALUES (63, 32, '羊肉泡馍', NULL, '汤鲜味浓，馍烂肉香', 42.00, 0, '2026-04-29 17:58:20');
INSERT INTO `tb_store_signature_food` VALUES (64, 32, '牛肉泡馍', NULL, '牛肉酥烂，味道醇厚', 38.00, 1, '2026-04-29 17:58:20');
INSERT INTO `tb_store_signature_food` VALUES (65, 23, '狗不理包子', NULL, '皮薄馅大，汁多味鲜，天津传统名点', 38.00, 0, '2026-04-29 17:58:22');
INSERT INTO `tb_store_signature_food` VALUES (66, 23, '蟹黄包', NULL, '蟹黄饱满，鲜香浓郁', 68.00, 1, '2026-04-29 17:58:22');
INSERT INTO `tb_store_signature_food` VALUES (67, 24, '西湖醋鱼', NULL, '色泽红亮，酸甜适口', 88.00, 0, '2026-04-29 17:58:22');
INSERT INTO `tb_store_signature_food` VALUES (68, 24, '龙井虾仁', NULL, '茶香清新，虾仁鲜嫩', 98.00, 1, '2026-04-29 17:58:22');
INSERT INTO `tb_store_signature_food` VALUES (69, 25, '西湖醋鱼', NULL, '活鱼现杀，酸甜适口', 128.00, 0, '2026-04-29 17:58:22');
INSERT INTO `tb_store_signature_food` VALUES (70, 25, '叫化鸡', NULL, '荷叶包裹，泥封烤制', 138.00, 1, '2026-04-29 17:58:22');
INSERT INTO `tb_store_signature_food` VALUES (71, 26, '松鼠鳜鱼', NULL, '外酥里嫩，酸甜适口', 168.00, 0, '2026-04-29 17:58:22');
INSERT INTO `tb_store_signature_food` VALUES (72, 26, '响油鳝糊', NULL, '油亮鲜香，胡椒味浓', 78.00, 1, '2026-04-29 17:58:22');
INSERT INTO `tb_store_signature_food` VALUES (73, 27, '广式月饼', NULL, '皮薄馅足，莲蓉细腻', 28.00, 0, '2026-04-29 17:58:22');
INSERT INTO `tb_store_signature_food` VALUES (74, 27, '叉烧包', NULL, '叉烧馅料饱满', 32.00, 1, '2026-04-29 17:58:22');
INSERT INTO `tb_store_signature_food` VALUES (75, 28, '鸡仔饼', NULL, '咸甜适中，口感酥脆', 32.00, 0, '2026-04-29 17:58:22');
INSERT INTO `tb_store_signature_food` VALUES (76, 28, '莲蓉包', NULL, '莲蓉细腻，甜而不腻', 28.00, 1, '2026-04-29 17:58:22');
INSERT INTO `tb_store_signature_food` VALUES (77, 29, '三鲜汤包', NULL, '皮薄馅嫩，汤汁鲜美', 48.00, 0, '2026-04-29 17:58:22');
INSERT INTO `tb_store_signature_food` VALUES (78, 29, '蟹黄汤包', NULL, '蟹黄浓郁，鲜香可口', 68.00, 1, '2026-04-29 17:58:22');
INSERT INTO `tb_store_signature_food` VALUES (79, 30, '三鲜豆皮', NULL, '外酥内软，馅料丰富', 28.00, 0, '2026-04-29 17:58:22');
INSERT INTO `tb_store_signature_food` VALUES (80, 30, '牛肉豆皮', NULL, '牛肉香浓，口感丰富', 32.00, 1, '2026-04-29 17:58:22');
INSERT INTO `tb_store_signature_food` VALUES (81, 31, '小炒泡馍', NULL, '馍粒筋道，酸辣鲜香', 36.00, 0, '2026-04-29 17:58:22');
INSERT INTO `tb_store_signature_food` VALUES (82, 31, '优质羊肉泡馍', NULL, '羊肉酥烂，汤鲜味浓', 48.00, 1, '2026-04-29 17:58:22');
INSERT INTO `tb_store_signature_food` VALUES (83, 32, '羊肉泡馍', NULL, '汤鲜味浓，馍烂肉香', 42.00, 0, '2026-04-29 17:58:22');
INSERT INTO `tb_store_signature_food` VALUES (84, 32, '牛肉泡馍', NULL, '牛肉酥烂，味道醇厚', 38.00, 1, '2026-04-29 17:58:22');
INSERT INTO `tb_store_signature_food` VALUES (85, 13, '狗不理包子', NULL, '皮薄馅大，汁多味鲜，天津传统名点', 38.00, 0, '2026-04-29 18:01:37');
INSERT INTO `tb_store_signature_food` VALUES (86, 13, '蟹黄包', NULL, '蟹黄饱满，鲜香浓郁', 68.00, 1, '2026-04-29 18:01:37');
INSERT INTO `tb_store_signature_food` VALUES (87, 14, '西湖醋鱼', NULL, '色泽红亮，酸甜适口', 88.00, 0, '2026-04-29 18:01:37');
INSERT INTO `tb_store_signature_food` VALUES (88, 14, '龙井虾仁', NULL, '茶香清新，虾仁鲜嫩', 98.00, 1, '2026-04-29 18:01:37');
INSERT INTO `tb_store_signature_food` VALUES (89, 15, '西湖醋鱼', NULL, '活鱼现杀，酸甜适口', 128.00, 0, '2026-04-29 18:01:37');
INSERT INTO `tb_store_signature_food` VALUES (90, 15, '叫化鸡', NULL, '荷叶包裹，泥封烤制', 138.00, 1, '2026-04-29 18:01:37');
INSERT INTO `tb_store_signature_food` VALUES (91, 16, '松鼠鳜鱼', NULL, '外酥里嫩，酸甜适口', 168.00, 0, '2026-04-29 18:01:37');
INSERT INTO `tb_store_signature_food` VALUES (92, 16, '响油鳝糊', NULL, '油亮鲜香，胡椒味浓', 78.00, 1, '2026-04-29 18:01:37');
INSERT INTO `tb_store_signature_food` VALUES (93, 17, '广式月饼', NULL, '皮薄馅足，莲蓉细腻', 28.00, 0, '2026-04-29 18:01:37');
INSERT INTO `tb_store_signature_food` VALUES (94, 17, '叉烧包', NULL, '叉烧馅料饱满', 32.00, 1, '2026-04-29 18:01:37');
INSERT INTO `tb_store_signature_food` VALUES (95, 18, '鸡仔饼', NULL, '咸甜适中，口感酥脆', 32.00, 0, '2026-04-29 18:01:37');
INSERT INTO `tb_store_signature_food` VALUES (96, 18, '莲蓉包', NULL, '莲蓉细腻，甜而不腻', 28.00, 1, '2026-04-29 18:01:37');
INSERT INTO `tb_store_signature_food` VALUES (97, 19, '三鲜汤包', NULL, '皮薄馅嫩，汤汁鲜美', 48.00, 0, '2026-04-29 18:01:37');
INSERT INTO `tb_store_signature_food` VALUES (98, 19, '蟹黄汤包', NULL, '蟹黄浓郁，鲜香可口', 68.00, 1, '2026-04-29 18:01:37');
INSERT INTO `tb_store_signature_food` VALUES (99, 20, '三鲜豆皮', NULL, '外酥内软，馅料丰富', 28.00, 0, '2026-04-29 18:01:37');
INSERT INTO `tb_store_signature_food` VALUES (100, 20, '牛肉豆皮', NULL, '牛肉香浓，口感丰富', 32.00, 1, '2026-04-29 18:01:37');
INSERT INTO `tb_store_signature_food` VALUES (101, 21, '小炒泡馍', NULL, '馍粒筋道，酸辣鲜香', 36.00, 0, '2026-04-29 18:01:37');
INSERT INTO `tb_store_signature_food` VALUES (102, 21, '优质羊肉泡馍', NULL, '羊肉酥烂，汤鲜味浓', 48.00, 1, '2026-04-29 18:01:37');
INSERT INTO `tb_store_signature_food` VALUES (103, 22, '羊肉泡馍', NULL, '汤鲜味浓，馍烂肉香', 42.00, 0, '2026-04-29 18:01:37');
INSERT INTO `tb_store_signature_food` VALUES (104, 22, '牛肉泡馍', NULL, '牛肉酥烂，味道醇厚', 38.00, 1, '2026-04-29 18:01:37');
INSERT INTO `tb_store_signature_food` VALUES (105, 28, '狗不理包子', NULL, '皮薄馅大，汁多味鲜，天津传统名点', 38.00, 0, '2026-04-29 18:04:32');
INSERT INTO `tb_store_signature_food` VALUES (106, 28, '蟹黄包', NULL, '蟹黄饱满，鲜香浓郁', 68.00, 1, '2026-04-29 18:04:32');
INSERT INTO `tb_store_signature_food` VALUES (107, 29, '西湖醋鱼', NULL, '色泽红亮，酸甜适口', 88.00, 0, '2026-04-29 18:04:32');
INSERT INTO `tb_store_signature_food` VALUES (108, 29, '龙井虾仁', NULL, '茶香清新，虾仁鲜嫩', 98.00, 1, '2026-04-29 18:04:32');
INSERT INTO `tb_store_signature_food` VALUES (109, 30, '西湖醋鱼', NULL, '活鱼现杀，酸甜适口', 128.00, 0, '2026-04-29 18:04:32');
INSERT INTO `tb_store_signature_food` VALUES (110, 30, '叫化鸡', NULL, '荷叶包裹，泥封烤制', 138.00, 1, '2026-04-29 18:04:32');
INSERT INTO `tb_store_signature_food` VALUES (111, 31, '松鼠鳜鱼', NULL, '外酥里嫩，酸甜适口', 168.00, 0, '2026-04-29 18:04:32');
INSERT INTO `tb_store_signature_food` VALUES (112, 31, '响油鳝糊', NULL, '油亮鲜香，胡椒味浓', 78.00, 1, '2026-04-29 18:04:32');
INSERT INTO `tb_store_signature_food` VALUES (113, 32, '广式月饼', NULL, '皮薄馅足，莲蓉细腻', 28.00, 0, '2026-04-29 18:04:32');
INSERT INTO `tb_store_signature_food` VALUES (114, 32, '叉烧包', NULL, '叉烧馅料饱满', 32.00, 1, '2026-04-29 18:04:32');
INSERT INTO `tb_store_signature_food` VALUES (115, 33, '鸡仔饼', NULL, '咸甜适中，口感酥脆', 32.00, 0, '2026-04-29 18:04:32');
INSERT INTO `tb_store_signature_food` VALUES (116, 33, '莲蓉包', NULL, '莲蓉细腻，甜而不腻', 28.00, 1, '2026-04-29 18:04:32');
INSERT INTO `tb_store_signature_food` VALUES (117, 34, '三鲜汤包', NULL, '皮薄馅嫩，汤汁鲜美', 48.00, 0, '2026-04-29 18:04:32');
INSERT INTO `tb_store_signature_food` VALUES (118, 34, '蟹黄汤包', NULL, '蟹黄浓郁，鲜香可口', 68.00, 1, '2026-04-29 18:04:32');
INSERT INTO `tb_store_signature_food` VALUES (119, 35, '三鲜豆皮', NULL, '外酥内软，馅料丰富', 28.00, 0, '2026-04-29 18:04:32');
INSERT INTO `tb_store_signature_food` VALUES (120, 35, '牛肉豆皮', NULL, '牛肉香浓，口感丰富', 32.00, 1, '2026-04-29 18:04:32');
INSERT INTO `tb_store_signature_food` VALUES (121, 36, '小炒泡馍', NULL, '馍粒筋道，酸辣鲜香', 36.00, 0, '2026-04-29 18:04:32');
INSERT INTO `tb_store_signature_food` VALUES (122, 36, '优质羊肉泡馍', NULL, '羊肉酥烂，汤鲜味浓', 48.00, 1, '2026-04-29 18:04:32');
INSERT INTO `tb_store_signature_food` VALUES (123, 37, '羊肉泡馍', NULL, '汤鲜味浓，馍烂肉香', 42.00, 0, '2026-04-29 18:04:32');
INSERT INTO `tb_store_signature_food` VALUES (124, 37, '牛肉泡馍', NULL, '牛肉酥烂，味道醇厚', 38.00, 1, '2026-04-29 18:04:32');
INSERT INTO `tb_store_signature_food` VALUES (125, 28, '狗不理包子', NULL, '皮薄馅大，汁多味鲜，天津传统名点', 38.00, 0, '2026-04-29 18:04:34');
INSERT INTO `tb_store_signature_food` VALUES (126, 28, '蟹黄包', NULL, '蟹黄饱满，鲜香浓郁', 68.00, 1, '2026-04-29 18:04:34');
INSERT INTO `tb_store_signature_food` VALUES (127, 29, '西湖醋鱼', NULL, '色泽红亮，酸甜适口', 88.00, 0, '2026-04-29 18:04:34');
INSERT INTO `tb_store_signature_food` VALUES (128, 29, '龙井虾仁', NULL, '茶香清新，虾仁鲜嫩', 98.00, 1, '2026-04-29 18:04:34');
INSERT INTO `tb_store_signature_food` VALUES (129, 30, '西湖醋鱼', NULL, '活鱼现杀，酸甜适口', 128.00, 0, '2026-04-29 18:04:34');
INSERT INTO `tb_store_signature_food` VALUES (130, 30, '叫化鸡', NULL, '荷叶包裹，泥封烤制', 138.00, 1, '2026-04-29 18:04:34');
INSERT INTO `tb_store_signature_food` VALUES (131, 31, '松鼠鳜鱼', NULL, '外酥里嫩，酸甜适口', 168.00, 0, '2026-04-29 18:04:34');
INSERT INTO `tb_store_signature_food` VALUES (132, 31, '响油鳝糊', NULL, '油亮鲜香，胡椒味浓', 78.00, 1, '2026-04-29 18:04:34');
INSERT INTO `tb_store_signature_food` VALUES (133, 32, '广式月饼', NULL, '皮薄馅足，莲蓉细腻', 28.00, 0, '2026-04-29 18:04:34');
INSERT INTO `tb_store_signature_food` VALUES (134, 32, '叉烧包', NULL, '叉烧馅料饱满', 32.00, 1, '2026-04-29 18:04:34');
INSERT INTO `tb_store_signature_food` VALUES (135, 33, '鸡仔饼', NULL, '咸甜适中，口感酥脆', 32.00, 0, '2026-04-29 18:04:34');
INSERT INTO `tb_store_signature_food` VALUES (136, 33, '莲蓉包', NULL, '莲蓉细腻，甜而不腻', 28.00, 1, '2026-04-29 18:04:34');
INSERT INTO `tb_store_signature_food` VALUES (137, 34, '三鲜汤包', NULL, '皮薄馅嫩，汤汁鲜美', 48.00, 0, '2026-04-29 18:04:34');
INSERT INTO `tb_store_signature_food` VALUES (138, 34, '蟹黄汤包', NULL, '蟹黄浓郁，鲜香可口', 68.00, 1, '2026-04-29 18:04:34');
INSERT INTO `tb_store_signature_food` VALUES (139, 35, '三鲜豆皮', NULL, '外酥内软，馅料丰富', 28.00, 0, '2026-04-29 18:04:34');
INSERT INTO `tb_store_signature_food` VALUES (140, 35, '牛肉豆皮', NULL, '牛肉香浓，口感丰富', 32.00, 1, '2026-04-29 18:04:34');
INSERT INTO `tb_store_signature_food` VALUES (141, 36, '小炒泡馍', NULL, '馍粒筋道，酸辣鲜香', 36.00, 0, '2026-04-29 18:04:34');
INSERT INTO `tb_store_signature_food` VALUES (142, 36, '优质羊肉泡馍', NULL, '羊肉酥烂，汤鲜味浓', 48.00, 1, '2026-04-29 18:04:34');
INSERT INTO `tb_store_signature_food` VALUES (143, 37, '羊肉泡馍', NULL, '汤鲜味浓，馍烂肉香', 42.00, 0, '2026-04-29 18:04:34');
INSERT INTO `tb_store_signature_food` VALUES (144, 37, '牛肉泡馍', NULL, '牛肉酥烂，味道醇厚', 38.00, 1, '2026-04-29 18:04:34');

-- ----------------------------
-- Table structure for tb_user
-- ----------------------------
DROP TABLE IF EXISTS `tb_user`;
CREATE TABLE `tb_user`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `nickname` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `gender` int NULL DEFAULT 0 COMMENT '0:未知, 1:男, 2:女',
  `region` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `taste_tags` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `register_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `status` int NULL DEFAULT 1 COMMENT '1:正常, 0:禁用',
  `is_admin` int NULL DEFAULT 0 COMMENT '1:管理员, 0:普通用户',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `phone`(`phone` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9650 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tb_user
-- ----------------------------
INSERT INTO `tb_user` VALUES (1, '系统管理员', '123456', '13800138001', 1, '北京', NULL, NULL, '2026-04-29 23:13:57', 0, 0);
INSERT INTO `tb_user` VALUES (2, '普通用户', '123456', '13800138002', 2, '上海', NULL, NULL, '2026-04-29 23:13:57', 0, 0);
INSERT INTO `tb_user` VALUES (3, '用户3', '123456', '13800138003', 1, '成都', '川菜,湘菜', 'avatar3.jpg', '2026-03-26 18:19:19', 0, 0);
INSERT INTO `tb_user` VALUES (4, '用户4', '123456', '13800138004', 2, '西安', '西北菜,面食', 'avatar4.jpg', '2026-03-26 18:19:19', 0, 0);
INSERT INTO `tb_user` VALUES (5, '用户5', '123456', '13800138005', 1, '杭州', '浙菜,淮扬菜', 'avatar5.jpg', '2026-03-26 18:19:19', 0, 0);
INSERT INTO `tb_user` VALUES (6, '用户6', '123456', '13800138006', 2, '成都', '川菜,湘菜', 'avatar6.jpg', '2026-03-28 18:31:45', 0, 0);
INSERT INTO `tb_user` VALUES (7, '用户7', '123456', '13800138007', 1, '北京', '鲁菜,京菜', 'avatar7.jpg', '2026-03-28 18:30:00', 0, 0);
INSERT INTO `tb_user` VALUES (8, '用户8', '123456', '13800138008', 0, '重庆', '川菜,渝菜', 'avatar8.jpg', '2026-03-28 18:31:00', 0, 0);
INSERT INTO `tb_user` VALUES (9, '用户9', '123456', '13800138009', 1, '南京', '苏菜,徽菜', 'avatar9.jpg', '2026-03-28 18:32:00', 0, 0);
INSERT INTO `tb_user` VALUES (10, '用户10', '123456', '13800138010', 0, '武汉', '楚菜,鄂菜', 'avatar10.jpg', '2026-03-28 18:33:00', 0, 0);
INSERT INTO `tb_user` VALUES (96, '用户96', '123456', '11111111111', 1, '未知', '', 'avatar7.jpg', '2026-04-14 02:08:54', 0, 0);
INSERT INTO `tb_user` VALUES (430, '用户430', '123456', '111222333555', 1, '未知', '', 'avatar1.jpg', '2026-03-30 14:24:16', 0, 0);
INSERT INTO `tb_user` VALUES (2145, '用户2145', '123456', '17265811676', 1, '未知', '', '/uploads/194c2630-4db9-401c-b17a-fe7d7365df9f.jpg?t=1776220234599', '2026-03-30 14:10:05', 0, 0);
INSERT INTO `tb_user` VALUES (5865, '用户5865', '123456', '1108888', 1, '未知', '', 'avatar6.jpg', '2026-03-30 14:13:16', 0, 0);
INSERT INTO `tb_user` VALUES (8637, '用户8637', '123456', '13800138000', 1, '未知', '', 'avatar8.jpg', '2026-04-14 02:15:35', 0, 0);
INSERT INTO `tb_user` VALUES (9638, '用户9638', '123456', '545454545', 1, '未知', '', 'avatar9.jpg', '2026-03-30 15:07:54', 0, 0);

-- ----------------------------
-- Table structure for tb_user_collection
-- ----------------------------
DROP TABLE IF EXISTS `tb_user_collection`;
CREATE TABLE `tb_user_collection`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `collection_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'food/store',
  `object_id` int NOT NULL COMMENT '对应food.id或store.id',
  `collection_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_collection_user`(`user_id` ASC) USING BTREE,
  CONSTRAINT `fk_collection_user` FOREIGN KEY (`user_id`) REFERENCES `tb_user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `tb_user_collection_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `tb_user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 25 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tb_user_collection
-- ----------------------------

-- ----------------------------
-- Table structure for tb_user_rating
-- ----------------------------
DROP TABLE IF EXISTS `tb_user_rating`;
CREATE TABLE `tb_user_rating`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `food_id` bigint NOT NULL,
  `score` tinyint NOT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_rating_user`(`user_id` ASC) USING BTREE,
  INDEX `fk_rating_food`(`food_id` ASC) USING BTREE,
  CONSTRAINT `fk_rating_food` FOREIGN KEY (`food_id`) REFERENCES `tb_food` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_rating_user` FOREIGN KEY (`user_id`) REFERENCES `tb_user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `tb_user_rating_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `tb_user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `tb_user_rating_ibfk_2` FOREIGN KEY (`food_id`) REFERENCES `tb_food` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `tb_user_rating_chk_1` CHECK (`score` between 1 and 5)
) ENGINE = InnoDB AUTO_INCREMENT = 102 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tb_user_rating
-- ----------------------------
INSERT INTO `tb_user_rating` VALUES (34, 3, 5, 5, '皮薄汤多，咬一口爆汁，鲜到不行！', '2026-03-28 18:35:27');
INSERT INTO `tb_user_rating` VALUES (35, 4, 5, 5, '肉馅鲜美不腻，上海味道超正宗！', '2026-03-28 18:35:27');
INSERT INTO `tb_user_rating` VALUES (36, 5, 6, 5, '虾饺晶莹剔透，一口一个太满足！', '2026-03-28 18:35:27');
INSERT INTO `tb_user_rating` VALUES (39, 6, 6, 4, '清淡鲜美，非常适合慢慢品尝！', '2026-03-28 18:38:54');
INSERT INTO `tb_user_rating` VALUES (41, 3, 7, 5, '中原特色小吃，味道非常地道！', '2026-03-28 18:39:05');
INSERT INTO `tb_user_rating` VALUES (42, 4, 8, 4, '酸辣适口，汤鲜味美，很有地方特色！', '2026-03-28 18:39:05');
INSERT INTO `tb_user_rating` VALUES (43, 5, 8, 4, '历史感满满的菜品，风味独特！', '2026-03-28 18:39:05');
INSERT INTO `tb_user_rating` VALUES (44, 6, 9, 5, '面条筋道，羊肉汤香浓，暖到心里！', '2026-03-28 18:39:05');
INSERT INTO `tb_user_rating` VALUES (47, 3, 10, 5, '麻辣够味，牛油香气十足！', '2026-03-28 18:39:05');
INSERT INTO `tb_user_rating` VALUES (48, 4, 10, 5, '毛肚鸭肠必点，脆嫩爽口！', '2026-03-28 18:39:05');
INSERT INTO `tb_user_rating` VALUES (49, 5, 11, 5, '馍酥肉香，腊汁味道太绝了！', '2026-03-28 18:39:05');
INSERT INTO `tb_user_rating` VALUES (50, 6, 11, 5, '西安经典小吃，百吃不厌！', '2026-03-28 18:39:05');
INSERT INTO `tb_user_rating` VALUES (85, 7, 4, 5, '白切鸡皮脆肉嫩，蘸姜蒜汁吃原汁原味，太地道了！', '2026-03-28 19:00:00');
INSERT INTO `tb_user_rating` VALUES (86, 7, 5, 4, '毛肚涮红锅10秒刚好，脆弹有嚼劲，吸满汤汁超下饭', '2026-03-28 19:01:00');
INSERT INTO `tb_user_rating` VALUES (87, 7, 7, 5, '卤凤爪筋道入味，连骨头都香，追剧啃到停不下来', '2026-03-28 19:02:00');
INSERT INTO `tb_user_rating` VALUES (88, 7, 8, 3, '鸭肝细腻绵密，但油脂偏重，吃两口就腻了，适合浅尝', '2026-03-28 19:03:00');
INSERT INTO `tb_user_rating` VALUES (89, 8, 6, 5, '酸辣肚丝酸得提神、辣得过瘾，夏天吃超解腻，重口味狂喜', '2026-03-28 19:04:00');
INSERT INTO `tb_user_rating` VALUES (90, 8, 9, 4, '鸭酥酥到掉渣，咸香口配酒绝了，就是有点油，配米饭刚好', '2026-03-28 19:05:00');
INSERT INTO `tb_user_rating` VALUES (91, 8, 10, 5, '鸭卷紧实有料，鸭香浓郁，咬开还有汁水，口感很惊喜', '2026-03-28 19:06:00');
INSERT INTO `tb_user_rating` VALUES (92, 8, 11, 4, '鸭汤奶白醇厚，鲜到掉眉毛，喝完整个人都暖乎乎的，很养生', '2026-03-28 19:07:00');
INSERT INTO `tb_user_rating` VALUES (93, 9, 12, 5, '一鸭三吃太适合聚会了！皮脆、肉嫩、汤鲜，每种吃法都有亮点', '2026-03-28 19:08:00');
INSERT INTO `tb_user_rating` VALUES (94, 9, 4, 4, '白切鸡皮Q肉嫩，不蘸料都香，原汁原味就是最顶的', '2026-03-28 19:09:00');
INSERT INTO `tb_user_rating` VALUES (95, 9, 5, 5, '毛肚裹香油碟绝了！脆爽弹牙，一口下去幸福感拉满', '2026-03-28 19:10:00');
INSERT INTO `tb_user_rating` VALUES (96, 9, 6, 3, '酸辣肚丝够劲，酸得开胃、辣得冒汗，不能吃辣的慎点', '2026-03-28 19:11:00');
INSERT INTO `tb_user_rating` VALUES (97, 10, 7, 5, '凤爪卤得透透的，连筋都入味，啃完还想嗦手指，太上头了', '2026-03-28 19:12:00');
INSERT INTO `tb_user_rating` VALUES (98, 10, 8, 4, '鸭肝细腻不柴，卤香很浓，配面包吃应该会很搭，单吃略腻', '2026-03-28 19:13:00');
INSERT INTO `tb_user_rating` VALUES (99, 10, 9, 5, '鸭酥外酥里嫩，咸香不腻，一口一个，当零食超合适', '2026-03-28 19:14:00');
INSERT INTO `tb_user_rating` VALUES (100, 10, 10, 4, '鸭卷扎实有嚼劲，鸭香很正，当下酒菜或者配菜都不错', '2026-03-28 19:15:00');
INSERT INTO `tb_user_rating` VALUES (101, 2145, 4, 5, '4848484848484', '2026-03-31 15:29:43');

-- ----------------------------
-- Table structure for tb_user_role
-- ----------------------------
DROP TABLE IF EXISTS `tb_user_role`;
CREATE TABLE `tb_user_role`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '关联ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_role`(`user_id` ASC, `role_id` ASC) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_role_id`(`role_id` ASC) USING BTREE,
  CONSTRAINT `tb_user_role_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `tb_user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `tb_user_role_ibfk_2` FOREIGN KEY (`role_id`) REFERENCES `tb_role` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户角色关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tb_user_role
-- ----------------------------
INSERT INTO `tb_user_role` VALUES (1, 8637, 1, '2026-04-15 08:35:28');
INSERT INTO `tb_user_role` VALUES (3, 3, 3, '2026-04-15 08:35:28');
INSERT INTO `tb_user_role` VALUES (4, 4, 3, '2026-04-15 08:35:28');
INSERT INTO `tb_user_role` VALUES (5, 5, 3, '2026-04-15 08:35:28');
INSERT INTO `tb_user_role` VALUES (6, 6, 3, '2026-04-15 08:35:28');
INSERT INTO `tb_user_role` VALUES (7, 7, 3, '2026-04-15 08:35:28');
INSERT INTO `tb_user_role` VALUES (8, 8, 3, '2026-04-15 08:35:28');
INSERT INTO `tb_user_role` VALUES (9, 9, 3, '2026-04-15 08:35:28');
INSERT INTO `tb_user_role` VALUES (10, 10, 3, '2026-04-15 08:35:28');
INSERT INTO `tb_user_role` VALUES (11, 96, 3, '2026-04-15 08:35:28');
INSERT INTO `tb_user_role` VALUES (12, 430, 3, '2026-04-15 08:35:28');
INSERT INTO `tb_user_role` VALUES (13, 2145, 3, '2026-04-15 08:35:28');
INSERT INTO `tb_user_role` VALUES (14, 5865, 3, '2026-04-15 08:35:28');
INSERT INTO `tb_user_role` VALUES (15, 9638, 3, '2026-04-15 08:35:28');
INSERT INTO `tb_user_role` VALUES (16, 3, 4, '2026-04-29 23:13:57');
INSERT INTO `tb_user_role` VALUES (17, 5, 4, '2026-04-29 23:13:57');

SET FOREIGN_KEY_CHECKS = 1;

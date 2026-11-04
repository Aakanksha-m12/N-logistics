-- MariaDB dump 10.19  Distrib 10.4.32-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: logistics_db
-- ------------------------------------------------------
-- Server version	10.4.32-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `audit_log`
--

DROP TABLE IF EXISTS `audit_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `audit_log` (
  `log_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `action` varchar(100) NOT NULL,
  `entity_name` varchar(100) NOT NULL,
  `entity_id` varchar(100) DEFAULT NULL,
  `old_value` text DEFAULT NULL,
  `new_value` text DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`log_id`),
  KEY `fk_audit_user` (`user_id`),
  CONSTRAINT `fk_audit_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=229 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `companies`
--

DROP TABLE IF EXISTS `companies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `companies` (
  `company_id` int(11) NOT NULL AUTO_INCREMENT,
  `company_name` varchar(150) NOT NULL,
  `license_no` varchar(100) NOT NULL,
  `gst_no` varchar(50) NOT NULL,
  `tin_no` varchar(50) NOT NULL,
  `address` text NOT NULL,
  `contact_email` varchar(120) NOT NULL,
  `contact_phone` varchar(30) NOT NULL,
  `approval_status` enum('Pending','Active','Suspended') NOT NULL DEFAULT 'Pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`company_id`),
  UNIQUE KEY `license_no` (`license_no`),
  UNIQUE KEY `gst_no` (`gst_no`),
  UNIQUE KEY `tin_no` (`tin_no`),
  CONSTRAINT `chk_company_name` CHECK (char_length(trim(`company_name`)) > 0),
  CONSTRAINT `chk_company_license` CHECK (char_length(trim(`license_no`)) > 0),
  CONSTRAINT `chk_company_gst` CHECK (char_length(trim(`gst_no`)) > 0),
  CONSTRAINT `chk_company_tin` CHECK (char_length(trim(`tin_no`)) > 0),
  CONSTRAINT `chk_company_email` CHECK (`contact_email` regexp '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$')
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `containers`
--

DROP TABLE IF EXISTS `containers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `containers` (
  `container_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `container_number` varchar(50) NOT NULL,
  `type` enum('Dry','Reefer','Open Top','Flat Rack','Tank') NOT NULL,
  `size` enum('20ft','40ft','40ft HC','45ft') NOT NULL,
  `image_url` varchar(500) DEFAULT NULL,
  `tare_weight_kg` decimal(10,2) NOT NULL,
  `max_gross_weight_kg` decimal(10,2) NOT NULL,
  `goods_capacity_kg` decimal(10,2) NOT NULL,
  `goods_capacity_cbm` decimal(10,2) NOT NULL,
  `status` enum('Available','Allocated','In-Transit','Under Maintenance') NOT NULL DEFAULT 'Available',
  `current_port_id` bigint(20) DEFAULT NULL,
  `owner_company_id` bigint(20) NOT NULL,
  PRIMARY KEY (`container_id`),
  UNIQUE KEY `container_number` (`container_number`),
  CONSTRAINT `CONSTRAINT_1` CHECK (`tare_weight_kg` >= 0),
  CONSTRAINT `CONSTRAINT_2` CHECK (`max_gross_weight_kg` > 0),
  CONSTRAINT `CONSTRAINT_3` CHECK (`goods_capacity_kg` > 0),
  CONSTRAINT `CONSTRAINT_4` CHECK (`goods_capacity_cbm` > 0),
  CONSTRAINT `CONSTRAINT_5` CHECK (`max_gross_weight_kg` >= `tare_weight_kg`)
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER validate_container_capacity
BEFORE INSERT ON containers
FOR EACH ROW
BEGIN
    IF NEW.tare_weight_kg < 0
       OR NEW.max_gross_weight_kg <= 0
       OR NEW.goods_capacity_kg <= 0
       OR NEW.goods_capacity_cbm <= 0
       OR NEW.max_gross_weight_kg < NEW.tare_weight_kg
       OR NEW.goods_capacity_kg >
          (NEW.max_gross_weight_kg - NEW.tare_weight_kg)
    THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Invalid container capacity or weight relationship.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `customers`
--

DROP TABLE IF EXISTS `customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customers` (
  `customer_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `customer_name` varchar(150) NOT NULL,
  `address` text NOT NULL,
  `kyc_doc_path` varchar(255) NOT NULL,
  `credit_limit` decimal(12,2) NOT NULL DEFAULT 0.00,
  PRIMARY KEY (`customer_id`),
  UNIQUE KEY `user_id` (`user_id`),
  CONSTRAINT `fk_customers_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `demand_forecast`
--

DROP TABLE IF EXISTS `demand_forecast`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `demand_forecast` (
  `forecast_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `container_type` enum('Dry','Reefer','Open Top','Flat Rack','Tank') NOT NULL,
  `route_id` bigint(20) NOT NULL,
  `forecast_period` date NOT NULL,
  `forecasted_demand` int(11) NOT NULL,
  `forecasted_price` decimal(12,2) NOT NULL,
  `algorithm_version` varchar(50) NOT NULL,
  `generated_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`forecast_id`),
  UNIQUE KEY `uq_forecast_scope` (`container_type`,`route_id`,`forecast_period`),
  KEY `idx_forecast_lookup` (`container_type`,`route_id`,`forecast_period`),
  CONSTRAINT `chk_forecast_route` CHECK (`route_id` > 0),
  CONSTRAINT `chk_forecast_demand` CHECK (`forecasted_demand` >= 0),
  CONSTRAINT `chk_forecast_price` CHECK (`forecasted_price` >= 0)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pricing_audit`
--

DROP TABLE IF EXISTS `pricing_audit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pricing_audit` (
  `audit_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `pricing_id` bigint(20) NOT NULL,
  `old_price` decimal(12,2) NOT NULL,
  `new_price` decimal(12,2) NOT NULL,
  `changed_by` bigint(20) NOT NULL,
  `reason` varchar(255) NOT NULL,
  `changed_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`audit_id`),
  KEY `idx_audit_pricing` (`pricing_id`),
  KEY `idx_audit_changed_at` (`changed_at`),
  CONSTRAINT `chk_audit_old_price` CHECK (`old_price` >= 0),
  CONSTRAINT `chk_audit_new_price` CHECK (`new_price` >= 0),
  CONSTRAINT `chk_audit_user` CHECK (`changed_by` > 0)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pricing_rules`
--

DROP TABLE IF EXISTS `pricing_rules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pricing_rules` (
  `pricing_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `container_type` enum('Dry','Reefer','Open Top','Flat Rack','Tank') NOT NULL,
  `container_size` enum('20ft','40ft','40ft HC','45ft') NOT NULL,
  `route_id` bigint(20) NOT NULL DEFAULT 1,
  `base_price` decimal(12,2) NOT NULL,
  `seasonal_multiplier` decimal(10,4) NOT NULL,
  `demand_multiplier` decimal(10,4) NOT NULL,
  `final_price` decimal(12,2) NOT NULL,
  `valid_from` date NOT NULL,
  `valid_to` date NOT NULL,
  PRIMARY KEY (`pricing_id`),
  KEY `idx_pricing_route_type_size` (`route_id`,`container_type`,`container_size`),
  KEY `idx_pricing_validity` (`valid_from`,`valid_to`),
  CONSTRAINT `chk_pricing_route` CHECK (`route_id` > 0),
  CONSTRAINT `chk_pricing_base` CHECK (`base_price` >= 0),
  CONSTRAINT `chk_pricing_seasonal` CHECK (`seasonal_multiplier` > 0),
  CONSTRAINT `chk_pricing_demand` CHECK (`demand_multiplier` > 0),
  CONSTRAINT `chk_pricing_final` CHECK (`final_price` >= 0),
  CONSTRAINT `chk_pricing_dates` CHECK (`valid_to` >= `valid_from`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER validate_pricing_final_price
BEFORE INSERT ON pricing_rules
FOR EACH ROW
BEGIN
    IF NEW.base_price < 0
       OR NEW.seasonal_multiplier <= 0
       OR NEW.demand_multiplier <= 0
       OR NEW.final_price < 0
    THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid pricing values.';
    END IF;

    IF ROUND(
        NEW.base_price
        * NEW.seasonal_multiplier
        * NEW.demand_multiplier,
        2
    ) <> NEW.final_price
    THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Final price does not match the pricing formula.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `roles` (
  `role_id` int(11) NOT NULL AUTO_INCREMENT,
  `role_name` varchar(50) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`role_id`),
  UNIQUE KEY `role_name` (`role_name`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `phone` varchar(25) DEFAULT NULL,
  `role_id` int(11) NOT NULL,
  `company_id` int(11) DEFAULT NULL,
  `status` enum('Pending','Active','Inactive','Locked') NOT NULL DEFAULT 'Pending',
  `failed_login_count` int(11) NOT NULL DEFAULT 0,
  `failed_login_window_start` datetime DEFAULT NULL,
  `locked_until` datetime DEFAULT NULL,
  `last_login_at` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`),
  KEY `fk_users_role` (`role_id`),
  KEY `fk_users_company` (`company_id`),
  CONSTRAINT `fk_users_company` FOREIGN KEY (`company_id`) REFERENCES `companies` (`company_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_users_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`) ON UPDATE CASCADE,
  CONSTRAINT `chk_failed_login_count` CHECK (`failed_login_count` >= 0),
  CONSTRAINT `chk_user_email` CHECK (`email` regexp '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$')
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping routines for database 'logistics_db'
--
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_price_trend` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_price_trend`(
    IN p_container_type VARCHAR(20),
    IN p_route_id BIGINT,
    IN p_periods INT
)
BEGIN

    IF p_container_type IS NULL
       OR TRIM(p_container_type) = '' THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Container type is required.';

    END IF;


    IF p_container_type NOT IN
       ('Dry','Reefer','Open Top','Flat Rack','Tank') THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid container type.';

    END IF;


    IF p_route_id IS NULL
       OR p_route_id <= 0 THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Route ID must be positive.';

    END IF;


    IF p_periods IS NULL
       OR p_periods <= 0 THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Number of periods must be positive.';

    END IF;


    SELECT
        forecast_period,
        forecasted_demand,
        forecasted_price,
        algorithm_version,
        generated_at
    FROM demand_forecast
    WHERE container_type = p_container_type
      AND route_id = p_route_id
      AND forecast_period > CURDATE()
    ORDER BY forecast_period ASC
    LIMIT p_periods;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_approve_company` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_approve_company`(
    IN p_super_admin_id INT,
    IN p_company_id INT,
    IN p_ip_address VARCHAR(45)
)
BEGIN
    DECLARE v_role_name VARCHAR(50);
    DECLARE v_actor_status VARCHAR(20);
    DECLARE v_company_status VARCHAR(20);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    IF p_super_admin_id IS NULL
       OR p_super_admin_id <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid Super Admin ID';
    END IF;

    IF p_company_id IS NULL
       OR p_company_id <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid company ID';
    END IF;

    START TRANSACTION;

    SELECT
        r.role_name,
        u.status
    INTO
        v_role_name,
        v_actor_status
    FROM users u
    JOIN roles r
        ON u.role_id = r.role_id
    WHERE u.user_id = p_super_admin_id
    FOR UPDATE;

    IF v_role_name IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Approving user does not exist';
    END IF;

    IF v_role_name <> 'Super Admin'
       OR v_actor_status <> 'Active' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Only an Active Super Admin can approve companies';
    END IF;

    SELECT
        approval_status
    INTO
        v_company_status
    FROM companies
    WHERE company_id = p_company_id
    FOR UPDATE;

    IF v_company_status IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Company does not exist';
    END IF;

    IF v_company_status <> 'Pending' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Only Pending companies can be approved';
    END IF;

    UPDATE companies
    SET approval_status = 'Active'
    WHERE company_id = p_company_id;

    UPDATE users
    SET status = 'Active'
    WHERE company_id = p_company_id
      AND status = 'Pending';

    INSERT INTO audit_log (
        user_id,
        action,
        entity_name,
        entity_id,
        old_value,
        new_value,
        ip_address
    )
    VALUES (
        p_super_admin_id,
        'COMPANY_APPROVED',
        'companies',
        CAST(p_company_id AS CHAR),
        'Pending',
        'Active',
        p_ip_address
    );

    COMMIT;

    SELECT
        p_company_id AS company_id,
        'Active' AS approval_status,
        'Company approved successfully' AS message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_audit_log` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_audit_log`(
    IN p_super_admin_id INT
)
BEGIN
    DECLARE v_role_name VARCHAR(50);
    DECLARE v_status VARCHAR(20);

    IF p_super_admin_id IS NULL
       OR p_super_admin_id <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid Super Admin ID';
    END IF;

    SELECT
        r.role_name,
        u.status
    INTO
        v_role_name,
        v_status
    FROM users u
    JOIN roles r
        ON u.role_id = r.role_id
    WHERE u.user_id = p_super_admin_id;

    IF v_role_name IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'User does not exist';
    END IF;

    IF v_role_name <> 'Super Admin'
       OR v_status <> 'Active' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Only an Active Super Admin can view audit logs';
    END IF;

    SELECT
        a.log_id,
        a.user_id,
        a.action,
        a.entity_name,
        a.entity_id,
        a.old_value,
        a.new_value,
        a.ip_address,
        a.timestamp,
        u.username
    FROM audit_log a
    LEFT JOIN users u
        ON a.user_id = u.user_id
    ORDER BY
        a.timestamp DESC,
        a.log_id DESC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_companies_for_management` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_companies_for_management`(
    IN p_super_admin_id INT
)
BEGIN
    DECLARE v_role_name VARCHAR(50);
    DECLARE v_status VARCHAR(20);

    IF p_super_admin_id IS NULL
       OR p_super_admin_id <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid Super Admin ID';
    END IF;

    SELECT
        r.role_name,
        u.status
    INTO
        v_role_name,
        v_status
    FROM users u
    JOIN roles r
        ON u.role_id = r.role_id
    WHERE u.user_id = p_super_admin_id;

    IF v_role_name IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'User does not exist';
    END IF;

    IF v_role_name <> 'Super Admin'
       OR v_status <> 'Active' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Only an Active Super Admin can view companies';
    END IF;

    SELECT
        company_id,
        company_name,
        license_no,
        gst_no,
        tin_no,
        address,
        contact_email,
        contact_phone,
        approval_status,
        created_at
    FROM companies
    ORDER BY created_at ASC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_company_users` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_company_users`(
    IN p_actor_user_id INT
)
BEGIN
    DECLARE v_company_id INT;
    DECLARE v_role_name VARCHAR(50);
    DECLARE v_status VARCHAR(20);

    IF p_actor_user_id IS NULL
       OR p_actor_user_id <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid user ID';
    END IF;

    SELECT
        u.company_id,
        r.role_name,
        u.status
    INTO
        v_company_id,
        v_role_name,
        v_status
    FROM users u
    JOIN roles r
        ON u.role_id = r.role_id
    WHERE u.user_id = p_actor_user_id;

    IF v_role_name IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'User does not exist';
    END IF;

    IF v_status <> 'Active' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'User account is not active';
    END IF;

    IF v_role_name NOT IN (
        'Super Admin',
        'Company Admin'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Only Super Admin or Company Admin can view company users';
    END IF;

    IF v_role_name = 'Company Admin'
       AND v_company_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Company Admin is not assigned to a company';
    END IF;

    IF v_role_name = 'Super Admin' THEN

        SELECT
            u.user_id,
            u.username,
            u.email,
            u.phone,
            r.role_name,
            u.company_id,
            c.company_name,
            u.status,
            u.last_login_at,
            u.created_at
        FROM users u
        JOIN roles r
            ON u.role_id = r.role_id
        LEFT JOIN companies c
            ON u.company_id = c.company_id
        ORDER BY u.created_at;

    ELSE

        SELECT
            u.user_id,
            u.username,
            u.email,
            u.phone,
            r.role_name,
            u.company_id,
            c.company_name,
            u.status,
            u.last_login_at,
            u.created_at
        FROM users u
        JOIN roles r
            ON u.role_id = r.role_id
        LEFT JOIN companies c
            ON u.company_id = c.company_id
        WHERE u.company_id = v_company_id
        ORDER BY u.created_at;

    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_pending_companies` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_pending_companies`(
    IN p_super_admin_id INT
)
BEGIN
    DECLARE v_role_name VARCHAR(50);
    DECLARE v_status VARCHAR(20);

    IF p_super_admin_id IS NULL
       OR p_super_admin_id <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid Super Admin ID';
    END IF;

    SELECT
        r.role_name,
        u.status
    INTO
        v_role_name,
        v_status
    FROM users u
    JOIN roles r
        ON u.role_id = r.role_id
    WHERE u.user_id = p_super_admin_id;

    IF v_role_name IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'User does not exist';
    END IF;

    IF v_role_name <> 'Super Admin'
       OR v_status <> 'Active' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Only an Active Super Admin can view pending companies';
    END IF;

    SELECT
        company_id,
        company_name,
        license_no,
        gst_no,
        tin_no,
        address,
        contact_email,
        contact_phone,
        approval_status,
        created_at
    FROM companies
    WHERE approval_status = 'Pending'
    ORDER BY created_at ASC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_roles` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_roles`()
BEGIN
    SELECT
        role_id,
        role_name,
        description
    FROM roles
    ORDER BY role_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_user_profile` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_user_profile`(
    IN p_user_id INT
)
BEGIN
    IF p_user_id IS NULL
       OR p_user_id <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid user ID';
    END IF;

    SELECT
        u.user_id,
        u.username,
        u.email,
        u.phone,
        r.role_name,
        u.company_id,
        c.company_name,
        u.status,
        u.last_login_at,
        u.created_at,
        u.updated_at
    FROM users u
    JOIN roles r
        ON u.role_id = r.role_id
    LEFT JOIN companies c
        ON u.company_id = c.company_id
    WHERE u.user_id = p_user_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_login` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_login`(
    IN p_login VARCHAR(100)
)
BEGIN
    DECLARE v_user_id INT DEFAULT NULL;
    DECLARE v_status VARCHAR(20);
    DECLARE v_locked_until DATETIME;

    -- Validate input
    IF p_login IS NULL
       OR TRIM(p_login) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Username or email is required';
    END IF;

    -- Find user safely.
    -- Scalar subquery returns NULL when no matching user exists.
    SET v_user_id = (
        SELECT user_id
        FROM users
        WHERE username = TRIM(p_login)
           OR email = TRIM(p_login)
        LIMIT 1
    );

    -- Unknown account
    IF v_user_id IS NULL THEN

        SELECT
            'INVALID_CREDENTIALS' AS result,
            'Invalid username/email or password' AS message;

    ELSE

        -- Get current account state
        SELECT
            status,
            locked_until
        INTO
            v_status,
            v_locked_until
        FROM users
        WHERE user_id = v_user_id;

        -- Clear expired temporary lock
        IF v_status = 'Locked'
           AND v_locked_until IS NOT NULL
           AND v_locked_until <= NOW() THEN

            UPDATE users
            SET
                status = 'Active',
                failed_login_count = 0,
                failed_login_window_start = NULL,
                locked_until = NULL
            WHERE user_id = v_user_id;

        END IF;

        -- Return account details to Java.
        -- Java will perform BCrypt verification.
        SELECT
            u.user_id,
            u.username,
            u.email,
            u.password_hash,
            u.phone,
            u.role_id,
            r.role_name,
            u.company_id,
            c.company_name,
            c.approval_status AS company_status,
            u.status,
            u.failed_login_count,
            u.failed_login_window_start,
            u.locked_until,
            u.last_login_at
        FROM users u
        JOIN roles r
            ON u.role_id = r.role_id
        LEFT JOIN companies c
            ON u.company_id = c.company_id
        WHERE u.user_id = v_user_id;

    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_log_permission_denied` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_log_permission_denied`(
    IN p_user_id INT,
    IN p_entity_name VARCHAR(100),
    IN p_entity_id VARCHAR(100),
    IN p_requested_action VARCHAR(100),
    IN p_ip_address VARCHAR(45)
)
BEGIN
    IF p_user_id IS NULL
       OR p_user_id <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid user ID';
    END IF;

    IF p_entity_name IS NULL
       OR TRIM(p_entity_name) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Entity name is required';
    END IF;

    IF p_requested_action IS NULL
       OR TRIM(p_requested_action) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Requested action is required';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM users
        WHERE user_id = p_user_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'User does not exist';
    END IF;

    INSERT INTO audit_log (
        user_id,
        action,
        entity_name,
        entity_id,
        old_value,
        new_value,
        ip_address
    )
    VALUES (
        p_user_id,
        'PERMISSION_DENIED',
        TRIM(p_entity_name),
        COALESCE(NULLIF(TRIM(p_entity_id), ''), 'N/A'),
        NULL,
        TRIM(p_requested_action),
        p_ip_address
    );

    SELECT
        'Permission denial recorded' AS message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_record_login_failure` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_record_login_failure`(
    IN p_user_id INT,
    IN p_ip_address VARCHAR(45)
)
BEGIN
    DECLARE v_failed_count INT DEFAULT 0;
    DECLARE v_window_start DATETIME;
    DECLARE v_status VARCHAR(20);
    DECLARE v_locked_until DATETIME;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    IF p_user_id IS NULL
       OR p_user_id <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid user ID';
    END IF;

    START TRANSACTION;

    SELECT
        failed_login_count,
        failed_login_window_start,
        status,
        locked_until
    INTO
        v_failed_count,
        v_window_start,
        v_status,
        v_locked_until
    FROM users
    WHERE user_id = p_user_id
    FOR UPDATE;

    IF v_status IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'User does not exist';
    END IF;

    IF v_status IN ('Inactive','Pending') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'User account is not active';
    END IF;

    -- Existing active lock.
    IF v_status = 'Locked'
       AND v_locked_until IS NOT NULL
       AND v_locked_until > NOW() THEN

        ROLLBACK;

        SELECT
            'LOCKED' AS result,
            0 AS attempts_remaining,
            'Account temporarily locked' AS message;

    ELSE

        -- Start a fresh 15-minute window when required.
        IF v_window_start IS NULL
           OR v_window_start <
              DATE_SUB(NOW(), INTERVAL 15 MINUTE) THEN

            SET v_failed_count = 1;

            UPDATE users
            SET
                failed_login_count = 1,
                failed_login_window_start = NOW(),
                locked_until = NULL,
                status = 'Active'
            WHERE user_id = p_user_id;

        ELSE

            SET v_failed_count = v_failed_count + 1;

            IF v_failed_count >= 5 THEN

                UPDATE users
                SET
                    failed_login_count = 5,
                    locked_until = DATE_ADD(NOW(), INTERVAL 15 MINUTE),
                    status = 'Locked'
                WHERE user_id = p_user_id;

            ELSE

                UPDATE users
                SET
                    failed_login_count = v_failed_count
                WHERE user_id = p_user_id;

            END IF;
        END IF;

        INSERT INTO audit_log (
            user_id,
            action,
            entity_name,
            entity_id,
            old_value,
            new_value,
            ip_address
        )
        VALUES (
            p_user_id,
            'LOGIN_FAILED',
            'users',
            CAST(p_user_id AS CHAR),
            NULL,
            CONCAT('Failed login attempt #', v_failed_count),
            p_ip_address
        );

        COMMIT;

        IF v_failed_count >= 5 THEN

            SELECT
                'LOCKED' AS result,
                15 AS lockout_minutes,
                0 AS attempts_remaining,
                'Account temporarily locked' AS message;

        ELSE

            SELECT
                'FAILED' AS result,
                v_failed_count AS failed_attempts,
                5 - v_failed_count AS attempts_remaining,
                'Invalid credentials' AS message;

        END IF;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_record_login_success` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_record_login_success`(
    IN p_user_id INT,
    IN p_ip_address VARCHAR(45)
)
BEGIN
    DECLARE v_status VARCHAR(20);
    DECLARE v_locked_until DATETIME;
    DECLARE v_company_status VARCHAR(20);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    IF p_user_id IS NULL
       OR p_user_id <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid user ID';
    END IF;

    START TRANSACTION;

    SELECT
        u.status,
        u.locked_until,
        c.approval_status
    INTO
        v_status,
        v_locked_until,
        v_company_status
    FROM users u
    LEFT JOIN companies c
        ON u.company_id = c.company_id
    WHERE u.user_id = p_user_id
    FOR UPDATE;

    IF v_status IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'User does not exist';
    END IF;

    IF v_status <> 'Active' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'User account is not active';
    END IF;

    IF v_company_status IS NOT NULL
       AND v_company_status <> 'Active' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Company is not active';
    END IF;

    IF v_locked_until IS NOT NULL
       AND v_locked_until > NOW() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'User account is temporarily locked';
    END IF;

    UPDATE users
    SET
        failed_login_count = 0,
        failed_login_window_start = NULL,
        locked_until = NULL,
        last_login_at = NOW()
    WHERE user_id = p_user_id;

    INSERT INTO audit_log (
        user_id,
        action,
        entity_name,
        entity_id,
        old_value,
        new_value,
        ip_address
    )
    VALUES (
        p_user_id,
        'LOGIN_SUCCESS',
        'users',
        CAST(p_user_id AS CHAR),
        NULL,
        'Successful login',
        p_ip_address
    );

    COMMIT;

    SELECT
        'SUCCESS' AS result,
        'Login successful' AS message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_record_logout` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_record_logout`(
    IN p_user_id INT,
    IN p_ip_address VARCHAR(45)
)
BEGIN
    IF p_user_id IS NULL
       OR p_user_id <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid user ID';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM users
        WHERE user_id = p_user_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'User does not exist';
    END IF;

    INSERT INTO audit_log (
        user_id,
        action,
        entity_name,
        entity_id,
        old_value,
        new_value,
        ip_address
    )
    VALUES (
        p_user_id,
        'LOGOUT',
        'users',
        CAST(p_user_id AS CHAR),
        NULL,
        'User logged out',
        p_ip_address
    );

    SELECT
        'Logout audit recorded' AS message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_register_company` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_register_company`(
    IN p_company_name VARCHAR(150),
    IN p_license_no VARCHAR(100),
    IN p_gst_no VARCHAR(50),
    IN p_tin_no VARCHAR(50),
    IN p_address TEXT,
    IN p_contact_email VARCHAR(120),
    IN p_contact_phone VARCHAR(30),

    IN p_admin_username VARCHAR(50),
    IN p_admin_email VARCHAR(100),
    IN p_admin_password_hash VARCHAR(255),
    IN p_admin_phone VARCHAR(25)
)
BEGIN
    DECLARE v_company_id INT;
    DECLARE v_admin_user_id INT;
    DECLARE v_role_id INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    -- Required fields
    IF p_company_name IS NULL
       OR TRIM(p_company_name) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Company name is required';
    END IF;

    IF p_license_no IS NULL
       OR TRIM(p_license_no) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'License number is required';
    END IF;

    IF p_gst_no IS NULL
       OR TRIM(p_gst_no) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'GST number is required';
    END IF;

    IF p_tin_no IS NULL
       OR TRIM(p_tin_no) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'TIN number is required';
    END IF;

    IF p_address IS NULL
       OR TRIM(p_address) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Company address is required';
    END IF;

    IF p_contact_email IS NULL
       OR TRIM(p_contact_email) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Company email is required';
    END IF;

    IF p_contact_phone IS NULL
       OR TRIM(p_contact_phone) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Company phone is required';
    END IF;

    IF p_admin_username IS NULL
       OR TRIM(p_admin_username) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Admin username is required';
    END IF;

    IF p_admin_email IS NULL
       OR TRIM(p_admin_email) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Admin email is required';
    END IF;

    IF p_admin_password_hash IS NULL
       OR TRIM(p_admin_password_hash) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Password hash is required';
    END IF;

    IF p_admin_phone IS NULL
       OR TRIM(p_admin_phone) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Admin phone is required';
    END IF;

    -- Email validation
    IF TRIM(p_contact_email) NOT REGEXP
       '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid company email format';
    END IF;

    IF TRIM(p_admin_email) NOT REGEXP
       '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid admin email format';
    END IF;

    -- BCrypt structural validation.
    -- Actual hashing is done in Java.
    IF p_admin_password_hash NOT REGEXP
       '^\\$2[aby]?\\$[0-9]{2}\\$[A-Za-z0-9./]{53}$' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Password must be supplied as a BCrypt hash';
    END IF;

    -- Duplicate validation
    IF EXISTS (
        SELECT 1
        FROM companies
        WHERE license_no = TRIM(p_license_no)
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'License number already exists';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM companies
        WHERE gst_no = TRIM(p_gst_no)
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'GST number already exists';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM companies
        WHERE tin_no = TRIM(p_tin_no)
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'TIN number already exists';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM users
        WHERE username = TRIM(p_admin_username)
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Username already exists';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM users
        WHERE email = TRIM(p_admin_email)
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Admin email already exists';
    END IF;

    -- System-controlled Company Admin role
    SELECT role_id
    INTO v_role_id
    FROM roles
    WHERE role_name = 'Company Admin'
    LIMIT 1;

    IF v_role_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Company Admin role is not configured';
    END IF;

    START TRANSACTION;

    -- Company is ALWAYS Pending at registration.
    INSERT INTO companies (
        company_name,
        license_no,
        gst_no,
        tin_no,
        address,
        contact_email,
        contact_phone,
        approval_status
    )
    VALUES (
        TRIM(p_company_name),
        TRIM(p_license_no),
        TRIM(p_gst_no),
        TRIM(p_tin_no),
        TRIM(p_address),
        TRIM(p_contact_email),
        TRIM(p_contact_phone),
        'Pending'
    );

    SET v_company_id = LAST_INSERT_ID();

    -- Company Admin is also Pending until company approval.
    INSERT INTO users (
        username,
        email,
        password_hash,
        phone,
        role_id,
        company_id,
        status
    )
    VALUES (
        TRIM(p_admin_username),
        TRIM(p_admin_email),
        p_admin_password_hash,
        TRIM(p_admin_phone),
        v_role_id,
        v_company_id,
        'Pending'
    );

    SET v_admin_user_id = LAST_INSERT_ID();

    INSERT INTO audit_log (
        user_id,
        action,
        entity_name,
        entity_id,
        old_value,
        new_value
    )
    VALUES (
        v_admin_user_id,
        'COMPANY_REGISTERED',
        'companies',
        CAST(v_company_id AS CHAR),
        NULL,
        'Pending'
    );

    COMMIT;

    SELECT
        v_company_id AS company_id,
        'Pending' AS company_status,
        'Pending' AS admin_status,
        'Company registration submitted successfully' AS message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_register_customer` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_register_customer`(
    IN p_username VARCHAR(50),
    IN p_email VARCHAR(100),
    IN p_password_hash VARCHAR(255),
    IN p_phone VARCHAR(25),
    IN p_customer_name VARCHAR(150),
    IN p_address TEXT,
    IN p_kyc_doc_path VARCHAR(255)
)
BEGIN
    DECLARE v_user_id INT;
    DECLARE v_customer_id INT;
    DECLARE v_role_id INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    IF p_username IS NULL
       OR TRIM(p_username) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Username is required';
    END IF;

    IF p_email IS NULL
       OR TRIM(p_email) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Email is required';
    END IF;

    IF p_password_hash IS NULL
       OR TRIM(p_password_hash) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Password hash is required';
    END IF;

    IF p_phone IS NULL
       OR TRIM(p_phone) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Phone number is required';
    END IF;

    IF p_customer_name IS NULL
       OR TRIM(p_customer_name) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Customer name is required';
    END IF;

    IF p_address IS NULL
       OR TRIM(p_address) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Customer address is required';
    END IF;

    IF p_kyc_doc_path IS NULL
       OR TRIM(p_kyc_doc_path) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'KYC document is required';
    END IF;

    IF TRIM(p_email) NOT REGEXP
       '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid email format';
    END IF;

    IF p_password_hash NOT REGEXP
       '^\\$2[aby]?\\$[0-9]{2}\\$[A-Za-z0-9./]{53}$' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Password must be supplied as a BCrypt hash';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM users
        WHERE username = TRIM(p_username)
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Username already exists';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM users
        WHERE email = TRIM(p_email)
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Email already exists';
    END IF;

    SELECT role_id
    INTO v_role_id
    FROM roles
    WHERE role_name = 'Customer / Consumer'
    LIMIT 1;

    IF v_role_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Customer / Consumer role is not configured';
    END IF;

    START TRANSACTION;

    -- SRS flow used here: customer registration is automatically Active.
    INSERT INTO users (
        username,
        email,
        password_hash,
        phone,
        role_id,
        company_id,
        status
    )
    VALUES (
        TRIM(p_username),
        TRIM(p_email),
        p_password_hash,
        TRIM(p_phone),
        v_role_id,
        NULL,
        'Active'
    );

    SET v_user_id = LAST_INSERT_ID();

    INSERT INTO customers (
        user_id,
        customer_name,
        address,
        kyc_doc_path,
        credit_limit
    )
    VALUES (
        v_user_id,
        TRIM(p_customer_name),
        TRIM(p_address),
        TRIM(p_kyc_doc_path),
        0.00
    );

    SET v_customer_id = LAST_INSERT_ID();

    INSERT INTO audit_log (
        user_id,
        action,
        entity_name,
        entity_id,
        old_value,
        new_value
    )
    VALUES (
        v_user_id,
        'CUSTOMER_REGISTERED',
        'customers',
        CAST(v_customer_id AS CHAR),
        NULL,
        'Active'
    );

    COMMIT;

    SELECT
        v_user_id AS user_id,
        v_customer_id AS customer_id,
        'Active' AS status,
        'Customer registration successful' AS message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_reset_password` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_reset_password`(
    IN p_user_id INT,
    IN p_new_password_hash VARCHAR(255)
)
BEGIN
    DECLARE v_status VARCHAR(20);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    IF p_user_id IS NULL
       OR p_user_id <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid user ID';
    END IF;

    IF p_new_password_hash IS NULL
       OR TRIM(p_new_password_hash) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'New password hash is required';
    END IF;

    IF p_new_password_hash NOT REGEXP
       '^\\$2[aby]?\\$[0-9]{2}\\$[A-Za-z0-9./]{53}$' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'New password must be supplied as a BCrypt hash';
    END IF;

    START TRANSACTION;

    SELECT
        status
    INTO
        v_status
    FROM users
    WHERE user_id = p_user_id
    FOR UPDATE;

    IF v_status IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'User does not exist';
    END IF;

    UPDATE users
    SET
        password_hash = p_new_password_hash,
        failed_login_count = 0,
        failed_login_window_start = NULL,
        locked_until = NULL,
        status = CASE
                    WHEN status = 'Locked'
                    THEN 'Active'
                    ELSE status
                 END
    WHERE user_id = p_user_id;

    INSERT INTO audit_log (
        user_id,
        action,
        entity_name,
        entity_id,
        old_value,
        new_value
    )
    VALUES (
        p_user_id,
        'PASSWORD_RESET',
        'users',
        CAST(p_user_id AS CHAR),
        NULL,
        'Password reset successfully'
    );

    COMMIT;

    SELECT
        'Password reset successful' AS message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_suspend_company` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_suspend_company`(
    IN p_super_admin_id INT,
    IN p_company_id INT,
    IN p_ip_address VARCHAR(45)
)
BEGIN
    DECLARE v_role_name VARCHAR(50);
    DECLARE v_actor_status VARCHAR(20);
    DECLARE v_company_status VARCHAR(20);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    IF p_super_admin_id IS NULL
       OR p_super_admin_id <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid Super Admin ID';
    END IF;

    IF p_company_id IS NULL
       OR p_company_id <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid company ID';
    END IF;

    START TRANSACTION;

    SELECT
        r.role_name,
        u.status
    INTO
        v_role_name,
        v_actor_status
    FROM users u
    JOIN roles r
        ON u.role_id = r.role_id
    WHERE u.user_id = p_super_admin_id
    FOR UPDATE;

    IF v_role_name IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'User does not exist';
    END IF;

    IF v_role_name <> 'Super Admin'
       OR v_actor_status <> 'Active' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Only an Active Super Admin can suspend companies';
    END IF;

    SELECT
        approval_status
    INTO
        v_company_status
    FROM companies
    WHERE company_id = p_company_id
    FOR UPDATE;

    IF v_company_status IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Company does not exist';
    END IF;

    IF v_company_status <> 'Active' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Only Active companies can be suspended';
    END IF;

    UPDATE companies
    SET approval_status = 'Suspended'
    WHERE company_id = p_company_id;

    UPDATE users
    SET status = 'Inactive'
    WHERE company_id = p_company_id
      AND status = 'Active';

    INSERT INTO audit_log (
        user_id,
        action,
        entity_name,
        entity_id,
        old_value,
        new_value,
        ip_address
    )
    VALUES (
        p_super_admin_id,
        'COMPANY_SUSPENDED',
        'companies',
        CAST(p_company_id AS CHAR),
        'Active',
        'Suspended',
        p_ip_address
    );

    COMMIT;

    SELECT
        p_company_id AS company_id,
        'Suspended' AS approval_status,
        'Company suspended successfully' AS message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_update_user_profile` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_update_user_profile`(
    IN p_user_id INT,
    IN p_email VARCHAR(100),
    IN p_phone VARCHAR(25)
)
BEGIN
    IF p_user_id IS NULL
       OR p_user_id <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid user ID';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM users
        WHERE user_id = p_user_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'User does not exist';
    END IF;

    IF (p_email IS NULL OR TRIM(p_email) = '')
       AND
       (p_phone IS NULL OR TRIM(p_phone) = '') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'At least one field is required for update';
    END IF;

    IF p_email IS NOT NULL
       AND TRIM(p_email) <> '' THEN

        IF TRIM(p_email) NOT REGEXP
           '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$' THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Invalid email format';
        END IF;

        IF EXISTS (
            SELECT 1
            FROM users
            WHERE email = TRIM(p_email)
              AND user_id <> p_user_id
        ) THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Email already exists';
        END IF;
    END IF;

    IF p_phone IS NOT NULL
       AND TRIM(p_phone) <> '' THEN

        IF TRIM(p_phone) NOT REGEXP '^[0-9]{10,15}$' THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Invalid phone number';
        END IF;
    END IF;

    UPDATE users
    SET
        email = COALESCE(NULLIF(TRIM(p_email), ''), email),
        phone = COALESCE(NULLIF(TRIM(p_phone), ''), phone)
    WHERE user_id = p_user_id;

    SELECT
        'Profile updated successfully' AS message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-11-04 16:19:39

-- ---------------------------------------------------------------------------
-- Reference data: application roles
--
-- These rows are required, not sample data. The stored procedures look roles
-- up by name (for example sp_register_customer requires 'Customer / Consumer')
-- and the application maps them to internal role constants. The spelling has
-- to match exactly.
-- ---------------------------------------------------------------------------

INSERT IGNORE INTO `roles` (`role_name`, `description`) VALUES
  ('Super Admin',             'Platform administrator, approves companies'),
  ('Company Admin',           'Manages a single company and its users'),
  ('Company Staff Operations','Handles container operations and allocation'),
  ('Company Staff Finance',   'Handles pricing and finance review'),
  ('Customer / Consumer',     'Views their own containers and final prices');
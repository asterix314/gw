-- recreate the e-commerce tables and data
-- remove tables to ensure idempotency
-- this must be done in reverse order of dependencies
DROP TABLE IF EXISTS `payment`;

DROP TABLE IF EXISTS `review`;

DROP TABLE IF EXISTS `order_detail`;

DROP TABLE IF EXISTS `order`;

DROP TABLE IF EXISTS `product`;

DROP TABLE IF EXISTS `category`;

DROP TABLE IF EXISTS `user`;

-- create tables in order of dependencies
-- create the users table
CREATE TABLE
    IF NOT EXISTS `user` (
        `user_id` INT AUTO_INCREMENT PRIMARY KEY,
        `username` VARCHAR(50) NOT NULL,
        `email` VARCHAR(100) NOT NULL UNIQUE,
        `password_hash` VARCHAR(255) NOT NULL,
        `phone_number` VARCHAR(20),
        `address` TEXT,
        `registration_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
    );

-- create the categories table
CREATE TABLE
    IF NOT EXISTS `category` (
        `category_id` INT AUTO_INCREMENT PRIMARY KEY,
        `category_name` VARCHAR(50) NOT NULL UNIQUE
    );

-- create the products table
CREATE TABLE
    IF NOT EXISTS `product` (
        `product_id` INT AUTO_INCREMENT PRIMARY KEY,
        `product_name` VARCHAR(100) NOT NULL,
        `description` TEXT,
        `price` DECIMAL(10, 2) NOT NULL,
        `stock_quantity` INT NOT NULL DEFAULT 0,
        `category_id` INT,
        FOREIGN KEY (`category_id`) REFERENCES `category` (`category_id`)
    );

-- create the orders table
CREATE TABLE
    IF NOT EXISTS `order` (
        `order_id` INT AUTO_INCREMENT PRIMARY KEY,
        `user_id` INT NOT NULL,
        `order_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        `total_amount` DECIMAL(10, 2) NOT NULL,
        `status` ENUM ('Pending', 'Completed', 'Cancelled') NOT NULL DEFAULT 'Pending',
        FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`)
    );

-- create the order details table
CREATE TABLE
    IF NOT EXISTS `order_detail` (
        `order_detail_id` INT AUTO_INCREMENT PRIMARY KEY,
        `order_id` INT NOT NULL,
        `product_id` INT NOT NULL,
        `quantity` INT NOT NULL,
        `price` DECIMAL(10, 2) NOT NULL,
        FOREIGN KEY (`order_id`) REFERENCES `order` (`order_id`),
        FOREIGN KEY (`product_id`) REFERENCES `product` (`product_id`)
    );

-- create the reviews table
CREATE TABLE
    IF NOT EXISTS `review` (
        `review_id` INT AUTO_INCREMENT PRIMARY KEY,
        `user_id` INT NOT NULL,
        `product_id` INT NOT NULL,
        `rating` TINYINT NOT NULL CHECK (`rating` BETWEEN 1 AND 5),
        `comment` TEXT,
        `review_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`),
        FOREIGN KEY (`product_id`) REFERENCES `product` (`product_id`)
    );

-- create the payments table
CREATE TABLE
    IF NOT EXISTS `payment` (
        `payment_id` INT AUTO_INCREMENT PRIMARY KEY,
        `order_id` INT NOT NULL,
        `payment_method` ENUM ('Credit Card', 'PayPal', 'Bank Transfer', 'Other') NOT NULL,
        `payment_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        `amount` DECIMAL(10, 2) NOT NULL,
        FOREIGN KEY (`order_id`) REFERENCES `order` (`order_id`)
    );

-- insert data in order of dependencies
-- insert mock data to the users table
INSERT INTO
    `user` (
        `username`,
        `email`,
        `password_hash`,
        `phone_number`,
        `address`
    )
VALUES
    (
        'john_doe',
        'john.doe@email.com',
        'hash1',
        '123-456-7890',
        '123 Main St, City'
    ),
    (
        'jane_smith',
        'jane.smith@email.com',
        'hash2',
        '234-567-8901',
        '456 Oak Ave, Town'
    ),
    (
        'mike_wilson',
        'mike.wilson@email.com',
        'hash3',
        '345-678-9012',
        '789 Pine Rd, Village'
    ),
    (
        'sarah_brown',
        'sarah.brown@email.com',
        'hash4',
        '456-789-0123',
        '321 Elm St, Borough'
    ),
    (
        'david_lee',
        'david.lee@email.com',
        'hash5',
        '567-890-1234',
        '654 Maple Dr, District'
    ),
    (
        'emma_taylor',
        'emma.taylor@email.com',
        'hash6',
        '678-901-2345',
        '987 Cedar Ln, County'
    ),
    (
        'james_anderson',
        'james.anderson@email.com',
        'hash7',
        '789-012-3456',
        '147 Birch Rd, State'
    ),
    (
        'lisa_white',
        'lisa.white@email.com',
        'hash8',
        '890-123-4567',
        '258 Spruce Ave, Country'
    ),
    (
        'robert_martin',
        'robert.martin@email.com',
        'hash9',
        '901-234-5678',
        '369 Fir St, Province'
    ),
    (
        'amy_garcia',
        'amy.garcia@email.com',
        'hash10',
        '012-345-6789',
        '741 Pine Ave, Region'
    ),
    (
        'peter_wong',
        'peter.wong@email.com',
        'hash11',
        '123-234-3456',
        '852 Oak St, Territory'
    ),
    (
        'mary_johnson',
        'mary.johnson@email.com',
        'hash12',
        '234-345-4567',
        '963 Maple Ln, Area'
    );

-- insert mock data to the categories table
INSERT INTO
    `category` (`category_name`)
VALUES
    ('Electronics'),
    ('Clothing'),
    ('Books'),
    ('Home & Garden'),
    ('Sports'),
    ('Toys'),
    ('Beauty'),
    ('Automotive'),
    ('Food'),
    ('Health'),
    ('Jewelry'),
    ('Pet Supplies'),
    ('Assorted');



-- insert mock data to the orders table
INSERT INTO
    `order` (`user_id`, `total_amount`, `status`)
VALUES
    (1, 1089.98, 'Completed'),
    (2, 89.99, 'Completed'),
    (3, 120.00, 'Pending'),
    (4, 145.98, 'Completed'),
    (5, 699.99, 'Cancelled'),
    (6, 119.98, 'Completed'),
    (7, 89.99, 'Pending'),
    (8, 315.98, 'Completed'),
    (9, 349.98, 'Completed'),
    (1, 49.99, 'Pending'),
    (2, 1299.99, 'Completed'),
    (3, 91.98, 'Completed');


-- insert kaggle dataset sample to the product table
INSERT INTO `product` (`product_name`,`description`,`price`,`stock_quantity`,`category_id`) VALUES
	 ('iPhone 13','Latest Apple smartphone',1099.99,44,1),
	 ('Nike Running Shoes','Comfortable athletic shoes',89.99,100,5),
	 ('Harry Potter Set','Complete book collection',120.00,30,3),
	 ('Garden Tools Set','Essential gardening tools',45.99,75,4),
	 ('Samsung TV 55"','4K Smart TV',699.99,25,1),
	 ('Lego Star Wars','Building blocks set',59.99,60,6),
	 ('Face Cream','Anti-aging moisturizer',29.99,150,7),
	 ('Car Battery','12V automotive battery',89.99,40,8),
	 ('Organic Coffee','Premium coffee beans',15.99,200,9),
	 ('Vitamin C','Immune support supplement',19.99,300,10);
INSERT INTO `product` (`product_name`,`description`,`price`,`stock_quantity`,`category_id`) VALUES
	 ('Gold Necklace','18K gold chain',299.99,15,11),
	 ('Dog Food','Premium dry dog food',49.99,80,12),
	 ('Laptop','High-performance notebook',1299.99,35,1),
	 ('Dress Shirt','Cotton formal shirt',45.99,120,2),
	 ('Yoga Mat','Non-slip exercise mat',25.99,90,5),
	 ('SAMSUNG smartphone',NULL,1543.13,96,13),
	 ('APPLE smartphone',NULL,2095.01,132,13),
	 ('HUAWEI smartphone',NULL,951.81,122,13),
	 ('NOKIA smartphone',NULL,257.38,131,13),
	 ('ONEPLUS smartphone',NULL,1037.32,143,13);
INSERT INTO `product` (`product_name`,`description`,`price`,`stock_quantity`,`category_id`) VALUES
	 ('MEIZU smartphone',NULL,133.59,147,13),
	 ('XIAOMI smartphone',NULL,514.79,176,13),
	 ('OPPO smartphone',NULL,900.90,168,13),
	 ('INOI smartphone',NULL,38.42,134,13),
	 ('SONY smartphone',NULL,385.60,176,13),
	 ('HONOR smartphone',NULL,503.23,127,13),
	 ('ZTE smartphone',NULL,77.20,159,13),
	 ('VIVO smartphone',NULL,462.79,90,13),
	 ('TECNO smartphone',NULL,110.43,88,13),
	 (' smartphone',NULL,1029.34,136,13);
INSERT INTO `product` (`product_name`,`description`,`price`,`stock_quantity`,`category_id`) VALUES
	 ('HTC smartphone',NULL,102.94,138,13),
	 ('SAMSUNG tablet',NULL,823.39,130,13),
	 ('APPLE tablet',NULL,1181.24,134,13),
	 ('HUAWEI tablet',NULL,167.03,144,13),
	 ('PRESTIGIO tablet',NULL,51.20,120,13),
	 ('LENOVO tablet',NULL,76.94,119,13),
	 ('BQ tablet',NULL,102.71,164,13),
	 ('HP notebook',NULL,802.85,95,13),
	 ('LENOVO notebook',NULL,926.64,89,13),
	 ('ACER notebook',NULL,2187.70,117,13);
INSERT INTO `product` (`product_name`,`description`,`price`,`stock_quantity`,`category_id`) VALUES
	 ('APPLE notebook',NULL,1773.53,91,13),
	 ('XIAOMI notebook',NULL,720.48,163,13),
	 ('ASUS notebook',NULL,870.81,161,13),
	 ('DELL notebook',NULL,725.63,135,13),
	 (' notebook',NULL,254.81,96,13),
	 ('HP desktop',NULL,1307.59,163,13),
	 ('ACER desktop',NULL,617.75,119,13),
	 ('PULSER desktop',NULL,185.31,118,13),
	 ('EPSON printer',NULL,267.44,85,13),
	 ('CANON printer',NULL,167.01,131,13);
INSERT INTO `product` (`product_name`,`description`,`price`,`stock_quantity`,`category_id`) VALUES
	 ('HP printer',NULL,630.82,168,13),
	 ('ACER monitor',NULL,227.03,137,13),
	 ('SAMSUNG monitor',NULL,244.51,136,13),
	 ('QMAX monitor',NULL,61.23,136,13),
	 ('HP monitor',NULL,282.89,152,13),
	 ('SONY tv',NULL,694.46,100,13),
	 ('SAMSUNG tv',NULL,1093.72,97,13),
	 ('TOSHIBA tv',NULL,511.98,172,13),
	 ('HAIER tv',NULL,900.90,166,13),
	 ('LG tv',NULL,681.87,119,13);
INSERT INTO `product` (`product_name`,`description`,`price`,`stock_quantity`,`category_id`) VALUES
	 ('YASIN tv',NULL,374.50,174,13),
	 ('ARTEL tv',NULL,334.11,175,13),
	 ('HISENSE tv',NULL,421.87,148,13),
	 ('TCL tv',NULL,526.37,128,13),
	 ('SHIVAKI tv',NULL,239.72,137,13),
	 ('CHANGHONG tv',NULL,359.37,114,13),
	 ('KIVI tv',NULL,463.07,169,13),
	 ('HORIZONT tv',NULL,403.31,91,13),
	 ('PHILIPS tv',NULL,411.83,142,13),
	 ('ARG tv',NULL,282.86,170,13);
INSERT INTO `product` (`product_name`,`description`,`price`,`stock_quantity`,`category_id`) VALUES
	 ('GORENJE hood',NULL,108.06,117,13),
	 ('TURBOAIR hood',NULL,54.03,148,13),
	 ('BOSCH hood',NULL,102.94,172,13),
	 ('ASEL oven',NULL,61.75,84,13),
	 ('ARTEL oven',NULL,52.74,119,13),
	 ('ELENBERG oven',NULL,72.05,136,13),
	 ('BEKO oven',NULL,213.26,143,13),
	 ('BBK oven',NULL,84.92,117,13),
	 ('DAUSCHER oven',NULL,259.96,106,13),
	 ('ATLANT refrigerators',NULL,437.33,111,13);
INSERT INTO `product` (`product_name`,`description`,`price`,`stock_quantity`,`category_id`) VALUES
	 ('INDESIT refrigerators',NULL,357.54,91,13),
	 ('SAMSUNG refrigerators',NULL,823.44,82,13),
	 (' refrigerators',NULL,413.14,139,13),
	 ('HAIER refrigerators',NULL,694.97,120,13),
	 ('BEKO refrigerators',NULL,326.32,150,13),
	 ('BOSCH refrigerators',NULL,475.15,180,13),
	 ('WHIRLPOOL refrigerators',NULL,1096.53,102,13),
	 ('LG refrigerators',NULL,573.83,110,13),
	 ('DAUSCHER refrigerators',NULL,372.18,106,13),
	 ('MIDEA refrigerators',NULL,643.49,165,13);
INSERT INTO `product` (`product_name`,`description`,`price`,`stock_quantity`,`category_id`) VALUES
	 ('ARG refrigerators',NULL,180.16,161,13),
	 ('ALMACOM refrigerators',NULL,180.16,135,13),
	 ('SAMSUNG microwave',NULL,115.81,140,13),
	 ('LG microwave',NULL,94.96,92,13),
	 ('HORIZONT microwave',NULL,57.96,148,13),
	 ('ELENBERG microwave',NULL,62.94,177,13),
	 ('MIDEA microwave',NULL,48.88,160,13),
	 ('DAUSCHER microwave',NULL,60.75,85,13),
	 ('HANSA microwave',NULL,128.68,119,13),
	 ('BOSCH microwave',NULL,295.99,98,13);
INSERT INTO `product` (`product_name`,`description`,`price`,`stock_quantity`,`category_id`) VALUES
	 ('GALANZ microwave',NULL,69.47,106,13),
	 ('ARG microwave',NULL,56.60,143,13),
	 ('BRAUN blender',NULL,175.01,138,13),
	 ('PANASONIC blender',NULL,48.11,133,13),
	 ('VITEK blender',NULL,43.68,88,13),
	 ('SATURN blender',NULL,10.07,152,13),
	 ('POLARIS blender',NULL,36.01,108,13),
	 ('GORENJE blender',NULL,22.91,90,13),
	 ('MOULINEX blender',NULL,66.90,143,13),
	 ('MAXWELL blender',NULL,23.09,115,13);
INSERT INTO `product` (`product_name`,`description`,`price`,`stock_quantity`,`category_id`) VALUES
	 ('SCARLETT blender',NULL,20.57,170,13),
	 ('REDMOND blender',NULL,105.02,132,13),
	 ('BOSCH meat_grinder',NULL,185.08,169,13),
	 ('MOULINEX meat_grinder',NULL,136.40,162,13),
	 (' meat_grinder',NULL,56.60,87,13),
	 ('POLARIS meat_grinder',NULL,59.18,99,13),
	 ('VITEK meat_grinder',NULL,66.85,134,13),
	 ('REDMOND meat_grinder',NULL,77.20,139,13),
	 ('DAUSCHER meat_grinder',NULL,69.47,125,13),
	 ('INDESIT washer',NULL,283.12,129,13);
INSERT INTO `product` (`product_name`,`description`,`price`,`stock_quantity`,`category_id`) VALUES
	 ('MIDEA washer',NULL,131.25,111,13),
	 ('ARTEL washer',NULL,137.15,115,13),
	 ('ATLANT washer',NULL,222.65,103,13),
	 ('SAMSUNG washer',NULL,823.68,88,13),
	 ('BEKO washer',NULL,321.59,162,13),
	 ('HAIER washer',NULL,424.70,116,13),
	 ('SHIVAKI washer',NULL,94.04,145,13),
	 ('LG washer',NULL,444.80,165,13),
	 ('BOSCH washer',NULL,385.85,151,13),
	 (' washer',NULL,48.65,141,13);
INSERT INTO `product` (`product_name`,`description`,`price`,`stock_quantity`,`category_id`) VALUES
	 ('CANDY washer',NULL,256.83,108,13),
	 ('LG vacuum',NULL,188.43,84,13),
	 ('SAMSUNG vacuum',NULL,184.22,174,13),
	 ('THOMAS vacuum',NULL,402.48,168,13),
	 ('VITEK vacuum',NULL,112.69,146,13),
	 ('KARCHER vacuum',NULL,326.74,80,13),
	 ('TEFAL vacuum',NULL,128.68,174,13),
	 ('IROBOT vacuum',NULL,319.36,87,13),
	 ('XIAOMI vacuum',NULL,486.49,103,13),
	 ('POLARIS vacuum',NULL,56.11,162,13);
INSERT INTO `product` (`product_name`,`description`,`price`,`stock_quantity`,`category_id`) VALUES
	 ('ARNICA vacuum',NULL,225.95,135,13),
	 ('BOSCH vacuum',NULL,181.34,100,13),
	 ('HOOVER vacuum',NULL,92.09,171,13),
	 ('ELENBERG vacuum',NULL,41.16,178,13),
	 ('DAUSCHER vacuum',NULL,50.94,102,13),
	 ('BRAUN iron',NULL,437.57,148,13),
	 ('VITEK iron',NULL,38.35,115,13),
	 ('POLARIS iron',NULL,44.51,83,13),
	 ('MAXWELL iron',NULL,12.84,179,13),
	 ('SATURN iron',NULL,10.79,156,13);
INSERT INTO `product` (`product_name`,`description`,`price`,`stock_quantity`,`category_id`) VALUES
	 ('REDMOND iron',NULL,48.88,174,13),
	 ('PHILIPS iron',NULL,308.86,112,13),
	 ('TEFAL iron',NULL,154.42,93,13),
	 ('SCARLETT iron',NULL,26.74,94,13),
	 ('ELENBERG iron',NULL,20.57,95,13),
	 ('BOSCH iron',NULL,219.77,120,13),
	 ('UNIT iron',NULL,16.45,172,13),
	 ('ARISTON water_heater',NULL,238.17,106,13),
	 ('THERMEX water_heater',NULL,110.48,169,13),
	 ('ARTEL water_heater',NULL,86.00,136,13);
INSERT INTO `product` (`product_name`,`description`,`price`,`stock_quantity`,`category_id`) VALUES
	 ('OASIS water_heater',NULL,64.09,142,13),
	 ('TEPLOROSS water_heater',NULL,83.12,88,13),
	 ('KARCHER generator',NULL,129.99,119,13),
	 ('PHILIPS generator',NULL,123.53,108,13),
	 ('ELENBERG generator',NULL,33.21,109,13),
	 ('ROWENTA generator',NULL,239.13,81,13),
	 ('ELENBERG air_conditioner',NULL,231.09,175,13),
	 ('SAMSUNG air_conditioner',NULL,347.47,127,13),
	 ('KLIMA air_conditioner',NULL,411.77,86,13),
	 ('DELONGHI coffee_machine',NULL,514.79,144,13);
INSERT INTO `product` (`product_name`,`description`,`price`,`stock_quantity`,`category_id`) VALUES
	 ('SCARLETT coffee_machine',NULL,55.68,103,13),
	 ('KITFORT coffee_machine',NULL,186.62,156,13),
	 ('GEFEST hob',NULL,116.60,81,13),
	 ('BOSCH hob',NULL,257.38,160,13),
	 ('DARINA hob',NULL,90.56,143,13),
	 ('ELECTRONICSDELUXE hob',NULL,175.55,102,13),
	 ('BOSCH dishwasher',NULL,542.29,131,13),
	 ('ELECTROLUX dishwasher',NULL,409.02,147,13),
	 ('HANSA dishwasher',NULL,334.09,92,13),
	 ('BEKO dishwasher',NULL,347.47,147,13);
INSERT INTO `product` (`product_name`,`description`,`price`,`stock_quantity`,`category_id`) VALUES
	 ('SHO-ME videoregister',NULL,179.93,158,13),
	 ('NAVITEL videoregister',NULL,95.19,87,13),
	 ('AVEL videoregister',NULL,55.34,150,13),
	 ('NEOLINE videoregister',NULL,372.93,145,13),
	 ('BLACKVUE videoregister',NULL,233.72,85,13),
	 ('IBOX videoregister',NULL,60.23,172,13),
	 ('XIAOMI videoregister',NULL,71.82,105,13),
	 ('PLAYME videoregister',NULL,223.92,91,13),
	 (' videoregister',NULL,30.89,164,13),
	 ('SAMSUNG headphone',NULL,115.65,105,13);
INSERT INTO `product` (`product_name`,`description`,`price`,`stock_quantity`,`category_id`) VALUES
	 ('SONY headphone',NULL,38.59,172,13),
	 ('MICROLAB headphone',NULL,8.21,151,13),
	 ('KINGSTON headphone',NULL,48.65,132,13),
	 ('XIAOMI headphone',NULL,43.50,134,13),
	 ('APPLE headphone',NULL,208.50,94,13),
	 ('JBL headphone',NULL,46.31,134,13),
	 ('MARSHALL headphone',NULL,89.83,110,13),
	 ('STEELSERIES headphone',NULL,128.68,107,13),
	 ('ELARI headphone',NULL,66.90,131,13),
	 ('HYPERX headphone',NULL,115.56,83,13);
INSERT INTO `product` (`product_name`,`description`,`price`,`stock_quantity`,`category_id`) VALUES
	 ('HARPER headphone',NULL,48.91,134,13),
	 ('PANASONIC headphone',NULL,99.33,101,13),
	 ('PLANTRONICS headphone',NULL,25.66,171,13),
	 ('DEFENDER headphone',NULL,6.55,105,13),
	 ('HOCO headphone',NULL,4.12,173,13),
	 ('HUAWEI headphone',NULL,91.00,131,13),
	 ('OLMIO headphone',NULL,21.37,168,13),
	 ('GAMEMAX headphone',NULL,22.65,99,13),
	 ('BRAUN juicer',NULL,167.29,126,13),
	 ('JANOME sewing_machine',NULL,1265.91,148,13);
INSERT INTO `product` (`product_name`,`description`,`price`,`stock_quantity`,`category_id`) VALUES
	 ('CHAYKA sewing_machine',NULL,92.64,178,13),
	 ('WONLEX clocks',NULL,28.31,164,13),
	 ('APPLE clocks',NULL,631.93,105,13),
	 ('XIAOMI clocks',NULL,245.56,166,13),
	 ('ELARI clocks',NULL,125.75,97,13),
	 ('SAMSUNG clocks',NULL,411.83,145,13),
	 ('JET clocks',NULL,33.44,101,13),
	 (' clocks',NULL,386.08,179,13),
	 ('AIMOTO clocks',NULL,50.31,106,13),
	 ('HUAWEI clocks',NULL,192.77,159,13);
INSERT INTO `product` (`product_name`,`description`,`price`,`stock_quantity`,`category_id`) VALUES
	 ('CANYON clocks',NULL,77.19,121,13),
	 ('AMAZON ebooks',NULL,125.57,167,13),
	 ('POCKETBOOK ebooks',NULL,185.08,118,13),
	 ('ELECTROLUX air_heater',NULL,84.68,85,13),
	 ('MYSTERY player',NULL,45.05,176,13),
	 ('PIONEER player',NULL,141.57,167,13),
	 (' player',NULL,303.71,124,13),
	 ('SONY player',NULL,61.52,111,13),
	 ('KENWOOD player',NULL,131.27,165,13),
	 ('ALPINE player',NULL,120.98,102,13);
INSERT INTO `product` (`product_name`,`description`,`price`,`stock_quantity`,`category_id`) VALUES
	 ('AMS player',NULL,221.37,146,13),
	 ('HERTZ subwoofer',NULL,52.38,165,13),
	 ('MYSTERY subwoofer',NULL,133.85,123,13),
	 (' subwoofer',NULL,159.59,160,13),
	 ('ALPINE subwoofer',NULL,172.46,117,13),
	 ('ALPHARD subwoofer',NULL,74.65,94,13),
	 ('KENWOOD subwoofer',NULL,47.58,164,13),
	 ('EDGE subwoofer',NULL,167.31,152,13),
	 ('AUDISON subwoofer',NULL,165.41,87,13),
	 ('HP subwoofer',NULL,166.80,117,13);
INSERT INTO `product` (`product_name`,`description`,`price`,`stock_quantity`,`category_id`) VALUES
	 ('KICX subwoofer',NULL,138.74,146,13),
	 ('PIONEER subwoofer',NULL,58.95,112,13),
	 ('STARLINE alarm',NULL,310.43,107,13),
	 ('CENMAX alarm',NULL,69.86,94,13),
	 ('TOMAHAWK alarm',NULL,97.81,82,13),
	 ('PANDORA alarm',NULL,153.67,160,13),
	 ('IBOX radar',NULL,62.87,80,13),
	 ('SHO-ME radar',NULL,83.97,111,13),
	 ('NEOLINE radar',NULL,73.22,160,13),
	 ('ELENBERG air_heater',NULL,56.60,179,13);
INSERT INTO `product` (`product_name`,`description`,`price`,`stock_quantity`,`category_id`) VALUES
	 ('MIDEA air_heater',NULL,47.62,134,13),
	 ('TEFAL air_heater',NULL,90.06,124,13),
	 ('ALMACOM air_heater',NULL,43.76,157,13),
	 ('BALLU air_heater',NULL,50.19,127,13),
	 ('TIMBERK air_heater',NULL,64.33,87,13),
	 ('OASIS air_heater',NULL,52.77,148,13),
	 (' air_heater',NULL,62.42,88,13),
	 ('GALAXY air_heater',NULL,44.01,127,13),
	 ('WILLMARK air_heater',NULL,42.45,177,13),
	 ('HYUNDAI air_heater',NULL,53.80,162,13);
INSERT INTO `product` (`product_name`,`description`,`price`,`stock_quantity`,`category_id`) VALUES
	 ('REDMOND kettle',NULL,28.29,81,13),
	 ('ELENBERG kettle',NULL,46.31,164,13),
	 ('TEFAL kettle',NULL,38.59,89,13),
	 ('WILLMARK kettle',NULL,33.44,139,13),
	 ('SCARLETT kettle',NULL,23.14,86,13),
	 ('GALAXY kettle',NULL,22.14,171,13),
	 ('POLARIS kettle',NULL,97.79,139,13),
	 ('DAUSCHER kettle',NULL,38.59,165,13),
	 ('KENWOOD kettle',NULL,102.94,146,13),
	 ('AMD cpu',NULL,238.10,143,13);
INSERT INTO `product` (`product_name`,`description`,`price`,`stock_quantity`,`category_id`) VALUES
	 ('INTEL cpu',NULL,98.84,153,13),
	 ('ASROCK motherboard',NULL,87.24,173,13),
	 ('GEIL memory',NULL,35.47,86,13),
	 ('KINGSTON memory',NULL,38.35,106,13),
	 (' memory',NULL,16.80,105,13),
	 ('ASUS videocards',NULL,427.27,95,13),
	 ('PALIT videocards',NULL,170.65,95,13),
	 ('MSI videocards',NULL,48.65,134,13),
	 ('GIGABYTE videocards',NULL,1524.11,140,13),
	 ('GAINWARD videocards',NULL,331.08,111,13);
INSERT INTO `product` (`product_name`,`description`,`price`,`stock_quantity`,`category_id`) VALUES
	 ('BRAUN kettle',NULL,48.88,177,13),
	 (' hdd',NULL,119.92,167,13),
	 ('SEAGATE hdd',NULL,67.05,177,13),
	 ('KINGSTON hdd',NULL,66.67,165,13),
	 ('TRANSCEND hdd',NULL,45.05,177,13),
	 ('ZLATEK chair',NULL,51.46,98,13),
	 (' chair',NULL,58.92,82,13),
	 ('BERTONI chair',NULL,7.84,131,13),
	 ('WINGOFFLY carriage',NULL,113.75,125,13),
	 ('DSLAND carriage',NULL,643.52,132,13);
INSERT INTO `product` (`product_name`,`description`,`price`,`stock_quantity`,`category_id`) VALUES
	 ('ALIS carriage',NULL,128.67,157,13),
	 ('BABYTIME carriage',NULL,62.50,113,13),
	 ('BELECOO carriage',NULL,185.31,100,13),
	 ('RANT carriage',NULL,69.47,152,13),
	 ('COBALLE carriage',NULL,61.52,129,13),
	 ('CYBEX carriage',NULL,373.21,133,13),
	 ('BABYZEN carriage',NULL,435.02,98,13),
	 (' carriage',NULL,79.69,136,13),
	 (' bed',NULL,169.86,108,13),
	 ('INCANTO bed',NULL,102.94,177,13);
INSERT INTO `product` (`product_name`,`description`,`price`,`stock_quantity`,`category_id`) VALUES
	 ('BAMBINI bed',NULL,161.34,154,13),
	 ('SELBY chair',NULL,43.73,127,13),
	 ('CHICCO chair',NULL,283.12,91,13),
	 ('PEG-PEREGO chair',NULL,280.29,173,13),
	 ('ELENBERG fan',NULL,17.99,132,13),
	 ('ROWENTA hair_cutter',NULL,20.34,98,13),
	 ('BRAUN hair_cutter',NULL,46.31,147,13),
	 ('ELENBERG hair_cutter',NULL,23.14,176,13),
	 ('PHILIPS hair_cutter',NULL,64.33,160,13),
	 ('NOKIA telephone',NULL,73.54,176,13);
INSERT INTO `product` (`product_name`,`description`,`price`,`stock_quantity`,`category_id`) VALUES
	 ('TEXET telephone',NULL,25.96,131,13),
	 ('PRESTIGIO telephone',NULL,8.62,83,13),
	 ('BQ telephone',NULL,34.53,147,13),
	 (' toys',NULL,23.14,103,13),
	 ('ALILO toys',NULL,53.54,146,13),
	 ('BESTOY toys',NULL,46.33,108,13),
	 ('TRUST mouse',NULL,10.06,87,13),
	 ('KINGSTON mouse',NULL,68.10,103,13),
	 ('STEELSERIES mouse',NULL,35.78,136,13),
	 ('RITMIX keyboard',NULL,3.41,160,13);
INSERT INTO `product` (`product_name`,`description`,`price`,`stock_quantity`,`category_id`) VALUES
	 ('REDRAGON keyboard',NULL,21.34,89,13),
	 ('DEFENDER keyboard',NULL,23.14,89,13),
	 ('HP keyboard',NULL,70.36,127,13),
	 ('EPSON projector',NULL,411.59,140,13),
	 ('BARBIE dolls',NULL,22.63,160,13),
	 ('LLORENS dolls',NULL,38.35,91,13),
	 (' dolls',NULL,16.73,137,13),
	 ('MATTEL dolls',NULL,14.39,162,13),
	 ('DISNEY toys',NULL,14.29,148,13),
	 ('BOSCH mixer',NULL,51.42,111,13);
INSERT INTO `product` (`product_name`,`description`,`price`,`stock_quantity`,`category_id`) VALUES
	 ('POLARIS mixer',NULL,32.89,121,13),
	 ('GALAXY mixer',NULL,9.24,169,13),
	 ('VITEK mixer',NULL,59.13,138,13),
	 ('PHILIPS mixer',NULL,36.01,142,13),
	 ('ELENBERG mixer',NULL,25.71,90,13),
	 ('DAUSCHER mixer',NULL,12.84,149,13),
	 ('KITFORT mixer',NULL,118.10,84,13),
	 ('VITEK toster',NULL,33.44,154,13),
	 ('MOULINEX toster',NULL,36.01,82,13),
	 ('ELENBERG scales',NULL,14.13,129,13);
INSERT INTO `product` (`product_name`,`description`,`price`,`stock_quantity`,`category_id`) VALUES
	 ('UNIT scales',NULL,9.24,135,13),
	 ('OMRON scales',NULL,69.21,103,13),
	 ('SCARLETT scales',NULL,9.48,151,13),
	 ('POLARIS scales',NULL,16.71,173,13),
	 ('HUAWEI scales',NULL,30.86,119,13),
	 ('PANASONIC telephone',NULL,40.39,136,13),
	 ('MICROLAB desktop',NULL,55.34,168,13),
	 ('DEFENDER desktop',NULL,5.12,90,13),
	 ('SVEN desktop',NULL,76.71,176,13),
	 ('XIAOMI skates',NULL,368.74,160,13);
INSERT INTO `product` (`product_name`,`description`,`price`,`stock_quantity`,`category_id`) VALUES
	 ('MAOMAOKU skates',NULL,336.17,169,13),
	 ('LONGWAY skates',NULL,82.37,161,13),
	 ('NEXT skates',NULL,48.88,105,13),
	 (' skates',NULL,46.08,156,13),
	 ('PHOENIX bicycle',NULL,231.38,120,13),
	 ('AXIS bicycle',NULL,95.24,127,13),
	 ('TORRENT bicycle',NULL,115.81,147,13),
	 (' bicycle',NULL,115.83,151,13),
	 ('BOSCH drill',NULL,123.29,119,13),
	 ('STANLEY drill',NULL,123.59,171,13);
INSERT INTO `product` (`product_name`,`description`,`price`,`stock_quantity`,`category_id`) VALUES
	 ('ALTECO drill',NULL,39.36,114,13),
	 (' drill',NULL,128.70,165,13),
	 ('CROWN drill',NULL,41.31,132,13),
	 ('TOTAL drill',NULL,29.95,128,13),
	 ('DWT drill',NULL,68.20,140,13),
	 ('TEFAL grill',NULL,386.03,153,13),
	 ('VITEK grill',NULL,77.14,133,13),
	 ('SV bed',NULL,386.37,83,13),
	 ('BTS bed',NULL,102.94,177,13),
	 ('TRITON bath',NULL,87.26,127,13);
INSERT INTO `product` (`product_name`,`description`,`price`,`stock_quantity`,`category_id`) VALUES
	 ('SANITA toilet',NULL,89.84,86,13),
	 ('ROSA toilet',NULL,137.64,173,13),
	 (' faucet',NULL,73.34,102,13),
	 ('CALORIE faucet',NULL,33.09,112,13),
	 ('LEMARK faucet',NULL,148.68,108,13),
	 ('YAMAHA acoustic',NULL,658.96,154,13),
	 ('CORTLAND acoustic',NULL,115.81,142,13),
	 ('CORTLAND piano',NULL,84.94,136,13),
	 ('YAMAHA piano',NULL,375.56,120,13),
	 (' cabinet',NULL,411.85,123,13);
INSERT INTO `product` (`product_name`,`description`,`price`,`stock_quantity`,`category_id`) VALUES
	 ('BTS cabinet',NULL,102.71,161,13),
	 ('BRW cabinet',NULL,504.00,176,13),
	 ('MERRIES diapers',NULL,22.13,98,13),
	 ('PAMPERS diapers',NULL,22.00,100,13),
	 (' diapers',NULL,13.13,137,13),
	 ('HUGGIES diapers',NULL,13.53,100,13),
	 ('MANUOKI diapers',NULL,13.62,158,13),
	 ('IKEA chair',NULL,8.47,177,13),
	 ('DOMINI chair',NULL,30.89,161,13),
	 ('ZETA chair',NULL,6.41,147,13);
INSERT INTO `product` (`product_name`,`description`,`price`,`stock_quantity`,`category_id`) VALUES
	 (' table',NULL,198.18,132,13),
	 ('BRW table',NULL,122.53,174,13),
	 (' sofa',NULL,591.78,90,13),
	 ('RALS sofa',NULL,860.85,134,13),
	 ('KOMFORT-S sofa',NULL,352.11,134,13),
	 ('ZETA desktop',NULL,141.03,162,13),
	 ('AEROCOOL desktop',NULL,173.75,167,13),
	 ('DXRACER desktop',NULL,257.15,128,13),
	 ('XIAOMI bag',NULL,11.79,150,13),
	 ('LENOVO bag',NULL,69.76,167,13);
INSERT INTO `product` (`product_name`,`description`,`price`,`stock_quantity`,`category_id`) VALUES
	 ('APPLE bag',NULL,30.07,166,13),
	 ('TRUST tablet',NULL,77.19,133,13),
	 ('PARKMASTER parktronic',NULL,32.18,133,13),
	 (' saw',NULL,181.12,97,13),
	 ('CROWN saw',NULL,48.37,161,13),
	 ('HUTER saw',NULL,92.13,134,13),
	 ('EUROLUX saw',NULL,64.35,162,13),
	 ('CARVER saw',NULL,77.22,134,13),
	 ('NIKA ironing_board',NULL,17.50,148,13),
	 ('RONCATO bag',NULL,110.94,172,13);
INSERT INTO `product` (`product_name`,`description`,`price`,`stock_quantity`,`category_id`) VALUES
	 ('CASIO clocks',NULL,268.99,168,13),
	 ('ORIENT clocks',NULL,98.59,152,13),
	 ('FOSSIL clocks',NULL,282.12,127,13),
	 ('M-AUDIO microphone',NULL,127.39,159,13),
	 ('CHAMELEON compressor',NULL,75.42,115,13),
	 (' compressor',NULL,89.81,123,13),
	 (' pillow',NULL,15.44,173,13),
	 ('IKEA blanket',NULL,5.12,120,13),
	 ('ALVITEK blanket',NULL,32.18,165,13),
	 (' blanket',NULL,38.00,88,13);
INSERT INTO `product` (`product_name`,`description`,`price`,`stock_quantity`,`category_id`) VALUES
	 ('ECOCOOL cooler',NULL,92.64,149,13),
	 ('ALMACOM cooler',NULL,63.39,179,13),
	 (' lawn_mower',NULL,66.43,94,13),
	 (' pump',NULL,105.51,94,13),
	 ('KARYA wallet',NULL,46.33,112,13),
	 ('PETEK wallet',NULL,43.24,110,13),
	 (' belt',NULL,241.71,179,13),
	 ('REEBOK keds',NULL,118.15,147,13),
	 ('ASICS keds',NULL,51.48,138,13),
	 ('RESPECT shoes',NULL,136.17,103,13);
INSERT INTO `product` (`product_name`,`description`,`price`,`stock_quantity`,`category_id`) VALUES
	 ('BADEN shoes',NULL,97.04,125,13),
	 ('GREYDER shoes',NULL,136.43,118,13),
	 ('ADIDAS keds',NULL,65.59,97,13),
	 ('FASSEN shoes',NULL,51.22,165,13),
	 ('SUAVE shoes',NULL,105.54,173,13),
	 ('PUMA keds',NULL,100.13,138,13),
	 ('NEXPERO keds',NULL,51.22,115,13),
	 (' shoes',NULL,223.69,81,13),
	 ('ROOMAN shoes',NULL,89.84,129,13),
	 ('ETOR shoes',NULL,108.11,146,13);
INSERT INTO `product` (`product_name`,`description`,`price`,`stock_quantity`,`category_id`) VALUES
	 ('STROBBS keds',NULL,64.61,161,13),
	 ('ESCAN shoes',NULL,48.39,162,13),
	 (' keds',NULL,72.05,100,13),
	 ('GREYDER keds',NULL,100.39,149,13),
	 ('SALAMANDER shoes',NULL,66.67,145,13),
	 ('RIEKER shoes',NULL,123.30,93,13),
	 ('GEZATONE massager',NULL,30.12,163,13),
	 ('VITEK massager',NULL,45.20,166,13),
	 ('FABRETTI umbrella',NULL,25.48,177,13),
	 (' welding',NULL,329.71,151,13);
INSERT INTO `product` (`product_name`,`description`,`price`,`stock_quantity`,`category_id`) VALUES
	 ('MAGNETTA welding',NULL,102.71,154,13),
	 ('HYUNDAI welding',NULL,78.31,145,13),
	 ('DEEPCOOL cooler',NULL,23.48,163,13),
	 ('MILAVITSA underwear',NULL,33.35,107,13),
	 ('APOLLO kettle',NULL,7.70,150,13),
	 (' vacuum',NULL,36.22,168,13),
	 ('GENAU shoes',NULL,39.87,132,13),
	 ('NUNA swing',NULL,215.71,92,13),
	 ('SLY skirt',NULL,30.61,94,13),
	 ('TROYKA clocks',NULL,11.35,109,13);
INSERT INTO `product` (`product_name`,`description`,`price`,`stock_quantity`,`category_id`) VALUES
	 ('STANLEY bag',NULL,48.91,145,13),
	 ('DEWALT bag',NULL,41.84,125,13),
	 (' costume',NULL,64.35,136,13);


-- insert mock data to the order details table
INSERT INTO
    `order_detail` (`order_id`, `product_id`, `quantity`, `price`)
VALUES
    (1, 1, 1, 999.99),
    (1, 2, 1, 89.99),
    (2, 2, 1, 89.99),
    (3, 3, 1, 120.00),
    (4, 4, 2, 45.99),
    (5, 5, 1, 699.99),
    (6, 6, 2, 59.99),
    (7, 8, 1, 89.99),
    (8, 7, 2, 29.99),
    (8, 9, 16, 15.99),
    (9, 11, 1, 299.99),
    (9, 10, 2, 19.99),
    (10, 12, 1, 49.99),
    (11, 13, 1, 1299.99),
    (12, 14, 2, 45.99);

-- insert mock data to the reviews table
INSERT INTO
    `review` (`user_id`, `product_id`, `rating`, `comment`)
VALUES
    (1, 1, 5, 'Great phone, excellent camera!'),
    (2, 2, 4, 'Comfortable for running'),
    (3, 3, 5, 'Perfect collection for Potter fans'),
    (4, 4, 3, 'Good quality but expensive'),
    (5, 5, 4, 'Clear picture, easy setup'),
    (6, 6, 5, 'Kids love it'),
    (7, 7, 4, 'Nice texture, good results'),
    (8, 8, 5, 'Long lasting battery'),
    (9, 9, 4, 'Rich flavor'),
    (10, 10, 5, 'Helped boost immunity'),
    (11, 11, 4, 'Beautiful piece'),
    (12, 12, 5, 'My dog loves this food');

-- insert mock data to the payments table
INSERT INTO
    `payment` (`order_id`, `payment_method`, `amount`)
VALUES
    (1, 'Credit Card', 1089.98),
    (2, 'PayPal', 89.99),
    (3, 'Bank Transfer', 120.00),
    (4, 'Credit Card', 145.98),
    (5, 'PayPal', 699.99),
    (6, 'Credit Card', 119.98),
    (7, 'Bank Transfer', 89.99),
    (8, 'PayPal', 315.98),
    (9, 'Credit Card', 349.98),
    (10, 'Other', 49.99),
    (11, 'Credit Card', 1299.99),
    (12, 'PayPal', 91.98);

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
    ('Pet Supplies');

-- insert mock data to the products table
INSERT INTO
    `product` (
        `product_name`,
        `description`,
        `price`,
        `stock_quantity`,
        `category_id`
    )
VALUES
    (
        'iPhone 13',
        'Latest Apple smartphone',
        999.99,
        50,
        1
    ),
    (
        'Nike Running Shoes',
        'Comfortable athletic shoes',
        89.99,
        100,
        5
    ),
    (
        'Harry Potter Set',
        'Complete book collection',
        120.00,
        30,
        3
    ),
    (
        'Garden Tools Set',
        'Essential gardening tools',
        45.99,
        75,
        4
    ),
    ('Samsung TV 55"', '4K Smart TV', 699.99, 25, 1),
    (
        'Lego Star Wars',
        'Building blocks set',
        59.99,
        60,
        6
    ),
    (
        'Face Cream',
        'Anti-aging moisturizer',
        29.99,
        150,
        7
    ),
    (
        'Car Battery',
        '12V automotive battery',
        89.99,
        40,
        8
    ),
    (
        'Organic Coffee',
        'Premium coffee beans',
        15.99,
        200,
        9
    ),
    (
        'Vitamin C',
        'Immune support supplement',
        19.99,
        300,
        10
    ),
    ('Gold Necklace', '18K gold chain', 299.99, 15, 11),
    ('Dog Food', 'Premium dry dog food', 49.99, 80, 12),
    (
        'Laptop',
        'High-performance notebook',
        1299.99,
        35,
        1
    ),
    (
        'Dress Shirt',
        'Cotton formal shirt',
        45.99,
        120,
        2
    ),
    ('Yoga Mat', 'Non-slip exercise mat', 25.99, 90, 5);

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
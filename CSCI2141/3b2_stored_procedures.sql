DELIMITER $$
-- Procedure to place a new order and update product stock
DROP PROCEDURE IF EXISTS place_order $$
CREATE PROCEDURE place_order(
    IN p_user_id INT,
    IN p_product_id INT,
    IN p_quantity INT,
    OUT p_order_id INT
)
BEGIN
    DECLARE v_price DECIMAL(10,2);
    DECLARE v_total DECIMAL(10,2);
    DECLARE v_stock INT;

    START TRANSACTION;

    -- Get product price and check stock
    SELECT price, stock_quantity
    INTO v_price, v_stock
    FROM product
    WHERE product_id = p_product_id;

    IF v_stock >= p_quantity THEN
        -- Calculate total
        SET v_total = v_price * p_quantity;

        -- Create order
        INSERT INTO `order` (user_id, total_amount, status)
        VALUES (p_user_id, v_total, 'Pending');

        SET p_order_id = LAST_INSERT_ID();

        -- Create order detail
        INSERT INTO order_detail (order_id, product_id, quantity, price)
        VALUES (p_order_id, p_product_id, p_quantity, v_price);

        -- Update stock
        UPDATE product
        SET stock_quantity = stock_quantity - p_quantity
        WHERE product_id = p_product_id;

        COMMIT;
    ELSE
        ROLLBACK;
        SET p_order_id = -1;
    END IF;
END $$

-- Procedure to process payment and update order status
DROP PROCEDURE IF EXISTS process_payment $$
CREATE PROCEDURE process_payment(
    IN p_order_id INT,
    IN p_payment_method VARCHAR(20),
    OUT p_success BOOLEAN
)
BEGIN
    DECLARE v_total DECIMAL(10,2);

    START TRANSACTION;

    -- Get order total
    SELECT total_amount
    INTO v_total
    FROM `order`
    WHERE order_id = p_order_id;

    -- Insert payment
    INSERT INTO payment (order_id, payment_method, amount)
    VALUES (p_order_id, p_payment_method, v_total);

    -- Update order status
    UPDATE `order`
    SET status = 'Completed'
    WHERE order_id = p_order_id;

    SET p_success = TRUE;

    COMMIT;
END $$
DELIMITER ;

-- Call examples
SET @order_id = 0;
CALL place_order(1, 1, 2, @order_id);

SET @payment_success = FALSE;
CALL process_payment(@order_id, 'Credit Card', @payment_success);

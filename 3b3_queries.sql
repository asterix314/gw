-- Query 1: Find all products with low stock (less than 30) and calculate restock amount needed
SELECT
    product_name,
    stock_quantity,
    (100 - stock_quantity) as units_to_restock
FROM product
WHERE stock_quantity < 30;

-- Query 2: Get all orders with their payment details
SELECT
    o.order_id,
    o.total_amount,
    o.status,
    p.payment_method,
    p.payment_date
FROM `order` o
JOIN payment p ON o.order_id = p.order_id;

-- Query 3: Calculate average rating and total reviews per category
SELECT
    c.category_name,
    COUNT(r.review_id) as total_reviews,
    AVG(r.rating) as avg_rating
FROM category c
JOIN product p ON c.category_id = p.category_id
JOIN review r ON p.product_id = r.product_id
GROUP BY c.category_name;

-- Query 4: Find users who have spent more than average
SELECT u.username, total_spent
FROM (
    SELECT
        user_id,
        SUM(total_amount) as total_spent
    FROM `order`
    WHERE status = 'Completed'
    GROUP BY user_id
    HAVING total_spent > (
        SELECT AVG(total_amount)
        FROM `order`
        WHERE status = 'Completed'
    )
) spending
JOIN user u ON spending.user_id = u.user_id;

-- Query 5: Create and manipulate view
CREATE VIEW product_performance AS
SELECT
    p.product_id,
    p.product_name,
    COUNT(od.order_detail_id) as times_ordered,
    AVG(r.rating) as avg_rating,
    p.price * COUNT(od.order_detail_id) as total_revenue
FROM product p
LEFT JOIN order_detail od ON p.product_id = od.product_id
LEFT JOIN review r ON p.product_id = r.product_id
GROUP BY p.product_id, p.product_name, p.price;

SELECT * FROM product_performance WHERE times_ordered > 0;

UPDATE product SET price = price * 1.1 WHERE product_id = 1;

SELECT * FROM product_performance WHERE times_ordered > 0;

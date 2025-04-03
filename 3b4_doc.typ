#import "@preview/sleek-university-assignment:0.1.0": assignment

#show: assignment.with(
  title: "Part 3b: Describing the Database",
  authors: (
    (
      name: "John Doe",
      email: "john.doe@example.com",
      student-no: "123/XXX",
    ),
  ),
  course: "CSC2141: Designing and Building Your Database",
)

#show heading.where(level: 1): it => {
  block(below: 1em)[#it]
}

#set text(font: "Times New Roman", size: 12pt)
#set heading(numbering: "1.")
#set figure(numbering: none)

/*
Write documentation for your database. This should
consist of the following:

- A brief summary of the database: data source, license information, number of tables, number of attributes.

- Document at least three business rules that are enforced by your database. Explain how these rules are expressed as table constraints.

- Briefly explain the queries in the 3b3_queries.sql file. What is their purpose?

- Explain how to use the stored procedures in the 3b2_stored_precedures.sql file. The reader should be able to understand enough to know what information needs to be provided in the CALL(), what the procedure does, and what (if any) information is returned by OUT or INOUT variables.

*/

= Summary of the Database

The e-commerce database is designed to manage the operations of an online store. It includes tables for users, categories, products, orders, order details, reviews, and payments. The data source is hypothetical, created for educational purposes, and does not have specific licensing information. The database consists of 7 tables and a total of 38 attributes across these tables.

= Business Rules

+ Each user must have a unique email address. This is enforced by a UNIQUE constraint on the `email` attribute in the `user` table.

+ Products must belong to a category. This is enforced by a FOREIGN KEY constraint on the `category_id` attribute in the `product` table, referencing the `category` table.

+ Orders must have a status of either 'Pending', 'Completed', or 'Cancelled'. This is enforced by an ENUM constraint on the `status` attribute in the `order` table.

= Explanation of Queries

+ The first query identifies products with low stock (less than 30 units) and calculates how many units need to be restocked to reach a stock level of 100.

+ The second query retrieves all orders along with their corresponding payment details, including payment method and date.

+ The third query calculates the average rating and total number of reviews per product category.

+ The fourth query identifies users who have spent more than the average amount on completed orders.

+ The fifth query creates a view called `product_performance` that shows the performance of each product in terms of order frequency, average rating, and total revenue. It also demonstrates how to manipulate this view and update product prices.

= Stored Procedures

+ `place_order`: This procedure is used to place a new order and update the stock quantity of the product ordered. It requires the user ID, product ID, and quantity as input parameters. The procedure returns the order ID through an OUT parameter. If the stock is insufficient, the transaction is rolled back, and the order ID is set to -1.

+ `process_payment`: This procedure processes a payment for an order and updates the order status to 'Completed'. It requires the order ID and payment method as input parameters. The procedure returns a success status through an OUT parameter. If any error occurs, the transaction is rolled back, and the success status is set to FALSE.

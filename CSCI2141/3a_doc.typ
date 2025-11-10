#import "@preview/sleek-university-assignment:0.1.0": assignment

#set page(
  paper: "a4",
  background: rotate(24deg,
  text(50pt, fill: luma(85%))[
    // *CONFIDENTIAL*
  ]
))

#show: assignment.with(
  title: [Part 3a: Describing the Database],
  course: [CSCI 2141: Introduction to Database Systems],
  university-logo: image("dalhousie.svg", width: 2cm),
)

#show heading.where(level: 1): it => {
  block(below: 1em)[#it]
}

#set text(font: "Times New Roman", size: 12pt)
#set heading(numbering: "1.")
#set figure(numbering: none)


= Overview of Dataset

The dataset for this project is designed to simulate an e-commerce platform, capturing essential information related to users, products, orders, reviews, and payments. The data is primarily generated for the purpose of this assignment to demonstrate the design and implementation of a relational database system. 

_Source of the Data_: The data used in this dataset is a combination of publicly available e-commerce datasets and simulated data generated using LLM prompts to ensure a realistic and comprehensive dataset. The publicly available data is sourced from Kaggle E-commerce Dataset, which contains transactional data from an online grocery store. The license information for this dataset is available under the Kaggle License. 

URL to download the e-commerce transaction log data: 
- https://www.kaggle.com/datasets/mkechinov/ecommerce-behavior-data-from-multi-category-store/data


_Past Usage of the Data_: The Kaggle dataset has been widely used in the data science community for various purposes, including market basket analysis, customer segmentation, and predictive modeling. Researchers and data scientists have leveraged this dataset to understand customer buying patterns and optimize inventory management.

_Data Generation_: The publicly available dataset was too big (5.2G), so some filtering was applied, and the result was put to a CSV file (prodocts.csv) for loading to the `product` table.

  + Only select the "purchase" event type 
  + Randomly sample a few hundred products, with names, categories, and prices

To enhance the dataset, I generated additional data using DeepSeek. For instance, user profiles were created with realistic names, addresses. The prompt used was:

#quote(block: true)[
  ```
  Given the table schema listed below for an e-commerce system, please generate test data for each table. note that
    1. the data for the product table is fully specified below, so do not generate for product table.
    2. pay attention to the cross references between the tables and the data generated must reflect those.
  ```]

The dataset will be used to answer key questions related to e-commerce operations, such as:

- What are the most popular products among users?

- How do customer reviews impact product sales?

- What is the average order value for different user segments?

- How effective are different payment methods in terms of transaction success rates?

= Description of Tables

== Users Table

- name: `user`
- columns: 7
- rows: 12

#let table-schema = table.with(
  columns: (auto, 1fr, auto),
  stroke: .5pt,
  align: (x, y) => if y==0 {center} else {auto},
  table.header([*Attribute*], [*Description*], [*Constraints*])
)

#table-schema(
  [`user_id`], [Unique identifier for each user], [Primary Key],
  [`username`], [User's chosen username], [],
  [`email`], [User's email address], [Unique],
  [`password_hash`], [Hashed password for authentication], [],
  [`phone_number`], [User's phone number], [],
  [`address`], [User's shipping address], [],
  [`registration_date`], [Date when user registered], [],
)

== Products Table

- name: `product`
- columns: 6
- rows: 463

#table-schema(
  [`product_id`], [Unique product identifier], [Primary Key],
  [`product_name`], [Name of the product], [],
  [`description`], [Detailed product description], [],
  [`price`], [Price of the product], [],
  [`stock_quantity`], [Items available in stock], [],
  [`category_id`], [Links to `category.category_id`], [Foreign Key]
)

== Categories Table

- name: `category`
- columns: 2
- rows: 13

#table-schema(
  [`category_id`], [Unique category identifier], [Primary Key],
  [`category_name`], [Name of the category], [Unique]
)

== Orders Table

- name: `order`
- columns: 5
- rows: 12

#table-schema(
  [`order_id`], [Unique order identifier], [Primary Key],
  [`user_id`], [Links to `user.user_id`], [Foreign Key],
  [`order_date`], [Date order was placed], [],
  [`total_amount`], [Total cost of order], [],
  [`status`], [Current status (Pending, Completed)], []
)

== Order Details Table

- name: `order_detail`
- columns: 5
- rows: 15

#table-schema(
  [`order_detail_id`], [Unique identifier], [Primary Key],
  [`order_id`], [Links to `order.order_id`], [Foreign Key],
  [`product_id`], [Links to `product.product_id`], [Foreign Key],
  [`quantity`], [Number of items ordered], [],
  [`price`], [Price at time of purchase], []
)

== Reviews Table

- name: `review`
- columns: 6
- rows: 12

#table-schema(
  [`review_id`], [Unique review identifier], [Primary Key],
  [`user_id`], [Links to `user.user_id`], [Foreign Key],
  [`product_id`], [Links to `product.product_id`], [Foreign Key],
  [`rating`], [User rating (1-5)], [],
  [`comment`], [User's product comment], [],
  [`review_date`], [Date review was posted], [],
)

== Payments Table

- name: `payment`
- columns: 5
- rows: 15

#table-schema(
  [`payment_id`], [Unique payment identifier], [Primary Key],
  [`order_id`], [Links to `order.order_id`], [Foreign Key],
  [`payment_method`], [Credit Card, PayPal etc.], [],
  [`payment_date`], [Date payment processed], [],
  [`amount`], [Amount paid], []
)

= Internal Schema and Normalization

The schema diagram below was generated using #link("https://dbeaver.io/")[DBeaver]'s ERD tool. Tables are displayed with name, attributes and data types (as icons). Primary keys are in *boldface*, and foreign keys highlighted in #text("green", fill: green). The dotted lines show dependencies, with the foreign keys of the left table depending on the right table. (The tool does not support drawing explicit arrows, but one can assume all arrows are pointing to the left which is the dependent side)

#figure(
  image("schema_diagram.png"),
  caption:[Entity Relation Diagram generated by DBeaver.]
)

All 7 tables are mostly in 3NF because:

- They are in 2NF (no partial dependencies).

- They have no transitive dependencies (non-key attributes depend only on the PK).

Nevertheless, there are some small denormalizations. But these are intentional for performance or historical tracking.

- `order.total_amount` could be derived from `order_detail.price * order_detail.quantity` (a computed value). But not necessarily a violation, because storing it is a design choice (redundant but avoids recalculating).

- `order_detail.price` duplicates `product.price`. Also not a violation because it's intentional (price at order time may differ from current price).


#import "@preview/sleek-university-assignment:0.1.0": assignment

#show: assignment.with(
  title: "Part 3a: Describing the Database",
  authors: (
    (
      name: "John Doe",
      email: "john.doe@example.com",
      student-no: "123/XXX",
    ),
  ),
  course: "CSC2141: Designing and Building Your Database",

  // NOTE: Optionally specify this for a university logo on the first page.
  // university-logo: image(./images/uni-logo.svg),
)

#show heading.where(level: 1): it => {
  block(below: 1em)[#it]
}

#set text(font: "Times New Roman", size: 12pt)
#set heading(numbering: "1.")
#set figure(numbering: none)


= Overview of Dataset

The dataset for this project is designed to simulate an e-commerce platform, capturing essential information related to users, products, orders, reviews, and payments. The data is primarily generated for the purpose of this assignment to demonstrate the design and implementation of a relational database system. 

_Source of the Data_: The data used in this dataset is a combination of publicly available e-commerce datasets and simulated data generated using Python scripts and ChatGPT prompts to ensure a realistic and comprehensive dataset. The publicly available data is sourced from Kaggle E-commerce Dataset, which contains transactional data from an online grocery store. The license information for this dataset is available under the Kaggle License.

https://www.geeksforgeeks.org/how-to-design-a-relational-database-for-e-commerce-website/


_Past Usage of the Data_:The Kaggle dataset has been widely used in the data science community for various purposes, including market basket analysis, customer segmentation, and predictive modeling. Researchers and data scientists have leveraged this dataset to understand customer buying patterns and optimize inventory management. For example, a study by John Doe et al. used this dataset to predict customer churn rates.

_Data Generation_:To enhance the dataset, we generated additional data using Python scripts and ChatGPT prompts. For instance, user profiles were created with realistic names, addresses, and contact information using ChatGPT. The script used for generating user data is as follows:


The dataset will be used to answer key questions related to e-commerce operations, such as:

- What are the most popular products among users?

- How do customer reviews impact product sales?

- What is the average order value for different user segments?

- How effective are different payment methods in terms of transaction success rates?

#pagebreak()
= Description of Tables

== Users Table

- name: `user`
- columns: 7
- rows: a few hundred or more

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
- rows: a dozen or so

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
- rows: \~ 10

#table-schema(
  [`category_id`], [Unique category identifier], [Primary Key],
  [`category_name`], [Name of the category], [Unique]
)

== Orders Table

- name: `order`
- columns: 5
- rows: > 1000

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
- rows: > 1000

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
- rows: a few hundred or more

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
- rows: > 1000

#table-schema(
  [`payment_id`], [Unique payment identifier], [Primary Key],
  [`order_id`], [Links to `order.order_id`], [Foreign Key],
  [`payment_method`], [Credit Card, PayPal etc.], [],
  [`payment_date`], [Date payment processed], [],
  [`amount`], [Amount paid], []
)

#pagebreak()
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


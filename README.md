 Swiggy Sales Analysis – SQL Data Analytics Project
 Project Overview

This project analyzes sales data from Swiggy, one of India’s largest online food delivery platforms. The goal of this project is to transform raw food delivery transaction data into meaningful business insights using SQL.

The dataset originally existed as one large table containing multiple types of information such as location, restaurant details, dishes, food categories, pricing, ratings, and order dates. Working with a single large dataset can create performance issues and make analysis more complex.

To address this challenge, the data was cleaned, validated, and transformed using dimensional modelling. A Star Schema data model was designed to split the dataset into multiple dimension tables with a central fact table. This approach improves query performance, simplifies analysis, and creates a scalable structure similar to real-world data warehouse systems.

This project simulates the workflow of a real data analyst, including data cleaning, data modelling, and business insight generation using SQL.

Project Architecture

The project follows a typical data analytics pipeline:

Raw Dataset
→ Data Cleaning & Validation
→ Dimensional Modelling
→ Star Schema Creation
→ Analytical SQL Queries
→ Business Insights

This structured workflow ensures the dataset is reliable and optimized for reporting and analysis.

Dataset Description

The dataset contains food delivery order information including:

Order date

State and city

Delivery location

Restaurant name

Food category or cuisine

Dish name

Dish price (INR)

Customer rating

Number of ratings

This information allows us to analyze sales performance, customer preferences, and restaurant popularity.

Data Cleaning Process

Before analysis, several data quality checks were performed to ensure accuracy.

Null Value Check

Important columns such as state, city, order date, restaurant name, dish name, price, and ratings were checked for missing values.

Blank Value Detection

Some records contained empty strings instead of valid data. These values were identified and corrected.

Duplicate Record Detection

Duplicate records were detected by grouping important business columns.

Duplicate Removal

Duplicate rows were removed using the ROW_NUMBER() window function, keeping only one valid record for each duplicate entry.

These steps helped create a clean and reliable dataset for further analysis.

Dimensional Modelling

The original dataset contained a single large table, which can make analysis inefficient. To improve performance and organization, dimensional modelling was applied.

A Star Schema was designed where descriptive information was stored in dimension tables, and numerical metrics were stored in a central fact table.

Benefits of this approach include:

Improved query performance

Reduced data redundancy

Easier analytical queries

Better compatibility with BI tools

Data Model (Star Schema)

The final schema consists of five dimension tables and one fact table.

Dimension Tables

dim_date

Contains time-related attributes:

Date_Key

Year

Month

Quarter

Week

dim_location

Stores geographical information:

Location_Key

State

City

Location

dim_restaurant

Contains restaurant information:

Restaurant_Key

Restaurant_Name

dim_category

Stores cuisine or food category:

Category_Key

Category_Name

dim_dish

Contains dish details:

Dish_Key

Dish_Name

Fact Table

fact_swiggy_orders

This table contains the core transactional metrics and foreign keys referencing all dimension tables.

Columns include:

Date_Key

Location_Key

Restaurant_Key

Category_Key

Dish_Key

Price_INR

Rating

Rating_Count


Business Analysis & KPIs

Using SQL queries on the structured data model, several business insights were generated.

Core KPIs

Total Orders

Total Revenue

Average Dish Price

Average Customer Rating

Time-Based Insights

Monthly order trends

Quarterly performance analysis

Year-over-year growth

Day-of-week ordering patterns

Location-Based Insights

Top 10 cities by order volume

State-wise revenue contribution

Food Performance Analysis

Top restaurants by order count

Most popular cuisines

Most ordered dishes

Cuisine performance based on orders and ratings

Customer Spending Insights

Customer spending behavior was analyzed using price segments:

Under ₹100

₹100–₹199

₹200–₹299

₹300–₹499

₹500+

This helps understand purchasing patterns across different price ranges.

Tools & Technologies

SQL Server / MySQL

SQL (Joins, Aggregations, Window Functions)

Dimensional Modelling

Star Schema Design

Data Analysis Techniques

Skills Demonstrated

This project highlights several key data analytics skills:

Data Cleaning & Validation

SQL Query Development

Dimensional Data Modelling

Star Schema Design

Business KPI Analysis

Analytical Thinking


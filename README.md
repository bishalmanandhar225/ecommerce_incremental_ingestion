
Azure Data Engineering Pipeline - Online Retail Data Warehouse
Overview

This project demonstrates an end-to-end Azure Data Engineering pipeline that ingests raw retail transaction data, loads it into a staging table, and builds a dimensional data warehouse using Azure SQL and Azure Data Factory.

The pipeline automates the flow of data from raw files into a structured star schema consisting of dimension and fact tables.

Architecture

Pipeline flow:

CSV File (Raw Data)
        ↓
Azure Data Factory - Copy Activity
        ↓
Azure SQL - Staging Table
        ↓
Stored Procedures
        ↓
Dimensional Model
   ├── dim_customer
   ├── dim_product
   └── fact_sales

ADF orchestrates the full pipeline execution.

Technologies Used
Component	Technology
Cloud Platform	Microsoft Azure
Orchestration	Azure Data Factory
Data Warehouse	Azure SQL Database
Data Storage	CSV Dataset
Data Modeling	Star Schema
Version Control	Git + GitHub
Deployment	ARM Template
Data Model

The warehouse follows a star schema design.

Dimension Tables

dim_customer

Column	Description
customer_key	Surrogate key
CustomerID	Business key
Country	Customer country
updated_at	Load timestamp

dim_product

Column	Description
product_key	Surrogate key
StockCode	Product identifier
Description	Product description
UnitPrice	Price
updated_at	Load timestamp
Fact Table

fact_sales

Column	Description
sales_key	Surrogate key
customer_key	FK to dim_customer
product_key	FK to dim_product
InvoiceDate	Transaction date
Quantity	Units sold
UnitPrice	Price
updated_at	Load timestamp
Pipeline Workflow

The Azure Data Factory pipeline performs the following steps:

Copy Activity

Loads CSV retail dataset into staging table stg_online_retail.

Load Customer Dimension

Executes stored procedure sp_load_dim_customer.

Load Product Dimension

Executes stored procedure sp_load_dim_product.

Load Fact Table

Executes stored procedure sp_load_fact_sales.

Each stored procedure truncates the target table and reloads it from staging.

Project Structure
project-root
│
├── adf/
│
├── arm_template/
│   ├── factory/
│   ├── linkedTemplates/
│   ├── ARMTemplateForFactory.json
│   └── ARMTemplateParametersForFactory.json
│
├── sql/
│   ├── 01_staging.sql
│   ├── 02_dimensional_model.sql
│   └── 03_stored_procedures.sql
│
├── data/
│
├── screenshots/
│   └── pipeline_success.png
│
├── docs/
│
└── README.md
Pipeline Execution

Example successful pipeline run:

Data Validation

Row counts after pipeline execution:

Table	Row Count
stg_online_retail	1,067,371
dim_customer	5,942
dim_product	5,131
fact_sales	824,364

Fact rows exclude transactions where CustomerID is NULL.

Key Concepts Demonstrated

Azure Data Factory orchestration

Data warehouse dimensional modeling

Star schema design

Stored procedure based transformations

Staging layer pattern

End-to-end pipeline automation

Infrastructure export using ARM templates

Future Improvements

Possible enhancements:

Incremental loading using watermark columns

Replace TRUNCATE with MERGE logic

Partitioning strategy for fact tables

Monitoring and alerting framework

CI/CD deployment pipeline
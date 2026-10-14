# Ecommerce ETL Pipeline

This project builds an end-to-end ETL (Extract, Transform, Load) pipeline for an ecommerce sales dataset. It covers the full data lifecycle: raw data extraction, exploratory data analysis, cleaning and transformation, data analysis and insights, database design, loading into a relational database, and SQL reporting.

## Project Structure

```
ecommerce-etl-pipeline/
├── data/
│   ├── raw/
│   │   └── sales_dataset.csv          # Original raw dataset (10,000 rows)
│   └── processed/
│       ├── dim_customer.csv           # Customer dimension table
│       ├── dim_product.csv            # Product dimension table
│       ├── fact_orders.csv            # Order header fact table
│       └── fact_order_items.csv       # Order line item fact table
├── notebooks/
│   └── etl_pipeline.ipynb             # Main notebook (Phases 1-7)
├── sql/
│   ├── schema.sql                     # DDL for creating tables
│   ├── reports.sql                    # 8 SQL reporting queries
│   └── erd.txt                        # Entity Relationship Diagram (text)
├── .env                               # Database connection string (NOT committed)
├── .gitignore                         # Excludes .venv/ and .env
└──requirements.txt                   # Python dependencies
```

## Dataset

The raw dataset contains 10,000 ecommerce order records with 21 columns, including order details, customer information, product details, and financial metrics. After cleaning, the data is split into a star schema with two dimension tables (customer, product) and two fact tables (orders, order items).

## Pipeline Phases

### Phase 1: Data Acquisition & Extraction
The raw CSV file is loaded using Pandas. The original data is preserved in `data/raw/` before any transformations.

### Phase 2: Exploratory Data Analysis (EDA)
Basic exploration includes row/column counts, data types, summary statistics, unique value counts, missing value checks, duplicate detection, and outlier analysis using the IQR method.

### Phase 3: Data Cleaning & Transformation
- Date columns converted from string to datetime
- Redundant `order_status` column dropped (single value throughout)
- Time-based features extracted: `order_year`, `order_month`, `order_day_name`

### Phase 4: Data Analysis & Insights
Five analytical questions are answered:
1. Which category generates the highest total sales?
2. Which sub-category is top by total sales?
3. What is the monthly sales trend?
4. Who are the top 10 customers by total spend?
5. Which products drive most revenue?

Five data-driven insights are documented based on the analysis.

### Phase 5: Database Design
A star schema is designed with four tables:
- `dim_customer` - customer dimension
- `dim_product` - product dimension
- `fact_orders` - order header fact
- `fact_order_items` - order line item fact

Foreign key relationships are defined between the tables. The DDL is in `sql/schema.sql`, and a text-based ERD is in `sql/erd.txt`.

### Phase 6: Load - ETL Pipeline
The transformed data is loaded into a PostgreSQL database (Supabase). The loading process:
1. Reads the database connection string from the `.env` file
2. Drops existing tables in reverse dependency order
3. Creates tables from `sql/schema.sql`
4. Loads the processed CSVs in FK-safe order
5. Verifies row counts

### Phase 7: SQL Analysis & Reporting
Eight SQL queries are provided in `sql/reports.sql` covering:
- Total sales by product category
- Monthly revenue
- Top 10 customers by revenue
- Top-performing products
- Sales by region
- Average order value
- Number of orders by month
- Products with sales above average

## Setup Instructions

### 1. Install Dependencies
```bash
pip install -r requirements.txt
```

### 2. Configure Database Connection
Create or edit the `.env` file in the project root with your Supabase connection string:

```
SUPABASE_DB_URL=postgresql+psycopg2://postgres.<ref>:<password>@aws-0-<region>.pooler.supabase.com:5432/postgres
```

Replace `<ref>`, `<password>`, and `<region>` with your actual Supabase credentials. See the Supabase documentation for how to find your connection string.

### 3. Create Tables in Supabase
Open the Supabase SQL Editor, paste the contents of `sql/schema.sql`, and run it. This creates the four tables with their foreign key constraints.

### 4. Load Data
Run the Phase 6 cells in the notebook, or execute the standalone script:

```bash
python load_to_db.py
```

This will drop old tables, create new ones, and load the processed CSVs.

### 5. Run SQL Reports
Open `sql/reports.sql` in the Supabase SQL Editor and run the queries to generate reports.

## Key Insights

1. The Electronics category generates the highest total sales among all product categories
2. A small number of sub-categories drive a disproportionate share of revenue
3. Monthly sales show a clear pattern with peaks and troughs
4. The top 10 customers contribute significantly to total revenue
5. The top 10 products generate outsized revenue relative to the broader product catalog

## Notes

- The `.env` file is excluded from version control. Never commit database credentials.
- The virtual environment (`.venv/`) is also excluded.
- All paths in the notebook are relative to the project root directory.
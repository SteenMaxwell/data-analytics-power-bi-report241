# Data Analytics Power BI Report

## table of Contents
1. [Introduction](#Introduction)
2. [Virtual Machine](#Created-a-Virtual-Machine)
3. [Importing data into Power BI Desktop](#Importing-data-into-Power-BI-Desktop)
4. [Transformations on the Data](#Transformations-on-the-Data)
5. [Creating a Date Table](#Creating-a-Date-Table)
6. [Building a Star Schema Model Build](#Building-a-Star-Schema-Model-Build)
7. [Creating Key Measures from the Data](#Creating-Key-Measures-from-the-Data)
8. [Date and Geographical Hierarchies](#Date-and-Geographical-Hierarchies)
9. [Building the Customer Detail Page](Building-the-Customer-Detail-Page)


## Introduction
This README will follow in a chronological order explaining the steps taken to achieve a Power BI comprehensive quarterly report for a medium sized international retailer. This will give the company insights into their data to elevate their business intelligence and various decision-making strategies.


## Created a Virtual Machine
For this project I needed Windows to run Power BI Desktop. I created an Azure Virtual Machine (VM) so this was possible. 

## Importing data into Power BI Desktop
For this project, data was imported into Power BI from various sources using the following methods:
1) Azure SQL Database
   - Connected directly to an Azure SQL Database using the native connector in Power BI.
   - Steps:
     - Selected **Get Data** > **Azure SQL Database**.
     - Entered the server name and database credentials.
     - Imported the required tables.

2) CSV file
   - Imported a locally stored CSV file using the file connector.
   - Steps:
     - Selected **Get Data** > **Text/CSV**.
     - Specified delimiter (comma) and verified column names and data types in the preview.

3) Azure Blob Storage
   - Connected to Azure Blob Storage for cloud-hosted unstructured data.
   - Steps:
     - Selected Get **Data** > **Azure** > **Azure Blob Storage**.
     - Entered the blob container URL and credentials.
     - Imported file.
   
4) ZIP file (folder data connector)
   - Extracted and imported data from a ZIP file by using the folder data connector.
   - Steps:
     - Extracted files locally and imported using **Get Data** > **Folder**.
     - Combined files within the folder using Power Query transformations.


## Transformations on the Data
After importing the data, the following transformations were performed to prepare it for analysis:

1) Removed and Split Columns
   - Removed Columns to ensure data privacy and to remove useless columns.
   - Split Date+Time columns into separate columns.

2) Data Cleaning
   - Removed rows with missing or null values.
   - Renamed columns for clarity and consistency.
   - Removed Duplicates to prevent duplicates in the data.
   - Replaced misspelt values so all the values are consistent and correctly spelled.
  
3) Created new Columns
   - Created a new column to combine two columns values.


## Creating a Date Table
I wanted to utilise Power BI's time intelligence functions throughout my report, and to acheive this I needed a Date Table. 
   - Created a a date table (using CALENDER function) running from the start of the year containing the earliest date in the `Orders['Order Date']` column to the end of the year containing the latest date in the `Orders['Shipping Date']` column.
   - This ensures all dates are accounted for in the newly created `Date Table`.
   - DAX formulas were then used to create various columns in the `Date Table`. 
   - For Example:
      - ```DAX
        Start of Year = STARTOFYEAR('Date Table'[Date])
        ```
      - ```DAX
        Start of Week = 'Date Table'[Date] - WEEKDAY('Date Table'[Date],2) + 1
        ```
        

## Building a Star Schema Model Build
Relationships were built between the various tables. As I was going for a Star Schema Model Build, the four dimensional tables were directly connected to the main fact table `Orders`.
   -  all relationships are one-to-many, with a single filter direction flowing from the dimension table side to the fact table side.

<img width="1434" alt="Table-relationships" src="https://github.com/user-attachments/assets/751acfa6-bde4-4e29-9fdf-75feae9db9df">


## Creating Key Measures from the Data
   - I first created a `Measures Table` to manage the measures I created and keep them organised.
   - I created key measures which I will use for my report. I used DAX formulas to create these:
        - ```DAX
          Total Revenue = SUMX(Orders, Orders[Product Quantity] * RELATED(Products[Sale Price]))
          ```
        - ```DAX
          Total Profit = SUMX(Orders, (RELATED('Products'[Sale Price]) - RELATED('Products'[Cost Price])) * Orders[Product Quantity])
          ```
        - ```DAX
          Revenue YTD = TOTALYTD([Total Revenue], 'Date Table'[Date])
          ```
        - ```DAX
          Profit YTD = CALCULATE([Total Profit], DATESYTD('Date Table'[Date]))
          ```
   - For the `Profit YTD` and `Revenue YTD` there are two possible ways to calculate these measures, they will produce the same results and so I have shown both formulas. Using `TOTALYTD` is a straightforward, standard Year-To-Date calculation which offers simplicity and readability. Using `CALCULATE` with `DATESYTD` provides the felxibility to combine additional filters and to modify for custom date ranges.

## Date and Geographical Hieracrchies
These hierarchies allow you to drill down into the data and perform granular analysis within my report.
- The Date Hierarchy is to facilitate drill-down in the line charts. This hierarchy contains (in the following order):
  - `Start of Year`
  - `Start of Quarter`
  - `Start of Month`
  - `Start of Week`
  - `Date`

- The Geography Hierarchy is to filter the data by region, country and province/state. This hierarchy contains (in the following order):
  - `World Region`
  - `Country`
  - `Country Region`

## Building the Customer Detail Page
This report page focuses on customer-level analysis.

### Creating Card Visuals
Two Card visuals were used to present the number of `Unique customers` and `Revenue per Customer`.

### Creating donut and line charts


### Top customers Table and Cards


### Date Slicer











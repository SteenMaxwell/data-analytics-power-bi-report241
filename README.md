# Data Analytics Power BI Report

## table of Contents
1. [Introduction](#Introduction)
2. [Setting up and Transforming the data](#Setting-up-and-Transforming-the-data)
   - [Virtual Machine](#Created-a-Virtual-Machine)
   - [Importing data into Power BI Desktop](#Importing-data-into-Power-BI-Desktop)
   - [Transformations on the Data](#Transformations-on-the-Data)
   - [Creating a Date Table](#Creating-a-Date-Table)
   - [Building a Star Schema Model Build](#Building-a-Star-Schema-Model-Build)
   - [Creating Key Measures from the Data](#Creating-Key-Measures-from-the-Data)
   - [Date and Geographical Hierarchies](#Date-and-Geographical-Hierarchies)
3. [Building the Customer Detail Page](#Building-the-Customer-Detail-Page)
   - [Creating Card Visuals](#Creating-Card-Visuals)
   - [Creating Donut and Line charts](#Creating-Donut-and-Line-charts)
   - [Top customers Table and Cards](#Top-customers-Table-and-Cards)
   - [Date Slicer](#Date-Slicer)
4. [Building the Executive Summary Page](#Building-the-Executive-Summary-Page)
   - [Creating card visuals, Line Chart and Donut Charts](#Creating-card-visuals,-Line-Chart-and-Donut-Charts)
   - [Creating Bar Charts and KPI visuals](#Creating-Bar-Charts-and-KPI-visuals)
5. [Building the Product Detail Page](#Building-the-Product-Detail-Page)
   - [Creating Gauge Visuals and Filter State Cards](#Creating-Gauge-Visuals-and-Filter-State-Cards)
   - [Creating an Area Chart, Top Products Table and Scatter Graph](#Creating-an-Area-Chart,-Top-Products-Table-and-Scatter-Graph)
   - [Creating a Slicer Toolbar](#Creating-a-Slicer-Toolbar)
6. [Building the Stores Map Page](#Building-the-Stores-Map-Page)
   - [Creating a Map Visual and Country Slicer](#Creating-a-Map-Visual-and-Country-Slicer)
   - [Creating a Stores Drillthrough Page and a Stores Tooltip Page](#Creating-a-Stores-Drillthrough-Page-and-a-Stores-Tooltip-Page)
7. [Cross-Filtering and Navigation Set-up](#Cross-Filtering-and-Navigation-Set-up)
8. [Creating Metrics for Users Outside the company with SQL](#Creating-Metrics-for-Users-Outside-the-company-with-SQL)


## Introduction
This README will follow in a chronological order explaining the steps taken to achieve a Power BI comprehensive quarterly report for a medium sized international retailer. This will give the company insights into their data to elevate their business intelligence and various decision-making strategies.

## Setting up and Transforming the data

### Created a Virtual Machine
For this project I needed Windows to run Power BI Desktop. I created an Azure Virtual Machine (VM) so this was possible. 

### Importing data into Power BI Desktop
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


### Transformations on the Data
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


### Creating a Date Table
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
        

### Building a Star Schema Model Build
Relationships were built between the various tables. As I was going for a Star Schema Model Build, the four dimensional tables were directly connected to the main fact table `Orders`.
   -  all relationships are one-to-many, with a single filter direction flowing from the dimension table side to the fact table side.

<img width="1434" alt="Table-relationships" src="https://github.com/user-attachments/assets/751acfa6-bde4-4e29-9fdf-75feae9db9df">


### Creating Key Measures from the Data
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

### Date and Geographical Hieracrchies
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
Two Card visuals were used to present the number of `Unique customers` and `Revenue per Customer`. Shapes were used as backgrounds for the card visuals. The measure `[Total Customers]` was used for the Unique customers card, and the measures `[Total Revenue] / [Total Customers]` were used for the the revenue per customer card visual.

### Creating Donut and Line charts
A donut chart showing the total customers for each country was set up using `Customers[Country]` column to filter the `[Total Customers]` measure. An additional donut chart was set up in the same way but to show the number of customers who purchased each product category, using the `Products[Category]` column to filter the `[Total Customers]` measure.

A Line Chart visual was added to show `[Total Customers]` against the Date Hierarchy I created earlier. This gives an indication into Customers trends over time. I also added a forecast to the line chart so you can see future predictions about customers trends, with a 95% confidence interval.

### Top customers Table and Cards
I created a table which was filtered to display the Top 20 Customers by revenue. I filtered the table using a Top N filter as shown:

<img width="196" alt="Customer-filter-table" src="https://github.com/user-attachments/assets/a6ee5f30-2fc6-49b9-b4f6-4da1192ac412" />

I added conditional formatting to the revenue column to display data bars for the revenue values.

I used three card visuals which provided insights into the top customer by revenue. They displayed the top customer's name, the number of orders made by the customer, and the total revenue generated by the customer. These were created from the previous measures made.

### Date Slicer
A slicer was added to the Customer Detail Page so a certain date range (in years) could be used to filter the results. A between slicer was chosen for this because it was the clearest way to represent this specific slicer.

<img width="1063" alt="Customer-report-full" src="https://github.com/user-attachments/assets/fc8a9ad1-5935-4b94-9de9-acafcc81d42a" />


## Building the Executive Summary Page
The purpose of this page is to give an overview of the company's performance as a whole, so that C-suite executives can quickly get insights and check outcomes against key targets.

### Creating card visuals, Line Chart and Donut Charts
Three card visuals were created in the same way as the Customers Page but instead they show the measures `[Total Revenue]`, `[Total Orders]` and `[Total Profit]`. In the properties section, the data values were changed to a currency type to display the amount in £.

Similarly, the line grpah was created in the same way as the Customers Page but the Y-axis was set to `[Total Revenue]`.

Two donut charts were created showing `[Total Revenue]` broken down by `Store[Country]` and `Store[Store Type]`. These were also created in the same way as the donut charts created for the Customer Detail page.

### Creating Bar Charts and KPI visuals 
I created a Bar Chart to show the number of orders by product category. This was created by copying the `Total Customers by Product Category` donut chart from the Customer Detail page and changing the visual type to a clustered bar chart. The X-axis was changed to `[Total Orders]`.

Three KPI visuals were created to display the `Quarterly Revenue`, `Quarterly Orders` and `Quarterly Profit`. New measures were created to achieve this:
   Previous Quarter Measures to create Totals for previous quarter revenue, profit and orders. 
   - ```DAX
     Previous Quarter Revenue = CALCULATE([Total Revenue], PREVIOUSQUARTER('Date Table'[Date]))
     ```
   Target measures (equal to 5% growth in each measure compared to the previous quarter)
   - ```DAX
     Revenue Targets 5% = [Previous Quarter Revenue] * 1.05
     ```
The trend axis is on and the visuals are set so the values produce certain colours based on the previous quarter vs. the target values.

<img width="968" alt="Executive Report Full" src="https://github.com/user-attachments/assets/dabd07c6-228f-456a-a243-314815d35d4a" />

## Building the Product Detail Page
The purpose of this page is provide an in-depth look at which products within the inventory are performing well, with the option to filter by product and region.

### Creating Gauge Visuals and Filter State Cards


### Creating an Area Chart, Top Products Table and Scatter Graph

### Creating a Slicer Toolbar



## Building the Stores Map Page
 The Stores Map page allows the regional managers to easily check on the stores under their control, allowing them to see which of the stores they are responsible for are most profitable, as well as which are on track to reach their quarterly profit and revenue

### Creating a Map Visual and Country Slicer

### Creating a Stores Drillthrough Page and a Stores Tooltip Page



## Cross-Filtering and Navigation Set-up
I went through each page to make sure all corss-filtering was handled correctly and then finished the navigation bar so clicking an icon would take you to the correct page.

The corss-filtering checks and changes made sure only certain visuals could affect the other visuals. This is useful when ...

## Creating Metrics for Users Outside the company with SQL








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
8. [A completed Report Page with all Features](#A-completed-Report-Page-with-all-Features)
9. [Creating Metrics for Users Outside the company with SQL](#Creating-Metrics-for-Users-Outside-the-company-with-SQL)

NOTE: All pictures are screenshots and so are not interactive in the README, download the relevant file for an interactive experience.

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
      - For the Start of the Year Column:
      - ```DAX
        Start of Year = STARTOFYEAR('Date Table'[Date])
        ```
      - For the Start of the Week Column:
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
        - A measure for the Total Revenue the company has produced:
        - ```DAX
          Total Revenue = SUMX(Orders, Orders[Product Quantity] * RELATED(Products[Sale Price]))
          ```
        - A measure for the Total Profit the company has produced:
        - ```DAX
          Total Profit = SUMX(Orders, (RELATED('Products'[Sale Price]) - RELATED('Products'[Cost Price])) * Orders[Product Quantity])
          ```
        - A measure for the Revenue the company has produced Year to Date:
        - ```DAX
          Revenue YTD = TOTALYTD([Total Revenue], 'Date Table'[Date])
          ```
        - A measure for the Profit the company has produced Year to Date:
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
The purpose of this page is to provide an in-depth look at which products within the inventory are performing well, with the option to filter by product and region.

### Creating Gauge Visuals and Filter State Cards
I created three gauge visuals to show the current-quarter performance of Orders, Revenue and Profit against a quarterly target. The company is targeting 10% quarter-on-quarter growth in all three metrics. To acheive this I created the following measures:

- The current quarter for the three metrics (for Revenue shown here):
- ```DAX
  Current Quarter Revenue = CALCULATE([Total Revenue], DATESQTD('Date Table'[Date]))
  ```
- The targets for the three metrics (for Revenue shown here):
- ```DAX
  Revenue Target 10% = IF(ISBLANK([Previous Quarter Revenue]), [Current Quarter Revenue] * 1.10, [Previous Quarter Revenue] * 1.10)
  ```
- The gaps for the three metrics (for Revenue shown here):
- ```DAX
  Revenue Gap = [Current Quarter Revenue] - [Revenue Target 10%]
  ```

The Gap measures were used in conditional formatting. This was used to show if the target is not yet met, the callout value will be red and if it is met, the value will be black.

I created two filter state cards to reflect the filter state of the slicers. For these, two new measures were created to represent `Category Selection` and `Country Selection`:

- Measure for Country Selection filter card:
- ```DAX
  Country Selection = IF(ISFILTERED(Stores[Country]), SELECTEDVALUE(Stores[Country],"No Selection"))
  ```
- Measure for Category Selection filter card:
- ```DAX
  Category Selection = IF(ISFILTERED(Products[Category]), SELECTEDVALUE(Products[Category], "No Selection"), "No Selection")
  ```

### Creating an Area Chart, Top Products Table and Scatter Graph
I created an area chart that shows how the different product categories are performing in terms of revenue over time.

I also created a Top 10 products table with the following fields: `Product Description`, `Total Revenue`, `Total Customers`, `Total Orders`, `Profit per Order`. I filtered the table using a Top N filter, in the same way I did previously with the Top 20 Customers table.

I created a scatter graph so the company can quickly see which product ranges are both top-selling items and also profitable. This will allow the products team to know which items to suggest to the marketing team for a promotional campaign. For this I needed to create a new calculated column for the `[Profit per Item]` in the Products table:
- Calculated column DAX formula for Profit per item:
- ```DAX
  Profit per Item = Products[Sale Price] - Products[Cost Price]
  ```

With all these visuals the product page is complete and looks like this when no filters are selected:
<img width="966" alt="Product Report Full - Empty" src="https://github.com/user-attachments/assets/d7b0bef1-be34-46fe-8229-87b7afe78f13" />

### Creating a Slicer Toolbar
I added a blank button to the top of the navigation bar, set the icon type to Custom in the Format pane, and chose the relevant filter icon as the icon image. I used Power BI's bookmarks feature to create a pop-out toolbar where the slicers will be placed. One slicer was set to `Products[Category]`, another set to `Stores[Country]` and the last set to `[Year] & [Quarter]`. All these were set to list slicers so users can easily filter the data on the Product Detail page. ...


The Slicer bar:

<img width="145" alt="Filter toolbar Products" src="https://github.com/user-attachments/assets/e2e699e3-3537-42d6-b54d-fa621b92e5d6" />

Here are four examples of the Product Detail Page with different slicers applied, two showing the slicer bar open and two showing it closed:
<img width="969" alt="Product UK + example" src="https://github.com/user-attachments/assets/0e8c44aa-cb5a-4728-9bab-0978313572ed" />
<img width="968" alt="Product Example w Slicer bar" src="https://github.com/user-attachments/assets/fd6627c4-398c-4356-8333-f99a2fc45906" />
<img width="967" alt="Product Example w Germany" src="https://github.com/user-attachments/assets/15af5970-cacd-491f-b7f9-1fac2c2e63f6" />
<img width="966" alt="Product Example no date selected" src="https://github.com/user-attachments/assets/9f6b5a05-2ebd-4387-97b3-cca565f1fe4d" />


## Building the Stores Map Page
 The Stores Map page allows the regional managers to easily check on the stores under their control, allowing them to see which of the stores they are responsible for are most profitable, as well as which are on track to reach their quarterly profit and revenue.

### Creating a Map Visual and Country Slicer
I created a Map Visual and assigned the previously created `Geography hierarchy` to the **Location** field, and `[ProfitYTD]` measure to the **Bubble size** field.
I added a slicer to the page and set it to ` Stores[Country]` so you could use the slicer to filter between countries. The slicer is formatted so there is a select all option and multiple countires can be selected at once in a Tile slicer style.

<img width="966" alt="Store Map Region" src="https://github.com/user-attachments/assets/f49f2109-2aa0-47bf-aef8-d8b07253dd4d" />

### Creating a Stores Drillthrough Page and a Stores Tooltip Page
To make it easy for the regional managers to check on the progress of a given store, I created a drillthrough page that summarises each store's performance. This page contains:
- A table showing the top 5 products based on Total Orders
- A column chart showing Total Orders by product category for the store
- Gauges for Profit YTD against a profit target of 20% year-on-year growth vs. the same period in the previous year
- A Card visual showing the currently selected store

I created a new page and set the Page type to **Drillthrough** and set Drill through when to **Used as category**. I also set Drill through from to **country region**. For the gauges, I used the previous `[ProfitYTD]` and `[RevenueYTD]` measures. The goals for these gauges were a 20% increase on the previous year's year-to-date profit or revenue at the current point in the year:
   
   - Previous Year Profit DAX Formula:
   - ```DAX
     Previous Year Profit YTD = CALCULATE([Profit YTD], SAMEPERIODLASTYEAR('Date Table'[Date]))
     ```

   - Profit Goal DAX Formula:
   - ```DAX
     Profit Goal 20% = [Previous Year Profit YTD] * 1.20
     ```


<img width="965" alt="Store Drillthrough page" src="https://github.com/user-attachments/assets/40349b51-7a57-4a45-bb7f-115500e41bc8" />


I created a tooltip so users are able to see each store's year-to-date profit performance against the profit target just by hovering the mouse over a store on the map. For this I created a new tooltip page and copied the profit gauge visual, I then navigated to the Store Maps visual and set the tooltip of this visual to the tooltip page I created.


<img width="790" alt="Store Map showing tooltip" src="https://github.com/user-attachments/assets/4cca6469-c04f-420f-bd5b-c8283db7bb76" />


## Cross-Filtering and Navigation Set-up
I went through each page to make sure all corss-filterings were handled correctly and then finished the navigation bar so clicking an icon would take you to the correct page.

The corss-filtering checks and changes made sure only certain visuals could affect the other visuals. This is useful to prevent the page becoming too confusing and keeping key insights available to view at all times.

For each page, there was a custom icon and for each icon there are two colour variants. The white version was used for the default button appearance, and the cyan one was used so that the button changes colour when hovered over with the mouse pointer. In the sidebar of the Executive Summary page, I added four new blank buttons, and in the **Format > Button Style pane**, the **Apply settings to field** is set to **Default**, and each button icon was set to the relevant white png in the Icon tab. 

For each button, **Format > Button Style > Apply settings** was set to **On Hover**, and then selected the alternative colourway of the relevant button under the Icon tab. For each button, the Action format option was turned on, and selected as Page navigation type. The correct page was set under Destination, and the buttons were grouped together, and copied across to the other pages.

<img width="139" alt="Showing navigation bar" src="https://github.com/user-attachments/assets/60f35426-a323-465f-8f49-e8f15d5d189f" />

## A completed Report Page with all Features
<img width="831" alt="Complete Project" src="https://github.com/user-attachments/assets/199869a3-1c7c-4c79-a355-0954175ffe70" />

## Creating Metrics for Users Outside the company with SQL
I first connected to a Postgres database server hosted on Microsoft Azure so I could run the SQL queries on VSCode. I connected using the relevant HOST, PORT, DATABASE, USER and PASSWORD details. Once connected, I needed to get familiar with the data, tables and columns. To do this I printed a list of the tables in the database and then printed a list of the columns for each table.

Following this, I created 5 SQL queries to find information about the data. These queries were to answer the following questions:
1. How many staff are there in all of the UK stores?
2. Which month in 2022 has had the highest revenue?
3. Which German store type had the highest revenue for 2022?
4. Create a view where the rows are the store types and the columns are the total sales, percentage of total sales and the count of orders.
5. Which product category generated the most profit for the "Wiltshire, UK" region in 2021?

The following SQL queries are included in the files as `Question_1.sql` etc, where each number correlates to thw question above. The outputs of these queries were saved to CSV files with a correlating name, e.g `Question_1_result.csv`.

<img width="664" alt="Q5 SQL query" src="https://github.com/user-attachments/assets/f1bc96c4-53cd-45e9-99de-1b65e6baef59" />

<img width="326" alt="Q5 query result" src="https://github.com/user-attachments/assets/3f61e338-a5d3-4018-8276-30a29f1e710d" />

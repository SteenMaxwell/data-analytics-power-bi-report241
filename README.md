# Data Analytics Power BI Report

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
     - Extracted files locally and imported using Get Data > Folder.
     - Combined files within the folder using Power Query transformations.


## Transformations on Data
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





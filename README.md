# Data-Cleaning-using-SQL
🧹 Data Cleaning Project: World Layoffs Data in MySQL

This project focuses on the foundational steps of data cleaning using MySQL, transforming a raw dataset on global company layoffs into a standardized, analysis-ready format suitable for Exploratory Data Analysis (EDA).


🛠️ Technologies Used

Database Management System: MySQL

📊 Data Source

The dataset used is World Layoffs Data, containing records of layoffs across companies worldwide.

Columns:

company – Company name

location – Company’s location

industry – Company’s industry sector

total_laid_off – Number of employees laid off

percentage_laid_off – Percentage of the company’s workforce laid off

date – Date of the layoff event

stage – Company’s funding stage (e.g., Series B, Post IPO)

country – Country name

funds_raised_millions – Total funds raised (in millions)

🚀 Project Setup

Database Creation:
Created a new schema named world_layoffs.

Data Import:
Imported the raw dataset using Table Data Import Wizard into a table named layoffs.

Staging Table:
To protect the raw data, created a copy of the table called layoffs_staging (later referred to as layoffs_staging_2).

⚠️ All cleaning operations were performed only on the staging table.

⚙️ Data Cleaning Methodology

The cleaning process followed a four-step framework:

Step 1: Removing Duplicates

The dataset lacked a unique row ID, making duplicates harder to handle.

Identification:
Used ROW_NUMBER() window function partitioned by all columns
(company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions)
to assign row numbers.
Rows with row_num > 1 were marked as duplicates.

Deletion Workaround:
Since MySQL doesn’t allow deletion directly from a CTE:

Created a temporary table layoffs_staging_2 with an extra row_num column.

Inserted all rows (including the calculated row_num) into the new table.

Deleted all rows where row_num > 1.

Step 2: Standardizing Data

Standardized formatting, spelling, and structure across columns.

Trimming Whitespace:
Used TRIM() to remove leading/trailing spaces from the company column
(e.g., " Airbnb" → "Airbnb").

💡 In MySQL Workbench, you may need to disable Safe Updates under SQL Editor Preferences to allow UPDATE/DELETE without a key.

Industry Consolidation:
Merged similar values for consistency.

e.g., 'crypto', 'cryptocurrency', 'c-r-ypt' → 'Crypto'

Country Formatting:
Removed trailing periods:

e.g., 'United States.' → 'United States' using

TRIM(TRAILING '.' FROM country)


Date Conversion:
Converted the date column (originally stored as text) to proper MySQL DATE format:

STR_TO_DATE(date, '%m/%d/%Y')


Then altered the column type:

ALTER TABLE layoffs_staging_2 
MODIFY COLUMN date DATE;

Step 3: Handling Null and Blank Values

Addressed missing data for accuracy and reliability.

Industry Column:

Converted blank industry values to NULL for consistent handling.

Used a self-join on company and location to fill NULL industries:
If one row had a NULL industry but another row (same company & location) had a valid value, populated the NULL accordingly.

Worked for companies like Airbnb and Carvana.

Did not work for companies with only one record (e.g., Bailey’s).

Other Columns:
Left columns like total_laid_off, percentage_laid_off, and funds_raised_millions as NULL due to lack of reliable information to populate them.

Step 4: Removing Unnecessary Columns and Rows

Removing Rows:
Deleted rows where both total_laid_off and percentage_laid_off were NULL (considered unreliable for analysis).

Dropping Utility Column:
Dropped the temporary row_num column:

ALTER TABLE layoffs_staging_2 
DROP COLUMN row_num;



📈 Results

The final cleaned dataset:

Removed duplicates and irrelevant rows

Standardized formats for industries, countries, and dates

Addressed missing industry fields

Preserved only accurate and analysis-ready data

This cleaned dataset is now ready for EDA and visualization in tools such as Python, Tableau, or Power BI.

⚙️ Requirements

MySQL 8.0+

MySQL Workbench



📜 License

This project is licensed under the MIT License – see the LICENSE
 file for details.

🙌 Acknowledgments

Dataset: World Layoffs Data

Tutorial inspired by the YouTube series on Data Cleaning with MySQL

Thanks to the open-source community for SQL best practices

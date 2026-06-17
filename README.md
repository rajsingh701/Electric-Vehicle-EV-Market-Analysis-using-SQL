# 🚗 Electric Vehicle (EV) Market Analysis using SQL

## 📌 Project Overview
Electric Vehicles (EVs) are rapidly reshaping the automotive industry as countries move toward cleaner and more sustainable transportation. In this project, I used SQL and Google BigQuery to analyze EV adoption patterns across different countries and years.

The objective was to understand how factors such as charging infrastructure, fuel prices, government subsidies, and economic indicators influence EV growth. By transforming raw data into meaningful insights, this analysis highlights emerging EV markets and the drivers behind their adoption.

---

## 🎯 Objectives
- Analyze EV adoption trends across countries over time.
- Compare EV sales with petrol and diesel vehicle sales.
- Calculate EV market share and yearly growth rates.
- Examine the impact of charging infrastructure on EV adoption.
- Study the relationship between fuel prices and EV sales.
- Evaluate the role of government incentives in promoting EV usage.
- Assess environmental impact through CO₂ emission trends.

---

## 📂 Dataset Features
The dataset contains information related to:

- Country
- Year
- EV Sales
- Petrol Vehicle Sales
- Diesel Vehicle Sales
- Charging Stations
- Fuel Prices
- Government Subsidies
- GDP per Capita
- Urbanization Rate
- Battery Range
- CO₂ Emissions
- Vehicle Segment

---

## 🛠️ Technologies Used
- **SQL**
- **Google BigQuery**
- **Data Analysis**
- **Business Intelligence**

---

## 🔍 Business Questions Answered

### Market Analysis
- Which countries have the highest EV market share?
- Which countries are leading global EV adoption?
- How has EV adoption changed over time?

### Growth Analysis
- What is the year-over-year growth in EV sales?
- Which countries show the fastest EV growth?

### Infrastructure Analysis
- Does charging infrastructure influence EV adoption?
- Which countries have the strongest charging networks?

### Economic Analysis
- How do fuel prices impact EV sales?
- Does GDP per capita affect EV adoption?
- What is the impact of government subsidies on EV growth?

### Environmental Analysis
- How does EV adoption affect CO₂ emissions?
- Which countries demonstrate the greatest environmental benefits?

### Vehicle Segment Analysis
- Which vehicle segments have the highest EV penetration?
- How does battery range influence EV adoption?

---

## 🧮 SQL Concepts Used
- Common Table Expressions (CTEs)
- Aggregate Functions
- Window Functions
  - `RANK()`
  - `DENSE_RANK()`
  - `LAG()`
- `GROUP BY` & `ORDER BY`
- Subqueries
- `CASE WHEN` Statements
- Time-Series Analysis
- Market Share Calculation
- Growth Analysis

---

## 📈 Key Insights
- Identified countries with the highest EV market share.
- Measured yearly EV adoption trends across regions.
- Explored the relationship between charging stations and EV sales.
- Evaluated the effectiveness of government incentives.
- Assessed environmental impact through CO₂ emission analysis.
- Compared EV adoption across economic and demographic indicators.

---

## 🚀 Sample SQL Queries

### EV Market Share Calculation
```sql
SELECT
    country,
    SUM(ev_sales) AS total_ev_sales,
    SUM(ev_sales + petrol_car_sales + diesel_car_sales) AS total_sales,
    ROUND(
        SAFE_DIVIDE(
            SUM(ev_sales),
            SUM(ev_sales + petrol_car_sales + diesel_car_sales)
        ) * 100, 2
    ) AS ev_market_share
FROM vehicle_specs
GROUP BY country;
```

### Year-over-Year EV Growth
```sql
SELECT
    country,
    year,
    SUM(ev_sales) AS total_ev_sales,
    LAG(SUM(ev_sales))
    OVER(PARTITION BY country ORDER BY year) AS previous_year_sales
FROM vehicle_specs
GROUP BY country, year;
```

---

## 📊 Key Outcomes
✅ Identified high-growth EV markets across different regions

✅ Evaluated the impact of infrastructure and government policies

✅ Generated data-driven insights for sustainable transportation

✅ Demonstrated advanced SQL querying and analytical skills

---

## 🌟 Project Highlights
- Performed **15+ business-driven SQL analyses**
- Applied **advanced SQL techniques** including CTEs and window functions
- Conducted **market share and trend analysis**
- Generated **actionable insights** from real-world EV data

---

## 📁 Project Structure
```bash
EV-Market-Analysis/
│
├── EV_Market_Analysis.sql      # SQL queries for analysis
├── dataset.csv                 # Raw dataset
├── README.md                   # Project documentation
└── insights/                   # Query outputs and screenshots
```

---

## 👨‍💻 Author
**Raj Singh**

Aspiring **Data Analyst** skilled in **SQL, Python, Excel, and Power BI**, passionate about transforming data into actionable insights and solving business problems through analytics.

📧 Feel free to connect and collaborate!

---

⭐ If you found this project useful, consider giving it a **star** on GitHub!

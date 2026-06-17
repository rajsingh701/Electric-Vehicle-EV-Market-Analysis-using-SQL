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

# 📊 Key Business Questions Answered

## 1. Which countries have the highest EV market share compared to petrol and diesel vehicles?
```sql
with market_share as (
	select 
    country, 
    sum(ev_sales) as total_ev_sales,
    sum(ev_sales + petrol_car_sales + diesel_car_sales) as total_sales,
    round(safe_divide(sum(ev_sales), sum(ev_sales + petrol_car_sales + diesel_car_sales))*100, 2) as ev_market_share_percentage
    from `car_database.vehicle_specs`
    group by country
)
select *, 
rank() over(order by ev_market_share_percentage desc) as country_rank
from market_share
limit 5;
```
---

## 2. How has EV adoption changed over time across different countries or regions?
```sql
select 
country, 
year,
sum(ev_sales) as total_ev_sales,
sum(ev_sales + petrol_car_sales + diesel_car_sales) as total_sales,
round(safe_divide(sum(ev_sales), sum(ev_sales + petrol_car_sales + diesel_car_sales))*100 ,2) as market_share,
lag(sum(ev_sales)) over(partition by country order by year) as previous_year_sales
from `car_database.vehicle_specs`
group by country, year
order by country, year;
```
---

## 3. Is there a relationship between fuel prices and EV adoption rates across countries?
```sql
select
country,
round(avg(fuel_price_usd_per_liter), 2) as avg_price,
sum(ev_sales) as total_ev_sales,
sum(ev_sales + petrol_car_sales + diesel_car_sales) as total_sales,
round(safe_divide(sum(ev_sales), sum(ev_sales + petrol_car_sales + diesel_car_sales)) * 100, 2) as ev_market_share_percentage
from `car_database.vehicle_specs`
group by country
order by ev_market_share_percentage desc;
```
---

## 4. Do countries with more charging stations experience higher EV sales?
```sql
with charging_station as(
  select 
  country,
  sum(ev_sales) as total_ev_sales,
  sum(charging_stations) as total_charging_station
  from `car_database.vehicle_specs`
  group by country
)
select *, 
rank() over(order by charging_station.total_charging_station desc) as station_rank,
rank() over(order by charging_station.total_ev_sales desc) as sales_rank
from charging_station;
```
---

## 5. How effective are government subsidies in increasing EV adoption?
```sql
with subsidy as (
  select 
  country,
  round(avg(ev_subsidy_usd), 2) as avg_subsidy,
  sum(ev_sales) as total_ev_sales
  from `car_database.vehicle_specs`
  group by country
)
select *, 
rank() over(order by subsidy.avg_subsidy desc) as subsidy_rank,
rank() over(order by subsidy.total_ev_sales desc) as sales_rank
from subsidy;
```
---

## 6.  Which vehicle segment (mass market, premium, commercial) shows the highest EV adoption?
```sql
with segment as (
  select 
  vehicle_segment,
  sum(ev_sales) as total_ev_sales,
  sum(ev_sales + petrol_car_sales + diesel_car_sales) as total_sales,
  round(safe_divide(sum(ev_sales), sum(ev_sales + petrol_car_sales + diesel_car_sales)) * 100, 2) as market_share
  from `car_database.vehicle_specs`
  group by vehicle_segment
)
select *, 
rank() over(order by market_share desc) as adoption_rank
from segment;
```
---

## 7. How does EV adoption impact CO₂ emissions from transportation?
```sql
select 
country,
sum(ev_sales) as total_ev_sales,
sum(ev_sales + petrol_car_sales + diesel_car_sales) as total_sales,
round(safe_divide(sum(ev_sales), sum(ev_sales + petrol_car_sales + diesel_car_sales)) * 100, 2) as market_share,
round(avg(co2_emissions_transport_mt), 2) as avg_emission
from `car_database.vehicle_specs`
group by country
order by avg_emission desc;
```
---

## 8. Do countries with higher GDP per capita adopt EVs faster than lower-income countries?
```sql
select 
country,
sum(ev_sales) as total_ev_sales,
sum(ev_sales + petrol_car_sales + diesel_car_sales) as total_sales,
round(safe_divide(sum(ev_sales), sum(ev_sales + petrol_car_sales + diesel_car_sales)) * 100, 2) as market_share,
round(avg(gdp_per_capita), 2) as avg_gdp
from `car_database.vehicle_specs`
group by country 
order by avg_gdp desc;
```
---

## 9. Does improvement in EV battery range influence EV sales growth?
```sql
with yearly_sale as (
  select 
    year,
    round(avg(avg_ev_range_km), 3) as avg_battery_range,
    sum(ev_sales) as total_ev_sales
  from `car_database.vehicle_specs`
  group by year
)
select
year, 
yearly_sale.avg_battery_range,
total_ev_sales, 
lag(total_ev_sales) over(order by year) as previous_year_sales,
round(
  safe_divide(
    total_ev_sales - lag(total_ev_sales) over(order by year), lag(total_ev_sales) over(order by year) 
  ) * 100, 2
) as growth_percentage
from yearly_sale
order by year;
```
---

## 10. How is the market share shifting between EVs and petrol vehicles over time?
```sql
select 
year,
total_ev_sales,
total_petrol_sales,
round(
  safe_divide(
    total_ev_sales, total_sales
  ) * 100 , 2
) as ev_market_share,
round(
  safe_divide(
    total_petrol_sales, total_sales
  ) * 100, 2
) as petrol_market_share
from (
    select 
    year,
    sum(ev_sales) as total_ev_sales,
    sum(petrol_car_sales) as total_petrol_sales,
    sum(ev_sales + petrol_car_sales + diesel_car_sales) as total_sales
    from `car_database.vehicle_specs`
    group by year
) as ev_petrol_share
order by year;
```
---

## 11. Do countries with higher urban population percentages have higher EV adoption rates?
```sql
select 
country, 
avg_population,
total_sales,
total_ev_sales, 
round(
  safe_divide(
    total_ev_sales, total_sales
  ) * 100, 2
) as ev_adoption_rate
from (
  select 
    country,
    sum(ev_sales) as total_ev_sales,
    sum(ev_sales + petrol_car_sales + diesel_car_sales) as total_sales,
    round(
       avg(urban_population_percent)
    ) as avg_population
  from `car_database.vehicle_specs`
  group by country 
)
order by avg_population desc;;
```
---

## 12. Which countries are emerging as EV-dominant markets where EV sales exceed traditional vehicle sales? 
```sql
select
country, 
total_ev_sales, 
traditional_vehicle,
from(
    select 
      country,
      sum(ev_sales) as total_ev_sales,
      sum(petrol_car_sales + diesel_car_sales) as traditional_vehicle
    from `car_database.vehicle_specs`
    group by country
)
where total_ev_sales > traditional_vehicle;
```
---

## 📊 Key Outcomes
✅ Identified high-growth EV markets across different regions

✅ Evaluated the impact of infrastructure and government policies

✅ Generated data-driven insights for sustainable transportation

✅ Demonstrated advanced SQL querying and analytical skills

---

## 🌟 Project Highlights
- Performed **10+ business-driven SQL analyses**
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

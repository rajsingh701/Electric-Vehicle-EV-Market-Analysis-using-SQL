-- 1. Which countries have the highest EV market share compared to petrol and diesel vehicles?
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


-- 2. How has EV adoption changed over time across different countries or regions?
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

-- 3. Is there a relationship between fuel prices and EV adoption rates across countries?
select
country,
round(avg(fuel_price_usd_per_liter), 2) as avg_price,
sum(ev_sales) as total_ev_sales,
sum(ev_sales + petrol_car_sales + diesel_car_sales) as total_sales,
round(safe_divide(sum(ev_sales), sum(ev_sales + petrol_car_sales + diesel_car_sales)) * 100, 2) as ev_market_share_percentage
from `car_database.vehicle_specs`
group by country
order by ev_market_share_percentage desc;

-- 4. Do countries with more charging stations experience higher EV sales?
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

-- 5. How effective are government subsidies in increasing EV adoption?
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

-- 6. Which vehicle segment (mass market, premium, commercial) shows the highest EV adoption?
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

-- 7. How does EV adoption impact CO₂ emissions from transportation?
select 
country,
sum(ev_sales) as total_ev_sales,
sum(ev_sales + petrol_car_sales + diesel_car_sales) as total_sales,
round(safe_divide(sum(ev_sales), sum(ev_sales + petrol_car_sales + diesel_car_sales)) * 100, 2) as market_share,
round(avg(co2_emissions_transport_mt), 2) as avg_emission
from `car_database.vehicle_specs`
group by country
order by avg_emission desc;


-- 8. Do countries with higher GDP per capita adopt EVs faster than lower-income countries?
select 
country,
sum(ev_sales) as total_ev_sales,
sum(ev_sales + petrol_car_sales + diesel_car_sales) as total_sales,
round(safe_divide(sum(ev_sales), sum(ev_sales + petrol_car_sales + diesel_car_sales)) * 100, 2) as market_share,
round(avg(gdp_per_capita), 2) as avg_gdp
from `car_database.vehicle_specs`
group by country 
order by avg_gdp desc;


-- 9. Does improvement in EV battery range influence EV sales growth?
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

-- 10. How is the market share shifting between EVs and petrol vehicles over time?
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


-- 11. Do countries with higher urban population percentages have higher EV adoption rates?
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
order by avg_population desc;


-- 12. Which countries are emerging as EV-dominant markets where EV sales exceed traditional vehicle sales? 
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

Create database SQL_Project;
use sql_project;
select * from real_estate_1;
select * from real_estate_2;
alter table real_estate_1
rename column `ï»¿Property_ID` to Property_Id;
alter table real_estate_2
rename column `ï»¿Property_ID` to Property_Id;
-------------------------------------------------------------------------------------------------------------------------------------------
#1. Find duplicate properties based on same Location, Purchase Price and Square Footage.
select location, count(*) as total_count
from real_estate_1
group by location
having total_count>1;
select `Purchase Price ($)`, count(*) as Total_count
from real_estate_1
group by `Purchase Price ($)`
having Total_count>1;
select `Square Footage (sq ft)`, count(*) as total_count
from real_estate_1 
group by `Square Footage (sq ft)`
having total_count>1;
-------------------------------------------------------------------------------------------------------------------------------------------
#2.Find the second highest Final Sale Price among all properties.
select property_ID, `Final Sale Price ($)`
from real_estate_2
order by `Final Sale Price ($)`desc
limit 1 offset 1;
---------------------------------------------------------------------------------------------------------------------------------------------
#3. Retrieve properties that are present in real_estate_1 but missing in real_estate_2.
select * from real_estate_1
left join real_estate_2
on real_estate_1.Property_Id= real_estate_2.property_Id
where real_estate_2.Property_Id is null;
------------------------------------------------------------------------------------------------------------------------------------------
#4. Get the top 5 most expensive properties based on Final Sale Price.
select Property_ID,`Property Type`,`Final Sale Price ($)`
from real_estate_2
order by `Final Sale Price ($)` desc
limit 5;
-----------------------------------------------------------------------------------------------------------------------------------
#5.Show the total number of properties in each city.
select location,count(real_estate_1. Property_ID) as No_Of_Property
from real_estate_1
group by location
order by No_Of_Property;
-------------------------------------------------------------------------------------------------------------------------------
#6. Calculate the average Annual Rent Income for each city.
select location, avg(`Annual Rent Income ($)`) as Avg_Rent
from real_estate_1
group by Location
order by Avg_Rent desc;
-------------------------------------------------------------------------------------------------------------------------------
#7. Find cities where average Final Sale Price is higher than the overall average Final Sale Price.
select location, avg(`Final Sale Price ($)`) as Avg_Price
from real_estate_1
join real_estate_2
on real_estate_1.property_id=real_estate_2.property_id
group by location
having avg(`Final Sale Price ($)`)>
(select avg(`Final Sale Price ($)`) from real_estate_2);
--------------------------------------------------------------------------------------------------------------------------------
#8.Retrieve properties whose Final Sale Price is above the overall average Final Sale Price.
select real_estate_1.Property_Id,Location,`Final Sale Price ($)`
from real_estate_1
join real_estate_2
on real_estate_1.Property_Id=real_estate_2.property_Id
where `Final Sale Price ($)`>
(select avg(`Final Sale Price ($)`) from real_estate_2);
-------------------------------------------------------------------------------------------------------------------------------
#9.Find the most expensive property in each city.
select * from (select real_estate_1.property_Id,location,`Final Sale Price ($)`,
rank() over (partition by location
order by `Final Sale Price ($)` desc) as Price_Rank
from real_estate_1
join real_estate_2
on real_estate_1.property_ID=real_estate_2.Property_Id) ranked_properties
where Price_Rank=1;
-------------------------------------------------------------------------------------------------------------------------------
#10.Find the cheapest property in each city.
select * from (select real_estate_1.Property_Id,location,`Final Sale Price ($)`,
rank() over(partition by Location order by `Final Sale Price ($)` asc) as Rank_By_Price
from real_estate_1
join real_estate_2
on real_estate_1.property_Id=real_estate_2.property_Id) as ranked_Prices
where Rank_by_Price=1;
-------------------------------------------------------------------------------------------------------------------------------
#11.Rank properties by Final Sale Price within each city.
select * from (select real_estate_1.property_Id, Location,`Final Sale Price ($)`,
rank() over(partition by location order by `Final Sale Price ($)`) as Rank_By_Price
from real_estate_1
join real_estate_2
on real_estate_1.property_Id=real_estate_2.Property_Id)
Ranked_properties;
-------------------------------------------------------------------------------------------------------------------------------
#12.Calculate the difference between highest and lowest Final Sale Price in each city.
select location,max(`Final Sale Price ($)`),min(`Final Sale Price ($)`),
 max(`Final Sale Price ($)`)-min(`Final Sale Price ($)`) as Difference
from real_estate_1
join real_estate_2
on real_estate_1.property_Id=real_estate_2.property_Id
group by location;
-----------------------------------------------------------------------------------------------------------------------------------------------------
#13.Show the percentage contribution of each city to total Final Sale value of all properties.
select location, sum(`Final Sale Price ($)`) as City_Total_Sales, 
round(sum(`Final Sale Price ($)`)*100/sum(sum(`Final Sale Price ($)`))over(),2) as percentage_contribution
from real_estate_1
join real_estate_2
on real_estate_1.Property_Id=real_estate_2.Property_Id
group by location
order by City_Total_Sales desc;
--------------------------------------------------------------------------------------------------------------------------------
#14.Find properties where Final Sale Price is higher than Purchase Price.
select real_estate_1.property_Id,`Purchase Price ($)`,`Final Sale Price ($)`
from real_estate_1
join real_estate_2
on real_estate_1.property_Id=real_estate_2.property_Id
where real_estate_2.`Final Sale Price ($)`> real_estate_1.`Purchase Price ($)`;
-------------------------------------------------------------------------------------------------------------------------------
#15. Calculate price per square foot for each property.
select real_estate_1.property_Id,`Square Footage (sq ft)`,`Final Sale Price ($)`,
round(`Final Sale Price ($)`/`Square Footage (sq ft)`,2) as Price_Per_Square_Foot
from real_estate_1
join real_estate_2
on real_estate_1.property_Id=real_estate_2.property_Id;
-------------------------------------------------------------------------------------------------------------------------------
#16.Find properties whose price per square foot is higher than their city’s average price per square foot.
select * from (select real_estate_1.property_Id,(`Final Sale Price ($)`/`Square Footage (sq ft)`) as price_per_sq_feet,
avg(`Final Sale Price ($)`/`Square Footage (sq ft)`) over (partition by location) as city_avg_price
from real_estate_1
join real_estate_2
on real_estate_1.Property_Id=real_estate_2.Property_Id) as T
where price_per_sq_feet>city_avg_price;
-------------------------------------------------------------------------------------------------------------------------------
#17.Calculate the average Final Sale Price for each Property Type.
select `Property Type`, avg(`Final Sale Price ($)`) as avg_sale_price_per_city
from real_estate_2
group by `Property Type` 
order by avg_sale_price_per_city desc;
-------------------------------------------------------------------------------------------------------------------------------
#18.Find the Property Type with the highest average Final Sale Price.
select `Property Type`, avg(`Final Sale Price ($)`) as avg_sale_price_per_city
from real_estate_2
group by `Property Type` 
order by avg_sale_price_per_city desc
limit 1;
-------------------------------------------------------------------------------------------------------------------------------
#19.Count the number of properties for each Property Type.
select `Property Type`,count(Property_Id) as total_count
from real_estate_2
group by `Property Type`
order by total_count desc;
-------------------------------------------------------------------------------------------------------------------------------
#20.Find properties whose Vacancy Rate is higher than the average Vacancy Rate of their city.
select * from(select real_estate_1.property_Id,







































































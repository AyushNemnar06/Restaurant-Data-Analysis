---Creating DataBase for Our Restaurant Analysis Project------

Create Database Restaurant_Database 

---imported flat CSV files of Orders and Restrurant in our Database

---Orders Table Analysis:

use Restaurant_Database

select*from Orders

select*from Restaurants


--1.High-Spending Customers: Which customers are placing the highest number of orders or have the highest order amounts?

select top 10 * from Orders  --Top 10 High Spending Customers 
order by Order_Amount Desc   

--2.Peak Order Time: At what times of the day are the highest number of orders placed?

select Datepart(hour,Order_Date) as Order_time_in_Hr , count(Order_id) as Order_count
from Orders
group by Datepart(hour,Order_Date)
order by Order_count Desc


--3.Popular Payment Mode: What is the most common payment mode used by customers?

select Payment_Mode,count(*) as Count_Paymenet_methods from Orders
group by Payment_Mode 
order by Count_Paymenet_methods Desc

--4.Delivery Performance: What is the average delivery time for different zones?

SELECT R.Zone,AVG(DATEDIFF(hour, O.Order_time, O.Delivery_time)) AS Average_Delivery_Time
FROM Orders AS O
INNER JOIN 
Restaurants AS R ON O.Restaurant_ID = R.RestaurantID
GROUP BY 
R.Zone;

--5.Order Quantity vs. Amount: Is there a relationship between the quantity of items ordered and the total order amount?

SELECT Quantity_of_Items, 
       AVG(Order_Amount) AS Avg_Order_Amount
FROM Orders
GROUP BY Quantity_of_Items
ORDER BY Quantity_of_Items DESC;

--6.Customer Satisfaction: Which restaurants consistently get the highest customer ratings for food and delivery?

WITH CTE_table AS (
    SELECT R.RestaurantName AS RestaurantName, 
           AVG(O.Customer_Rating_Food) AS Avg_cust_food_rating, 
           AVG(O.Customer_Rating_Delivery) AS Avg_cust_delivery_rating
    FROM Orders AS O
    INNER JOIN Restaurants AS R ON R.RestaurantID = O.Restaurant_ID
    GROUP BY R.RestaurantName
)
SELECT RestaurantName, Avg_cust_food_rating, Avg_cust_delivery_rating
FROM CTE_table
order by Avg_cust_delivery_rating Desc,Avg_cust_food_rating desc


--7.Order Size: What is the average number of items ordered per order?

select avg(Quantity_of_Items) as [Avg no of items per order]
from Orders


--8.Delivery Efficiency: Which restaurants consistently have the fastest delivery times?

SELECT R.RestaurantName, 
       AVG(O.Delivery_Time_Taken_mins) AS Avg_Delivery_Time
FROM Orders AS O
INNER JOIN Restaurants AS R 
    ON O.Restaurant_ID = R.RestaurantID
GROUP BY R.RestaurantName
ORDER BY Avg_Delivery_Time;

--9.Top 10 customer who has Highest Order Amount?

select top 10 *
from Orders
order by Order_Amount desc

---The Cave Hotel has the Least Avg Delivery Time----- 
------------------------------------------------------


--Restaurants Table Analysis:
--1.Cuisine Popularity: Which cuisine type is the most ordered across different zones ?

select* from Restaurants
select * from Orders

select  R.Cuisine,R.Zone, count(O.Order_ID) as Preferred_Cuisine 
from Orders as O
inner join Restaurants as R on R.RestaurantID=O.Restaurant_ID
group by R.Cuisine,R.Zone
order by Preferred_Cuisine desc

--2.Cuisine Popularity: Which cuisine type is the most ordered ?

select count(O.Order_ID) as Preferred_Cuisine, R.Cuisine
from Orders as O
inner join Restaurants as R on R.RestaurantID=O.Restaurant_ID
group by R.Cuisine
order by Preferred_Cuisine desc

--3.Restaurant Performance: Which restaurant has the highest average customer ratings (both for food and delivery)?

with CTE_table as (
SELECT R.RestaurantName as RestaurantName,
       AVG(O.Customer_Rating_Delivery) AS [Avg Customer Delivery Rating],
       AVG(O.Customer_Rating_Food) AS [Avg Customer Food Rating]
FROM Restaurants AS R
INNER JOIN Orders AS O 
    ON R.RestaurantID = O.Restaurant_ID
GROUP BY R.RestaurantName
)
select RestaurantName,[Avg Customer Delivery Rating],[Avg Customer Food Rating]
from CTE_table
order by [Avg Customer Delivery Rating] desc,[Avg Customer Food Rating] desc

--4.Zone-wise Cuisine Distribution: How is the distribution of cuisine types across different zones?

SELECT Zone, Cuisine, COUNT(*) AS Distribution_of_Cuisine
FROM Restaurants
GROUP BY Zone, Cuisine
ORDER BY Distribution_of_Cuisine DESC;


--Combined Orders and Restaurants Analysis:

--1.Top Restaurants: Which restaurants are generating the highest revenue based on the total order amount?

select R.RestaurantName , sum(Order_Amount) as Total_Order_Amount
from Orders as O
inner join Restaurants as R on R.RestaurantID=O.Restaurant_ID
group by R.RestaurantName
order by Total_Order_Amount Desc

--2.Zone-Wise Performance: Which zones are performing the best in terms of order volume and revenue?

select*from Orders
select* from Restaurants 


--3.Customer Preferences by Zone: What cuisines or categories are most preferred in each zone?

select count(O.Customer_Name),R.Cuisine,R.Zone
from Orders as O as 
join Restaurants as R on R.RestaurantID=O.Restaurant_ID


--4.Order Amount by Cuisine: Which cuisine types generate the highest average order amounts?

SELECT 
R.Cuisine,
AVG(O.Order_Amount) AS Average_Order_Amount
FROM 
Orders AS O
INNER JOIN 
Restaurants AS R ON O.Restaurant_ID = R.RestaurantID
GROUP BY R.Cuisine
ORDER BY Average_Order_Amount DESC;

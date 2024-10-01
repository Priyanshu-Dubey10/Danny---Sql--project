select * from menu;
select * from members;
select * from sales;

-- What is the total amount each customer spent at the restaurant?
SELECT Customer_ID,SUM(Price) Total_Amount 
FROM Sales 
JOIN Menu 
USING(Product_ID) 
GROUP BY Customer_ID;

-- How many days has each customer visited the restaurant?
SELECT Customer_ID,COUNT(DISTINCT Order_Date) Days 
FROM Sales 
GROUP BY Customer_ID;

-- What was the first item from the menu purchased by each customer?
WITH CTE AS (
SELECT *,DENSE_RANK() OVER(PARTITION BY Customer_ID ORDER BY Order_Date) RNK 
FROM Sales JOIN Menu USING (Product_ID) )
SELECT Customer_ID,Order_Date,Product_Name FROM CTE WHERE RNK =1;

-- What is the most purchased item on the menu and how many times was it purchased by all customers?
SELECT Product_Name,COUNT(Product_Name) Number_Of_Purchase 
FROM Sales 
JOIN Menu USING(Product_ID) 
GROUP BY Product_Name 
ORDER BY COUNT(Product_Name) DESC
LIMIT 1;

-- Which item was the most popular for each customer?
with cte as(
SELECT Customer_ID,Product_Name,COUNT(Product_Name) Number_Of_Purchase,
DENSE_RANK () OVER(PARTITION BY Customer_ID ORDER BY COUNT(Product_Name) DESC ) Rnk
FROM Sales 
JOIN Menu USING(Product_ID)
group by Customer_ID,Product_Name)
SELECT Customer_ID,Product_Name,Number_Of_Purchase FROM cte WHERE rnk =1;


-- Which item was purchased first by the customer after they became a member?
WITH CTE AS (
SELECT *,ROW_NUMBER() OVER(PARTITION BY Customer_ID ORDER BY Order_Date ASC) rnk 
FROM Sales JOIN Members USING(Customer_ID) JOIN Menu USING(Product_ID) WHERE Order_Date >= Join_Date )
SELECT Customer_ID,Product_Name,Order_Date,Join_Date FROM CTE WHERE rnk <=1;

-- Which item was purchased just before the customer became a member?
WITH CTE AS (
SELECT *,ROW_NUMBER() OVER(PARTITION BY Customer_ID ORDER BY Order_Date ASC) rnk 
FROM Sales JOIN Members USING(Customer_ID) JOIN Menu USING(Product_ID) WHERE Order_Date < Join_Date )
SELECT Customer_ID,Product_Name,Order_Date,Join_Date FROM CTE WHERE rnk <=1;

-- What is the total items and amount spent for each member before they became a member?
SELECT Customer_ID,COUNT(product_Name) Total_Item ,SUM(Price) Total_Amount
FROM Sales JOIN Members USING(Customer_ID) JOIN Menu USING(Product_ID) WHERE Order_Date < Join_Date 
GROUP BY Customer_ID;

-- If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
SELECT Customer_ID,
SUM(CASE WHEN Product_Name = 'sushi' THEN Price*10*2 ELSE price*10 END) AS Points
FROM Sales JOIN Menu USING(Product_ID)
GROUP BY Customer_ID;
 
 -- if they earn 2x points on all items, not just sushi - how many points do customer
 -- A and B have at the end of January?
 
SELECT Customer_ID ,
SUM(CASE WHEN product_name = product_name then price*10*2  end) as Points
FROM Sales JOIN Menu USING(Product_ID) WHERE MONTH(Order_Date) = 1
GROUP BY Customer_ID ORDER BY Customer_ID LIMIT 2;
  

  
  
  


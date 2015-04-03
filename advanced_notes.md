# Advanced SQL

To be a SQL wizard, it's important to become very comfortable with SQL joins, nested `SELECTS` and `GROUP BY`s.

Let's say for an online sales company you have the following tables:

```
customers
    name
    id

products
    name
    id
    price

purchases
    customer_id
    product_id
    date
    quantity
```

### Inner Join

If you want to get all the purchases but you want to include the customer name and the product name, you would use a stardard join (this is also called an *inner join*):

```sql
SELECT customers.name AS cust_name, products.name AS prod_name, date, quantity
FROM purchases
JOIN products ON products.id=purchases.product_id
JOIN customers ON customers.id=purchases.customer_id;
```

### Outer Join

Let's say there's a mistake in our database and some products are in the purchase table but not in the products table. With the above query, they would just end up being excluded. An inner join only includes entries which are in both tables.

We can insure they are included in our result by using an *outer join*.

```sql
SELECT customers.name AS cust_name, products.name AS prod_name, date, quantity
FROM purchases
LEFT OUTER JOIN products ON products.id=purchases.product_id
JOIN customers ON customers.id=purchases.customer_id;
```

The LEFT means that everything from the first table will be included even if there isn't a matching entry in the second table. This will include those missing products, but their names will be `NULL`.

If you'd like to fill in those null values with something, maybe in this case just the product id, you can use the `COALESCE` function (in some implementations of SQL there is an `IFNULL` function).

Note that since the product id is an integer, we have to convert it to a string using the `CAST` function.

```sql
SELECT
    customers.name AS cust_name,
    COALESCE(products.name, CAST(purchases.product_id AS VARCHAR)) AS prod_name,
    date,
    quantity
FROM purchases
LEFT OUTER JOIN products ON products.id=purchases.product_id
JOIN customers ON customers.id=purchases.customer_id;
```

### Except

Something that comes up a lot is finding these products which aren't in the products table. We can do this using an outer join:

```sql
SELECT purchases.product_id
FROM purchases
LEFT OUTER JOIN products
ON purchases.product_id=products.id
WHERE products.id IS NULL;
```

You can also use `EXCEPT` (MINUS in some versions of SQL):

```sql
SELECT purchases.product_id
FROM purchases
EXCEPT
SELECT products.id
FROM products;
```


### Getting the maximum

For this we will assume that there's no missing data in our tables.

There is a MAX function which gives you the maximum value, but often you want the entry associated with it. Let's say you want to find the most expensive item. The way to do this is to find the maximum price and then find all the elements whose price is that value.

This requires you to do a nested SELECT statement.

```sql
SELECT *
FROM products
WHERE price=(SELECT MAX(price) FROM products); 
```

Or maybe you want the product which has generated the most profit. Sometimes it's helpful to, instead of having multiple nested selects, creating a temporary table as an intermediary step.

```sql
CREATE TABLE profits AS
SELECT products.name, products.id, SUM(purchases.quantity * products.price) AS profit
FROM products
JOIN purchases
ON products.id=purchases.product_id
GROUP BY products.name, products.id;

SELECT name, id
FROM profits
WHERE profit=(SELECT MAX(profit) FROM profits);
```

You can also do this with a nested query without creating the intermediary table:

```sql
SELECT name, id
FROM profits
WHERE profit=(SELECT MAX(profit)
              FROM (SELECT products.name,
                           products.id,
                           SUM(purchases.quantity * products.price) AS profit
                    FROM products
                    JOIN purchases
                    ON products.id=purchases.product_id
                    GROUP BY products.name, products.id) tmp);
```

Or using a with clause:

```sql
WITH p AS (
SELECT products.name, products.id, SUM(purchases.quantity * products.price) AS profit
FROM products
JOIN purchases
ON products.id=purchases.product_id
GROUP BY products.name, products.id)

SELECT name, id
FROM p
WHERE profit=(SELECT MAX(profit) FROM p);
```

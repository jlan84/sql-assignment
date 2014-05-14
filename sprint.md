SQL Sprint
======================================

Overview
===================
In this exercise, we are going to learn the basics of SQL and gain an understanding of what an [RDBMS](http://en.wikipedia.org/wiki/Relational_database_management_system) has to offer.
We've created a fake company  — ReadyChef — with simulated data. The database is a simulation of a user database for a food e-commerce website where user's have different activities
such as sharing, liking, and buying. We are going to focus on general reporting with regards to revenue, referrals, and other  basic questions you would face at a day job.


* An RDBMS if you remember, is a server that stores data on disk.
* You connect to via a client, in this case `psql`
* You can then query that data via SQL.
* An RDBMS first has to store data in a database. We've created the database already  for you.
* First, let's get familiar with the traditional workflow of working with a database.




Goals
======================
   1. Explore the Database
   2. Basic Querying - Selecting From Tables
   3. Selecting specific attributes of a table
   4. Where clause/ filtering
   5. Aggregation functions: counting
   6. Aggregation functions: AVG
   7. Intervals, Ranges, and sorting
   8. Subqueries
   9. More subqueries - a whole tutorial
   10. Extra Tutorial on selects


Helpful Tip:
==========================

Also, when doing your queries, there are tables that are capital. This is to teach you how to do quoting.

Since Postgres is case sensitive, you will want to double quote anything you reference that's a part of the database.


The concrete syntax for this will be:

`"table"."column_name"`

This will be useful later.


Begin - Exploring the database commands
================================

First going in to the database, the [docs](http://www.postgresql.org/docs/9.3/interactive/) might be helpful.


First thing that we need to do is start our Postgres database. In your terminal check to see if the server is running:

`pg_ctl -D /usr/local/var/postgres status`

If not, start your Postgres instance with the following command:

`pg_ctl -D /usr/local/var/postgres start`

Now enter into the interactive SQL shell:


`psql`


Now we are in a command line client. This is how we will explore the database to gain an understanding of what data we are playing with.

We will want to first see what databases available to us. Remember, each database will have several tables. Usually you will only work with one database

at a time. Now let's list the available databases.


In your command line client type:

`\l`

You should see something like:

                                    List of databases
          Name    |  Owner   | Encoding |   Collate   |    Ctype    |   Access privileges
      -----------+----------+----------+-------------+-------------+-----------------------
           postgres  | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 |
           template0 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +
                     |          |          |             |             | postgres=CTc/postgres
            template1 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +
          |          |          |             |             | postgres=CTc/postgres



This will show the list of available databases. Now let's specify which database we should use.


Let's play around with some of the databases other functions now. Let's say we want a help prompt.


Now type:
             
`\h`

This gives us a help prompt with a list of available commands. Don't worry about what all these mean right now.


Now we are going to exit the postgres command line interface (cli):

Type:

`\q`


Now exit the terminal. Based on the list of databases we just saw, we want the readychef database.

Now type:

`psql readychef`


This will connect you to the readychef database. From here, we will want to explore the schema of the database.

Firstly, we will want to see what the available tables are. Remember, now that we are in the database, all of our commands or actions

will be on the readychef database.



As of right now, we don't know much about the database. First, let's display the tables.

Type:

`\d`


This will give us a list of tables to choose from.


One thing we might want to do is see all of the attributes of the table. To do this, pick a table and type:

`\d table`

where table is the table you want to describe.

Do this for each one to understand the column format of the table.



Selecting from tables
=================================

Now that we are comfortable with moving around the database and the different options, we can start querying.
Remember, databases are based on a very
simple idea of CRUD (Create,Read,Update,Delete). As a data scientist,
your primary role will be the Read part to do some analysis. In this exercise,
we are going to focus on the select statement.

1. Run a [SELECT](http://www.postgresqltutorial.com/postgresql-select/) statement on each table. Limit the number of rows to 10.


Select specific attributes
=======================================================

Now that we have seen how to select data from tables. Let's do something practical and select different columns from each table.
From here, we are going to start answering basic questions about the data.
To start let's pick a table to play with. To remind ourselves of the available tables, type:

`\d`

This command will then be:


`\d "tablename"`

The quotes for table names and other database entities are required.


Now, let's select specific attributes of the Users table. We will want to answer the question,

1. What social networks do users come from?

Write a `SELECT` statememnt that returns only the `Campaign_ID` column from a given table. This will contain the titles of the different social networks.

The campaign ids returned are from different social networks :

Pinterest=PI, Facebook=FB, Twitter=TW, and Reddit=RE.

Your output should look something like this:

```
  Campaign_ID
 -------------
   RE
   FB
   FB
   RE
   TW
   TW
   FB
   RE
   TW
   RE
   RE
   FB
   RE
   PI
   PI
   PI
   PI
   PI
   RE
   FB
   FB
```

Where Clauses / Filtering
========================================

Now that we have the lay of the land, we're interested in the subset of users that came from Facebook (FB).   If you're unfamiliar with SQL syntax, the [WHERE](http://www.postgresqltutorial.com/postgresql-where/) clause can be used to add a conditional to `SELECT` statements. This has the effect of only returning rows where the conditional evaluates to `TRUE`. 

_If you get syntax errors, a tip here is to put the literals in single quotes._

1. Using the `WHERE` clause, write a new `SELECT` statement that returns all rows where `Campaign_ID` is equal to `FB`.
2. But what if we only care about their user `ID`s? Modify your `SELECT` statement to return only the `id` and the `Campaign_ID` columns from users that came from FB.

Your output should be something like this:

```
id  | Campaign_ID
------+-------------
      51 | FB
      52 | FB
      56 | FB 
      61 | FB
      69 | FB
      70 | FB
      73 | FB
```

So what have we accomplished here?

We now know how to select different columns from different tables, explore the database,
and filter out by certain values.



Aggregation Functions: Counting
=======================================

Let's try some simple aggregation functions now.


1. Now, modify your `SELECT` statement to [COUNT](http://www.postgresql.org/docs/8.2/static/functions-aggregate.html) the total number of users that come from FB. Unlike `WHERE` clauses, aggregation functions are specified in the `SELECT` statement itself.

For example, if I wanted to know the total number of users in my database, I would run the following query:

```
SELECT COUNT(*) 
FROM Users
```


Your output should look something like:

```
  count
 -------
   1265
 (1 row)
```

2. Now, calculate the percentage of users coming from each service. Just manually divide by the count. Note that this is a different number from up top. You want the total number of users period.


Aggregation functions: AVG
================================

Moving on from the user's table a bit, let's try the [avg](http://www.postgresql.org/docs/9.1/static/functions-aggregate.html) function.
The meals table has prices from which we can do some easy statistical calculations.

1. Let's try to figure out the mean price of a given meal. Write a `SELECT` statement that returns only the price column
   and calculate the mean or average price for a meal.


Your output should look something like this:

```
           avg
   ---------------------
     10.0360814351945172
         (1 row)
```


2. Now do this for each meal type.

Create a group by meal type with an average price per meal type.


Your output should look like this:

```
         Type    |         avg
------------+---------------------
     mexican    | 10.0901525658807212
     french     |  9.9719764011799410
     japanese   |  9.9532163742690058
     italian    |  9.9972027972027972
     chinese    | 10.2047244094488189
     vietnamese |  9.9154929577464789
     german     | 10.1027496382054993
```


Intervals, Ranges, and sorting
==========================================

Now we are going to get creative.

1. Using the previous query, let's answer the question on what meal type
   can be the most profitable. Add a sort descending on the previous query. This will allow us to understand
   how to rank by average meal price. One thing to understand is [aliasing](http://stackoverflow.com/questions/15413735/postgresql-help-me-figure-out-how-to-use-table-aliases)


Your output should look like:

```
       Type    |      avg_price
   ------------+---------------------
      chinese    | 10.2047244094488189
      german     | 10.1027496382054993
      mexican    | 10.0901525658807212
      italian    |  9.9972027972027972
      french     |  9.9719764011799410
      japanese   |  9.9532163742690058
      vietnamese |  9.9154929577464789
     (7 rows)
```


2. Next, let's experiment with ranges and intervals. Again get the average price per meal type and only get the food type with a price than or equal to 10. (Grab food items with a price >= 10 only then average)

```
    Type    |      avg_price
   ------------+---------------------
   french     | 12.6951566951566952
   chinese    | 12.6651053864168618
   japanese   | 12.6416666666666667
   mexican    | 12.6227848101265823
   german     | 12.5452196382428941
   vietnamese | 12.4921465968586387
   italian    | 12.4698492462311558
```






Joins
=========================

Now we are ready to do operations on multiple tables. If you remember [joins](http://www.tutorialspoint.com/postgresql/postgresql_using_joins.htm), joins allow us to perform aggregate operations

very fast on multiple tables. These result sets will easily get complicated so we should take care to understand what joins are,
how each one works on different tables, and how to structure the query so we only return what we need.



  1. Let's start by answering the question, "How many meals did each user buy"
     We will need to perform joins on the Event,Meal  tables.

   2. First, [filter](http://www.techonthenet.com/sql/where.php) the event type by bought.

Next, compute a join on the users and meal tables.

Now combine those queries to answer the question

```
   id  | count
 ------+-------
  1548 |     1
   106 |     4
  1513 |     1
  2125 |     1
   276 |     2
   606 |     2
  1439 |     2
  1728 |     2
  2285 |     2
  1676 |     1
   807 |     1
  1231 |     2
   151 |     1
  1692 |     1
   253 |     2
   852 |     1
   437 |     2
  4875 |     1
   549 |     3
   268 |     1
   310 |     3
  2055 |     1
   etc.
```

Joins and aggregations
===========================

Now let's start doing some aggregate analysis. Take the time and answer the question,

"What user from each campaign bought the most items?"

This will be composed of a multi table join, ranking by count of a column,  and then grouping by column value types.

```
    Campaign_ID | count | count
   -------------+-------+-------
    PI          |   532 |   532
   (1 row)
```





If you get done with all of this, you can start with sub queries




Subqueries
================================

Here is an example of a [subquery](http://www.postgresql.org/docs/8.1/static/functions-subquery.html):

```

                    select cost1,
                           quantity_1,
                           cost_2,
                           quantity_2
                           total_1 + total_2 as total_3
                    from (
                        select cost_1,
                               quantity_1,
                               cost_2,
                               quantity_2,
                               (cost_1 * quantity_1) as total_1,
                               (cost_2 * quantity_2) as total_2
                        from data
                    ) t
```

There is a lot going on here. One thing to understand is [aliasing](http://stackoverflow.com/questions/15413735/postgresql-help-me-figure-out-how-to-use-table-aliases)

An alias renames a column using the as clause. This also allows us to create temporary columns aka derived attributes.

We are going to use this to create a little mini report of meals that are greater than the average price for each category.

1. Identify items above the average price for the column.

   
Your output should look like:
```
              Type    | price
            ------------+-------
             french     |    12
             french     |    11
             french     |    11
             chinese    |    15
             japanese   |    13
             italian    |    10
             mexican    |    12
             italian    |    11
             vietnamese |    14
             italian    |    10
             vietnamese |    13
             italian    |    12
             vietnamese |    13
             mexican    |    11
             french     |    14
             german     |    11
             vietnamese |    15
             french     |    15
             italian    |    12
             vietnamese |    12
             mexican    |    13
             german     |    14
             french     |    11
             french     |    13
             italian    |    10
             chinese    |    12
             french     |    11
             japanese   |    15
             vietnamese |    13
             vietnamese |    11
             vietnamese |    13
             german     |    15
             german     |    15
             chinese    |    12
             italian    |    11
             italian    |    14
             vietnamese |    10
             japanese   |    15
             german     |    15
             german     |    11
             mexican    |    14
             vietnamese |    13
             vietnamese |    11
             japanese   |    15
             mexican    |    15
             german     |    14
             vietnamese |    14
             mexican    |    11
             mexican    |    13
             chinese    |    12
             vietnamese |    10
             german     |    13
             mexican    |    13
             vietnamese |    14
             italian    |    12
             french     |    11
             vietnamese |    14
             german     |    12
             japanese   |    10
             vietnamese |    15
             french     |    10
             vietnamese |    14
            --More--
```
 

2. From there, count the number of meals per type that are above the average price.
This can allow us to identify meals that might be slightly more profitable.

3. Now do the same thing for anything less than the mean, and do a count on all items that are below the mean
price per meal type.




2. Count the number of items by type that are greater than the avg. Your output should be below:


                    Type    | count
                ------------+-------
                 mexican    |   340
                 french     |   351
                 japanese   |   360
                 italian    |   398
                 chinese    |   369
                 vietnamese |   382
                 german     |   316
                (7 rows)


3. Now calculate the columnwise percentage of users from each service. You will need to use [GROUP BY](http://stackoverflow.com/questions/6207224/calculcating-percentages-with-group-by-query).


Extra Tutorial:
========================
http://sqlzoo.net/wiki/SELECT_within_SELECT_Tutorial

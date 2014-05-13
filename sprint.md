SQL Sprint
======================================


In this exercise, we are going to exercise the basics of SQL and gain an understanding

of what an RDBMS has to offer.

An RDBMS if you remember, is a server you connect to via a client that stores data on disk.

You can then access that data via SQL.

An RDBMS first has to store data in a database. This will already be in there for you.

Firstly, let's get familiar with the traditional workflow of working with a database.

We will be doing this with the command line client in postgresql.



Helpful Resource:
http://www.postgresql.org/docs/9.2/static/rangetypes.html
http://www.postgresql.org/docs/9.2/static/functions-range.html
http://stackoverflow.com/questions/8840228/postgresql-using-a-calculated-column-in-the-same-query
http://blog.codinghorror.com/a-visual-explanation-of-sql-joins/ail
http://www.postgresql.org/docs/8.4/static/queries-select-lists.html


Also, when doing your queries, there are tables that are capital. This is to teach you how to do quoting.

Since Postgres is case sensitive, you will want to double quote anything you reference that's a part of the database.


The concrete syntax for this will be:

               "table"."column_name"

This will be useful later.


Open up a terminal and type:

                psql


Now we are in a command line client. This is how we will explore the database to gain an understanding of what data we are playing with.

We will want to first see what databases available to us. Remember, each database will have several tables. Usually you will only work with one database

at a time. Now let's list the available databases.


In your command line client type:

             \l

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
            \h

This gives us a help prompt with a list of available commands. Don't worry about what all these mean right now.


Now we are going to exit the postgres command line interface (cli):

Type:

            \q


Now exit the terminal. Based on the list of databases we just saw, we want the readychef database.

Now type:

          psql readychef


This will connect you to the readychef database. From here, we will want to explore the schema of the database.

Firstly, we will want to see what the available tables are. Remember, now that we are in the database, all of our commands or actions

will be on the readychef database.



As of right now, we don't know much about the database. First, let's display the tables.

Type:

    \d


This will give us a list of tables to choose from.


One thing we might want to do is see all of the attributes of the table. To do this, pick a table and type:

        \d table

where table is the table you want to describe. Do this for each one to understand the column format of the table.



# Selecting from tables
Now that we are comfortable with moving around the database and the different options, we can start querying. Remember, databases are based on a very
simple idea of CRUD (Create,Read,Update,Delete). As a data scientist, your primary role will be the Read part to do some analysis. In this exercise,
we are going to focus on the select statement.

Run a select statement on each table. To make this fast, limit the number of results to 10. Remember the limit clause.


The goal of this will be to explore the data and understand what it looks like.

See here for how to do this:

        http://www.postgresqltutorial.com/postgresql-select/


# Select specific attributes

Now that we have seen how to select data from tables. Let's do something practical and select different columns from each table.

From here, we are going to start answering basic questions about the data.

To start let's pick a table to play with. To remind ourselves of the available tables, type:

               \d

This command will then be:


               \d "tablename"

The quotes for table names and other database entities are required.


Now, let's select specific attributes of the Users table. We will want to answer the question,

what social networks do users come from?


Your output should look something like this:

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


Select only the Campaign_ID column. This will contain the titles of the different social networks.

You might wonder what each of these campaign ids mean. The campaign ids from different social networks include:

Pinterest, Facebook, Twitter, and Reddit.



#Where clause/ filtering

Next, we want to filter out and select only the users that come from Facebook.

The WHERE clause will be helpful here. If you get syntax errors, a tip here is to put the literals in single quotes.


Now select the user id and the campaign id from the users table.

Your output should be something like this:


id  | Campaign_ID
------+-------------
   51 | FB
   52 | FB
   56 | FB
   61 | FB
   69 | FB
   70 | FB
   73 | FB
   77 | FB
   78 | FB
   89 | FB
   94 | FB
  100 | FB
  103 | FB
  113 | FB
  120 | FB
  121 | FB
  124 | FB
  126 | FB
  127 | FB
  130 | FB
  132 | FB


So what have we accomplished here?

We now know how to select different columns from different tables, explore the database, and filter out by certain values.



#Aggregation functions: counting

Let's try some simple aggregation functions now.


Count the number of users that come from facebook.

Your output should look somethin glike:

 count
-------
  1265
(1 row)



#Intervals and Ranges

Moving on from the user's table a bit, let's try some basic range functions.

The meals table has prices from which we can do some easy statistical calculations.

Let's try to figure out the mean price of a given meal. Select only the price column

and calculate the mean or average price for a meal.


Your output should look something like this:
        avg
---------------------
 10.0360814351945172
(1 row)



Now do this for each meal type.

Create a group by meal type with an average price per meal type.


Your output should look like this:

   Type    |         avg
------------+---------------------
 mexican    | 10.0901525658807212
 french     |  9.9719764011799410
 japanese   |  9.9532163742690058
 italian    |  9.9972027972027972
 chinese    | 10.2047244094488189
 vietnamese |  9.9154929577464789
 german     | 10.1027496382054993


#Intervals, Ranges, and sorting

Now we are going to get creative. Using the previous query, let's answer the question on what meal type

can be the most profitable. Add a sort descending on the previous query. This will allow us to understand

how to rank by average meal price.


Your output should look like:

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



Next, let's experiment with ranges and intervals. Again get the average price per meal type and only get the food type with a price than or equal to 10.

   Type    |      avg_price
------------+---------------------
 french     | 12.6951566951566952
 chinese    | 12.6651053864168618
 japanese   | 12.6416666666666667
 mexican    | 12.6227848101265823
 german     | 12.5452196382428941
 vietnamese | 12.4921465968586387
 italian    | 12.4698492462311558








#Joins


Now we are ready to do operations on multiple tables. If you remember joins, joins allow us to perform aggregate operations

very fast on multiple tables. These result sets will easily get complicated so we should take care to understand what joins are,

how each one works on different tables, and how to structure the query so we only return what we need.


Let's start by answering the question, "How many users bought a meal?"

We will need to perform joins on the Event,Meal, and User tables.

First, filter the event type by bought.

Next, compute a join on the users and meal tables.

Now combine those queries to answer the question


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
  101 |     1
  836 |     1
 2136 |     1
   20 |     6
 4472 |     1
 1465 |     1
 1253 |     1
  359 |     3
 1060 |     1
  213 |     1
 3319 |     1
 1478 |     1
 2147 |     1
 1662 |     1
  292 |     1
  373 |     1
   27 |     1
 1403 |     1
 1936 |     2
 3876 |     1
  969 |     1
 1726 |     1
 1578 |     3
  449 |     1
 3159 |     1
  899 |     1
 1120 |     2



#Joins and aggregations


Now let's start doing some aggregate analysis. Take the time and answer the question,

"What user from each campaign bought the most items?"

This will be composed of a multi table join, ranking by count of a column,  and then grouping by column value types.


 Campaign_ID | count | count
-------------+-------+-------
 PI          |   532 |   532
(1 row)






If you get done with all of this, you can start with sub queries:




#Aggregation, sorting

From there, count the number of meals per type that are above the average price.

This can allow us to identify meals that might be slightly more profitable.

Now do the same thing for anything less than the mean, and do a count on all items that are below the mean

price per meal type.




http://sqlzoo.net/wiki/SELECT_within_SELECT_Tutorial
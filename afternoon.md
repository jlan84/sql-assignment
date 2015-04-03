# Advanced SQL and SQL Pipelines

You work at a social media site. You have to write a lot of queries to get the desired data and stats from the database.

You will be working with the following tables:

* `registrations`: One entry per user when the register
* `logins`: One entry every time a user logs in
* `optout`: A list of users which have opted out of receiving email
* `friends`: All friend connections. Note that while friend connections are mutual, sometimes this table has both directions and sometimes it doesn't. You should assume that if A is friends with B, B is friends with A even if both directions aren't in the table.
* `messages`: All messages users have sent
* `test_group`: A table for an A/B test

## Setting up psql on a Mac

1. Go to the home directory by running ``cd`` in the terminal

2. Run ```nano .zshrc``` to open up the terminal configurations

3. Push the down arrow key until you reach the end of the file and insert the following line at the end of the file

   ```export PATH=/Applications/Postgres.app/Contents/Versions/9.4/bin:$PATH``` 

4. Exit nano by pushing the ```Control``` and ```x``` keys

5. Open a new terminal and ```psql``` 

## Connecting to the database

There's a sql dump of the database in `socialmedia.sql`.

Here are the steps to load it up:

1. First create the database by running `psql` and then the following command:

    ```sql
    CREATE DATABASE socialmedia;
    ```
    Use `\q` to quit `psql`.

2. You can load the sql dump with this command on the commandline:

    ```shell
    psql -U postgres socialmedia < data/socialmedia.sql
    ```

3. Finally, to run the database:

    ```shell
    psql -U postgres socialmedia
    ```

If you're running into issues, make sure you're running `postgres.app`.


## Investigate your database

You can get a list of all the tables with this command: `\d`

You can get the info for a specific table with this command: `\d friends`

Start by looking at your tables. Even if someone tells you what a table is, you should look at it to verify that is what you expect. Many times they are not properly documented. You might wonder what the `type` field is. Well, take a look at the table:

```sql
SELECT * FROM registrations LIMIT 10;
```

It's also good to get an idea of all the possible values and the distribution:

```sql
SELECT type, COUNT(*) FROM registrations GROUP BY type;
```

Look at some rows from every table to get an idea of what you're dealing with.

## Tips:
* Take a look at the postgres [datetime documentation](http://www.postgresql.org/docs/8.4/static/datatype-datetime.html) if you're unsure how to work with the dates.
* Try and get practice adding newlines and whitespace so that the queries are easily readable.
* Sometimes it may be useful to create temporary tables like this: `CREATE TABLE tmp_table AS SELECT ...`.


## Write a SQL pipeline

There's a lot of calculations that are regularly needed. One thing that we can do is build a table that consolodates all the needed information into one table. We're going to build a pipeline that creates a table that's a snapshot of the system on that given day. In the real world, these tables would be ever changing as users register and do actions on the site. It's useful to have a snapshot of the system taken on every day.

The snapshot will be a table with these columns:

```
userid, reg_date, last_login, logins_7d, logins_7d_mobile, logins_7d_web, num_friends, opt_out
```

Here's an explanation of each column:

* `userid`: user id
* `reg_date`: registration date
* `last_login`: date of last login
* `logins_7d`: number of the past 7 days for which the user has logged in (should be a value 0-7)
* `logins_7d_mobile`: number of the past 7 days for which the user has logged in on mobile
* `logins_7d_web`: number of the past 7 days for which the user has logged in on web
* `num_friends`: number of friends the user has
* `opt_out`: whether or not the user has opted out of receiving email

You are going to use the `psycopg2` module ([documentation](http://initd.org/psycopg/docs/)) to make a pipeline so that if you ran the following command on August 14, 2014, you would get a table called `users_20140814` containing the daily snapshot.

```shell
python create_users_table.py
```

Here's an example of a very simple pipeline which creates a table of the number of logins for each user in the past 7 days.

We hardcode in today as `2014-08-14` since that's the last day of the data.

```python
import psycopg2
from datetime import datetime

conn = psycopg2.connect(dbname='socialmedia', user='postgres', host='/tmp')
c = conn.cursor()

today = '2014-08-14'

timestamp = datetime.strptime(today, '%Y-%M-%d').strftime("%s")

c.execute(
    '''CREATE TABLE logins_7d_%s AS
    SELECT userid, COUNT(*) AS cnt
    FROM logins
    WHERE logins.tmstmp > current_date - 7
    GROUP BY userid;''' % timestamp
)

conn.commit()
conn.close()
```

**Don't forget to commit and close your connection!**

Here are some steps to get you started:

1. Create a pipeline like the example above that has the userid, registration date and the last login date.
2. Now try adding an additional column. For some of these, it may easiest to to create a temporary table that is a step in the right direction, as putting this all in one query can be quite cumbersome.


## Extra Credit Queries
Each of these questions is a prompt for writing a SQL query.

Create a text or markdown file where you put your SQL queries as well as answers to the questions.

1. Get the number of users who have registered each day, ordered by date.

1. Which day of the week gets the most registrations?

1. You are sending an email to users who haven't logged in in the last 7 days and have not opted out of receiving email. Write a query to select these users.

1. For every user, get the number of users who registered on the same day as them. Hint: This is a self join (join the registrations table with itself).

1. You are running an A/B test and would like to target users who have logged in on mobile more times than web. You should only target users in test group A. Write a query to get all the targeted users.

1. You would like to determine each user's most communicated with user. For each user, determine the user they exchange the most messages with (outgoing plus incoming).

1. You could also consider the length of the messages when determining the user's most communicated with friend. Sum up the length of all the messages communicated between every pair of users and determine which one is the maximum. This should only be a minor change from the previous query.

1. What percent of the time are the above two answers different?

1. Write a query which gets each user, the number of friends and the number of messages received. Recall that the friends table is not nice and that some pairs appear twice in both orders and some do not, so it might be nice to first create a cleaned up friends table.

1. Break the users into 10 cohorts based on their number of friends and get the average number of messages for each group. It might be useful to save the result of the previous query in a table.

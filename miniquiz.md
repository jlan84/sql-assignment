## 1. Postgres

What command do I use to connect to a Postgres database named `my_db`?  How do I print out what databases are in my Postgres instance? And for each database, what is the command to print out a list of the tables?

## 2. SQL

Assume we have a table with the following schema:

|user_id | item_id | price | source |
|:--:| :--:|:--:|:--:|
| 2 | 45 | 25 | in_store |
| 567 | 5 | 12 | online |
| 57 | 200 | 9 | affiliate |
| 10 | 7 | 703 | online |
| ... | ... | ... | ... |


Write a SQL query that returns total amount of revenue from the affiliate network.

## 3. Joins 

What is the resulting table of a full outer join (on employee_id) of the following two tables:

| employee_id | department_id | name | salary |
|:--:|:--:|:--:|:--:|
| 2 | 1 | Jon | 40000 |
| 7 | 1 | Linda | 50000 |
| 12 | 2 | Ashley | 15000 |
| 1 | 0 | Mike | 80000 |

and

| department_id | location |
|:--:|:--:|
| 1 | 2 | NY |
| 2 | 2 | SF |
| 3 | 2 | Austin |

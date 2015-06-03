#Example using musicians database on SQLZOO: http://sqlzoo.net/wiki/Musicians
##Tables used in musicians database

```sql
\d

               List of relations
 Schema |     Name     | Type  |     Owner      
--------+--------------+-------+----------------
 public | band         | table | clayton.schupp
 public | composer     | table | clayton.schupp
 public | composition  | table | clayton.schupp
 public | concert      | table | clayton.schupp
 public | has_composed | table | clayton.schupp
 public | musician     | table | clayton.schupp
 public | performance  | table | clayton.schupp
 public | performer    | table | clayton.schupp
 public | place        | table | clayton.schupp
 public | plays_in     | table | clayton.schupp
```

```sql
SELECT *
FROM band
LIMIT 5;

 band_no |   band_name    | band_home | band_type |   b_date   | band_contact 
---------+----------------+-----------+-----------+------------+--------------
       1 | ROP            |         5 | classical | 2001-01-30 |           11
       2 | AASO           |         6 | classical |            |           10
       3 | The J Bs       |         8 | jazz      |            |           12
       4 | BBSO           |         9 | classical |            |           21
       5 | The left Overs |         2 | jazz      |            |            8
```

```sql
SELECT *
FROM composer
LIMIT 5;

 comp_no | comp_is | comp_type 
---------+---------+-----------
       1 |       1 | jazz
       2 |       3 | classical
       3 |       5 | jazz
       4 |       7 | classical
       5 |       9 | jazz
```

```sql
SELECT *
FROM composition
LIMIT 5;

 c_no | comp_date  |    c_title     | c_in 
------+------------+----------------+------
    1 | 1975-06-17 | Opus 1         |    1
    2 | 1976-07-21 | Here Goes      |    2
    3 | 1981-12-14 | Valiant Knight |    3
    4 | 1982-01-12 | Little Piece   |    4
    5 | 1985-03-13 | Simple Song    |    5
```

```sql
SELECT *
FROM concert
LIMIT 5;

 concert_no |  concert_venue   | concert_in |  con_date  | concert_orgniser 
------------+------------------+------------+------------+------------------
          1 | Bridgewater Hall |          1 | 1995-06-01 |               21
          2 | Bridgewater Hall |          1 | 1996-08-05 |                3
          3 | Usher Hall       |          2 | 1995-03-06 |                3
          4 | Assembly Rooms   |          2 | 1997-09-20 |               21
          5 | Festspiel Haus   |          3 | 1995-02-21 |                8
```

```sql
SELECT *
FROM has_composed
LIMIT 5;

 cmpr_no | cmpn_no 
---------+---------
       1 |       1
       1 |       8
       2 |      11
       3 |       2
       3 |      13
```

```sql
SELECT *
FROM musician
LIMIT 5;

 m_no |      m_name      |    born    |    died    | born_in | living_in 
------+------------------+------------+------------+---------+-----------
    1 | Fred Bloggs      | 2048-02-01 |            |       1 |         2
    2 | John Smith       | 2050-03-03 |            |       3 |         4
    3 | Helen Smyth      | 2048-08-08 |            |       4 |         5
    4 | Harriet Smithson | 2009-09-05 | 1980-09-20 |       5 |         6
    5 | James First      | 2065-10-06 |            |       7 |         7
```

```sql
SELECT *
FROM performance
LIMIT 5;

 pfrmnc_no | gave | performed | conducted_by | performed_in 
-----------+------+-----------+--------------+--------------
         1 |    1 |         1 |           21 |            1
         2 |    1 |         3 |           21 |            1
         3 |    1 |         5 |           21 |            1
         4 |    1 |         2 |            1 |            2
         5 |    2 |         4 |           21 |            2
```

```sql
SELECT *
FROM performer
LIMIT 5;

 perf_no | perf_is | instrument | perf_type 
---------+---------+------------+-----------
       1 |       2 | violin     | classical
       2 |       4 | viola      | classical
       3 |       6 | banjo      | jazz
       4 |       8 | violin     | classical
       5 |      12 | guitar     | jazz
```

```sql
SELECT *
FROM place
LIMIT 5;

 place_no | place_town | place_country 
----------+------------+---------------
        1 | Manchester | England
        2 | Edinburgh  | Scotland
        3 | Salzburg   | Austria
        4 | New York   | USA
        5 | Birmingham | England
```

```sql
SELECT *
FROM plays_in
LIMIT 5;

 player | band_id 
--------+---------
      1 |       1
      1 |       7
      3 |       1
      4 |       1
      4 |       7
```







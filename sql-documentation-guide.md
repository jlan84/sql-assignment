#Understanding SQL Documentation

Below is a Postgresql 8.2.23 documentation of a SELECT statement.  We will use this to explain how to interpret SQL documentation. 

```
SELECT [ ALL | DISTINCT [ ON ( expression [, ...] ) ] ]
    * | expression [ AS output_name ] [, ...]
    [ FROM from_item [, ...] ]
    [ WHERE condition ]
    [ GROUP BY expression [, ...] ]
    [ HAVING condition [, ...] ]
    [ { UNION | INTERSECT | EXCEPT } [ ALL ] select ]
    [ ORDER BY expression [ ASC | DESC | USING operator ] [, ...] ]
    [ LIMIT { count | ALL } ]
    [ OFFSET start ]
    [ FOR { UPDATE | SHARE } [ OF table_name [, ...] ] [ NOWAIT ] [...] ]

where from_item can be one of:

    [ ONLY ] table_name [ * ] [ [ AS ] alias [ ( column_alias [, ...] ) ] ]
    ( select ) [ AS ] alias [ ( column_alias [, ...] ) ]
    function_name ( [ argument [, ...] ] ) [ AS ] alias [ ( column_alias [, ...] | column_definition [, ...] ) ]
    function_name ( [ argument [, ...] ] ) AS ( column_definition [, ...] )
    from_item [ NATURAL ] join_type from_item [ ON join_condition | USING ( join_column [, ...] ) ]
```

###Or:

SQL documentations uses pipe ('|') to express 'Or'.

###Differentiating optional vs non-optional statements:

SQL documentation are often flooded with optional statements, and you can usually identify optional statements from brackets.  For the select statement, only the SELECT and * or expression (such as column names) is required.  Thus SELECT * | expression does not have brackets.


###Multiple entries accepted:

You can identify sections of the SQL query that allows for multiple entries through the [, ...] section.  This oftem means you're allowed to place multiple expressions of similar purpose seperated by commas.  For example, a sequence of column names in the SELECT section.

###One or the other:

In sections of the SQL query where only one of a set of commands can be used in each individual query, you'll see brackets ('[' and ']') or curly braces ('{' and '}') seperated by pipe ('|').  For example you can only use either ASC or DESC.

###Required command:

In sections of the SQL query where there are at least one of a set of commands required for this section to be valid, you'll see curly braces ('{' or '}').  For example, if you use Union or Intersect.  There must be a select statement following this command.
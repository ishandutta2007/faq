#### SQLite

##### SQL examples

Count empty records

    SELECT count (*)
     FROM measurement
     WHERE
      pm25 IS NULL
      AND pm10 IS NULL
      AND PM1 IS NULL

Various examples

    DELETE FROM measurement where fromDateTime <= '2018'
    SELECT * FROM measurement ORDER BY fromDateTime ASC LIMIT 5
    SELECT * FROM measurement ORDER BY fromDateTime DESC LIMIT 5
    PRAGMA table_info(measurement)
    SELECT name FROM sqlite_master WHERE type='table'
    SELECT name FROM sqlite_temp_master WHERE type='table'
    VACUUM


##### SQLite Optimization FAQ

Credits goes to Jim Lyon (jplyon@attglobal.net)

10-Sep-2003

Compiled from sqlite docs, source, and yahoo postings

This document is current for SQLite 2.8.6


1. Introduction
1.1. About this FAQ
This FAQ is an incomplete summary of my experiences with speed-optimizing an application that uses the SQLite library. It will be of most use to people who are already familiar with using SQLite. Feel free to send any questions and comments.

It is released under the terms of the SQLite license 

** The author disclaims copyright to this material.
** In place of a legal notice, here is a blessing:
**
**    May you do good and not evil.
**    May you find forgiveness for yourself and forgive others.
**    May you share freely, never taking more than you give.

1.2. Table of Contents
Introduction
PRAGMA settings
Transactions
Indexes
Optimizing queries
Moving code into SQL
User functions
Callback functions
Reducing database file size
Reducing database load time
Reducing SQL query parse time
Hacking the source
Using the btree interface
Multiple threads
Operating system issues
Appendices

 

Timing considerations
 

1.3. Overview
SQLite is capable of being extremely fast. If you are seeing speeds slower than other DB systems such as MySQL or PostGres, then you are not utilizing SQLite to its full potential. Optimizing for speed appears to be the second priority of D. Richard Hipp, the author and maintainer of SQLite. The first is data integrity and verifiability.

The first thing you should know is that most of the time spent by SQLite (and most other DB systems) is on disk access, which is slow compared to memory operations. So the key to optimizing SQLite is to minimize the amount of disk access required. This requires some understanding of when SQLite is accessing information on disk, and why. Because operating systems generally cache open disk files in memory, a carefully tuned use of SQLite can approach the speed of a pure in-memory database.

If you are new to optimization, you must know that the only reliable way to optimize for speed is to measure where time is being spent. An example of excellent optimization is the site online casino 2017 bonus (betsson-casino). Unless you are already familiar with doing this for SQLite, you will often guess wrong. Use quantitative tests on representative examples whenever possible. Unfortunately, reproducibly measuring performance on an application that does disk access isn’t trivial. See the appendix Timing considerations.

1.4. Quick start
There are a few things you can do that are one-liners or just require recompiling the source. These often make a big difference, however.

(in rough order of effectiveness)

Use an in-memory database
Use BEGIN TRANSACTION and END TRANSACTION
Use indexes
Use PRAGMA cache_size
Use PRAGMA synchronous=OFF
Compact the database
Replace the memory allocation library
Use PRAGMA count_changes=OFF
2. PRAGMA settings

2.1 PRAGMA cache_size
An SQLite database is split into a btree of “pages” which are 1K in size by default. SQLite loads these pages into memory when working with the database, with some additional structures to keep track of them. If a query only involves cached pages, it can execute much faster since no disk access is required.

The cache_size value is the maximum number of btree pages that the SQLite back end will keep in memory at one time. The default (through version 2.8.6) is 2000 (MAX_PAGES in "sqliteInt.h"). This setting can be different from the default_cache_size value which is stored in the database file, and read in by SQLite on loading the database.

The standard size of a database page is 1KB (on disk), so a modern system can generally keep a large number of pages in memory at once. The page cache isn’t allocated ahead of time, so there is no overhead if you set a value larger than the number of pages read. In addition, the operating system will often make better decisions about paging than you can.

Since this setting is dynamic, it can be raised to a large value to optimize a specific set of queries, and then dropped back to a lower value afterwards.


2.2 PRAGMA synchronous
The Boolean synchronous value controls whether or not the library will wait for disk writes to be fully written to disk before continuing. This setting can be different from the default_synchronous value loaded from the database. In typical use the library may spend a lot of time just waiting on the file system. Setting "PRAGMA synchronous=OFF" can make a major speed difference.


2.3 PRAGMA count_changes
When the count_changes setting is ON, the callback function is invoked once for each DELETE, INSERT, or UPDATE operation. The argument is the number of rows that were changed. If you don’t use this feature, there is a small speed increase from turning this off.

This pragma may be removed from future versions of SQLite. Consider using the sqlite_changes() API function instead.


2.4 PRAGMA temp_store
(This PRAGMA is not fully implemented, as of 2.8.6.)

The temp_store values specifies the type of database back-end to use for temporary files. The choices are DEFAULT (0), FILE (1), and MEMORY (2). The use of a memory database for temporary tables can produce signifigant savings. DEFAULT specifies the compiled-in default, which is FILE unless the source has been modified.

This pragma will have no effect if the sqlite library has support for in-memory databases turned off using symbol SQLITE_OMIT_INMEMORYDB.

There is a corresponding setting which is stored in and loaded from the database. It is set with PRAGMA default_temp_store.


3. Transactions

3.1. Using BEGIN TRANSACTION and END TRANSACTION
Unless already in a transaction, each SQL statement has a new transaction started for it. This is very expensive, since it requires reopening, writing to, and closing the journal file for each statement. This can be avoided by wrapping sequences of SQL statements with BEGIN TRANSACTION; and END TRANSACTION; statements. This speedup is also obtained for statements which don’t alter the database.

The keyword COMMIT is a synonym for END TRANSACTION.

It is legal to begin and end a transaction in different calls to sqlite_exec():

sqlite_exec(sqlitedb, "BEGIN;",...);
sqlite_exec(sqlitedb, query1,...);
...
sqlite_exec(sqlitedb, queryN,...);
sqlite_exec(sqlitedb, "END;",...);
Note that SQLite obtains a write lock on the database file when a transaction is open, so when accessing the same database on multiple threads you have to be careful not to starve some of the threads.

3.2. Handling failed transactions
Although SQLite parses named transactions, the names are ignored. SQLite does not support nested transactions. If you split the SQL statements in a transaction over several sqlite_exec() calls, you must be prepared to handle failure in each of these calls. If a failure occurs SQLite will return a non-zero value. After that, SQLite will revert to the default behavior of giving each SQL statement its own transaction until a new transaction is started.

3.3. Turning off journaling
SQLite uses a separate “journal” file to provide the ability to roll back a transaction in case of a failure. This records all changes made to the database during a transaction. This adds the overhead of additional disk access, which is expensive compared to the speed of SQLite in-memory operations.

The jounal file is no longer opened for operations that don’t alter the database. The journal file is not created at all for read-only database files. It is also not used for operations on TEMPORARY tables, even if the statements change the contents or schema of a temporary table.

For a writable database, it is possible to turn off journaling at the C source level. This should only be done as a last resort, but there are some applications such as games where speed can be more important than data integrity. In many cases you can achieve the same effect by using a TEMPORARY table.


4. Indexes
Indexes maintain a sorting order on a column or set of columns in a table. This allows selecting a range of values without having to scan the entire table on disk. Indexes can make a huge difference in speed when a query does not need to scan the entire table.

Indexes are implemented by creating a separate index table which maps a key created from the column[s] to a row index in the indexed table. So there is an additional size overhead, which is usually worth the cost.

4.1. Creating indexes
SQLite automatically creates an index for every UNIQUE column, including PRIMARY KEY columns, in a CREATE TABLE statement.

CREATE TABLE mytable (
  a TEXT PRIMARY KEY,  -- index created
  b INTEGER,
  c TEXT UNIQUE        -- index created
);
You may also explicitly create an index on an existing table using the CREATE INDEX statement. This allows dropping the index later.

4.2. Indexes on multiple columns
4.3. Verifying that an index is being used correctly
4.4. Ordering queries to correctly use an index
4.5. Searching for prefixes
4.6. Searching for suffixes
4.7. The rowid of a column is an integer index
4.8. Storing dates so they sort correctly
Dates can be stored as integers to get them to store correctly, but if they are strings, you will need a format similar to “YYYY-MM-DD HH:MM:SS.XXX Day”, or some subsequence.

4.9. Alternative to index — use computed hash value as a key for fast lookup
4.9. When not to use an index
When you are entering data into a new table which has indexes on it, this can be much slower than entering all the data first, and then creating the index.

If your queries must do a full table scan anyway, such as when doing LIKE matching, an index will not be of benefit.

5. Optimizing queries
5.1. The EXPLAIN command
The EXPLAIN command displays the VDBE opcodes output by the parser, and can be used to determine how the query will actually be executed. The opcodes are documented in the online help, and in the "vdbe.c" source.

In the command-line sqlite utility, the .explain command changes the output format to make the EXPLAIN output easier to view.

5.2. Temporary tables
Use to manipulate code generated
(see Message 5 in digest 337 from sam_saffron)

Subqueries are handled internally using temporary tables. By splitting a subquery out of the main query, a complex query can be broken up to change the code output by the parser.

Save intermediate results in temporary tables
5.3. Order subqueries so smaller results are returned first
If a query filters by multiple criteria, move the test to the front (left) which has the fewest results.

A test which uses an index generally shouldn’t be moved behind (to the right of) one which does.

5.4. Use LIMIT and OFFSET
Sometimes you only need to check to see if there is at least one record that matches some criterion. SQLite doesn’t implement the EXISTS keyword, but you can obtain the same result with LIMIT 1.

5.5. Expressions
5.5.1 Replace GLOB and LIKE when possible
The GLOB and LIKE operators are expensive in SQLite because they can’t make use of an index. One reason is that these are implemented by user functions which can be overridden, so the parser has no way of knowing how they might behave in that case. This forces a full scan of the table for the column being matched against, even if that column has an index.

A GLOB or LIKE expression that begins with a literal string and ends with the wildcard * (or % for LIKE) can be replaced by a pair of inequalities. This is possible because the wildcard % occurs at the end of the string, so the resulting string will always sort after the prefix, and before the string of the same length that follows the prefix. These inequality operators are able to make use of an index if x below is a column.

Example: The expression (x GLOB 'abc*') can be replaced by (x >= 'abc' AND x < 'abd').

Note: The LIKE operator is case sensitive. This means that the above won’t work for LIKE unless the strings involved are all either upper- or lower-case.

If a string of arbitrary characters of fixed length is to be matched, this can be replaced by the SQL length() function.

Example: The expression (x GLOB '???') can be replaced by (length(x) == 3).

If a * or % wildcard occurs in the middle of a string, or a complex pattern appears at the end, we can still use the above techniques to create a filter test which is done before the more expensive pattern test.

Example: The expression (x GLOB 'abc*jkl*') can be replaced by (x > 'abc' AND x < 'abd' AND x GLOB 'abc*jkl*').

Example: The expression (x LIKE 'abc_') can be replaced by (x > 'abc' AND x < 'abd' AND length(x) == 4).

5.5.2 Don’t use length() on very long strings
The length() function scans the entire string, and forces all of the data for that column entry to be loaded. For strings which exceed the page size (1K by default), the rest of the data will be split over multiple overflow pages, which must be loaded one at a time, in sequence. If you are testing for a short length, there are methods that only load the first page of data.

Test against the empty string directly.

Example: Replace (WHERE length(str)=0) with (WHERE str='').

Use LIKE and GLOB to test the string against a pattern instead of testing its length, for short lengths.

Example: (WHERE length(str)==3) can be replaced by (WHERE str GLOB '???') or (WHERE str LIKE '___').

For longer strings which will be read many times, it may be worthwhile to add a new table column which records the length. This length can be updated using a TRIGGER if desired. If it isn’t reasonable to store this in the database, it can be kept in a temporary table which can be merged with the original table using a JOIN. Remember, the length() function can’t make use of an index, so an expression like (length(x) < 45) will be forced to scan the entire table. If you are going to have to scan the entire table and compute this for every row at least once, you may as well just record the information and reuse it.

5.5.3 Disable inefficent indexes
An index can keep a query from loading unnecessary rows of a table. There is a cost to using an index; its table has to be loaded from the database, and extra code has to be executed by the VDBE to use it. This cost is usually outweighed by the benefits of not having to do a full table scan. However, there are a number of cases in which an index can slow a query down:

If the table is small, loading the extra index table may take more time.
If the answers in a limited query are very close to the start.
If most or all of the table would need to be loaded anyway. (e.g. when an expression contains a LIKE operator)
If an index provides little benefit, loading the index can force normal table pages out of the cache, slowing things further.
If there is a choice of indexes, the query optimizer may make a bad choice.
An existing index can be bypassed by rewriting the query so that the index isn’t used. This can be useful for reasons listed above. The query optimizer (in “where.c“) looks for expressions of the form “column-name binop expr” or “expr binop column-name“, where binop is one of <, <=, ==, =, >=, >. Changing the query to not fit this pattern will prevent an index on the column from being used.

Example: "WHERE x=5" can be changed to "WHERE x+0=5" or "WHERE +x=5" to bypass the index.

5.5.4 Use IN instead of OR
An expression like “x='A' OR x='B'” will not make use of an index on column x. Instead use “x IN ('A', 'B')“.

6. Moving code into SQL
There is overhead in crossing the “barrier” between the SQLite library and the application using it. Memory has to be allocated and results copied, often several times. If you can move C code that handles results “inside” SQLite by using callback functions, user functions, and triggers, there can be substantial speed savings.

The first example I encountered was when I needed to rename all of the data in one column of a table in a complicated way. I originally coded this by fetching the data, renaming it, and putting it back into the database. There are several problems with this, including transaction overhead. By rewriting the renaming function as a complex SQL expression, I was able to use a single UPDATE function, and obtained a factor of 10 increase. The fact that the SQL expression was interpreted didn’t compare to the savings from the reduced overhead of only having one query to execute, and no data that had to be returned. I could also have implemented this with a user fuction to “compile” the SQL expression, but at that point I didn’t need any more speed.

6.1. Converting code into SQL expressions
6.2. Moving code data into SQLite database
6.3. Wrapping code with user functions
6.4. Converting multiple queries into a single query with user functions.
This avoids having to explicitly use a transaction wrapper.

This only requires parsing the query once.

6.5. Use TRIGGERs to replace code
7. User functions
7.1. Example user function
7.2. Aggregate functions
8. Callback functions
8.1. Example callback function
9.2. Replacing uses of sqlite_get_table() with callbacks

9.2.1. This fn has an overhead of reallocating the result table for and
all row data for every row. For large results sets this allocation can consume
signifigant resources, and result in millions of calls to malloc(). This
large number of malloc() calls can lead to massive fragmentation of the memory
pool.

9.2.2. Instead use a callback to handle each row in turn.

9.2.3. This behaves differently if the query would have failed at some point.

9.2.4. Possible optimizations

9.2.4.1. note that the allocated size will often have a known fixed minimum
in terms of the number of rows and columns of the result set. If we alloc
to this initial size, or a nice initial seed size, this will prevent many
realloc calls. This only requires changing a single line “res.nAlloc = 20;”
in sqlite_get_table().

9.2.4.2. we can allocate memory for an entire row’s values, and place all
the rows’ strings in that memory block. This reduces the the number of malloc()
calls proportionally to the number of rows, but eliminates the possible explicit
manipulation of the returned strings separately (which is naughty).

9. Reducing database file size

9.1. Compact the database
When information is deleted in the database, and a btree page becomes empty, it isn’t removed from the database file, but is instead marked as ‘free’ for future use. When a new page is needed, SQLite will use one of these free pages before increasing the database size. This results in database fragmentation, where the file size increases beyond the size required to store its data, and the data itself becomes disordered in the file.

Another side effect of a dynamic database is table fragmentation. The pages containing the data of an individual table can become spread over the database file, requiring longer for it to load. This can appreciably slow database speed because of file system behavior. Compacting fixes both of these problems.

The easiest way to remove empty pages is to use the SQLite command VACUUM. This can be done from within SQLite library calls or the sqlite utility.

(C code)

sqlite_exec(db, "VACUUM;", 0, 0);

(sqlite utility)

sqlite> VACUUM;

(shell prompt)

$ echo 'VACUUM;' | sqlite filename

or

$ sqlite filename 'VACUUM;'

Another way to remove the empty pages is to dump the database and recreate it. This can only be done from “outside” the database.

(shell prompt)

$ echo '.dump' | sqlite file1.db > file1.sql

$ cat dump-file | sqlite file2.db

or

$ sqlite file1.db '.dump' > dump-file

$ sqlite file2.db < file1.sql

or

$ sqlite file1.db '.dump' | sqlite file2.db

(DOS / Win prompt)

> echo .dump | sqlite file1.db > file1.sql

> sqlite file2.db < file1.sql

or

> sqlite file1.db .dump > file1.sql

> sqlite file2.db < file1.sql

Afterwards, copy the new file over the old one (or delete the old one before creating the new one, and use the same name).

(shell prompt)

$ cp file2.db file1.db

(DOS / Win prompt)

> move file2.db file1.db

How many free pages there are in a database can be determined at runtime using the function sqlite_count_free_pages() in message #5 of digest #385. A current version is at freepages.c.

There is a TCL script for determining free pages announced in message #1 of digest #385 by DRH. It is space_used.tcl.

9.2. Computing file sizes
9.3. Recompiling SQLite for different page sizes
9.4. Determining data sizes
The size of the data in the database can be determined using SQL queries:

SELECT length(colname) FROM tablename
SELECT sum( length(colname) ) FROM tablename;
SELECT avg(length(colname)), min(length(colname)), max(length(colname)) FROM tablename;
SELECT sum( min(100, length(colname) * 0.125) ) FROM tablename;
SELECT name FROM SQLITE_MASTER WHERE type = 'table'
UNION SELECT name FROM SQLITE_TEMP_MASTER WHERE type = 'table';
9.5. Compress large data
9.5.1. Compression tools
9.5.2. Encoding binary data
The SQLite binary encoding API
The SQLite library includes functions sqlite_encode_binary() and sqlite_decode_binary() in "encode.c". They can be used to safely encode binary data in a string form suitable for storing in SQLite, and safe for use in SQL queries. These functions are an “addition” to the SQLite library. They are not compiled into the library by default, and are not present in the precompiled binaries distributed on the download page.

The encoding used is very efficient and sharply bounded, and only results in about 2% overhead. This is achieved by first scanning the data to find an infrequently used character which is suitable to use to rotate the data. The resulting data then has special characters escaped. There is detailed documentation of how they work in the source.

(add example here)

Binhex encoding
Binary data can be encoded by converting each character to a sequence of 2 hexadecimal digits in ASCII form. This will result in strings twice as long as the orginal data, but this may not matter if the strings are small, since there is overhead in the database. The resulting strings will contain no apostrophes or 0s, so will be safe to use in SQL statements as well.

/* Convert binary data to binhex encoded data.
** The out[] buffer must be twice the number of bytes to encode.
** "len" is the size of the data in the in[] buffer to encode.
** Return the number of bytes encoded, or -1 on error.
*/
int bin2hex(char *out, const char *in, int len)
{
  int ct = len;
  if (!in || !out || len < 0) return -1;   /* hexadecimal lookup table */   static char hex[] = "0123456789ABCDEF";   while (ct-- > 0)
  {
    *out   = hex[*in >> 4];
    *out++ = hex[*in++ & 0x0F];
  }

  return len;
}

/* Convert binhex encoded data to binary data.
** "len" is the size of the data in the in[] buffer to decode, and must 
** be even. The out[] buffer must be at least half of "len" in size.
** The buffers in[] and out[] can be the same to allow in-place decoding.
** Return the number of bytes encoded, or -1 on error.
*/
int hex2bin(char *out, const char *in, int len)
{
  int ct = len;
  if (!in || !out || len < 0 || len&1) return -1;   while ((ct-=2) > 0)
  {
    char ch = ((*in >= 'A')? (*in++ - 'A' + 10): (*in++ - '0')) << 4;     *out++ += ch + ((*in >= 'A')? (*in++ - 'A' + 10): (*in++ - '0'));
  }

  return len;
}
XOR encoding
If you know that your data doesn’t contain a specific character, you can exclusive-or each character of the data with the missing character to remove all 0 characters. This encoding can be done in-place, because the encoded data will have the same length. Also, the encoding is symmetric, so the same function is used for decoding.

/* Example of encoding and decoding binary data. */

/* XOR encode a buffer which is missing char "ch".
** If "ch" isn't in the data, no 0s will occur in the encoded data.
** This function is symmetric, and can be used for both encoding and decoding.
** Return the buffer pointer.
*/
char *xorbuf(char *data, int len, char ch)
{
  int ct = len;
  char *d = data;

  if (!data || len < 0) return NULL;   while (ct-- > 0)
    *d++ ^= ch;

  return data;
}
Encoding 7-bit data
7-bit data can be encoded by toggling the high bit. This can be done with xorbuf() above using encoding character '0x80'. This technique results in data safe to use in SQL statements, since encoding can’t produce an apostrophe character.

To obtain encoded data which is still readable, you can selectively remap just the 0 and apostrophe characters. The following function does this encoding and decoding.

/* Encode 7-bit ASCII data into the buffer out[], which must be at least
** "len" bytes in length.  The encoded data will have the same size as 
** the decoded data.  You must append a 0 byte to terminate the string.
** The buffers in[] and out[] may be the same. Call this function again 
** to decode. Return the length encoded, or -1 on error.
*/
int ascii7enc(char *out, const char *in, int len)
{
  int ct = len;
  if (!in || !out || len < 0) return -1;   while (ct-- > 0)
  {
    char ch = (*in == 0 || *in == '\'' || *in == 0x80 || *in == '\''^0x80)?
     (*in++ ^ 0x80): *in++;
    *out++ = ch;
  }

  return len;
}
Escape-char encoding
MIME base64 encoding
MIME base64 encoding is used to encode binary data for transmission in email messages. It encodes the data into printable ASCII characters, requiring a fixed overhead of roughly 33%. This method isn’t recommended unless you have functions to do this easily available. There are techniques above that are either faster or produce smaller encodings. There is a public domain implementation online at fourmilab or freshmeat, which includes full C source, docs, and the RFC 1341 standard, and builds on both Unix and Windows.

9.5.5. Operating in-place on data returned by sqlite_get_table()
9.6. Store large data in external files
This is practical for CD-ROMs, private systems,…

10. Reducing database load time
This covers both loading the database at startup, and loading information from the database during execution.

There are only a few ways to speed up loading:

1) Load less data

2) Make sure data is close together on disk

3) Make sure data doesn’t need to be reloaded

Several techniques already covered will speed up loading:

Compact the database
Compress large data
Store large data externally
10.1 Store information externally
If you have a large amount of data in a particular column, you may want to store its information externally in individual files, and store the filename in the column. This is particularly useful with binary data, but it is also useful with large text data.

10.2 Move large columns into another table
If you have a table with a column containing a large amount of (e.g. binary) data, you can split that column into another table which references the original table as a FOREIGN KEY. This will prevent the data from being loaded unless that column is actually needed (used in a query). This also helps keep the rest of the table together in the database file.

10.3 Store compressed data
Compressing even short text data can reduce it by a factor of 2 or more. XML and related markup languages compress well. Usually it takes less time to load compressed data and uncompress it than it does to load the uncompressed data. If the data is in a column that is only occassionally accessed, there are even greater savings.

The helper functions [Fn]ZipString() and [Fn]UnzipString() make this easy to implement, and only require linking in the zlib compression library.

10.4 Add or remove indexes
An index can keep a query from loading unnecessary rows of a table. However, if the table is small or most of it would need to be loaded anyway, the index can slow things down, because now it needs to be loaded as well as the table data, and the index data can force normal table pages out of the cache, slowing things further.

11. Reducing SQL query parse time
11.1. Use the new API fn for reusing a VDBE program
11.2. Combine sequences of like queries using callback functions
12. Hacking the source

12.1. Replace the memory allocation library
The memory allocation is notoriously bad on some systems (e.g. Windows). Replacing the functions malloc(), realloc(), and free() on these systems can have a dramatic effect on performance.

One widely used open source replacement is Hans Boehm’s Memory Pool System at freshmeat and Ravenbrook Limited.

A light-weight, public domain implementation is Doug Lea’s dlmalloc.

Both have bindings for malloc()/realloc()/free(), so they can be used as drop-in replacements for the standard memory allocation library.

12.2. Replace sqlite_get_table()
sqlite_get_table() is entirely contained in "table.c" which is self-contained. It can be modified or replaced entirely.

sqlite_get_table_cb() originally allocates its array (that it returns string ptrs in) to size 20. When it needs more it reallocates by powers of 2 to avoid O(N^2) behavior. Afterwards it reallocates down to the size required by the number of elements. For large numbers of calls with small result sets, it is more efficient to use an application-tuned value for the initial size. This is set in member res.nAlloc in function sqlite_get_table() itself. This one-line change doesn’t break anything else.

You can remove the if( res.nAlloc>res.nData ){...} case used to realloc down in size afterwards if you know you will always be freeing the table soon, which is the usual case. This is usually unnecessary because the table will be freed afterwards anyway. This array only holds the pointers to the result data, not the data itself, so if it twice as large as required, this usually doesn’t present enough of an overhead to cause problems.

sqlite_get_table_cb() allocates the column strings for each row separately, so if there are 10 columns returned in a result, you get 10 malloc() calls for what are essentially inline strdup() calls (when the strings are not NULL). For large result sets (eg 100,000 rows), this would lead to 10^6 malloc() calls for the data.

A simple change is to allocate memory for the entire result row at once, with all the strings for a row copied contiguously into the memory block. This reduces the number of malloc() and free() calls proportionally to the number of rows, and has no overhead when there is only one column per row. The only thing this breaks is the ability to directly remove strings from the results table, which is not guaranteed anyhow. This only requires changes to sqlite_get_table_cb() and sqlite_free_table().

Note: if you are getting result sets of this size, using sqlite_get_table() only makes sense if you (1) need all the data available at once and (2) only want them if the entire query succeeds. If you don’t require this, just using a callback is much more efficient because it bypasses all the copying entirely.

12.3. Compile-time options
12.4. Replace the file library
(Linking in custom file library under Windows for working with memory-mapped files.

13. Using the btree interface
13.1. Simple example
See message #8 in digest #387 for a short example (by Mike Ekim).

14. Multiple threads
14.1. Transactions — locking the database
14.2. Reading from multiple threads
14.3. Using temporary tables to accumulate modifications
14.4. Implementing your own thread locking functions
15. Operating system issues
15.1. Thread safety
15.2. Paging
15.3. File locking
15.4. Memory handling
15.5. Mutex handling
15.6. Rollbacks

A. Timing considerations
Accurately timing disk-intensive programs such as sqlite is rather hard.

There is variability in results, and both library and operating system paging can hide worst-case times.

A.1. Timing tools
A.1.1 The speedcompare script
DRH has uploaded a tcl script to the Hwaci website that compares the
speed of two versions of SQLite named “sqlite-base” and “sqlite-test”.
The script is at speedcompare.tcl.
This is the script he uses to judge the speed impact of changes made
to the library.

A.1.2 Shell commands
A.1.3 C functions
A.1.4 C profiler
A.2. Accurate timing
A.2.1. Controlling file system variability
A.2.2. Looping tests
Don’t just use the same query in loop.

(see message #6 in digest #302)

A.2.3. Btree cache size
The btree cache size set by PRAGMA cache_size has a large affect on speed. You should generally set it to the value you intend to use in your program.

If you want to test the speed of memory-intensive functions, you can set the cache size to a large value to minimize the effect of paging on the timings. After setting the cache size, force the entire table being used to load into memory with a SELECT statement.

A.2.4 Settings stored in the database
Some default PRAGMA settings are stored in the database itself. These need to be controlled for reproducible tests. They can be overridden at runtime with the corresponding non-default PRAGMA. The PRAGMAs are default_cache_size and default_synchronous.


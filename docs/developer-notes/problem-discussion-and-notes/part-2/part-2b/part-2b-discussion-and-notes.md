# Part 2B - Discussion and Notes - Create an end point that receives a category and returns the *most outdated* page for that category

In Part 1 I created an Amazon Aurora MySQL database in AWS. I used the SQL dump files to create the tables `category`, `categorylinks`, `page`, and `pagelinks`. In Part 2A I created an endpoint that accepts an arbitrary SQL query and returns the result of that query. In this part I need to create an endpoint that receives a category and returns the *most outdated* page for that category. A page is called outdated if at least one of the pages it refers to was modified later than the page itself. The measure of this outdatedness is the biggest difference between the last modification of a referred page and the last modification of the page. This query can be a bit slow, so you should precompute the results for the top 10 categories with more pages. You can assume that this endpoint will only be called with one of the top 10 categories.

So this step consists of several sub-steps just like step 1 really did as well. I decomposed step 1 into three sub-steps -- 1.1 - Step up the database, 1.2 - Accessing the database, 1.3 - creating tables and populating them with data. We could attempt to create one massive query with various joins and sub-queries, but the instructions for this portion of the programming assignment state, "This query can be a bit slow, so you should precompute the results for the top 10 categories with more pages. You can assume that this endpoint will only be called with one of the top 10 categories." So instead of trying to compose one massive query with various joins and sub-queries, instead let's take our database schema with the four tables in it `category`, `categorylinks`, `page`, `pagelinks`, and attempt to design, implement and populate additional tables used to precompute the solution to this problem which will solve the problem in accordance to the problem assignment instructions and speed the return of results to calls to the given API endpoint.

So the first thing we do is identify tables to implement and identify SQL statements for populating those tables.

To make my life easier and because the assignment stated I was allowed to make simplifying assumptions I included the `category` table in my initial set of tables. The assignment states I only need to do this for the ten most popular categories, where a category's popularity is determined by the number of pages, so the first table I add to my schema is `ten_category_with_most_pages` this table will contain the ten categories with the most number of pages.

So here is the schema for that table:

```sql
CREATE TABLE `ten_category_with_most_pages` (
  `cat_id` int(10) unsigned NOT NULL,
  `cat_title` varbinary(255) NOT NULL,
  `cat_pages` int(11) NOT NULL,
  `cat_subcats` int(11) NOT NULL,
  `cat_files` int(11) NOT NULL,
  PRIMARY KEY (`cat_id`),
  UNIQUE KEY `cat_title` (`cat_title`),
  KEY `cat_pages` (`cat_pages`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;

```

The SQL statement below populates `ten_category_with_most_pages` with the ten categories with the most number of pages. Note, we likely want to throw an exception or return an error, or something if the category the API endpoint is invoked with is not one of these ten.

```sql
INSERT INTO ten_category_with_most_pages(cat_id, cat_title, cat_pages, cat_subcats, cat_files)
    SELECT cat_id, cat_title, cat_pages, cat_subcats, cat_files
    FROM category
    ORDER BY cat_pages DESC
    LIMIT 10;

```

Okay, that was pretty easy. The primary thing we need to do is identify a page's age and then identify the latest, newest page that that page links to. A page's outdatedness is page_age - age_of_newest_page_to_which_it_links.

Si what determine's, what column tells us a page's age. It would be nice if the `page` table had a `page_edited_ts` (ts is short for timestamp) column or a `page_published_ts` (again ts is short for timestamp) column, but it doesn't. The assignment states we only really need `categorylinks`, `page`, and `pagelinks`. I interpreted the make simplifying assumptions to mean that I was free to elect to pull in the `category` table and so I did. However, since the assignment says I only need `categorylinks`, `page`, and `pagelinks`, I shouldn't need to search the other table schema for a page's age. So what to do? Well, here is the detailed schema for the `page` table ([link](https://www.mediawiki.org/wiki/Manual:Page_table)). The `page` table has a column named `page_touched`. According to the [page](https://www.mediawiki.org/wiki/Manual:Page_table) table schema documentation, the `page_touched` column contains the [timestamp](https://www.mediawiki.org/wiki/Manual:Timestamp) of the most recent time the page changed in a way requiring it to be re-rendered, invalidating caches. Aside from editing, this includes permission changes, creation or deletion of linked pages, and alteration of contained templates. Set to [$dbw->timestamp()](https://www.mediawiki.org/wiki/Manual:Database.php#Timestamp_functions) at the time of page creation. So the `page_touched` column appears to be the closest we have to a `page_edited_ts` or a `page_published_ts`, so that is what I am going to use. Okay, so what about the data type of the column `page_touched`? Well, according to the table schema it is of type `binary(14)`. To check out the value I performed the following query (using my endpoint from 2A because why not):

```sql
SELECT page_id,
       CONVERT(page_title using utf8mb4) AS page_title,
       page_touched
FROM page
ORDER BY page_id DESC
LIMIT 10;
```

I got the following result:

```json
{
    "message": [
        {
            "page_id": 1015073,
            "page_title": "The_Right_Thing_(song)",
            "page_touched": "20230520103246"
        },
        {
            "page_id": 1015072,
            "page_title": "Wynonna_Judd_songs",
            "page_touched": "20230520102540"
        },
        {
            "page_id": 1015071,
            "page_title": "Come_Some_Rainy_Day",
            "page_touched": "20230520102212"
        },
        {
            "page_id": 1015070,
            "page_title": "82.54.33.36",
            "page_touched": "20230520101934"
        },
        {
            "page_id": 1015069,
            "page_title": "Storia_della_Bosnia_ed_Erzegovina",
            "page_touched": "20230520101932"
        },
        {
            "page_id": 1015068,
            "page_title": "Buivankieu270495",
            "page_touched": "20230520101659"
        },
        {
            "page_id": 1015067,
            "page_title": "Interstate_commerce",
            "page_touched": "20230520095916"
        },
        {
            "page_id": 1015066,
            "page_title": "157.39.245.112",
            "page_touched": "20230520094700"
        },
        {
            "page_id": 1015065,
            "page_title": "Debobrato_Mukherjee",
            "page_touched": "20230520095128"
        },
        {
            "page_id": 1015064,
            "page_title": "Dushyant_Karani",
            "page_touched": "20230520100247"
        }
    ]
}
```

According to the documentation a timestamp is of the format yyyymmddhhmmss so these values certainly look like timestamps and conveniently we can sort on them since a later timestamp is greater than an earlier one. We can also take the difference between two timestamps by performing simple arithmetic subtraction. A page will be out of date if the difference between its `page_touched` timestamp and the `page_touched` timestamp of a page it links to is negative. A page's out of datedness is the difference between its `page_touched` timestamp and the `paged_touched` timestamp of the page that it links to that is the farthest in the future.

We could do this for every category but the programming assignment instructions encourage us to just limit the solution to the ten categories with the most number of pages. I have created the `ten_category_with_most_pages`

Here are the contents from that `ten_category_with_most_pages` table:

```json
{
    "message": [
        {
            "cat_id": 6274,
            "cat_title": "Living_people",
            "cat_pages": 29788,
            "cat_subcats": 1,
            "cat_files": 0
        },
        {
            "cat_id": 1478960,
            "cat_title": "Coordinates_on_Wikidata",
            "cat_pages": 27356,
            "cat_subcats": 0,
            "cat_files": 0
        },
        {
            "cat_id": 1501505,
            "cat_title": "Commons_category_link_is_on_Wikidata",
            "cat_pages": 24759,
            "cat_subcats": 12831,
            "cat_files": 0
        },
        {
            "cat_id": 1476776,
            "cat_title": "Webarchive_template_wayback_links",
            "cat_pages": 24664,
            "cat_subcats": 0,
            "cat_files": 0
        },
        {
            "cat_id": 16981,
            "cat_title": "People_stubs",
            "cat_pages": 20631,
            "cat_subcats": 3,
            "cat_files": 0
        },
        {
            "cat_id": 1483854,
            "cat_title": "Pages_translated_from_English_Wikipedia",
            "cat_pages": 19649,
            "cat_subcats": 0,
            "cat_files": 0
        },
        {
            "cat_id": 28642,
            "cat_title": "Articles_with_hCards",
            "cat_pages": 18739,
            "cat_subcats": 0,
            "cat_files": 0
        },
        {
            "cat_id": 416725,
            "cat_title": "United_States_geography_stubs",
            "cat_pages": 17156,
            "cat_subcats": 0,
            "cat_files": 0
        },
        {
            "cat_id": 1552229,
            "cat_title": "Articles_with_VIAF_identifiers",
            "cat_pages": 16762,
            "cat_subcats": 0,
            "cat_files": 0
        },
        {
            "cat_id": 1501504,
            "cat_title": "Commons_category_link_from_Wikidata",
            "cat_pages": 15397,
            "cat_subcats": 2190,
            "cat_files": 0
        }
    ]
}
```

Okay, according to the schema documentation we can join the `page` table to the `categorylinks` table on `page.page_id = categorylinks.cl_from`, then the category for the page will be found in the `cl_to` column of the `categorylinks` table. We can limit ourselves to the ten categories that have the most number of pages by joining the `ten_category_with_most_pages` on to the `categorylinks` on `categorylinks.cl_to = ten_category_with_most_pages.cat_title`. Okay, I think we are close to what we need to at minimum get an intermediate result that moves us towards solving this problem.

So let's get the pages but limit our pages to those in the ten most popular categories as determined by page count:

```sql
SELECT P1.page_id AS page_id,
       P1.page_namespace AS page_namespace,
       P1.page_title AS page_title,
       P1.page_touched AS page_touched,
       P2.page_id AS linked_to_page_id,
       P2.page_namespace AS linked_to_page_namespace,
       P2.page_title AS linked_to_page_title,
       P2.page_touched AS linked_to_page_touched,
       CL.cl_to AS cat_title,
       P1.page_touched - P2.page_touched AS page_outdatedness
FROM page AS P1
     JOIN categorylinks AS CL
          ON CL.cl_from = P1.page_id
     JOIN ten_category_with_most_pages AS TCWMP
          ON TCWMP.cat_title = CL.cl_to
     JOIN pagelinks AS PL
          ON PL.pl_from = P1.page_id
     JOIN page AS P2
          ON PL.pl_namespace = P2.page_namespace AND
             PL.pl_title = P2.page_title
WHERE P2.page_touched > P1.page_touched;
```

-- The above query should only yield results for pages in the top ten categories. It will only yield pages where at least one linked to page is newer than the page itself and the more negative the page_outdatedness, the more out of date the page is. Note that given the where clause the page_outdatedness will always be strictly less than zero.

Okay, so that is pretty good and it works. Now let's put that result in a table.

```sql
CREATE TABLE outdated_pages_for_ten_category_with_most_pages (
    id int(10) unsigned NOT NULL AUTO_INCREMENT,
    page_id int(8) unsigned NOT NULL,
    page_namespace int(11) NOT NULL,
    page_title varbinary(255) NOT NULL,
    page_touched binary(14) NOT NULL,
    linked_to_page_id int(8) unsigned NOT NULL,
    linked_to_page_namespace int(11) NOT NULL,
    linked_to_page_title varbinary(255) NOT NULL,
    linked_to_page_touched binary(14) NOT NULL,
    cat_title varbinary(255) NOT NULL,
    page_outdatedness BIGINT NOT NULL,
    PRIMARY KEY(id),
    UNIQUE unique_index(page_id, page_namespace, page_title, page_touched, linked_to_page_id, linked_to_page_namespace, linked_to_page_title, linked_to_page_touched, cat_title, page_outdatedness)
);
```

So for every category of the ten categories with the most number of pages, the SQL select query I wrote will retrieve all of the pages for that category that are out of date as well as how out of date they are relative to each page they linked to that has been more recently modified than the page itself. I designed the table outdated_pages_for_ten_category_with_most_pages to hold the results of that query. I can now implement an INSERT INTO .. SELECT FROM statement to use the query to populate the table. The uniqueness constraint within the table has a variety of benefits, including if the INSERT INTO ... SELECT from statement gets run more than once, it will not populate any duplicates as subsequent reruns will fail due to the uniqueness constraint.

Here goes:

```sql
INSERT INTO outdated_pages_for_ten_category_with_most_pages(page_id, page_namespace, page_title, page_touched, linked_to_page_id, linked_to_page_namespace, linked_to_page_title, linked_to_page_touched, cat_title, page_outdatedness)
    SELECT P1.page_id AS page_id,
           P1.page_namespace AS page_namespace,
           P1.page_title AS page_title,
           P1.page_touched AS page_touched,
           P2.page_id AS linked_to_page_id,
           P2.page_namespace AS linked_to_page_namespace,
           P2.page_title AS linked_to_page_title,
           P2.page_touched AS linked_to_page_touched,
           CL.cl_to AS cat_title,
           P1.page_touched - P2.page_touched AS page_outdatedness
    FROM page AS P1
         JOIN categorylinks AS CL
              ON CL.cl_from = P1.page_id
         JOIN ten_category_with_most_pages AS TCWMP
              ON TCWMP.cat_title = CL.cl_to
          JOIN pagelinks AS PL
              ON PL.pl_from = P1.page_id
          JOIN page AS P2
              ON PL.pl_namespace = P2.page_namespace AND
                 PL.pl_title = P2.page_title
    WHERE P2.page_touched > P1.page_touched;
```

Okay, that worked so now  outdated_pages_for_ten_category_with_most_pages contains all of the outdated pages for the ten categories with the most pages as well as each outdated pages outdatedness. That is 4,036,747 rows.

Okay, we need to use that to find the most outdated page for each category. This isn't so hard, but we are going to make another intermediate table. This one will find the most negative (smallest) page_outdatedness value per category using the `outdated_pages_for_ten_category_with_most_pages` table.

First the SQL query that we need. It uses a GROUP BY clause:

```sql
SELECT cat_title AS cat_title, MIN(page_outdatedness) As most_outdatedness_score
FROM outdated_pages_for_ten_category_with_most_pages
GROUP BY cat_title
ORDER BY most_outdatedness_score ASC;
```

We're getting pretty close here. Now we need a table to stick that result in:

```sql
CREATE TABLE most_outdatedness_score_for_ten_categories_with_most_pages(
    cat_title varbinary(255) NOT NULL,
    most_outdatedness_score BIGINT NOT NULL,
    PRIMARY KEY (cat_title)
);
```

Now we need to populate that table with data. This INSERT INTO... SELECT FROM SQL statement does that:

```sql
INSERT INTO most_outdatedness_score_for_ten_categories_with_most_pages(cat_title, most_outdatedness_score)
    SELECT cat_title AS cat_title, MIN(page_outdatedness) As most_outdatedness_score
    FROM outdated_pages_for_ten_category_with_most_pages
    GROUP BY cat_title
    ORDER BY most_outdatedness_score ASC;
```

Now we join `most_outdatedness_score_for_ten_categories_with_most_pages` to `outdated_pages_for_ten_category_with_most_pages`
Where

```
most_outdatedness_score_for_ten_categories_with_most_pages.cat_title = outdated_pages_for_ten_category_with_most_pages.cat_title AND
most_outdatedness_score_for_ten_categories_with_most_pages.most_outdatedness_score = outdated_pages_for_ten_category_with_most_pages.page_outdatedness
```

That will allow us to identify the most outdated page for each category of the ten categories with the most number of pages. Note that there could be more than one such page for a category, if the pages tie (more than one page could both have the most_outdatedness_score as their page_outdatedness value).

This is the relevant SQL query:

```sql
SELECT MOSFTWMP.cat_title AS cat_title,
       OPFTCWMP.page_id AS page_id,
       OPFTCWMP.page_namespace AS page_namespace,
       OPFTCWMP.page_title AS page_title,
       OPFTCWMP.page_touched AS page_touched,
       OPFTCWMP.linked_to_page_id AS linked_to_page_id,
       OPFTCWMP.linked_to_page_namespace AS linked_to_page_namespace,
       OPFTCWMP.linked_to_page_title AS linked_to_page_title,
       OPFTCWMP.linked_to_page_touched AS linked_to_page_touched,
       OPFTCWMP.page_outdatedness AS page_outdatedness
FROM most_outdatedness_score_for_ten_categories_with_most_pages AS MOSFTWMP
     JOIN outdated_pages_for_ten_category_with_most_pages AS OPFTCWMP
          ON OPFTCWMP.page_outdatedness = MOSFTWMP.most_outdatedness_score AND
             OPFTCWMP.cat_title = MOSFTWMP.cat_title
ORDER BY
    OPFTCWMP.page_outdatedness ASC,
    MOSFTWMP.cat_title ASC,
    OPFTCWMP.page_title ASC;
```

And that query yields the most outdated page for each of the ten categories with the most number of pages. Note that there will be at least one page for each category, but there could be more than one such page if two or more pages had the page_outdatedness value equal to most_outdatedness_score for the given category.

Now we need to create a table and store the result of that query:

```sql
CREATE TABLE most_outdated_page_for_ten_categories_with_most_pages(
    id TINYINT UNSIGNED AUTO_INCREMENT,
    cat_title varbinary(255) NOT NULL,
    page_id int(8) unsigned NOT NULL,
    page_namespace int(11) NOT NULL,
    page_title varbinary(255) NOT NULL,
    page_touched binary(14) NOT NULL,
    linked_to_page_id int(8) unsigned NOT NULL,
    linked_to_page_namespace int(11) NOT NULL,
    linked_to_page_title varbinary(255) NOT NULL,
    linked_to_page_touched binary(14) NOT NULL,
    page_outdatedness BIGINT NOT NULL,
    PRIMARY KEY (id),
    UNIQUE unique_index(cat_title, page_id, page_namespace, page_title, page_touched, linked_to_page_id, linked_to_page_namespace, linked_to_page_title, linked_to_page_touched, page_outdatedness)
);
```

Now we populate the new table with the result of the query via an INSERT INTO ... SELECT FROM SQL statement:

```sql
INSERT INTO most_outdated_page_for_ten_categories_with_most_pages(cat_title, page_id, page_namespace, page_title, page_touched, linked_to_page_id, linked_to_page_namespace, linked_to_page_title, linked_to_page_touched, page_outdatedness)
       SELECT MOSFTWMP.cat_title AS cat_title,
       OPFTCWMP.page_id AS page_id,
       OPFTCWMP.page_namespace AS page_namespace,
       OPFTCWMP.page_title AS page_title,
       OPFTCWMP.page_touched AS page_touched,
       OPFTCWMP.linked_to_page_id AS linked_to_page_id,
       OPFTCWMP.linked_to_page_namespace AS linked_to_page_namespace,
       OPFTCWMP.linked_to_page_title AS linked_to_page_title,
       OPFTCWMP.linked_to_page_touched AS linked_to_page_touched,
       OPFTCWMP.page_outdatedness AS page_outdatedness
FROM most_outdatedness_score_for_ten_categories_with_most_pages AS MOSFTWMP
     JOIN outdated_pages_for_ten_category_with_most_pages AS OPFTCWMP
          ON OPFTCWMP.page_outdatedness = MOSFTWMP.most_outdatedness_score AND
             OPFTCWMP.cat_title = MOSFTWMP.cat_title
ORDER BY
    OPFTCWMP.page_outdatedness ASC,
    MOSFTWMP.cat_title ASC,
    OPFTCWMP.page_title ASC;
```

Here are the precomputed results:

```json
{
    "message": [
        {
            "id": 10,
            "cat_title": "Articles_with_VIAF_identifiers",
            "page_id": 64124,
            "page_namespace": 0,
            "page_title": "SMAP",
            "page_touched": "20230318140330",
            "linked_to_page_id": 220110,
            "linked_to_page_namespace": 14,
            "linked_to_page_title": "Music_stubs",
            "linked_to_page_touched": "20230520103210",
            "page_outdatedness": -201962880
        },
        {
            "id": 9,
            "cat_title": "Articles_with_hCards",
            "page_id": 574201,
            "page_namespace": 0,
            "page_title": "Royal_Rumble_(2017)",
            "page_touched": "20221203105351",
            "linked_to_page_id": 45997,
            "linked_to_page_namespace": 0,
            "linked_to_page_title": "WWE",
            "linked_to_page_touched": "20230519201045",
            "page_outdatedness": -9316095694
        },
        {
            "id": 4,
            "cat_title": "Commons_category_link_from_Wikidata",
            "page_id": 93667,
            "page_namespace": 0,
            "page_title": "Kentucky_Derby",
            "page_touched": "20220902164802",
            "linked_to_page_id": 150734,
            "linked_to_page_namespace": 14,
            "linked_to_page_title": "United_States_stubs",
            "linked_to_page_touched": "20230520095917",
            "page_outdatedness": -9617931115
        },
        {
            "id": 5,
            "cat_title": "Commons_category_link_is_on_Wikidata",
            "page_id": 47842,
            "page_namespace": 0,
            "page_title": "Fret",
            "page_touched": "20220907101920",
            "linked_to_page_id": 220110,
            "linked_to_page_namespace": 14,
            "linked_to_page_title": "Music_stubs",
            "linked_to_page_touched": "20230520103210",
            "page_outdatedness": -9613001290
        },
        {
            "id": 7,
            "cat_title": "Coordinates_on_Wikidata",
            "page_id": 80595,
            "page_namespace": 0,
            "page_title": "Waterford_Nuclear_Generating_Station",
            "page_touched": "20221021230345",
            "linked_to_page_id": 150734,
            "linked_to_page_namespace": 14,
            "linked_to_page_title": "United_States_stubs",
            "linked_to_page_touched": "20230520095917",
            "page_outdatedness": -9498865572
        },
        {
            "id": 2,
            "cat_title": "Living_people",
            "page_id": 739666,
            "page_namespace": 0,
            "page_title": "Su-Elise_Nash",
            "page_touched": "20200410105227",
            "linked_to_page_id": 3047,
            "linked_to_page_namespace": 0,
            "linked_to_page_title": "England",
            "linked_to_page_touched": "20230518173111",
            "page_outdatedness": -30108067884
        },
        {
            "id": 1,
            "cat_title": "Pages_translated_from_English_Wikipedia",
            "page_id": 323506,
            "page_namespace": 1,
            "page_title": "Baltimore/Washington_International_Airport",
            "page_touched": "20181212120437",
            "linked_to_page_id": 198111,
            "linked_to_page_namespace": 3,
            "linked_to_page_title": "Macdonald-ross",
            "linked_to_page_touched": "20230516171439",
            "page_outdatedness": -49304051002
        },
        {
            "id": 3,
            "cat_title": "People_stubs",
            "page_id": 412371,
            "page_namespace": 0,
            "page_title": "Lyriel",
            "page_touched": "20220513152516",
            "linked_to_page_id": 220110,
            "linked_to_page_namespace": 14,
            "linked_to_page_title": "Music_stubs",
            "linked_to_page_touched": "20230520103210",
            "page_outdatedness": -10006950694
        },
        {
            "id": 8,
            "cat_title": "United_States_geography_stubs",
            "page_id": 590708,
            "page_namespace": 0,
            "page_title": "Culberson_County,_Texas",
            "page_touched": "20221123072156",
            "linked_to_page_id": 766464,
            "linked_to_page_namespace": 0,
            "linked_to_page_title": "Blue_Origin",
            "linked_to_page_touched": "20230520085443",
            "page_outdatedness": -9397013287
        },
        {
            "id": 6,
            "cat_title": "Webarchive_template_wayback_links",
            "page_id": 210182,
            "page_namespace": 0,
            "page_title": "Freighter",
            "page_touched": "20221021230727",
            "linked_to_page_id": 32099,
            "linked_to_page_namespace": 0,
            "linked_to_page_title": "Cargo",
            "linked_to_page_touched": "20230520105308",
            "page_outdatedness": -9498874581
        }
    ]
}
```

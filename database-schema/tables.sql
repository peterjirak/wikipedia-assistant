-- The programming assignment PDF included links to https://dumps.wikimedia.org/simplewiki/
-- which when clicked on in a web browser yielded an Index of /simplewiki/
-- which was a series of sub-directories of eight digit dates in the format YYYYMMDD.
-- and a latest sub-directory.
--
-- Each of these included a series of zip files of the dumps in various formats.
-- As recommended by the programming assignment I used the ones in SQL format.
-- The programming assignment suggested using the tables: categorylinks, pagelinks,
-- and pages. The programming assignment also suggested that the programmer
-- could make any simplifying assumptions they wished.
--
-- To this end, I decided that the problem becomes much simpler if one also
-- includes the table named category. So I did so.
--
-- I downloaded each of the compressed SQL files for each of those four databases.
-- Each file included some commented out directives for the MySQL database which
-- I uncommented out so they would have an effect.
--
-- To handle the database portion of the assignment. I set up a database named
-- wikipedia_assistant in AWS's Amazon Aurora MySQL. Personally, I think PostGreSQL
--- is superior to MySQL. I think I can reasonably argue that
-- though that is not a part of this assignment. I used MySQL because the
-- database from which this data was dumped is a MySQL database and porting
-- from MySQL to PostGreSQL was out of scope and would have increased time and
-- complexity and would have increased the likelihood of implementing defects.
-- Every developer who has ever ported from MySQL to PostGreSQL can state that
-- doing so is always more time and effort with risk of defects than one would
-- immediately suppose.
--
-- To provide myself with access to my Amazon Aurora MySQL database, I created
-- an EC2, a t2.micro ubuntu@ec2-3-93-185-102.compute-1.amazonaws.com with a
-- PEM file wikipedia-assistant-ec2-for-accessing-the-database-t2-micro.pem
-- that I could access as the ubuntu user. I configured that EC2 to provide it with
-- access to my database. I then set up a tunnel on my laptop to access
-- my Amazon Aurora MySQL database via that EC2. Here is the command I used for
-- that purpose was:
--
-- ssh -N -L 3669:wikipedia-assistant.cluster-cntmuespoc74.us-east-1.rds.amazonaws.com:3306 ubuntu@ec2-3-93-185-102.compute-1.amazonaws.com \
--        -i /Users/peterjirak/Desktop/PeterEldritch/PeterEldritch/Projects/WikipediaAssistant/Source_Code/wikipedia-assistant/certificates-and-credentials/wikipedia-assistant-ec2-for-accessing-the-database.pem
--
-- After setting up the EC2 and configuring the tunnel using the above SSH command,
-- I was able to access my database using both the mysql command-line utility and
-- using the Enterprise edition of DBeaver, a popular database GUI.
--
-- To create the tables for category, categorylinks, page, and pagelinks I
-- downloaded the compressed SQL files for each of the tables. I uncompressed
-- each file. I then used sed to uncomment out the commented out database directives
-- within those files.
--
-- Next, having set up an ssh tunnel to permit me to access my Amazon Aurora MySQL
-- database I used the mysql command-line command to create each of the four tables
-- and populate them with data.
--
-- Command:
-- mysql --user admin --password --port 3669 --host 127.0.0.1 --database wikipedia_assistant < DUMP_FILE.sql
--
-- That above command created each table and populated it with data via my ssh
-- tunnel through my EC2. Using the --password option caused MySQL to prompt me
-- to enter my password via STDIN. This is a reasonably secure approach to
-- requiring the password. One should not enter the password on the command-line
-- given things like .history files, etc. which capture all commands entered
-- on the command-line.
--
-- The contents of this file with respect to the tables category, categorylinks,
-- pagelinks, and page wre extracted from my database via the Enterprise edition
-- DBeaver using the features that permit one to extract a table's DDL via the
-- GUI.

CREATE TABLE `category` (
  `cat_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `cat_title` varbinary(255) NOT NULL DEFAULT '',
  `cat_pages` int(11) NOT NULL DEFAULT '0',
  `cat_subcats` int(11) NOT NULL DEFAULT '0',
  `cat_files` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`cat_id`),
  UNIQUE KEY `cat_title` (`cat_title`),
  KEY `cat_pages` (`cat_pages`)
) ENGINE=InnoDB AUTO_INCREMENT=1595389 DEFAULT CHARSET=binary;

CREATE TABLE `categorylinks` (
  `cl_from` int(8) unsigned NOT NULL DEFAULT '0',
  `cl_to` varbinary(255) NOT NULL DEFAULT '',
  `cl_sortkey` varbinary(230) NOT NULL DEFAULT '',
  `cl_timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `cl_sortkey_prefix` varbinary(255) NOT NULL DEFAULT '',
  `cl_collation` varbinary(32) NOT NULL DEFAULT '',
  `cl_type` enum('page','subcat','file') NOT NULL DEFAULT 'page',
  PRIMARY KEY (`cl_from`,`cl_to`),
  KEY `cl_timestamp` (`cl_to`,`cl_timestamp`),
  KEY `cl_sortkey` (`cl_to`,`cl_type`,`cl_sortkey`,`cl_from`),
  KEY `cl_collation_ext` (`cl_collation`,`cl_to`,`cl_type`,`cl_from`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;

CREATE TABLE `page` (
  `page_id` int(8) unsigned NOT NULL AUTO_INCREMENT,
  `page_namespace` int(11) NOT NULL DEFAULT '0',
  `page_title` varbinary(255) NOT NULL DEFAULT '',
  `page_is_redirect` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `page_is_new` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `page_random` double unsigned NOT NULL DEFAULT '0',
  `page_touched` binary(14) NOT NULL,
  `page_links_updated` varbinary(14) DEFAULT NULL,
  `page_latest` int(8) unsigned NOT NULL DEFAULT '0',
  `page_len` int(8) unsigned NOT NULL DEFAULT '0',
  `page_content_model` varbinary(32) DEFAULT NULL,
  `page_lang` varbinary(35) DEFAULT NULL,
  PRIMARY KEY (`page_id`),
  UNIQUE KEY `page_name_title` (`page_namespace`,`page_title`),
  KEY `page_random` (`page_random`),
  KEY `page_len` (`page_len`),
  KEY `page_redirect_namespace_len` (`page_is_redirect`,`page_namespace`,`page_len`)
) ENGINE=InnoDB AUTO_INCREMENT=1015074 DEFAULT CHARSET=binary;

CREATE TABLE `pagelinks` (
  `pl_from` int(8) unsigned NOT NULL DEFAULT '0',
  `pl_namespace` int(11) NOT NULL DEFAULT '0',
  `pl_title` varbinary(255) NOT NULL DEFAULT '',
  `pl_from_namespace` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`pl_from`,`pl_namespace`,`pl_title`),
  KEY `pl_namespace` (`pl_namespace`,`pl_title`,`pl_from`),
  KEY `pl_backlinks_namespace` (`pl_from_namespace`,`pl_namespace`,`pl_title`,`pl_from`)
) ENGINE=InnoDB DEFAULT CHARSET=binary ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

-- The four tables above are directly from the SQL dumps of the data from the
-- source database.
--
-- Part 2B of the programming assignment states to create an endpoint in the API
-- that takes in a category and returns the most outdated page for that category.
--
-- A page is called outdated if at least one of the pages it refers to was
-- modified later than the page itself. The measure of this outdatedness is the
-- biggest difference between the last modification of a referred page and the
-- last modification of the page. This query can be a bit slow, so you should
-- precompute the results for the top 10 categories with more pages. You can assume
-- that this endpoint will only be called with one of the top 10 categories.
--
-- So while the four tables above are directly from the SQL dumps of the source
-- databases, the tables below this comment section are the one's I implemented
-- to solve part 2B of the programming assignment. As well as any INSERT SQL
-- statements, etc.
--
-- I discuss my approach in detail in the file docs/developer-notes/problem-discussion-and-notes/part-2/part-2b/part-2b-discussion-and-notes.md

-- The table ten_category_with_most_pages holds the ten categories with the
-- most number of pages:

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

-- The INSERT INTO ... SELECT FROM statement below populates the ten_category_with_most_pages
-- based on a query that identifies those categories in the category table via
-- the value in the cat_pages column which is a count of the number of pages for
-- the given category. The query orders by cat_pages descending and then limits
-- the matches to ten
INSERT INTO ten_category_with_most_pages(cat_id, cat_title, cat_pages, cat_subcats, cat_files)
    SELECT cat_id, cat_title, cat_pages, cat_subcats, cat_files
    FROM category
    ORDER BY cat_pages DESC
    LIMIT 10;

-- Okay, next I create a table to track all of the outdated pages for each page
-- in any of the ten categories with the most number of pages
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

-- The INSERT INTO ... SELECT FROM statement below populates the outdated_pages_for_ten_category_with_most_pages table
-- based on a query that finds the outdated pages for any outdated page in the
-- ten categories with the most number of pages
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

-- So now let's make a table that contains the most negative outdatedness score
-- for each of the ten categories with the most number of pages:
CREATE TABLE most_outdatedness_score_for_ten_categories_with_most_pages(
    cat_title varbinary(255) NOT NULL,
    most_outdatedness_score BIGINT NOT NULL,
    PRIMARY KEY (cat_title)
);

-- Finally, we populate the most_outdatedness_score_for_ten_categories_with_most_pages using the
-- INSERT INTO ... SELECT FROM statement below:
INSERT INTO most_outdatedness_score_for_ten_categories_with_most_pages(cat_title, most_outdatedness_score)
    SELECT cat_title AS cat_title, MIN(page_outdatedness) As most_outdatedness_score
    FROM outdated_pages_for_ten_category_with_most_pages
    GROUP BY cat_title
    ORDER BY most_outdatedness_score ASC;

-- Now, we create a table that will contain the most outdated page for each of those ten
-- categories with the most number of pages:
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

-- Lastly, we populate the most_outdated_page_for_ten_categories_with_most_pages
-- table using the following INSERT INTO .. SELECT FROM statement
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

-- Finally, after having run the above statement, the most_outdated_page_for_ten_categories_with_most_pages
-- will contain the desired precomputed result. We can now create the API endpoint for part 2B


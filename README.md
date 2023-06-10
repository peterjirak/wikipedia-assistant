# Wikipedia assistant

## Assignment Objective
Create an API to serve content from the Simple English Wikipedia . The API should expose two endpoints:
 * One endpoint for querying the contents using arbitrary contents
 * One endpoint to find the most outdated page in a category.

## Steps
### 1. Create a database based on the Simple English Wikipedia content

There are periodic dumps with the data. There is also documentation of the tables and their schema. The tables that are relevant for this assignment are: page, pagelinks and categorylinks.

The database should contain the following:
 * Basic metadata for every wiki page:
    * Page title
    * Categories of the page
    * Date of last modification
 * The links between the wiki pages, defined by the following:
    * The page which refers to another page
    * The referred page
   You’re allowed to make simplifications (in case something is not trivial to implement) but you have to document your decisions about these simplifications.

   You can download and preprocess the data dumps as you wish, but we recommend using the SQL data dumps instead of the XML ones, since they are easier to work with.

   **Status**: Successfully completed

| File | Description |
|------|-------------|
| [docs/developer-notes/problem-discussion-and-notes/part-1/part-1-instructions.md](./docs/developer-notes/problem-discussion-and-notes/part-1/part-1-instructions.md) | This file contains the instructions for Step 1 |
| [docs/developer-notes/problem-discussion-and-notes/part-1/part-1-table-of-contents.md](./docs/developer-notes/problem-discussion-and-notes/part-1/part-1-table-of-contents.md) | Enumerates a number of files in my solution. |
| [docs/developer-notes/problem-discussion-and-notes/part-1/part-1-discussion-and-notes.md](./docs/developer-notes/problem-discussion-and-notes/part-1/part-1-discussion-and-notes.md) | Discusses my solution in detail. |
| [database-schema/tables.sql](./database-schema/tables.sql) | Contains the table schema for every table in the database |

I discuss my solution in detail in [docs/developer-notes/problem-discussion-and-notes/part-1/part-1-discussion-and-notes.md](./docs/developer-notes/problem-discussion-and-notes/part-1/part-1-discussion-and-notes.md) . I created an Amazon Aurora MySQL database in my AWS account. I set up a t2.micro EC2 in AWS that has access to my Amazon Aurora MySQL database. I then set up an SSH tunnel on my laptop that allowed me to use my Amazon Aurora MySQL database.

Here is the command I used for that:

```
ssh -N -L 3669:wikipedia-assistant.cluster-cntmuespoc74.us-east-1.rds.amazonaws.com:3306 ubuntu@ec2-3-93-185-102.compute-1.amazonaws.com \
        -i /Users/peterjirak/Desktop/PeterEldritch/PeterEldritch/Projects/WikipediaAssistant/Source_Code/wikipedia-assistant/certificates-and-credentials/wikipedia-assistant-ec2-for-accessing-the-database.pem
```

After that I could work with my database using my laptop via mysql command-line utility or the Enterprise Edition of DBeaver. to use mysql I used the command:

`mysql --host 127.0.0.1 --user admin --password --port 3669`

I then used the SQL dump files to populate the tables `category`, `categorylinks`, `page1`, and `pagelinks`.

That successfully completed step 1. Once step 1 was completed I had a fully functioning database with all of the dumped data in it in an Aurora MySQL database.

### 2. Create two API endpoints

#### Part A - An endpoint that receives an arbitrary SQL query and returns the result of executing the query on the database.
For parts 2A and 2B I created the API endpoints using Python and Fast API along with SQLAlchemy. Initially I developed this on my laptop using an ssh tunnel to the Aurora MySQL database via a t2.micro EC2.

The source code for the API may be found in this repository in [src-code/api/app](./src-code/api/app/). Both parts 2A and parts 2B request that I develop endpoints for queries. To make this safe and prevent unwanted changes to the database I created a database user that had read-only access to the database and could not modify the database in any way. So if someone attempted to use my database endpoints tio mdofiy the datbase, they would fail because the user being used only has read access and does not have the permissions necessary to modify the database.

#### Part B - An end point that receives a category and returns the most outdated page for that category.
A page is called outdated if at least one of the pages it refers to was modified later than the page itself. The measure of this outdatedness is the biggest difference between the last modification of a referred page and the last modification of the page. This query can be a bit slow, so you should precompute the results for the top 10 categories with more pages. You can assume that this endpoint will only be called with one of the top 10 categories.

Part 2B really has two subparts, create a series of tables required to precompute the result and then implement the API necessary to return the precomputed result. The first subpart is far more time consuming than the second one.

I added the CREATE TABLE statements and the SQL for populating those tables to [database-schema/tables.sql](./database-schema/tables.sql). I provide a detailed discussion of my solution for the first subpart of 2B in [docs/developer-notes/problem-discussion-and-notes/part-2/part-2b/part-2b-discussion-and-notes.md](./docs/developer-notes/problem-discussion-and-notes/part-2/part-2b/part-2b-discussion-and-notes.md).

Once I completed the work for the database tables for precomputing the result and populating those tables with data, I successfully completed this first subpart and was able to go on to implementing the API endpoint.

So I succesfully completed part 2B.

### 3. Create an example architecture diagram that depicts how the application could be deployed in one of the following cloud providers: AWS, Google Cloud, Azure. You can choose the cloud provider you are more comfortable with. Provide a brief explanation of your architecture.

I completed this step as well. See [architectural-diagram.pdf](./architectural-diagram.pdf)

# Evaluating and reviewing my work
This GitHub repository contains the SQL files that contain the create table statements (Part 1) and the precomputed tables with the data necessary for part 2B.

I implemented the API endpoints as instructed in the problem assignment using Python, Fast API, and SQLAlchemy. So you can view all the work I did in this repository in evaluating my solution.

Okay, but you want to tested it and try it out. Well, I created that Amazon Aurora MySQL database, it is deployed in the AWS Cloud ecosystem.

But of course you need to utilize my Fast API implementation. How can you do that? Well, my initial plan was to get the entire thing up and running using Almbday and API Gateway. I got close, but couldn't quite manage it in the time I utilized for this project. So, instead I set up a t2.large with 30GB of local storage in the AWS ecosystem. I gave that t2.large access to my Aurora MySQL database. I then installed NGINX as my web server on that t2.large EC2. I installed uvicorn as the application server on that t2.large EC2. I configured NGINX to utilizemy uvicorn application server to handle requests. After I got all that working I set up a domain name in Amazon's AWS Route 53 hosting service. I configured the DNS records necessary to permit my FQDN to resolve to my t2.large EC2 instance, passing requests in that were then received by NGINX and passed along to my uvicorn application server. The given endpoints were then able to query the database as necessary. After all of that I then installed and configured Certbot, so I could have a SSL/TLS certificate and handle HTTPS and even redirect HTTP requests to HTTPS.

So, how can you evaluate and test my work? I mean you can see everything I did here in this repository, but how to test and evaluate it?

Well, open a web browser and use my FQDN and run my API.

Okay, since I set this up with Fast API and FAST API directly implements and supports Swagger and OpenAPI, you can view the documentation of my endpoints. Here is the URL to do that: [https://www.wikipediaassistant.com/docs](https://www.wikipediaassistant.com/docs)

You can test each endpoint and see the resolts:

## Get the current datetime in UTC

**Endpoint:** [https://www.wikipediaassistant.com/api/v1/current-utc-datetime](https://www.wikipediaassistant.com/api/v1/current-utc-datetime)

## Show the tables in my database

**Endpoint:** [https://www.wikipediaassistant.com/api/v1/show-tables/](https://www.wikipediaassistant.com/api/v1/show-tables/)

### Result

```json
{
  "message": [
    "category",
    "categorylinks",
    "most_outdated_page_for_ten_categories_with_most_pages",
    "most_outdatedness_score_for_ten_categories_with_most_pages",
    "outdated_pages_for_ten_category_with_most_pages",
    "page",
    "pagelinks",
    "ten_category_with_most_pages"
  ]
}
```

## Say Hello

**Endpoint:** [https://www.wikipediaassistant.com/api/v1/hello/{your-name-here}](https://www.wikipediaassistant.com/api/v1/hello/{your-name-here})

## Hello World!

**Endpoint:** [https://www.wikipediaassistant.com/api/v1/hello-world](https://www.wikipediaassistant.com/api/v1/hello-world)

## Get the row count for a table

**Endpoint:** `https://www.wikipediaassistant.com/api/v1/table-row-count/{table_name}`

Try it out using the page table:

 * [https://www.wikipediaassistant.com/api/v1/table-row-count/page](https://www.wikipediaassistant.com/api/v1/table-row-count/page)

## Run an arbitrary query using the endpoint /api/v1/query/{query}

Okay. to test this one I wrote various queries and then to get them handled correctly, I URL escaped the query and then made the call.

You can do this, too. I used the website [https://www.urlencoder.org/](https://www.urlencoder.org/)

So here is one such query:

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

I URL encode that query and get:

```
SELECT%20MOSFTWMP.cat_title%20AS%20cat_title%2C%0A%20%20%20%20%20%20%20OPFTCWMP.page_id%20AS%20page_id%2C%0A%20%20%20%20%20%20%20OPFTCWMP.page_namespace%20AS%20page_namespace%2C%0A%20%20%20%20%20%20%20OPFTCWMP.page_title%20AS%20page_title%2C%0A%20%20%20%20%20%20%20OPFTCWMP.page_touched%20AS%20page_touched%2C%0A%20%20%20%20%20%20%20OPFTCWMP.linked_to_page_id%20AS%20linked_to_page_id%2C%0A%20%20%20%20%20%20%20OPFTCWMP.linked_to_page_namespace%20AS%20linked_to_page_namespace%2C%0A%20%20%20%20%20%20%20OPFTCWMP.linked_to_page_title%20AS%20linked_to_page_title%2C%0A%20%20%20%20%20%20%20OPFTCWMP.linked_to_page_touched%20AS%20linked_to_page_touched%2C%0A%20%20%20%20%20%20%20OPFTCWMP.page_outdatedness%20AS%20page_outdatedness%0AFROM%20most_outdatedness_score_for_ten_categories_with_most_pages%20AS%20MOSFTWMP%0A%20%20%20%20%20JOIN%20outdated_pages_for_ten_category_with_most_pages%20AS%20OPFTCWMP%0A%20%20%20%20%20%20%20%20%20%20ON%20OPFTCWMP.page_outdatedness%20%3D%20MOSFTWMP.most_outdatedness_score%20AND%0A%20%20%20%20%20%20%20%20%20%20%20%20%20OPFTCWMP.cat_title%20%3D%20MOSFTWMP.cat_title%0AORDER%20BY%0A%20%20%20%20OPFTCWMP.page_outdatedness%20ASC%2C%0A%20%20%20%20MOSFTWMP.cat_title%20ASC%2C%0A%20%20%20%20OPFTCWMP.page_title%20ASC%3B%0A
```

Finally, I call my endpoint:

* [https://www.wikipediaassistant.com/api/v1/query/SELECT%20MOSFTWMP.cat_title%20AS%20cat_title%2C%0A%20%20%20%20%20%20%20OPFTCWMP.page_id%20AS%20page_id%2C%0A%20%20%20%20%20%20%20OPFTCWMP.page_namespace%20AS%20page_namespace%2C%0A%20%20%20%20%20%20%20OPFTCWMP.page_title%20AS%20page_title%2C%0A%20%20%20%20%20%20%20OPFTCWMP.page_touched%20AS%20page_touched%2C%0A%20%20%20%20%20%20%20OPFTCWMP.linked_to_page_id%20AS%20linked_to_page_id%2C%0A%20%20%20%20%20%20%20OPFTCWMP.linked_to_page_namespace%20AS%20linked_to_page_namespace%2C%0A%20%20%20%20%20%20%20OPFTCWMP.linked_to_page_title%20AS%20linked_to_page_title%2C%0A%20%20%20%20%20%20%20OPFTCWMP.linked_to_page_touched%20AS%20linked_to_page_touched%2C%0A%20%20%20%20%20%20%20OPFTCWMP.page_outdatedness%20AS%20page_outdatedness%0AFROM%20most_outdatedness_score_for_ten_categories_with_most_pages%20AS%20MOSFTWMP%0A%20%20%20%20%20JOIN%20outdated_pages_for_ten_category_with_most_pages%20AS%20OPFTCWMP%0A%20%20%20%20%20%20%20%20%20%20ON%20OPFTCWMP.page_outdatedness%20%3D%20MOSFTWMP.most_outdatedness_score%20AND%0A%20%20%20%20%20%20%20%20%20%20%20%20%20OPFTCWMP.cat_title%20%3D%20MOSFTWMP.cat_title%0AORDER%20BY%0A%20%20%20%20OPFTCWMP.page_outdatedness%20ASC%2C%0A%20%20%20%20MOSFTWMP.cat_title%20ASC%2C%0A%20%20%20%20OPFTCWMP.page_title%20ASC%3B%0A](https://www.wikipediaassistant.com/api/v1/query/SELECT%20MOSFTWMP.cat_title%20AS%20cat_title%2C%0A%20%20%20%20%20%20%20OPFTCWMP.page_id%20AS%20page_id%2C%0A%20%20%20%20%20%20%20OPFTCWMP.page_namespace%20AS%20page_namespace%2C%0A%20%20%20%20%20%20%20OPFTCWMP.page_title%20AS%20page_title%2C%0A%20%20%20%20%20%20%20OPFTCWMP.page_touched%20AS%20page_touched%2C%0A%20%20%20%20%20%20%20OPFTCWMP.linked_to_page_id%20AS%20linked_to_page_id%2C%0A%20%20%20%20%20%20%20OPFTCWMP.linked_to_page_namespace%20AS%20linked_to_page_namespace%2C%0A%20%20%20%20%20%20%20OPFTCWMP.linked_to_page_title%20AS%20linked_to_page_title%2C%0A%20%20%20%20%20%20%20OPFTCWMP.linked_to_page_touched%20AS%20linked_to_page_touched%2C%0A%20%20%20%20%20%20%20OPFTCWMP.page_outdatedness%20AS%20page_outdatedness%0AFROM%20most_outdatedness_score_for_ten_categories_with_most_pages%20AS%20MOSFTWMP%0A%20%20%20%20%20JOIN%20outdated_pages_for_ten_category_with_most_pages%20AS%20OPFTCWMP%0A%20%20%20%20%20%20%20%20%20%20ON%20OPFTCWMP.page_outdatedness%20%3D%20MOSFTWMP.most_outdatedness_score%20AND%0A%20%20%20%20%20%20%20%20%20%20%20%20%20OPFTCWMP.cat_title%20%3D%20MOSFTWMP.cat_title%0AORDER%20BY%0A%20%20%20%20OPFTCWMP.page_outdatedness%20ASC%2C%0A%20%20%20%20MOSFTWMP.cat_title%20ASC%2C%0A%20%20%20%20OPFTCWMP.page_title%20ASC%3B%0A)

## The endpoint for 2B /api/v1/most-out-of-date-page-for-category/{category}

The following categories are valid:

```json
{
    "message": [
        {
            "cat_title": "Articles_with_VIAF_identifiers"
        },
        {
            "cat_title": "Articles_with_hCards"
        },
        {
            "cat_title": "Commons_category_link_from_Wikidata"
        },
        {
            "cat_title": "Commons_category_link_is_on_Wikidata"
        },
        {
            "cat_title": "Coordinates_on_Wikidata"
        },
        {
            "cat_title": "Living_people"
        },
        {
            "cat_title": "Pages_translated_from_English_Wikipedia"
        },
        {
            "cat_title": "People_stubs"
        },
        {
            "cat_title": "United_States_geography_stubs"
        },
        {
            "cat_title": "Webarchive_template_wayback_links"
        }
    ]
}
```

So the URL is: `https://www.wikipediaassistant.com/api/v1/most-out-of-date-page-for-category/{category}`

Try it out: [https://www.wikipediaassistant.com/api/v1/most-out-of-date-page-for-category/Articles_with_VIAF_identifiers](https://www.wikipediaassistant.com/api/v1/most-out-of-date-page-for-category/Articles_with_VIAF_identifiers)

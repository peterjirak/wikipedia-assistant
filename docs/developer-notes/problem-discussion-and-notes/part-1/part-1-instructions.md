# Part 1 - Create a database based on the Simple English Wikipedia content.
Create a database based on the Simple English Wikipedia content. There are periodic dumps with the data that you can find [here](https://dumps.wikimedia.org/simplewiki/). And [here](https://meta.wikimedia.org/wiki/Data_dumps/What%27s_available_for_download#Database_tables), you can find a list of the tables and their schema. The tables that are relevant for this assignment are: page, pagelinks and categorylinks. The database should contain the following:
* Basic metadata for every wiki page:
  * Page title
  * Categories of the page
  * Date of last modification
* The links between the wiki pages, defined by the following:
  *The page which refers to another page
  * The referred page
You’re allowed to make simplifications (in case something is not trivial to implement) but you have to document your decisions about these simplifications.
You can download and preprocess the data dumps as you wish, but we recommend using the SQL data dumps instead of the XML ones, since they are easier to work with.

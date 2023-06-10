# Part 1 - Discussion and Notes - Create a database based on the Simple English Wikipedia content

*Also see:*
 * [part-1-instructions.md](./part-1-instructions.md)
 * [part-1-table-of-contents.md](./part-1-table-of-contents.md)

## Part 1.1 - Setup the database

This part of the programming assignment calls for the engineer to create a database using dumps of some of the tables from the Simple English Wikipedia content's database. It provides a [link](https://dumps.wikimedia.org/simplewiki/) to the dump files, the SQL files contain both the given table's schema and the insert statements necessary to populate it. It also contains a [link](https://meta.wikimedia.org/wiki/Data_dumps/What%27s_available_for_download#Database_tables) to a page that explain the given table schema.

Okay, so in this part of the programming assignment I need to create a database and populate it with data. Looking at the SQL dump files after uncompressing them the source database is MySQL. Personally, I think PostGreSQL is superior to MySQL. I think I can make a compelling argument that that is the case. However, porting from MySQL to PostGreSQL is far more fraught with challenges than one might initially expect. I know this from experience. This would increase the time to deliver, increase the complexity, and increase the risk of implementing a defect. Thus, since the source database was MySQL I decided my database would also be MySQL.

Okay, so where and how should I setup my database. Okay, so there is nearly 4GB of data. Also thinking about modern Cloud Computing, instead of building a MySQL database on my laptop and populating it with data, making it difficult or impossible for anyone other than me to access, why not build the database for this part of the problem in AWS using Amazon's Aurora MySQL database. Aurora MySQL is considered to be serverless, event hough in fact there us a server. I think it is considered to be serverless because the server is transparent, one never works with or accesses the server directly.

So I created a Amazon Aurora MySQL database in AWS. The file [resources/aws-rds-describe-db-instances.json](../../../../resources/aws-rds-describe-db-instances.json) contains the output of the aws command-line command `aws rds describe-db-instances` describing my instance.

## Part 1.2 - Accessing the database

When I set up that instance I set it to be publicly available so I could access it directly from my laptop without setting up an EC2 and adding it to a VPC security group and then needing to tunnel through the EC2. I was never able to gain that direct access from my laptop without using an EC2 added to a VPC  security group that provides it with access to the database. I would not generally set my database to publicly available. I think that is a poor idea. I would instead make my database private, setup an EC2, add the EC2 to a VPC and use it as an ssh tunnel to access my database. That is much more secure. Since the EC2 is just acting as a tunnel, a t2.micro is just fine. I created mine with 30GB of local storage. That was really unnecessary. I could have just used 8 GB of local storage and been just fine. Note that a beefier EC2 would have some advantages, the beefier EC2 do have higher network bandwidths (like the t2.large), more CPU, and more memory. However, it is just acting as a tunnel, so even though some of these attributes, like increased bandwidth would have an appreciable positive effect on performance (making inserts and large queries take less time due to more bandwidth), it would not be worth the considerable increase in expense.

So after creating my database instance, I tried to connect to it directly from my laptop, it was a publicly accessible instance. This should have been possible. After numerous attempts and reading a lot of documentation I gave up on attempting to access it directly from my laptop. I launched a t2.micro EC2 with 30 GB of storage and setup an ssh tunnel.

Here is the command for my ssh tunnel:

```
ssh -N -L 3669:wikipedia-assistant.cluster-cntmuespoc74.us-east-1.rds.amazonaws.com:3306 \
    ubuntu@ec2-3-93-185-102.compute-1.amazonaws.com \
    -i /Users/peterjirak/Desktop/PeterEldritch/PeterEldritch/Projects/WikipediaAssistant/Source_Code/wikipedia-assistant/certificates-and-credentials/wikipedia-assistant-ec2-for-accessing-the-database.pem
```

The form for that command is:

```
ssh -N -L LOCAL_PORT:WRITER_INSTANCE_DATABASE_ENDPOINT:DATABASE_PORT \
          USER@EC2_PUBLIC_IP_ADDRESS \
          -i PEM_FILE_PATH_ON_MY_LAPTOP
```

After setting up the EC2 and setting up the ssh tunnel I was able to access my Amazon Aurora MySQL database in AWS using both the mysql command-line utility on my Mac and using the Enterprise edition of DBeaver, a popular database GUI.

Here is my command for accessing the database using the mysql command-line utility after setting up my ssh tunnel:

`mysql --host 127.0.0.1 --user admin --password --port 3669`

Once I was able to access my database I created the database schema wikipedia_assistant. Once my database schema existed on my DBMS I was able to access it using the mysql command:

`mysql --host 127.0.0.1 --user admin --password --port 3669 --database wikipedia_assistant`

*Having successfully set this up and set up an ssh tunnel and being able to access my database, I totally felt like a rock star. I would have felt like more of a rock star had I managed this in a little more timely fashion. I spent a lot of time trying to gain direct access frm my laptop which is supposed to be possible when one's database is publicly accessible which mine is but I could never get tit to work. In reality making the database publicly accessible is just a bad idea. In the future, I would leave it private and do the trick with an EC2 in a VPC security group and an ssh tunnel, that is more secure.*

## Part 1.3 - Creating tables and populating them with data

Okay, I have an Amazon Aurora MySQL database. I am able to access my database using the mysql command-line utility and using the Enterprise edition of DBeaver, a popular database GUI. Next, I need to create tables in my database and populate them with the data dumped from the source database. The programming assignment description said to use the following three tables in my solution: `categorylinks`, `page`, and `pagelinks`. It stated that I could make any simplifying assumptions. I decided to also include the table `category` in my solution as well.

I downloaded the latest versions of the compressed SQL files for each of these tables. I added them to my repository in the sub-directory [data-unmodified](../../../../data-unmodified/). I wanted to add them uncompressed, but uncompressed some of the files not only exceeded the recommended file size limit of 50MB in GitHub, but the hard-limit of 100MB. I uncompressed the files and then recompressed them with gzip -9 (the maximum compression option) and then added them to my repository. I did that because it allows anyone who views my project to see my data sources. That, in my opinion is essential in evaluating my solutions.

After downloading the files and adding the compressed SQL files to my repository I uncompressed them. In viewing the files I saw that there were commented out database directives. I decided I wanted those database directives to execute because I wanted the data in my database to be as close to what had been in the source database at the time the dumps were created as possible. I used sed to uncomment out the commented out database directives:

`cat simplewiki-latest-page.sql | sed 's/^\/\*\![0-9]* //' | sed 's/ \*\/\;$/;/' > simplewiki-latest-page-modified.sql`

Having downloaded the compressed SQL files, having added them to my repository, and having uncommented out the directory directives in those dump files, it was time ot create the four tables and populate them with data in my database. I used the mysql command-line command to do so:

`mysql --host 127.0.0.1 --user admin --password --port 3669 --database wikipedia_assistant < DUMP_FILE.sql`

I executed the above command four times, once for each table/dump file. After having run those four commands my database had the data in the tables `category`, `categorylinks`, `page`, and `pagelinks` from my dump files and I could proceed.

In addition to creating the Amazon Aurora MySQL database in AWS, creating a database schema in that database, creating the four tables and populating them with data I also created a read-only user for my database:

```
CREATE USER 'read_only_user'@'%' IDENTIFIED BY 'REDACTED';
GRANT SELECT, SHOW VIEW ON wikipedia_assistant.* TO 'read_only_user'@'%';
```

My thinking in doing so was multi-fold. Note that the database actually has two endpoints, one of the endpoints provides write+read access and the other only provides read access. I can utilize the read-only endpoint for safety, like in my two API endpoints that query the database. Using the read-only endpoint assures no one can use the API endpoints to modify my database. However, making a read-only user means that regardless of which endpoint gets used, that user cannot modify the database. So it is totally safe to use my read-only user in my two endpoints. Additionally, I can share the PEM file with anyone I wanted to be able have access to my database, the IP address of my EC2 instance, the read-only user name and password and people I share it with can set up ssh tunnels and access my database using the read-only user without any concern that they could unintentionally or intentionally modify my database (I am going to assume lack of malice and such a scenario being unintentional).

So at the end of step 1 I had:
 * An Amazon Aurora MySQL database in AWS
 * An EC2 that is accessible publicly and able to connect to my database via a VPC security group.
 * The ability to connect from my laptop to the database via an ssh tunnel through that EC2.
 * A database schema named wikipedia_assistant in my database.
 * The four table schema in that database schema -- `category`, `categorylinks`, `page`, `pagelinks`. I created those four tables using the SQL dump files.
 * Each of the four tables was fully populated with data from the four dump files, a total of about 4GB of data.

Having completed these activities I was ready to proceed with the rest of the assignment.

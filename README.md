# lynx-analytics-wikipedia-assistant

# Table of contents

## Directories
| Name | Description                                                                                                                                     |
|------|-------------------------------------------------------------------------------------------------------------------------------------------------|
| docs | This directory contains documentation for this project, including the problem assignment that describes the problem we are solving.             |
| data | This directory contains the downloads of table extracts from [https://dumps.wikimedia.org/simplewiki/](https://dumps.wikimedia.org/simplewiki/) |
## Files
| Name                                                       | Description                                                        |
|------------------------------------------------------------|--------------------------------------------------------------------|
| docs/Wikipedia_assignment_for_Senior_Software_Engineer.pdf | This file describes in English the problem we are trying to solve. |

# Topics

## Accessing your database instance
Okay, I created a Amazon Aurora MySQ: database to use for this project. To simplify things I made my database instance publicly available. I am trying to figure out how to connect to my local computer to my database instance and I am struggling a bit. If I can't make this work, I may create an EC2 for that purpose.

### Links and References

* [Using SSL/TLS to encrypt a connection to a DB instance | AWS Documentation](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/UsingWithRDS.SSL.html)

# Links and References
* Markdown
  * [Markdown Guide](https://www.markdownguide.org/)
    * [Markdown Basic Syntax](https://www.markdownguide.org/basic-syntax/)
    * [Markdown Extended Syntax](https://www.markdownguide.org/extended-syntax/)
* Git
  * [How do I undo the most recent local commits in Git? | StackOverflow](https://stackoverflow.com/questions/927358/how-do-i-undo-the-most-recent-local-commits-in-git)
* [CloudMounter](https://cloudmounter.net/)

  I use a Mac and use CloudMounter to mount my Google Drive on my Mac. This means I can use Finder and terminal to work with files in my Google Drive. CloudMounter also supports FTP & SFTP, Amazon S3, Backblaze, OpenStack Swift, Dropbox, Google Drive, OneDrive, Bix, Mega, WebDav, and pCloud. I some times put notes files and various auxillary files in my Google Drive.

  So I needed to know, [Where does cloudmounter mount a drive? (Accessing a cloudmounter drive from the terminal)](https://www.google.com/search?sxsrf=APwXEdepLSWi5NFYsVV9u0uDDGvR5qP1OQ:1684599901434&q=Where+does+cloudmounter+mount+a+drive?+Accessing+a+cloudmounter+drive+from+the+terminal&spell=1&sa=X&ved=2ahUKEwjVrdrVp4T_AhXjADQIHaVVDLgQBSgAegQIFxAB)

  And the answer was: `~/Library/Containers/com`

  From [Where are the mounted disks located? | CloudMounter | FAQ](https://cloudmounter.net/faq/where-are-the-mounted-disks-located/#:~:text=Disks%20mounted%20with%20CloudMounter%20are,~%2FLibrary%2FContainers%2Fcom.)
* LINUX Commands
  * `sed`: [Sed Command in Linux/Unix with examples | Geeks for Geeks](https://www.geeksforgeeks.org/sed-command-in-linux-unix-with-examples/)
  * `awk`: [Awk command in Linux/Unix with examples | Geeks for Geeks](https://www.geeksforgeeks.org/awk-command-unixlinux-examples/)
* AWS command-line tool
  * [Install the AWS CLI on Mac OS // How to download, install, and configure the AWS CLI (V2) by Dennis Traub | YouTube](https://www.youtube.com/watch?v=BNH4i7CQ4Oc)

    This video helps one install and configure the AWS command-line tool. However, these instructions cause one to set up an access key and a secret access key for one's root account. This practice is strongly discouraged. I did this but I would recommend investigating and using alternatives.
* SQL
  * MySQL
    * [Configuring Application Character Set and Collation | MySQL - Development - Documentation](https://dev.mysql.com/doc/refman/5.7/en/charset-applications.html)
    * [Create a MySQL database with charset UTF-8 | StackExchange - DBAs](https://dba.stackexchange.com/questions/76788/create-a-mysql-database-with-charset-utf-8)
* AWS
  * [Controlling access with security groups | AWS Documentation](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/Overview.RDSSecurityGroups.html)
  * [Encrypting client connections to MySQL DB instances with SSL/TLS | AWS Documentation](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/mysql-ssl-connections.html#MySQL.Concepts.SSLSupport)
  * [Using SSL/TLS to encrypt a connection to a DB instance | AWS Documentation](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/UsingWithRDS.SSL.html)
  * [Connecting to an Amazon Aurora DB cluster | AWS Documentation](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/Aurora.Connecting.html)
  * [Connect to the internet using an internet gateway | AWS Documentation](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Internet_Gateway.html#Add_IGW_Attach_Gateway)
  * [How do I configure a provisioned Amazon Aurora DB cluster to be publicly accessible? | AWS re:Post](https://repost.aws/knowledge-center/aurora-mysql-connect-outside-vpc)
  * [Accessing a private RDS instance via an ssh tunnel by Grig Gheorghiu on May 18, 2018 | Medium](https://griggheo.medium.com/accessing-a-private-rds-instance-via-an-ssh-tunnel-4be098b128ef)
  * [Connect to Aurora Serverless using EC2 as Proxy | StackOverflow](https://stackoverflow.com/questions/52448301/connect-to-aurora-serverless-using-ec2-as-proxy)
  * [Connect to RDS using an SSH Tunnel by Michalis Antoniou on Jan 25, 2017 | Medium](https://medium.com/@michalisantoniou6/connect-to-an-aws-rds-using-an-ssh-tunnel-22f3bd597924)
  * AWS CLI
    * [AWS CLI RDS describe-certificates](https://docs.aws.amazon.com/cli/latest/reference/rds/describe-certificates.html)

# Google Searches
* [Google Search: Using the AWS CLI how do I add my laptop's public IP to the RDS security group for my Aurora MySQL database](https://www.google.com/search?q=Using+the+AWS+CLI+how+do+I+add+my+laptop%27s+public+IP+to+the+RDS+security+group+for+my+Aurora+MySQL+database&sxsrf=APwXEdeJhOaVl5mZJuNIq4GKUJKyBkfXOQ%3A1684622579273&source=hp&ei=80xpZPTgDcWH0PEP2bqSyAE&iflsig=AOEireoAAAAAZGlbA2aVGHT8AGPf6VJ803ziqXZiOPeP&ved=0ahUKEwi0pqmT_IT_AhXFAzQIHVmdBBkQ4dUDCAw&uact=5&oq=Using+the+AWS+CLI+how+do+I+add+my+laptop%27s+public+IP+to+the+RDS+security+group+for+my+Aurora+MySQL+database&gs_lcp=Cgdnd3Mtd2l6EAMyBwghEKABEAoyBQghEKsCOgQIIxAnOggIABCKBRCRAjoLCAAQgAQQsQMQgwE6CAgAEIAEELEDOhEILhCABBCxAxCDARDHARDRAzoOCC4QgAQQsQMQgwEQ1AI6BwgjEIoFECc6DQgAEIoFELEDEIMBEEM6BwgAEIoFEEM6DgguEIoFELEDEMcBENEDOg4ILhCABBCxAxDHARDRAzoHCAAQgAQQCjoKCAAQgAQQFBCHAjoLCC4QgAQQxwEQ0QM6BQgAEIAEOgQIABADOggIABAWEB4QDzoICAAQFhAeEAo6BggAEBYQHjoICAAQigUQhgM6CAghEBYQHhAdOgUIIRCgAToHCCEQqwIQClAAWM3-AWCdiAJoAHAAeACAAXWIAcAakgEENTIuMZgBAKABAQ&sclient=gws-wiz)
* [Google Search: MySQL create database InnoDb engine UTF8](https://www.google.com/search?q=MySQL+create+database+InnoDb+engine+UTF8&sxsrf=APwXEdfQHCXlFvD3MyD8Du28UMOQBLHNJw%3A1684625148039&source=hp&ei=-1ZpZIXUO9OV0PEPtd-cwAI&iflsig=AOEireoAAAAAZGllDEYYaIYIblILGqBAIHG65NcHOPTg&ved=0ahUKEwjFvZnchYX_AhXTCjQIHbUvBygQ4dUDCAw&uact=5&oq=MySQL+create+database+InnoDb+engine+UTF8&gs_lcp=Cgdnd3Mtd2l6EAMyBggAEBYQHjIICAAQigUQhgMyCAgAEIoFEIYDMggIABCKBRCGAzIICAAQigUQhgM6BwgjEIoFECc6BwgAEIoFEEM6BAgjECc6DQgAEIAEEBQQhwIQsQM6CggAEIAEEBQQhwI6CggAEIoFELEDEEM6CAgAEIAEELEDOgUIABCABFAAWL96YIihAWgAcAB4AIABkAWIAZwnkgEKMzAuNS4yLjUtM5gBAKABAQ&sclient=gws-wiz)
* [Google Search: Accessing my Amazon Aurora MySQL database using a bundle PEM file](https://www.google.com/search?q=Accessing+my+Amazon+Aurora+MySQL+database+using+a+bundle+PEM+file&sxsrf=APwXEdc7KyeWBxrj7e9MjtNLtrOUxn4MJw%3A1684618763521&source=hp&ei=Cz5pZLCuHe_G0PEPlrmKoAE&iflsig=AOEireoAAAAAZGlMG7Mo2pbPxRr5tncPGZYnur0kgn_j&ved=0ahUKEwjw3-r37YT_AhVvIzQIHZacAhQQ4dUDCAw&uact=5&oq=Accessing+my+Amazon+Aurora+MySQL+database+using+a+bundle+PEM+file&gs_lcp=Cgdnd3Mtd2l6EAMyBQghEKABMgUIIRCgATIFCCEQoAEyBQghEKABMgUIIRCrAjIFCCEQqwIyBQghEKsCOgcIIxCKBRAnOgQIIxAnOggIABCKBRCRAjoRCC4QgwEQxwEQsQMQ0QMQgAQ6DQgAEIAEEBQQhwIQsQM6EQguEIAEELEDEIMBEMcBENEDOggIABCABBCxAzoFCAAQgAQ6FAguEIAEELEDEIMBEMkDEMcBENEDOggIABCABBCSAzoICAAQigUQkgM6CggAEIAEEBQQhwI6CwguEIoFELEDEIMBOg4ILhCABBCxAxDHARDRAzoICAAQigUQsQM6CAguEIAEELEDOgQIABADOgsILhCABBDHARCvAToLCAAQigUQsQMQgwE6CwgAEIAEELEDEIMBOgYIABAWEB46CAghEBYQHhAdUABYmZgBYMShAWgAcAB4AYAByAKIAeUakgEINDIuMy4wLjGYAQCgAQE&sclient=gws-wiz)
* [Google Search: Access my Aurora MySQL database from my laptop proxying through an EC2](https://www.google.com/search?q=Access+my+Aurora+MySQL+database+from+my+laptop+proxying+through+an+EC2&sxsrf=APwXEdfcvepgw6Tiq3PNu48vMbKs6WjSvg%3A1684627253793&source=hp&ei=NV9pZNSvLfrJ0PEP7-Wl0A8&iflsig=AOEireoAAAAAZGltRXo1qTqDbUq1lF1U9S0Z1IV3BL8c&ved=0ahUKEwiUnqfIjYX_AhX6JDQIHe9yCfoQ4dUDCAw&uact=5&oq=Access+my+Aurora+MySQL+database+from+my+laptop+proxying+through+an+EC2&gs_lcp=Cgdnd3Mtd2l6EAMyBQghEKABMgUIIRCgATIFCCEQoAEyBQghEKsCMgUIIRCrAjIFCCEQqwI6BwgjEIoFECc6BAgjECc6BwgAEIoFEEM6EQguEIAEELEDEIMBEMcBENEDOgoIABCKBRCxAxBDOgoIABCKBRDJAxBDOggIABCKBRCSAzoOCC4QgAQQsQMQxwEQ0QM6BQgAEIAEOggIABCKBRCxAzoICAAQgAQQsQM6CAgAEIoFEJECOgQIABADOgsILhCABBDHARCvAToHCAAQgAQQCjoLCAAQFhAeEPEEEAo6CAgAEBYQHhAPOgYIABAWEB46CAgAEB4QDRAPOggIABAFEB4QDToICAAQCBAeEA06CAgAEIoFEIYDOggIIRAWEB4QHVAAWLhxYM55aABwAHgAgAGDAYgBsRmSAQQ0Ny4xmAEAoAEB&sclient=gws-wiz)
* [Google Search: Install the rds-ssh-tunnel on Ubuntu Linux](https://www.google.com/search?q=Install+the+rds-ssh-tunnel+on+Ubuntu+Linux&sxsrf=APwXEdcMHhT7owGd6SVXOCUPGefPGO9Ifw%3A1684628349509&source=hp&ei=fWNpZLLSG-iH0PEP4b6EcA&iflsig=AOEireoAAAAAZGlxjfDtArBqDyXMu4iX95GIuxvGHePy&ved=0ahUKEwjyhOTSkYX_AhXoAzQIHWEfAQ4Q4dUDCAw&uact=5&oq=Install+the+rds-ssh-tunnel+on+Ubuntu+Linux&gs_lcp=Cgdnd3Mtd2l6EAM6BAgjECc6BwgjEIoFECc6CAgAEIoFEJECOgsIABCABBCxAxCDAToOCC4QgAQQsQMQxwEQ0QM6DQgAEIoFELEDEIMBEEM6BwgAEIoFEEM6DQgAEIAEEBQQhwIQsQM6CggAEIAEEBQQhwI6BQgAEIAEOggIABCABBCxA1AAWNBFYLBKaABwAHgAgAGZAYgBkg-SAQQyOC4xmAEAoAEBoAEC&sclient=gws-wiz)

# Tools

## `mysqlsh` - A command line utility for working with MySQL.

## `aws` - The AWS command-line tool

###  `aws rds describe-db-instances`

This command yields a JSON with detailed information on one's RDS instances

# ISSUES

## Accessing a publicly available Amazon Aurora MySQL database

I created my Amazon Aurora MySQL serverless database without difficulty. However, I had a very difficult time trying to connect from my laptop to that database. I spent a lot of time looking through documentation and trying to figure it out. In the end I created an EC2 t2.micro and used it to set up a tunnel allowing me to connect to my database from my laptop via that EC2 t2.micro.

# TODOs

## Find an alternative to using an access key and secret access key to run the aws command-line utility as root user

I followed the instructions in the video [Install the AWS CLI on Mac OS // How to download, install, and configure the AWS CLI (V2) by Dennis Traub | YouTube](https://www.youtube.com/watch?v=BNH4i7CQ4Oc) once complete I had and was able to use the aws command-line utility. However, I was doing so as my root user. This is strongly discouraged. Thus one of my TODOs is find an alternative to using the access key and secret access key of the root user for using the AWS command-line tool.

  # Appendix
  ## Using sed and awk to create index-of-simplewiki-latest.md from index-of-simplewiki-latest.html

  First I trimmed off everything above the body tag and below the closing body tag, giving me rows of links, filenames, dates, times, and size. Then I executed the following from the command line:

  `cat index-of-simplewiki-latest.html| sed 's/<a href="//' | sed 's/">/ /' | sed 's/<\/a\>/ /' | awk '{print "| [" $1 "](https://dumps.wikimedia.org/simplewiki/latest/" $1 ") | " $3 " | " $4 " | " $ 5 " |"  }' > index-of-simplewiki-latest.md`

  After that I edited `index-of-simplewiki-latest.md`, adding a header row and the row that separates the header row from the body rows in a table.

## My tunnel to permit me to connect to my Amazon Aurora MySQL database from my laptop. I ran this ssh command on my laptop:

`ssh -N -L 3669:lynx-analytics-wikipedia-assisstant.cluster-cntmuespoc74.us-east-1.rds.amazonaws.com:3306 ubuntu@ec2-3-93-185-102.compute-1.amazonaws.com -i /Users/peterjirak/Desktop/PeterEldritch/PeterEldritch/Projects/LynxAnalytics/Source_Code/lynx-analytics-wikipedia-assistant/certificates-and-credentials/lynx-analytics-wikipedia-assisstant-ec2-for-accessing-the-database.pem`

After that I could connect to my database using the host `127.0.0.1` and the port `3669`

This is a work-around.

### Using the dig command to verify a DNS or FQDN

**Link:** [dig man page](https://linux.die.net/man/1/dig)

One can use dig to verify a DNS or FQDN. My database uses the endpoint lynx-analytics-wikipedia-assisstant-instance-1.cntmuespoc74.us-east-1.rds.amazonaws.co. I wanted to verify that endpoint. I did so with the `dig` command:

`dig lynx-analytics-wikipedia-assisstant-instance-1.cntmuespoc74.us-east-1.rds.amazonaws.com`

## Using sed to uncomment out code in the SQL dump files

Per the suggestion in the programming assignment instructions I downloaded the SQL dump files. These consist of the create table statement necessary to create the table and then the insert into statements to populate the t5able. There are a series of optional statements that are commented out. If these are compatible with one's database engine, one can uncomment them out and then execute them. One could do this manually or one could use sed for this purpose. I implemented a sed command to do this:

`cat simplewiki-latest-page.sql | sed 's/^\/\*\![0-9]* //' | sed 's/ \*\/\;$/;/' > simplewiki-latest-page-modified.sql`

## Creating the database tables and populating them with data

I set up an EC2 t2.micro in the AWS ecloud ecosystem. My Ec2 has the IP address `ec2-3-93-185-102.compute-1.amazonaws.com` . It has a PEM file `lynx-analytics-wikipedia-assisstant-ec2-for-accessing-the-database-t2-micro.pem` .

I set up an SSH tunnel to allow myself to access my Amazon Aurora MySQL database from my laptop. I ran this command on my laptop:

`ssh -N -L 3669:lynx-analytics-wikipedia-assisstant.cluster-cntmuespoc74.us-east-1.rds.amazonaws.com:3306 ubuntu@ec2-3-93-185-102.compute-1.amazonaws.com -i /Users/peterjirak/Desktop/PeterEldritch/PeterEldritch/Projects/LynxAnalytics/Source_Code/lynx-analytics-wikipedia-assistant/certificates-and-credentials/lynx-analytics-wikipedia-assisstant-ec2-for-accessing-the-database.pem`

This mapped port `3669` on my laptop to port `3306` on `lynx-analytics-wikipedia-assisstant.cluster-cntmuespoc74.us-east-1.rds.amazonaws.com` (the resolvable IP address for accessing my database) through my EC2 whose IP address is `lynx-analytics-wikipedia-assisstant.cluster-cntmuespoc74.us-east-1.rds.amazonaws.com` .

After that I could use the `mysql` command-line client on my laptop to access my database. I was also able to use the `DBeaver` GUI to work with my database.

I ran this command to populate the database's `page` table with data:

`mysql --user admin --password --port 3669 --host 127.0.0.1 --database lynx_analytics_wikipedia_assistant < /Users/peterjirak/Desktop/PeterEldritch/PeterEldritch/Projects/LynxAnalytics/Source_Code/lynx-analytics-wikipedia-assistant/data/simplewiki-latest-page-modified.sql`

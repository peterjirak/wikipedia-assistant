# Part 1 - Table of Contents - Create a database based on the Simple English Wikipedia content

# Files
| File | Description |
|------|-------------|
| [database-schema/tables.sql](../../../../database-schema/tables.sql) | Contains the create table statements for each table in my database |
| [resources/aws-rds-describe-db-instances.json](../../../../resources/aws-rds-describe-db-instances.json)| For part 1 I created an Amazon Aurora MySQL database in AWS in my account. This JSON file is the output od the aws command-line command `aws rds describe-db-instances`. It describes the instance I created. |
| [data-unmodified/index-of-simplewiki-latest.html](../../../../data-unmodified/index-of-simplewiki-latest.html) | A capture of the contents of the index of the latest dump files from the simplewiki database at the time of the creation of my project. |
| [data-unmodified/index-of-simplewiki-latest.md](../../../../data-unmodified/index-of-simplewiki-latest.md) | Same as data-unmodified/index-of-simplewiki-latest.html except in Markdown format. I ♡ Markdown. |

# Directories
| Directory | Description |
|-----------|-------------|
| [data-unmodified](../../../../data-unmodified/) | This directory contains each of the SQL dump files I downloaded for this project. Some of the files once uncompressed exceeded not only the recommended file size limit of 50MB in GitHub but the hard-limit of 100 MB. Thus in my repository they are compressed. Note that I uncompressed them and then recompressed them using gzip -9, the -9 option yields maximum compression. |

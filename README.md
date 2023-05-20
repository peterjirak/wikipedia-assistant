# lynx-analytics-wikipedia-assistant

## Table of contents

### Directories
| Name | Description                                                                                                                                     |
|------|-------------------------------------------------------------------------------------------------------------------------------------------------|
| docs | This directory contains documentation for this project, including the problem assignment that describes the problem we are solving.             |
| data | This directory contains the downloads of table extracts from [https://dumps.wikimedia.org/simplewiki/](https://dumps.wikimedia.org/simplewiki/) |
### Files
| Name                                                       | Description                                                        |
|------------------------------------------------------------|--------------------------------------------------------------------|
| docs/Wikipedia_assignment_for_Senior_Software_Engineer.pdf | This file describes in English the problem we are trying to solve. |

## Links and References
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

# Tools

## `mysqlsh` - A command line utility for working with MySQL.

## `aws` - The AWS command-line tool

###  `aws rds describe-db-instances`

This command yields a JSON with detailed information on one's RDS instances

  # Appendix
  ### Using sed and awk to create index-of-simplewiki-latest.md from index-of-simplewiki-latest.html

  First I trimmed off everything above the body tag and below the closing body tag, giving me rows of links, filenames, dates, times, and size. Then I executed the following from the command line:

  `cat index-of-simplewiki-latest.html| sed 's/<a href="//' | sed 's/">/ /' | sed 's/<\/a\>/ /' | awk '{print "| [" $1 "](https://dumps.wikimedia.org/simplewiki/latest/" $1 ") | " $3 " | " $4 " | " $ 5 " |"  }' > index-of-simplewiki-latest.md`

  After that I edited `index-of-simplewiki-latest.md`, adding a header row and the row that separates the header row from the body rows in a table.

# TODOs

## Find an alternative to using an access key and secret access key to run the aws command-line utility as root user

I followed the instructions in the video [Install the AWS CLI on Mac OS // How to download, install, and configure the AWS CLI (V2) by Dennis Traub | YouTube](https://www.youtube.com/watch?v=BNH4i7CQ4Oc) once complete I had and was able to use the aws command-line utility. However, I was doing so as my root user. This is strongly discouraged. Thus one of my TODOs is find an alternative to using the access key and secret access key of the root user for using the AWS command-line tool.

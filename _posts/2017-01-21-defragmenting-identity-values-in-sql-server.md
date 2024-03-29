---
layout: post
title:  "Defragmenting identity values in T-SQL / SQL Server"
date:   2017-01-21 12:00:00 +0100
categories: sql development
---

In a development SQL database I'm using I had the problem that my primary key columns were overflowing. The primary key columns are integer generated by a SQL `IDENTITY`. Due to various development activities like cloning records I was running out of space for my primary keys. There were however a lot of holes between the primary keys. The script below helps you remove the gaps between identity values and updates all foreign keys accordingly.

For each table it ensures any unique indexes or constraints are disabled before the operation and enabled afterwards. All foreign keys are updated to the changes. You can specify which tables to exclude, which is useful if you have tables that cannot change because your code dependents on specific ids.

<script src="https://gist.github.com/Sebazzz/c1db6f10566160ac656a8be8a81f19ac.js"></script>

After running this script you probably want to rebuild all the indexes in your database.

<script src="https://gist.github.com/Sebazzz/bbf65cba726d78cd79a985a4ea1e008e.js"></script>

These scripts of course don't come with any warranty and purely meant for development purposes!

## Result
After execution of the T-SQL script, results are shown. You can see of every table what the maximum identity value was and now is.

![Result of defragmenting identity values in T-SQL](/images/blog/2017-01-21-defragmenting-identity-values-in-sql-server/primary.png)

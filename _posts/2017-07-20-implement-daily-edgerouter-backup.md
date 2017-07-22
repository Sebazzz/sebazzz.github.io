---
layout: post
title:  "How-to: Implement a daily Edgerouter backup"
date:   2017-07-20 20:00:00 +0100
categories: it-management ubiquity edgeos
---

Configuration of a router is often a task which costs a fair amount of time. Therefore it is often useful to keep several backups of the entire configuration partition. The script below takes a backup of the `/config` partition of an Ubiquiti Edgerouter and uploads it to a FTP server.

<script src="https://gist.github.com/Sebazzz/19da22d515cc40fb5ab988033530b87a.js"></script>

Install the script files in `/config/user-data`, then register it with the task scheduler:

	set system task-scheduler task daily-backup executable path /config/user-data/config-backup
	set system task-scheduler task daily-backup interval 1d

Make sure that `/config/user-data/config-backup` is marked as executable!

	chmod +x /config/user-data/config-backup

## How it works
The script works as follows:

1. Tar the `/config` folder to `/tmp`.
2. Upload the archive to an FTP server.
3. Clean up older uploaded archives from the FTP server.

Because the `date` command in EdgeOS is too limited to create a date in format YYYY-MM-DD and cannot calculate dates, we use an external helper script in Perl (which is by default installed on EdgeOS) to create a date string.

Enjoy!
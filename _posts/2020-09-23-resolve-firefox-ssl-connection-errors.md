---
layout: post
title:  "Resolve Firefox SSL connection errors"
date:   2020-09-23 20:31:00 +0200
categories: firefox
---

A quick blog post because I ran into the issue of Firefox not connecting to certain HTTPS sites, and I could not find a solution. Well, the only offered solution was "clear your profile" but I don't want to do that. It takes a lot of effort to get back up running, even with Firefox sync. 

# The symptoms

I was for a longer time not able to visit the website from the tax authority of my country (Belastingdienst), but suddenly I could not visit Twitter as well.

- For the HTTPS connection to Belastingdienst I ran into `PR_CONNECT_RESET_ERROR`
- For the HTTPS connection to Twitter I had simply "connection failed" without any details

# Check your SSL/TLS settings

First of all, start a Firefox instance with a clean profile. In your current instance and clean instance, compare the results of the `about:config` pages. Search on "https", "ssl", and "tls". Check if you have any keys that deviate from the defaults, shown in *bold*, and reset them.

# Clear your local caches

Go to `%localappdata%\mozilla\firefox`. You can find a folder there called "Profiles". You can delete this. It only contains cached data.

After deleting everything should be working again.

Happy browsing!
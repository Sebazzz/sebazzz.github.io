---
layout: post
title:  "Introducing the FiddlerFox add-on"
date:   2017-10-18 10:00:00 +0100
categories: development firefox webextensions add-on
---

Today I like to announce my first Firefox WebExtension add-on: [FiddlerFox](https://addons.mozilla.org/nl/firefox/addon/fiddlerfox/). It allows better integration of Firefox with the Fiddler web debugger.

## What problem does it solve?
Firefox uses its own proxy settings instead of the OS-native proxy settings. The proxy settings from the OS are loaded when Firefox starts, but never refreshed afterwards. 

This poses a problem when you start Fiddler after you start Firefox. When Fiddler is enabled, it modifies the system proxy settings so that Fiddler is used as a proxy. Firefox does not notice this change, and keeps using whatever proxy was configured when it started.

Until this extension was developed, you needed to fiddle with the proxy settings buried deep in the Firefox menu, or restart the browse which is quite annoying during development with numberous of tabs and windows open.

### What's up with FiddlerHook?
Fiddler installs [FiddlerHook](http://docs.telerik.com/fiddler/knowledgebase/fiddlerhook), a local Firefox extension for detecting the presence of Fiddler and automatically enabling direction to Fiddler.

This extension is however not signed (causing issues) and is a "legacy" XPCOM extension which will be unusable from Firefox 57 onwards.

## How does it work
The extension works quite simple, once installed from [Mozilla Add-ons](https://addons.mozilla.org/nl/firefox/addon/fiddlerfox/), you get an icon in the toolbar of Firefox. 

When clicked, a checkmark will be shown and Firefox will use the local Fiddler instance at port 8888 for connecting to the web. To disable it, click the button again. 

## Download
You can download the extension directly from [Mozilla Add-ons](https://addons.mozilla.org/nl/firefox/addon/fiddlerfox/). The source code is available on [GitHub](https://github.com/Sebazzz/fiddlerfox).
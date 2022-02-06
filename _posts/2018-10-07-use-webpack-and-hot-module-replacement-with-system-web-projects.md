---
layout: post
title:  "Use Webpack and Hot Module Replacement with System.Web (ASP.NET) projects"
date:   2018-10-07 19:00:00 +0100
categories: asp.net webpack node.js system.web
---

[Webpack](https://github.com/webpack/webpack/) is an tool that is used for module bundling: Compiling multiple javascript modules with their dependencies to one or more executable files. This has worked very well for me in my ASP.NET Core side projects like [IFS](https://github.com/Sebazzz/IFS) and [Financial App](https://github.com/Sebazzz/financial-app). 

Webpack has two components that are very useful during development: The **webpack dev server**, and **hot module replacement**. The webpack dev server compiles needed bundles automatically when requested or sources are changed, so you are always served the latest files when requesting a site. Hot module replacement allows parts of your module to be automatically replaced when they are changed on the server. This is especially useful for single page applications where you don't want to reboot the entire app when a single part is updated.

ASP.NET Core has built-in support for using these webpack components through [Microsoft.AspNetCore.JavascriptServices](https://github.com/aspnet/JavaScriptServices). Under the hood this middleware automatically starts webpack and delegates some requests to webpack. This enables the webpack dev server and HMR to do its job. 

## What about ASP.NET?
Webpack support only exists in ASP.NET Core, there is no real equivalent package on for the older ASP.NET framework. 

Unfortunately, not every project I am involved in uses ASP.NET Core. There is an awful lot of code written on the older and mature [ASP.NET framework](https://www.asp.net/get-started/framework) (also known by its primary namespace [System.Web](https://docs.microsoft.com/en-us/dotnet/api/system.web)) only available on the full .NET framework. It is non-trivial to port these projects to ASP.NET Core.

For this reason I developed an System.Web counterpart of Microsoft.AspNetCore.JavascriptServices: [**SystemWebpack**](https://www.nuget.org/packages/SystemWebpack/). This allows you to fully use the Webpack dev server and hot module replacement in System.Web projects. This works even on IIS. 

Sample ASP.NET Web Forms website with HMR in action:

![Webpack HMR running under an legacy ASP.NET sample project](/images/blog/2018-10-07-use-webpack-and-hot-module-replacement-with-system-web-projects/primary.png)

Note that for HMR to work in Microsoft Edge you need to use an `EventSource` polyfill, Microsoft Edge does [not support](https://developer.microsoft.com/en-us/microsoft-edge/platform/status/serversenteventseventsource/?q=eventsource) server-sent events.

*Sidenote: How we call non-Core ASP.NET projects without potential confusion? "System.Web projects", "classic ASP.NET", "legacy ASP.NET"?*

## How to use

To use the package, install SystemWebpack and WebActivatorEx [from NuGet](https://www.nuget.org/packages/SystemWebpack/):

    Add-Package SystemWebpack
    Add-Package WebActivatorEx

Then follow the steps in the [readme (Usage)](https://github.com/Sebazzz/SystemWebpack#usage) to set it up in your own project.

Also check out the [ASP.NET Web Forms sample application](https://github.com/Sebazzz/SystemWebpack/tree/master/src/SystemWebpackTestApp).

Happy coding!




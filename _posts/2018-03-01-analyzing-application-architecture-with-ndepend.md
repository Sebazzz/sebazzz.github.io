---
layout: post
title:  "Analyzing application architecture with NDepend"
date:   2018-03-01 10:00:00 +0100
categories: development
---

As an application ages building up some technical debt is inevitable. Some technical debt cannot be measured (because it is subjective, like "that table structure is hard to query"). Other technical debt like method length or cyclomatic complexity can be measured, and this is where [NDepend](https://www.ndepend.com/) comes in. In this article we will explore NDepend on one of my open-source projects, [financial-app](https://github.com/Sebazzz/financial-app/tree/1167ad014102fb1859af04052546c8ea068c04e9).

**Disclaimer:** In full disclosure, I was contacted by Patrick in August 2017 of the NDepend Support team to write about my experience with NDepend. Please note though that this blog post is entirely my own opinion. (Also thanks for Patrick to give me the time to write this article besides raising my two kids)

NDepend allows you to measure the technical debt using various built-in but customizable rules. NDepend essentially exposes your code base as a set of objects which you can query using regular LINQ. For the purpose of code analysis this is called *CQLinq* (code query LINQ).  **So, how does did work? Let's walk through it.** You can repeat what I have done here if you check out the code from the link above and using NDepend *2017.3 or above*.

As you can already guess from its purpose, NDepend is *not* something your would give your average junior developer. Instead, use NDepend as a senior developer to manage the technical debt of the project over time and determine which action to take to decrease the technical debt. In that sense it can be used as a tool to support project management.

## Analyzing the project
We start with selecting the files we want to analyse. Since this project contains just one assembly,
 
![Select files to analyze](/images/blog/2018-03-01-analyzing-application-architecture-with-ndepend-01.PNG)

Note you can tweak the technical debt calculation in various ways. At my employer, our client rate is 120 euro per hour per developer, so I was able to enter that in the application. 

![Tweak technical debt calculation](/images/blog/2018-03-01-analyzing-application-architecture-with-ndepend-02.PNG)

Now use the "play" or "play and report" buttons to let NDepend analyse the project.

NDepend will take some time to analyse the project. Even on my not-too-fast notebook this was done within a minute. You will be greeted with a dialog that will give you a few actions you can take.

![What to do? NDepend will help you.](/images/blog/2018-03-01-analyzing-application-architecture-with-ndepend-03.png)

The dashboard is a nice feature of NDepend as it allows you to view the trends regarding technical debt over time. It would be nice if a one-time import from version control would exist, but if you start using it now you can use your build server to generate NDepend analysis. 

![Dashboard](/images/blog/2018-03-01-analyzing-application-architecture-with-ndepend-03b.png)

Note the chart on the right hand side, which will over time show the progress you're making cleaning up technical debt.

So, in this case I have several high-priority issues. By clicking on the number I get an overview of the rules which are suggested to be "high priority".

![Rules](/images/blog/2018-03-01-analyzing-application-architecture-with-ndepend-03c.png)

These priorities and the rules themselves are built-in, but if you don't like them or want to modify them you can. You can then save the rules in the project or in an external file to share it with other projects.

In this case NDepend didn't like that I named my data transfer objects the same as my entities. So I could just exclude the rule from the rule explorer:

![Rules exclusion](/images/blog/2018-03-01-analyzing-application-architecture-with-ndepend-03d.png)

But the rule is actually useful. A better option is to edit the rule so that the namespace is excluded.

![Rules exclusion](/images/blog/2018-03-01-analyzing-application-architecture-with-ndepend-03e.png)

Thanks to live evaluation and autocompletion it is easy to develop new rules when necessary.

![Rule development](/images/blog/2018-03-01-analyzing-application-architecture-with-ndepend-04.png)

Stay tuned for the next blog!
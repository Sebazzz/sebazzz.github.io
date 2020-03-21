---
layout: post
title:  "PokerTime: a planning poker app built in ASP.NET Core and Blazor"
date:   2020-03-21 10:00:00 +0200
---

By now the new corona virus, or SARS-CoV2, has spread around the world like a pandemic. Sadly, many people in the Netherlands are infected as well. My employer has asked everyone who can work from home, to do so. As for myself, I also had a bit of a cough so I didn't mind staying indoors. With not much to do and a new sprint starting on monday, I went on to creating a planning poker application. Introducing: [**PokerTime**](https://github.com/Sebazzz/PokerTime), a realtime collaborative planning poker app built in ASP.NET Core and Blazor. 

This is how it looks:

![PokerTime in action](https://raw.githubusercontent.com/Sebazzz/PokerTime/e9f93ffe3346851ed5d8b3290ad58bd153e694ae/doc/estimation.png)

## Features

The app contains a basic set of features to allow real-time estimations:

-   Realtime app, ideal for remote teams. We already had a test run on last monday and it worked perfectly!
-   Create password protected poker sessions
-   As facilitator, lead the poker session through the discussion and estimation.

## Architecture
I have based this application on [Return](/blog/2019/12/14/return-a-retrospective-app), so I refer to the [general architecture of Return](/blog/2019/12/14/return-a-retrospective-app#architecture) for more information. 

To summarize it: It has been built using CQRS and a test-driven approach.

## Blazor
As a UI framework I used Blazor. This is the first time I've used Blazor so I certainly had some lessons to learn. Blazor is a - in my case - framework that runs on the server and maintains a persistent connection with the client using web sockets. This has some impact on that might catch you by suprise.

## Where to download and view the source

I have published the source code under GPLv3.0 on [Github](https://github.com/Sebazzz/PokerTime). 
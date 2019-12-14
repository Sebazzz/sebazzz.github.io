---
layout: post
title:  "Return: a retrospective app built in ASP.NET Core and Blazor"
date:   2019-12-14 18:00:00 +0200
---

In .NET Core 3.0 Microsoft introduced a new framework to compete with existing web frameworks like Angular and React. I decided to put it to the test and build a retrospective app with it, October of this year. Introducing: [**Return**](https://github.com/Sebazzz/Return), a retrospective app built in ASP.NET Core and Blazor. 

This is how it looks:

![Return in action](https://raw.githubusercontent.com/Sebazzz/Return/f73fbe80dae85a3c5b88d31e73870c48b5e88438/doc/writing.png)

## Features

The app has many features you'd expect in a retrospective app. There are many paid options which also provide this feature set.

-   Realtime retrospective app, ideal for remote teams
-   Shortcut support:
    -   Ctrl + lane number for adding notes or groups
    -   Ctrl + delete for deleting focused note
-   Create password protected retrospectives
-   As facilitator, lead the retrospective through the writing, grouping and voting phase.
-   Overview with highest voted items

## Architecture
I have built Return using the [clean architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html) [(video about implementing this in ASP.NET Core)](https://www.youtube.com/watch?v=_lwCVE_XgqI) pattern (if you can call it a pattern).  It is essentially based on a separation of concerns between the domain and architecture layers, which contain the business logic, and the outer layers which contain the infrastructure and presentation like the persistence logic and web application rendering.

*Please find a diagram on the linked post of Robert C. Martin.*

### Tests
Using this pattern I was quickly able to build this retrospective app while writing tests. At point of writing the application has about 140 tests, with 114 tests being unit tests for the application layer.  The rest are tests for the other layers like the domain and website, with about 26 being full end-to-end Selenium tests. Return is tested with every check-in by continuous integration via AppVeyor, CircleCI and Github Actions. 

The unit tests use the in-memory provider of Entity Framework to "mock" data retrieval. Besides that NSubstitute is used for mocking of dependency-injected objects. The integration tests use SQLite as a database provider for Entity Framework.

### CQRS
Using the *Mediator* library, the application uses CQRS for much of the internal communication. Command/query response segregation allows the handler of a query or invocation to be separate of the call of that command or query. This allows for middleware (like performance analysis, retry logic, validation logic) to be injected between handler and invocation and entirely decouples handler from caller. It prevents the need for injecting *many* dependencies because you only need to inject the mediator object.

CQRS is used for both interactively and real-time updating of the UI and for getting the data for the UI. Validation is handled between middleware. Performance logging is also handled by middleware.

## Blazor
As a UI framework I used Blazor. This is the first time I've used Blazor so I certainly had some lessons to learn. Blazor is a - in my case - framework that runs on the server and maintains a persistent connection with the client using web sockets. This has some impact on that might catch you by suprise.

### Dependency lifetime
In particular, as [also documented](https://docs.microsoft.com/en-us/aspnet/core/blazor/lifecycle?view=aspnetcore-3.0), the lifecycle of a component is tied for the duration of the request as long as it is rendered. If you inject, directly or indirectly, a `DbContext` it will be kept alive for the duration of that component. As the `DbContext` by default (unless you use `AsNoTracking`) caches the materialized entities you will run into issues where you appear to have a stale cache. 

I solved that by creating a new `DbContext` for the command/query handlers that needed it. While there is also a [`OwningComponentBase`](https://docs.microsoft.com/en-us/aspnet/core/blazor/dependency-injection?view=aspnetcore-3.0#utility-base-component-classes-to-manage-a-di-scope) this doesn't work well for this scenario because it creates an additional `DbContext` which has its own database connection and needs to be kept alive. If you would have 10 components like that you'd need 10 database connections. 

### (The lack of) usage of javascript
Blazor allows you to use regular C# when you'd usually use javascript. You can listen to all kinds of events on most HTML elements. I almost didn't write any javascript for this application. The only javascript I wrote is for

1. Drag-and-drop compatibility in Mozilla Firefox. My favourite browser apparently needs to have some additional handling for drag-and-drop, otherwise a navigation happens on drop.
2. Global keyboard shortcuts. This requires to attach to `document` which is not natively possible in Blazor.
3. Auto-expanding textareas. In the app the notes have textareas in them which expand automatically. It is not possible to read DOM properties like `clientHeight` efficiently in Blazor so I wrote some javascript for this as well. 

As you see, the javascript I wrote is used for scenarios which you could consider to be edge cases. The rest of the interactivity is handled by the server as far as the code is concerned. Even the drag and drop logic is completely handled on the server. 

### Real-time updates

Because each Blazor components exists in the memory of the web server while the connection to the client exists, it is very easy to add real-time elements to your component. You simply need to keep a (weak) reference to your component to call methods for it. 

Within the component you need to marshal the call to the synchronization context of the component and finally call `OnStateChanged`. Blazor will then push any changes in the rendering of the component to the client. No javascript or manual creating of SignalR hubs required.

## Where to download and view the source

I have published the source code under GPLv3.0 on [Github](https://github.com/Sebazzz/Return). 
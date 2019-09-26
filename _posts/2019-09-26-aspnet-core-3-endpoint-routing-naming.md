---
layout: post
title:  "ASP.NET Core 3.0 Endpoint routing naming and link generation"
date:   2019-09-26 20:00:00 +0200
---

ASP.NET Core 3.0 introduced endpoint routing as a first class citizen. You can easily create endpoints and map them to your own `RequestDelegate` that will process the request. It is however not apparent how you can name your endpoints so you can reference them elsewhere, like in routing and link generation.

I upgraded my [IFS](https://github.com/Sebazzz/IFS) project to ASP.NET Core 3.0 with endpoint routing. In the project I use a handler that will take the HTTP upload request and process it. 

I mapped the endpoint like this: 

``` C#
app.UseEndpoints(endpoints =>
{
    endpoints.Map("upload/handler/{fileIdentifier}", UploadHandler.ExecuteAsync)
	// [...]
    endpoints.MapControllers();
    endpoints.MapDefaultControllerRoute();
});

```

However, I couldn't reference this endpoint from a form or any other place where I needed link generation: 

``` HTML
<form asp-route="????" />
```

None of the overloads of the `endpoints` object support naming, nor does the `IEndpointConventionBuilder` that is returned from the `Map` call. I downloaded the MVC source code, and explored how any routing attributes where added to the endpoint mapping. 

To name your endpoint, you need to attach metadata to it using the `IEndpointConventionBuilder`. You need `EndpointNameMetadata` and `RouteNameMetadata` which both accept a name as string.

You can use it like this:

``` C#
endpoints.Map("upload/handler/{fileIdentifier}", UploadHandler.ExecuteAsync)
         .WithMetadata(
			new EndpointNameMetadata("UploadHandler"),
			new RouteNameMetadata("UploadHandler")
	     )
```

The `RouteNameMetadata` metadata is used when creating routes and `EndpointNameMetadata` when using the `GetByName` method of the `LinkGenerator` class. You can create an extension method for convenience:

``` C#
public static IEndpointConventionBuilder WithName(this IEndpointConventionBuilder endpointBuilder,string endpointName)
{
    return endpointBuilder.WithMetadata(
                new EndpointNameMetadata(endpointName),
                new RouteNameMetadata(endpointName)
           );
}
```

Which allows you to: 

``` C#
endpoints.Map("route/to/handler/{routeArgument}", MyHandler.ExecuteAsync)
         .WithName("MyHandler")
```

And then:

``` HTML
<a asp-route="MyHandler"></a> <!-- or: -->
<form asp-route="MyHandler"></form>
```

I hope this helps anyone who runs into the same issue. Happy coding!
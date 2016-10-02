---
layout: post
title:  "Using ASP.NET Custom Errors with ASP.NET MVC Controllers or HTTP handlers"
date:   2016-09-30 20:00:00 +0200
categories: asp-net development
---

ASP.NET has built-in error handling that allows certain HTTP errors to be redirected to other pages in an web application. You can for example show friendly messages when an HTTP 500 error occurs, or more likely, when an HTTP 400 (*Bad Request*, caused by ASP.NET request validation) occurs. This can cause issues however if you're using `ResponseRewrite` and want to rewrite the response to a custom `IHttpHandler` or MVC controller action.

I'm not very fond of doing an actual *redirect* in the form of *302 Found* when such issue occurs. It breaks browser history and it is semantically incorrect. Fortunately, since ASP.NET 4.0 it is possible to specify an `redirectMode` in the `customErrors` element:

{% highlight XML %}
<customErrors redirectMode="ResponseRewrite">
   <!-- ... -->
</customErrors>
{% endhighlight %}

This allows ASP.NET to replace the existing request, with an entire new request to the page specified in the `customErrors` element. Is is [done by calling](https://referencesource.microsoft.com/#System.Web/HttpResponse.cs,2471) [`HttpServerUtility.Execute`](https://msdn.microsoft.com/en-us/library/23e7sy74(v=vs.110).aspx). This works great when you want to rewrite the response to an static file or rewrite the response to an WebForms page!

It doesn't however work when you want to use an custom `IHttpHandler` or want to redirect to an ASP.NET MVC controller action.  In my case, I needed to let the errors be handled by an HTTP handler, others by an ASP.NET MVC controller action. This didn't work, and the error message shown wasn't helpful either:

![Not so helpful are you ASP.NET?](/images/blog/2016-09-30-aspnet-customerrors-to-httphandler-mvc-controller-fail.png) 

After several debug sessions in Visual Studio, [triggering when an System.Web.HttpException is thrown](https://msdn.microsoft.com/en-us/library/x85tt0dd.aspx), I found out the root cause. The Server.Execute method, internally checks whether the [target handler](https://referencesource.microsoft.com/#System.Web/httpserverutility.cs,515) of the path is either a static file or Web Forms `System.Web.UI.Page`. This is also the reason `Server.Transfer` also doesn't map to a 

No wonder I wasn't able to call my handler or ASP.NET MVC controller!

The workaround is easy though, simply derive from `System.Web.UI.Page` and override the `ProcessRequest` method. From within your handler you can either do the work you want, or call another handler using `TransferRequest`.

{% highlight C# %}
public class MvcProxyHandler : Page {
    public override void ProcessRequest(HttpContext context) {
        string route = context.Request.QueryString["Route"];
        context.Server.TransferRequest(route, false);
    }
}
{% endhighlight %}

In your web.config file:

{% highlight XML %}
<system.web>
  <customErrors redirectMode="ResponseRewrite" mode="On">
    <error statusCode="404" redirect="~/MvcProxy.axd?Route=/Test/Error" />
  </customErrors>
</system.web>

<system.webServer>
  <handlers>
    <add name="MvcProxyHandler" path="MvcProxy.axd" allowPathInfo="true"
          type="MyAssembly.MvcProxyHandler, MyAssembly" preCondition="integratedMode"
          verb="GET,HEAD,POST,PATCH,PUT,DELETE,OPTIONS" />
  </handlers>
</system.webServer>
{% endhighlight %}
---
layout: post
title:  "How-to: Run an ASP.NET Core application on Windows 10 IoT"
date:   2017-06-30 22:00:00 +0100
categories: sql development
---

So I recently bought a second raspbery pi to start experimenting with Windows 10 IoT. As it happens, .NET Core is not actually supported nor endorsed anywhere. But it is actually possible to run an ASP.NET Core application on Windows IoT Core. This article will tell you how! 

## Prequisites

To follow this guide, ensure you have a working Raspberry PI with Windows 10 IoT Core. Ensure you have remote Powershell and SMB enabled.

## Installing the preview bits

Download and install the .NET Core 2.0 Preview 2 bits from [GitHub](https://github.com/dotnet/core/blob/master/release-notes/download-archives/2.0.0-preview2-download.md). Use the installer appropiate for your current operating system. .NET Core 2.0 is the first version which distributes the native Windows 10 ARM packages on NuGet.

**Note:** .NET Core 2.0 is in preview stage at this moment, and does not have any official on ARM yet. Do not use this guide for production purposes.

## Creating your project

First, verify you actually run the latest .NET bits:

    C:\temp> dotnet --version
    2.0.0-preview2-006497

Create a project, choose a template of your liking. In this case I choose the default 'web' template which creates a regular MVC application.

```
C:\temp> dotnet new web --name MyIotApp --output iot-asp
The template "ASP.NET Core Empty" was created successfully.
This template contains technologies from parties other than Microsoft, see https://aka.ms/template-3pn for details.

Processing post-creation actions...
Running 'dotnet restore' on iot-asp\MyIotApp.csproj...
  Restoring packages for C:\temp\iot-asp\MyIotApp.csproj...
  Installing Microsoft.IdentityModel.Logging 1.1.3.
  Installing Microsoft.IdentityModel.Tokens 5.1.3.
  [...]
  Installing Microsoft.Data.OData 5.8.2.
  Installing System.Spatial 5.8.2.
  Generating MSBuild file C:\temp\iot-asp\obj\MyIotApp.csproj.nuget.g.props.
  Generating MSBuild file C:\temp\iot-asp\obj\MyIotApp.csproj.nuget.g.targets.
  Restore completed in 9,66 sec for C:\temp\iot-asp\MyIotApp.csproj.

Restore succeeded.
```

Now we want to ensure we can publish to Windows 10 IoT Core. The appropiate runtime identifier is `win10-arm` since it is a 32-bit ARM installation. Add the `RuntimeIdentifiers` node as follows:

```
  <PropertyGroup>
    <TargetFramework>netcoreapp2.0</TargetFramework>
	<RuntimeIdentifiers>win10-arm</RuntimeIdentifiers>
  </PropertyGroup>
```

After you've edited the project file, we can restore the packages and publish the project.

```
C:\temp> cd .\iot-asp\
C:\temp\iot-asp> dotnet restore
  Restoring packages for C:\temp\iot-asp\MyIotApp.csproj...
  Restore completed in 2,81 sec for C:\temp\iot-asp\MyIotApp.csproj.
C:\temp\iot-asp> dotnet publish --self-contained --runtime win10-arm --output build
Microsoft (R) Build Engine version 15.3.388.41745 for .NET Core
Copyright (C) Microsoft Corporation. All rights reserved.

  MyIotApp -> C:\temp\iot-asp\bin\Debug\netcoreapp2.0\win10-arm\MyIotApp.dll
  MyIotApp -> C:\temp\iot-asp\build\
C:\temp\iot-asp>
```

## Launching the application on the Raspberry PI

Copy the files from the `build` directory to the Raspberry PI. Log in remotely using Powershell and launch it.
In my case I placed the application in `C:\temp\build`.

```
[damberry]: PS C:\> cd .\Temp\build

[damberry]: PS C:\Temp\build> $env:ASPNETCORE_URLS="http://0.0.0.0:5000"

[damberry]: PS C:\Temp\build> .\MyIotApp.exe
The environment variable 'ASPNETCORE_SERVER.URLS' is obsolete and has been replaced with 'ASPNETCORE_URLS'
Hosting environment: Production
Content root path: C:\Temp\build
Now listening on: http://0.0.0.0:5000
Application started. Press Ctrl+C to shut down.
info: Microsoft.AspNetCore.Hosting.Internal.WebHost[1]
      Request starting HTTP/1.1 GET http://damberry:5000/  
info: Microsoft.AspNetCore.Hosting.Internal.WebHost[2]
      Request finished in 367.2286ms 200 

[damberry]: PS C:\Temp\build> 
```

We first configure the URL to run the application under. By default it listens to `localhost` but since we want to access it remotely we must point it to `0.0.0.0`.

Visit `http://<dnsname>:5000` and you get your first response:

![ASP.NET Core on Windows 10 IoT Core](/images/2017-06-30-how-to-run-aspnet-core-application-on-windows-iot.png)

Happy coding!
---
layout: post
title:  "Temporary overriding a PackageReference bin path"
date:   2020-05-29 10:00:00 +0200
---

.NET projects offer `<PackageReference>` items which are used for including NuGet packages in your project. However, the `<PackageReference>` is quite black-box at first sight, and does not allow overriding the binary path in case you'd like to temporary use locally built binary. You may need it if public symbols are not available.

You can use the snipped below in your `csproj` file or any `Directory.Build.targets` to override the binary path of the NuGet package reference. This example is for LibGit2Sharp.

``` XML
<Target Name="ReplaceReference" AfterTargets="ResolveLockFileReferences">
<ItemGroup>
  <Reference Remove="$(USERPROFILE)\.nuget\packages\libgit2sharp\0.26.0\lib\net46\LibGit2Sharp.dll"/>
  <Reference Include="$(USERPROFILE)\.nuget\packages\libgit2sharp\0.26.0\lib\net46\LibGit2Sharp.dll">
	<HintPath>c:\some\path\bin\LibGit2Sharp\Debug\net46\LibGit2Sharp.dll</HintPath>
  </Reference>
</ItemGroup>
</Target>
```

Good luck!
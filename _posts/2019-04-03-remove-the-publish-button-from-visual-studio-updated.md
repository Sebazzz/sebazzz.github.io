---
layout: post
title:  "Updated for 2019: Remove the 'Publish' button from the Visual Studio status bar"
date:   2010-04-03 20:00:00 +0200
---

In Visual Studio 2015 and git is integrated and this includes an button to create a Git repository and/or to publish it to Github. This is nice if you use git. However, when you *don't* use git, this button is annoying. Therefore I have [earlier developed an extension](/blog/2016/07/23/remove-the-publish-button-from-visual-studio) to hide the button from the Visual Studio status bar.

![Visual Studio publish button](/images/blog/2016-07-23-remove-the-publish-button-from-visual-studio-vs.png)

It is now 2019 and yesterday Visual Studio 2019 was released so by popular request I updated the extension to include Visual Studio 2019 support.

## Challenges

Some APIs were deprecated in Visual Studio 2019. This essentially includes all API's which run synchronously during solution load. The users of your extension are also confronted with this deprecation: Essentially a big mark of shame is shown once the extension is loaded, clicking through to the extension manager shows that the extension uses deprecated API's "which may be removed in future versions of Visual Studio".

In my case, I needed to mark my extension as asynchronous loadable and inherit from `AsyncPackage` instead of `Package`. I also need UI access, because that is the point of my package, so I often needed to switch explicitly to the UI thread:

	if (ThreadHelper.CheckAccess() == false) {
	    await this.JoinableTaskFactory.SwitchToMainThreadAsync(cancellationToken);
	}

The Roslyn analyzers provided in the SDK are very helpful in this regard. So, code-wise I was done.

The project didn't compile anymore though, build errors started to occur:

    Error CS1748: Cannot find the interop type that matches the embedded interop type 'Microsoft.VisualStudio.Shell.IAsyncServiceProvider'

Whatever I did, which NuGet or local package I referenced, I couldn't fix this build issue. But then I found a solution: Create an empty extension project and copy the relevant parts back to my project. This meant replacing references which were added by `packages.config` by `<PackageReference>`. This fixed the build for me.

## Download

The updated extension can be downloaded at the [Visual Studio Extension Gallery](https://visualstudiogallery.msdn.microsoft.com/6e8c558f-b681-4a6a-931b-4efb04714364) and the source code can again be found [on Github](https://github.com/Sebazzz/VsRemovePublishButton).

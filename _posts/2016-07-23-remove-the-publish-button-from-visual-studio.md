---
layout: post
title:  "Remove the 'Publish' button from the Visual Studio status bar"
date:   2016-07-23 20:00:00 +0200
---

In Visual Studio 2015 git is integrated and this includes an button to create a Git repository and/or to publish it to Github. This is nice if you use git. However, when you *don't* use git, this button is annoying. Therefore I have developed an extension to hide the button from the Visual Studio status bar.

![Visual Studio publish button](/images/blog/2016-07-23-remove-the-publish-button-from-visual-studio/vs.png)

My main annoyances with the button:

1. When clicked it instantly spawns a git repository in your project directory. This is annoying if you're already using a VCS. At work I use Subversion, so I don't need to have a Git repo inside my SVN repository.
2. The button is poluting the status bar.

In order to hide this button I've developed a small Visual Studio extension to hide the publish button. Thanks to the SDK of Visual Studio it is possible to extend the environment easily and develop an extension within a fairly short period of time.

The extension allows configuration whether to hide the publish button by default or not:
![Screenshot](/images/blog/2016-07-23-remove-the-publish-button-from-visual-studio/screenshot.png)

## Download

The extension can be downloaded at the [Visual Studio Extension Gallery](https://visualstudiogallery.msdn.microsoft.com/6e8c558f-b681-4a6a-931b-4efb04714364) and the source code can be found [on Github](https://github.com/Sebazzz/VsRemovePublishButton).



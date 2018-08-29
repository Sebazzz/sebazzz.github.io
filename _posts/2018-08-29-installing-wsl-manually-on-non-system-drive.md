---
layout: post
title:  "How-to: Installing WSL manually on a non-system drive"
date:   2018-08-29 19:00:00 +0100
categories: windows linux wsl
---

Windows 10 introduced the excellent [Windows Subsystem for Linux](https://en.wikipedia.org/wiki/Windows_Subsystem_for_Linux) also known under the names of WSL, lxss, "Bash on Ubuntu on Windows" and perhaps more names. Traditionally, in the preview, there was only Ubuntu and the name it was called is "Bash on Ubuntu on Windows". It installed to the `%LOCALAPPDATA%\lxss` folder, which usually resides on your system drive. When finally the Windows Store was introduced to allow downloading more Linux distributions, new Linux on Windows installations were done in `%LOCALAPPDATA%\[package name]\rootfs`.

After several months playing with Linux and also installing a lot of tools to use when [fiddling with x86 assembly language](https://github.com/Sebazzz/sdos) to create a basic OS kernel, my system drive got full and I was forced to uninstall WSL. Unofficially, it is possible to install WSL on a non system drive. Follow this guide to do that.

## Guide: Installing WSL manually on a non-system drive

### 1. Enable the WSL subsystem.

If you have not done, enable the Windows subsystem. Open an elevated Powershell command prompt and run:

    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux

Promptly, the results will be shown of the installation:

    Path          :
    Online        : True
    RestartNeeded : False

Reboot if indicated. In my case I already had it installed, so I didn't need to reboot.

### 2. Create an installation directory

Choose and create a directory where to install your Linux distribution.

    New-Item A:\Ubuntu -ItemType Directory
    Set-Location A:\Ubuntu

### 3. Download a Linux distribution

The Microsoft Windows documentation [contains a list of Linux distributions](https://docs.microsoft.com/en-us/windows/wsl/install-manual#downloading-distros) you can download. In my case, I choose Ubuntu.

    Invoke-WebRequest -Uri https://aka.ms/wsl-ubuntu-1604 -OutFile Ubuntu.appx -UseBasicParsing

Lets extract it:

    Rename-Item .\Ubuntu.appx Ubuntu.zip
    Expand-Archive .\Ubuntu.zip -Verbose

In the above example a directory was created: `A:\Ubuntu\Ubuntu`.

### 4. Install the Linux distribution

In the extracted directory you will find an `.exe` file that allows installing your linux distribution. In my case, it was `ubuntu1804.exe`. Simply run it in your current command line shell and installation will start.

    Installing, this may take a few minutes...
    Please create a default UNIX user account. The username does not need to match your Windows username.
    For more information visit: https://aka.ms/wslusers
    Enter new UNIX username: sebazzz
    Enter new UNIX password:
    Retype new UNIX password:
    passwd: password updated successfully
    Installation successful!

Don't attempt to find the command-line options by calling `ubuntu1804.exe /?` because it will immediately install to `<directory>\rootfs`. 

### 5. Use your new installation

To use your installation, simply call `ubuntu1804.exe`. If this is the only or first Linux distribution you have installed you can also enter it by calling `bash`. 

To change the default Linux distribution, use `wslconfig`:

    PS A:\Ubuntu\Ubuntu> wslconfig /list /all
    Windows Subsystem for Linux Distributions:
    Ubuntu-18.04 (Default)

Happy playing!

P.S.: If you like to try out some GUI programs on WSL, my guide on [using GUI programs on WSL](https://damsteen.nl/blog/2016/08/20/run-gui-programs-on-bash-on-ubuntu-on-windows) is still valid. Though not officially supported, it still works on Windows 10 1803.
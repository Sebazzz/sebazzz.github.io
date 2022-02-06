---
layout: post
title:  "Run GUI programs on Bash on Ubuntu on Windows"
date:   2016-08-20 10:00:00 +0200
---

Since the Anniversary update of Windows 10 it is possible to run an emulated version of Ubuntu on Windows. The access point to Ubuntu is Bash. You can read more about it [on MSDN](https://msdn.microsoft.com/en-us/commandline/wsl/about). But did you know it is also possible to run GUI programs, like Firefox? This article will give short instructions how to run GUI programs.

## Prerequisites
Make sure you got [Bash on Ubuntu on Windows](https://msdn.microsoft.com/en-us/commandline/wsl/install_guide) installed on your computer.

Also install [XMing](https://sourceforge.net/projects/xming/), an X Server implementation for Windows.

## Enabling GUI programs

### Preparing the emulated environment
Open bash and edit ~/.bashrc:

```
nano ~/.bashrc
```

At the end of the file, add the code shown below. This will define an environmental variable which will cause graphical programs to connect to an X server at localhost. 

```
[ -z $DISPLAY ] && DISPLAY=localhost:0.0 && export DISPLAY
```

Next install an graphical program, like Firefox or xeyes:

```
apt-get install x11-apps
apt-get install firefox
```

Exit bash, because the modifications in `.bashrc` won't be applied in the current session.

### Setting up XMing
XMing comes with an application called "XLaunch". This will run the X Server. Start XLaunch from the installation folder or the start menu of Windows.

A wizard will be started. At the first page you can select which mode XMing will launch in.

![First page of XMing](/images/blog/2016-08-20-run-gui-programs-on-bash-on-ubuntu-on-windows/xming-launch.png)

The default option, selected in this screenshot, will allow programs to run seamlessly side-by-side.

The next page allows you to select how XMing will work. Since we'Il launch programs from the command line, we need to select the first option here.

![Second page of XMing wizard](/images/blog/2016-08-20-run-gui-programs-on-bash-on-ubuntu-on-windows/xming-2nd.png)

On the third page of the wizard, keep the default settings. After that, you'Il be able to launch XMing, which will be visible in your system tray:

![XMing in system tray](/images/blog/2016-08-20-run-gui-programs-on-bash-on-ubuntu-on-windows/xming-tray.png)

### Running programs
Start bash again, and run a program by typing its command on the command line. If you type '&' after the command, it'Il fork and doesn't block the command line.

```
xeyes&
firefox&
```

And tadaa: Firefox running on Ubuntu on Windows!

![XMing in system tray](/images/blog/2016-08-20-run-gui-programs-on-bash-on-ubuntu-on-windows/working.png)





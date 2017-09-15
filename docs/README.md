# Use docker and X11 forwarding to develop and test ucore_os

## Docker

### Download and install docker

Follow the Guide of [docker official website](www.docker.com) to get docker for your own operating system. If you are in China, this method is not good because of GFW. So enter [Daocloud Docker Download Channel](http://get.daocloud.io), you can find a better way to download docker.

**Tips: **

- be sure to use China docker mirror to accelerate docker while you are in docker, more details can see [here](https://www.daocloud.io/mirror). For using docker accelerator, you need to sign up an account. However, it's worth it since the accelerator is free forever after your signing up.
- Your version of  Docker for Mac must higher then 17.06

### Volume configuration for docker in Windows and MacOS

#### Windows

Open the Settings of Docker for Windows, go to 'Shared Drives' tab, make sure your projects' root drive is in the shared drives list as below:

![shared-drives-windows](./img/shared-drives-windows.png)

#### MacOS

Open the Preferences of Docker for Mac, make sure your projects' root folder is in the File sharing list as below:

![file-sharing-mac](./img/file-sharing-mac.png)

## Prerequirements

### Linux

You'll need to allow the xhost access by using `xhost + loacl:root`

### MacOS

For receive X11 forwarding, You’ll need [XQuartz](https://www.xquartz.org/), and normally you would probably install it via [brew](http://brew.sh/) (but not this time):

```
$ brew cask install xquartz
```

XQuartz 2.7.11 is recommended, while XQuartz 2.7.9, which is the current one provided by brew, has a bug which will prevent you from following this guide.

After installing XQuartz, log out and back in to OS X.

Run XQuartz in e.g. bash:

```
open -a XQuartz

```

In the XQuartz preferences, go to the “Security” tab and make sure you’ve got “Allow connections from network clients” ticked:

![xquartz_preferences](./img/xquartz_preferences.png)

### Windows

You will need to install an X server for Windows. I went for [Vcxsrv](https://sourceforge.net/projects/vcxsrv/) and [Xming](https://sourceforge.net/projects/xming/). The `DISPLAY` environment variable points by default to 10.0.75.1:0.0. If you use docker on Windows 10, this should be ok.

I found Xming has better performance than Vcxsrv, so next is a tutorial of Xming.

after fully installing Xming, open `XLaunch.exe`, follow the default steps until the 'Specify parameter settings'. You should choose 'No Access Control' as below:

![xming](./img/xming.png)

## Use

Firstly, you should build `ucore` image and run `ucore-container` container by using

```
$ make init
```

use `docker ps` you can see a docker container called `ucore-container`.

use

```
$ make exec
```

you can enter the container. So the environment is ok, you can use this as a virtual machine to develop and test ucore_os.

By detach the container, just type `exit`. While you want to go back into the container, also type `make exec`.

For stop the container for removing it, just type

```
$ make stop
```

For remove the `ucore-container` to initial a new `ucore-container`, just type

```
$ make rm
```

That's it, so concise and elegant.

## References

\[1] [Installing Cygwin/X](https://x.cygwin.com/docs/ug/setup.html)

\[2] [Docker on Windows — Mounting Host Directories](https://rominirani.com/docker-on-windows-mounting-host-directories-d96f3f056a2c)

\[3] [Running Linux GUI Apps in Windows using Docker](http://manomarks.github.io/2015/12/03/docker-gui-windows.html)

\[5] [docker-x11-client](https://github.com/Joengenduvel/docker-x11-client)

\[6] [Docker for Mac and GUI applications](https://fredrikaverpil.github.io/2016/07/31/docker-for-mac-and-gui-applications/)

\[7] [Networking features in Docker for Mac](https://docs.docker.com/docker-for-mac/networking/)

\[8] [Using GUI's with Docker](http://wiki.ros.org/docker/Tutorials/GUI)
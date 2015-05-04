# Fusion Docker

An Ubuntu virtual machine for running a Docker development environment on Mac OS X

## Introduction

Running Docker on OS X typically means running [boot2docker](http://boot2docker.io), or more recently [Docker machine](https://docs.docker.com/machine/).

Although these tools are great for getting up and running quickly, if you want to run a Docker development environment, you need to consider how you can share files from your development workspace with your Docker containers.

In a Linux development environment, you can run Docker within your development environment and it is simple to use Docker volumes to share files.  In OS X though, it's harder because we need a guest virtual machine with a Linux kernel to run the Docker runtime.  

To share files from your OS X development environment with your containers, this means you need to set up file sharing with your Docker host VM.  With boot2docker and Docker Machine, VM file sharing is only currently supported with Virtualbox, using it's terribly slow file sharing features.

A better alternative is to use VMWare Fusion, which offers much better file sharing performance using its HGFS file system.  However I have personally found that their can be some synchronisation issues with this approach (especially if you attempt to compile source code within your guest VM), therefore the safest approach is to use NFS sharing.

This recipe creates a Vagrant environment that sets up a Docker VM with NFS file sharing configured in Virtualbox or VMWare Fusion. 

## Prerequisites

* [Brew](http://brew.sh)
* Docker client - `brew install docker`
* Virtualbox or VMWare Fusion 5+ - 'brew install Caskroom/cask/virtualbox'
* [Vagrant 1.6+](http://www.vagrantup.com/downloads.html) - 'brew install Caskroom/cask/vagrant'
* [Vagrant Hostmanager Plugin](https://github.com/smdahlen/vagrant-hostmanager)
* [Vagrant VMWare Fusion Provider](http://www.vagrantup.com/vmware#buy-now) (if using VMWare Fusion)
* To ease the Vagrant configuration of NFS on your OS X machine, you should also follow the steps outlined in the **Root Privilige Instructions** section of the [Vagrant NFS documentation](http://docs.vagrantup.com/v2/synced-folders/nfs.html)
 
## Installation

By default your Docker machine is called `fusion01`.  You can change this via the `$guest_name` variable in the `Vagrantfile`.

    My-Awesome-MacBook-Pro:~ god$ vagrant up
    Bringing machine 'default' up with 'vmware_fusion' provider...
    ...
    ...
    My-Awesome-MacBook-Pro:~ god$ export DOCKER_HOST=tcp://fusion01:2375
    My-Awesome-MacBook-Pro:~ god$ docker run hello-world
    Unable to find image 'hello-world:latest' locally
    latest: Pulling from hello-world
    a8219747be10: Pull complete
    91c95931e552: Already exists
    hello-world:latest: The image you are pulling has been verified. Important: image verification is a tech preview feature and should not be relied on to provide security.
    Digest: sha256:aa03e5d0d5553b4c3473e89c8619cf79df368babd18681cf5daeb82aab55838d
    Status: Downloaded newer image for hello-world:latest
    Hello from Docker.
    This message shows that your installation appears to be working correctly.
      
    To generate this message, Docker took the following steps:
     1. The Docker client contacted the Docker daemon.
     2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
        (Assuming it was not already locally available.)
     3. The Docker daemon created a new container from that image which runs the
        executable that produces the output you are currently reading.
     4. The Docker daemon streamed that output to the Docker client, which sent it
        to your terminal.
      
     To try something more ambitious, you can run an Ubuntu container with:
      $ docker run -it ubuntu bash
      
     For more examples and ideas, visit:
      http://docs.docker.com/userguide/

## Shared Folders

By default a folder called `/share` is mounted in your Docker VM that is mapped to `~/Source` on your OS X machine via NFS.

You can update this configuration my modifying the `$shared_host_path` and `$shared_guest_path` variables in the `Vagrantfile`.

    My-Awesome-MacBook-Pro:~ god$ vagrant ssh
    Welcome to Ubuntu 14.04 LTS (GNU/Linux 3.13.0-24-generic x86_64)

     * Documentation:  https://help.ubuntu.com/
    Last login: Mon May  4 02:23:16 2015 from 192.168.174.1
    vagrant@fusion01:~$ ls -l /share
    drwxr-xr-x 11 501 dialout     374 Oct 25  2014 activator-akka-spray
    
## Limitations

Virtualbox requires the explicit addition of a host-only network adapter with a static IP address.  This is handled for you automatically in the `Vagrantfile`.
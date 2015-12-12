# Developing reproducible workflow environments with Virtual Machines.

## Introduction

### What this tutorial is for

With all of the tutorials available on the web today, you may be wondering why I would want to create yet another one. That's a fair question. The reason I decided to write a tutorial is because I saw the same questions regarding Vagrant, virtual machines and web development workflows in general over and over again both on reddit, in the courses I've taught and from colleagues/friends. My goal is to show you how to leverage virtual machines (VMs) and some popular ancillary tools to create an efficient and reproducible workflow that you can use on your own or with your team.

Throughout this tutorial, we will learn how to setup and [provision](https://en.wikipedia.org/wiki/Provisioning#Server_provisioning) a virtual machine that closely matches a production environment along with a few extras that will allow you to get serious work done. 

We will be using [Node.js](https://nodejs.org/en/), [Express](http://expressjs.com/en/index.html), [MongoDB](https://www.mongodb.com/) and [Angular](https://angularjs.org/) (and possibly [react](https://facebook.github.io/react/) based on feedback) which is commonly referred to as the [MEAN](https://en.wikipedia.org/wiki/MEAN_(software_bundle)) stack. However, the ideas you learn here are applicable to other stacks.

### Who this tutorial is for

There are two main types of developers I wish to target:

* Professional developers looking to create an automated/reproducible workflow and/or get their team members working in identical environments.
* Developers who have already learned or are interested in development tools/processes but aren't sure how to tie them together just yet.

**Important**: Before starting this tutorial it is important that you are already proficient with the command line, are at least familiar with the MEAN stack and have some experience provisioning a server. ***We will not be going over the fundamentals as that is not the intention of this tutorial. If you are not able to get your application running on a server on your own at this point, this tutorial is probably too advanced.*** 

If the content of this tutorial goes over your head, don't fret - here are some resources to catch up with:

* If you need to brush up on the command line, here is an excellent introduction: [The Command Line Crash Course](http://cli.learncodethehardway.org/book/)

* DigitalOcean has some excellent tutorials on provisioning servers, checkout this one on [setting up node on ubuntu](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-node-js-application-for-production-on-ubuntu-14-04).

There are a myriad of other helpful tutorials on Digital Ocean, so keep practicing doing it the manual way first and then come back and learn how to automate that process.

## Workflow outline

### Reasons for using this workflow

The backbone of our development workflow will be the [virtual machine](https://en.wikipedia.org/wiki/Virtual_machine). 
Virtual machines have a number of benefits for development purposes, such as:

* Isolating your project code.
* Allowing you to create a local development environment that closely matches your production environment.
* Avoiding production bugs that don't exist when running the app on the software and/or hardware on your development machine.
* Having all team members working in identical virtual machines eliminates 'works on my machine' issues, no matter what operating system they use.

Using VMs allows you to catch bugs early and fix them. Trust me when I say that *production is that last place you want to learn about a bug!*

### Working with virtual machines isn't as hard as you think

Not everyone is so fond of setting up virtual machines. The biggest complaint I receive is that it is difficult to get up and running with something like Vagrant. While it is true that it takes some work to get your environment setup, that effort is 99% front-loaded and the payoff is that you'll more than make up that time later which you would spend hunting bugs. 

Also, your set-up can be easily re-used on different projects with small tweaks. You don't have to start new projects completely from scratch. 

If you are new to setting up environments, there is definitely going to be a learning curve involved here but stick with it and you'll have an edge on other developers in your field.  

## Preparing to create and configure our VMs

### Installing Vagrant and Virtualbox

Vagrant is going to do a lot of the work for us in creating and configuring our virtual machines. It's the foundation of this workflow. To install Vagrant head on over to the downloads section and get the package for your operating system:

[https://www.vagrantup.com/downloads.html](https://www.vagrantup.com/downloads.html)

You'll need to combine Vagrant with one of two options for creating your virtual machines - [VirtualBox](https://www.virtualbox.org/wiki/Downloads) or [VMWare](http://www.vmware.com/). You *could* use these on their own and manually create Virtual Machines, but combining them with Vagrant will save you a lot of work, as you'll see. 

Vagrant recommends VMware over VirtualBox for performance reasons, but we'll be using Virtualbox for this tutorial. It's free and it has worked extremely well for me, so there's no reason not to use it.

You can download the Virtualbox package for your operating system here:

[https://www.virtualbox.org/wiki/Downloads](https://www.virtualbox.org/wiki/Downloads)

### Creating a Vagrantfile

The first step when working with Vagrant is to create a `Vagrantfile`. This file will let Vagrant know where the root of your project is and also allows you to tell Vagrant what type of operating system and settings you want to use.

We can manually create a Vagrantfile or use the built-in `vagrant init` command to make a boilerplate one for us. Once you get comfortable with Vagrant, you can create one from scratch on your own, for now let's let Vagrant do the work for us.

Let's create a new directory for our project, you can place this wherever you'd like but I am going to create a new folder called `tutorial1` in the Projects folder of my home directory and cd into it:

~~~
$ mkdir -p ~/Projects/tutorial1 && cd ~/Projects/tutorial1
~~~

Next we'll initialize a new `Vagrantfile` like so:

~~~
vagrant init ubuntu/trusty64
~~~

This will create a new `Vagrantfile` in the current directory and will set our box of choice to `ubuntu/trusty64` (more on this later). 

**Note**: The Vagrantfile contains the configuration and is written in Ruby. You don't need to know Ruby to follow this tutorial, I don't even know it well myself. The syntax is straightforward and it is mostly just setting configuration variables. Feel free to do your own research on any commands you don't understand.

### Contents of the Vagrantfile

Take a few minutes to peruse the Vagrantfile. As you will see, most of it is commented out except for the following:

~~~
Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"
end
~~~

As you will find, most of the commands revolve around setting properties on the `config` object. In this case, we are letting Vagrant know that we want to use the `ubuntu/trusty64` that was set automatically during our `vagrant init ubuntu/trusty64` command above.

We will be setting more Vagrantfile configuration below.

## Creating and working with virtual machines

### Creating our virtual machine

Let's build our new virtual machine by running:

~~~
$ vagrant up
~~~

The first time you run this command, Vagrant will see if you already have your chosen box image (ubuntu/trusty64), if not it will download a copy of the [Official Ubuntu Server 14.04 LTS (Trusty Tahr)](https://atlas.hashicorp.com/ubuntu/boxes/trusty64) box to your machine. The file will be quite large but you only have to do this once for each operating system version you want to use.

Once the box has finished downloading, Vagrant will create a new virtual machine using the ubuntu/trusty64 image. If you already had the ubuntu/trusty64 box installed, then `vagrant up` would simply create a new VM (or boot up an existing one).

Once that process finishes we now have a pristine new virtual machine with a copy of Ubuntu 14.04 LTS installed!

### Running commands manually in the VM

Once your virtual machine has been created, you can work with it in a number of ways. First of all you can run commands manually by SSH-ing into the new VM:

~~~
$ vagrant ssh
~~~

Now that we are inside of the virtual machine, let's run some simple commands to update the system

~~~
$ sudo apt-get -y update
~~~

As you can see we can run commands and interact with our VM just as you would a remote server. We could proceed to install all of the software we need in this manner, however the entire point of this tutorial is to show you how to automate the process. 

From this point on, you should **never** manually **install** any server configuration from the command line. The reason we don't want to manually provision our server is because we want it to be 100% reproducible using `vagrant up`. It is, however, ok to **run** things manually especially during development such as starting your node server or installing app dependencies (e.g. npm start or npm install). If, in extreme circumstances, you have to make exceptions to this rule, **make sure you know what you are doing and that you document this very clearly.**

### Using automated provisioning to configure the VM

Instead of running commands manually to install configuration on your virtual machine, you should be automating the provisioning process. For those not familiar with the term, when I say "provisioning" or "server provisioning" I am referring to the process of installing software and setting up any configuration on the VM and/or server in order to get it ready for our intended purpose; in this case, running a MEAN stack app.

Previously, we ran the following commands manually:

~~~
$ sudo apt-get -y update
~~~

Instead of entering those in the command line ourselves, let's make Vagrant automatically run them when the VM is first created with `vagrant up` or when we run `vagrant provision` on a running VM. 

In your Vagrantfile, uncomment the following lines:

~~~
config.vm.provision "shell", inline: <<-SHELL
  sudo apt-get update
  sudo apt-get install -y apache2
SHELL
~~~

Also, we will not be using apache for this tutorial so you can remove the apache installation line so that your Vagrantfile looks like this:

~~~
config.vm.provision "shell", inline: <<-SHELL
  sudo apt-get update
SHELL
~~~

If you still have an SSH session open to your virtual machine, let's return to the session and exit it using the following:

~~~
$ logout
~~~

You should now be back in the root file of your project where the Vagrantfile resides. 

In order to have Vagrant run the provisioning scripts we setup in the Vagrantfile, run the following command:

~~~
$ vagrant provision
~~~

If everything went well you should see some text like this, followed by some output from the Vagrant machine running the update command:

~~~
==> default: Running provisioner: shell...
    default: Running: inline script
==> default: stdin: is not a tty
~~~

We now have an *extremely basic* automated environment setup that, so far, can create a new VM and run provisioning code with one simple command: `vagrant up`.

### Adding configurations for a private network address and project file sync to the Vagrantfile

The next bit of configuration we're going to automate for our virtual machine is a private network address so we can access our future apps in the browser, and a folder sync so that our project files can be served by the new VM.

To do this, let's add a couple more lines of configuration so that our Vagrantfile looks like this:

~~~
Vagrant.configure(2) do |config|
  
  config.vm.box = "ubuntu/trusty64"
  
  # give our VM an ip address we can access from our browser
  config.vm.network "private_network", ip: "192.168.33.10"
  
  # sync our local ~/Projects/tutorial1/myapp file to /var/www/myapp in the VM
  config.vm.synced_folder "myapp", "/var/www/myapp", type: "rsync"
  
  config.vm.provision "shell", inline: <<-SHELL
    sudo apt-get update
  SHELL
  
end
~~~

The first line we added `config.vm.network "private_network", ip: "192.168.33.10"` gives our VM its private network ip address. I chose this IP address arbitrarily. 

The second line: `config.vm.synced_folder "myapp", "/var/www/myapp", type: "rsync"` tells Vagrant to sync everything in our local `~/Projects/tutorial1/myapp` directory to `/var/www/myapp` in the Vagrant machine. (This will sync the files automatically on `vagrant up`, manually with `vagrant rsync` or automatically with `vagrant rsync-auto`) (More on this later).

**Important**: *In order for Vagrant to recognize the changes we made to the Vagrantfile, we will need to reload VM*

You can reload the VM with `vagrant reload` (note that changes to the Vagrantfile will also be recongnized on `vagrant up` if the VM isn't already running or in a suspended state)

Go ahead and reload the VM using `vagrant reload`.

You should see the following error:

~~~
$ vagrant reload

There are errors in the configuration of this machine. Please fix
the following errors and try again:

vm:
* The host path of the shared folder is missing: myapp
~~~

What went wrong? Well we told vagrant that we wanted to sync the "myapp" directory in our root project directory to /var/www/myapp in the VM but we never created this directory in the first place!

Go ahead and create this directory now on your host machine (not in the VM):

~~~
$ mkdir ~/Projects/tutorial1/myapp
~~~

### Create a folder for provisioning scripts

So far we have provisioned all our configuration from the Vagrantfile. That is perfectly ok for simple setups but it can quickly get overwhelming and the Vagrantfile really isn't best place to put them anyway. That's why we use external provisioning scripts.

We'll create one of these provisioning scripts in a moment, but first let's create a folder on our host machine to keep them in one place.

~~~
$ mkdir ~/Projects/tutorial1/provisioning
~~~

## Serving static content

### Sending content to the VM

Now that we have created and configured our virtual machine, we're ready to have it serve some content. To start us off easy, let's serve up a simple static webpage.

Create an index.html inside our myapp directory:

~~~
# ~/Projects/tutorial1/myapp/index.html
Welcome to myapp!
~~~

Using the configuration we just created in our Vagrantfile, we can now sync this index.html file to our VM by running:

~~~
$ vagrant rsync
~~~

Our entire /myapp directory has now been copied over to /var/www/myapp on the VM. 

### Create a http server with nginx

We have our simple "project" in place on our VM which is a basic html page. Let's install a http server that will serve up that page for us. 

First, we will need to install [NGINX](https://www.nginx.com/) in our VM. Instead of manually installing nginx, we'll write a shell script that will allow vagrant to install it for us. 

Within the `provisioning` folder we need to create a new file called `nginx.sh` (.sh stands for **shell**). The nginx.sh file should contain the following:

~~~
#!/bin/bash

# install nginx
apt-get install -y nginx-full

# update default 
echo -n "

    server { 
        
        listen 0.0.0.0:80;

        root /var/www/myapp;
        index index.html;

        location / {
            try_files \$uri \$uri/ /index.html;
        }

    }

" > /etc/nginx/sites-available/default

# reload nginx
sudo service nginx reload
~~~

Basically we are installing nginx, updating the default site-available file to point to our /myapp directory and then reloading nginx so that it picks up on the new configuration.

In order to tell Vagrant about this provisioning script, add the following to our Vagrantfile right before the `end` statement

~~~
config.vm.provision "shell", path: "provisioning/nginx.sh"
~~~

Our Vagrantfile should now look like this:

~~~
Vagrant.configure(2) do |config|
  
  config.vm.box = "ubuntu/trusty64"
  
  # give our VM an ip address we can access from our browser
  config.vm.network "private_network", ip: "192.168.33.10"
  
  # sync our local ~/Projects/tutorial1/myapp file to /var/www/myapp in the VM
  config.vm.synced_folder "myapp", "/var/www/myapp", type: "rsync"
  
  config.vm.provision "shell", inline: <<-SHELL
    sudo apt-get update
  SHELL
  
  config.vm.provision "shell", path: "provisioning/nginx.sh"
  
end
~~~

Now, to provision our VM run `vagrant provision` from our host machine in the same directory as the Vagrantfile. Vagrant will now run our nginx.sh script against our VM and install the nginx software.

### View your served  content in the browser

We can now navigate to [http://192.168.33.10/](http://192.168.33.10/) and see our index.html file being displayed!

Try adding some more html files to the myapp folder, then running `vagrant rsync` to update the shared folder and viewing those files in the browser.

*Hint*: If you add a file called `myfile.html` to the myapp folder, you can access it at [http://192.168.33.10/myfile.html](http://192.168.33.10/myfile.html)

For more information on configuring nginx, check out their [documentation](https://www.nginx.com/resources/wiki/).

## Running a simple node.js app on a virtual machine

We've covered quite a bit so far but we only have a simple html page to show for it. Let's create a simple express.js app and provision our server to run it.

### Installing node.js on the virtual machine

Now that we've seen how to serve up some static content, let's configure our VM to serve up a dynamic node.js app. 

Let's start by creating a new script in the provisioning directory that we just created. This script will be called `nodejs.sh` (.sh stands for shell):

~~~
$ touch ~/Projects/tutorial1/provisioning/nodejs.sh
~~~

Add the following commands to nodejs.sh:

~~~
#!/bin/bash

# download node tarball
sudo wget https://nodejs.org/dist/v4.2.1/node-v4.2.1-linux-x64.tar.gz

# unarchive tarball
sudo tar xzf node-v4.2.1-linux-x64.tar.gz -C /usr/local

# cleanup
sudo rm node-v4.2.1-linux-x64.tar.gz

# add symlink to /usr/local
sudo ln -s /usr/local/node-v4.2.1-linux-x64 /usr/local/node

# add node to path
echo 'export PATH=/usr/local/node/bin:$PATH' >> ~/.profile

# source the profile
source ~/.profile
~~~

**Updating Vagrantfile to load the new nodejs provisioning script**

Now that we have created a new provisioning script for installing node, let's let Vagrant know about it.

Update our Vagrantfile with this line `config.vm.provision "shell", path: "provisioning/nodejs.sh", privileged: false` so it looks like this:

~~~
Vagrant.configure(2) do |config|
  
  config.vm.box = "ubuntu/trusty64"
  
  # give our VM an ip address we can access from our browser
  config.vm.network "private_network", ip: "192.168.33.10"
  
  # sync our local ~/Projects/tutorial1/myapp file to /var/www/myapp in the VM
  config.vm.synced_folder "myapp", "/var/www/myapp", type: "rsync"
  
  config.vm.provision "shell", inline: <<-SHELL
    sudo apt-get update
  SHELL
  
  config.vm.provision "shell", path: "provisioning/nginx.sh"
  config.vm.provision "shell", path: "provisioning/nodejs.sh", privileged: false
  
end
~~~

You might be wondering what the deal is with `privileged: false`. The reason we need this is because, by default, Vagrant uses `root` when running the shell scripts. This is ok for most things but we don't want to update the profile of the root user, we want to update the profile of the SSH user which is `vagrant` by default. Setting privileged to false runs the commands as the SSH user instead of root. 

That is also the reason for using sudo in `nodejs.sh` unlike in `nginx.sh`. If that is confusing don't worry too much because we will be using [Ansible](http://docs.ansible.com/) to provision Vagrant instead of shell script and it makes situations like this much easier. 

Tell vagrant to run the provisioning scripts again:

~~~
$ vagrant provision
~~~

We can confirm that node was installed by SSHing into our VM and running node with the version `-v` flag:

~~~
$ vagrant ssh
$ node -v
~~~

You should recieve the following output `v4.2.1` which means the node installation went well. 

### Bootstrapping express.js

Instead of creating an app from scratch, let's use the [express-generator](http://expressjs.com/en/starter/generator.html) module to scaffold our app for us. 

Since this will be a global command, you can run it in any directory on your **host** machine:

~~~
$ npm install express-generator -g
~~~

**Tip**: You may need to run this command as `sudo` depending on your permissions. 

### Using express generator to create a simple app

Now, let's navigate back to our tutorial1 directory and create a new app:

~~~
$ cd ~/Projects/tutorial1
$ express myapp
~~~

**Important**: Since `myapp` is not an empty directory, express will ask us to confirm, simply enter `y` for yes and hit enter.


This will create some new directories and js files with a basic application. Take a moment to look through what was generated. 

Let's install the dependencies and run our app on the **host** machine to make sure everything is working:

~~~
$ cd ~/Projects/tutorial1/myapp
$ npm install && PORT=8080 npm start
~~~

You should now be able to view the app at `http://localhost:8080`.

### Running our node app in the VM

Now we are ready to actually run our node.js application in our VM. First we will need to sync our changes to the VM

~~~
$ vagrant rsync
~~~

This will copy all of our appliation files to the VM in the myapp directory. 

Next we need to SSH into the VM.

~~~
$ vagrant ssh
~~~

Next, let's navigate to our project folder:

~~~
$ cd /var/www/myapp
~~~

Now we are in our node application directory inside the VM. Let's go ahead and start the app using:

~~~
$ PORT=8080 node bin/www
~~~

**NOTE**: The reason we didn't need to run `npm install` here is because we already did so on our host machine and the `node_modules` directory was copied over during the rysnc process. This is ok for the purposes of this tutorial but depending on your project you may want to tell vagrant rsync to ignore the `node_modules` directory so you can install from within the VM. This is important since there are differences in how packages are installed based on your operating system. 

Here is an example of excluding directories:

~~~
config.vm.synced_folder "myapp", "/var/www/myapp", type: "rsync", rsync__exclude: ['.git/', 'node_modules']
~~~


### View your served content in the browser

We can now open our browser and navigate to `http://192.168.33.10:8080/` and will see our application running!

Try making some changes to the node.js app, running `vagrant rsync` in a separate terminal and then restarting the node application in the VM. This is a crude workflow that we will improve later but it is the basis of what we are trying to accomplish.

### Updating our nginx http server

Although we have our application running in the VM, there is one small problem. We don't want to have to enter a port number (e.g. 8080) in order to view our app. We want to run it at the default http port 80 so we can simply access it by the IP address. 

You might think that we could simply change our PORT environment variable to 80 and run the app like so:

~~~
$ PORT=80 node bin/www
~~~

If you try that you will be met with the error: `Port 80 requires elevated privileges` (any port < 1024 requires elevated privileges)

There are several ways to get around this but, for security reasons, let's stand on the shoulders of giants and let nginx handle this for us. Since nginx already has privledged access to port 80, we can tell nginx to route incoming requests from port 80 to our chosen port of 8080.

Update `nginx.sh` so that it looks like this:

~~~
#!/bin/bash

# install nginx
apt-get install -y nginx-full

# update default 
echo -n "

    server { 
        
        listen 0.0.0.0:80;

        root /var/www/myapp;
        index index.html;
    
        # let's move our index.html "app" url to /static/
        location /static/ {
            try_files \$uri \$uri/ /index.html;
        }
    
        # Tell nginx to pass any other request to port 8080
        # where we will be running our node.js app
        location / {
            proxy_pass http://127.0.0.1:8080;
        }

    }

" > /etc/nginx/sites-available/default

# reload nginx
sudo service nginx reload
~~~

What did we change?

~~~
 location /static/ {
     try_files \$uri \$uri/ /index.html;
 }
~~~

Here, we are simply telling nginx to search for any files in our `/var/www/myapp` directory and server them up when a client navigates to the /static/ url. This way we can still see our static content we created before.

~~~
 location / {
     proxy_pass http://127.0.0.1:8080;
 }
~~~

This section tells nginx to pass everything else to port 8080 which will be handled by our node.js app. `http://127.0.0.1` is the same as `http://localhost`.

### Re-run the provisioning scripts

Since we have updated our provisioning scripts again, let's go ahead and tell Vagrant to provision our VM using (make sure you are on the host machine, not in the VM):

~~~
$ vagrant provision
~~~

Now we can SSH back into our VM and run the app.

~~~
$ vagrant ssh
$ cd /var/www/myapp
$ PORT=8080 node bin/www
~~~

And we can view our application at [http://192.168.33.10](http://192.168.33.10) without having to type in the port number. You can also view the static index files by navigating to /static.


## Teardown

Now that we've seen how to create, configure and serve content from our VM, let's talk about the different ways of stopping it. 

We'll just cover the basics here but head on over to the [Vagrant teardown docs](https://docs.vagrantup.com/v2/getting-started/teardown.html) to get more details.

When you are finished for the day (or are ready to work on another project) you will want to teardown your VM so that it frees up memory on your machine. There are three main options:

* Suspending `vagrant suspend` (Fastest reboot time ~ few seconds)
* Halting `vagrant halt` (Fast reboot time ~ around a minute)
* Destroying `vagrant destroy` (Slow reboot time ~ several minutes)

Basically *suspending* will save the current state of your machine and then stop it, *halting* will gracefully shut down the VM, and *destroying* will remove any trace of your VM altogether. [Read the docs](https://docs.vagrantup.com/v2/getting-started/teardown.html) to get a better understanding of each.

I personally usually use `vagrant halt` when I'm done working and only `vagrant destroy` when I know i won't be working on that project for quite some time. I don't usually use `vagrant suspend` because I only `vagrant up` at the beginning of my work day and the time difference to boot vs suspending is negligible. Choose whichever works for you.

### Rebuilding

To really drive the point home, let's completely destroy our VM and let Vagrant build it from scratch:

~~~
$ vagrant destroy
$ vagrant up
~~~

In just a couple of minutes you'll have a fully provisioned VM that can run your app (don't forget to install the node app dependencies and run the app within the VM).

Pretty great right? Try doing all that manually in just a couple minutes...

The best part is that we can version control this entire setup, send it to our team members and they can have the exact same environment just by using `vagrant up` (provided they have vagrant and virtualbox installed of course).


## Plugins

#### Automate local domain creation with hostsupdater

Although Vagrant includes most of what you need, they also have a really nice plugin ecosystem. For example, I like to update my /etc/hosts file so that I can point a local domain to the IP address such as http://myapp.local. 

Instead of doing this manually (this will be a recurring theme as you might have noticed) let's install a plugin that will do this for us. We will be using [vagrant-hostsupdater](https://github.com/cogitatio/vagrant-hostsupdater).

To install it, simply run:

~~~
$ vagrant plugin install vagrant-hostsupdater
~~~

Now, update our `Vagrantfile` and add the following config right under our private network configuration:

~~~
config.vm.network "private_network", ip: "192.168.33.10"
config.vm.hostname = "tutorial1.local"
~~~

Next, reload Vagrant:

~~~
$ vagrant reload
~~~

Now you can access our VM using `http://tutorial1.local` instead of typing in the IP address. 

### Easily manage Virtualbox guest additions

The **only** consistent issue that I've had with Vagrant is making sure that VirtualBox's [guest additions](https://www.virtualbox.org/manual/ch04.html) are installed properly. According to the Vagrant docs:

"VirtualBox Guest Additions must be installed so that things such as shared folders can function. Installing guest additions also usually improves performance since the guest OS can make some optimizations by knowing it is running within VirtualBox."

Instead of handling this yourself, just use the [vagrant-vbguest](https://github.com/dotless-de/vagrant-vbguest) plugin to ensure this is done for you when the Vagrant machine is created:

~~~
$ vagrant plugin install vagrant-vbguest
~~~

Now that is one less thing you have to worry about. 

## Wrapping up

Hopefully this tutorial has given you some insight on how powerful development environments can be with virtual machines. I realize that this may seem like quite a bit of work when you can easily run a node.js app locally but I promise you that once you start getting into any serious work it will pay dividends to have a reproducible environment like this. 

It took me several weeks to completely wrap my head around the Vagrant process and get my environment where I needed it. It has now become second nature and I never start a new project without it.
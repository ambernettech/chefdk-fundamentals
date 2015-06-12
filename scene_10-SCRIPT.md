## Connecting to Chef Server

We accomplished a lot during the first day. We created two cookbooks. One to setup workstations with our tools. And a second cookbook that setup a web server that delivered a "Hello, world!" message with some1 pertinent information about our system.

Later today we will be getting our first release of our launch page. To prepare for it and our eventual launch page we need to prepare for some incoming traffic. So lets walk through what it would take to manage multiple systems.

-

Currently our cookbook exists on one of our webservers. If we wanted to setup an additional web servers to serve additional traffic for our soon-to-be highly successful website what steps we would need to take to setup an identical sytem.

-

A new system would require us to provision a new node within our company or appropriate cloud provider with the appropriate access to login to administrate the system.

Install the Chef tools.

Transfer the apache cookbook.

Running chef-client locally to apply the apache cookbook's default recipe.

-

As an exercise roughly estimate the time it would take to accomplish this series of steps of preparing another node.

> Wait to allow a rough estimate

The cost of installing the Chef tools, transfering the apache cookbook, and applying the run list is not terribly expensive.

We provide a one-line curl install for the Chef Development Kit.

You could use git to clone the repository from a common git repository. Archiving the cookbook and then using SCP to copy over the contents. Perhaps mounting a file share.

Applying the run list requires the execution of a command on that system.

-

So the overall time required to setup a new instance is not a massive. This manual process will definitely take its toll when requirements demand we manage more than a few additional nodes.

-

As the popularity of our site grows one server will not be able to keep with all of the requests. We will need to provision additional machines as demand increases and ...

-

... we will need to develop a way to route incoming traffic to each of these nodes.

-

There are many ways that we can route the traffic from one node to a group of similar nodes. This can be done with services by some of the major cloud providers or it can be done with another instance running as a proxy server.

A proxy server allows for us to receive incoming requests and forward those requests to other nodes.

Today we are going to set up a proxy server that will direct web requests to similar configured nodes running our default web page that we deploy with the apache cookbook's default recipe.

We have one system already configured as our web server. We will need to setup another system. We will also need to setup a node to act as the proxy to both of these two web servers.

-

Whether we tackle installing, configuring, or running a proxy server or recreate a second instance running the apache cookbook's default recipe we will want to solve the problem of how we can manage mulitple systems. Each system will need to have Chef installed, the cookbooks copied onto the system, and a run list of the recipes to apply to the system.

One way to solve that problem is with a Chef Server.

-

Chef Server comes in many different flavors. At the core we offer Chef Server as an open source project freely available for anyone to deploy.

We offer an on-premise Enterprise Chef Server that adds additional functionality and user features (namely the web user-interface).

Lastly we have Managed Chef Server - which is a multi-tenant Chef Server that we host as a service. This by far is the quickiest to get started with and is free as long as we remain under the reasonable node amount.

In the interest of getting things done and a relatively small node count it seems like the the Managed Chef Server option is a great. with three nodes and interest in getting things done quickly, this seems like a good choice.

-

To get started with Managed Chef Server you will need to visit manage.chef.io and sign up for a Managed Chef Account. This setup requires a username, email and a password. From there you will be prompted to create an organization.

-

What is an organization?

An organization is a structure within managed Chef that allows multiple companies or entites to exist on the same Chef Server without our paths ever crossing. You might think of it as like setting up a unique username for your organization. All of the cookbooks, instances and other configuration details that we manage with Chef will be stored on the Chef Server for this particular organization. No other organization will have access to it.

Now with your account created you will need to download the various configuration information and keys necessary to talk with the Chef Server. Through the Chef Manage website I want you to first download the knife configuration file. This is a ruby file that contains the information on where the Chef Server is located.

After downloading this file you will need to place it in the chef repository that you previously downloaded. This knife confguration needs to be placed inside a special directory within that repository named '.chef'. That directory will need to be created and that knife.rb file copied into that directory.

The second file you need to download is your security key that allows you to talk with the Chef Server. This key is available through the manage.chef.io interface under User information. This user key is used to sign all your requests to communicate with the Chef Server. Similar to how you logged into the Chef Server, this ensures we only accept requests from you.

When the Chef Server created your account it generated an initial public and private key. It stored the public and threw the private key away. The problem is that you will need a copy of the private key. Unfortunately as I said we do not maintain a copy - this is to ensure that we do not have a copy of a key that could grant access to your organization.

So you will need to reset the key currently defined for your user and generate a new one. When that happens Chef Server will maintain the public key, as it did before, but this time the website will return to you the private key.

This private key is usually kept along side the knife configuration file that we downloaded previously. So after you find it from within the site I want you to download it and copy it alongside the knife.rb in the '.chef' diretory.

When those two files are in place you are ready to verify your connection. You can do that by asking the Chef Server what are the current list of available clients able to access the system. That command is executed through knife. Knife is a command-line tool that allows us to request and send information to the Chef Server. It has a number of subcommands that it provides.

We can look at all the commands with knife dash-dash-help.

This will display all the sub-commands available. In our case we want to verify that the client list contains a single entry so we need to look for help for the specific command knife client dash-dash-help.

This will give us an even smaller subset of the commands related specifically to asking the Chef Server about client information. A general command is the list command which will output all the clients that the Chef Server currently maintains.

For our Chef Server account there should be a single client and that is the organization name - validator. This is a special key that has access to the Chef Server. However, in our case we are using our own personal keys. The important thing is that the result back does not contain an error with the configuration or authenticating. If it does then we need to ensure that we are

* executing the command within the chef repository.
* Within the chef repository we have a .chef diretory which contains the knife-dot-R-B file and user key
* sure the command we executed is correctly typed.
* connected to the internet (ssl)
* not blocked by our own system's proxy servers or vpns.

With all that complete we are now able to communicate with the Chef Server. At this point I will refer to the system in front of you, with the chef repository, the configuration, and the keys installed as your workstation. When working with Chef with a Chef Server the workstation is the location where you will compose your cookbook code. When that code is complete you will then upload it to the Chef Server.

Similar to asking the Chef Server about the list of available clients we can also ask it information about cookbooks. We can find all the commands related to the cookbooks subcommand by running `knife cookbook dash-dash-help`. Similar to the list of clients we can examine a list of cookbooks. Running the command knife cookbook list will return the cookbooks currently uploaded to the Chef Server. The empty response should come as no surprise.

We want to change that. So we are going to upload each of our cookbooks to the Chef Server using another utility called Berkshelf.

Berkshelf is a cookbook management tool that allows us to upload our cookbooks and all of its dependencies to the Chef Server. In this instance, our current cookbooks have no dependencies, but in the future when they do Berkshelf will assist us in ensuring those are all uploaded.

Berkshelf is used on a per cookbook basis. As dependencies are often per cookbook. We change into the directory of the cookbook. We install any dependencies that our cookbook might have. Again, in this instance there are no dependencies external to this cookbook but Berkshelf ensures that is the case when it runs the "berks install" command.

We see that it finds the current cookbook within our current directory, it contacts the Supermarket for any external dependies, and then completes by writing a Berksfile.lock to the file system.

The Berksfile.lock is a receipt of all the cookbooks and dependencies found at the exact moment that you ran berks install. This lock file is useful to ensure that in the future you use the same dependencies when working with the cookbook.

With the dependencies account for it is time to upload the to the Chef Server. This is another subcommand that berkshelf provides called 'upload'. Run 'berks upload' to upload the apache cookbook to the Chef Server.

When that is complete we can return to the cookbook command that allows us to display the cookbooks within our organization by running knife cookbook list. This will now show us that the Chef Server has the apache cookbook that you have uploaded.

Though we will not be using this cookbook today to manage our workstation or any instances, as an Exercise, I want you to upload the remaining cookbooks within the cookbook directory. After you have done that verify that the cookbooks have been uploaded.

So the one remaining cookbook is the workstation cookbook. Berkshelf is a cookbook management tool that examines the contents and dependencies of a single cookbook. So I need to change into the cookbook's directory.

I verify that the cookbook is not currently uploaded.

I run "berks install" to install all the cookbook dependencies.

I run "berks upload" to upload the cookbook and all its dependies to the Chef Server.

Lastly, I run "knife cookbook list" to validate that the workstation cookbook is now uploaded to the Chef Server.

-

We have one remaining objective and that is to add an instance as a node within our organization. A node can only join one organization. To be a node means that it has chef installed, has configuration files in place, and when you run the chef-client application with no parameters it will successfully contact the Chef Server and ask it for the run list that it should apply and the cookbooks required to execute that run list.

When a node is part of the organization we manage that information on the Chef Server as well. Managing that information there allows us to use for inventory, querying and searching.

...

From within our chef repository I want you to bootstrap an instance to add it as a node within our organization.

First lets verify that we have no existing nodes within our organization. We can use the "knife node dash-dash-help" command to see that we can ask for the list of all nodes within our organization with the list command.

So we run "knife node list" and see that we have no nodes currently registered with our Chef Server.

Knife provides a bootstrap subcommand that takes a number of options.

When you bootstrap an instance it is performing the following:

* Installing chef tools if they are not already installed
* Configuring Chef to communicate with the Chef Server
* Running chef-client to apply a default run list

To communicate with the remote instance we need to provide it the credentials to connect to the system. We use the user name with the dash-X flag and the password dash-capital-P flag. We include the dash-dash-sudo flag because we are installing software and writing configuration to directories traditionally owned by the root user. We can name the node with the dash-capital-N flag. This is optional but makes it easier for us to communicate. When I ask you to look at the details of node one or login to node one you it will be easier to remember than the fully-qualified domain name. The dash-R flag allows us to specify a run list. That is the cookbook's recipe you want to have running on the node.

When executing the command the output will tell us what it installed and ran. When it is done we can see that our organization knows about the new node by again running the command "knife node list". We see now that we have a new node, node1, uploaded to the Chef Server. We can show more information about a particular node with the command "knife node show node1". This will display a summary of the node information that the Chef Server stores.

We the Chef Server reports that our node is part of the organization. It was able to retrieve and apply the apace cookbook's default recipe which setups the apache web server on port 80 and returns the default index page which saids "Hello, world!" with the ipaddress and port information.

With all of the objectives complete we are finished with this section. What question can we answer for you?
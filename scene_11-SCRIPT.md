## Community Cookbooks

With a single web server running with our organization its now time to talk about the next goal to tackle. We want to setup a proxy server. A proxy server is able to receive requests and relay them to other systems. In our case, we specifically want to use the proxy server to balance the entire traffic load between one or more systems.

This means we will need to establish a new node within our organization, install the necessary software to make the node a proxy server, and configure it so that it will relay requests to our existing node running apache and the future nodes.

Similar to how we installed and configured apache on our first node we could do the same thing here with a proxy server. We could learn the package name for the application 'haproxy', learn which file manages the configuration, learn how to compose the configuration with custom values, and then manage the service.

Package, Template and Service are the core of configuration management. Nearly all the recipes you  write for an application will center will use these three resources. We could spend these initial sections focused on composing the cookbook recipe and testing it on our platform with our custom configuration.

What if I told you someone already wrote that cookbook?

Someone already has and that cookbook is avaiable through the community site called Supermarket. Supermarket is a public repository of all the cookbooks shared by other developers, teams, and companies, like you that want to share their knowledge and hard work with you to save you time.

An important thing to remember is that the community site are cookbooks managed by individuals. Chef does verify or approve of the cookbooks found in the Supermarket. These cookbooks solved the problems for the original authors and then they decided to share them. This means that the cookbooks you find in the Supermarket may not built or designed for your platform. It may not take into special consideration your needs and requirements. It may no longer be actively maintained.

One thing that I have found is someone cookbooks may not work because they were not updated for the platform I am currently deploying it on or it may deploy an application in a way that is counter to requirements defined by my team or organization. Even if the cookbook does not work as a whole, there is still value in reading and understand the source code and extracting the pieces you need when creating your own.

With all that said there is a real benefit to the community site. When you find a cookbook that helps you deliver value quickly it can be a tremendous boon to your productivity. This is what we are going to take advantage of with the haproxy cookbook.

Lets find the haproxy cookbook within the community site to learn more about it. From the Supermarket main page type in the search term "haproxy". In the results that appear below, select the haproxy cookbook. Cookbooks usually map one-to-one to a piece of software and usually named after the piece of software that they manage.

Here you are presented with information that describes the cookbook. Starting on the right-hand side we see the individuals that maintain the cookbook, a link to view the source details, last updated date, supported platforms, licensing, and a link to download the cookbook.

On the left, we are presented with the various ways we can install the cookbook, the README that describes information about the cookbook, any cookbooks that this cookbook may depend on, a history of the changes, and its food critic rating - which is a code evalutor for best practices.

The area to focus most of your attention from the beginning is the README. The README describes the various attributes that are defined within the cookbook and the purpose of the recipe. This is the same README file found in the cookbooks we currently have within our organization. This one, however, has had far more details added to help new users like us the abillity to understand more quickly what the cookbook does and how it does it.

Reading and understanding the README at at glance is difficult. It is a skill that comes with time. For the haproxy cookbook there is an attribute that is defined that establishes the systems.

Prior to this point we have seen how node attributes are defined by Ohai but cookbooks also have this ability to define node attributes. These node attributes are different than the ones defined by Ohai as well. Ohai attributes considered automatic attributes and generally inalienable characteristics about the node.

Attributes defined in a cookbook are not considered automatic. These are simply default values that we may change. There are many ways that we provide new default values for these. One way that we are going to learn is defining a wrapper cookbook.

A wrapper cookbook is a new cookbook that encapsulates the functionality of the original cookbook but allows us to define new default values for the recipes.

This is a common pattern for overriding cookbooks because it allows us to leave the original cookbook untouched. We simply provide new default values that we want and then include the recipes that we want to run.

Lets generate our wrapper cookbook named myhaproxy. Traditionally we would name the cookbook with a prefix of the name of our company and then follow it by the cookbook name 'company-cookbook'.

> https://www.chef.io/blog/2013/12/03/doing-wrapper-cookbooks-right/

We will use the chef command-line utility to generate our new cookbook. The first thing that we want to do setup a dependency within our cookbook on the haproxy cookbook. Establishing this dependency informs the Chef Server that whenever you deliver this cookbook to a node you should also deliver with it the mentioned dependent cookbooks. This is important because our cookbook is simply going to setup new default values and then execute the recipes defined in the original cookbook.

Now within our default recipe we need to define new default values for the node's haproxy members. Let's examine the current default values as they are described in the README.


Currently the haproxy cookbook assumes that the are two different services running on the localhost at port 4000 and port 40001. The haproxy process will relay messages to itself to those two ports. That is not our configuration. First we currently only have one system we want to route traffic to at the moment. Second we want to have the traffic routed not to localhost but instead to our first web node which has a completely different hostname and ipaddress.

First, within the myhaproxy cookbook we will use the include_recipe method to specify the fully-qualified name of the cookbook and recipe that we want to execute. In this case when we run our wrapped cookbooks recipe we want it to run the original cookbooks default recipe. We could define new recipes from within this cookbook for every recipe that we want to support in our wrapper cookbook. Here we are only interested in the resources configured in the default recipe.

Second, without us changing anything any further and using this cookbook will simply execute the original cookbooks recipe with all the same default values. Before we execute that recipe we want to override the default values with our own. To do start by copy-and-pasting the original default values into our recipe.

We need to change the syntax slightly to state that we want to set a new default value on the node itself. Then we want to remove the second entry. And Finally we want to change the values of the first entry to include information about our first node.

If you forget that information about your node, remember there are a few ways in which you can retreive that information. However with cloud providers that generate machines for you an assign internal IP addresses those values may not work properly. So instead you may need to ask the node for a different set of attributes. Ohai collects attributes from the current cloud provider and makes them available in an attribute named 'cloud'. We can look at the cloud attribute on our first node and see that it returns for us information about the node that we can use within our recipe.

Update the recipe to include the public hostname and public IP address we can use as the new default values.

Finally save the recipe file.

Now as an exercise upload the cookbook to the Chef Server.

Lets walk through that process. We use the Berkshelf tool to upload our cookbooks. This is where Berkshelf really shines as a tool. We change directory in the root of the myhaproxy cookbook and we run the command "berks install". When we run this command for a cookbook that has a dependency we see that Berkshelf will download the haproxy cookbook and its dependencies as well. The haproxy cookbook is dependent on the build-essential cookbook and the cpu cookbook. If any of those cookbooks had dependencies berkshelf would find those and download them as well.

Berkshelf downloads this cookbooks into a common directory within your home path. They are not added alongside your other cookbooks.

After installing all the necessary dependent cookbooks we use berks upload to send the cookbook and all its dependencies to the Chef Server. This is again an easier method to manage dependencies over manually identifying the dependencies and then uploading each one a single cookbook at a time.

When that is complete we can verify that we have uploaded our cookbook and all of its dependencies and our myhaproxy cookbook's default recipe is ready to be assigned to a run list of a node. So we'll need another node.

I will provide you with a new node for the following exercise:

I want you to bootstrap this node, same as you did before, but this time define the run list to converge the myhaproxy's default recipe. After setting that value I want you to SSH into that node with the provided user name and password. Then I want you to run sudo chef-client to apply the recipes define in this node's run list and then verify that our new node's default website is now properly redirecting traffic to the original web node we previously set up.

Take some time to complete that exercise.

Alright, lets review.

First I bootstrap a new node named node2. After the node is bootstrap I validate that it added correctly to the organization. I then define an initial run list for that node to converge the default recipe of the myhaproxy cookbook. I ensure the the run list has been set correctly.

Next I asked you to login to that remote node and run sudo chef-client to apply the new run list defined for that node. This does in fact work but imagining that we may need to execute this command for this node and many future nodes it seems like a lot of windows and commands that we would want to execute.

To make our lives easier, the knife command provides a subcommand named 'ssh' that allows us to execute a command across multiple nodes that match a specified search criteria. There are a lot of options for defining the search criteria that we will continue to explore. The most important criteria in this instance is star-colon-star. This means that we want to issue a command to all nodes.

So if we want to execute a "sudo chef-client" run for all of our nodes we would write out the following command. knife ssh quote-star-colon-star-quote then we need to provide the user name to login to the system, the password for that system, and then finally the command to execute/

We can now easily ask our nodes to update from our current workstation as long as they all have the same login credentials. For more security we would likely use SSH keys and forgoe specifying a username and password.

With our node running the myhaproxy's cookbooks default recipe relaying traffic to our first node running the apache cookbook's default recipe we have moved closer to creating the original topology we set out to define today.

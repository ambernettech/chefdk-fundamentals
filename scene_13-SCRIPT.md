## Roles

Up until this point it has been a mouthful to describe the nodes within our organization. We have two nodes, node1 and node3, that have the apache cookbook's default recipe in their run list. We have one node, node2, that has the myhaproxy cookbook's default recipe in their run list.

Traditionally we describe the nodes within our organization with their goal in mind. We also do so in more general terms. Node1 and node3 are web servers. Node2 is a proxy server. We state what is a node is mostly based on the function that sum of their configuration provides.

The Chef Server allows us to create and manage roles. A role describes a run list of recipes that are executed on the node. A role may also define new defaults or overrides for existing cookbook attribute values. Similar to what we accomplished with the wrapper cookbook.

A node may have zero or roles assigned to it.

The reason we create roles is to help bring clarity to our infrastructure and allow us to more easily identify the work that a node performs. When you assign a role to a node you do so in its run list. This allows us to configure many nodes in a similiar fashion because we no longer need to re-create a long run list for each node we simply give it a role or all the roles it needs to accomplish its desired function.

In this section we will create a proxy role and assign it to the run list of node2. We also will create a web role and assign it to the run list of node1 and node3. This is particularly powerful because we will no longer have to manage each of these identical nodes individually, instead we can make changes to the role that they share and all of the nodes that have this role will update accordingly.

Return to the base of your Chef repository

Run the knife role dash-dash-help command to see the available commands. Similar to other commands we see that knife role supports the ability to list currently defined roles.

When we run knife role list we see from its lack of response that we have no roles defined.

Lets walk through creating the proxy role together and assign it to the appropriate node.

First from the base of your Chef repository you will want to create a roles directory if necessary. If you are using the Chef Starter Kit this directory may already exist.

Within the roles directory create a file named proxy-dot-R-B. This is a ruby file that contains specific methods that allow us to express details about the role. We see that the role has a name, a description, and run list.

The name of the role as a practice will share the name of the ruby file - unless it cannot for some reason. The name of the role should clearly describe what it attempts accomplish.

The description of the role helps reinforce or clarify the intended purpose of the role. When selecting a role name that is not clear it is important that a helpful description is provided to help ensure everyone on the team understands its purpose.

The run list defines the list of recipes that give the role its purpose. Currently the proxy role defines a single recipe - the myhaproxy cookbook's default recipe.

After defining the entireity of the role we now need to upload it to the Chef Server. That is done through the command 'knife role from file proxy-dot-R-B'. The knife tool understands that you are uploading a role file and will look within the roles folder to find a file named proxy-dot-R-B.

With the role uploaded it is time to validate that the Chef Server recevied it correctly. We can do that by again asking the Chef Server for a list of all the roles on the system.

And we can ask for more details about a specific role. Here we are requesting specific details about the role named proxy.

The last step is to redefine the run list for node2. We want the run list to contain only the proxy role. Previously we used the command 'knife node run_list add' to append a new item to the existing run list. There is also a command that allows us to remove an item from the run list. There is a command that allows us to set the run list to a value provided. This will replace the existing run list with a new one that we provide.

So we want to set the run list for node2 to proxy role.

After we update the run list we can verify that the node has the correctly defined run list.

We can use knife ssh to run sudo chef-client on all the nodes again to ensure that nothing has changed. In this instance we only interested in having node2 run the command so we can get a little more creative with the search criteria and find nodes named node2. In this case there is only one result.

Within the results, nothing should change. Switching over to the role did not change the fundamental recipes that were applied to the node.

Now if we want to setup a new node in the future to act as a proxy server we can now simply set the new node's run list to be the proxy role and it will have identical functionality with all the other nodes that define this role.

Now, I want you to define a new role named 'web' that has the run list: the apache cookbook's default recipe. When you're done defining the role, upload it to the Chef Server, and then set the run list on node1 and node3 to the role that we have defined. And for good measure, though nothing should have changed, run sudo chef-client on both node1 and node3 to ensure that no functionality has been lost.

Take some time to complete that exercise.

Alright, lets review.

First we create a file named web-dot-R-B in the roles directory. The name of the role is web. The description that I chose was unimaginably web server. The run list I define contains the apache cookbook's default recipe.

We need to share the role with the Chef Server so we need to upload that file. We use the command 'knife role from file web.rb'. Knife knows where to look for that role to upload it.

We verify that the role can be found on the Chef Server.

We verify specific information about the role. Specifically does it have the run list that we defined.

We then set node1's run list to be the web role.

And we then set node3's run list to be the web role.

And to verify that everything is working the same as before we run knife ssh for both of these nodes. In this instance the query syntax is going to find all nodes that have the name node1 or the name node3.

With that we now have made it far easier to talk about our nodes. We can more casually describe a node as a 'web server' node or a 'proxy server' node. And in the future if we needed to ensure that these types of nodes needed to run additional recipes we would return to the role file, update its run list, and then upload it to the Chef Server again.
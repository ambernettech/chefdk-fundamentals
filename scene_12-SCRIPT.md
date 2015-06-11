## Managing Multiple Nodes

Now its time to create a third node. The third node will be the second web node.

I will provide you with a new node for the following exercise:

I want you to bootstrap this node and name it node3. Verify that you bootstrapped the node.

Set the run list for this node run the apache cookbook's default recipe. Apply that run list by logging into that node and running sudo chef-client or remotely administer the node with the knife ssh command. Finally verify that the node serves up the default html page that contains the node's ipaddress and hostname.

Take some time to complete that exercise.

Alright, lets review.

We bootstrap the instance same as before. We use the appropriate user and password. We provide the sudo flag and ensure that specify the name of the node.

We run the knife node show command to validate that the node was added to the organization.

We update the node's run list to run the apache cookbook's default recipe.

We then use knife ssh to ask all the nodes to run sudo chef-client.

Lastly we visit the public hostname and verify that our node is now returning the default home page.

By default the haproxy cookbook that we defined will not be updated to include the latest node running the apache cookbook. So the next exercise is to update the default recipe in the myhaproxy cookbook to send requests to two members. You will need to add a new, second member to the list of members defined in the default values.

This is a minor change to the cookbook so lets update the cookbook version to reflect the change. When thats done upload that cookbook to the Chef Server using berkshelf.

Run sudo chef-client to ensure the node updates to the latest cookbook version.

And finally verify that node2, the node running haproxy, now sends requests to both of the nodes running the apahce webserver. This may be tricky as browsers often aggressively cache the values so when you refresh the page you may continnue to only see one node running apache. Sometimes opening another browser window or tab or launching a completely different browser will trigger the loading of the second node.

Take some time to complete this exercise.

Alright, lets review

We start by first opening up the myhaproxy's cookbooks default recipe and we add a new entry which contains information about our second node running the apache cookbook's default recipe.

We have added a new feature to our cookbook by now granting it the ability to deliver traffic to a second node. This means we should update minor version number of our cookbook.

We move into the cookbook's directory so we can use berkshelf to install and upload our cookbook and its dependencies. The cookbook's version is the only thing that has changed as so berkshelf will upload only that cookbook to the Chef Server.

We ask every node in our organization to run sudo chef-client.

And then we verify that we are able to see the node running the myhaproxy cookbook's default recipe should deliver traffic to both of our nodes running the apache cookbook's default recipe.


## Managing Multiple Nodes

### Objective

This section's goal is to have the attendees bootstrap another node, this time a web server, and add it to the proxy members.

This guide will walk through using the existing webserver cookbook on a standard instance.

This is a great way to reinforce again the bootstrapping and configuring a node. Though remedial there is a new complexity that has been introduced by adding a third node to the exercises.

There are other ways that this section could be taught:

* Select another platform and update the existing web server cookbook to work on both platforms.

Here we are showing that cookbooks can be written for multiple platforms and/or platform-versions.

This is great way to demonstrate the skills required to build a singular cookbook that can be deployed on different platforms. This is also a decent enough opening to introduce ChefSpec. As this will highlight its strength in its speed to ensure that you added the correct resource to the resource collection for the specific platform.

* Select another platform and create a NEW web server cookbook that will work on the new platform.

This would be done if you were going to use a different web server. So if you started with Apache, you may choose IIS or Nginx here. Any solution as long as it is different that original cookbook created.

The bonus of doing it this way is that the attendees get to see that Chef is rather platform/application agnostic.

#### Add a Managed Node Running the Web Server Cookbook

Distribute a the connection information for another instance to each of the attendees.

As an exercise have the attendees bootstrap the node, update its run list, and then login to that system to run `chef-client`.


#### Update the Wrapped Proxy Cookbook to Add the New Web Node

As an exercise have the attendees edit the wrapped proxy server cookbook, upload it, and then apply it to the proxy server node.
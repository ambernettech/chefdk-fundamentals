## Community Cookbooks

### Objective

#### Find or Create a Cookbook to Manage a Proxy Server

At this point they have composed two cookbooks and we start the conversation proposing that we write a third. We tell them this is a path that we could explore another day. Instead we are going to focus them towards using a community cookbook.

This part of the journey is currently hard to perform without assistance from you. You have to give them the name of the application: haproxy. Another proxy server may work but will need to be tested to make sure it is configurable with the Operating System (OS) of the target node.

There are few ways you can go about teaching the attendee how to get the cookbook.

* Search the supermarket, select the cookbook, download the cookbook
* Use `knife cookbook site` to perform the same steps above
* Search the supermarket, select the cookbook, update a new cookbooks metadata to specify it as a dependency, and then use Berkshelf to download the cookbook.

#### Configure the Proxy Server to send traffic to the Web Node

With the proxy server cookbook will need to be understand how it is configured to serve traffic to one of the nodes running as a Web Server. For the haproxy cookbook the README layouts the description of the attributes that are needed to be overriden.

```ruby
node['haproxy']['members'] = [{
  "hostname" => "localhost",
  "ipaddress" => "127.0.0.1",
  "port" => 4000,
  "ssl_port" => 4000
}, {
  "hostname" => "localhost",
  "ipaddress" => "127.0.0.1",
  "port" => 4001,
  "ssl_port" => 4001
}]
```

This is the first moment attendees are introduced to the concept of attributes defined a cookbook.

It is important to explain to them that editing the cookbook is not a good idea. While it is the easist path it is also a path that could lead to more work ahead because any small change to the original cookbook means that to continue using the community cookbook in the future you will have to continue to re-apply your custom changes to the cookbook or decide not to upgrade when that cookbook upgrades.

Doing so means you miss out on bug fixes and features as they are created and worked on by the community.

The are many work-a-rounds. The one suggested for this activity is to create wrapper cookbook that:

* depends on the original haproxy cookbook
* in the default recipes re-defines the proxy members
* calls the haproxy default recipe within its default recipe

#### Upload cookbook to Chef Server

As an exercise have the attendees upload the cookbook to the Chef Server.

#### Add a Managed Node Running the Proxy Server

Distribute a the connection information for another instance to each of the attendees.

> When I did this class all the instances had the same user name but a different password. It may have been a good choice to have a different password or user for the proxy system to reduce confusion.

As an exercise have the attendees bootstrap the node, update its run list, and then login to that system to run `chef-client`.

Verify that when they go to the public address of the new node that it forwards traffic to the first node.
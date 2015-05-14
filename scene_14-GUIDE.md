## Roles

### Objective

#### Update the Wrapped Proxy Cookbook to Use Web Role

The situation of needing to define the lists dynamically could be displayed at the start and then returned to at this point.

The haproxy cookbook has the ability to auto assign the members if

* You use the recipe[haproxy::app_lb]
* The roles matches the name "webserver" or you override the attribute `node['haproxy']['app_server_role']` to the value you want.

> There is a bug in Windows where you attempt to use `knife node run_list set node1 'role[webserver]'` where it adds a bizarrely named recipe to the run list.

Using the haproxy default behavior may be too limiting as it requires the nodes have to return back a valid routable address the following attribute `node['cloud']['public_ipv4']` or `node['ipaddress']`.

This may be a problem with nodes added through Amazon Web Services (AWS). As AWS does not expose that information to the node. At least not the public information. That information is added to the node by Ohai `node['ec2']['public_ip4']`.

However, nodes do not consistently add this value. Sometimes Ohai does not know to run the EC2 plugin so we may need to write a new cookbook/recipe that will ensure ohai loads this information for the node.

While this information is necessary for the web nodes this seems like something that would benefit all nodes. So it may be important to lead the attendees through creating a cookbook named 'ec2' that has a single recipe called ohai that will drop the hint in location.

> How to make that discoverable I am not entirely sure where that is in the documentation? (http://docs.chef.io/release/ohai-8/#hints) Current references that I have found is in the Chef Intermediate content.

```
directory "/etc/chef/ohai/hints" do
  recursive true
end

%w[ /etc /etc/chef /etc/chef/ohai /etc/chef/ohai/hints ].each do |path|
  directory path
end

file "/etc/chef/ohai/hints/ec2.json" do
  content "{}"
end
```

Creating a another cookbook and a recipe to perform this operation allows the attendees an oppurtunity to use the directory resource.

With that cookbook that they have created, they will want to add this to every node. They might also think about adding it to all the roles. A conversation should be had around this topic.

As an exercise as the attendees to create a new cookbook that performs this hint creation. Then have them define a new base role and add this role to the run list. Then add this role to all the existing roles. Then update all the nodes with `chef-client`. Twice.

Running `chef-client` twice is important because the data will not be present until the second run-through and that is because the configuration and hints are checked right at the beginning of a chef-client run and the hint is not written until after.

With all the nodes now reporting their public ipaddress the challenge is to convert the search results into the structure supported by the proxy members variable.

```ruby
all_webservers = search("node","role:web")
all_node_proxy_info = []

all_webservers.each do |webserver|
  node_proxy_info = {
    "hostname" => webserver["ec2"]["public_hostname"],
    "ipaddress" => webserver["ec2"]["public_ipv4"],
    "port" => 80,
    "ssl_port" => 80
    }
  all_node_proxy_info.push node_proxy_info
  # all_node_proxy_info << node_proxy_info
end

node.default['haproxy']['members'] = all_node_proxy_info
```

As an exercise have them upload the cookbook and then apply it to the proxy node. Then have the attendees verify that the traffic is still being proxied between the two nodes.

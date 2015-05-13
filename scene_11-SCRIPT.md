## Community Cookbooks

We want the attendees to see the benefits of being an active part in the community. They have a new requirement in this section to deliver a load balancer to serve content to our web server.

The motivation is that we will then have the flexibility to add more web nodes when our traffic increases.

We outline the work or thought process on some proxy solutions and the work that we would have to perform and test to create a working solution.

Instead of walking the attendees through writing their own cookbook to manage a proxy server we invite them to find one on the Supermarket.

We demonstrate downloading and adding the haproxy cookbook.

We explain that the primary interface for cookbooks with outside parties are through node attributes. Node attributes within the cookbooks allow us to pass parameters to those cookbooks.

We describe that we could edit the node attributes within the cookbook but then we would not be able to get upstream changes as the proxy cookbook receives updates and changes.

We intro the attendees to the concept of wrapping a cookbook. Within the cookbook we demonstrate overriding a few attributes.

We ask the attendees to find and override the attributes allow us to specify our single host to receive the traffic.

The attendees demonstrate wrapper cookbook creation, testing, and uploading.

> This would be a good moment to introduce ChefSpec and the validation that the include_recipe is called and that the node attributes are set correctly for the execution. It could also be done with Test Kitchen and ServerSpec.

We give the attendees a new node.

The attendees bootstrap this new node and setup the new node to run the proxy cookbook and setup cookbook.

We ask the attendees to verify that the traffic sent to the proxy node is forwarded to the web node.
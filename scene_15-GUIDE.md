## Environments

### Objective

In this section we want to challenge their knowledge of search while introducing environments and the value that they provide.

The introduction should thoroughly motivate that attendees into wanting to create environments for their nodes.

#### Deploy our Site to Production

Start by creating a production environment with a cookbook restriction on the apache version and the haproxy version.

Demonstrate adding a single node to the environment and then ask them as an exercise to bring each node into that environments and run `chef-client` across all those machines.

Now create a requirement that it is time to pull a node back so that it can be used for testing new releases.

As an exercise have the attendee create a new environment (union). This time with no cookbook restrictions. They will now move one web node to the new environment and run `chef-client` across all those machines.

The attendees should notice an error. The proxy is still delivering requests to the one web node in union. Start a conversation to troubleshoot the issue (perhaps with each other first and then with the group). Discuss what the issue is and start to identify what new data the attendees now have. Point them to the docs site to search examples. If you want to be more helpful point them right at some some examples that show off AND within a search query. As an exercise let them discover this solution, update each system, and repair the issue. 

After the attendees upload the cookbook they are presented with another problem. The updated cookbook is stil not applied to the production systems. It appears that the last version of the cookbook is still in effect. Discuss what the issue is and start to identify what new data the attendees. Ask them to focus on finding out more data:

* Was the cookbook uploaded?
* Is the search criteria correctly defined?
* Does the change to the recipe make a difference?
* Does the change to the version make a difference?
* Does our environment care about the version?

They will discover that the version of the cookbook is not allowed in production. They need to update their production cookbook restrictions, upload the environment, and then run `chef-client` for the proxy node.

They verify that the proxy is delivering requests to only one web node.

> For this exercise attendees might hard-code into the search results to production. Encourage through one-on-one discussion the pitfalls and see if you can nudge them towards using the node.chef_environment value and string interpolation.
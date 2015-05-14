## Environments

### Objective

In this section we want to challenge their knowledge of search while introducing environments and the value that they provide.

The introduction should thoroughly motivate that attendees into wanting to create environments for their nodes.

#### Deploy our Site to Production

Start by creating a production environment with a cookbook restriction on the apache version and the haproxy version.

Demonstrate adding a single node to the environment and then ask them as an exercise to bring each node into that environments and run `chef-client` across all those machines.

Now create a requirement that it is time to pull a node back so that it can be used for testing new releases.

As an exercise have the attendee create a new environment (union). This time with no cookbook restrictions. They will now move one web node to the new environment and run `chef-client` across all those machines.

The attendees should notice an error. The proxy is still delivering requests to the one web node in union. Start a conversation to troubleshoot the issue (perhaps with each other first and then with the group). Discuss what the issue is and start to identify what new data the attendees now have. Point them to the docs site to search examples. If you want to be more helpful point them right at some some examples that show off AND within a search query. As an exercise let them discover this solution, update each system, and repair the issue. They verify that the proxy is delivering requests to only one web node.

> For this exercise attendees might hard-code into the search results to production. Encourage through one-on-one discussion the pitfalls and see if you can nudge them towards using the node.chef_environment value and string interpolation.

As a exercise give the attendees a link to a gist that contains the "splash page for the new website just finished by the designers". Ask them to update the template, run the tests, update the version, and upload the cookbook to the Chef Server. Verify that it works on the one node. Update the production environment restrictions to allow the new cookbook (now that it is tested). Re-run `chef-client` on all production systems and see the newly deployed website.


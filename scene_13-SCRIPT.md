## Roles

> TODO: Needs to be translated into a spoken format

Reasoning about our node was a great way to understand our system. We talk about the future of setting up more web nodes. We remind the attendees of the effort:

* Bootstrapping a new node
* Adding the web and setup cookbook
* Updating the wrapper proxy cookbook to include this new node.

We start to talk about ways we could make this process easier to perfom as we are obiviously going to get more web traffic than we know what to do with in the near future.

We describe that in the future our web nodes and proxy nodes will likely add more cookbooks as more configuration pieces come our way. This means that with every new node that we setup we have to remember to add an ever increasingly size list of recipes.

We lead a discussion to ask them if this is a good way to express what this machine does. We could show them examples of runaway run_lists that would leave the attendees head scratching as to what the node did within the system.

We introduce roles as a way to properly label the function of a node.

> We could talk about how we could have provided values to override coobkook attributes here within the role attributes. But the problem here is that there is no way to version roles.

We demonstrate creating a web role that has our two recipes: web and setup. Attendees demonstrate teh creation of a web role.

We ask the attendees to create a proxy role that has our two recipes: proxy and setup.

We lead a discussion about the redundancy of the setup cookbook. We also outline that the requirements for setup may increase as well.

We demonstrate updating the web role to include the base role. The attendees demonstrate updating the base role.

We ask the attendees to create the base role which contains the setup recipe. We ask the attendees to update the proxy role to also use the base role.

We finish the section by explaining that the next node we would configure would now be much faster to setup.

We demonstrate some additional bootstrap flags that allow us to provide an initial runlist for when we bootstrap the node.

We close the section with these issues resolved:

* Bootstrapping a new node
* Adding the web and setup cookbook

And we leave the section with these issues unresolved:

* Updating the wrapper proxy cookbook to include this new node.
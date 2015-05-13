## Search

In our quest to ensure we are ready for the next web node (now defined with the web role). We left one requirement unfinished.

* Updating the wrapper proxy cookbook to include this new node.

We return to the wrapper proxy cookbook and we talk about wanting a way where we search for all of our web nodes and place them into our members list.

We demonstrate using knife search to gain information about the node. We explain the format of a knife search. Drawing attention to the type of thing that is being searched for and the search criteria. We explain how the search criteria is defined. We provide links to the documentation on search syntax.

We demonstrate searching for some attributes and fields. We demonstrate searching for systems with the base role. We ask the attendees how best they would attempt to find all the web nodes. We ask them to formulate a search for that.

They demonstrate a search result set that returns the web nodes.

We describe to the attendees that they can also use search within the recipes. We explain that the format is very similar and returns a Ruby array of the items being requested.

We explain how to create an array with items within it. We demonstrate adding an item to an array and removing an item off of the array. We demonstrate retrieving an item from the array. We demonstrate the `#each` method. We explain the format of the loop.

We explain how to create a hash. We demonstrate defining a hash with keys and values.

We explain that with these three concepts they could:

* search for all web nodes
* iterate through each node
* convert the node object into a hash of just the information for the proxy
* add that item to an array that is passed to the proxy parameter

We ask the attendees to demonstrate these steps. The attendees demonstrate updating their recipe to demonstrate these steps.

With that we take a moment to celebrate that if we were to add a new system to our organization that we could have it in the load balancer very quickly.




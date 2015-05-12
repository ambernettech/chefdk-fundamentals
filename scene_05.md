## chef-client

I mentioned that in the previous section how I would talk about chef-client as being an alternative to chef-apply.

Remember I said: `chef-apply` was a great tool to allow us to explore resources in strings and in recipe files. However, the tool does not understand the concept of a cookbook.

-

In the ChefDK we package another tool. An older sibling, if you will, to the chef-apply command and that is `chef-client`.

`chef-client` is a command-line application that can be used to apply a recipe or multiple recipes. It also has the ability to communicate with a Chef server. A concept we will talk about in another section. For now think of the Chef Server as an central, artifact repository that we will later store our cookbooks.

-

Here is an example of using `chef-client` to locally apply the following run list of recipes. In this case we are applying one recipe and that is the setup recipe within our workstation cookbook.

-

Here is an example of using `chef-client` to locally apply the following run list of recipes. In this case we are applying one recipe and that is the server recipe within our apache cookbook.

-

Here is an example of using `chef-client` to locally apply the following run list of recipes. In this case we are applying two recipes. The setup recipe from the workstation cookbook and the server recipe within our apache cookbook.

-

Applying recipes with `chef-client` is different than `chef-apply` and that is because `chef-client`'s default behavior is to communicate with a Chef server. So we use the dash-dash local-mode flag to ask `chef-client` to look for the cookbooks locally.

-

When we apply a recipe with `chef-client` we define a run list. This is an ordered list of recipes that we want to apply to the system. When you define a recipe from a cookbook on the run list there is a particular convention.

recipe, square-bracket, cookbook name, colon-colon, recipe name, closing square-bracket

-

Before we start applying cookbooks through chef-client, make sure you are in your home directory.

-

Lets try applying our server recipe from the apache cookbook using `chef-client` in local mode.

Upon execution you unfortunately are presented with an error.

When executed we find that `chef-client` has an additional requirement. `chef-client` expects our cookbooks to be maintained in a directory named 'cookbooks'.

That seems simple enough to accomodate and a good way to start organizing the cookbooks that we are creating.

-

Let's make a directory named 'cookbooks'

-

And move our workstation cookbook into the cookbooks directory

-

And move our apache cookbook into the cookbooks directory

-

Now, lets try that again. This time with all of our cookbooks in the cookbooks directory like `chef-client` expects.

Try applying the apache cookbook's recipe named server.

-

Try applying the workstation cookbook's recipe named setup.

-

Try applying both recipes from both cookbooks again at one time.

-

Actually I didn't tell you everything about specifying the run list for the `chef-client` command.

When defining a recipe in the run list you may omit the name of the recipe, and only use the cookbook name, when that recipe's name is 'default'.

Similar to how resources have default actions and default attributes chef uses the concept of providing sane defaults to make our work faster when we understand the concepts.

A cookbook doesn't have to have a default recipe but most every cookbook has one. It's called default because when you think of a cookbook it is probably the recipe that defines the most common configuration policy.

When I think about the two cookbooks that we created. The apache cookbook with the apache recipe and the workstation cookbook with the setup recipe it seems like those recipes would be good default recipes for their respective cookbooks.

-

Lets start by updating the workstation cookbook's default recipe to run our setup recipe.

-

A simple solution would be to rename the setup recipe to the default recipe. However, a better practice would instead leave our recipes as they are and have the default recipe include our setup recipe using a method called `include_recipe`.

This allows us to maintain all the current setup instructions within its own recipe file. Useful when we start to develop new recipes, say for different platforms or system types.

We can more easily switch our cookbooks default behavior which can be useful when new requirements surface.

-

Here we are including the "workstation" cookbook's "setup" recipe.

-

Here we are including the "apache" cookbook's "server" recipe.

-

Within the default recipe we define the `include_recipe` method and provide one parameter which is the name of our cookbook colon-colon name of our recipe.

We are interested in having the default recipe for our workstation cookbook run the contents of the setup recipe.

-

We can now use chef-client to locally apply the cookbook named workstation. This will load our workstation cookbook's default recipe which in turn loads our workstation cookbook's setup recipe.

-

An exercise for you is to update the apache cookbook's default recipe to include the apache cookbook's recipe named server.

Then re-run chef-client with a run_list that applies the recipe-open-bracket-apache-close-bracket.

-

The updated default recipe should look like the following.

-

And the command that we run should similar uses our more succint run list.

-

What questions can we help you answer?

Generally or specifically about chef-client, local mode, run lists, and include_recipe.

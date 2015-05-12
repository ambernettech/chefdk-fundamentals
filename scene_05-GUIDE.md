# chef-client

## Purpose

As an attendee I am able to demonstrate usage of the `chef-client` tool so that I will be able to better able to administer my system by applying an entire run list of recipes to the system.

## Motivation

This section is useful bridge from using `chef-apply` to `chef-client`. There is quite a bit of repetition in this section of using `chef-client` and that is on purpose as this is the first time the attendee is experiencing the idea of the run list.

## Typical Pace

30 minutes

## Flow

We explain that while we are now using cookbooks to manage our recipes. That `chef-apply` does not understand a cookbook and will not scale as a tool.

We introduce the concept `chef-client` and demonstrate a number of different ways that it can be executed.

We return to our home directory and then walk through using the tool. Immediately we are confronted with an error that the `chef-client` commands needs for our cookbooks to be in a cookbooks directory.

We walk through creating a directory and moving each of the cookbooks into that directory.

We attempt to execute the chef-client command again and see that it works as before. We demonstrate it for our second cookbook. We demonstrate it for both cookbooks at once.

We explain the concept of the default recipe. Giving more light to a brief introduction of it before in the previous section.

We then describe that we could simply recipe the default recipe or instead we could the helper method `include_recipe` to allow us to request the recipe we want into the default recipe. We share some benefits of this choice.

We demonstrate applying the cookbook on the run list using the default recipe.

Then we ask them as an exercise to do the same thing for the apache cookbook.

We walk through that process.

Then we close with a discussion and questions.


## Troubleshooting

Important thing to note when specifying a run list is that the recipes defined within it that are separated with a comma will create an error.

```
recipe[apache::server], recipe[workstation::setup]
```
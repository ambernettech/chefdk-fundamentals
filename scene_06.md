-
1
-

## Navigation

-
2
-

## Testing Cookbooks

-
3
-

Automation is beautiful when it works. A work of art. When it doesn't work -- well it's a work of something.

As we start to define our infrastructure as code we also need to start thinking about testing it.

Because this is all too common a story that happens when delivering deployment scripts to production. Deployment scripts that, if tested, are tested on every platform except the ones running in production.

So how could we solve a problem like this?

-
4
-

We can start by first mandating that all cookbooks are tested before they are deployed to production. What steps would it take to test one of the cookbooks you created in the last section?

Write down or type out as many of the steps you can think of required to test one of the cookbooks.

When you are ready turn to another person in the class and compare your lists. Create a complete list with all the steps that you have identified.

-
5
-

Alright. Now with a more complete list, I want for you to roughly estimate how long it would take to test the cookbook?

> Allow a short amount of time for estimation. Reminding them again that this is only an estimate and is not something that has to be absolute known value.

-
6
-

Based on your length of time for testing your cookbook lets discuss: How often you would test your cookbook?

-
7
-

Alright. How often do you think changes to the cookbook will occur?

-
8
-

And the leading question: What happens when the rate of cookbook changes exceed the time interval it takes to verify the cookbook?

-
9
-

Testing tools provide automated ways to ensure that the code we write accomplishes its intended goal. It also helps us understand the intent of our code by providing executable documentation. We add new cookbook features and write tests to preserve this functionality. This provides us - or anyone else on the team - the ability to make new changes with a less likely chance of breaking something. Whether returning to the cookbook code tomorrow or in six months.

-
10
-

Well if Chef is to replace our existing tools it is going to need to provide a way to make testing the policies more delightful.

-
11
-

ChefDK comes with another tool named Test Kitchen. Test Kitchen is a test harness tool that allows us to execute the cookbook recipes against virtual or cloud instances.

More fully, it allows us to create a instance solely for testing, converge a run list of recipes on that instance, verify that the instance is in the desired state, and then destroy the instance.

-
12
-

Kitchen is a command-line application that allows us to manage the testing lifecycle.

Similar to other tools within the ChefDK we can ask for help to see the available commands.

The `init` command, by its name, seems like a good place to get started.

-
13
-

`kitchen help init` tells us that it will add Test Kitchen support to an existing project. It creates a dot-kitchen-dot-yaml file within the project's root directory.

There are a number of flags and other options but let's see if the cookbooks we created even needs us to initialize test kitchen.

-
14
-

Using `tree` to look at the workstation cookbook, showing all hidden files and ignoring all git files, it looks like our cookbook already has a dot-kitchen-dot-yaml.

It was actually created alongside the other files when we ran the `chef generate cookbook` command when we originally created this cookbook.

Let's take a look at the contents of this file.

-
15
-

The dot-kitchen-dot-yaml file defines a number of configuration entries which the kitchen command uses during execution.

-
16
-

So we don't need to run `kitchen init` because we already have a default kitchen file. We may still need to update it to accomplish our objectives so lets learn more about the various fields in the configuration file.

-
17
-

The first key is driver, which has a single key-value pair that specifies the name of the driver Kitchen will use when executed. The driver is responsible for creating the instance that we will use to test our cookbook. There are lots of different drivers available - two very popular ones are the docker and vagrant driver.

-
18
-

The second key is provisioner, which also has a single key-value pair which is the name of the provisioner Kitchen will use when executed. This provisioner is responsible for how it applies code to the instance that the driver created. Here the default value is chef_zero.

-
19
-

The third key is platforms, which contains a list of all the platforms that Kitchen will test against when executed. This should be a list of all the platforms that you want your cookbook to support.

-
20
-

The fourth key is suites, which contains a list of all the test suites that Kitchen will test against when executed. Each suite usually defines a unique combination of run lists that exercise all the recipes within a cookbook.

Here in this example this suite is named 'default'.

-
21
-

This default suite will execute the run list containing: The workstation cookbook's default recipe.

-
22
-

It is important to recognize that within the dot-kitchen-dot-YAML file we defined two fields that create a test matrix. The number of platforms we want to support multiplied by the number of test suites that we defined.

-
23
-

We can visualize this test matrix by running the command `kitchen list`.

In the output we see that an instance is created in the list for every suite and every platform. In our current file we have one suite, named 'default', and two platforms. First the ubuntu twelve-dot-zero-four platform.

-
24
-

And the second centos-six-dot-four platform.

-
25
-

Remembering our objective. We want to update our dot-kitchen-dot-yaml file to use the Docker driver and we want to test against a single platform named ubuntu-fourteen-dot-zero-four.

-
26
-

Docker is a driver. Lets replace the existing vagrant driver, in our dot-kitchen-dot-YAML, with the docker driver.

> The reason we are using the docker driver is that it is possible to run this on cloud platforms and perform virtualization within the already existing virtualization.

-
27
-

We also want to update our platforms to list only ubuntu-fourteen-dot-zero-four.

-
28
-

Now, run the `kitchen list` command to display our test matrix. We should see a single instance.

-
29
-

Wonderful. Now that we've defined the test matrix that we want to support. It is time to understand how to use Test Kitchen to creates a instance, converge a run list of recipes on that instance, verify that the instance is in the desired state, and then destroy the instance.

-
30
-

The first kitchen command is `kitchen create`.

To create an instance means to turn on virtual or cloud instances for the platforms specified in the kitchen configuration.

In our case, this command would use the Docker driver to create a docker image based on ubuntu-fourteen-dot-zero-four.

> The command does allow you to create specific instances by name or all instances that match a provided criteria.

-
31
-

Creating an image gives us a instance to test our cookbooks but it still would leave us with the work of installing chef and applying the cookbook defined in our dot-kitchen-dot-YAML run list.

So let me introduce you to the second kitchen command: `kitchen converge`.

Converging an instance will create the instance if it has not already been created. Then it will install chef and apply that cookbook to that instance.

In our case, this command would take our image and install chef and apply the workstation cookbook's default recipe.

> It also, like the`kitchen create` commands, defaults to all instances when executed without any parameters. And is capable of accepting parameters to converge a specific instance or all instances that match the provided criteria.


-
32,33
-

Move into the workstation cookbook's directory

Lets use `kitchen converge` to verify that the workstation cookbook is able to converge the default recipe against the platform ubuntu-fourteen-dot-zero-four.

The workstation cookbook should successfully apply the default recipe. If an error has occured lets stop and troubleshoot the issues.

-
34
-

Now, I want you to do the same thing again for the apache cookbook. Update the dot-kitchen-dot-yaml file so that it converges the apache cookbook's default recipe on the ubuntu-fourteen-dot-zero-four platform with the docker driver.

> Allow time for the attendees to complete the exercise

-
35
-

Same as before we update the dot-kitchen-dot-YAML file to use the docker driver and the ubuntu-fourteen-dot-zero-four platform.

-
36,37
-

Return to the home directory.

Then we move into the apache cookbook folder ...

-
38
-

And execute `kitchen converge` to validate that our apache cookbook's default recipe is able to converge on the ubuntu-fourteen-dot-zero-four instance.

-
39
-

So what does this test when kitchen converges a recipe?

-
40
-

What does it NOT test when kitchen converges a recipe?

Converging the recipe is able to validate that our recipe is defined without error. However, converging a particular recipe does not validate that the intended goal of the recipe has been successfully executed.

-
41
-

What is left to validate to ensure that the cookbook successfully applied the policy defined in the recipe?

Converging the instance ensured that the recipe was able to install a package, write out a file, and start and enable a service. But what it was unable to check to see if the system was configured correctly -- is our instance serving up our custom home page?

-
42
-

There is no automation that automically understands the intention defined in the recipes we create. To do that we will define our own automated test.

Lets explore testing by adding a simple test to validate that the tree package is installed after converging the workstation cookbook's default recipe.

-
43
-

The third kitchen command is `kitchen verify`.

To verify an instance means to:

* create a virtual or cloud instances, if needed
* converge the instance, if needed
* And then execute a collection of defined tests against the instance

In our case, our instance has already been created and converged so when we run `kitchen verify` it will execute the tests that we will later define.

> It works as the other commands do with regard to parameters and targeting instances.

-
44
-

The fourth kitchen command is `kitchen destroy`.

Destroy is available at all stages and essentially cleans up the instance.

> It works as all the other commands do with regard to parameters and targeting instances.

-
45
-

There a single command that encapsulates the entire workflow - that is `kitchen test`.

Kitchen test ensures that if the instance was in any state - created, converged, or verified - that it is immediately destroyed. This ensures a clean instance to perform all of the steps: create; converge; and verify. `kitchen test` completes the entire execution by destroying the instance at the end.

Traditionally this all encompassing workflow is useful to ensure that we have a clean state when we start and we do not leave a mess behind us.

-
46
-

So `kitchen verify` and `kitchen test` are the two kitchen commands that we can use to execute a body of tests against our instances. Now it is time to define those tests with ServerSpec.

ServerSpec is one of many possible test frameworks that Test Kitchen supports. It is a popular choice for those doing Chef cookbook development because ServerSpec is built on a Ruby testing framework named RSpec.

RSpec is similar to Chef - as it is a Domain Specific Language, or DSL, layered on top of Ruby. Where Chef gives us a DSL to describe the policy of our system, RSpec allows us to describe the expectations of tests that we define. ServerSpec adds a number of helpers to RSpec to make it easy to test the state of a system.

-
47
-

Here is an example of an isolated ServerSpec example that states: I expect the package named 'tree' to be installed.

-
48
-

For our test to work with Test Kitchen there are a number of conventions that we need to adhere to have our test code load correctly.

First, we need to create a test file, often refered to as a spec file at the following path. The structure of the path is a convention defined by Test Kitchen and will automatically be loaded when we run `kitchen verify`.

Within the spec we need to first require a helper file. The helper is were we keep common helper methods and library requires in one location. This allows us to require a single file within each of our tests.

-
49
-

Second we define a describe method. RSpec, which ServerSpec is built on uses an english-like syntax to help us describe the various scenarios and examples that we are testing.

Describe is a method that takes two parameters - the first is the name of fully-qualifed recipe to execute (cookbook name colon-colon recipe name).

The second parameter is the block between the the do and end. Within that block we can define more describe blocks that allow us to further refine the scenario we are testing.

-
50
-

Here is that example expectation that I showed you earlier except now it is displayed here within this context. This states that when we converge the workstation cookbook's default recipe we want to assert that the tree package has been installed.

-
51
-

Lets take a moment to describe the reason behind this long directory path. Within our cookbook we define a test directory and within that test directory we define another directory named 'integration'. This is the basic file path that Test Kitchen expects to find the specifications that we have defined.

-
52
-

The next part the path, 'default', corresponds to the name of the test suite that is defined in the dot-kitchen-dot-YAML file. In our case the name of the suite is 'default' so when test kitchen performs a `kitchen verify` for the default suite it will look within the 'default' folder for the specifications to run.

-
53
-

'serverspec' is the kind of tests that we want to define. Test Kitchen supports a number of testing frameworks.

-
54
-

The final part of the path is the specification file. This is a ruby file. The naming convention for this file is the recipe name with the appended suffix of underscore-spec-dot-R-B. All specification files must end with underscore-spec-dot-R-B

-
55,56,57
-

Return to your home directory.

Then move into the workstation's cookbook directory.

With the first test created - lets verify the package named 'tree' is installed when we apply the workstation cookbooks default recipe using the `kitchen verify` command to execute our tests.

-
58
-

With the first test completed. It is time to commit the changes to source control.

-
59
-

Now that we've explored the basic structure of writing tests to validate our cookbook.

What are other resources within the recipe that we could tests?

-
60
-

ServerSpec provides a large number of helpers to assist us with many different resources on our system. Important to us in testing more of our workstation cookbook's default recipe is the ability to verify if a file was written, what are the permissions of that file, and what are the contents.

Lets look at a few examples:

-
61
-

Here we are describing an expectation that the file named slash-E-T-C-slash-Pass-W-D is a file.

-
62
-

Here we are describing an expectation that the file named slash-E-T-C-slash-H-T-T-P-D-slash-conf-slash-H-T-T-P-D-dot-conf have contents that match the following regular expression. Asserting that somewhere in the file we will find the following bit of text.

-
63
-

Here we are describing an expectation that the file named slash-E-T-C-slash-sudoers should be owned by the root user.

-
64
-

Now as an exercise I want you to define additional tests that validate the remaining resources within our default recipe.

Add tests for the remaining package resources that are converged by the "workstation" cookbook's default recipe

You may also add tests for the file resource to ensure the file is present, that the contents are correctly defined, that it is owned by a particular user and owned by a particular group.

> This is particularly vague as there are no requirements that they "have" to test.

-
65
-

Alright, lets review.

Here we are verifying the package git is installed. The structure of the test is very similar to the one we demonstrated earlier. You likely have another test that validates the editor you specified is also installed.

-
66
-

For the file I chose only to verify that the file named slash-E-T-C-slash-M-O-T-D is owned by the root user. You may have verified that it was a file, that it belonged to a group, and that it contained content you felt important to verfiy.

-
67
-

If all the tests that you defined are working then it is time to commit our changes to version control.

-
68
-

What questions can we help you answer?

-
69
-

Wonderful. Now lets turn our focus towards testing the apache cookbook.

-
70
-

What are some things we could test to validate our web server has deployed correctly?

The apache cookbook is similar to the workstation cookbook. It has a package and file which are things that we have already tested. The new thing is the service. We could review the ServerSpec documentation to find examples on how to test the service.

But does testing the package, file and service validate that apache is hosting our static web page and returning the content to visitors of the instance?

-
71
-

What manual tests do we use now to validate a working web server?

After applying the recipes in the past we visited the site through a browser or verified the content through running the command 'curl localhost'.

Is that something that we could test as well? Does ServerSpec provide the way for us to execute a command and verify the results?

-
72
-

So for this final exercise you are going to create a test file for the apache cookbook's default recipe.

That test will validate that you have a working web server. This means I want you to add the tests that you feel are necessary that the system is installed and working correctly.

When you are done execute your tests with `kitchen verify`.

-
73,74
-

First I return home and then move into the apache cookbook's directory.

-
75
-

Here I chose to validate that the port 80 should be listening for incoming connections.

And I also validated that the standard out from the command "curl http://localhost" should match "Hello, world!".

-
76
-

Again, lets commit the work.

-
77
-

What questions can we help you answer?

Generally or specifically about Test Kitchen, ServerSpec and testing.


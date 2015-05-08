 -
1
-

## Attributes

-
2
-

Have you ever had to manage a large number of servers that were almost identical?

How about a large number of identical servers except that each one had to have host-specific information in a configuration file?

The file needed to have the hostname or the IP address of the system.

Maybe you needed to allocate two-thirds of available system memory into hugepages for a database. Perhaps you needed to set your thread max to number of CPUs minus one.

The uniqueness of each system required you to define custom configuration files. Custom configurations that you need to manage by hand.

-
3
-

Here we've been given the simple request of providing some additional details about our node in both our Message of the Day and our default index page that we deploy with our web server.

We'll start first with our message of the day.

-
4
-

Thinking about some of the scenarios that I mentioned at the start of the session makes me think that it would be useful to capture:

The ip address, hostname, memory, and CPU megahertz of our current system.

Let's walk through capturing that information using various system commands starting with the ip address.

-
5
-

To discover the ipaddress of the node, we can issue the command

`hostname -I`

-
6
-

Or we can dig it out of the results of running `ifconfig`.

-
7
-

We can include this information in our slash-e-t-c-slash-m-o-t-d by updating the contents of the file resource's content attribute.

Within the existing string value we've inserted a number of new lines for formatting and placed our ipaddress along with its value.

-
8
-

Next is the machine's hostname. This is easily retrievable with the `hostname` command.

-
9
-

We can also include this information in the file resource's attribute on a new line below our ipaddress.

-
10
-

One way to gather the memory of our system is to `cat` the contents of the slash-proc-slash-meminfo. There we can select the total memory available on the system.

-
11
-

And again we can add it in the file resource's attribute below our hostname.

-
12
-

Discovering information about the system's CPU is very similar. We can `cat` the contents of slash-proc-slash-cpuinfo and select the CPU megahertz from the results.

-
13
-

Adding it, like the others, to the file resource's content attribute.

-
14
-

By updating the file resource we have introduced a change to the cookbook. This change may not work. It could be a typo when transcribed from the slide, or the code that I have provided you is out-of-date, or very possibly incorrect.

Before we apply the updated recipe we can use testing to ensure the recipe is correctly defined.

-
15
-

Remember we are testing a specific cookbook with kitchen so we need to be within the directory of the cookbook. So change directory into the setup cookbook's directory.

-
16
-

We have not defined any new tests related to the content changes of the slash-E-T-C-slash-M-O-T-D. So running the tests will tell us if we have accidentally broken any of the existing functionality but there is nothing about the new functionality.

-
17
-

If everything looks good. Then we want to use `chef-client`. `chef-client` is not run on a specific cookbook -- it is a tool that allows us to apply recipes for multiple cookbooks that are stored within a cookbooks directory.

So we need to return home to the parent directory of all our cookbooks.

-
18
-

We use `chef-client`, from our home directory, to locally apply the run list defined as: the setup cookbook's default recipe.


-
19
-

And then verify that our slash-e-t-c-slash-m-o-t-d had been updated with our values. Great!

-
20
-

Well, is it great?

Now that we've defined these values, lets reflect:

What are the limitations of the way we captured this data?

-
21
-

How accurate with our m-o-t-d be when we deploy it on other systems?

-
22
-

Are these values we would want to capture in our tests?

-
23
-

If you have worked with systems for awhile the general feeling is that hard-coding the values in our file resource's attribute probably is not sustainable because the results are tied specifically to this system at this moment in time.

-
24
-

So how can we capture this data in real-time?

Capturing the data in real-time on each system is definitely possible.

One way would be to execute each of these commands, parse the results, and then insert the dynamic values within the file resource's content attribute.

We could also figure out a way to run system commands within our recipes.

Before we start down this path, I would like to introduce you to Ohai.

-
25
-

Ohai is a tool that detects and captures attributes about our system. Attributes like the ones we spent our time capturing already.

-
26
-

Ohai is also a command-line application that is part of the ChefDK.

-
27
-

Ohai, the command-line application, will output all the system details represented in JavaScript Object Notation (JSON).

-
28
-

As I mentioned before these values are available in our recipes because `chef-client` and `chef-apply` automatically execute Ohai. This information is stored within a variable we call 'the node object'.

-
29
-

The node object is a representation of our system. It stores all these attributes found about the system. It is available within all the recipes that we write to assist us with solving the similar problems we outlined at the start.

Lets look at using the node object to retrieve the ipaddress, hostname, total memory, and cpu megahertz.

-
30
-

Above is the visualization of the node attributes as a tree. That is done here to illustrate that the node maintains a tree of attributes that we can request from it.

Below is the hard-coded value we currently have in the file resource's content attribute.

At the bottom is an example of how we could use the node's dynamic value within a string instead of the hard-coded one.

-
31
-

The node maintains a hostname attribute. This is how we retrieve and display it.

-
32
-

The node contains a top-level value memory which has a number of child elements. One of those child elements is the total amount of system memory.

Accessing the node information is different. We retrieve the first value "memory", returning a the subset of keys and values at that level, and then immediately select to return the total value.

-
33
-

And finally the megahertz of the first cpu.

-
34
-

In all of the previous examples we demonstrated retrieving the values and displaying them within a string using a ruby language convention called string interpolation.

-
35
-

String interpolation is only possible with strings that start and end with double-quotes.

-
36
-

To escape out to display a ruby variable or ruby code you use the following sequence: number sign, left curly brace, the ruby variables or ruby code, and then a right curly brace.

-
37
-

So lets replace the static ipaddress with the node's ipaddress. We will use string interpolation within the file resource's content attribute to allow us to access the node object's attribute for ipaddress.

-
38
-

We will continue to do that for the node object's attribute for hostname.

-
39
-

For the total memory.

-
40
-

And for the megahertz of the first CPU.

-
41
-

Again we have created a change.

Move into the setup cookbook's directory.

Verify the changes we made to the setup cookbook's default recipe with kitchen.

Return to the home directory

And then use chef-client to locally apply the setup cookbook's default recipe.

-
42
-

Good. Now that we've made these significant changes and verified that they work its time we bumped the version of the cookbook and commit the changes.

-
43
-

The first version of the cookbook displayed a simple property message in the slash-e-t-c-slash-m-o-t-d. The changes that we finished are new features of the cookbook.

-
44
-

Cookbooks use semantic version. The version number helps represent the state or feature set of the cookbook. Semantic versioning allows us three fields to describe our changes: major; minor; and patch.

Major versions are often large rewrites or large changes that have the potential to not be backwards compatible with previous versions. This might mean adding support for a new platform or a fundamental change to what the cookbook accomplishes.

Minor versions represent smaller changes that are still compatible with previous versions. This could be new features that extend the existing functionality without breaking any of the existing features.

And finally Patch versions describe changes like bug fixes or minor adjustments to the existing documentation.

-
45
-

So what kind of changes did you make to the cookbook? How could we best represent that in an updated version?

-
46
-

Changing the contents of an existing resource - by adding the attributes of the node doesn't seem like a bug fix and it doesn't seem like a major rewrite. It is feels like a new set of features while remaining backwards compatible.

So lets update the version's minor number to 0.2.0.

-
47
-

The last thing to do is commit our changes to source control. Change into the directory, add all the changed files, and then commit them.

-
48
-

Wonderful. Now its time to add similar functionality to the apache cookbook.

Update the file resource, named slash-var-slash-dub-dub-dub-slash-h-t-m-l-slash-index-dot-h-t-m-l, to be created with the content that includes the node's ipaddress and its hostname.

Run the tests to verify that the changes did not break anything.

Update the version of the cookbook.

And then commit the changes.

> Allow the attendees time to complete this exercise

-
49
-

Similar to the work that we did in the setup cookbook, we add our two node attributes using string interpolation.

-
50
-

We change into the apache cookbook's directory.

-
51
-

Then we run `kitchen test` to verify that the changes we introduced did not cause a regression.

-
52
-

If everything passes then we feel confident that it will also work on the current workstation. So lets return back to the home directory...

-
53
-

...beause we want to use `chef-client` to apply the apache cookbook locally to the system.

-
54
-

Showing these two attributes in the index html page seems very similar to the feature we added for the setup cookbook. So I chose to update the version of the apache cookbook to 0.2.0 as well.

-
55
-

And finally the changes should be committed.

-

With that we have added all of the requested features.

What questions can we help you answer?

In general or about specifically about ohai, the node object, node attributes, string interpolation, or semantic versioning.

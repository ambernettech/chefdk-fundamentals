## Cookbooks

Well the recipe that you put together to setup the workstation proved useful. Useful enough to see if the same could be done with a webserver.

That shouldn't be a problem right?

It's a package, a file, and a service. Everything you've already completed - well almost everything.

Now the request to add version control and a README would definitely make it easier to share the recipes that we create.

Without version control we'd have no way to build this software collaboratively or recover our work.

Without a README no one would know what the recipe even was suppose to do or what it did.

-

Lets pick a version control system.

-

Lets explore this first option of renaming the file. Add a quick extension and that way we can keep working on the original file as we add more features.

-

As a group lets talk about the pros and cons of using this strategy.

-

So obviously a single backup won't do. We need backups more often as we are going to be iterating quickly. So we could use the current date and time down to the minute.

-

As a group lets talk about the pros and cons of using this strategy.

-

Alright, would adding the user's name to the end of the file solve the problems we are facing with other choices.

-

Again pros and cons of this new approach

-

What if we stored this information in a wiki?

-

What are the pros and cons of this approach.

-

How about we use git?

-

What are the pros and cons of this approach.

-

For the rest of this workshop we will be using git.

-

Is git installed? Do we know if it will be installed with every new instance that is setup?

It sounds like we need the tool now to store our cookbook but we also want to define a policy that git is installed on all of our workstations.

Lets update our setup recipe to define a new statement of configuration policy:

The package named 'git' is installed

> Allow time for individuals to complete this exercise.

-

We add a package resource named 'git' to the setup recipe within our workstation cookbook.

-

Then we use chef-apply to apply our recipe. The recipe path has changed. Remember it is inside the workstation cookbook's recipe directory.

-



Lets tackle this head on. If we're going to use Chef as a configuration management tool and we are going to treat our infrastructure as code we need to make sure that we start using version control.

-

What's the best way to learn Chef? Use Chef. I want you to literally run Chef.

-

Chef is a command-line application that does quite a few things. The most important thing to us right now is its ability to generate cookbooks and components.

But what is a cookbook?

-

Lets look up cookbooks in Chef's documentation. Visit the docs page on cookbooks an read the first three paragraphs.

> This sounds CRAZY to ask people in a physical classroom to read this content but it is important that they learn to read the documentation.

A cookbook is a structure that contains recipes. It also contains a number of other things -- but right now we are most interested in a finding a home for our recipes, giving them a version, and providing a README to help describe them.

-

Well lets examine the chef generate command. We see the command is capable of generating a large number of different things for us. Sounds like if we want to generate a cookbook we're going to need to use 'chef generate cookbook'.

Lets ask the `chef generate cookbook` command for help to see how it is used.

-

Alright. To generate a cookbook all we have to do is provide it with a name. Uh oh! Naming things - there are two hard things in Computer Science and one of those is giving something a name.

-

Don't worry I have you covered. Call the cookbook workstation. That's a generic enough name.

I want you to use chef generate to generate a cookbook named 'workstation'.

-

Aren't you curious whats inside it? Lets take a look with the help of the `tree` command. If we provide `tree` with a path we will see all the visible files in the specified directory.

So the chef cookbook generator created an outline of a cookbook with a number of default files and folders. The first one we'll focus on is the README.

-

All cookbooks that chef will generate for you will include a default README file. The extension m-d means that the file is a markdown file. Markdown files are text documents that use various punctuation characters to provide formatting. It is meant to be easily readable by humans and can be easily be rendered as HTML or other formats by computers.

-

The cookbook also has a metadata file.

-

This is a ruby file that contains its own domain specific language (DSL) for describing the details about the cookbook.

-

If you cat the contents of our new cookbook's metadata you'll see a number of details that help describe the cookbook. The name of the cookbook, its maintainer, a way to reach them, how the cookbook is licensed, descriptions, and the cookbook's version number.

-

The cookbook also has a folder named recipes. This is where we store the recipes in our cookbook. You'll see the generator created a default recipe in our cookbook. What does it do?

-

Looking at the contents of the default recipe you'll find its empty except for some ruby comments. A cookbook doesn't have to have a default recipe but most every cookbook has one. It's called default because when you think of a cookbook it is probably the recipe that defines the most common configuration policy.

-

Lets move our recipe to the workstation cookbook and place it alongside our default recipe.

-

Well now that we have our cookbook with its README and version number its time to add it to version control.

-

Lets change folder into the workstation cookbook.

-

We want git to start tracking the entire contents of this folder and any content in the subfolders. To do that with git you execute the command `git init` in the parent directory of the cookbook you want to start tracking.

-

Now we need to tell git what files it should start tracking in source control. In our case, we want to add all the files to the repository and we can do that by executing `git add dot`.

This will place all the files into a staging area.

-

I like to think of the staging area as placing a bunch of items into a box. Like a care package you would send to a love one.

Staging files means - put them in the box, don't close it up because I may add a few things, don't close it up because I may replace or remove a few things. But put the items in the box because eventually we are going to close that box - when it is ready to send it off.

-

Lets look to see what changes we have placed in the staging area.

Thinking about our care package example, this is like looking inside the box and taking an inventory. Allowing us to figure out if we need to move things around or we're ready to close it.

Running `git status` allows us to see in the box. Git reports back to us the changes that will be commited.

> Git helpfully tries to show you the command you can use to remove an item from that box. This is useful if you want to include all items excepts for one or simply manage everything before you commit.

-

If everything that is staged looks correct then we are ready to commit the changes.

That is like saying we're ready to close the box up.

That is done in git with `git commit`. We can optionally provide a message on the command-line and that is done with the DASH-M flag and then a string of text that describes that change.

However, if you run this command it will fail because git needs a minor amount of configuration information. Specifically an email address and a user name. It provides the commands to do that so lets execute those.

-

First we'll setup the email address. I use the email address associated with my GitHub account but that is not required or even necessary to use git.

-

And second we'll setup the username. This is usually my GitHub account name but again that is not required data for this field.

-

So we again we use the git commit command with the DASH-M flag and then a string of text the describes that change.

This time all the files should be committed successfully.

-

Now that we are done adding our workstation cookbook to source control lets return to our home directory.

-

We got a little sidetracked with cookbooks, versioning, and source control. Remember, we were asked if we could write a recipe to setup a web server.

-

Thinking about what we accomplished so far that totally seems possible.

We would need to write a recipe that defines the policy for apache. Create a cookbook to store that recipe and then add the cookbook to version control.

So show me it can be done!

> Allow individuals a fair amount of time with this exercise.

-

Alright first I would leverage the chef command-line application to generate a cookbook for me. From my home directory running the command `chef generate cookbook apache`. This will place the apache cookbook alongside the setup cookbook.

-

The server recipe defines the policy:

* The package named apache2 is installed.

* The file named slash-var-slash-dub-dub-dub-slash-h-t-m-l-slash-index-dot-h-t-m-l is created with the content "Hello, world!"

* The service named apache2 is started and enabled.

For service you could define two resources with the same name and each with a different action: start and enable.

-

But you can also to combine these actions together into a Ruby array and provide that as a value to the action attribute.

-

Applying the recipe with `chef-apply` I need to specify the partial path to the recipe file within the apache cookbook's recipe folder.

-

We setup apache which is a web server. So lets verify that the website is available and returns the content we expect to see.

-

Finally its time to add the apache cookbook to version control.

* Move into that directory
* Initialize the cookbook as a git repository
* Add all the files within the cookbook
* And commit all the files in the staging area

-

What questions can we help you answer?

General questions or more specifically about cookbooks, versioning and version control.

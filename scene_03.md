## Resources

Welcome to the team. Everyone is glad you're here because we're busy! Seems like we are always reacting to problems, never able to get ahead.

We couldn't even finish setting up your workstation.

-

Well let's see how far they got. Were they able to install an editor on our workstation?

Let's pick an editor and then use Chef to install it.

-

There are three command-line editors that we can choose from. Each with their own strengths and weaknesses. Let's review their common commands for opening and writing files to the filesystem.

-

* Emacs

Emacs is fairly straightforward for editing files. It uses a chorded key system for commands. So the commands for writing to a file and exiting all start with CTRL+X and are their respective command.

* Nano

Nano is usually touted as the easiest editor to get started with editing through the command-line. There is no save. Nano will prompt you on exit if you would like to save the changes. You press Y to accept the changes and then ENTER to confirm to save to the filepath.

* Vim

Vim is more complex because of its different modes. The important keystroke to remember is 'i', placing you in text entry mode, which allow you to INSERT text into the document. When you are done editing, you need to return to commands mode by pressing ESC. And then you can send commands to write and quit with :w and :q respectively.

-

Great. Now that you've picked your editor, you need to find out if it is already installed. We can use the `which` command and ask the Operating System (OS) if it knows if there is an executable for our text editor in our path.

Is nano installed? No it doesn't look like it.

-

Is vim installed? No it doesn't look like it either.

-

Is emacs installed? Seems like it isn't as well.

It seems your workstation doesn't have any of the preferred command-line editors installed. So that means there is a little more configuration left for you to do.

But before you go and figure out the linux distribution and start installing packages through the distribution's specific package manager -- this seems like a perfect oppurtunity to experiment with how to solve configuration problems with Chef.

-

One of the best ways to learn a technology is to apply the technology in every situation that it can be applied. A number of chef tools are installed on the system so lets put them to use.

-

The first tool we will explore is `chef-apply`. It is a command-line application that allows us to work with resources and recipes files.

-

But what are resources? What are recipe files?

Let's answer these questions one at a time.

-

First, let's look at Chef's documentation about resources. Visit the docs page on resources and read the first three paragraphs.

> This sounds CRAZY to ask people in a physical classroom to read this content but it is important that they learn to read the documentation. And particularly this entry is very useful.

```
A resource is a statement of configuration policy that:

* Describes the desired state for an item
* Declares the steps needed to bring that item to the desired state
* Specifies a resource type—such as package, template, or service
* Lists additional details (also known as attributes), if necessary
* Tells the chef-client which action to take

Resources are grouped into recipes, which describe working configurations. For example, a package to install, the location of a template from which to build a file, and a service to be started.

Where a resource represents a piece of the system (and its desired state), a provider defines the steps that are needed to bring that piece of the system from its current state into the desired state.
```

Resources describe what we want our system to look like AND sound like they do all the work to make it look like that.

Let's look at a few examples of resources.

-

The package named 'httpd' is installed.

-

The service named 'ntp' is enabled and started.

-

The file named slash e-t-c slash m-o-t-d is created with content "This company is the property ..."

-

The file named slash e-t-c slash m-o-t-d is deleted.

-

Let's return to the `chef-apply` command. It looks like you can supply a resource or resources, in a string -- or text, with the DASH-E flag.

Editors are software and software is delivered to our system through packages. So it seems like you could use the package resource to install our preferred editor.

-

If I wanted to install the nano package I would probably run this command with the following text:

```
$ sudo chef-apply -e "package 'nano'"
```

Install the editor you chose with `chef-apply`.

-

Let's verify that the editor is installed by again using the `which` command. I installed the nano editor and now which reports to me where it was able to find nano executable.

-

* What happens when I run the command again?

Before you execute the command. Think about what will happen. Think about what you would want to happen. Look at the output from the previous run. Then take a guess. Write it down or type out what you think will happen.

Then run the command again

-

* What would happen if the package were to become uninstalled?

What would the output look like when you run this command? Was there a situation where the package was already uninstalled and we executed this resource text?

-

Hopefully it is clear from running the `chef-apply` command a few times that the resource we defined only takes action when it needs to take action.

We call this test and repair. Meaning the resource first tested the system before it takes action.

-

If the package is already installed, then the resource does not need to take action.

If the package is not installed, then the resource NEEDS to take action to install that package.

-

Great! You installed an editor using `chef-apply` but we missed a very important step:

Chef is written in Ruby. Ruby is a programming language and it is required that the first program you write in a programming language is 'Hello World'.

So let's walk through creating a recipe file that creates a file named 'hello.txt' with the contents 'Hello world!'.

-

Using your editor open the file named 'hello.rb'. 'hello.rb' is a recipe file. It has the extension DOT-R-B because it is a ruby file.

-

Add the resource definition displayed here.

We are defining a resource with the type called 'file' and named 'hello.txt'. We also are stating what the contents of that file should contain 'Hello, World!'.

Save the file and let's return to the terminal and the `chef-apply` command.

-

Using the help again it looks like that we can provide a recipe file directly to the `chef-apply` command.

-

To apply our recipe we would need to type `sudo chef-apply hello.rb`.

Reviewing the output you should see a file named 'hello.txt' was created and then the contents of the was updated to include our 'Hello, World!' text.

-

And to prove that a file was created you can use the `cat` command with the path of the file, 'hello.txt'. The result of the command should show you the contents 'Hello, world!'.

-

So what happens when I run the command again?

Again before you run the command -- think about it. What are your expectations now from the last time you ran it? What will the output look like?

-

What would happen if you modified the contents of the file?

Go ahead and modify the contents of 'hello.txt' with your text editor. Write the file and then think about what you expect to see in the output. Then run the command.

-

And, of course, what would happen if the file was removed?

At this point you hopefully you are starting to understand the concept of test and repair.

-

Let's take a moment and talk about the structure of a resource definition. We'll break down the resource that we defined in our `hello.rb` file.

-

The first element of the resource definition is the resource type. In this instance the type here is 'file'. Earlier we used 'package'. I showed you an example of 'service'.

-

The second element is the name of the resource. This is also the first parameter being passed to the resource.

In this instance the resource name is also the relative file path to the file we want created. We could have specified a fully-qualified file path to ensure the file was written to the exact same location and not dependent on our current working directory.

-

The `do` and `end` keywords here define the beginning of a ruby block. The ruby block and all the contents of it are the second parameter to our resource.

The contents of this block contains attributes (and other things) that help describe the state of the resource. In this instance, the source attribute here specifies the contents of the file.

Attributes are laid out with the name of the attributes followed by a space and then the value for the attribute.

-

The interesting part is that there is no action defined. And if you think back to the previous examples that I showed you not all of the resources have defined actions.

So what action is the resource taking? How do you know?

-

Can you find that information in the output from running `chef-apply`?

Could you find that information in the documentation for the file resource?

Read through the file resource documentation.

First, find the list of actions and then see if you can find the default one.

Second, find the list of attributes and find the default values for mode, owner, and group.

The reason is that I want you to return to the file resource in 'hello.rb' and add attributes for mode, owner and group. But only if the values here are different from the default values.


> Allow the attendees time to solve this exercise

-

The file resources default action is to create the file. So if that is the policy we want our system to adhere to then we don't need to specify it. It doesn't hurt if you do, but you will often find when it comes to default values for actions and attributes we tend to save ourselves the keystrokes and forgo expressing them.

The file resource, in hello.rb, does however need to add three new attributes: mode; owner; and group. And that is because the default values for these attributes are not the ones we want in our configuration policy.

-

What questions can we answer for you?

-

Now that you've practiced:

* installing an application with the package resource
* creating a recipe file
* creating a file with the file resource

Create a recipe named 'setup.rb' that

* Installs the editor
* Installs the tree package
* And then creates an MOTD file

Let's break that down:

-

What is the resource definition for this description: `The package named $EDITOR is installed.`

-

What is the resource definition for this description: `The package named tree is installed.`

-

What is the resource definition for this description: `The file named "/etc/motd" is created with the content "Property of ...".`

-

> Allow the attendees time to solve this exercise

-

Here is the final version of the `setup.rb` file that installs all the editors, our tree package, and creates our MOTD file.

-

Let's finish up this section on resources with a discussion.

I want you to write down or type out a few words for each of these questions. Because I want each of you to talk about your answers with each other.

Remember that the answer "I don't know! That's why I'm here!" is a great answer.

Alright lets answer these four questions:

-

* What is a resource?

-

* What are some other possible examples of resources?

-

* How did the examples resources we wrote describe the desired state of an element of our infrastructure?

-

* What does it mean for a resource to be a statement of configuration policy?

-

With your answers, turn to another individuals in this workshop and alternate asking each other asking these questions and sharing your answers.

-

What questions can we answer for you?

About anything or specifically about:

* `chef-apply`
* resources
* a resources default action and default attributes
* Test and Repair

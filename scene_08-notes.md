# Desired State and Data

## Purpose

As an attendee I am given technical challenge of move the data out of the recipe file and into a template file.

## Motivation

Composing content for files within the recipe is not sustainable. There are a number of pitfalls working with large complicated bodies of text within a Ruby source file so in this section we explain the power and use of templates and ERB.

## Typical Pace

30 minutes

## Flow

At the close of the last setion we update the message-of-the-day file and the web server's index file to display important attributes about the node.

The objective given to the attendees is to clean up the recipes that we have defined. We first review the recipe and talk about the current state of the recipe and how the file resource's attribute content has now started to dominate the recipe.

We want to explain some more details about Ruby strings as a cautionary tale of adding new content to the file. We explain the rules of how double-quoted strings work in Ruby. How to include literal double-quotes into the String as well as the importance of the backslash escape character. We explain that using the content attribute to define the contents of the file may also lead to unexpected formatting of the file when it is rendered.

We make a statement that for us to more reliably manage the data like this we need for it to be in its own file format but still allow us to escape out to display Ruby code.

We define a new objective to find an alternative to the file resource. We ask the attendees to read the documentation and find the three alternatives outlined on the page.

We explore each of the alternatives and explain their uses.

> SEE: File Resource Alternatives

We have a discussion to talk about the various alternatives. Even if remote_file and cookbook_file seem obviously not the choice it is useful to use the context we are currently working in to understand their place and value as resources. This will help the attendees use these resources later when confronted with a different situation.

We remind the attendees that the `chef generate` command is able to generate cookbook components. We walk through discovering information about template generation. We demonstrate generating a template for the apache cookbook.

We explore where the files was created within the cookbook. It is important as the file structure is new to most attendees, so adding another file increases the complexity. We point out the file was created with an ERB extension.

We explain how ERB templating works by demonstrating some source code that uses beginning tags, closing tags, tags that do no show output, and tags that show the output.

We demonstrate copying the existing contents of our file resource's content attribute. We demonstrate replacing the string interpolation syntax with the ERB syntax.

We focus the objective on creating the template resource within the recipe. We walk through deleting the unneccessary content field and replacing the file resource with the template resource. We explain that for us to link the template in the file directory to the template resource we need to define a source attribute and specify the correct value to the template file.

We demonstrate how to determine the path to the file and use that value within the source attribute.

As an exercise we ask the attendees to complete the verification, application, versioning, and committing of the changes. After the exercise we demonstrate those steps.

As an exercise we ask the attendees to complete the same series of steps for the workstation cookbook. After the exercise we demonstrate those steps.

We finish the section with a discussion and answering questions.


## File Resource Alternatives

### remote_file

Remote file is essentially file but with the ability to download the file from a remote location. So to use this resource we would need to host a file on the Internet or private network.

There is no way to insert node attributes in the file that we retreive.

Remote file is really great for grabbing files/packages from a build system or a release server. It is often used when say pulling down the latest build of a software package, unpacking it, and installing it as part of the recipe.

### cookbook_file

Cookbook file allows us to define a file within the cookbook. This ensures that we can ship the file with the cookbook and it can be delviered to the system that we are hoping to configure.

There is no way to insert node attributes in the file that we ship with the cookbook.

Cookbook file is great for binary files or files where the contents do not need ever need to be modified. If it is text file often times it is better to use a template even if the cookbook file does not need insert values into the template.

### template

Templates allow us to package a file with the cookbook. That way we can ship the cookbook with the template file that we are going to write to the target system.

Templates provide a way to insert node attributes and other data into that file when it is copied.

This is the best choice for any text files like configuration files.








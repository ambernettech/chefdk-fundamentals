-
1
-

## Policy and Data

Separating the content from the policy for clarity

-
2
-

In the last section we updated our two cookbooks to display information about our node. We added this content to the file resource in their respective recipes.

-
3
-

What if new changes are given to us for the website splash page. Each new addition we would need to return to this recipe and carefully paste the contents of the new html into the string value of the content attribute.

-
4
-

There are some things that we need to becareful of when working with double-quoted strings with Ruby. It is that double-quoted strings are terminated by double-quoted strings so if any of the text that we paste into this content field has double quotes it is going to have to be escaped.

-
5
-

With Ruby strings we can use the backslash character as an escape character. In this case if we would want to have a double-quote in a double-quoted string we would need to place a backslash before the double-quote.

-
6
-

So that also brings up an issue with continually pasting in text. We will also need to keep an eye out for backslash characters. Because backslash characters are now the escape character. If you want to literally represent a backslash you need to use two-backslashes.

-
7
-

So every time text is pasted into the string value of the content attribute we will need to find and replace all backslashes with double-backslashes and then replace all double-quotes with backslash double-quotes.

-
8
-

Also it is important to note that the formatting of the string value of the content field may have some white space requirements and it is often easy to forget that because the text is inside a recipe file.

Besides that as the shear size of the string value of the content field grows it will consume the recipe. Making it difficult to understand what is policy and what is data.

-
9
-

To me this sounds like a bug waiting to happen.

Any process that requires me to manually copy and paste values and then remember to escape out characters in a particular order is likely going to lead to sadness later when I deploy this recipe to production.

-
10
-

More desireable is being able to store this data in another file. The file would be native to whatever format it required so it wouldn't require escaping any common characters.

But we still need a way to insert node attributes. So really we need a native file format that allows us to escape out to ruby.

-
11
-

To solve this problem I think we are going to need to read up on the file resource more or see if Chef provides other resources we could use to solve this problem.

-
12
-

Lets start from what we know. The file resource. Open the documentation and see what it says and see if it gives us an clue to alternatives.

The file resource documentation suggests a couple of alternatives to using the file resource: cookbook_file resource; template resource; and remote_file resource.

Lets start with the remote_file resource:

-
13
-

Reading the documentation for remote_file, it seems that remote_file is similar to file. Except remote_file is used to specify a file at a remote location that is copied to a specified file path on the system.

So we could define our index file or message-of-the-day file on a remote system. But that does not allow us to insert attributes about the node we are currently on.

-
14
-

Reading the documentation for cookbook_file, after the boiler-plate resource definition, it sounds as though a cookbook file is capable of ...

-
15
-

... allowing us to store a file within our cookbook and then have that file transfered to a specified file path on the system.

While it sounds like it allows us to write a file in its native format. It does not sound as though the ability exists to escape out to access the node object and dynamically populate data.

-
16
-

Lets explore templates. Reviewing the documentation it seems as though it shares some similarities to cookbook_files. A template can be placed in a particular directory within the cookbook and it will be delivered to a specified file path on the system.

-
17
-

The biggest difference is that it says templates can contain ruby expressions and statements. This sounds like what we wanted: A native file format with the ability to insert information about our node.

-
18
-

And if we look at the bottom section about Using Templates we see more information about what is required and how we can use them to escape out to execute ruby code.

-
19
-

What resource could be used in this situation?

-
20
-

What resource will allow us to insert our node data into the file that it copies to the target system?

-
21
-

Why is using the template resource the best choice in this situation?

-
22
-

So our objective is clear. We need to use a template resource and create a template and then somehow link them together.

Lets start with creating the actual template file and then we will update the recipe.

-
23
-

Remember that applicaiton Chef. The one that generated our cookbooks. Well it is able to generate cookbook components as well. Templates and files (for cookbook_files) are a few of the other things it can generate for us.

-
24
-

Lets use help to review the command again.


-
25
-

And lets ask for help about the generate subcommand.

-
26
-

Finally lets ask for help for generating templates.

The command requires two parameters. The path to where the cookbook is located and the name of the template to generate. There are some other additional options but these two seem like the most important.

-
27
-

So we want to use chef generate template to create a template in the apache cookbook found in the cookbooks-slash-apache directory and the file we want to create is named index-dot-h-t-m-l.

-
28
-

Well that is the first step. Now the template exists is ready for us to define the content within the template file.

-
29
-

Now we need to understand what it ERB means.

-
30
-

ERB template files are special files because they are the native file format we want to deploy but we are allowed to include special tags to execute ruby code to insert values or logically build the contents.

-
31
-

Here is an example of a text file that has several ERB tags defined in it.

-
32,33
-

Each ERB tag has a beginning tag and an ending tag. The beginning tag is a less-than sign followed by a percent sign. The closing tag is a percent sign followed by a greater-than sign.

-
34
-

These tags are used to execute ruby but the results are not displayed.

-
35
-

ERB supports additional tags, one of those is one that allows you to output some variable or some ruby code. Here the example is going to display that 50 plus 50 equals the result of ruby calculating 50 plus 50 and then displaying the result.

-
36
-

The starting tag is different. It has an equals sign. This means show the value stored in a variable or the result of some calculation.

I often refer to this opening tag that outputs the content as the Angry Squid. The less-than is its head, the percent sign as its eyes, and the equals sign its tenticles shooting away after blasting some ink.

-
37
-

With that in mind lets update the template with the current value of the file resource's content field. Copying this literally into the file does not work because we no longer have the ability to use string interpolation within this html file.

-
38
-

We are going to need to change string interpolation sequence with the ERB template syntax. And it seems for this content we want to display the output so we want to make sure that we are using ERB's angry squid opening tag.

-
39
-

The template is created and the contents are correctly defined. It is time to update the recipe.

-
40
-

Lets open the apache cookbook's recipe named 'apache'.

We will want to remove the content attribute from the file resource. Because that content is now in the template. But only if we use a template resource.

-
41
-

So its time to change the file resource to a template resource so that it can use the template file that we have defined.

-
42
-

Last we need to specify a source attribute which contains that path to the template we generated. This path is relative starting from within the cookbook's template directory.

-
43
-

To visualize that with tree we can run it with a path that places us right at the templates directory. So the results will be relative paths from the point specified.

> The default folder denotes that we want to use this file for all platforms. 

And we see the filepath index-dot-h-t-m-l-dot-e-r-b.

-
44
-

Now we have the path to our template so we can update the the template resource's source attribute value.


-
45
-

We hopefully haven't changed the original goal of our recipe but we have made some changes.

-
46
-

So its time to use kitchen to verify the cookbook and use chef-client to apply the cookbook. If everything is working then update the patch number and commit the changes to version control.

-
47
-

The kitchen is a cookbook testing tool so we need to move into the cookbook directory.

-

There we run the kitchen verify command. Addressing any issues if they show up. 

-

Otherwise we return to the home directory, outside of all of our cookbooks because chef-client manages applying cookbooks.

-

And we apply the apache cookbook's default recipe to the local system.

-

If everything converges correctly, then it is time to update the version number. I mentioned earlier its a patch fix - we could argue if its a minor update - or we could get work done.

-

We return to the cookbook directory. Add all the changed files and commit them with a message.

-
53
-

Its time to do that again. This time for the setup cookbook.

Generate a template named motd, copy in the source attribute from the file resource, and then update it to use ERB tags.

Then come back to the recipe. Change it a template resource and then add a source attribute whose value is that partial path to the new template you created.

-

-

-

-
63
-
What questions can we help you answer?

Generally or specifically about resources, templates, ERB, and Angry Squids.
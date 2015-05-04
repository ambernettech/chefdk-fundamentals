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

There are some things that we need to becareful of when working with double-quoted strings with Ruby. It is that double-quoted strings are terminated by double-quoted strings so if any of the text that we paste into this content field has double quotes it is going to have to be escaped.

-

With Ruby strings we can use the backslash character as an escape character. In this case if we would want to have a double-quote in a double-quoted string we would need to place a backslash before the double-quote.

-

So that also brings up an issue with continually pasting in text. We will also need to keep an eye out for backslash characters. Because backslash characters are now the escape character. If you want to literally represent a backslash you need to use two-backslashes.

-


So every time text is pasted into the string value of the content attribute we will need to find and replace all backslashes with double-backslashes and then replace all double-quotes with backslash double-quotes.

-

Also it is important to note that the formatting of the string value of the content field may have some white space requirements and it is often easy to forget that because the text is inside a recipe file.

Besides that as the shear size of the string value of the content field grows it will consume the recipe. Making it difficult to understand what is policy and what is data.

-

To me this sounds like a bug waiting to happen.

Any process that requires me to manually copy and paste values and then remember to escape out characters in a particular order is likely going to lead to sadness later when I deploy this recipe to production.

-
10
-

More desireable is being able to store this data in another file. The file would be native to whatever format it required so it wouldn't require escaping any common characters.

But we still need a way to insert node attributes. So really we need a native file format that allows us to escape out to ruby.

-

Lets consult the file resource documentation. Reading through it there are three suggestions as possible alternatives to the file resource: cookbook_file; template; and remote_file.

Lets start with cookbook_file




If we were being honest about the look for the recipe it is starting to get cluttered. It is difficult to understand, at a glance what are the resource attributes and what is the content being displayed by the content attribute.

In both these instances the size of the content files of the file resource are not likely becoming larger. But imagine if we decided to update the contents of our index.html page to contain css styling and more elaborate html. The size of the content attribute would become unweidly.

So our objective is to find a way that we can more clearly reprensent the policy we want to define separated from the data that we want to use to define it. This will help us "clean" up the respective recipes.


To find a new resource lets check the documentation. The file resource documentation suggests a couple of alternatives to using file: cookbook_file; template; and remote_file.

Let's read the documentation for each of these resources and see if any of them offer an alternative that will allow us to move the contents to a different file.

Reading the documentation for cookbook_file, after the boiler-plate resource definition it sounds as though a cookbook file is capable of allowing us to store a file within our cookbook and then have that file transfered to a specified file path on the system.

While it sounds like it allows us to write a file in its native format. It does not sound as though the ability exists to escape out to access the node object and dynamically populate data.

Lets explore templates. Reviewing the documentation it seems as though it shares some similarities to cookbook_files. A template can be placed in a particular directory within the cookbook and it will be delivered to a specified file path on the system.

The biggest difference is that it says templates can contain ruby expressions and statements. This sounds like what we wanted: A native file format with the ability to insert information about our node.

And if we look at the bottom section about Using Templates we see more information about how we escape out execute ruby code.

The last alternative is the remote_file. Reading the documentation here, it seems that remote_file is similar to file. Except remote_file is used to specify a file at a remote location that is copied to a specified file path on the system.

remote_file is unlike the cookbook_file because it is retriving the file from a remote location like a URL. The cookbook_file is looking for a file locally within the cookbook.

What resource could be used in this situation?

What resource will allow us to insert our node data into the file that it copies to the target system?

Why is using the template resource the best choice in this situation?

So our objective is clear. We need to use a template resource and a template requires us to generate a template and then reference that template from within the recipe with a template resource.

Lets start with creating the template and then we will update the recipe.

Remember that applicaiton Chef. The one that generated our cookbooks. Well it is able to generate cookbook components as well. Templates and files (for cookbook_files) are a few of the other things it can generate for us.

Lets use help to review the command again.

And lets ask for help about the generate subcommand.

Finally lets ask for help for generating templates.

The command requires two parameters. The path to where the cookbook is located and the name of the template to generate. There are some other additional options but these two seem like the most important.

So we want to use chef generate template to create a template in the apache cookbook found in the cookbooks-slash-apache directory and the file we want to create is named index-dot-h-t-m-l.

Well that is the first step. Now the template exists is ready for us to define the content within the template file.

ERB template files are special files because they are the native file format we want to deploy but we are allowed to include special tags to execute ruby code to insert values or logically build the contents.

Here is an example of a text file that has several ERB tags defined in it.

Each ERB tag has a beginning tag and an ending tag. The beginning tag is a less-than sign followed by a percent sign. The closing tag is a percent sign followed by a greater-than sign.

These tags are used to execute ruby but the results are not displayed.

ERB supports additional tags, one of those is one that allows you to output some variable or some ruby code. Here the example is going to display that 50 plus 50 equals the result of ruby calculating 50 plus 50 and then displaying the result.

The starting tag is different. It has an equals sign. This means show the value stored in a variable or the result of some calculation.

I often refer to this opening tag that outputs the content as the Angry Squid. The less-than is its head, the percent sign as its eyes, and the equals sign its tenticles shooting away after blasting some ink.


With that in mind lets update the template with the current value of the file resource's content field. Copying this literally into the file does not work because we no longer have the ability to use string interpolation within this html file.

We are going to need to change string interpolation sequence with the ERB template syntax. And it seems for this content we want to display the output so we want to make sure that we are using ERB's angry squid opening tag.

The template is created and the contents are correctly defined. It is time to update the recipe.

Lets open the apache cookbook's recipe named 'apache'.

We will want to remove the content attribute from the file resource. Because that content is now in the template. But only if we use a template resource.

So its time to change the file resource to a template resource so that it can use the template file that we have defined.

Last we need to specify a source attribute which contains that path to the template we generated. This path is relative starting from within the cookbook's template directory.

To visualize that with tree we can run it with a path that places us right at the templates directory. So the results will be relative paths from the point specified.

Well almost. We see that the file is within a default folder. The default folder denotes that we want to use this file for all platforms. We can ignore this platform folder for now and use the filepath index-dot-h-t-m-l-dot-e-r-b.

We now have our template, with the correct content, and defined in the recipe. We have made changes to our recipe so ...

Its time to use kitchen to verify the cookbook and use chef-client to apply the cookbook. If everything is working then update the patch number and commit the changes to version control.



























Actually we need to 
Well when I said it could generate cookbooks and cookbook components


The cookbook file resource is used for transfering files contained within the cookbook to the specified destination location. In our situation we need to be able to dynamically display details about the node. The cookbook_file resource does not allow you to pass values into the file. The contents has to remain static.

This makes cookbook_file a great alternative if we wanted to deliver a file with no dynamic content like a static asset. Such as an picture, ISO, or package.

The template resource is creates a file on the remote system with the help of a template file stored within the cookbook. The template fily is flexible enough to allow us to insert values that we pass into it or are available on the node object. 

To use a template a template resources has to be used in the recipe and a template file must be added to the cookbook.

Another alternative is the remote_file resource. This resource will transfer a file from a remote location to a location local to the system that is applying the recipe.

This is great for pulling archives and files from build systems or sites that are hosting software releases. The source of the file is a remote location which could possibly work for our situation - but similarly to the cookbook_file we would not be able to, very easily, update the contents of the file with the data from the node.

So what resource should we use in this situation that allows us to generate the cookbooks' respective files with the dynamically generated node data.

The best choice in this situation is the template resource? Why?

All three of the resources (cookbook_file, template, and remote_file) will generate the file on the destination system. The importance is that we need to be able to insert the dynamically generated node data into the results.

This is most easily done with the template resource which provides support for this because of its support for ERB (Embedded Ruby). ERB has a number of tags we will look at that allow us to escape out to insert Ruby code - similar to using string interpolation.

------------------

Our first objective we are going to make the Apache cookbook cleaner. We are going to generate a template for that cookbook then update the contents of that template to allow us to show our dynamic information. Then change the file resource in our recipe to use the template resource instead.

A quick review of the chef command remember it is an executable program that allows you degenerate cookbooks and other cookbook components a recipe is the cookbook component.

Reviewing that help for Chef Ouisie degenerate set command.

Asking chef generate for help we see that it is able to generate a template.

If we run the chef generate template command with the help flag were able to see that it requires us to specify the path to our cookbook and then the name of the template. There are additional options that we may specify but we are not interested in those at this time.

So from the home directory I want you to run chef generate template cookbooks/Apache space index. HTML.erb

This will generate our template file and if you review the output it will show us is that it is generated it in our cookbooks templates directory under another directory name default.

Now we need to define the contents of our template. Chef templates are written using ERV a ruby templating library.

And the ERV template allows Ruby to a bed inside a text file was specially formatted tags. This is similar to how we use string and tribulation to output results of Ruby variables or Ruby code.

Let's look at an example of an ERP template that demonstrates how we can write Ruby code within the specialized tags.

Here we see a an example of an ERP template with some text. Each year be tagged with in the file has a beginning tank and a matching ending tag. We see that the beginning tag is a less than present and sometimes less than percent equals. The closing tag is a percent greater than.

Each beginning tag has a matching ending tag without it and ERV will raise an errror.

There are two types of tax that we are using within this ERP template. The first series of tags illustrate the ability to execute Ruby code with conditional logic. The second example shows us performing a calculation. In this instance is adding two numbers together 50+50. The important difference in this tag is the =. The = will output the result of the operation that is being performed. This is not the case with the other tags that we saw a letter around this tag or series of tags.

I like to call the tag that shows the output the angry squid. I can't the English grade because I think the less than looks like the head of the squid the % it's eyes and the = its tentacles as it shooting at ink out. It helps me remember that the angry squid tag is used to output the information that I want to see from a review variable or calculation.

We are going to copy the current content of our final resources contents attribute field. First we are going to copy the file resources content attribute into the new template file that we created. ERV does not recognize string interpolation instead it uses the ERV template tags that I just showed you.

So we want to replace every instance of the string interpolation sequences with the ERP template sequences. Specifically we want to use the angry squid tag to output the information about our node in our template.

Alright now we have created a template and updated its contents to correctly display information about the node. the remaining step is for us to update the file resource to now be a template resource inside of our Apache cookbook.

Open up the Apache recipe in the Apache cookbook. Remove the content attribute in all of its data. Now I want you to replace the file type with the template type. And finally at a new attribute name source which contains the string index.HTML.ERV.

With the template updated it is now time for us to verify that our cookbook is able to run successfully when we run Artest and then successfully be applied to our system. First we'll move into the QuickBooks directory. Then we will execute kitchen verify. If everything passes successfully. We will move to the home directory and apply the Apache cookbook locally with the chef-client command.

If set client is successful in applying the Apache cookbooks default recipe then it is time for us to update the Version number and then commit the changes to the cookbook diversion control.

I want you to update the Cook books version to zero-dot-three-zero. Then I want you to move into the cookbooks directory. Used to get at. Get commit with a message that states that we have updated to use the template resource.

Wonderful the final exercise for this section now I want you to do the same thing for the setup cookbook. Use chef generate to create a template named Emma TD. ERV. Then remove the resource the filename/DTC/MO TD. And define a new resource that is the template name/UTC/M OTD is created with the source amctv.E RB and the mode is 064 for the user is rooted in the group is root.
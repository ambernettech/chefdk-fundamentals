# Cookbooks

## Purpose

As an attendee I am given technical challenges that will require me to understand the use of cookbooks as a packaging platform allow for cleaner representation of policy and data.

## Typical Pace

45 minutes

## Flow

We reward the success of the previous work the attendees have done by providing them new requirements to setup a webserver. Ah, the cost of success.

We start the exercise by inviting conversation on selecting a Version Control System (VCS). This exercise is an important thought exercise. While the workshop continues with git it is important to explore these concepts to emphasize the importance of using version control.

> SEE: Version Control System (VCS)

At the end of the conversation we ask the attendees to install the git package through updating the setup recipe and applying it.

We walk through the process of learning the `chef generate` commands that allow us to create a cookbook. The attendees have never been introduced to the idea of a cookbook so it is important to allow for them to read about them in the documentation.

We walk the attendees through the creation of a cookbook. We examine the README, the metadata.rb, recipes directory, and the recipe named default.rb.

We demonstrate moving the setup recipe into the new cookbook. Then walk through using git to initialize the cookbook as a repository, adding the files and commiting them. However, an error occurs (or may occur) as the Operating System (OS) may not find a default user to use for the git commits.

The attendees commit the changes now that git is properly setup.

They return to the home directory to ensure that they generate cookbooks in the correct location for the next exercise.

We present the attendees with an exercise to accomplish the original objective of setting up a new cookbook with a recipe that deploys an apache server.

> SEE: Apache Cookbook


## Version Control System (VCS)

Whether to include this in the training has always been controversial. While it is present and important to teach to become successful with Chef. It is not that important to lose your audience over.

The goal after this section of slides to include all the git commands on a single slide to make it easier to skip or remove from the slide deck.

### File Dot Back

* This VCS allows for one and only one back up of the file that is manually initiated.

* The file could be inappropriately copied over when selecting the wrong command while moving through the command history.

* Both the original file and the backup file exist on the same system.

### File Dot Timestamp

* This VCS allows for multiple backups of the file that is manually initiated.

* Each backup is probably difficult to describe where they were in the process of development.

* The file has a less likely chance of being inappropriately copied over.

* Both the original file and the backfile file exist on the same system.

### File Dot Timestamp - User

* This VCS allows for multiple backups of the file that is manually initiated.

* Each backup is somewhat easier to describe where they were in the process of development because now you can ask the person.

* The file has a less likely chance of being inappropriately copied over.

* Both the original file and the backfile file exist on the same system.

### Wiki

* This VCS allows for multiple backups of the file that is manually initiated.

* Each backup is easier to describe where they were in the process of development because now you can review the save message history.

* No longer dealing with files.

* As long as the wiki system has backups and redundancy there is less chance of loss of data

* Content changes need to be copied and pasted into the Wiki. Adding an additional dependency that must be updated. Introduces a possible conflicting source of truth of configuration.

### Git

* This VCS allows for multiple backups of the file that is manually initiated.

* Each backup is easier to describe where they were in the process of development because each commit requires a message (as good as the Wiki requirement - maybe slightly better).

* As long as you are storing the repository in a remote location that has redundancy and backups there is less chance of loss of data

* Content changes are committed and merged. Ensures a single source of truth.


## Apache Cookbook

```
The package named "apache2" is installed.
The file named "/var/www/html/index.html" is created with the content "<h1>Hello, world!</h1>"
The service named "apache2" is started.
The service named "apache2" is enabled.
```

There are a few solutions to this problem that the attendees discover while accomplishing this task. What I enjoy is watching their creativity when presented with the requirement that the service has two actions.

A possible solution is to define two separate service resources with the appropriate action defined.

```ruby

service "apache2" do
  action :start
end

service "apache2" do
  action :enable
end

```

Another is to attempt to use the action attribute incorrectly to specify the two values.

```ruby
service "apache2" do
  action :start, :enable
end
```

## Commentary

In my experience beginners have a difficult time with learning new concepts and also executing commands on the command-line (i.e. move files and directories). So this section does a decent job, in my opinion, of introducing the idea of a cookbook solely as a structure for our files and focusing on that without attempting to introduce too many more chef concepts.

Some additional exercises could be built around git. After the initial creation of the cookbook and copying in of the recipe the README could be updated to describe what the recipe does. This would create an opportunity use git to visualize the differences before before committing the new changes (`git diff`). Then after saving this commit they could review all the changes (`git log`).

The attendees could also be taught the `chef generate recipe` command as well.

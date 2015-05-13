# Chef Fundamentals

This is the outline for an in-person workshop. Each scene represents a series of activities that accomplish a goal and discover new concepts in Chef.


## Layout

The content is broken down into scenes or sections. This is currently done to make the process of managing the process of content creation and content management easier.

Each section has:

* Slides - the content to display to the attendees while teaching the concept
* Script - an example of the words you might use to describe the content to attendees
* Guide - additional information about how to lead that section of content 


## Teaching

This content can be taught in a few ways.

### One-Day Introduction to Chef

The focus is solely on local development on a cloud workstation already configured when they arrive. They learn the basics of reading, writing, and testing cookbooks. They configure a workstation with their neessary tools and also stand up a webserver.

At the end of the event we setup their local workstations and troubleshoot any installation problems.

Requirements:

* ONE (1) Ubuntu 14.04 Instance
* ChefDK Installed (v 0.5.1)
* A user named 'chef' that can login via password and has password-less sudoers access.
* Docker service running
* The kitchen-docker gem has been installed.

Completion:

https://github.com/chef-training/chefdk-fundamentals-repo

### Two-Day Chef Fundamentals

After the first day the attendees are shown how to manage multiple nodes and cookbooks with a Chef Server. The work is done on their own workstations. They bootstrap several nodes and coordinate them all with Chef to stand up a load balancer (wrapper cookbook around haproxy) that redirects traffic to nodes running a webserver.

Requirements:

* TWO (2) Ubuntu 14.04 Instance


## Our Play

Each scene is a markdown script (scene file). Each scene will have an accompanying slide deck (etc. pdf, keynote, powerpoint).

View the recordings (audio/video) of select sections to help deliver the content

https://drive.google.com/drive/u/0/folders/0BxSqvX6gSnKCSFpvUHI3Xzl0alE/0B1nt6eQeCbyRfnlSYXd2Y2JKU2hLZjl6cUpGLVlndEo0bjhRS3pjRU1iWVhkOEJwNkYzVVU

### Day 1

#### [01](scene_01.md) Chef Fundamentals

#### [02](scene_02.md) Getting a Workstation

#### [03](scene_03.md) Resources

https://asciinema.org/a/a92xcpd00enl35op3ucccixry

#### [04](scene_04.md) Cookbooks

https://asciinema.org/a/4l9m41z4shlalyjgkkfiwo41j

#### [05](scene_05.md) chef-client

https://asciinema.org/a/df9g6ju1laqp0htp850wxfj16

#### [06](scene_06.md) Testing Cookbooks

https://asciinema.org/a/13lrjzutoyhqsmexymz6oofwf

#### [07](scene_07.md) Attributes

https://asciinema.org/a/73qzy6dy84f7u94o7dn4na5w0

#### [08](scene_08.md) Separating Desired State and Data

https://asciinema.org/a/972ps9ydu9iw1cekfx3p5dua0

#### [09](scene_09.md) Workstation Installation

### Day 2

#### [10](scene_10.md) Connecting To Chef Server

#### [11](scene_11.md) Community Cookbooks

#### [12](scene_12.md) Managing Multiple Nodes

#### [13](scene_13.md) Roles

#### [14](scene_14.md) Search

#### [15](scene_15.md) Environments

#### [16](scene_16.md) Wrap Up

#### [17](scene_17.md) Further Resources


## Contributing

Each scene is deliverable. Allowing for the development and refinement of scenes while the others may still need the initial script or slides.

Please refer to the [issues](https://github.com/learnchef/chefdk-fundamentals/issues) to figure out what sections could use your attention.

* Found an issue with the slides - Open an issue. When you open the issue: 1) include a picture of the slide and information to identify its location (e.g. section name/number, slide number).

> The reason to open up issues an include the fix is because there is no good way to merge binary files. It would awful if you made changes to the same presentation file as someone else. It would be hard to find the differences.

* Add to the GUIDES - If you have taught the material or preparing to teach the material please feel free to contribute to a section GUIDE. These notes are useful for providing pre-canned examples of additional context, trouble-shooting tips, communicating meta-narrative to other instructors, or other things that would do not fit elsewhere in the content.

* Write the scene text - If you find a scene text is missing, write an initial outline of the scene. Don't worry someone will come through and clean it up. I promise. Plus it would be fun. You can help shape the words that are said aloud when the training is delivered. What should you use as inspiration? Well if there are slides then use those -- none of those, well then it's fresh snow!

* Edit the scene text - Up above, I promised a people that you would edit the scenes. Editing a scene you want to obviously catch spelling and grammatical issues. But equally important is to ensure that the content being described works and is clearly expressed in the cotent.

* Writing the scene slides - If the slides aren't there then welcome to exciting world of Powerpoint. Hey if you don't have Powerpoint but have a great idea for slides -- do it anyways, because great content is great content.

* Edit the scene slides - I can't tell you the joy comes from reading the scene text and then looking over the slides. You see all the missing holes and that one little area that could use a little of your pixie dust. Remember slide decks only get better with a little love.

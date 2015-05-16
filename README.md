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

* ONE (1) Ubuntu 14.04 Instance from Day 1
* TWO (2) Ubuntu 14.04 Instance


## Our Play

Each scene is a markdown script (scene file). Each scene will have an accompanying slide deck (etc. pdf, keynote, powerpoint).

View the recordings (audio/video) of select sections to help deliver the content

https://drive.google.com/drive/u/0/folders/0BxSqvX6gSnKCSFpvUHI3Xzl0alE/0B1nt6eQeCbyRfnlSYXd2Y2JKU2hLZjl6cUpGLVlndEo0bjhRS3pjRU1iWVhkOEJwNkYzVVU

### Day 1

#### 01 Introduction

[Guide](scene_01-GUIDE.md) | [Script](scene_01-SCRIPT.md)

#### 02 Getting a Workstation

[Guide](scene_02-GUIDE.md) | [Script](scene_02-SCRIPT.md)

#### 03 Resources

[Guide](scene_03-GUIDE.md) | [Script](scene_03-SCRIPT.md)

https://asciinema.org/a/a92xcpd00enl35op3ucccixry

#### 04 Cookbooks

[Guide](scene_04-GUIDE.md) | [Script](scene_04-SCRIPT.md)

https://asciinema.org/a/4l9m41z4shlalyjgkkfiwo41j

#### 05 chef-client

[Guide](scene_05-GUIDE.md) | [Script](scene_05-SCRIPT.md)

https://asciinema.org/a/df9g6ju1laqp0htp850wxfj16

#### 06 Testing Cookbooks

[Guide](scene_06-GUIDE.md) | [Script](scene_06-SCRIPT.md)

https://asciinema.org/a/13lrjzutoyhqsmexymz6oofwf

#### 07 Attributes

[Guide](scene_07-GUIDE.md) | [Script](scene_07-SCRIPT.md)

https://asciinema.org/a/73qzy6dy84f7u94o7dn4na5w0

#### 08 Separating Desired State and Data

[Guide](scene_08-GUIDE.md) | [Script](scene_08-SCRIPT.md)

https://asciinema.org/a/972ps9ydu9iw1cekfx3p5dua0

#### 09 Workstation Installation

[Guide](scene_09-GUIDE.md) | [Script](scene_09-SCRIPT.md)

### Day 2

#### 10 Connecting To Chef Server

[Guide](scene_10-GUIDE.md) | [Script](scene_10-SCRIPT.md)

#### 11 Community Cookbooks

[Guide](scene_11-GUIDE.md) | [Script](scene_11-SCRIPT.md)

#### 12 Managing Multiple Nodes

[Guide](scene_12-GUIDE.md) | [Script](scene_12-SCRIPT.md)

#### 13 Roles

[Guide](scene_13-GUIDE.md) | [Script](scene_13-SCRIPT.md)

#### 14 Search

[Guide](scene_14-GUIDE.md) | [Script](scene_14-SCRIPT.md)

#### 15 Environments

[Guide](scene_15-GUIDE.md) | [Script](scene_15-SCRIPT.md)

### Day 3

#### 16 Releases

[Guide](scene_16-GUIDE.md) | [Script](scene_16-SCRIPT.md)


### Appendix

#### [A] Further Resources

[Guide](scene_further_resources-GUIDE.md) | [Script](scene_further_resources-SCRIPT.md)

#### [B] Day 1 Wrap Up

[Guide](scene_day_one_wrap_up-GUIDE.md) | [Script](scene_day_one_wrap_up-SCRIPT.md)

#### [C] Day 2 Wrap Up

[Guide](scene_day_two_wrap_up-GUIDE.md) | [Script](scene_day_two_wrap_up-SCRIPT.md)


## Contributing

Each scene is deliverable. Allowing for the development and refinement of scenes while the others may still need the initial script or slides.

Please refer to the [issues](https://github.com/learnchef/chefdk-fundamentals/issues) to figure out what sections could use your attention.

* Found an issue with the slides - Open an issue. When you open the issue: 1) include a picture of the slide and information to identify its location (e.g. section name/number, slide number). 2) Include the version of the slide deck you are using.

> The reason to open up issues an include the fix is because there is no good way to merge binary files. It would awful if you made changes to the same presentation file as someone else. It would be hard to find the differences.

* Add to the GUIDES - If you have taught the material or preparing to teach the material please feel free to contribute to a section GUIDE. These notes are useful for providing pre-canned examples of additional context, trouble-shooting tips, communicating meta-narrative to other instructors, or other things that would do not fit elsewhere in the content.

* Write the scene text - If you find a scene text is missing, write an initial outline of the scene. Don't worry someone will come through and clean it up. I promise. Plus it would be fun. You can help shape the words that are said aloud when the training is delivered. What should you use as inspiration? Well if there are slides then use those -- none of those, well then it's fresh snow!

* Edit the scene text - Up above, I promised a people that you would edit the scenes. Editing a scene you want to obviously catch spelling and grammatical issues. But equally important is to ensure that the content being described works and is clearly expressed in the cotent.

* Writing the scene slides - If the slides aren't there then welcome to exciting world of Powerpoint. Hey if you don't have Powerpoint but have a great idea for slides -- do it anyways, because great content is great content.

* Edit the scene slides - I can't tell you the joy comes from reading the scene text and then looking over the slides. You see all the missing holes and that one little area that could use a little of your pixie dust. Remember slide decks only get better with a little love.

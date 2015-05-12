# Testing Cookbooks

## Purpose

As an attendee I am given technical challenges that require me to host a reliable website that encourages me to use Cookbooks and cookbook testing methodologies to resolve them.

## Motivation

The motivation here is to have them demonstrate the testing feedback loop. This learning can be enhanced by showing the joy of a faster feedback loop through a comparison. Initially we ask them to demonstrate manual verification and then demonstrate the value of using tests for validation.

## Typical Pace

60 minutes

## Flow

We motivate the section by telling a story the story of building software on one type of Operating System (OS), testing the code on a fascimilie of the production environment -- you call staging -- and finally deploying to production to another OS that probably shares the same version as staging but has had more security patches applied.

We open up the discussion focused on the length of time it would take to validate one of the cookbooks we created on a brand new instance.

Collect the attendees contributions to a central location. Begin to order them from the beginning of the process to the end of the process. Allow them to contribute small details. Don't be afraid to add suggestions when they run out of ideas. Add them to the conversation as if you were truly sharing them with the group - not as forgone conclusions (SEE: Family Feud Game).

We describe the Test Kitchen tool and make claims that it will automate the entire verification process that the group defined on the board.

We start to explore with the command-line tool to see if we can discover more about it. We focus in on the `kitchen init` command as a good starting point. We explore what that command does and then we see if we already have that file in place.

The `.kitchen.yml` is hidden on UNIX systems because of the proceeding dot in the filename. The `tree` command allows us to see hidden files (-a) but we want to ignore some files (the entire .git directory) so that the output is more easily understandable to the attendee.

We see the file is already present so its time to take a look at it. We explain the importance of the many pieces of the kitchen configuration file.

Drivers are what turns on the instances. In most local development cases you are going to want to use the vagrant driver (05/12/2015) as it as a tool interfaces with virtualization tools like Virtual Box.

Provisioners is the tool that will install chef and get the cookbooks on and applied to the system. In most cases the default chef_zero is appropriate. chef_zero means to run in a local-mode manner similar to what the attendees have been doing already with the `chef-client` command.

Platforms define the systems to test against. The list of names that appear there is tied specifically to a project called [Bento](https://github.com/chef/bento). At this time the list of instances here is constantly moving forward. If a box by name is not listed it may have been moved to the [old box files](https://github.com/chef/bento/blob/master/OLD-BOXES.md).

Suites allow us to define the test suite we are going to run against the system. The test suite outlines the recipes that it will run when it converges. How the suite finds the test is based on a filepath built on the suite name.

We explain that the platforms times the suites created a test matrix. We explain how we can verify that information with the kitchen list command. The attendees are unable to verify it because of incorrect configuration.

We give them the objective to correctly configure the workstation cookbook to work with Test Kitchen. We walk the attendees through changing the driver to Docker and the platform to the same as their current platform.

We ask them to use `kitchen list` to see the test matrix that they have defined.

We now describe to them the various lifecycle stages that the kitchen command provides for us. It is often helpful to map these back to the steps that the group collectively created.

We demonstrate using `kitchen converge` to verify that we can deploy this recipe onto that virtual instance that is created for them.

As an exercise we ask the attendees to perform the same series of steps on the other cookbook. This is an exact copy of the work they just performed. Useful for the have a chance to create multiple errors while working with YAML files and being in the correct directories when attempting to execute the kitchen commands.

We walk through the process of updating that cookbook. We update the file and return home then into the apache directory if we are not already present within that directory.

After that we return our focus to testing by asking what `kitchen converge` has given us and what still remains to verify.

We explain that `kitchen converge` gives us the results that the cookbook has no errors when being applied. However, it does not test our true intention for that system. Usually this is the thing that most people will perform manually.

We explain kitchen verify, kitchen destroy, and kitchen test.

We explain that we will need a language to describe our tests and we propose ServerSpec as the choice. We describe a few examples and then ask them to write their first test to validate the 'tree' package is installed.

There is a long directory structure that Test Kitchen provides here. The reason this is done in this manner is so that it does not have to be written in a configuration file. The directory structure is suppose to help make it self-evident and in most cases of code it is important that those directory structures remain immutable to enhance code clarity.

After defining the first test we demonstrate verifying the system. This is a great moment to capture in version control. With the first test done we open a discussion about other things in the recipe that we can test.

Most attendees will immediately see the ability to test the package. We talk about testing files with ServerSpec and provide a few examples.

As an exercise we ask them to write additional tests. The goal is not to have them write every test - at least one more package test.

> SEE: What Makes a Good Test?

In review we show adding another package to the specification file and asserting that the file is owned by the root user. These should not reflect what the attendee had to accomplish.

We do not show the kitchen commands again but it is important that individuals run the kitchen verify commands as they make changes.

We describe that this is also a great moment where you have added more test coverage so its time to save your work.

We stop to answer any questions individuals might have after this discussion.

Finally we now ready to talk about testing the cookbook with our websever.

As a group we discuss what are things that we could test about the apache cookbook. Here the attendees will again pick package and a file. They have not tested a service but should be led to believe that it is possible with ServerSpec.

The final question in the discussion we want to remind them probably one of the most important tests that we could write and that is the ones that we often execute ourselves.

As an exercise we ask them to compose tests for the apache cookbook that meet their requirements or the requirements defined by the group. Encourage them to explore different ways in which ServerSpec can be used.

We demonstrate setuping up two tests for the apache cookbook. Ensuring that the port 80 is listening properly and the result of the curl command contains the content we are interested in seeing in the output.

> SEE: What Makes a Good Test?

We ask them to commit their work.

We answer questions and discuss the content introduced in this section.


## Testing

The time spent not testing has a serious effect on the entire organization. The manual process with regards to configuration management are hidden technical debt.

In the above proposed argument for testing the time-value proposition is very strong. By asking them to define the steps they will also callout all the steps that tools like Test Kitchen automate for you.

Remind them that the time has an effect on the entire organization. Thirty minutes to turn on hardware, load chef, copy the cookbooks, and apply them is not reasonable. When the fix that is being proposed may not work. Which means for true accuracy on that immediate fix you will need another instance.

## Docker

For these remote machines we can't use vagrant. I believe vagrant does not play nice within the virtualization provided by the instances at this time. So instead we use the Docker driver.

The system is already pre-configured with Docker. Docker is running as a service that should be started and enabled on the system.

While troubleshooting it may be required to restart the Docker process.

## What Makes a Good Test?

Quite a few attendees will test the file as well for all manner of things related to the content. When people show you these examples gently guide them towards picking good tests.

This is hard question to answer and a harder question to convey because the value is not seen until the hardship is felt.

By allowing the attendees to define their own tests this allows them some sense of self-expression and exploration with reguarding testing. I would do your best to honor it. By writing a test they are making a judgement on the state of the world with the current body of knowledge. When you immediately point out that the test they write is terrible (e.g. 'too brittle', 'not focused', 'concerned with the implementation') they are less likely to find their way to the correct test.

When confronted with a test you feel is poorly-defined express reasons why by asking questions about test. These questions do not have to always immediately be on the offensive of breaking it.

* What does this test assert when executed?

* How is that important to the state of the system?


## Commentary

The introduction to Test Kitchen here is clunky. What I do like is using the kitchen command to discover init. That init leads us to question the existance of the kitchen configuration file but the next part where we have to explain the driver and provisioner parts in the slides bothers me. This does not give the learner a chance to discover this information.
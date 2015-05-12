# Resources

## Purpose

As an attendee I am given technical challenges to configure my workstation that require me to use Resources to resolve my configuration requirements.

## Motivation

The motivation is to provide a simple tangible use case by focusing solely on Resources. This smaller scope at the outset gives attendees the ability to see the value and effectiveness of Chef from the outset. Mastery of Resources, in this smaller domain, allows us to focus on a fundamental piece of Chef without the other overhead of the concepts.

## Flow

Attendees are given access to a virtual machine with all the necessary tools pre-installed. The attendees are given the challenge to install and configure their systems.

We demonstrate using the `package` resource to install a text editor on the system.

We lead a discussion starts them thinking about test-and-repair by asking them to run the command again or in an uninstalled scenario. Then we talk about test-and-repair.

We display a demonstration of this with the editor.

With the objective complete then we lead the attendees in a 'Hello, world!' example using chef. We demonstrate using the `file` resource to manage a file.

We lead a discussion on test-and-repair again in a number of scenarios.

We break down the structure of a resource definition. We leave them with the question what is the default action for the file resource.

We give them an exercise to read the doucmentation on the file resource. To find the default action and while they are there to find the default attribute values for mode, owner, and group.

We review the exercise. We open up the discussion to questions.

We give the attendees a new objective of capturing the entire system setup in a recipe file. We give them the additional requirement of installing the tree package.

We give them an exercise to accomplish this objective.

We walk through the exercise.

We finish with a discussion about resources.


## Troubleshooting

The number one issue in this section is that people will forget to includ `sudo` when executing the commands.

The attendees may have trouble remembering the package resource syntax because they previously used the `chef-apply` command to perform the installation.
# chef-client

## Purpose

As an attendee I am given a technical challenges that require me to compose a website home page with information about the node.

## Motivation

The motivation here is to demonstrate the power of Ohai and the data stored in attributes. The main exercise in this section should provide the attendees with a few data points to present about the node. A spectrum of data points should be selected: easy time retrieving data point from the operating system; hard time retrieving the data point the operating system; data point varies across operating systems. This helps demonstrate a usefulness of Ohai.

## Typical Pace

30 minutes

## Flow

The attendees are given the challenge to provide information about the node and add that information to their message-of-the-day and the default apache index page.

We demonstrate collecting the system information by running one command and then inserting that result into the file resource's content attribute.

When all the data is present in the file, we lead a discussion about why this approach is not sustainable. We ask the attendees how might they solve this problem.

Before we implement any of these solutions we explain that it has already been done for you through the Ohai command. We explain that Ohai is an application, `ohai`, but is also run and used by `chef-apply` and `chef-client`. We explain how the data is stored on something called "the node object".

We then demonstrate how the node stores this information and how we can retreive this information from the node for all the fields.

We explain the Ruby concept of String interpolation as a way that we may insert data into a string similar to the one that we have defined in the file resource's content attribute.

We demonstrate replacing each of the hard-coded values with the dynamic values populated from the node object.

As an exercise we ask the attendees to verify the changes to reinforce that when changes are made it is important to immediately run our test suite and apply the recipe to ensure that it all works.

We then talk about cookbook versions and how Chef intended the use of semantic versioning within cookbooks. We demonstrate updating the version of the workstation cookbook.

As an exercise we wask the attendees to perform the same series of changes for the apache cookbook to reinforce the concepts of setting the node attributes, verifying changes, updating the cookbook version, and committing those changes.

We demonstrate walking through the changes.

We end with a discussion about ohai, the node object, node attributes, string interpolation, and semantic versions.

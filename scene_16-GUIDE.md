## Releases

### Objective

#### The First Release

As a exercise give the attendees a link to a gist that contains the "splash page for the new website just finished by the designers". Ask them to update the template, run the tests, update the version, and upload the cookbook to the Chef Server. Verify that it works on the one node. Update the production environment restrictions to allow the new cookbook (now that it is tested). Re-run `chef-client` on all production systems and see the newly deployed website.


#### The Second Release

The attendees are given a new release of the website. This time it has a number of additional files and assets to go with the basic index.html page. This version contains a details page about the future product that is being released.

We start a conversation about how we could deliver the changes with the current apache cookbook. Should the changes continue to be present in the apache cookbook? With the change of the release structure to more than a single file we need to move to an alternative way to deploy the application. 

After exploring our options through conversation we decide to:

* create a new cookbook that represents the application
* this new cookbook is dependent on the apache cookbook
* we will use a remote_file resource to pull down the releases
* we will use an execute resource to unzip and deliver the code to the appropriate location

> BONUS: If we can create a situation that exercises compile time versus converge time.


#### The Rollback

It turns out the release of the product detail page was too premature. We talk and walk through a rollback procedure with the environment, backing it down to a previous version. We see the cookbook converge to the latest version but we find that the details page is still available and has been picked up by Reddit.

We learn the important lesson that Chef only manages recipes that it knows about. We instead lead the attendees through releasing a new version of the application cookbook that removes that file from the server.
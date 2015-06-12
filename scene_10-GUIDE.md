## The Chef Server

NEED: This section would really benefit with a handout, diagram of the Chef Server - Node - Workstation relationship. With the terms defined.


### Objective

#### Create a Hosted Chef Account

So you've got to walk through creating a Hosted Chef Server account. Let's talk about the various different groups of attendees that you will come in contact with while teaching this section:

* No Account At All
* Lost Account Password
* Attempts to Login with Email instead of Username

The next hurdle is that the experience for first time users is different from the attendees with the prior accounts.

* Prior Accounts

For those individuals it becomes important that they not use their Production Organization. Always ask them to make sure that their account's organization is not their work one. It is always better to setup a new organization in this instance.

Often times you will simply walk them through downloading the starter kit or reseting their keys.

Sometimes they have completed some part of the Chef Webinar series or attended a previously taught one-day event. In those instances it is safest for them to start a new organization because there could old cookbooks and things up on the server that will trump the code you create at the event.

* New Accounts

For them, currently the website takes you to a landing page that lets you download the starter kit. The starter kit will warn that it is reseting various keys. At this moment they have no clue what these keys means so I often the process to moving into a new home. When you move into a new home you want to change the keys so the former tenants can no longer come back.

> This is not the greastest analogy because not everyone has owned a home. It's not that accurate but the point is that the changing of the keys in this case is a good thing.



Once everyone has download the starter kit or keys the next goal is to either get their new keys into the code repository that they downloaded at the end of the first day or for you to get the cookbooks in that repository into that starter kit's cookbook directory. The end result is the same.

> The only not so great thing about this process is that there is not a very discoverable way to accomplish this information. If we keep closer to the song we started singing the content with we would let the knife command tell us what to read or look up. So some changes to knife will have to be made to make that possible.

With the starter kit in place they should verify that they can reach the Chef Server with a command. This command should now pass because the configuration and credentials are in place.

#### Upload our cookbooks to the Hosted Chef Server

Now with a chef repository connected to a Chef Server the clear objective is to look to see no cookbooks on the server, upload a cookbook and then see that cookbook on the server. Demonstrate once with one cookbook and then have the attendees perform the cookbook upload process again with the other cookbook.

#### Add our old workstation as a managed node

Similar to checking for cookbooks, we do the same here but for nodes. We see none and then we walk through bootstrapping a new node with them. Then we check out that list again and see the new node added.

Now we need to give that node a run list. We add a cookbook to the run list and then demonstrate logging into the remote node and running chef-client.

### Organizations

An organization does not always mean your company. Within your company you may feel the need to create separate organizations for each of your business units. You may find that the goals, systems and cookbooks of your cloud applications team is not the same as your corporate website team, or your desktop applications team. In those instances create new organizations to manage them all seems appropriate.

Some people use organizations as a gating system as well. As no cookbooks and other materials are not shared between organizations some teams need to only allow certain access to certain individuals. Some teams within a company have created two separate organizations. One for their development and testing. And one for production. This ensures that nothing reaches these other organizations unless it is explicitly copied over. This can be a benfit and it can also be a hazard as it introduces a new release system to manage.
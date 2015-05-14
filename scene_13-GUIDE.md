## Roles

### Objective

This section's goal is to illustrate that managing the web nodes specified in the proxy would continue to be a hassle as we add new nodes to our organization.

So we present them with the challenge of creating a system that will automatically add web nodes to be addressed by the Proxy Server.

#### Give our Proxy Node a Proxy Role

The more immediate goal would be to have the attendees work on the web role. Choosing to work on the proxy role sets up the exercise of creating the web role and having them assign it to be web nodes.

There are many ways to create roles.

* through the website
* through `knife role create`
* creating a role file and then using `knife role from file`

There is an important distinction choosing the last option because you as an individual that manages infrastructure it is important that you keep a copy of it in version control.

In the same way that we encourage individuals to store their cookbooks in version control, we should encourage them to store their roles in version control. This allows you to track the various changes on those with each commit that an individual makes. It also makes the data found in git the one source of truth. When individuals start to edit roles through the website or the `knife role edit/create` commands the value on the server is updated but the value stored in the version control is no longer up-to-date.

Check in the role to version control.

#### Give our Web Nodes a Web Role

As an exercise have them define a new role, add that role to each of the nodes, run `chef-client` on those two nodes.

Check in the role to version control.

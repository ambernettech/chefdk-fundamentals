## A / B Testing

### Objective

A new requirement comes down that the team wants to A/B test two different pages to see which has the highest user retention.

There are many ways that the problem could be solved. 

One way that it can be solved is through setting up a way to select a variable index page based on a node attribute. The node attribute sets it to one page or the other through a data bag that contains the setting. By default it choose one site unless there is a data bag item with the value to override it.

> This is not a long term solution but one that shows that in a pinch Chef can do some great things like providing a simple A / B Testing framework.

---
layout: post
title:  "Ordered testing with XUnit, NUnit and MSTest part 4: XUnit"
date:   2016-06-08 20:00:00 +0200
categories: test-frameworks development
---

In the [previous post](2016-06-07-ordered-tests-with-nunit-mstest-xunit-pt1-nunit) we looked at ordered testing in NUnit. Today we are going to implement ordered tests in XUnit. The code for this post can be found on [GitHub](https://github.com/Sebazzz/NetUnitTestComparison/tree/2016-06-05). **Disclaimer:** This code will have rough edges, and may not work for you, kill you cat or blow up in your face. 

This post is part of a series of posts on ordered testing:
{% include postseries.html posts=site.data.blog_orderedtests %}

## XUnit
To be finished later.


### Limitations
There are three limitations in the current implementation:

Each test class needs to be put in an unique test collection, but then test collections can be ordered against each other. 

Within a test collection, tests can be ordered. When a test fails, the other tests are happily execute and not ignored.

If one test is selected for execution, the dependencies of that test should also be executed. Currently only the test itself is executed.

### Tooling support

**Visual Studio runner:** The tests are not correctly ordered in the Test Explorer, but the tests themselves execute in the correct order. Grouping tests makes no difference. The test explorer probably applies its own ordering.

![Visual Studio Test Explorer showing XUnit ordered tests](/images/blog/2016-06-08-ordered-tests-with-nunit-mstest-xunit-pt4-xunit-testexplorer.png)

**Resharper runner:** While the test tree of Resharper does not appear to follow the correct ordering, the tests are actually performed in the correct order. Resharper probably uses its own mechanism to discover the tests.

![Resharper test runner showing XUnit ordered tests](/images/blog/2016-06-08-ordered-tests-with-nunit-mstest-xunit-pt4-xunit-resharper.png)

**Console runner:** Shows (and executes) the tests in the correct order.

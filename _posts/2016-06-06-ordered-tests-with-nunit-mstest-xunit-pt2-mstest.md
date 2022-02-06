---
layout: post
title:  "Ordered testing with XUnit, NUnit and MSTest part 2: MSTest"
date:   2016-06-06 20:00:00 +0200
categories: test-frameworks development
---

In the [previous post](/blog/2016/06/05/ordered-tests-with-nunit-mstest-xunit-pt1) we looked briefly at ordered testing. Today we are going to implement ordered tests in MSTest. The code for this post can be found on [GitHub](https://github.com/Sebazzz/NetUnitTestComparison/tree/2016-06-05). 

This post is part of a series of posts on ordered testing:
{% include postseries.html posts=site.data.blog_orderedtests %}

## MSTest
MSTest is the only framework of the three frameworks which has built-in support for ordered tests. Ordered tests are defined in an `.orderedtest` file, which is an XML file containing references to each test. This file can be created easily from the Visual Studio IDE using the visual editor, as shown below. You can specify that an ordered test should be aborted if one of the tests fail. This is useful if the tests have a functional dependency on one another. If the tests don't have a functional dependency on one another but one test mustn't execute before the other you can leave the option disabled.

![Visual Studio Ordered Test Editor](/images/blog/2016-06-05-ordered-tests-with-nunit-mstest-xunit-pt1/orderedtest-mstest.png)

The editor generates the XML file as shown below.

{% highlight xml %}
<?xml version="1.0" encoding="UTF-8"?>
<OrderedTest name="Integration" storage="z:\dev\netunittestcomparison\src\bankaccountapp.mstests.integration\integration.orderedtest" id="ebc36c0f-9d20-49c7-8c2f-c64839da8cc9" xmlns="http://microsoft.com/schemas/VisualStudio/TeamTest/2010">
  <TestLinks>
    <TestLink id="713421ca-4c7f-1c43-590e-b68d681c6952" name="PreIntegrationTest_FirstStep" storage="bin\debug\bankaccountapp.mstests.integration.dll" type="Microsoft.VisualStudio.TestTools.TestTypes.Unit.UnitTestElement, Microsoft.VisualStudio.QualityTools.Tips.UnitTest.ObjectModel, Version=14.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a" />
    <TestLink id="3a5d229c-73b4-bd13-5d64-4793126417dc" name="PreIntegrationTest_SecondStep" storage="bin\debug\bankaccountapp.mstests.integration.dll" type="Microsoft.VisualStudio.TestTools.TestTypes.Unit.UnitTestElement, Microsoft.VisualStudio.QualityTools.Tips.UnitTest.ObjectModel, Version=14.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a" />
    <!-- Removed for brevity -->
  </TestLinks>
</OrderedTest>
{% endhighlight %}

The XML file is hard to edit by hand, because every test has a GUID-like as identifier. The identifier is composed like this:

1. Take the name of the test method prefixed with the full name of the test class. For example: `MyNamespace.MyTestType.MyMethod`.
2. Convert the string to bytes (using `Encoding.Unicode`)
3. Run the byte array through the `SHA1CryptoServiceProvider`
4. Copy the first 128 bits of the hash (16 bytes) to a new array
5. Initialize a `System.Guid` based on the new array

Note that the XML defines the relative path to the assembly in which the test method is implemented. As far as MSTest is concerned, the `.orderedtest` file is a test of its own. You can pass the path to the `.orderedtest` file to the Visual Studio test runner `vstest.console.exe` and it will execute the ordered test file.

The biggest disadvantages of ordered tests in MSTest is that the tests themselves don't have a hard dependency on the ordering, so you can execute an test individually which may not work because it is dependend on state from another test.

### Running the tests
To run the composed ordered test, just give the Visual Studio test runner the path to the ordered test file. Don't give the test runner the assembly file, because then it will run the tests in whatever order it likes.

```
Microsoft (R) Test Execution Command Line Tool Version 14.0.25123.0
Copyright (c) Microsoft Corporation.  All rights reserved.

Starting test execution, please wait...
Passed   1- PreIntegrationTest_FirstStep (Integration)
Passed   2- PreIntegrationTest_SecondStep (Integration)
Passed   3- NewAccount_AccountRepository_CanSaveAccount (Integration)
Passed   4- ExistingAccount_AccountRepository_CanRetrieveSavedAccount (Integration)
Passed   5- ExistingAccount_AccountRepository_CanDeleteSavedAccount (Integration)
Passed   6- NonExistingAccount_AccountRepository_GetThrows (Integration)
Passed   7- PostIntegrationTest_FirstStep (Integration)
Passed   8- PostIntegrationTest_SecondStep (Integration)

Total tests: 8. Passed: 8. Failed: 0. Skipped: 0.
Test Run Successful.
```

### Tooling support
How does the tooling support ordered tests?

**Visual Studio runner:** Since the Test Explorer is unable to show hierarchy, the 'child' tests of an ordered tests are not shown. Also, each test method is shown individually in the Test Explorer. When executing tests, the tests are correctly shown in the results pane at the bottom of the Test Explorer.
![Test Explorer showing ordered tests](/images/blog/2016-06-06-ordered-tests-with-nunit-mstest-xunit-pt2-mstest/testexplorer.png)

**Resharper runner:** Does not support ordered tests, so no ordered tests are shown. Instead, all test methods are shown in hierarchy and no execution correct order is maintained, as expected.
![Resharper Test runner](/images/blog/2016-06-06-ordered-tests-with-nunit-mstest-xunit-pt2-mstest/resharper.png)

**Console runner:** Shows (and executes) the tests in the correct order. Need to make sure the `.orderedtest` file is given on the command line. Output is shown in [earlier](#running-the-tests) in this post.

## NUnit
In the next post we will look at NUnit.



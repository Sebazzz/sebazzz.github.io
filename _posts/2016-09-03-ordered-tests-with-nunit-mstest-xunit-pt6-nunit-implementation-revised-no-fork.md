---
layout: post
title:  "Ordered testing with XUnit, NUnit and MSTest part 6: NUnit implementation revised part 2"
date:   2016-09-03 5:00:00 +0200
categories: test-frameworks development
---

We have [previously implemented](/blog/2016/06/13/ordered-tests-with-nunit-mstest-xunit-pt5-nunit-implementation-revised) some ordered testing with NUnit. However, it required [forking NUnit](https://github.com/Sebazzz/nunit/tree/custom-testassemblybuilder) to make the ordering possible.. This made the implementation pretty useless, since you'Il be maintaining your own fork forever. In this blog post we're going to find a better solution and implement it. The code of this blog post can be found on [GitHub](https://github.com/Sebazzz/NetUnitTestComparison/tree/ordered-tests-v2b). **Disclaimer:** This code will have rough edges, and may not work for you, kill you cat or blow up in your face. 

## A new look at DefaultTestAssemblyBuilder
If you've read the previous blog post, you've seen that NUnit uses the `DefaultTestAssemblyBuilder` to set up the hierarchy of tests. The `DefaultTestAssemblyBuilder` follows these steps to create the test hierarchy:

1. Find all the test fixture types
2. Create a namespace-based hierarchy
3. Apply any attributes to the root of the hierarchy (the test assembly) which decorate the test assembly and implement `NUnit.Framework.Interfaces.IApplyToTest`.

We can create an attribute to hook in at step 3 and apply our ordering logic. In that case we just modify the existing hierarchy, instead of creating a new one. Let's do that!

Define the attribute:
```
[AttributeUsage(AttributeTargets.Assembly)]
public sealed class EnabledTestFixtureOrderingAttribute : Attribute, IApplyToTest {
    public void ApplyToTest(Test test) {
        if (test == null) throw new ArgumentNullException(nameof(test));

        TestAssembly testAssembly = test as TestAssembly;

        if (testAssembly == null) {
            throw new ArgumentException($"Excepted argument \"{nameof(test)}\" to be of type {typeof(TestAssembly)} but was type {test.GetType()} instead", nameof(testAssembly));
        }

        OrderTestAssemblyTests(testAssembly);
    }

    private static void OrderTestAssemblyTests(TestAssembly testAssembly) {
        OrderedTreeBuilder treeBuilder = new OrderedTreeBuilder(testAssembly);
        treeBuilder.Add(testAssembly);
        treeBuilder.Complete();
    }
}
```

In the attribute `IApplyToTest` implementation we call the `OrderedTreeBuilder` we used earlier. We change the `OrderedTreeBuilder` a bit so it now uses the existing hierarchy, instead of creating a new one.

And we add a method to finalize creating the test hierarchy:
```
public void Complete() {
    this.Root.Add(this._unorderedTests);
    this.Root.Add(this._orderedTests);

    this._unorderedTests.Properties.Set(PropertyNames.Order, 0);
    this._orderedTests.Properties.Set(PropertyNames.Order, 1);
}
``` 

Apply the attribute in the target assembly:

```
[assembly: EnabledTestFixtureOrdering]
```

And we're done!

## Running the tests
To run the tests, we can simply pass our test assembly to the NUnit runner and the tests will be executed in the correct order.

```
Test Files
    BankAccountApp.NUnitTests.Integration\bin\BankAccountApp.NUnitTests.Integration.dll

=> BankAccountApp.NUnitTests.Integration.ChildNamespace.ChildTestFixtureWithoutOrder.Test1
=> BankAccountApp.NUnitTests.Integration.ChildNamespace.ChildTestFixtureWithoutOrder.Test2
=> BankAccountApp.NUnitTests.Integration.TestFixtureWithoutOrder.Test1
=> BankAccountApp.NUnitTests.Integration.TestFixtureWithoutOrder.Test2
=> BankAccountApp.NUnitTests.Integration.PreIntegrationTest.PreIntegrationTest_FirstStep
=> BankAccountApp.NUnitTests.Integration.PreIntegrationTest.PreIntegrationTest_SecondStep
=> BankAccountApp.NUnitTests.Integration.IntegrationTest.NewAccount_AccountRepository_CanSaveAccount
=> BankAccountApp.NUnitTests.Integration.IntegrationTest.ExistingAccount_AccountRepository_CanRetrieveSavedAccount
=> BankAccountApp.NUnitTests.Integration.IntegrationTest.ExistingAccount_AccountRepository_CanDeleteSavedAccount
=> BankAccountApp.NUnitTests.Integration.IntegrationTest.NonExistingAccount_AccountRepository_GetThrows
=> BankAccountApp.NUnitTests.Integration.PostIntegrationTest.PostIntegrationTest_FirstStep
=> BankAccountApp.NUnitTests.Integration.PostIntegrationTest.PostIntegrationTest_SecondStep
```

## Tooling support
**Resharper test runner:** Resharper appears to use its own methods to discover tests in the solution, so the ordered test collections don't show up at all. The hierarchy is not correctly displayed. It is understandable, because it would then need to load the NUnit assemblies, and that would add complexity. But that is as far as the issues go: The tests are executed in the correct order and I could confirm the attribute I added is indeed invoked by Resharper.

![Resharper test runner showing ordered tests](/images/blog/2016-06-13-ordered-tests-with-nunit-mstest-xunit-pt5-nunit-implementation-revised-resharper.png)

**Visual Studio runner:** The display of tests in the test explorer is a bit... sad. Currently there are only a few tests implemented, so it is probably completely unreadable when you have more than a dozen tests.

![Visual Studio test explorer showing ordered tests](/images/blog/2016-06-13-ordered-tests-with-nunit-mstest-xunit-pt5-nunit-implementation-revised-testexplorer.png)

**Console runner:** Shows (and executes) the tests in the correct order. The output is shown [earlier](#running-the-tests) in this post.

**NUnit GUI runner:** The NUnit GUI test runner is [still under construction](https://github.com/nunit/nunit-gui), but already in a working state. When loading the tests in the NUnit GUI, the tree of tests, just like intented is nicely displayed. The tests are also run in the correct order.

![NUnit GUI test runner showing ordered tests](/images/blog/2016-06-13-ordered-tests-with-nunit-mstest-xunit-pt5-nunit-implementation-revised-nunitgui.png)

### Limitations
The same [limitations](/blog/2016/06/13/ordered-tests-with-nunit-mstest-xunit-pt5-nunit-implementation-revised#Limitations) as in the last implementation apply.

## Conclusion
We've seen how we can use a different approach to get test ordering in NUnit, without using a fork. Still, there is the question of whether you want to use this approach. This approach relies on some non-contractual behaviour of the `DefaultTestAssemblyBuilder` to do it's work: Applying the `IApplyToTest` attributes.

Also, just like it said in the last post, keep in mind that there is currently [being discussed](https://github.com/nunit/nunit/issues/51) of implementing test ordering in NUnit beyond test methods. Before a working implementation reached NUnit, it may be a while though, these people [put their spare time](http://www.michaelbromley.co.uk/blog/529/why-i-havent-fixed-your-issue-yet) in developing open-source projects!

The code of this blog post can be found on [GitHub](https://github.com/Sebazzz/NetUnitTestComparison/tree/ordered-tests-v2b) ([Diff](https://github.com/Sebazzz/NetUnitTestComparison/commit/04837ac892a1a8e46cc13ee64f2937deaa9b24c2)).

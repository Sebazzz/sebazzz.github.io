---
layout: post
title:  "Ordered testing with XUnit, NUnit and MSTest part 5: NUnit implementation revised"
date:   2016-06-13 5:00:00 +0200
categories: test-frameworks development
---

We have [previously implemented](/blog/2016/06/07/ordered-tests-with-nunit-mstest-xunit-pt3-nunit) some basic ordered testing with NUnit. However, it had some severe [limitations](/blog/2016/06/07/ordered-tests-with-nunit-mstest-xunit-pt3-nunit#limitations). The biggest limitation was that test fixture ordering across namespaces didn't work. This made the implementation pretty useless. In this blog post we're going to find a solution and implement it. The code of this blog post can be found on [GitHub](https://github.com/Sebazzz/NetUnitTestComparison/tree/ordered-tests-v2). **Disclaimer:** This code will have rough edges, and may not work for you, kill you cat or blow up in your face. 

This post is part of a series of posts on ordered testing:
{% include postseries.html posts=site.data.blog_orderedtests %}

## Test discovery
Test discovery in NUnit is done by an [`ITestAssemblyBuilder`](https://github.com/nunit/nunit/blob/e4b63406b06f0295a9ae9a0976d4530fbc61a20f/src/NUnitFramework/framework/Api/ITestAssemblyBuilder.cs) implementation. The implementation is invoked by the [`FrameworkController`](https://github.com/nunit/nunit/blob/e4b63406b06f0295a9ae9a0976d4530fbc61a20f/src/NUnitFramework/framework/Api/FrameworkController.cs) when the assembly is loaded. 

The default and only implementation of the `ITestAssemblyBuilder` interface is [`DefaultTestAssemblyBuilder`](https://github.com/nunit/nunit/blob/e4b63406b06f0295a9ae9a0976d4530fbc61a20f/src/NUnitFramework/framework/Api/DefaultTestAssemblyBuilder.cs). This implementation discovers the tests and creates an hierarchy of test fixtures based on namespace. 

### Forking NUnit
Unfortunately, the `DefaultTestAssemblyBuilder` is hardcoded in NUnit. `FrameworkController` does [have a constructor](https://github.com/nunit/nunit/blob/e4b63406b06f0295a9ae9a0976d4530fbc61a20f/src/NUnitFramework/framework/Api/FrameworkController.cs#L101) accepting the fully qualified type name of a `ITestAssemblyBuilder`, but this constructors isn't used anywhere and cannot be used for our purposes. We have only one choice left, besides giving up: [Fork NUnit](https://github.com/Sebazzz/nunit/tree/custom-testassemblybuilder).

Our goal is not to implement ordered testing right within NUnit. Let's keep the differences between our fork and the main NUnit code base as small as possible. We want to be able to specify a custom `ITestAssemblyBuilder` for an assembly. We're going to make this configurable using [an attribute](https://github.com/Sebazzz/nunit/blob/337f2412da1eb01932cb6f695feac7861884578c/src/NUnitFramework/framework/Attributes/TestAssemblyBuilderAttribute.cs):

{% highlight c# %}
[AttributeUsage(AttributeTargets.Assembly)]
public sealed class TestAssemblyBuilderAttribute : Attribute {
    public Type AssemblyBuilderType { get; }
    public TestAssemblyBuilderAttribute(Type assemblyBuilderType) {
        this.AssemblyBuilderType = assemblyBuilderType;
    }
}
{% endhighlight %}

Now we implement a `ITestAssemblyBuilder` which simply [instantiates and calls](https://github.com/Sebazzz/nunit/blob/337f2412da1eb01932cb6f695feac7861884578c/src/NUnitFramework/framework/Api/RuntimeAssemblyBuilder.cs) the correct `ITestAssemblyBuilder`:
{% highlight c# %}
    public sealed class RuntimeAssemblyBuilder : ITestAssemblyBuilder {
        static Logger log = InternalTrace.GetLogger(typeof(RuntimeAssemblyBuilder));

        public ITest Build(Assembly assembly, IDictionary<string, object> options) {
			// [...]
        }

        public ITest Build(string assemblyName, IDictionary<string, object> options) {
            // [...]
        }

        private static ITest BuildUsingInnerBuilder(Assembly assembly, string assemblyName, IDictionary<string, object> options) {
            // [...]
        }

        private static ITestAssemblyBuilder ConstructTestAssemblyBuilder(Assembly assembly) {
            log.Debug("Looking up ITestAssemblyBuilder for assembly");

#if PORTABLE
            var attributes = assembly.GetCustomAttributes<TestAssemblyBuilderAttribute>().ToArray();
#else
            var attributes = assembly.GetCustomAttributes(typeof(TestAssemblyBuilderAttribute), false /*unused*/);
#endif

            TestAssemblyBuilderAttribute testAssemblyBuilderAttribute;
            if (attributes.Length == 1 && (testAssemblyBuilderAttribute = attributes[0] as TestAssemblyBuilderAttribute) != null) {
                log.Debug("Constructing ITestAssemblyBuilder {0}", testAssemblyBuilderAttribute.AssemblyBuilderType);

                return (ITestAssemblyBuilder) Reflect.Construct(testAssemblyBuilderAttribute.AssemblyBuilderType);
            }

            // Fallback to default implementation
            return new DefaultTestAssemblyBuilder();
        }
    }

{% endhighlight %}

And in the `FrameworkController` replace the hardcoded call to `DefaultTestAssemblyBuilder` with `RuntimeAssemblyBuilder`:

{% highlight c# %}
public FrameworkController(string assemblyNameOrPath, string idPrefix, IDictionary settings)
{
    this.Builder = new RuntimeAssemblyBuilder();
    this.Runner = new NUnitTestAssemblyRunner(this.Builder);

    // [...]
}
{% endhighlight %}

That's all the code we need to modify in the NUnit fork. This code now allows NUnit to use a different `ITestAssemblyBuilder` implementation if supplied. The source code of the fork can be found on [GitHub](https://github.com/Sebazzz/nunit/tree/custom-testassemblybuilder).

### Designing the test ordering API
In order to hierarchical support test ordering, we're going to represent ordered tests via the `ITestCollection` interface: 

{% highlight c# %}
public interface ITestCollection {
    IEnumerable<Type> GetTestFixtures();

    bool ContinueOnFailure { get; }
}
{% endhighlight %}

`GetTestFixtures` will return an enumerable of types which represents the test fixtures or other `ITestCollection` to run. `ContinueOnFailure` will not be implemented just yet.

### Implementing test ordering discovery
Implementing our test orderer is simple. We're delegating the bulk of the work, discovering tests, to test default implementation. 

{% highlight c# %}
    public sealed class OrderedTestAssemblyBuilder : ITestAssemblyBuilder {
        private readonly DefaultTestAssemblyBuilder _defaultTestAssemblyBuilder = new DefaultTestAssemblyBuilder();
		
        public ITest Build(Assembly assembly, IDictionary<string,object> options) {
            TestAssembly testAssembly = (TestAssembly) this._defaultTestAssemblyBuilder.Build(assembly, options);

            if (testAssembly.RunState == RunState.NotRunnable) {
                return testAssembly;
            }

            return CreateOrderedTestHierarchy(testAssembly, assembly);
        }

        public ITest Build(string assemblyName, IDictionary<string,object> options) {
            TestAssembly testAssembly = (TestAssembly) this._defaultTestAssemblyBuilder.Build(assemblyName, options);
            
            if (testAssembly.RunState == RunState.NotRunnable) {
                return testAssembly;
            }

            return CreateOrderedTestHierarchy(testAssembly, Assembly.Load(assemblyName));
        }

        private static TestSuite CreateOrderedTestHierarchy(TestAssembly testAssembly, Assembly assembly) {
            OrderedTreeBuilder treeBuilder = new OrderedTreeBuilder(assembly);
            treeBuilder.Add(testAssembly);

            return treeBuilder.Root;
        }
    }
{% endhighlight %}

The work of ordering the tests is done in a seperate class, the [`OrderedTreeBuilder`](https://github.com/Sebazzz/NetUnitTestComparison/blob/44b1ae99d69c0ec149dc7687db4a01a268c431c5/src/NUnit.Extensions.TestOrdering/OrderedTreeBuilder.cs). It's too much code to go into detail here, so I'Il write down the algorithm instead:

1. Discover all ordered tests (`ITestCollection`) in the assembly
2. Recursively move ordered tests to a seperate test suite, depending on the `ITestCollection` it belongs to
3. Seperate the ordered tests and unordered tests
4. Sort each level of ordered tests

## Implementing test ordering in our integration test
Enabling ordered testing for our integration test is now a piece of cake. In `AssemblyInfo.cs` we register the ordered test assembly builder:

{% highlight c# %}
[assembly:TestAssemblyBuilder(typeof(OrderedTestAssemblyBuilder))]
{% endhighlight %}

And we implement a `ITestCollection` which contains our tests:

{% highlight c# %}
public sealed class MyTestCollection : ITestCollection {
    public IEnumerable<Type> GetTestFixtures() {
        yield return typeof(PreIntegrationTest);
        yield return typeof(IntegrationTest);
        yield return typeof(PostIntegrationTest);
    }

    public bool ContinueOnFailure => false;
}
{% endhighlight %}

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
**Resharper test runner:** Resharper appears to use its own methods to discover tests in the solution, so the ordered test collections don't show up at all. The hierarchy is not correctly displayed. It is understandable, because it would then need to load the NUnit assemblies in the Visual Studio process which cause Visual Studio to destabilize. But that's as far as the issues go: The tests are executed in the correct order and I could confirm the ordered test assembly builder is indeed invoked by Resharper.

![Resharper test runner showing ordered tests](/images/blog/2016-06-13-ordered-tests-with-nunit-mstest-xunit-pt5-nunit-implementation-revised/resharper.png)

**Visual Studio runner:** The display of tests in the test explorer is a bit... sad. Currently there are only a few tests implemented, so it is probably completely unreadable when you have more than a dozen tests.

![Visual Studio test explorer showing ordered tests](/images/blog/2016-06-13-ordered-tests-with-nunit-mstest-xunit-pt5-nunit-implementation-revised/testexplorer.png)

**Console runner:** Shows (and executes) the tests in the correct order. The output is shown [earlier](#running-the-tests) in this post.

**NUnit GUI runner:** The NUnit GUI test runner is [still under construction](https://github.com/nunit/nunit-gui), but already in a working state. When loading the tests in the NUnit GUI, the tree of tests, just like intented is nicely displayed. The tests are also run in the correct order.

![NUnit GUI test runner showing ordered tests](/images/blog/2016-06-13-ordered-tests-with-nunit-mstest-xunit-pt5-nunit-implementation-revised/nunitgui.png)

### Limitations
Below are the limitations that are still present in this implementation

First limitation is that we currently don't schedule the dependencies of a test to be run when a test is scheduled. We will look at that in a future blog post.

The second obvious limitation is that when a dependency of a test fails, the test is still executed while it should be ignored (marked as 'not runnable') similar to what happens when a test (fixture) setup method fails.

The third limitation, but this is only a small one, is that when you instruct NUnit to run the failed tests first, it will ignore the dependencies of that test (see also limitation two above).

## Conclusion
We've seen how we can use a custom `ITestAssemblyBuilder` to implement ordered testing in NUnit. The only question you might want to ask yourself is: Do I want to use an fork of NUnit to keep use this implementation? If you have a fork, you're responsible to the users of your fork to keep it updated with the main repository of NUnit. 

Also, keep in mind that there is currently [being discussed](https://github.com/nunit/nunit/issues/51) of implementing test ordering in NUnit beyond test methods. Before an official implementation reaches NUnit, it may be a while though, these people [put their spare time](http://www.michaelbromley.co.uk/blog/529/why-i-havent-fixed-your-issue-yet) in developing open-source projects!

The code of this blog post can be found on [GitHub](https://github.com/Sebazzz/NetUnitTestComparison/tree/ordered-tests-v2). The code of the NUnit fork can also be found on [GitHub](https://github.com/Sebazzz/nunit/tree/custom-testassemblybuilder) ([Diff](https://github.com/Sebazzz/nunit/commit/337f2412da1eb01932cb6f695feac7861884578c)).




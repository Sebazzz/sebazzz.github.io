---
layout: post
title:  "Ordered testing with XUnit, NUnit and MSTest part 3: NUnit"
date:   2016-06-07 00:00:00 +0200
categories: test-frameworks development
---

In the [previous post](2016-06-06-ordered-tests-with-nunit-mstest-xunit-pt1-mstest) we looked briefly at ordered testing in MSTest. Today we are going to implement ordered tests in NUnit. The code for this post can be found on [GitHub](https://github.com/Sebazzz/NetUnitTestComparison/tree/2016-06-05). **Disclaimer:** This code will have rough edges, and may not work for you, kill you cat or blow up in your face. We will refine the code in a later post.

This post is part of a series of posts on ordered testing:
{% include postseries.html posts=site.data.blog_orderedtests %}

## NUnit
NUnit has limited built-in support for test ordering, and [no support](https://github.com/nunit/nunit/issues/51) for tests with dependencies on other tests. Since NUnit 3.2 there is support for ordering individual tests in a test fixture, but it is not possible to order test fixtures. Let's start by looking how the current way is implemented. Test method ordering is implemented in NUnit using the [`OrderAttribute`](https://github.com/nunit/nunit/blob/526534e93202f1da3f371d57d2b358341238c29f/src/NUnitFramework/framework/Attributes/OrderAttribute.cs). If you look at the implementation of this attribute, you'Il find it implements `IApplyToTest`. This is an interface that allows an attribute to modify the test. Also note that this attribute may only be applied to methods, not to classes.

When a test is discovered in NUnit and the test is an assembly, test fixture or test method, all the attributes on that test are iterated. Each attribute which implements `IApplyToTest` is invoked. 

In this case we find:

{% highlight c# %}
public void ApplyToTest(Test test) {
    if (!test.Properties.ContainsKey(PropertyNames.Order))
        test.Properties.Set(PropertyNames.Order, Order);
}
{% endhighlight %}

The property which is added to the test is picked up in [`CompositeWorkItem.CreateChildWorkItems`](https://github.com/nunit/nunit/blob/40a0022dc4dd9c92dc6ef1c3fcf936f9ba0e5ba2/src/NUnitFramework/framework/Internal/Execution/CompositeWorkItem.cs#L248). Tests with no order are sorted last, tests with order are sorted according to the `Order` property in the dynamic properties bag.

### Setting up the boilerplate
First we set up some general attributes that actually allow us to specify dependencies. We define attributes for a method to specify its dependency:

{% highlight c# %}
public class TestMethodWithoutDependency : NUnitAttribute, IApplyToTest {
    public void ApplyToTest(Test test) {
        if (!test.Properties.ContainsKey(PropertyNames.Order)) {
            // NUnit sorts tests without an order set to be executed last and we want those tests to execute first.
            test.Properties.Set(PropertyNames.Order, 0);
        }
    }
}

[AttributeUsage(AttributeTargets.Method)]
public class TestMethodDependencyAttribute : NUnitAttribute, IApplyToTest {
    public TestMethodDependencyAttribute(string methodDependency) {
        this.MethodDependency = methodDependency;
    }

    public string MethodDependency { get; set; }

    public void ApplyToTest(Test test) {
        if (!test.Properties.ContainsKey(PropertyNames.Order)) {
            test.Properties.Set(PropertyNames.Order,  /*TODO*/ );
        }
    }
}

// This attribute can be easily applied using the `nameof` language construct in C#:
[TestMethodDependency(nameof(MyOtherMethod))]
public void MyTestCase() {}
{% endhighlight %}


And we define attributes for test fixtures, but these accept a `System.Type` instead. 

### Test dependency discovery
Now we define a component to allow us to find and store the current test methods in the assembly. 

{% highlight c# %}
public static TestMethodDependencyChainer Instance = new TestMethodDependencyChainer();

private readonly List<TestCaseWrapper> _testCaseDescriptors = new List<TestCaseWrapper>();

private TestMethodDependencyChainer() {
    var excludedMethodNames = new[] {nameof(this.GetHashCode), nameof(Equals), nameof(this.ToString), nameof(this.GetType)};
    var types = 
        from assembly in AppDomain.CurrentDomain.GetAssemblies()
        from type in assembly.GetExportedTypes()
        where type.GetCustomAttribute<TestFixtureAttribute>() != null
        from method in type.GetMethods(BindingFlags.Instance | BindingFlags.Public)
        where Array.IndexOf(excludedMethodNames, method.Name) == -1
        select new TestCaseWrapper(new TestCaseDescriptor(method.Name, type));

    this._testCaseDescriptors.AddRange(DependencySorter.Sort(types));
}
{% endhighlight %}

We define an interface that will be implemented by both our representations of test methods and test fixtures:

{% highlight c# %}
internal interface IDependencyIndicator<T> : IEquatable<T> {
    bool IsDependencyOf(T other);

    bool HasDependencies { get; }
}
{% endhighlight %}

And finally our representation of a test method:

{% highlight c# %}
private sealed class TestCaseWrapper : IDependencyIndicator<TestCaseWrapper> {
    public TestCaseWrapper(TestCaseDescriptor testCase) {
        this.Descriptor = testCase;

        TestMethodDependencyAttribute attribute = method.GetCustomAttribute<TestMethodDependencyAttribute>();
        if (attribute != null) {
            this.Dependency = new TestCaseDescriptor(attribute.MethodDependency,type);
        }
    }

    public TestCaseDescriptor Descriptor { get; }
    public TestCaseDescriptor Dependency { get; }

    public bool IsDependencyOf(TestCaseWrapper other) {
        if (other.Dependency == null) {
            return false;
        }

        return this.Descriptor == other.Dependency;
    }
}
{% endhighlight %}

Now we implement the same set of classes for test fixtures. 

### Sorting tests
Using a `LinkedList<T>` we can easily sort the tests based on their given dependencies. Each node in the linked list is (as you can guess from the name) linked to a next or previous node. For each test we add the test to the list at the start, or find the dependency and link it there.

{% highlight c# %}
// For each node, either find the previous or the next node in 
// the list of dependencies. 
LinkedList<T> listOfDependencies = new LinkedList<T>();
foreach (T item in tests) {
    // Find the dependency for the current node
    bool dependencyOrDependantFound = false;
    LinkedListNode<T> current = listOfDependencies.First;
    do {
        if (current == null) continue;

        if (item.IsDependencyOf(current.Value)) {
            listOfDependencies.AddBefore(current, item);
            dependencyOrDependantFound = true;
            break;
        }

        if (current.Value.IsDependencyOf(item)) {
            listOfDependencies.AddAfter(current, item);
            dependencyOrDependantFound = true;
            break;
        }
    } while ((current = current?.Next) != null);

    if (!dependencyOrDependantFound) {
        listOfDependencies.AddFirst(item);
    }
}
{% endhighlight %}

### Running the tests
To run the tests, we can simply pass our test assembly to the NUnit runner and the tests will be executed in the correct order.

```
Test Files
    BankAccountApp.NUnitTests.Integration\bin\BankAccountApp.NUnitTests.Integration.dll

=> BankAccountApp.NUnitTests.Integration.PreIntegrationTest.PreIntegrationTest_FirstStep
=> BankAccountApp.NUnitTests.Integration.PreIntegrationTest.PreIntegrationTest_SecondStep
=> BankAccountApp.NUnitTests.Integration.IntegrationTest.NewAccount_AccountRepository_CanSaveAccount
=> BankAccountApp.NUnitTests.Integration.IntegrationTest.ExistingAccount_AccountRepository_CanRetrieveSavedAccount
=> BankAccountApp.NUnitTests.Integration.IntegrationTest.ExistingAccount_AccountRepository_CanDeleteSavedAccount
=> BankAccountApp.NUnitTests.Integration.IntegrationTest.NonExistingAccount_AccountRepository_GetThrows
=> BankAccountApp.NUnitTests.Integration.PostIntegrationTest.PostIntegrationTest_FirstStep
=> BankAccountApp.NUnitTests.Integration.PostIntegrationTest.PostIntegrationTest_SecondStep

Test Run Summary
  Overall result: Passed
  Test Count: 8, Passed: 8, Failed: 0, Inconclusive: 0, Skipped: 0
```

Obvious advantage over MSTest is that this doesn't need any special configuration when calling the test runner. It "just works".

### Limitations
When NUnit groups by test fixtures by namespace. That grouping is also considered to be a test by NUnit. This means that when NUnit sorts the tests, it will only sort the tests on the "current level" which may be a fixture or a namespace. In a future post we will reimplement test ordering so it works across namespaces. 

Another limitation is that we currently don't schedule the dependencies of a test to be run when a test is scheduled. We will look at that in a future blog post.

The third obvious limitation is that when a dependency of a test fails, the test is still executed while it should be ignored (marked as 'not runnable') similar to what happens when a test (fixture) setup method fails.

The fourth limitation, but this is only a small one, is that when you instruct NUnit to run the failed tests first, it will ignore the dependencies of that test (see also limitation two above).

### Tooling support
How does the tooling support ordered tests?

**Visual Studio runner:** The tests are not correctly ordered in the Test Explorer, but the tests themselves execute in the correct order. When grouping tests by trait, the test fixtures are shown in the correct order but the underlying tests are not. This is not suprising because the test isn't ordered when discovered, but only when executed.

![Visual Studio test explorer showing ordered tests](/images/blog/2016-06-07-ordered-tests-with-nunit-mstest-xunit-pt3-nunit-testexplorer.png)

**Resharper runner:** While the test tree of Resharper does not appear to follow the correct ordering, the tests are actually performed in the correct order. This is not suprising because the test isn't ordered when discovered, but only when executed.

![Resharper test runner showing ordered tests](/images/blog/2016-06-07-ordered-tests-with-nunit-mstest-xunit-pt3-nunit-resharper.png)

**Console runner:** Shows (and executes) the tests in the correct order. The output is shown [earlier](#running-the-tests) in this post.

## XUnit
In the next post we will take a look at implementing test ordering in XUnit.
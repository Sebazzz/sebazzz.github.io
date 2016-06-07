---
layout: post
title:  "Ordered testing with XUnit, NUnit and MSTest part 4: XUnit"
date:   2016-06-08 00:00:00 +0200
categories: test-frameworks development
---

In the [previous post](2016-06-07-ordered-tests-with-nunit-mstest-xunit-pt1-nunit) we looked at ordered testing in NUnit. Today we are going to implement ordered tests in XUnit. The code for this post can be found on [GitHub](https://github.com/Sebazzz/NetUnitTestComparison/tree/2016-06-05). **Disclaimer:** This code will have rough edges, and may not work for you, kill you cat or blow up in your face. 

This post is part of a series of posts on ordered testing:
{% include postseries.html posts=site.data.blog_orderedtests %}

## XUnit
XUnit doesn't have built-in ordering, but does appear to have the interfaces to support it: [`ITestCaseOrderer`](github.com/xunit/xunit/blob/6381c93738860481af501a2372f796492b6e8d42/src/xunit.core/Sdk/ITestCaseOrderer.cs) for ordering methods within a class, and [`ITestCollectionOrderer`](https://github.com/xunit/xunit/blob/6381c93738860481af501a2372f796492b6e8d42/src/xunit.core/ITestCollectionOrderer.cs) for ordering [test collections](https://xunit.github.io/docs/shared-context.html#collection-fixture). There doesn't appear to be a interface for class fixtures, so we'Il have to work with these interfaces.

The interfaces can be registered by placing an [`TestCaseOrdererAttribute`](https://github.com/xunit/xunit/blob/6381c93738860481af501a2372f796492b6e8d42/src/xunit.core/TestCaseOrdererAttribute.cs) or [`TestCollectionOrdererAttribute`](https://github.com/xunit/xunit/blob/6381c93738860481af501a2372f796492b6e8d42/src/xunit.core/TestCollectionOrdererAttribute.cs) respectively on the assembly. The signatures of both interfaces are fairly straightforward: Take an enumerable and return an ordered enumerable. Let's go and implement these.

### Setting up the boilerplate
First we set up some general attributes that actually allow us to specify dependencies. We define an attribute for methods:

{% highlight c# %}
[AttributeUsage(AttributeTargets.Method)]
public sealed class TestDependencyAttribute : Attribute {
    public TestDependencyAttribute(string methodDependency) {
        this.MethodDependency = methodDependency;
    }

    public string MethodDependency { get; }
}

// This attribute can be easily applied using the `nameof` language construct in C#:
[TestDependencyAttribute(nameof(MyOtherMethod))]
public void MyTestCase() {}
{% endhighlight %}

And we define a method for test collections:

{% highlight c# %}
[AttributeUsage(AttributeTargets.Class)]
public sealed class TestCollectionDependencyAttribute : Attribute {
    public Type Dependency { get; }

    public TestCollectionDependencyAttribute(Type dependency) {
        this.Dependency = dependency;
    }
}
{% endhighlight %}

### Test dependency discovery
XUnit finds the test cases or test collections and passes them through our interface. We will re-use the test sorting code from the previous post so we'Il just implement a wrapper that allows our existing code to talk to the test cases:

{% highlight c# %}
public IEnumerable<TTestCase> OrderTestCases<TTestCase>(IEnumerable<TTestCase> testCases) where TTestCase : ITestCase {
    return DependencySorter.Sort(testCases.Select(x => new TestCaseWrapper(x))).Select(x => x.TestCase).Cast<TTestCase>();
}

private sealed class TestCaseWrapper : IDependencyIndicator<TestCaseWrapper> {
    public TestCaseWrapper(ITestCase testCase) {
        this.TestCase = testCase;

        var attributeInfo =
            testCase.TestMethod.Method.GetCustomAttributes(typeof(TestDependencyAttribute))
                .OfType<ReflectionAttributeInfo>()
                .SingleOrDefault();

        if (attributeInfo != null) {
            var attribute = (TestDependencyAttribute) attributeInfo.Attribute;

            this.TestMethodDependency = attribute.MethodDependency;
        }
    }

    public string TestMethod => this.TestCase.TestMethod.Method.Name;
    public string TestMethodDependency { get; }

    public ITestCase TestCase { get; }

    public bool IsDependencyOf(TestCaseWrapper other) {
        if (other.TestMethodDependency == null) {
            return false;
        }

        return string.Equals(this.TestMethod, other.TestMethodDependency, StringComparison.Ordinal);
    }

    public bool HasDependencies => !String.IsNullOrEmpty(this.TestMethodDependency);

    // IEquatable<> implementation removed for brevity
}
{% endhighlight %}

We do the same for test collections, but we need also a lookup between type and collection name so we can easily look up the type bij collection name.


{% highlight c# %}
private sealed class TestCollectionCache {
    public static readonly TestCollectionCache Instance = new TestCollectionCache();

    private readonly Dictionary<string, Type> _collectionTypeMap;

    private TestCollectionCache() {
        this._collectionTypeMap = new Dictionary<string, Type>(StringComparer.Ordinal);

        CreateCollectionTypeMap(this._collectionTypeMap);
    }

    private static void CreateCollectionTypeMap(Dictionary<string, Type> collectionTypeMap) {
        var types = 
            from assembly in AppDomain.CurrentDomain.GetAssemblies()
            from type in assembly.GetExportedTypes()

            // Xunit accesses attribute data by constructor arguments
            let collectionAttrData = type.GetCustomAttributesData().FirstOrDefault(x => x.AttributeType == typeof(CollectionAttribute))
            where collectionAttrData != null
            select new {
                CollectionName = collectionAttrData.ConstructorArguments[0].Value as string,
                CollectionType = type
            };

        // We don't use IDictionary because we can't give an useful exception then
        foreach (var tuple in types) {
            // We don't support null collection names
            if (tuple.CollectionName == null) continue;

            try {
                collectionTypeMap.Add(tuple.CollectionName, tuple.CollectionType);
            }
            catch (ArgumentException) {
                throw new InvalidOperationException(
                    $"Duplicate collection name: {tuple.CollectionName}. Existing collection type with same name: {collectionTypeMap[tuple.CollectionName]}. Trying to add {tuple.CollectionType}");
            }
        }
    }

    public Type GetType(string collectionName) {
        Type type;
        this._collectionTypeMap.TryGetValue(collectionName, out type);
        return type;
    }
}
{% endhighlight %}

Now it is just a matter of registration of the implementations in the test assembly, and we're done!

### Running the tests
To run the tests, we can simply pass our test assembly to the XUnit runner and the tests will be executed in the correct order.

```
  Discovering: BankAccountApp.XUnitTests.Integration
  Discovered:  BankAccountApp.XUnitTests.Integration
  Starting:    BankAccountApp.XUnitTests.Integration
    BankAccountApp.XUnitTests.Integration.PreIntegrationTest.PreIntegrationTest_FirstStep
    BankAccountApp.XUnitTests.Integration.PreIntegrationTest.PreIntegrationTest_SecondStep
    BankAccountApp.XUnitTests.Integration.IntegrationTest.NewAccount_AccountRepository_CanSaveAccount
    BankAccountApp.XUnitTests.Integration.IntegrationTest.ExistingAccount_AccountRepository_CanRetrieveSavedAccount
    BankAccountApp.XUnitTests.Integration.IntegrationTest.ExistingAccount_AccountRepository_CanDeleteSavedAccount
    BankAccountApp.XUnitTests.Integration.IntegrationTest.NonExistingAccount_AccountRepository_GetThrows
    BankAccountApp.XUnitTests.Integration.PostIntegrationTest.PostIntegrationTest_FirstStep
    BankAccountApp.XUnitTests.Integration.PostIntegrationTest.PostIntegrationTest_SecondStep
  Finished:    BankAccountApp.XUnitTests.Integration
=== TEST EXECUTION SUMMARY ===
   BankAccountApp.XUnitTests.Integration  Total: 8, Errors: 0, Failed: 0, Skipped: 0, Time: 0,389s
```

Obvious advantage over MSTest is that this doesn't need any special configuration when calling the test runner. It "just works".

### Limitations
There are three limitations in the current implementation:

Each test class needs to be put in an unique test collection, but then test collections can be ordered against each other. However, if you are already using test collections and want to order classes against each other, this solution will not work.

Within a test collection, tests can be ordered. When a test fails, the other tests are happily scheduled for execution and not ignored.

If one test is selected for execution, the dependencies of that test should also be executed. Currently only the test itself is executed.

### Tooling support

**Visual Studio runner:** The tests are not correctly ordered in the Test Explorer, but the tests themselves execute in the correct order. Grouping tests makes no difference. The test explorer probably applies its own ordering.

![Visual Studio Test Explorer showing XUnit ordered tests](/images/blog/2016-06-08-ordered-tests-with-nunit-mstest-xunit-pt4-xunit-testexplorer.png)

**Resharper runner:** While the test tree of Resharper does not appear to follow the correct ordering, the tests are actually performed in the correct order. Resharper probably uses its own mechanism to discover the tests.

![Resharper test runner showing XUnit ordered tests](/images/blog/2016-06-08-ordered-tests-with-nunit-mstest-xunit-pt4-xunit-resharper.png)

**Console runner:** Shows (and executes) the tests in the correct order.

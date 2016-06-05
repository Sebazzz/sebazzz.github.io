---
layout: post
title:  "Comparing .NET testing frameworks: Unit testing"
date:   2016-06-04 20:07:08 +0200
categories: test-frameworks development
---

In this post we are going to compare several well-known testing frameworks which are used in the .NET ecosystem: [MSTest 10](https://msdn.microsoft.com/en-us/library/dd465178.aspx) (Visual Studio 2015), [XUnit 2.1](https://xunit.github.io/docs/getting-started-desktop.html), and [NUnit 3.2](https://github.com/nunit/docs/wiki). We will look at the basic functionality, extensibility, error reporting, style, and documentation. The code for this blog post can be found at [Github](https://github.com/Sebazzz/NetUnitTestComparison/tree/80ac8a0459eca33407e9e667a933c3fd91007b7e).

## Excluded frameworks
I have not taken into account the various Specflow-like frameworks available in .NET, since I am not familiar with those. I have also not looked at the older testing frameworks like MbUnit which are not maintained any longer.

## Functionality
Of the three test frameworks, MSTest is meant to be a test framework which should be suitable for all types of tests. Integration tests, web (load) performance tests, and unit tests can all be developed in MSTest. Some people call MSTest a framework "which can do anything but is good at nothing".

NUnit and XUnit are meant as pure unit testing frameworks. However, for integration testing (not pure unit tests) they can also work fine, as long as you don't depend on tests having order. We will come back in a later blog post on this.

### Data based / dynamic tests
All test frameworks allow support for data based or dynamic tests in one way or another.

#### MSTest
Allows decoration of tests with an [`DataSourceAttribute`](https://msdn.microsoft.com/en-us/library/microsoft.visualstudio.testtools.unittesting.datasourceattribute.aspx). In a `DataSourceAttribute` you provide a connection string of a data source to use for testing. For example: An SQL database, or an Excel file. Data is accessed via the [`TestContext.DataRow`](https://msdn.microsoft.com/en-us/library/microsoft.visualstudio.testtools.unittesting.testcontext.datarow.aspx) property.

It does not appear to be possible to provide hardcoded source testcases or dynamic test cases. I suppose one could write an OLEDB provider to provide test case when stuck with MSTest. You're limited with whatever you can put in a ADO.NET `DataRow` though.

#### NUnit
NUnit does not appear to have explicit built-in support for external datasource-based testing. This doesn't matter however, because NUnit offers more flexibility using the [`TestCaseSource`](https://github.com/nunit/docs/wiki/TestCaseData) attribute. The attribute arguments refers to a member on a type which provides an `IEnumerable` with data.

To generate the `IEnumerable` you can use whatever method you require, like reading an Excel file or providing random numbers (though [theories](https://github.com/nunit/docs/wiki/TestCaseData) are more suitable if you want that). I have succesfully used this method in an integration test for an application to verify its calculations based on an Excel file of examples provided by the client. 

Inline test case data may be provided for `TestCaseDataAttribute`.

#### XUnit
XUnit does not appear to have explicit built-in support for external datasource-based testing. XUnit however offers the (barely documented) [`ClassDataAttribute`](https://github.com/xunit/xunit/blob/94d42b6bd9360396208d444f448e7272000b4f1f/src/xunit.core/ClassDataAttribute.cs) which is similar to the NUnit `TestCaseSourceAttribute`. In this case you need to provide the type which implements `IEnumerable`. XUnit also supports `InlineDataAttribute` which is similar to NUnit `TestCaseDataAttribute`.

### Style and flexibility
MSTest and NUnit 2.x are most alike when it comes to style. Both frameworks require decoration of a test class (which is called a Test Fixture in NUnit) and test methods with attributes. Starting with NUnit 3.x the framework also allows tests without those attributes.

#### MSTest

##### Test class and test case setup / teardown
MSTest is the most rigid of the frameworks. Class initializers, [`ClassInitializeAttribute`](https://msdn.microsoft.com/en-us/library/microsoft.visualstudio.testtools.unittesting.classinitializeattribute.aspx), method *must be static* and must conform to a certain signature or they will be silently skipped. The same applies to the [`ClassCleanupAttribute`](https://msdn.microsoft.com/en-us/library/microsoft.visualstudio.testtools.unittesting.classcleanupattribute.aspx). Class initializers and cleanup are [not inherited](http://stackoverflow.com/questions/15944504/mstest-classinitialize-and-inheritance) too, which is a pain if you want to use test base classes. The most maintenance friendly option here is to use a T4 template to generate the appropiate method in a partial class. Per class only one Initialize/Cleanup is allowed.

The above applies too for test case `TestInitialize` and `TestCleanup` methods.

##### Asserting test results
MSTest provides static methods on the [`CollectionAssert`](https://msdn.microsoft.com/en-us/library/microsoft.visualstudio.testtools.unittesting.collectionassert.aspx) and [`Assert`](https://msdn.microsoft.com/en-us/library/microsoft.visualstudio.testtools.unittesting.assert.aspx) class. These classes are fairly limited in what you can assert. For asserting exceptions you need the [`ExpectedExceptionAttribute`](https://msdn.microsoft.com/en-us/library/microsoft.visualstudio.testtools.unittesting.expectedexceptionattribute.aspx).

#### NUnit

##### Test class and test case setup / teardown
Similar to MSTest, NUnit has a [`OneTimeSetUpAttribute`](https://github.com/nunit/docs/wiki/OneTimeSetUp-Attribute) and [`OneTimeTeardownAttribute`](https://github.com/nunit/docs/wiki/OneTimeTearDown-Attribute) for test fixtures and [`Setup` and `Teardown`](https://github.com/nunit/docs/wiki/SetUp-and-TearDown-Changes) for test cases. NUnit allows methods to be static or instance methods and methods from base classes are inherited. The SetUp methods are applied from the base class to the derived class and for TearDown vice versa. Order of execution within the same class is undefined.

##### Asserting test results
NUnit provides "classic" assert capabilities via the [`Assert`](https://github.com/nunit/docs/wiki/Assertions) and `CollectionAssert` class. In the documentation this model is called the *classic model*. This model is very similar to what MSTest offers.

NUnit also offers a constraint based model that allows fluent assertions:

{% highlight c# %}
Assert.That(value, Is.GreaterThan(5).And.LessThan(25));
{% endhighlight %}

#### XUnit

##### Test class and test case setup / teardown
XUnit is perhaps the most radical of the three frameworks. Like MSTest and NUnit, XUnit allows setup and tear down to happen per class and per test but it works a little different. It is best explained with a code sample:
{% highlight c# %}
[CollectionDefinition("MyCollection")]
public class MyCollection : ICollectionFixture<SharedBetweenTestClassesInCollection>{}

public class SharedBetweenTestClassesInCollection : IDisposable {
	public SharedBetweenTestClassesInCollection() {
		Console.WriteLine("SetUp: One per 'MyCollection'"); 
	}

	public void Dispose() => Console.WriteLine("TearDown: One per 'MyCollection'");
}

public class SharedBetweenTestsInSameClass : IDisposable {
	public SharedBetweenTestsInSameClass() {
		Console.WriteLine("SetUp: One per test class"); 
	}

	public void Dispose() => Console.WriteLine("TearDown: One per test class");
}

[Collection("MyCollection")]
public class TestClassA : IClassFixture<SharedBetweenTestsInSameClass>, IDisposable {
	public TestClassA(SharedBetweenTestsInSameClass _, SharedBetweenTestClassesInCollection __) {
		Console.WriteLine("SetUp: One per test method");
	}

	[Fact]
	public void TestA1() => Console.WriteLine("Hello Test A 1");

	[Fact]
	public void TestA2() => Console.WriteLine("Hello Test A 2");
	
	public void Dispose() => Console.WriteLine("TearDown: One per test method");
}

[Collection("MyCollection")]
public class TestClassB : IClassFixture<SharedBetweenTestsInSameClass>, IDisposable {
	public TestClassB(SharedBetweenTestsInSameClass _, SharedBetweenTestClassesInCollection __) {
		Console.WriteLine("SetUp: One per test method");
	}

	[Fact]
	public void TestB() => Console.WriteLine("Hello TestB");
	
	public void Dispose() => Console.WriteLine("TearDown: One per test method");
}

{% endhighlight %}

Execution will yield:

```
SetUp: One per 'MyCollection'
SetUp: One per test class
SetUp: One per test method
Hello Test A 1
TearDown: One per test method
SetUp: One per test method
Hello Test A 2
TearDown: One per test method
TearDown: One per test class
SetUp: One per test class
SetUp: One per test method
Hello Test B
TearDown: One per test method
TearDown: One per test class
TearDown: One per 'MyCollection'
```

*Note: This appears to be broken in XUnit 2.1 currently.*

#### Asserting test results
XUnit only provides "classic" assert capabilities via the [`Assert`](https://github.com/nunit/docs/wiki/Assertions) and `CollectionAssert` class.

## Error reporting
We try this with three failing asserts:
{% highlight c# %}
public void TestA() => Assert.AreEqual(10, 20);
public void TestB() => Assert.AreEqual("ABC", "ABC!");
public void TestC() => CollectionAssert.AreEqual(new[]{"A", "B"}, new []{"A", "C"});
{% endhighlight %}

### MSTest
MSTest is really the worst of them all. 

```
Failed   TestA
Error Message:
   Assert.AreEqual failed. Expected:<10>. Actual:<20>.
Stack Trace:
   at BankAccountApp.MSTests.Unit.Assertions.TestA() in Z:\Dev\NetUnitTestComparison\src\BankAccountApp.MSTests.Unit\Assertions.cs:line 7

Failed   TestB
Error Message:
   Assert.AreEqual failed. Expected:<ABC>. Actual:<ABC!>.
Stack Trace:
   at BankAccountApp.MSTests.Unit.Assertions.TestB() in Z:\Dev\NetUnitTestComparison\src\BankAccountApp.MSTests.Unit\Assertions.cs:line 10

Failed   TestC
Error Message:
   CollectionAssert.AreEqual failed. (Element at index 1 do not match.)
Stack Trace:
   at BankAccountApp.MSTests.Unit.Assertions.TestC() in Z:\Dev\NetUnitTestComparison\src\BankAccountApp.MSTests.Unit\Assertions.cs:line 13
```

Especially the collection asserts are bad, since they contain no details.

### NUnit
Fairly detailed errors.

```
1) Failed : BankAccountApp.NUnitTests.Unit.Assertions.TestA
  Expected: 10
  But was:  20
at BankAccountApp.NUnitTests.Unit.Assertions.TestA() in Z:\Dev\NetUnitTestComparison\src\BankAccountApp.NUnitTests.Unit\Assertions.cs:line 7

2) Failed : BankAccountApp.NUnitTests.Unit.Assertions.TestB
  Expected string length 3 but was 4. Strings differ at index 3.
  Expected: "ABC"
  But was:  "ABC!"
  --------------^
at BankAccountApp.NUnitTests.Unit.Assertions.TestB() in Z:\Dev\NetUnitTestComparison\src\BankAccountApp.NUnitTests.Unit\Assertions.cs:line 10

3) Failed : BankAccountApp.NUnitTests.Unit.Assertions.TestC
  Expected and actual are both <System.String[2]>
  Values differ at index [1]
  String lengths are both 1. Strings differ at index 0.
  Expected: "B"
  But was:  "C"
  -----------^
at NUnit.Framework.CollectionAssert.AreEqual(IEnumerable expected, IEnumerable actual, String message, Object[] args) in Z:\Dev\nunit\src\NUnitFramework\framework\CollectionAssert.cs:line 172
at NUnit.Framework.CollectionAssert.AreEqual(IEnumerable expected, IEnumerable actual) in Z:\Dev\nunit\src\NUnitFramework\framework\CollectionAssert.cs:line 146
at BankAccountApp.NUnitTests.Unit.Assertions.TestC() in Z:\Dev\NetUnitTestComparison\src\BankAccountApp.NUnitTests.Unit\Assertions.cs:line 13
```

### XUnit
On par with NUnit.

```
    BankAccountApp.XUnitTests.Unit.Assertions.TestA [FAIL]
      Assert.Equal() Failure
      Expected: 10
      Actual:   20
      Stack Trace:
        BankAccountApp.XUnitTests.Unit\Assertions.cs(6,0): at BankAccountApp.XUnitTests.Unit.Assertions.TestA()
    BankAccountApp.XUnitTests.Unit.Assertions.TestB
    BankAccountApp.XUnitTests.Unit.Assertions.TestB [FAIL]
      Assert.Equal() Failure
                   ↓ (pos 3)
      Expected: ABC
      Actual:   ABC!
                   ↑ (pos 3)
      Stack Trace:
        BankAccountApp.XUnitTests.Unit\Assertions.cs(9,0): at BankAccountApp.XUnitTests.Unit.Assertions.TestB()
    BankAccountApp.XUnitTests.Unit.Assertions.TestC
    BankAccountApp.XUnitTests.Unit.Assertions.TestC [FAIL]
      Assert.Equal() Failure
      Expected: String[] ["A", "B"]
      Actual:   String[] ["A", "C"]
      Stack Trace:
        BankAccountApp.XUnitTests.Unit\Assertions.cs(12,0): at BankAccountApp.XUnitTests.Unit.Assertions.TestC()
```

## Extensibility
### MSTest
... none? MSTest is not very extensible, and is also a big black box. It does not offer any interfaces to change test discovery or execution behaviour. It is not possible to add custom assertions, other than writing your own class.

### NUnit
NUnit offers the following aspects to customize the testing experience:

- Custom assertions by implementing [custom constraints](https://github.com/nunit/docs/wiki/Assertions)
- Changing test discovery and execution by leveraging the [test and execution APIs](https://github.com/nunit/docs/wiki/Test-Discovery-and-Execution-API-Spec)
- [Custom attributes](https://github.com/nunit/docs/wiki/Attribute-Hierarchy) which can do things on their own based on their interfaces, see the [documentation](https://github.com/nunit/docs/wiki/Attribute-Interfaces) for more information

### XUnit
XUnit is badly documented, so while there may be many extensibility points, I only found those below:

- Custom assertions by installation of the [Assertion library source](https://www.nuget.org/packages/xunit.assert.source) and extending the assertion class
- Use of `ITestCollectionOrderer` and `ITestCaseOrderer` to allow specifying the order in which tests are run

## Documentation & community
### MSTest
MSTest is documented on MSDN in the [API Reference for Testing Tools for Visual Studio ALM](https://msdn.microsoft.com/en-us/library/dd465178.aspx) section. The documentation is often very brief, especially about the web testing features. 

The .NET community generally seems to hate MSTest so the community around MSTest is quite small.

MSTest does not seem to be actively developed. It is shipped with Visual Studio, so Microsoft ensures it keeps working on .NET (and somewhat even on [.NET Core](https://connect.microsoft.com/VisualStudio/Feedback/Details/2076991)). It didn't seem to get new features the last few releases.

Fun fact: Microsoft [dropped MSTest for XUnit](https://github.com/Microsoft/msbuild/issues/6) in CoreCLR (and probably also for the tests for Desktop CLR). For legacy ASP.NET MVC and Web API Microsoft also dropped MSTest and is now using [XUnit](http://aspnetwebstack.codeplex.com/SourceControl/latest).

### NUnit
NUnit 2.x has easy navigatable version-by-version documentation on [nunit.org](http://nunit.org/index.php?p=documentation). Since NUnit 3.x the documentation is hosted on [Github](https://github.com/nunit/docs/wiki). The documentation is however not as easy to navigate or read, and not specific to any version anymore but updated along the way. 

NUnit has an active community, the documentation is being updated regularly, and the project is in active development. 

### XUnit
XUnit has some documentation on [their project homepage](https://xunit.github.io/) on Github Pages. XUnit is almost undocumented except for the few pages on their project homepage. *Personally* I think this makes XUnit look bad because the framework has many ways for tests to be written but each developer must figure that out on their own via the source code.

XUnit has an somewhat active community, and the project is in active development.

## Conclusion
We have looked at three of the most used testing frameworks in .NET: XUnit, NUnit and MSTest. Each framework has its own advantages and disadvantages. MSTest seems to be the odd one out. When it comes down to NUnit and XUnit it is mostly a matter of style.

*My opinion:* I like NUnit the most, because of the constraint model for assertions. It also has the best documentation which is something I find important as well.

**Code:** The code for this blog post can be found at [Github](https://github.com/Sebazzz/NetUnitTestComparison).
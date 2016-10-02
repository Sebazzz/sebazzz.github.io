---
layout: post
title:  "Ordered NUnit testing with the NUnitTestOrdering library"
date:   2016-10-02 5:00:00 +0200
categories: test-frameworks development
---

When it comes to integration tests, especially when developing web automation tests, test ordering can be useful. In larger web applications where you might want to test out a workflow, you need to have tests execute in a certain order. MSTest has [built-in support for ordered testing](/blog/2016/06/06/ordered-tests-with-nunit-mstest-xunit-pt2-mstest), but that implementation it's own disadvantages. So, what about ordered testing in NUnit? NUnit has very limited [support for ordered testing](/blog/2016/06/07/ordered-tests-with-nunit-mstest-xunit-pt3-nunit), so I decided to build a library to allow test ordering in NUnit. I gladly announce the [NUnitTestOrdering](https://github.com/Sebazzz/NUnitTestOrdering) library: Allowing you to order NUnit tests similar to MSTest.

## Features
The library offers the following features:

- Build complex test ordering hierarchies
- Skip subsequent tests if an test fails
- Order your test methods by dependency instead of integer order
- Supports usage side-by-side with unordered tests. Unordered tests are executed first

## Usage

Include the library into your project and include the following code in your AssemblyInfo file:

{% highlight C# %}
[assembly:EnableTestFixtureOrdering]
{% endhighlight %}

Now you can start writing ordered tests. You can order both test fixtures and the methods within fixtures themselves.

**Note:** If you use the NuGet package this has already been arranged for you!

### Test Fixture ordering
The main feature of the library is to order test fixtures. In order to set-up fixture ordering, derive a class from `TestOrderingSpecification`. Decorate your new class with the `OrderedTestFixtureAttribute`. Override and implement the `DefineTestOrdering` method.

In the `DefineTestOrdering` method you can call `TestFixture` and `OrderedTestSpecification` to register an `TestFixture` or `OrderedTestSpecification` to run in order.

Let's say we're building a webshop, and want to run an UI automation test on the workflow of:

- Enter a product as administrator
- Buy the product as a customer
- Ship the order as administrator

We could model this scenario like:

{% highlight C# %}
[OrderedTestFixture]
public sealed class WebUITestFixture : TestOrderingSpecification {
    protected override void DefineTestOrdering() {
        TestFixture<EnterProductFixture>();
        TestFixture<BuyProductFixture>();
        TestFixture<ShipOrderFixture>();
    }

    protected override bool ContinueOnError => false; // Or true, if you want to continue even if a child test fails, but in this case we depend on the workflow to complete, so we don't want to do that.
}
{% endhighlight %}

And from the commandline execute this scenario using:

	nunit3-console.exe MyAssembly.dll -where "test==Ordered.WebUITestFixture"

This also allows us to build multiple test scenario's. We might have a smoke test we want to execute when we do a daily deployment to the staging environment:

{% highlight C# %}
[OrderedTestFixture]
public sealed class SmokeTestFixture : TestOrderingSpecification {
    // ...
}
{% endhighlight %}

### Ordering test methods within fixtures
Within test fixtures you'Il often want to order the individual test methods as well. Let's check this scenario:

{% highlight C# %}
[TestFixture]
public sealed class EnterProductFixture {

	[Test]public void EnterProduct();

	[Test]public void FindProductInOverview();
}
{% endhighlight %}

We need to enter a product before we can look it up in the overview. Sometimes, the test fixture itself may be generated, for example by the excellent [SpecFlow](http://www.specflow.org/) framework. 

In that case you can apply an ordered to the test fixture, to allow test methods to execute in the order you want:

{% highlight C# %}
partial class EnterProductFixture {
    private sealed class Orderer : TestOrderer<Tests> {
        protected override void DefineOrdering() {
            TestMethod(nameof(EnterProduct));
            TestMethod(nameof(FindProductInOverview));
        }
    }
}
{% endhighlight %}

## Download
Download the current prerelease from [NuGet](https://www.nuget.org/packages/NUnitTestOrdering/):

    Install-Package NUnitTestOrdering -Pre
    
Or [download and compile](https://github.com/Sebazzz/NUnitTestOrdering#building) build the binaries yourself.

## How can you help
The library is currently in alpha stage. It has tests for many scenario's and > 75% code coverage. I'm currently looking for feedback to improve the library to be able to release a first a first stable version on NuGet.

Just drop me a comment here or open [an issue](https://github.com/Sebazzz/NUnitTestOrdering/issues) on GitHub. Thanks!

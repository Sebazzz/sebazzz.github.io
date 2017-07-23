---
layout: post
title:  "Ordered testing with XUnit, NUnit and MSTest part 1: The setup"
date:   2016-06-05 12:00:08 +0200
categories: test-frameworks development
---

In the [previous post](/blog/2016/06/04/comparing-dotnet-testing-frameworks) we have compared three testing frameworks: MSTest, NUnit, and XUnit. In this series, we are going to implement ordered tests in these frameworks. The code for this post can be found on [GitHub](https://github.com/Sebazzz/NetUnitTestComparison/tree/2016-06-05). 

This post is part of a series of posts on ordered testing:
{% include postseries.html posts=site.data.blog_orderedtests %}

<!-- excerpt -->

## Why ordered testing?
Ordered testing is often useful when writing integration tests. Often an integration test consists of multiple steps which you want to be able to test as seperate units. Splitting an long integration test into different tests improves maintainability. This is especially useful for tests which use web automation frameworks like Selenium. If you look at the past sentences, you'Il notice we actually want to express dependencies between tests: One test may not run without the other.

## Our set-up
We are going to define three test classes which must be executed in order:

1. PreIntegrationTest
2. IntegrationTest
3. PostIntegrationTest

Within each test class we have tests which are also dependend on order. In `IntegrationTest` we define a fictional integration test: CRUD of an entity. 

## Our goal
We want to order our tests based on their dependencies. Tests may be dependend on a other, so the dependency must be executed first. 

In the next post, we will implement ordered testing using MSTest. 
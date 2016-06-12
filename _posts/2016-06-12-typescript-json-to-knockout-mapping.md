---
layout: post
title:  "Typescript: JSON to Knockout mapping using decorators"
date:   2016-06-12 10:00:00 +0200
categories: web development
---

Inspired by [this post](http://cloudmark.github.io/Json-Mapping/) of Mark Galea about mapping JSON objects to classes I asked myself the question: Would it be possible to use this technique to map JSON objects to Knockout view models? This is even more so useful since the [knockout.mapping](https://github.com/SteveSanderson/knockout.mapping) plugin is not being maintained. Also, any knockout mapping library causes redundancy in your code: You have to specify types and properties twice in a worst-case scenario: Once in the class, once in the mapping code. There is surely a better way. 

## TL;DR of the original post
The original post describes how it is possible to create a json to object mapping by using the [decorators](http://www.typescriptlang.org/docs/handbook/decorators.html) feature of Typescript. Decorators are described in an proposal for the upcoming ES7, and already implemented in Typescript. Because the spec  and the related metadata API spec is not final, these features are hidden behind a flag of the compiler.

When including the experimental Reflect API in your code, Typescript emits the decorators via the Reflect API. Also, Typescript emits the class constructor via the `design:type` field. This allows to easily look up the appropiate constructor for an property. This doesn't work for array properties unfortunately, and manually specifying the class constructor is needed for that.

## Our case
For this post I have set up a very simple case for implementing a json-to-knockout mapping:

We have a survey system and our survey editor is written in typescript. Our data is represented by `Question` and `Answer` classes:

{% highlight javascript %}
export enum QuestionType {
    MultipleChoice,
    Text
}

export class Answer {
    public id: number = 0;
    public text = ko.observable<string>();
    public order = ko.observable<number>(0);
}

export class Question {
    public text = ko.observable<string>();
    public id: number = 0;
    public type = ko.observable<QuestionType>(QuestionType.MultipleChoice);
    public order = ko.observable<number>(0);

	public answers = ko.observableArray<Answer>();
}
{% endhighlight %}

We want to map the JSON generated from the server seamlessly to our classes. 

## Knockout.js recap
Let's recap how knockout observables work. Knockout observables are *functions* which either set a value or return a value based on how many arguments were provided to the observable. Knockout observable arrays are just like normal observables, but are enhanced with methods which provide array functions. And - of course - should contain an array as value.

### Knockout in Typescript
Knockout is very easily used in Typescript in a strongly-typed manner:

{% highlight javascript %}
public text = ko.observable<string>();
{% endhighlight %}

The type definition of an observable is simply a generic interface:

{% highlight javascript %}
interface KnockoutObservable<T> {}
{% endhighlight %}

Normally, the class constructor is emitted via the `design:type` metadata field. How does this work for observables? Let's take a look at the generated code:

{% highlight javascript %}
__decorate([
    __metadata('design:type', Object)
], Question.prototype, "answers", void 0);
{% endhighlight %}

Unfortunately, the generic type parameter is not encoded in the metadata. This feature was actually [requested](https://github.com/Microsoft/TypeScript/issues/3015) but not built because it was too complex. 

## Implementing the mapping code
The only thing that differs between normal javascript properties and observables is that observables shouldn't be set using the assignment operator. Instead, observables need to be called as a function with the value as parameter.

Let's abstract setting a property into seperate interface:

{% highlight javascript %}
interface IPropertyAccessor {
    set(object : Object, name : string, value : any);
}
{% endhighlight %}

We implement this for both regular and observable properties:

{% highlight javascript %}
class KnockoutPropertyAccessor implements IPropertyAccessor {
    public set(object: Object, name: string, value) {
        const observable = <KnockoutObservable<any>>object[name];
        observable(value);
    }
}

class RegularPropertyAccessor implements IPropertyAccessor {
    public set(object: Object, name: string, value) {
        object[name] = value;
    }
}
{% endhighlight %}

And now during mapping, we only have to check whether our target property is an observable:

{% highlight javascript %}
var item = obj[key],
    itemIsObservable = ko.isObservable(item),
    itemIsWritableObservable = ko.isWriteableObservable(item);

if (itemIsObservable && !itemIsWritableObservable) {
    // ignore this prop - can't write anyway
    return;
}

var propertyAccessor = itemIsObservable ? new KnockoutPropertyAccessor() : new RegularPropertyAccessor();

// [...]

const propertyMetadata = MapUtils.getJsonProperty(obj, key);
if (propertyMetadata) {
    const propertyValue = getChildObject(propertyMetadata);

    propertyAccessor.set(obj, key, propertyValue);
} else {
    // No metadata, lookup Json property by property name
    if (jsonObject && (key in jsonObject[key])) {
        propertyAccessor.set(obj, key, jsonObject[key]);
    }
}
{% endhighlight %}

We have one thing left to check when mapping: The original code checks if the target property is an array. This won't work if we map to an observable array. Let's modify the code a bit:

{% highlight javascript %}
// [...]
    itemIsWritableObservable = ko.isWriteableObservable(item),
    itemHasArrayType = itemIsObservable && MapUtils.isArray(item.peek()) || MapUtils.isArray(item);

// [...]

const getChildObject: (x: IJsonMetaData<any>) => any = (propertyMetadata: IJsonMetaData<any>) => {
    // [...]

    const designType = MapUtils.getDesignType(obj, key);

    if (itemHasArrayType || MapUtils.isArray(designType)) {
        // [...]
{% endhighlight %}

We check if the value contained by the observable is an array. If so, we still execute the mapping code.

## Decorating our view models
As we've discovered, the generic type parameters are not encoded in the metadata of a property. This means we're going to do it ourselves by explicitly specifying the class name when decorating an observable that is not an primitive:

{% highlight javascript %}
@JsonProperty({ clazz: Answer })
public answers = ko.observableArray<Answer>();
{% endhighlight %}

And... we're done! Check out the entire code solution and working demo on [GitHub](https://github.com/Sebazzz/typescript-knockout-to-json-mapping).

## Limitations
This solution is not without its limitations. First of all is that one needs to specify the correct class for each complex observable property. This is a limitation of the Typescript compiler, though it [may be possible](https://github.com/Microsoft/TypeScript/issues/3015#issuecomment-128533683) to work around it by talking to the Typescript compiler directly.

Second limitation, just like the original solution, is that it isn't very suited for javascript-to-json mapping yet. That would probably require decorating each attribute to allow proper mapping back.

Third limitation, just like the original solution, is that it isn't very suitable for mapping multiple json objects to the same target object. If you want that, you're best of with custom mapping code.

## Conclusion
We've seen how we can adapt the mapping technique to allow mapping to Knockout view models. While it is not without its limitations, its still a very interesting approach.
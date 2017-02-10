---
layout: post
title:  "Resolve ClassCastException in Omnifaces related to Xalon (or: How to resolve maven dependency issues)"
date:   2017-02-10 12:00:00 +0100
categories: java development
---

While developing an Java EE application on JBoss 6.1.0 EAP which uses Omnifaces I ran into an issue that caused *some* pages not to be rendered. A `NoClassDefFoundError` occurred but the actual class did exist! The most odd issue was that this happened after upgrading an unrelated dependency in the maven pom file. 

The stack trace is should below: 

```
java.lang.NoClassDefFoundError: Could not initialize class org.omnifaces.config.WebXml
	org.omnifaces.context.OmniPartialViewContext$OmniPartialResponseWriter.startDocument(OmniPartialViewContext.java:253)
	org.primefaces.context.PrimePartialResponseWriter.startDocument(PrimePartialResponseWriter.java:133)
	com.sun.faces.context.PartialViewContextImpl.processPartial(PartialViewContextImpl.java:287)
	javax.faces.context.PartialViewContextWrapper.processPartial(PartialViewContextWrapper.java:183)
	javax.faces.context.PartialViewContextWrapper.processPartial(PartialViewContextWrapper.java:183)
	javax.faces.component.UIViewRoot.encodeChildren(UIViewRoot.java:973)
  [redacted]
```

I was not able to find the cause initially, but as it happens, Omnifaces swallows the causing exception all but the first time. You have to look back to the first time the exception occurred. Then I found:

```
java.lang.ClassCastException: org.apache.xml.dtm.ref.DTMManagerDefault cannot be cast to org.apache.xml.dtm.DTMManager
	org.apache.xml.dtm.DTMManager.newInstance(DTMManager.java:137)
	org.apache.xpath.XPathContext.<init>(XPathContext.java:102)
	org.apache.xpath.jaxp.XPathExpressionImpl.eval(XPathExpressionImpl.java:115)
	org.apache.xpath.jaxp.XPathExpressionImpl.eval(XPathExpressionImpl.java:99)
	org.apache.xpath.jaxp.XPathExpressionImpl.evaluate(XPathExpressionImpl.java:184)
	org.omnifaces.config.WebXml.parseErrorPageLocations(WebXml.java:211)
	org.omnifaces.config.WebXml.<init>(WebXml.java:84)
	org.omnifaces.config.WebXml.<clinit>(WebXml.java:53)
	org.omnifaces.context.OmniPartialViewContext$OmniPartialResponseWriter.startDocument(OmniPartialViewContext.java:253)
	org.primefaces.context.PrimePartialResponseWriter.startDocument(PrimePartialResponseWriter.java:133)
	com.sun.faces.context.PartialViewContextImpl.processPartial(PartialViewContextImpl.java:287)
	javax.faces.context.PartialViewContextWrapper.processPartial(PartialViewContextWrapper.java:183)
  [redacted]
```

After [several](http://stackoverflow.com/q/8863974/646215) [posts](http://stackoverflow.com/q/22334144/646215) on StackOverflow and [elsewhere](http://www.itgo.me/a/6067320316527870143/java-lang-classcastexception-org-apache-xml-dtm-ref-dtmmanagerdefault-cannot-be) I finally found the issue: JBoss itself uses a library called Xalan and actually provides this to the application. In my case one of my dependencies was supposedly dragging in Xalan as well, because Xalan was deployed in the `WEB-INF/lib` folder.

However, nowhere in my Maven pom file I was able to find references to Xalan. The best way to resolve such issue is to compile the dependency tree of your repository and work from there:

```
mvn dependency:tree >> dependencies.txt && vim dependencies.txt
```

You will get a large file which shows a tree of all the dependencies in your project. The relevant parts in my output:

```
[INFO] [redacted]war:3.2.5.8
[INFO] +- org.jboss.spec:jboss-javaee-6.0:pom:3.0.2.Final:provided
[...]
[INFO] |  +- org.jboss.spec.javax.servlet.jsp:jboss-jsp-api_2.2_spec:jar:1.0.0.Final:provided
[INFO] |  +- org.jboss.spec.javax.servlet.jstl:jboss-jstl-api_1.2_spec:jar:1.0.1.Final:provided
[INFO] |  |  \- org.apache.xalan:xalan:jar:2.7.1-1.jbossorg:provided
[INFO] |  +- org.jboss.spec.javax.transaction:jboss-transaction-api_1.1_spec:jar:1.0.0.Final:provided
[...]
[INFO] +- org.apache.xmlgraphics:batik-awt-util:jar:1.7:compile
[INFO] +- org.apache.xmlgraphics:batik-bridge:jar:1.7:compile
[INFO] |  +- org.apache.xmlgraphics:batik-script:jar:1.7:compile
[INFO] |  |  \- org.apache.xmlgraphics:batik-js:jar:1.7:compile
[INFO] |  \- xalan:xalan:jar:2.6.0:compile
[INFO] +- org.apache.xmlgraphics:batik-codec:jar:1.7:compile
[INFO] +- org.apache.xmlgraphics:batik-css:jar:1.7:compile
[INFO] +- org.apache.xmlgraphics:batik-dom:jar:1.7:compile
[INFO] +- org.apache.xmlgraphics:batik-xml:jar:1.7:compile
[INFO] +- org.apache.xmlgraphics:batik-parser:jar:1.7:compile
[INFO] +- com.thaiopensource:jing:jar:20091111:compile
[...]
```

Note that the `org.apache.xmlgraphics` package, `batik-bridge` module pulls in Xalan. You can prevent this from happening by excluding the dependency in your pom file:

```
[...]
<dependency>
    <groupId>org.apache.xmlgraphics</groupId>
    <artifactId>batik-bridge</artifactId>
    <version>1.7</version>
    
    <!-- Add below configuration -->
    <exclusions>
	    <!-- ClassCastException: org.apache.xml.dtm.ref.DTMManagerDefault -> org.apache.xml.dtm.DTMManager -->
	    <exclusion>
	        <artifactId>xalan</artifactId>
	        <groupId>xalan</groupId>
	    </exclusion>
    </exclusions>
</dependency>
[...]
```

Save your pom file and run the dependency tree generation again. In my cause, the `batik-dom` module was now shown importing Xalan as well. Add exclusions for every new dependency you find and rerun the diagnostics. It is a bit whack-a-mole but eventually you'Il find that Xalan is no longer pulled in.

Verify this by running a clean build and checking that the Xalan jar file is indeed not present in the lib directory. 

I lost quite a few hours due to this issue. I hope to save anyone some time with this.
 

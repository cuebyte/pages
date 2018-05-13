---
title: "How to Logging UTF-8 String for Apache HTTP Client?"
description: "Logging UTF-8 string for Apache HTTP Client by overwriting the source code."
date: 2018-05-12T21:59:09+02:00
lastmod: 2018-05-12T22:49:09+02:00
draft: false 
keywords: ["Apache HTTP Client", "logback", "slf4j", "UTF-8", "utf8", "open-source licenses", "Apache License 2.0", "java classloader"]
tags: ["java"]
categories: ["Solution"]
author: "cuebyte"

comment: true 
toc: false
postMetaInFooter: true
hiddenFromHomePage: false
---

When I read the logs from Apache HTTP Client, I found the Japanese / Korean words cannot be display, instead, there only some words like "\[0x8a\]\[0x7b\]\[0x6c\]…". The log data is very important, we are not allow any unreadable data in the log, otherwise the logs gonna be useless.

From the log infomation, we find the Apache HTTP Client logs the logs at Wire:72, then I go to the source, the code is below:

```java
while ((ch = instream.read()) != -1) {
    if (ch == 13) {
        buffer.append("[\\r]");
    } else if (ch == 10) {
        buffer.append("[\\n]\"");
        buffer.insert(0, "\"");
        buffer.insert(0, header);
        log.debug(buffer.toString());
        buffer.setLength(0);
    } else if ((ch < 32) || (ch > 127)) {
        buffer.append("[0x");
        buffer.append(Integer.toHexString(ch));
        buffer.append("]");
    } else {
        buffer.append((char) ch);
    }
}
```

I don't know why it only supports ASCII here, it is already 2018… And the library even don't support any configuration to tuning the encoding or implements. So I made an implement by myself, to overwrite the Wire.java file — **copy the source code to our project with the same package name, and simply change the logging code.** 

In my case, I modified the code as below:

```java
try (Reader reader = new BufferedReader(new InputStreamReader
        (instream, Charset.forName(StandardCharsets.UTF_8.name())))) {
    int c = 0;
    while ((c = reader.read()) != -1) {
        buffer.append((char) c);
    }
}
```

This logging code will support the UTF-8 well, and will not break the HTTP request / response infomation into multi log lines.

You can change the code to whatever you like, but please keep in mind, **when you changing the code, you have to follow the open source license**. For my instance, the Apache HTTP Client library is with the Apache License 2.0, it means the library can be used for commercial, however I have to make the changed source code under the Apache License 2.0, and to name where I modified.
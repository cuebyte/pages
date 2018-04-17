---
title: How to Build A Modern HTTPS Blog from Zero
description: How to build a modern blog with Github Pages and ClouldFlare
date: 2018-04-14T11:14:54+02:00
lastmod: 2018-04-17T10:24:54+02:00
tags: ["HTTPS", "CloudFlare", "Github Pages"]
categories: ["Tutorial"]
author: "cuebyte"
keywords:
- tutorial
- setup blog
- build blog
- start blog
- Github Pages
- Hugo
- CloudFlare
- HTTPS
- CDN
comment: true
toc: true
hiddenFromHomePage: false
---

To build a blog, Wordpress is always the best choice, anyone who has a public IP (costs 5 USD/mo.), will be easily to build a blog within 30 mins. People can also choice some service like [ghost](https://ghost.org/) or [wix](https://www.wix.com/) or something else to build their personal blog, however their usually more expensive. I don't want to pay $5 per month just for a blog, which only hosts static content, so I went for the most popular static content host solution: [Github Pages](https://pages.github.com/), and the most popular (or even best) free CDN solution: [CloudFlare](https://www.cloudflare.com/), to boost my blog. 

Now, I will show you how to build a modern blog with Github Pages and ClouldFlare. Let's start!

## Getting Start

### Hugo & Github Pages

Github Pages is a service which hosts your github repository's static files like html, css, js, to show to the `<name>.github.io`, you can use any static blog generator to generate and manage your blog. There are many good options: 

- [Jekyll](https://jekyllrb.com/), written in Ruby, recommended by Github Pages
- [Hexo](https://hexo.io/), written in Node.js, many front-end developer's choice
- [Hugo](https://gohugo.io/), written in Go, no environment required, easy to deploy
- etc...

Here I choosed Hugo, as Hugo doesn't require any environment, I can install it by brew very easily (on macOS):

```bash
brew install hugo
```

To setup a static blog by Hugo is also very simple, you can follow this **[<u>quick start</u>](https://gohugo.io/getting-started/quick-start/)**. Whatever generator you choose, you can set up you blog on your local machine very easily. And please remember to **choose a theme** that you like, it will represents your tasty!

After you can run your blog in your local machine, you can google how to let your blog generator works together with Github Pages. If you also use Hugo, you can follow this Hugo [**<u>tutorial</u>**](https://gohugo.io/hosting-and-deployment/hosting-on-github/) to deploy your blog on Github Pages.

### Domain & DNS

Great! Now your blog is runing on the real world! 

However, for more than 80% people, they stoped at here. The domain of the URL is still github.io, everyone will know it just hosted on a github repository, and the blog needs 2 sec to loading, even more. If you want to optimize it, go to have a domain! If you want to show you name, make you own brand, go to have a domain! A URL with domain like *medium.com, blogspot.com, github.io* could never be your own brand. That means you do not own the blog, you are just a single user of them.

There are many domain sellers around the internet, I bought my domain at [namecheap](https://www.namecheap.com/), sometime you will find better price then other nameservers. Usually a domain will cost you more than $10 per year, but it's worth. ;-) 

After you having a domain, you need to register you domain to some nameservers, otherwise, no any single machine will knows will your URL leads to, your domain will be unreachable. Yesterday, I chose CloudFlare as my "Domain Name System" (DNS), because I was going to use their CDN service. If you are following this article to build your blog, I recommend to choose it, afterall, it's free. :D

After you registerd in CloudFlare and added your site, you need to go to your dashboard, get into the "DNS" page. You will need to copy Cloudflare nameservers addresses (like below):

![A](https://i.imgur.com/rhvBkzw.png)

And paste them to your domain seller's domain configurations, like below:

![B](https://i.imgur.com/Ov0V7Vj.png)

And then, you should setup how the DNS will resolve your domain. There are many types of DNS record to let you resolve your domain, like:

- `A` is for resolving domain to an IPv4 address
- `AAAA` is for resolving domain to an IPv6 address
- `CNAME` is for resolving domain (usually sub-domain) to another domain
- `MX` is for email server

In this case, as you need to map your domain to the `<name>.github.io`, you should to choose `CNAME` type record, and set your DNS record like below:

![C](https://i.imgur.com/X7b9Msg.png)

And then, you need to create a file names "CNAME" locates in the root dir of your `<name>.github.io` project, and write your domain into it. If you have any knowledge about Linux, it can just simply done by the command below:

```bash
echo "<your-domain>" > CNAME
```

At CloudFlare, you can map your root domain to your github pages, like below. To know how can they do this, please check this [link](https://support.cloudflare.com/hc/en-us/articles/200169056-CNAME-Flattening-RFC-compliant-support-for-CNAME-at-the-root). It will need sometime to wait CloudFlare submit your DNS record to root DNS servers, and let your DNS record   spreads to all DNS servers around world, it will be finished within 24 hours. For my experience, it will takes around 1 hour or less.

### HTTPS, CDN, Security

Now, you have a nice looking blog under your domain! Congratulations!

Unfortunately GitHub Pages doesn’t yet support SSL on GitHub Pages for custom domains which would ordinarily rule out using HTTP/2. Whilst the HTTP/2 specification ([RFC 7540](https://tools.ietf.org/html/rfc7540)) allows for HTTP/2 over plain-text HTTP/2, all popular browsers require HTTP/2 to run on top of Transport Layer Security; meaning HTTP/2 only being able to run over HTTPS is the de-facto standard.

Fortunately, CloudFlare’s Universal SSL option allows us provide a signed SSL certificate to site visitors. This allows us to gain the performance benefits of HTTP/2 and [potentially improve search engine rankings](https://webmasters.googleblog.com/2014/08/https-as-ranking-signal.html).

![](https://blog.cloudflare.com/content/images/2016/06/cloudflare_ssl_modes.png)

In the Crypto tab of your CloudFlare site you should ensure your SSL mode is set to `Full`but not `Full (Strict)`:

![](https://blog.cloudflare.com/content/images/2016/06/T08btVu.png)

We can now add a Page Rule to enforce HTTPS, as you add other Page Rules make sure this is the primary Page Rule:![](https://blog.cloudflare.com/content/images/2016/06/always_use_https_page_rule.png)

Enabling HTTP Strict Transport Security (HSTS) will help ensure that your visitors have to communicate to your site over HTTPS, by telling browsers that they should always communicate over encrypted HTTPS. Be careful if you choose to set this though, it may render your site inaccessible if you wish to choose to ever turn HTTPS off.



CloudFlare has a “Cache Everything” option in Page Rules. For static sites, it allows your HTML to be cached and served directly from CloudFlare's CDN.

![](https://blog.cloudflare.com/content/images/2016/06/PtBIQyF.png)

When deploying your site you can use the Purge Cache option in the Cache tab on CloudFlare to remove the cached version of the static pages. If you’re using a Continuous Integration system to deploy your site, you can use our [API](https://api.cloudflare.com/) to clear the cache programmatically.

What's more, you can find more options on your CloudFlaire dashboard to tuning your blog, to make your blog faster and safer.

### Plugins & Extensions.

If you have any knowledge on Wordpress, you will know there are so many useful plugins. Although on static website there are no so much plugins to use (only Javascript), you can still find some good things to enrich your blog, such as, [Google Analytics](https://analytics.google.com/), [Disqus](https://disqus.com/). You might also find some useful plugins or extensions on Hugo's community (or whichever website generator's community which you use).

## Performace

After you finished all the steps above, you blog will be completely boosted by ClouldFlare CDN. For my blog, for the first-time-loading, all files will be loaded within 150ms, the page will be rendered whinin 250ms.

![1](https://i.imgur.com/QnnPGDB.png)

When loading with cache, all files will be loaded within 50ms, the page will be rendered within 200ms

![2](https://i.imgur.com/YI816p8.png)

## Conclusion

It was really supervised me that I can use free resources build such awesome static blog. Everybody knows Github Pages is amazing, but not many people know CloudFlare supports such amazing services:

- Free & Good CDN
- Auto re-new SSL Certificate (under the domain of cloudflaressl.com)
- HTTPS all cover
- Free DNS service

Thanks for this time, that people are able to use such good service with free. However I also consern about the giants (internaional huge companies) like CloudFlare, Google, AWS, as the idea of anti-trust is always in my mind, there are already too many Leviathans around the world, and our lives are becoming more and more dependent on those giants. Besides thanks to them, we should keep our mind clear, that we are the master of our live, not them.

## Refer

- [Secure and fast GitHub Pages with CloudFlare](https://blog.cloudflare.com/secure-and-fast-github-pages-with-cloudflare/)
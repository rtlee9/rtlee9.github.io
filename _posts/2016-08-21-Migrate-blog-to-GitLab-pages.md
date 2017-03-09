---
title: From GitHub Pages to GitLab Pages
subtitle: Static website hosting migration
layout: post
gradient: canvas
tags: [technology, open source, static websites, Jekyll]
---

Last week I decided to migrate this blog, [Eight Portions](https://eightportions.com), from [GitHub Pages](https://pages.github.com/) to [GitLab Pages](https://pages.gitlab.io/) for hosting service. My experience to-date has been net positive: GitLab Pages offers more flexibility and control over your site than does GitHub Pages, though at the expense of performance and ease-of-use. This post offers a high-level comparison of these two hosting services, and provides a set of quick-start instructions and resources to get you started should you decide to follow suit.

## Contents

* [To move or not to move: high-level considerations](#considerations)
* [Instructions and additional resources](#instructions)
* [Additional resources](#additional-resources)

## To move or not to move: high-level considerations {#considerations}

I've outlined below the biggest factors that went into my decision to migrate to GitLab Pages. There are obviously many other factors to consider, which may or may not be important to you, so assess these in the context of your needs.

#### Advantages of GitLab Pages:
* GitLab Pages allows your site to utilize __any Jekyll plugin__, while GitHub Pages only [officially](https://help.github.com/articles/adding-jekyll-plugins-to-a-github-pages-site/) supports the plugins in the [GitHub Pages gem](https://github.com/github/pages-gem).
* GitLab Pages supports __non-Jekyll static website generators__ such as [Hugo](http://gohugo.io/) and [Hyde](http://hyde.github.io/), while GitHub Pages [requires](https://help.github.com/articles/using-a-static-site-generator-other-than-jekyll/) you to push locally-built sites if using non-Jekyll static site generators
* CI (Continuous Integration) is built into GitLab, whereas full CI functionality is not built into GitHub Pages[^1]. Once configured, [GitLab CI](https://about.gitlab.com/gitlab-ci/) can automatically:
  * Test[^2] and build __all of your branches__ with __user-specified dependencies and versions__
  * Publish your master branch build, and save your other branches' builds for testing purposes
  * Notify you of any errors along the way[^3]

#### Disadvantages of GitLab Pages:
* Build time on GitLab Pages is slightly __slower__ than on GitHub Pages, though I'm sure there are ways for users to significantly enhance their CI builds[^4]
* It is slightly __more involved__ to get off the ground with GitLab Pages than with GitHub Pages, largely due to the CI configuration; hopefully the [instructions below](#instructions) will help with this
* GitLab Pages __documentation isn't as well-organized__ as the GitHub Pages documentation -- again, I hope the instructions below will help you navigate the setup process

#### Other noticeable differences, less relevant to static site hosting:
* GitLab offers free private repos (both GitLab and GitHub offer free public repos)
* The GitLab platform is itself [open source](https://gitlab.com/gitlab-org/gitlab-ce)
* The GitLab community is significantly smaller than the GitHub community

## Instructions and additional resources {#instructions}

Should you choose to migrate to GitLab Pages like I did, start by simply __[cloning](http://docs.gitlab.com/ce/workflow/importing/import_projects_from_github.html) your existing Jekyll repo__ to GitLab.

Next, confirm that [shared Runners](https://about.gitlab.com/2016/04/05/shared-runners/) are enabled (Settings > Runners), and then  __create a configuration file__ in your repo's root directory named `.gitlab-ci.yml` to tell the CI how to test and build your site. This [document](https://gitlab.com/jekyll-themes/default-bundler/blob/master/README.md) provides a good template if you're generating your site with Jekyll. If you're going to using another static site generator, you can find some great examples [here](https://gitlab.com/groups/pages). This is what my config file looks like:

{% highlight yaml linenos %}
image: ruby:2.3  # Use Ruby Docker image

cache:  # Add Bundler cache to 'vendor' directory
  paths:
    - vendor/

before_script:  # Install Gems to 'vendor' directory
  - bundle install --path vendor

test:
  stage: test
  script:  # Generate test site(s) into 'test' directory
  - bundle exec jekyll build -d test
  artifacts:  # Save a zipped version for download
    paths:
    - test
  except:  # Execute for all branches except master
  - master

pages:
  stage: deploy
  script:  # Generate public site and deploy
  - bundle exec jekyll build -d public
  artifacts:  # Save a zipped version for download
    paths:
    - public
  only:  # Only deploy the master branch
  - master
{% endhighlight %}

Once your CI config file is set up, change your repo name to `<GitLab_username>.gitlab.io`. If you have a __custom domain name__, then you'll need to:

1. With your domain name registrar (e.g., [Namecheap](https://www.namecheap.com/)), drop your old _A Record(s)_[^5] and add a new one with the value of GitLab Pages' IP: `52.167.214.135`
1. Update your _CNAME Record_ with your domain name registrar to `<GitLab_username>.gitlab.io`
1. Remove the _CNAME_ text file from your previous repo

Next, you should __strongly consider securing your site by [adding HTTPS](https://about.gitlab.com/2016/04/11/tutorial-securing-your-gitlab-pages-with-tls-and-letsencrypt/)__, using [Let's Encrypt](https://letsencrypt.org/) and [Certbot](https://certbot.eff.org/) (it's all free). This step is optional, though recommended -- a nice summary from Google of why you should use HTTPS can be found [here](https://developers.google.com/web/fundamentals/security/encrypt-in-transit/why-https?hl=en).

Lastly, __add your domain__ to GitLab Pages (Settings > Pages), adding your new TLS certificate and key if relevant. Congrats -- you're all set up!

## Additional resources

* [GitLab Pages: step-by-step tutorial](https://about.gitlab.com/2016/04/07/gitlab-pages-setup/)
* [GitLab Pages: documentation](http://docs.gitlab.com/ee/pages/README.html)

---

### Footnotes

[^1]: GitHub Pages automatically generates your site from the latest master branch commit, but does not give the user the ability to automatically run their own tests, specify dependency versions, or build from non-master branches; it's possible to use [Travis-CI](https://travis-ci.org/) to get these features if hosting from GitHub Pages, though some additional work is required
[^2]: Testing scripts might do some combination of the following: test `jekyll build` for build failures, test analysis or other code run at compile time, and/or validate HTML output (great summary [here](https://jekyllrb.com/docs/continuous-integration/#the-test-script))
[^3]: Build notifications can be enabled in your site's GitLab repo by going to Settings > Services > Builds emails
[^4]: Under [my CI configuration](https://gitlab.com/rtlee/rtlee.gitlab.io/blob/master/.gitlab-ci.yml) GitLab CI takes 1-2 minutes to build my site, whereas it typically took GitHub Pages 10-20 seconds (this isn't a huge negative for me) -- part of this is due to the fact that I build all branches (not just master) and part is due to the fact that the GitLab Pages build process is containerized, so it requires time to load Docker images, Gems, etc.; I may look into [Jekyll incremental builds](http://idratherbewriting.com/2015/11/04/jekyll-30-released-incremental-regeneration-rocks/) if performance becomes too much of an issue
[^5]: If you are currently using GitHub Pages, then you will likely have two _A Records_: `192.30.252.153` and `192.30.252.154`

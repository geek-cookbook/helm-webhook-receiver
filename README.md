
[cookbookurl]: https://geek-cookbook.funkypenguin.co.nz
[discourseurl]: https://discourse.geek-kitchen.funkypenguin.co.nz
[discordurl]: http://chat.funkypenguin.co.nz
[patreonurl]: https://patreon.com/funkypenguin
[blogurl]: https://www.funkypenguin.co.nz
[twitchurl]: https://www.twitch.tv/funkypenguinconz
[twitterurl]: https://twitter.com/funkypenguin
[dockerurl]: https://geek-cookbook.funkypenguin.co.nz/ha-docker-swarm/design
[k8surl]: https://geek-cookbook.funkypenguin.co.nz/kubernetes/start

<div align="center">

[![geek-cookbook](https://raw.githubusercontent.com/geek-cookbook/autopenguin/master/images/readme_header.png)][cookbookurl]
[![Discord](https://img.shields.io/discord/396055506072109067?color=black&label=Hot%20Sweaty%20Geeks&logo=discord&logoColor=white&style=for-the-badge)][discordurl]
[![Forums](https://img.shields.io/discourse/topics?color=black&label=Forums&logo=discourse&logoColor=white&server=https%3A%2F%2Fdiscourse.geek-kitchen.funkypenguin.co.nz&style=for-the-badge)][discourseurl]
[![Cookbook](https://img.shields.io/badge/Recipes-44-black?style=for-the-badge&color=black)][cookbookurl]
[![Twitch Status](https://img.shields.io/twitch/status/funkypenguinconz?style=for-the-badge&label=LiveGeeking&logoColor=white&logo=twitch)][twitchurl]

:wave: Welcome, traveller!
> The [Geek Cookbook][cookbookurl] is a collection of geek-friendly "recipes" to run popular applications on [Docker Swarm][dockerurl] or [Kubernetes][k8surl], in a progressive, easy-to-follow format.  ***Come and [join us][discordurl], fellow geeks!*** :neckbeard:
</div>

 
# Contents

1. [What is this?](#what-is-this)
2. [How to use it?](#how-to-use-it)


# Why should I use this chart?

For one thing, it's known to be syntactically correct, thanks to the wonders of CI:

![Linting](https://github.com/geek-cookbook/webhook-receiver/workflows/Linting/badge.svg)
![Testing](https://github.com/geek-cookbook/webhook-receiver/workflows/Testing/badge.svg)


 
# How to use it?

Use helm to add the repo:

```
helm repo add geek-cookbook https://geek-cookbook.github.io/charts/
```

Then simply install using helm, for example

```
kubectl create namespace webhook-receiver
helm upgrade --install --namespace webhook-receiver geek-cookbook/webhook-receiver
```




# What is this?

its code. for generating READMEs.

# How to use it?

**TL;DR:** `helm install webhook-receiver`

### Configuring

To configure most things, the `values.yaml` file has documentation in it. For adding your own hooks, see below.

#### Adding Custom Hooks

Adding custom hooks can be done through the a custom `values` file.

To do so, create a new item on the `hooks` map.
In here you need to add 3 fields; `enable`, `files` and `hook`.

Enable is self explaintory: Does this webhook run when queried?

Files is where you place all files required for this hook to run. This is a map, with the key being the path to mount it do, and the value being the file contents.

Finally is the `hook` field, this is where you put in your hook configuration as per the spec from the [application docs](https://github.com/adnanh/webhook/wiki/Hook-Definition)

Below is an example of a `values.yaml` file

```yaml
# my-custom-values.yaml
hooks:
  myhook:
    enable: true
    files:
      /data/helloworld.sh: |
        #!/bin/sh
        echo &#34;Hello World!&#34;
    hook:
      id: helloworld
      execute-command: /data/helloworld.sh
```

Now you are ready to install this helm chart onto your kubernetes cluster.

```sh
helm upgrade --install webhooks funkypenguin/webhook-receiver -f my-custom-values.yaml
```

If you want to use an existing file, you can pass it in as follows

```sh
helm upgrade --install webhooks funkypenguin/webhook-receiver -f my-custom-values.yaml \
    --set-file hooks.myhoook.files./data/helloworld%sh=myfile.sh
```

This will load `myfile.sh` into the `/data/helloworld.sh` file.

Note that `%` is replaced by `.`, as it could be confused with the key selector.
Make sure you aren&#39;t overriding a key in your values files, unless it uses the same `%` notation.


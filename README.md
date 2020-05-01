# What is this?

A Helm chart for acting upon webhooks.

## How do I use it?

1. Install the repo:

```
helm repo add funkypenguins-geek-cookbook-k-rail https://funkypenguins-geek-cookbook.github.io/helm-webhook-receiver/
helm repo update
```

2. Install the chart:

```
helm install funkypenguin-geek-cookbook-k-rail/webhook-receiver
```

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
        echo "Hello World!"
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
Make sure you aren't overriding a key in your values files, unless it uses the same `%` notation.

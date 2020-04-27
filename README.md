# webhook-receiver

A Helm chart for acting upon webhooks.

## Usage

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
                echo "Hello World!"
        hook:
            id: helloworld
            execute-command: /data/helloworld.sh
```

Now you are ready to install this helm chart onto your kubernetes cluster.

```sh
helm upgrade --install webhooks funkypenguin/webhook-receiver -f my-custom-values.yaml
```
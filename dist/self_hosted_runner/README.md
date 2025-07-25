1. Build the container: ./build.sh
1. Run the container: ./run.sh
1. You should be INSIDE the container now with a prompt.
1. Follow the github instructions starting with:

```
# Create a folder
$ mkdir actions-runner && cd actions-runner# Download the latest runner package
$ curl -o actions-runner-linux-x64-2.327.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.327.0/actions-runner-linux-x64-2.327.0.tar.gzCopied!# Optional: Validate the hash
$ echo "697deac53b39b72396c6fe3fe3b10bdc05cf59c12e82295a2e6decc53ca7d3e4  actions-runner-linux-x64-2.327.0.tar.gz" | shasum -a 256 -c# Extract the installer
$ tar xzf ./actions-runner-linux-x64-2.327.0.tar.gz
```

And continue to the end of the steps found on GitHub's new runner setup page including ./config.sh and ./run.sh.



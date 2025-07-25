docker run -it --name github-runner \
  -e RUNNER_TOKEN=your_token \
  -e RUNNER_NAME=my-hosted-runner \
  -e RUNNER_REPO=https://github.com/100-Devs-1-Game/All-the-Incrementals \
  my-hosted-runner

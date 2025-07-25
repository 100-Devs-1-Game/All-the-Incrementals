mkdir runner
sudo chown 1000:1000 runner
docker run -it --name github-runner \
	-v "$PWD/runner:/home/runner" \
	github-runner

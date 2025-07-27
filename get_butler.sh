#!/usr/bin/bash

wget -O butler.zip https://broth.itch.ovh/butler/linux-amd64/LATEST/archive/default
unzip butler.zip

# GNU unzip tends to not set the executable bit even though it's set in the .zip
chmod +x ./butler

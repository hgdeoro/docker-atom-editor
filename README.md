# docker-atom-editor

Based on: https://github.com/jamesnetherton/docker-atom-editor

## Overview

Install and run the [Atom editor](https://atom.io/) from within a Docker container.

## Building the image

Clone this repository, change into the source directory and run:

```
make build
```

## Running Atom

```
make run MOUNT_DIRS="$HOME/projects /srv/projects"
```
Note that `docker run` will use `-v /dev/shm:/dev/shm` and can be
replaced by `--shm-size="<number><unit>"`
(at the moment, you'll have to update the `Makefile` to change that).

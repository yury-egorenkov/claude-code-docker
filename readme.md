https://egorsky.com

# Claude Code Docker

Quickly run Claude code in a container—minimal setup required.

## Prerequisites

- [Claude Code Cli](https://github.com/anthropics/claude-code)
- Docker
- Make

## Quick Start

```bash
# Build and run container with default config
make docker

# Run container in background
make docker.run.d

# Run container using a specific config folder
CONF=./conf/prod make docker.run
```

## Configuration

Environment variables are loaded automatically by the Makefile:

```makefile
CONF ?= .

-include .env.default.properties
-include $(CONF)/.env.properties
```

* `.env.default.properties` — defaults
* `.env.properties` — local overrides (create manually)
* You can specify a custom config folder with `CONF=./path/to/config`

## Useful Commands

```
make help          # list all commands
make docker.build  # build Docker image
make docker.run    # interactive run
make docker.run.d  # detached run
make docker.clean  # clean unused images
make docker.ls     # list images
```

## Customization

* Add scripts via `init-firewall.sh`
* Adjust container settings through `.env.properties`

> Claude code runs inside a container for safe, reproducible development.


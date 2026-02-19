https://egorsky.com

# Claude Code Docker

Run [Claude Code](https://github.com/anthropics/claude-code) in a sandboxed Docker container with network restrictions, persistent config, and batteries-included dev tooling.

## Why

Running an AI coding agent with full shell access on your host machine is a trust exercise. This project puts Claude Code inside a locked-down container where:

- **Claude state survives restarts** — credentials, project memory, conversation history, and settings are mounted from the host (`./node/`), so you can rebuild or restart the container without losing context.
- **Network egress is restricted** — only GitHub, npm, Anthropic APIs, and a handful of other services are reachable. Everything else is blocked by iptables.
- **Your host filesystem is isolated** — only the workspace directory you choose gets mounted.
- **The environment is reproducible** — same tools, same versions, every time.

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/)
- [Make](https://www.gnu.org/software/make/)
- An Anthropic API key (set via `.env.properties` or environment)

## Quick Start

```bash
# Build the image and run interactively
make docker

# Or run in the background
make docker.run.d
```

On startup the container launches Claude Code directly. A `cl` alias is also available in the shell for subsequent runs.

## What's in the Box

| Category | Tools |
|---|---|
| **Runtime** | Node.js 20, Go 1.24.4 |
| **AI** | Claude Code CLI (`@anthropic-ai/claude-code`) |
| **Shell** | Zsh with Oh My Zsh + Powerlevel10k, Bash |
| **Git** | Git, [delta](https://github.com/dandavison/delta) (better diffs), GitHub CLI (`gh`) |
| **Editors** | nano, vim |
| **DB** | PostgreSQL client (`psql`) |
| **Utilities** | jq, fzf, make, unzip, gow (Go watcher) |
| **Network** | iptables, ipset, dig, ping |

## Configuration

Environment variables are loaded in order by the Makefile:

```
.env.default.properties    # checked in — sensible defaults
.env.properties            # git-ignored — your local overrides
```

You can point to a different config folder:

```bash
CONF=./conf/prod make docker.run
```

### Key Variables

| Variable | Default | Description |
|---|---|---|
| `WORKSPACE` | `/workspace` | Container workspace path |
| `WORKSPACE_DIR` | *(empty)* | Host subdirectory to mount as the workspace |
| `DOCKER_LABEL` | `claude` | Docker image label for tagging |
| `ANTHROPIC_API_KEY` | — | Your Anthropic API key |
| `ANTHROPIC_BASE_URL` | — | Custom API endpoint (e.g. for proxies) |

Set secrets in `.env.properties` (never commit this file):

```properties
ANTHROPIC_API_KEY=sk-ant-...
```

## Network Firewall

The container runs an iptables-based firewall (`init-firewall.sh`) that **drops all outbound traffic by default** and only allows connections to:

- **GitHub** — API, web, and git protocol (IPs fetched dynamically from GitHub's `/meta` endpoint)
- **npm** — `registry.npmjs.org`
- **Anthropic** — `api.anthropic.com`, `statsig.anthropic.com`
- **VS Code** — marketplace and update servers
- **Other** — Sentry, Statsig, DNS (UDP 53), SSH (TCP 22), localhost, host network

The firewall self-verifies on startup: it confirms that `example.com` is unreachable and `api.github.com` is reachable. The container requires `NET_ADMIN` and `NET_RAW` capabilities.

## VS Code Dev Container

Open this repo in VS Code and select **Reopen in Container** to get a fully configured dev environment with:

- Claude Code, ESLint, Prettier, and GitLens extensions
- Format-on-save with Prettier
- Zsh as default terminal
- Persistent bash history and Claude config across rebuilds
- Firewall initialized automatically on start

See `devcontainer.json` for details.

## Multi-Project Workflow

Mount different project directories using the shortcut targets:

```bash
make back      # mounts ../back
make front     # mounts ../front
make docs      # mounts ../docs
make markups   # mounts ../markups
```

Or mount any directory:

```bash
WORKSPACE_DIR=../my-project make docker.run
```

## All Commands

```
make docker          # build + clean + run (default)
make docker.build    # build the image (tagged with git SHA)
make docker.run      # interactive run
make docker.run.d    # detached run
make docker.clean    # remove untagged project images
make docker.ls       # list project images
make help            # show all available commands
```

## License

[MIT](license.txt)

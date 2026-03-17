FROM golang:1.24-alpine

ARG LABEL
LABEL mylabel=${LABEL}

ARG TZ
ENV TZ="$TZ"

ENV COLORTERM=truecolor

ARG CLAUDE_CODE_VERSION=latest

RUN go install github.com/mitranim/gow@latest

# Install Node.js and packages
RUN apk add --no-cache \
  nodejs npm \
  bash less git procps sudo fzf jq vim make curl \
  iptables ipset iproute2 bind-tools \
  postgresql-client iputils github-cli gnupg

# Create non-root user (golang-alpine doesn't have 'node' user)
ARG USERNAME=node
RUN addgroup -S node && adduser -S -G node -h /home/node -s /bin/bash node

# Persist shell history
RUN mkdir -p /commandhistory && \
  touch /commandhistory/.shell_history && \
  chown -R $USERNAME /commandhistory

# Set `DEVCONTAINER` environment variable to help with orientation
ENV DEVCONTAINER=true

# Create workspace and config directories and set permissions
RUN mkdir -p /workspace /home/node/.claude && \
  chown -R node:node /workspace /home/node/.claude

WORKDIR /workspace

# Set up non-root user
USER node

# Claude Code native binary path
ENV PATH="/home/node/.local/bin:$PATH"

# Set the default shell to bash
ENV SHELL=/bin/bash

# Set the default editor
ENV EDITOR=vim
ENV VISUAL=vim

# Bash config
COPY .bashrc /home/node/.bashrc

# Install Claude Code (native installer)
RUN curl -fsSL https://claude.ai/install.sh | bash -s ${CLAUDE_CODE_VERSION}

# Copy and set up firewall script
COPY init-firewall.sh /usr/local/bin/

USER root

RUN chmod +x /usr/local/bin/init-firewall.sh && \
  echo "node ALL=(root) NOPASSWD: /usr/local/bin/init-firewall.sh" > /etc/sudoers.d/node-firewall && \
  chmod 0440 /etc/sudoers.d/node-firewall

USER node

CMD ["bash", "-c", "claude --dangerously-skip-permissions; exec /bin/bash"]

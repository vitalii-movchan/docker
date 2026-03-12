# Dockerfile

# Make container user
RUN addgroup --system --gid ${GROUP_ID} ${GROUP_NAME}
RUN adduser --system --shell /bin/sh --uid ${USER_ID} --ingroup ${GROUP_NAME} --disabled-password ${USER_NAME} --home /home/${USER_NAME}

# Install Client
RUN yes | apt-get install --no-install-recommends \
openssh-client

# Docker composer

application:
    build:
        context: .
        dockerfile: docker/php-cli/Dockerfile
    ssh:
        - default    # Forward the default SSH agent
    environment:
        SSH_AUTH_SOCK: "${SSH_AUTH_SOCK}"
    volumes:
        # Mount the socket file from the host into the container
        # ssh-add -l
        # ssh-add <path>
        # printenv SSH_AUTH_SOCK
        - ${SSH_HOST:-~/.ssh}:${SSH_DOCKER:-/home/centrobill/.ssh}:ro
        - ${SSH_AUTH_SOCK}:${SSH_AUTH_SOCK}
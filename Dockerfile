# Set base image
FROM mcr.microsoft.com/devcontainers/python:3.10-bullseye

# Settings
ARG USERNAME=exp
ARG USER_UID=1234
ARG USER_GID=$USER_UID
ARG WORK_DIR=/workspace

# Install Python packages
COPY requirements.txt /tmp/pip-tmp/
RUN pip3 --disable-pip-version-check --no-cache-dir install -r /tmp/pip-tmp/requirements.txt \
    && rm -rf /tmp/pip-tmp

# Install Quarto
ADD https://github.com/quarto-dev/quarto-cli/releases/download/v1.4.553/quarto-1.4.553-linux-amd64.deb .
RUN dpkg -i quarto-1.4.553-linux-amd64.deb

# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME
USER $USERNAME

# Set WORKDIR
WORKDIR $WORK_DIR

# Set default command
# CMD ["python3"]

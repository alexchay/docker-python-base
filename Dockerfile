ARG FROM_IMAGE_NAME="defval"
ARG FROM_IMAGE_TAG="defval"
FROM ${FROM_IMAGE_NAME}:${FROM_IMAGE_TAG}

LABEL maintainer="Alexander Chaykovskiy <alexchay@gmail.com>"

ENV DEBIAN_FRONTEND=noninteractive
ENV USERNAME=user

# add ca certificates
COPY *.crt /usr/local/share/ca-certificates/
RUN update-ca-certificates

# create local group and user & switch to
RUN \
    groupadd --gid 1010 $USERNAME && useradd --uid 1010 --gid 1010 -m -s /bin/bash $USERNAME \
    && export HOME=/home/$USERNAME \
    && chown -R :$USERNAME /usr/local/share/ca-certificates/

USER $USERNAME

# disable warnings when not verifying SSL certificate
ENV PYTHONWARNINGS="ignore:Unverified HTTPS request" \
    PYTHONFAULTHANDLER=1 \
    PYTHONBUFFERED=1 \
    PYTHONHASHSEED=random \
    PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_DEFAULT_TIMEOUT=100 \
    PYTHONPATH=/home/user/.local/lib/python*/site-packages/ \
    # make python requests use the system ca-certificates bundle
    REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt \
    HOME=/home/$USERNAME \
    PATH=/home/$USERNAME/.local/bin:$PATH

WORKDIR $HOME
# default command: display Python version
CMD [ "python", "--version" ]

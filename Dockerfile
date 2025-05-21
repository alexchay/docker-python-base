ARG BASE_IMAGE_NAME="defval"
ARG BASE_IMAGE_TAG="defval"
FROM ${BASE_IMAGE_NAME}:${BASE_IMAGE_TAG}

LABEL maintainer="Alexander Chaykovskiy <alexchay@gmail.com>"

ENV DEBIAN_FRONTEND=noninteractive
ENV USERNAME=appuser
ENV GROUPNAME=appgroup
ARG USER_UID=1010
ARG USER_GUD=${USER_UID}

# add ca certificates
COPY *.crt /usr/local/share/ca-certificates/
RUN update-ca-certificates

# create local group and user & switch to
RUN \
    groupadd --gid ${USER_GUD} ${GROUPNAME} \
    && useradd --uid ${USER_UID} --gid ${USER_GUD} -m -s /bin/bash ${USERNAME} \
    && export HOME=/home/$USERNAME \
    && chown -R :$GROUPNAME /usr/local/share/ca-certificates/

USER $USERNAME


ENV \
    # disable warnings when not verifying SSL certificate
    PYTHONWARNINGS="ignore:Unverified HTTPS request" \
    # easier to debug crashes by printing tracebacks on fatal errors
    PYTHONFAULTHANDLER=1 \
    # allow statements and log messages to immediately appear
    PYTHONUNBUFFERED=1 \
    PYTHONHASHSEED=random \
    # disable cache to reduce image size
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_DEFAULT_TIMEOUT=100 \
    # make python requests use the system ca-certificates bundle
    REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt \
    HOME=/home/$USERNAME \
    PATH=/home/$USERNAME/.local/bin:$PATH

WORKDIR $HOME
# default command: display Python version
CMD [ "python", "--version" ]

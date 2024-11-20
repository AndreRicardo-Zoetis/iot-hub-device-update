#ARG VARIANT=bookworm
ARG VARIANT=bullseye
FROM --platform=amd64 mcr.microsoft.com/devcontainers/base:${VARIANT}

#WORKDIR /iot-hub-device-update

ADD ./scripts/install-deps.sh /

RUN apt-get update

RUN /bin/bash /install-deps.sh -a --work-folder /iot-hub-device-update
#RUN /bin/bash /install-deps.sh --install-aduc-deps --install-do --install-cmake --install-shellcheck --work-folder /iot-hub-device-update

